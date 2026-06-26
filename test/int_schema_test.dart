import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group('isRequired', () {
    test('null fails', () {
      final r = Rule.integer(name: 'Age').isRequired().validate(null);
      expect(r.hasError, isTrue);
      expect(r.error?.message, equals('Age is required'));
    });
    test('zero is present and passes required', () {
      final r = Rule.integer(name: 'Age').isRequired().validate(0);
      expect(r.ok, isTrue);
    });
    test('null optional passes', () {
      final r = Rule.integer(name: 'Age').validate(null);
      expect(r.ok, isTrue);
    });
    test('custom required message', () {
      final r = Rule.integer(name: 'Age')
          .isRequired(error: 'Age is needed')
          .validate(null);
      expect(r.error?.message, equals('Age is needed'));
    });
  });

  group('comparisons', () {
    test('greaterThan boundary fails', () {
      final r = Rule.integer(name: 'v').greaterThan(1).validate(1);
      expect(r.error?.message, contains('should be greater than 1'));
    });
    test('greaterThan passes', () {
      final r = Rule.integer(name: 'v').greaterThan(1).validate(2);
      expect(r.ok, isTrue);
    });
    test('greaterThanOrEqualTo at boundary passes', () {
      final r = Rule.integer(name: 'v').greaterThanOrEqualTo(1).validate(1);
      expect(r.ok, isTrue);
    });
    test('lessThan boundary fails', () {
      final r = Rule.integer(name: 'v').lessThan(1).validate(1);
      expect(r.error?.message, contains('should be less than 1'));
    });
    test('lessThanOrEqualTo at boundary passes', () {
      final r = Rule.integer(name: 'v').lessThanOrEqualTo(0).validate(0);
      expect(r.ok, isTrue);
    });
    test('equalTo mismatch fails', () {
      final r = Rule.integer(name: 'v').equalTo(0).validate(1);
      expect(r.error?.message, contains('should be equal to 0'));
    });
    test('notEqualTo match fails', () {
      final r = Rule.integer(name: 'v').notEqualTo(0).validate(0);
      expect(r.error?.message, contains('should not be equal to 0'));
    });
    test('negative numbers compare correctly', () {
      final r = Rule.integer(name: 'v').greaterThan(-1).validate(0);
      expect(r.ok, isTrue);
    });
  });

  group('lists', () {
    test('inList membership fails', () {
      final r = Rule.integer(name: 'v').inList([0, 1, 2]).validate(10);
      expect(
        r.error?.message,
        contains('should be any of these values 0, 1, 2'),
      );
    });
    test('inList passes', () {
      final r = Rule.integer(name: 'v').inList([1, 2]).validate(1);
      expect(r.ok, isTrue);
    });
    test('notInList membership fails', () {
      final r = Rule.integer(name: 'v').notInList([0, 1, 2]).validate(1);
      expect(
        r.error?.message,
        contains('should not be any of these values 0, 1, 2'),
      );
    });
  });

  group('check and refine', () {
    test('check predicate', () {
      final r = Rule.integer(name: 'v')
          .check((v) => v.isEven, error: '{name} must be even')
          .validate(3);
      expect(r.error?.message, equals('v must be even'));
    });
    test('refine receives the typed int', () {
      final r = Rule.integer(name: 'Age')
          .refine((v) => v < 18 ? 'too young: {value}' : null)
          .validate(16);
      expect(r.error?.message, equals('too young: 16'));
    });
    test('refine null passes', () {
      final r = Rule.integer(name: 'Age')
          .refine((v) => v < 18 ? 'too young' : null)
          .validate(21);
      expect(r.ok, isTrue);
    });
  });

  group('ordering', () {
    test('first failing check wins', () {
      final r = Rule.integer(name: 'v').greaterThan(10).lessThan(5).validate(3);
      expect(r.error?.message, contains('should be greater than 10'));
      expect(r.error?.check, equals(IntCheck.greaterThan));
    });
  });

  group('isRequired ordering', () {
    test('isRequired fires before greaterThan', () {
      final r =
          Rule.integer(name: 'v').isRequired().greaterThan(0).validate(null);
      expect(r.error?.check, equals(IntCheck.isRequired));
    });

    test('isRequired fires before check', () {
      final r = Rule.integer(name: 'v')
          .isRequired()
          .check((v) => false, error: 'should not reach')
          .validate(null);
      expect(r.error?.check, equals(IntCheck.isRequired));
    });

    test('isRequired fires before refine', () {
      final r = Rule.integer(name: 'v')
          .isRequired()
          .refine((v) => 'should not reach')
          .validate(null);
      expect(r.error?.check, equals(IntCheck.isRequired));
    });

    test('isRequired with custom error fires before greaterThan', () {
      final r = Rule.integer(name: 'Age')
          .isRequired(error: 'Enter your age')
          .greaterThan(0)
          .validate(null);
      expect(r.error?.message, equals('Enter your age'));
    });
  });

  group('comparisons additional', () {
    test('lessThan passes', () {
      final r = Rule.integer(name: 'v').lessThan(5).validate(1);
      expect(r.ok, isTrue);
    });

    test('greaterThanOrEqualTo below boundary fails', () {
      final r = Rule.integer(name: 'v').greaterThanOrEqualTo(5).validate(4);
      expect(
        r.error?.message,
        contains('should be greater than or equal to 5'),
      );
    });

    test('lessThanOrEqualTo above boundary fails', () {
      final r = Rule.integer(name: 'v').lessThanOrEqualTo(0).validate(1);
      expect(r.error?.message, contains('should be less than or equal to 0'));
    });

    test('equalTo match passes', () {
      final r = Rule.integer(name: 'v').equalTo(5).validate(5);
      expect(r.ok, isTrue);
    });

    test('notEqualTo differing values passes', () {
      final r = Rule.integer(name: 'v').notEqualTo(0).validate(1);
      expect(r.ok, isTrue);
    });
  });

  group('lists additional', () {
    test('notInList membership passes', () {
      final r = Rule.integer(name: 'v').notInList([0, 1, 2]).validate(10);
      expect(r.ok, isTrue);
    });
  });

  group('per-check error overrides', () {
    test('greaterThan custom error', () {
      final r =
          Rule.integer(name: 'v').greaterThan(1, error: 'Too low').validate(1);
      expect(r.error?.message, equals('Too low'));
    });

    test('greaterThanOrEqualTo custom error', () {
      final r = Rule.integer(name: 'v')
          .greaterThanOrEqualTo(5, error: 'Too low')
          .validate(4);
      expect(r.error?.message, equals('Too low'));
    });

    test('lessThan custom error', () {
      final r =
          Rule.integer(name: 'v').lessThan(1, error: 'Too high').validate(1);
      expect(r.error?.message, equals('Too high'));
    });

    test('lessThanOrEqualTo custom error', () {
      final r = Rule.integer(name: 'v')
          .lessThanOrEqualTo(0, error: 'Too high')
          .validate(1);
      expect(r.error?.message, equals('Too high'));
    });

    test('equalTo custom error', () {
      final r =
          Rule.integer(name: 'v').equalTo(0, error: 'Must be zero').validate(1);
      expect(r.error?.message, equals('Must be zero'));
    });

    test('notEqualTo custom error', () {
      final r = Rule.integer(name: 'v')
          .notEqualTo(0, error: 'Cannot be zero')
          .validate(0);
      expect(r.error?.message, equals('Cannot be zero'));
    });

    test('inList custom error', () {
      final r = Rule.integer(name: 'v')
          .inList([1, 2], error: 'Pick 1 or 2').validate(3);
      expect(r.error?.message, equals('Pick 1 or 2'));
    });

    test('notInList custom error', () {
      final r = Rule.integer(name: 'v')
          .notInList([0], error: 'Cannot be 0').validate(0);
      expect(r.error?.message, equals('Cannot be 0'));
    });
  });

  group('check and refine additional', () {
    test('check fails with default message', () {
      final r = Rule.integer(name: 'v').check((v) => v > 2).validate(1);
      expect(r.error?.message, equals('v is invalid'));
    });

    test('check passes when predicate is true', () {
      final r = Rule.integer(name: 'v').check((v) => v.isEven).validate(4);
      expect(r.ok, isTrue);
    });

    test('check fires before refine', () {
      final r = Rule.integer(name: 'v')
          .check((v) => false, error: 'check failed first')
          .refine((v) => 'should not reach')
          .validate(1);
      expect(r.error?.message, equals('check failed first'));
      expect(r.error?.check, equals(IntCheck.check));
    });

    test('refine fires after check passes', () {
      final r = Rule.integer(name: 'v')
          .check((v) => true)
          .refine((v) => 'refine error')
          .validate(1);
      expect(r.error?.message, equals('refine error'));
      expect(r.error?.check, equals(IntCheck.refine));
    });

    test('refine supports the name placeholder', () {
      final r = Rule.integer(name: 'Age')
          .refine((v) => v < 18 ? '{name} is too young' : null)
          .validate(16);
      expect(r.error?.message, equals('Age is too young'));
    });

    test('refine supports both name and value placeholders', () {
      final r = Rule.integer(name: 'Age')
          .refine((v) => v < 18 ? '{name} is {value}, too young' : null)
          .validate(16);
      expect(r.error?.message, equals('Age is 16, too young'));
    });

    test('refine is skipped for an absent optional value', () {
      final r = Rule.integer(name: 'Age')
          .refine((v) => 'this should not be reached')
          .validate(null);
      expect(r.ok, isTrue);
    });

    test('refine does not run when isRequired already failed', () {
      final r = Rule.integer(name: 'Age')
          .isRequired()
          .refine((v) => 'this should not be reached')
          .validate(null);
      expect(r.error?.check, equals(IntCheck.isRequired));
    });
  });

  group('ordering additional', () {
    test('isRequired fires before lessThan', () {
      final r = Rule.integer(name: 'v').isRequired().lessThan(5).validate(null);
      expect(r.error?.check, equals(IntCheck.isRequired));
    });

    test('multiple checks, first failure wins', () {
      final r = Rule.integer(name: 'v')
          .check((v) => false, error: 'first')
          .check((v) => false, error: 'second')
          .validate(1);
      expect(r.error?.message, equals('first'));
    });

    test('multiple checks, first passes second fails', () {
      final r = Rule.integer(name: 'v')
          .check((v) => true, error: 'first')
          .check((v) => false, error: 'second')
          .validate(1);
      expect(r.error?.message, equals('second'));
    });
  });

  group('validatedValue and hasValidatedValue', () {
    test('present value, hasValidatedValue true', () {
      final r = Rule.integer(name: 'v').isRequired().validate(25);
      expect(r.hasValidatedValue, isTrue);
      expect(r.validatedValue, equals(25));
    });

    test('zero is present, hasValidatedValue true', () {
      final r = Rule.integer(name: 'v').validate(0);
      expect(r.hasValidatedValue, isTrue);
      expect(r.validatedValue, equals(0));
    });

    test('null optional, hasValidatedValue false', () {
      final r = Rule.integer(name: 'v').validate(null);
      expect(r.ok, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });

    test('failed validation, hasValidatedValue false', () {
      final r = Rule.integer(name: 'v').greaterThan(10).validate(1);
      expect(r.hasError, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });
  });
}
