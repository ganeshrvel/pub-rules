import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group('isRequired', () {
    test('null fails', () {
      final r = Rule.double(name: 'Price').isRequired().validate(null);
      expect(r.hasError, isTrue);
    });
    test('0.0 is present and passes', () {
      final r = Rule.double(name: 'Price').isRequired().validate(0.0);
      expect(r.ok, isTrue);
    });
    test('null optional passes', () {
      final r = Rule.double(name: 'Price').validate(null);
      expect(r.ok, isTrue);
    });
  });

  group('isInteger', () {
    test('whole-valued double passes', () {
      final r = Rule.double(name: 'v').isInteger().validate(5.0);
      expect(r.ok, isTrue);
    });
    test('fractional double fails', () {
      final r = Rule.double(name: 'v').isInteger().validate(5.5);
      expect(r.error?.message, contains('should be a whole number'));
    });
  });

  group('comparisons', () {
    test('greaterThan boundary fails', () {
      final r = Rule.double(name: 'v').greaterThan(1.0).validate(1.0);
      expect(r.error?.message, contains('should be greater than 1'));
    });
    test('greaterThanOrEqualTo boundary passes', () {
      final r = Rule.double(name: 'v').greaterThanOrEqualTo(5.0).validate(5.0);
      expect(r.ok, isTrue);
    });
    test('lessThanOrEqualTo boundary passes', () {
      final r = Rule.double(name: 'v').lessThanOrEqualTo(2.0).validate(2.0);
      expect(r.ok, isTrue);
    });
    test('equalTo treats 10.0 and 10 as equal', () {
      final r = Rule.double(name: 'v').equalTo(10.0).validate(10.0);
      expect(r.ok, isTrue);
    });
    test('notEqualTo match fails', () {
      final r = Rule.double(name: 'v').notEqualTo(10.0).validate(10.0);
      expect(r.error?.message, contains('should not be equal to 10'));
    });
    test('negative comparison passes', () {
      final r = Rule.double(name: 'v').lessThanOrEqualTo(-2.0).validate(-10.0);
      expect(r.ok, isTrue);
    });
  });

  group('lists', () {
    test('inList membership passes', () {
      final r = Rule.double(name: 'v').inList([1.0, 2.0]).validate(1.0);
      expect(r.ok, isTrue);
    });
    test('notInList membership fails', () {
      final r = Rule.double(name: 'v').notInList([-10.0]).validate(-10.0);
      expect(r.hasError, isTrue);
    });
  });

  group('check and refine', () {
    test('refine receives the typed double', () {
      final r = Rule.double(name: 'Price')
          .refine((v) => v < 0 ? 'negative {value}' : null)
          .validate(-3.5);
      expect(r.error?.message, equals('negative -3.5'));
    });
    test('check passes', () {
      final r = Rule.double(name: 'v').check((v) => v > 0).validate(1.0);
      expect(r.ok, isTrue);
    });
  });

  group('isRequired custom messages and ordering', () {
    test('custom required message overrides the default', () {
      final r = Rule.double(name: 'Price')
          .isRequired(error: 'Price is invalid.')
          .validate(null);
      expect(r.error?.message, equals('Price is invalid.'));
    });

    test('isRequired fires before isInteger', () {
      final r = Rule.double(name: 'v').isRequired().isInteger().validate(null);
      expect(r.error?.check, equals(DoubleCheck.isRequired));
    });

    test('isRequired fires before greaterThan', () {
      final r =
          Rule.double(name: 'v').isRequired().greaterThan(0.0).validate(null);
      expect(r.error?.check, equals(DoubleCheck.isRequired));
    });

    test('isRequired fires before refine', () {
      final r = Rule.double(name: 'v')
          .isRequired()
          .refine((v) => 'should not reach')
          .validate(null);
      expect(r.error?.check, equals(DoubleCheck.isRequired));
    });

    test('isRequired with custom error fires before isInteger', () {
      final r = Rule.double(name: 'Price')
          .isRequired(error: 'Enter a price')
          .isInteger()
          .validate(null);
      expect(r.error?.message, equals('Enter a price'));
    });
  });

  group('comparisons additional', () {
    test('lessThan passes', () {
      final r = Rule.double(name: 'v').lessThan(5.0).validate(1.0);
      expect(r.ok, isTrue);
    });

    test('lessThan boundary fails', () {
      final r = Rule.double(name: 'v').lessThan(1.0).validate(1.0);
      expect(r.error?.message, contains('should be less than 1'));
    });

    test('greaterThanOrEqualTo below boundary fails', () {
      final r = Rule.double(name: 'v').greaterThanOrEqualTo(5.0).validate(4.9);
      expect(
        r.error?.message,
        contains('should be greater than or equal to 5'),
      );
    });

    test('lessThanOrEqualTo above boundary fails', () {
      final r = Rule.double(name: 'v').lessThanOrEqualTo(2.0).validate(2.1);
      expect(r.error?.message, contains('should be less than or equal to 2'));
    });

    test('equalTo mismatch fails', () {
      final r = Rule.double(name: 'v').equalTo(10.0).validate(9.99);
      expect(r.error?.message, contains('should be equal to 10'));
    });

    test('notEqualTo differing values passes', () {
      final r = Rule.double(name: 'v').notEqualTo(10.0).validate(9.99);
      expect(r.ok, isTrue);
    });
  });

  group('lists additional', () {
    test('inList membership fails', () {
      final r = Rule.double(name: 'v').inList([1.0, 2.0]).validate(3.0);
      expect(
        r.error?.message,
        equals('v should be any of these values 1.0, 2.0'),
      );
    });

    test('notInList membership passes', () {
      final r = Rule.double(name: 'v').notInList([-10.0]).validate(5.0);
      expect(r.ok, isTrue);
    });
  });

  group('per-check error overrides', () {
    test('isInteger custom error', () {
      final r = Rule.double(name: 'v')
          .isInteger(error: 'Whole numbers only')
          .validate(5.5);
      expect(r.error?.message, equals('Whole numbers only'));
    });

    test('greaterThan custom error', () {
      final r = Rule.double(name: 'v')
          .greaterThan(1.0, error: 'Too low')
          .validate(1.0);
      expect(r.error?.message, equals('Too low'));
    });

    test('greaterThanOrEqualTo custom error', () {
      final r = Rule.double(name: 'v')
          .greaterThanOrEqualTo(5.0, error: 'Too low')
          .validate(4.0);
      expect(r.error?.message, equals('Too low'));
    });

    test('lessThan custom error', () {
      final r =
          Rule.double(name: 'v').lessThan(1.0, error: 'Too high').validate(1.0);
      expect(r.error?.message, equals('Too high'));
    });

    test('lessThanOrEqualTo custom error', () {
      final r = Rule.double(name: 'v')
          .lessThanOrEqualTo(2.0, error: 'Too high')
          .validate(2.1);
      expect(r.error?.message, equals('Too high'));
    });

    test('equalTo custom error', () {
      final r = Rule.double(name: 'v')
          .equalTo(10.0, error: 'Must be 10')
          .validate(9.0);
      expect(r.error?.message, equals('Must be 10'));
    });

    test('notEqualTo custom error', () {
      final r = Rule.double(name: 'v')
          .notEqualTo(10.0, error: 'Cannot be 10')
          .validate(10.0);
      expect(r.error?.message, equals('Cannot be 10'));
    });

    test('inList custom error', () {
      final r = Rule.double(name: 'v')
          .inList([1.0, 2.0], error: 'Pick 1.0 or 2.0').validate(3.0);
      expect(r.error?.message, equals('Pick 1.0 or 2.0'));
    });

    test('notInList custom error', () {
      final r = Rule.double(name: 'v')
          .notInList([-10.0], error: 'Cannot be -10').validate(-10.0);
      expect(r.error?.message, equals('Cannot be -10'));
    });

    test('check custom error', () {
      final r = Rule.double(name: 'v')
          .check((v) => v > 0, error: '{name} must be positive')
          .validate(-1.0);
      expect(r.error?.message, equals('v must be positive'));
    });
  });

  group('check and refine additional', () {
    test('check fails with default message', () {
      final r = Rule.double(name: 'v').check((v) => v > 2).validate(1.0);
      expect(r.error?.message, equals('v is invalid'));
    });

    test('check fires before refine', () {
      final r = Rule.double(name: 'v')
          .check((v) => false, error: 'check failed first')
          .refine((v) => 'should not reach')
          .validate(1.0);
      expect(r.error?.message, equals('check failed first'));
      expect(r.error?.check, equals(DoubleCheck.check));
    });

    test('refine fires after check passes', () {
      final r = Rule.double(name: 'v')
          .check((v) => true)
          .refine((v) => 'refine error')
          .validate(1.0);
      expect(r.error?.message, equals('refine error'));
      expect(r.error?.check, equals(DoubleCheck.refine));
    });

    test('refine returns null when value passes', () {
      final r = Rule.double(name: 'Price')
          .refine((v) => v < 0 ? 'negative {value}' : null)
          .validate(5.0);
      expect(r.ok, isTrue);
    });

    test('refine supports the name placeholder', () {
      final r = Rule.double(name: 'Price')
          .refine((v) => v < 0 ? '{name} cannot be negative' : null)
          .validate(-1.0);
      expect(r.error?.message, equals('Price cannot be negative'));
    });

    test('refine supports both name and value placeholders', () {
      final r = Rule.double(name: 'Price')
          .refine((v) => v < 0 ? '{name} was {value}' : null)
          .validate(-7.25);
      expect(r.error?.message, equals('Price was -7.25'));
    });

    test('refine is skipped for an absent optional value', () {
      final r = Rule.double(name: 'Price')
          .refine((v) => 'this should not be reached')
          .validate(null);
      expect(r.ok, isTrue);
    });

    test('refine does not run when isRequired already failed', () {
      final r = Rule.double(name: 'Price')
          .isRequired()
          .refine((v) => 'this should not be reached')
          .validate(null);
      expect(r.error?.check, equals(DoubleCheck.isRequired));
    });
  });

  group('validatedValue and hasValidatedValue', () {
    test('present value, hasValidatedValue true', () {
      final r = Rule.double(name: 'v').isRequired().validate(9.99);
      expect(r.hasValidatedValue, isTrue);
      expect(r.validatedValue, equals(9.99));
    });

    test('zero is present, hasValidatedValue true', () {
      final r = Rule.double(name: 'v').validate(0.0);
      expect(r.hasValidatedValue, isTrue);
      expect(r.validatedValue, equals(0.0));
    });

    test('null optional, hasValidatedValue false', () {
      final r = Rule.double(name: 'v').validate(null);
      expect(r.ok, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });

    test('failed validation, hasValidatedValue false', () {
      final r = Rule.double(name: 'v').isInteger().validate(5.5);
      expect(r.hasError, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });
  });
}
