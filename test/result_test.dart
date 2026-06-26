import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group('RuleResult.ok', () {
    test('Valid with value, ok is true', () {
      final r = Rule.string(name: 'v').isRequired().validate('abc');
      expect(r.ok, isTrue);
    });

    test('Valid absent optional, ok is true', () {
      final r = Rule.string(name: 'v').validate('');
      expect(r.ok, isTrue);
    });

    test('Invalid, ok is false', () {
      final r = Rule.string(name: 'v').isRequired().validate('');
      expect(r.ok, isFalse);
    });
  });

  group('RuleResult.hasError', () {
    test('Valid, hasError is false', () {
      final r = Rule.string(name: 'v').validate('abc');
      expect(r.hasError, isFalse);
    });

    test('Invalid, hasError is true', () {
      final r = Rule.string(name: 'v').isRequired().validate('');
      expect(r.hasError, isTrue);
    });

    test('ok and hasError are always inverses', () {
      final r1 = Rule.integer(name: 'v').isRequired().validate(null);
      final r2 = Rule.integer(name: 'v').isRequired().validate(5);

      expect(r1.ok, equals(!r1.hasError));
      expect(r2.ok, equals(!r2.hasError));
    });
  });

  group('RuleResult.hasValidatedValue', () {
    test('string present and valid, true', () {
      expect(
        Rule.string(name: 'v').isRequired().validate('hello').hasValidatedValue,
        isTrue,
      );
    });

    test('string empty optional, false', () {
      expect(Rule.string(name: 'v').validate('').hasValidatedValue, isFalse);
    });

    test('string null optional, false', () {
      expect(Rule.string(name: 'v').validate(null).hasValidatedValue, isFalse);
    });

    test('string validation failed, false', () {
      expect(
        Rule.string(name: 'v').isEmail().validate('bad').hasValidatedValue,
        isFalse,
      );
    });

    test('integer present, true', () {
      expect(Rule.integer(name: 'v').validate(5).hasValidatedValue, isTrue);
    });

    test('integer zero, true', () {
      expect(Rule.integer(name: 'v').validate(0).hasValidatedValue, isTrue);
    });

    test('integer null optional, false', () {
      expect(Rule.integer(name: 'v').validate(null).hasValidatedValue, isFalse);
    });

    test('integer failed constraint, false', () {
      expect(
        Rule.integer(name: 'v').greaterThan(10).validate(1).hasValidatedValue,
        isFalse,
      );
    });

    test('double present, true', () {
      expect(Rule.double(name: 'v').validate(1.5).hasValidatedValue, isTrue);
    });

    test('double zero, true', () {
      expect(Rule.double(name: 'v').validate(0.0).hasValidatedValue, isTrue);
    });

    test('double null optional, false', () {
      expect(Rule.double(name: 'v').validate(null).hasValidatedValue, isFalse);
    });

    test('bool true, true', () {
      expect(Rule.boolean(name: 'v').validate(true).hasValidatedValue, isTrue);
    });

    test('bool false, true — false is a real value', () {
      expect(Rule.boolean(name: 'v').validate(false).hasValidatedValue, isTrue);
    });

    test('bool null optional, false', () {
      expect(Rule.boolean(name: 'v').validate(null).hasValidatedValue, isFalse);
    });
  });

  group('RuleResult.validatedValue', () {
    test('string present, returns value', () {
      expect(
        Rule.string(name: 'v').validate('hello').validatedValue,
        equals('hello'),
      );
    });

    test('string after trim, returns trimmed value', () {
      expect(
        Rule.string(name: 'v').trim().validate('  hello  ').validatedValue,
        equals('hello'),
      );
    });

    test('string after toLowerCase, returns lowered value', () {
      expect(
        Rule.string(name: 'v').toLowerCase().validate('HELLO').validatedValue,
        equals('hello'),
      );
    });

    test('string after toUpperCase, returns uppercased value', () {
      expect(
        Rule.string(name: 'v').toUpperCase().validate('hello').validatedValue,
        equals('HELLO'),
      );
    });

    test('string after trim + toLowerCase, returns clean value', () {
      expect(
        Rule.string(name: 'v')
            .trim()
            .toLowerCase()
            .validate('  HELLO  ')
            .validatedValue,
        equals('hello'),
      );
    });

    test('string empty optional, returns null', () {
      expect(Rule.string(name: 'v').validate('').validatedValue, isNull);
    });

    test('string null optional, returns null', () {
      expect(Rule.string(name: 'v').validate(null).validatedValue, isNull);
    });

    test('string spaces with trim, returns null', () {
      expect(
          Rule.string(name: 'v').trim().validate('   ').validatedValue, isNull);
    });

    test('string spaces without trim, returns spaces', () {
      expect(
        Rule.string(name: 'v').validate('   ').validatedValue,
        equals('   '),
      );
    });

    test('string validation failed, returns null', () {
      expect(
        Rule.string(name: 'v').isEmail().validate('bad').validatedValue,
        isNull,
      );
    });

    test('integer present, returns value', () {
      expect(Rule.integer(name: 'v').validate(42).validatedValue, equals(42));
    });

    test('integer zero, returns zero', () {
      expect(Rule.integer(name: 'v').validate(0).validatedValue, equals(0));
    });

    test('integer negative, returns negative value', () {
      expect(Rule.integer(name: 'v').validate(-5).validatedValue, equals(-5));
    });

    test('integer null optional, returns null', () {
      expect(Rule.integer(name: 'v').validate(null).validatedValue, isNull);
    });

    test('integer failed constraint, returns null', () {
      expect(
        Rule.integer(name: 'v').greaterThan(10).validate(1).validatedValue,
        isNull,
      );
    });

    test('double present, returns value', () {
      expect(
        Rule.double(name: 'v').validate(3.14).validatedValue,
        equals(3.14),
      );
    });

    test('double zero, returns zero', () {
      expect(Rule.double(name: 'v').validate(0.0).validatedValue, equals(0.0));
    });

    test('double negative, returns negative value', () {
      expect(
        Rule.double(name: 'v').validate(-1.5).validatedValue,
        equals(-1.5),
      );
    });

    test('double null optional, returns null', () {
      expect(Rule.double(name: 'v').validate(null).validatedValue, isNull);
    });

    test('double failed constraint, returns null', () {
      expect(
        Rule.double(name: 'v').greaterThan(0.0).validate(-1.0).validatedValue,
        isNull,
      );
    });

    test('bool true, returns true', () {
      expect(Rule.boolean(name: 'v').validate(true).validatedValue, isTrue);
    });

    test('bool false, returns false not null', () {
      expect(Rule.boolean(name: 'v').validate(false).validatedValue, isFalse);
    });

    test('bool null optional, returns null', () {
      expect(Rule.boolean(name: 'v').validate(null).validatedValue, isNull);
    });

    test('bool failed isTrue, returns null', () {
      expect(
        Rule.boolean(name: 'v').isTrue().validate(false).validatedValue,
        isNull,
      );
    });
  });

  group('RuleResult.error', () {
    test('Valid, error is null', () {
      expect(Rule.string(name: 'v').validate('abc').error, isNull);
    });

    test('Invalid, error is not null', () {
      expect(
        Rule.string(name: 'v').isRequired().validate('').error,
        isNotNull,
      );
    });

    test('error carries the field name', () {
      final error =
          Rule.string(name: 'MyField').isRequired().validate('').error;
      expect(error?.name, equals('MyField'));
    });

    test('error carries the message', () {
      final error =
          Rule.string(name: 'MyField').isRequired().validate('').error;
      expect(error?.message, equals('MyField is required'));
    });

    test('error carries the check', () {
      final error = Rule.string(name: 'v').isRequired().validate('').error;
      expect(error?.check, equals(StringCheck.isRequired));
    });

    test('error toString returns message', () {
      final error = Rule.string(name: 'v').isRequired().validate('').error;
      expect(error.toString(), equals('v is required'));
    });
  });

  group('RuleResult pattern matching', () {
    test('can switch on Valid and Invalid', () {
      final r = Rule.string(name: 'v').isRequired().validate('hello');
      final output = switch (r) {
        Valid(:final value) => 'valid: $value',
        Invalid(:final failure) => 'invalid: ${failure.message}',
      };
      expect(output, equals('valid: hello'));
    });

    test('can switch on Invalid', () {
      final r = Rule.string(name: 'v').isRequired().validate('');
      final output = switch (r) {
        Valid(:final value) => 'valid: $value',
        Invalid(:final failure) => 'invalid: ${failure.message}',
      };
      expect(output, equals('invalid: v is required'));
    });
  });
}
