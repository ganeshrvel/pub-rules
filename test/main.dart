import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group("'name' should not be left empty", () {
    test('should throw an error', () {
      try {
        final rule = Rules('', name: '');

        expect(rule, equals("'name' parameter is required"));
      } catch (e) {
        expect(e, equals("'name' parameter is required"));
      }
    });

    test('should NOT throw an error', () {
      final rule = Rules('', name: 'Name');

      expect(rule.hasError, equals(false));
    });
  });

  group('Only string can be input as the value', () {
    test('should throw an error', () {
      try {
        final rule = Rules(0, name: 'name');
      } catch (e) {
        expect(e, contains("data type isn't supported yet"));
      }
    });

    test('should NOT throw an error', () {
      final rule = Rules('', name: 'Name');

      expect(rule.hasError, equals(false));
    });
  });

  group('MultiRules', () {
    test('should throw an error', () {
      final rule1 = Rules('', name: 'name', isRequired: true);
      final rule2 = Rules('', name: 'email', isRequired: true);
      final multiRules = MultiRules([rule1, rule2]);

      expect(multiRules.hasError, equals(true));
      expect(multiRules.errorList.length, 2);
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('', name: 'name');
      final rule2 = Rules('', name: 'email');
      final multiRules = MultiRules([rule1, rule2]);

      expect(multiRules.hasError, equals(false));
      expect(multiRules.errorList.length, 0);
    });
  });

  group('isRequired', () {
    test('should throw an error', () {
      final rule = Rules('', name: 'name', isRequired: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rules('', name: 'name', isRequired: false);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rules('', name: 'name');

      expect(rule.hasError, equals(false));
    });
  });

  group('isNumeric', () {
    test('should throw an error', () {
      final rule = Rules('', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rules('qwerty123.', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rules('0.0', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rules('0', name: 'value', isNumeric: false);

      expect(rule.hasError, equals(false));
    });
  });
}
