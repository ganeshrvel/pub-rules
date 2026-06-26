import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group('isRequired', () {
    test('null fails', () {
      final r = Rule.boolean(name: 'Terms').isRequired().validate(null);
      expect(r.hasError, isTrue);
      expect(r.error?.message, equals('Terms is required'));
    });
    test('false is present and passes required', () {
      final r = Rule.boolean(name: 'Terms').isRequired().validate(false);
      expect(r.ok, isTrue);
    });
    test('null optional passes', () {
      final r = Rule.boolean(name: 'Terms').validate(null);
      expect(r.ok, isTrue);
    });
  });

  group('check placeholder support', () {
    test('check default message uses the name placeholder', () {
      final r = Rule.boolean(name: 'Flag').check((v) => false).validate(true);
      expect(r.error?.message, equals('Flag is invalid'));
    });

    test('check custom error supports the name placeholder', () {
      final r = Rule.boolean(name: 'Subscribed')
          .check((v) => false, error: '{name} is not allowed')
          .validate(true);
      expect(r.error?.message, equals('Subscribed is not allowed'));
    });

    test(
        'check custom error does not interpolate value (predicate has no value placeholder)',
        () {
      final r = Rule.boolean(name: 'Flag')
          .check((v) => false, error: 'Flag {value} is bad')
          .validate(true);
      expect(r.error?.message, equals('Flag true is bad'));
    });

    test(
        'check custom error substitutes the value placeholder with the bool itself',
        () {
      final r = Rule.boolean(name: 'Flag')
          .check((v) => false, error: '{name} was {value}')
          .validate(true);
      expect(r.error?.message, equals('Flag was true'));
    });
  });

  group('isTrue / isFalse', () {
    test('isTrue fails on false', () {
      final r = Rule.boolean(name: 'Terms').isTrue().validate(false);
      expect(r.error?.message, equals('Terms must be true'));
    });
    test('isTrue passes on true', () {
      final r = Rule.boolean(name: 'Terms').isTrue().validate(true);
      expect(r.ok, isTrue);
    });
    test('isFalse fails on true', () {
      final r = Rule.boolean(name: 'Hidden').isFalse().validate(true);
      expect(r.error?.message, equals('Hidden must be false'));
    });
    test('isFalse passes on false', () {
      final r = Rule.boolean(name: 'Hidden').isFalse().validate(false);
      expect(r.ok, isTrue);
    });
    test('custom isTrue message', () {
      final r = Rule.boolean(name: 'Terms')
          .isTrue(error: 'You must accept the terms')
          .validate(false);
      expect(r.error?.message, equals('You must accept the terms'));
    });
  });

  group('check and refine', () {
    test('check predicate', () {
      final r = Rule.boolean(name: 'Flag')
          // ignore: no_literal_bool_comparisons
          .check((v) => v == true, error: '{name} should be on')
          .validate(false);
      expect(r.error?.message, equals('Flag should be on'));
    });
    test('refine receives the typed bool', () {
      final r = Rule.boolean(name: 'Flag')
          .refine((v) => v ? null : 'flag is off')
          .validate(false);
      expect(r.error?.message, equals('flag is off'));
    });
    test('required fires before isTrue', () {
      final r =
          Rule.boolean(name: 'Terms').isRequired().isTrue().validate(null);
      expect(r.error?.message, equals('Terms is required'));
      expect(r.error?.check, equals(BoolCheck.isRequired));
    });
  });

  group('refine additional cases', () {
    test('refine returns null when value passes', () {
      final r = Rule.boolean(name: 'Flag')
          .refine((v) => v ? null : 'flag is off')
          .validate(true);
      expect(r.ok, isTrue);
    });

    test('refine supports the name placeholder', () {
      final r = Rule.boolean(name: 'Terms')
          .refine((v) => v ? null : '{name} must be accepted')
          .validate(false);
      expect(r.error?.message, equals('Terms must be accepted'));
    });

    test('refine supports the value placeholder', () {
      final r = Rule.boolean(name: 'Flag')
          .refine((v) => v ? null : 'got {value}')
          .validate(false);
      expect(r.error?.message, equals('got false'));
    });

    test('refine supports both name and value placeholders', () {
      final r = Rule.boolean(name: 'Subscribed')
          .refine((v) => v ? null : '{name} was {value}')
          .validate(false);
      expect(r.error?.message, equals('Subscribed was false'));
    });

    test('refine is skipped for an absent optional value', () {
      final r = Rule.boolean(name: 'Flag')
          .refine((v) => 'this should not be reached')
          .validate(null);
      expect(r.ok, isTrue);
    });

    test('refine fires after isRequired for a present value', () {
      final r = Rule.boolean(name: 'Terms')
          .isRequired()
          .refine((v) => v ? null : 'Terms must be true')
          .validate(false);
      expect(r.error?.message, equals('Terms must be true'));
      expect(r.error?.check, equals(BoolCheck.refine));
    });

    test('refine does not run when isRequired already failed', () {
      final r = Rule.boolean(name: 'Terms')
          .isRequired()
          .refine((v) => 'this should not be reached')
          .validate(null);
      expect(r.error?.check, equals(BoolCheck.isRequired));
    });

    test('check fires before refine', () {
      final r = Rule.boolean(name: 'Flag')
          .check((v) => false, error: 'check failed first')
          .refine((v) => 'this should not be reached')
          .validate(true);
      expect(r.error?.message, equals('check failed first'));
      expect(r.error?.check, equals(BoolCheck.check));
    });

    test('refine fires after check passes', () {
      final r = Rule.boolean(name: 'Flag')
          .check((v) => true)
          .refine((v) => v ? null : 'refine failed')
          .validate(false);
      expect(r.error?.message, equals('refine failed'));
      expect(r.error?.check, equals(BoolCheck.refine));
    });
  });

  group('equalTo', () {
    test('equalTo true passes on true', () {
      final r = Rule.boolean(name: 'Terms').equalTo(true).validate(true);
      expect(r.ok, isTrue);
    });

    test('equalTo true fails on false', () {
      final r = Rule.boolean(name: 'Terms').equalTo(true).validate(false);
      expect(r.error?.message, equals('Terms should be equal to true'));
      expect(r.error?.check, equals(BoolCheck.equalTo));
    });

    test('equalTo false passes on false', () {
      final r = Rule.boolean(name: 'Hidden').equalTo(false).validate(false);
      expect(r.ok, isTrue);
    });

    test('equalTo false fails on true', () {
      final r = Rule.boolean(name: 'Hidden').equalTo(false).validate(true);
      expect(r.error?.message, equals('Hidden should be equal to false'));
      expect(r.error?.check, equals(BoolCheck.equalTo));
    });

    test('custom equalTo message', () {
      final r = Rule.boolean(name: 'Terms')
          .equalTo(true, error: 'You must accept the terms')
          .validate(false);
      expect(r.error?.message, equals('You must accept the terms'));
    });

    test('equalTo is equivalent to isTrue', () {
      final viaEqualTo =
          Rule.boolean(name: 'Terms').equalTo(true).validate(false);
      final viaIsTrue = Rule.boolean(name: 'Terms').isTrue().validate(false);
      expect(viaEqualTo.ok, equals(viaIsTrue.ok));
    });

    test('equalTo is equivalent to isFalse', () {
      final viaEqualTo =
          Rule.boolean(name: 'Hidden').equalTo(false).validate(true);
      final viaIsFalse = Rule.boolean(name: 'Hidden').isFalse().validate(true);
      expect(viaEqualTo.ok, equals(viaIsFalse.ok));
    });

    test('required fires before equalTo', () {
      final r =
          Rule.boolean(name: 'Terms').isRequired().equalTo(true).validate(null);
      expect(r.error?.message, equals('Terms is required'));
      expect(r.error?.check, equals(BoolCheck.isRequired));
    });

    test('equalTo fires before refine', () {
      final r = Rule.boolean(name: 'Terms')
          .equalTo(true, error: 'equalTo failed first')
          .refine((v) => 'this should not be reached')
          .validate(false);
      expect(r.error?.message, equals('equalTo failed first'));
      expect(r.error?.check, equals(BoolCheck.equalTo));
    });

    test('refine fires after equalTo passes', () {
      final r = Rule.boolean(name: 'Terms')
          .equalTo(true)
          .refine((v) => v ? null : 'this should not be reached')
          .validate(true);
      expect(r.ok, isTrue);
    });

    test('equalTo custom error supports the value placeholder', () {
      final r = Rule.boolean(name: 'Terms')
          .equalTo(true, error: '{name} expected true but got {value}')
          .validate(false);
      expect(r.error?.message, equals('Terms expected true but got false'));
    });
  });
}
