import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group('RuleResult.ok', () {
    test('Valid with value, ok is true', () {
      final r = Rule.string(name: 'v').isRequired().parse('abc');
      expect(r.ok, isTrue);
    });

    test('Valid absent optional, ok is true', () {
      final r = Rule.string(name: 'v').parse('');
      expect(r.ok, isTrue);
    });

    test('Invalid, ok is false', () {
      final r = Rule.string(name: 'v').isRequired().parse('');
      expect(r.ok, isFalse);
    });
  });

  group('RuleResult.hasError', () {
    test('Valid, hasError is false', () {
      final r = Rule.string(name: 'v').parse('abc');
      expect(r.hasError, isFalse);
    });

    test('Invalid, hasError is true', () {
      final r = Rule.string(name: 'v').isRequired().parse('');
      expect(r.hasError, isTrue);
    });

    test('ok and hasError are always inverses', () {
      final r1 = Rule.integer(name: 'v').isRequired().parse(null);
      final r2 = Rule.integer(name: 'v').isRequired().parse(5);

      expect(r1.ok, equals(!r1.hasError));
      expect(r2.ok, equals(!r2.hasError));
    });
  });

  group('RuleResult.hasValidatedValue', () {
    test('string present and valid, true', () {
      expect(
        Rule.string(name: 'v').isRequired().parse('hello').hasValidatedValue,
        isTrue,
      );
    });

    test('string empty optional, false', () {
      expect(Rule.string(name: 'v').parse('').hasValidatedValue, isFalse);
    });

    test('string null optional, false', () {
      expect(Rule.string(name: 'v').parse(null).hasValidatedValue, isFalse);
    });

    test('string validation failed, false', () {
      expect(
        Rule.string(name: 'v').isEmail().parse('bad').hasValidatedValue,
        isFalse,
      );
    });

    test('integer present, true', () {
      expect(Rule.integer(name: 'v').parse(5).hasValidatedValue, isTrue);
    });

    test('integer zero, true', () {
      expect(Rule.integer(name: 'v').parse(0).hasValidatedValue, isTrue);
    });

    test('integer null optional, false', () {
      expect(Rule.integer(name: 'v').parse(null).hasValidatedValue, isFalse);
    });

    test('integer failed constraint, false', () {
      expect(
        Rule.integer(name: 'v').greaterThan(10).parse(1).hasValidatedValue,
        isFalse,
      );
    });

    test('double present, true', () {
      expect(Rule.double(name: 'v').parse(1.5).hasValidatedValue, isTrue);
    });

    test('double zero, true', () {
      expect(Rule.double(name: 'v').parse(0.0).hasValidatedValue, isTrue);
    });

    test('double null optional, false', () {
      expect(Rule.double(name: 'v').parse(null).hasValidatedValue, isFalse);
    });

    test('bool true, true', () {
      expect(Rule.boolean(name: 'v').parse(true).hasValidatedValue, isTrue);
    });

    test('bool false, true — false is a real value', () {
      expect(Rule.boolean(name: 'v').parse(false).hasValidatedValue, isTrue);
    });

    test('bool null optional, false', () {
      expect(Rule.boolean(name: 'v').parse(null).hasValidatedValue, isFalse);
    });
  });

  group('RuleResult.validatedValue', () {
    test('string present, returns value', () {
      expect(
        Rule.string(name: 'v').parse('hello').validatedValue,
        equals('hello'),
      );
    });

    test('string after trim, returns trimmed value', () {
      expect(
        Rule.string(name: 'v').trim().parse('  hello  ').validatedValue,
        equals('hello'),
      );
    });

    test('string after toLowerCase, returns lowered value', () {
      expect(
        Rule.string(name: 'v').toLowerCase().parse('HELLO').validatedValue,
        equals('hello'),
      );
    });

    test('string after toUpperCase, returns uppercased value', () {
      expect(
        Rule.string(name: 'v').toUpperCase().parse('hello').validatedValue,
        equals('HELLO'),
      );
    });

    test('string after trim + toLowerCase, returns clean value', () {
      expect(
        Rule.string(name: 'v')
            .trim()
            .toLowerCase()
            .parse('  HELLO  ')
            .validatedValue,
        equals('hello'),
      );
    });

    test('string empty optional, returns null', () {
      expect(Rule.string(name: 'v').parse('').validatedValue, isNull);
    });

    test('string null optional, returns null', () {
      expect(Rule.string(name: 'v').parse(null).validatedValue, isNull);
    });

    test('string spaces with trim, returns null', () {
      expect(Rule.string(name: 'v').trim().parse('   ').validatedValue, isNull);
    });

    test('string spaces without trim, returns spaces', () {
      expect(
        Rule.string(name: 'v').parse('   ').validatedValue,
        equals('   '),
      );
    });

    test('string validation failed, returns null', () {
      expect(
        Rule.string(name: 'v').isEmail().parse('bad').validatedValue,
        isNull,
      );
    });

    test('integer present, returns value', () {
      expect(Rule.integer(name: 'v').parse(42).validatedValue, equals(42));
    });

    test('integer zero, returns zero', () {
      expect(Rule.integer(name: 'v').parse(0).validatedValue, equals(0));
    });

    test('integer negative, returns negative value', () {
      expect(Rule.integer(name: 'v').parse(-5).validatedValue, equals(-5));
    });

    test('integer null optional, returns null', () {
      expect(Rule.integer(name: 'v').parse(null).validatedValue, isNull);
    });

    test('integer failed constraint, returns null', () {
      expect(
        Rule.integer(name: 'v').greaterThan(10).parse(1).validatedValue,
        isNull,
      );
    });

    test('double present, returns value', () {
      expect(
        Rule.double(name: 'v').parse(3.14).validatedValue,
        equals(3.14),
      );
    });

    test('double zero, returns zero', () {
      expect(Rule.double(name: 'v').parse(0.0).validatedValue, equals(0.0));
    });

    test('double negative, returns negative value', () {
      expect(
        Rule.double(name: 'v').parse(-1.5).validatedValue,
        equals(-1.5),
      );
    });

    test('double null optional, returns null', () {
      expect(Rule.double(name: 'v').parse(null).validatedValue, isNull);
    });

    test('double failed constraint, returns null', () {
      expect(
        Rule.double(name: 'v').greaterThan(0.0).parse(-1.0).validatedValue,
        isNull,
      );
    });

    test('bool true, returns true', () {
      expect(Rule.boolean(name: 'v').parse(true).validatedValue, isTrue);
    });

    test('bool false, returns false not null', () {
      expect(Rule.boolean(name: 'v').parse(false).validatedValue, isFalse);
    });

    test('bool null optional, returns null', () {
      expect(Rule.boolean(name: 'v').parse(null).validatedValue, isNull);
    });

    test('bool failed isTrue, returns null', () {
      expect(
        Rule.boolean(name: 'v').isTrue().parse(false).validatedValue,
        isNull,
      );
    });
  });

  group('RuleResult.error', () {
    test('Valid, error is null', () {
      expect(Rule.string(name: 'v').parse('abc').error, isNull);
    });

    test('Invalid, error is not null', () {
      expect(
        Rule.string(name: 'v').isRequired().parse('').error,
        isNotNull,
      );
    });

    test('error carries the field name', () {
      final error = Rule.string(name: 'MyField').isRequired().parse('').error;
      expect(error?.name, equals('MyField'));
    });

    test('error carries the message', () {
      final error = Rule.string(name: 'MyField').isRequired().parse('').error;
      expect(error?.message, equals('MyField is required'));
    });

    test('error carries the check', () {
      final error = Rule.string(name: 'v').isRequired().parse('').error;
      expect(error?.check, equals(StringCheck.isRequired));
    });

    test('error toString returns message', () {
      final error = Rule.string(name: 'v').isRequired().parse('').error;
      expect(error.toString(), equals('v is required'));
    });
  });

  group('RuleResult pattern matching', () {
    test('can switch on Valid and Invalid', () {
      final r = Rule.string(name: 'v').isRequired().parse('hello');
      final output = switch (r) {
        Valid(:final value) => 'valid: $value',
        Invalid(:final failure) => 'invalid: ${failure.message}',
      };
      expect(output, equals('valid: hello'));
    });

    test('can switch on Invalid', () {
      final r = Rule.string(name: 'v').isRequired().parse('');
      final output = switch (r) {
        Valid(:final value) => 'valid: $value',
        Invalid(:final failure) => 'invalid: ${failure.message}',
      };
      expect(output, equals('invalid: v is required'));
    });
  });
}
