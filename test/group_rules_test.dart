import 'package:rules/rules.dart';
import 'package:rules/src/group_rules.dart';
import 'package:test/test.dart';

void main() {
  group("'name' should not be left empty", () {
    test('should throw an error', () {
      try {
        final rule = Rules('', name: 'value');
        final groupRule = GroupRules([rule], name: '');

        expect(groupRule, contains("'name' parameter is required"));
      } catch (e) {
        expect(e, contains("'name' parameter is required"));
      }
    });

    test('should NOT throw an error', () {
      final rule = Rules('', name: 'Name');
      final groupRule = GroupRules([rule], name: 'group name');

      expect(groupRule.hasError, equals(false));
    });
  });

  group('Custom errors', () {
    test('should throw an error', () {
      final rule = Rules('',
          name: 'Name', isRequired: true, customErrorText: 'Name is invalid.');
      final groupRule = GroupRules([rule], name: 'group name');

      expect(groupRule.error, equals('Name is invalid.'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rules(
        '',
        name: 'Name',
        isRequired: true,
        customErrors: {'isRequired': 'Name is invalid.'},
      );
      final groupRule = GroupRules([rule], name: 'group name');

      expect(groupRule.error, equals('Name is invalid.'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rules(
        '',
        name: 'Name',
        isRequired: true,
        customErrorText: 'This is a master error',
        customErrors: {'isRequired': 'Name is invalid.'},
      );
      final groupRule = GroupRules([rule], name: 'group name');

      expect(groupRule.error, equals('This is a master error'));
      expect(groupRule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rules(
        '',
        name: 'Name',
        isRequired: false,
        customErrorText: 'This is a master error',
        customErrors: {'isRequired': 'Name is invalid.'},
      );
      final groupRule = GroupRules([rule], name: 'group name');

      expect(groupRule.hasError, equals(false));
    });
  });

  group("'name' should not be left empty", () {
    test('should throw an error', () {
      final rule = Rules('0', name: 'value', isEmail: true);
      final groupRule = GroupRules([rule], name: 'group name');

      expect(rule.error, contains('is not a valid email address'));
      expect(rule.hasError, equals(true));
      expect(groupRule.error, contains('is not a valid email address'));
      expect(groupRule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rules('abc@xyz.com', name: 'value', isEmail: true);
      final groupRule = GroupRules([rule], name: 'group name');

      expect(rule.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });
  });

  group('requiredAll', () {
    test('should throw an error', () {
      final rule = Rules('', name: 'name', isRequired: false);
      final groupRule =
          GroupRules([rule], name: 'group name', requiredAll: true);

      expect(rule.hasError, equals(false));
      expect(
          groupRule.error, contains('All fields are mandatory in group name'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rules('', name: 'name', isRequired: false);
      final rule2 = Rules(null, name: 'name', isRequired: false);
      final groupRule =
          GroupRules([rule1, rule2], name: 'group name', requiredAll: true);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(
          groupRule.error, contains('All fields are mandatory in group name'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rules('123', name: 'name', isRequired: false);
      final rule2 = Rules(null, name: 'name', isRequired: false);
      final groupRule =
          GroupRules([rule1, rule2], name: 'group name', requiredAll: true);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(
          groupRule.error, contains('All fields are mandatory in group name'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rules('', name: 'name', isRequired: false);
      final rule2 = Rules(null, name: 'name', isRequired: true);
      final groupRule =
          GroupRules([rule1, rule2], name: 'group name', requiredAll: true);

      expect(rule2.error, contains('is required'));
      expect(rule2.hasError, equals(true));
      expect(groupRule.error, contains('is required'));
      expect(groupRule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('', name: 'name');
      final rule2 = Rules(null, name: 'name');
      final groupRule =
          GroupRules([rule1, rule2], name: 'group name', requiredAll: false);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('', name: 'name');
      final rule2 = Rules(null, name: 'name');
      final groupRule = GroupRules([rule1, rule2], name: 'group name');

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });
  });

  group('requiredAtleast', () {
    test('should throw an error', () {
      try {
        final rule1 = Rules('', name: 'value');
        final rule2 = Rules('', name: 'value');
        final groupRule =
            GroupRules([rule1, rule2], name: 'group rules', requiredAtleast: 3);

        expect(
            groupRule,
            contains(
                "A minimum of 'requiredAtleast' number of (3) rules are required"));
      } catch (e) {
        expect(
            e,
            contains(
                "A minimum of 'requiredAtleast' number of (3) rules are required"));
      }
    });

    test('should throw an error', () {
      final rule1 = Rules('', name: 'name', isRequired: false);
      final rule2 = Rules(null, name: 'name', isRequired: false);
      final groupRule1 =
          GroupRules([rule1, rule2], name: 'group name', requiredAtleast: 1);
      final groupRule2 =
          GroupRules([rule1, rule2], name: 'group name', requiredAtleast: 2);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(groupRule1.error,
          contains('At least 1 field is required in group name'));
      expect(groupRule1.hasError, equals(true));
      expect(groupRule2.error,
          contains('At least 2 fields are required in group name'));
      expect(groupRule2.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('', name: 'value');
      final rule2 = Rules('', name: 'value');
      final groupRule =
          GroupRules([rule1, rule2], name: 'group rules', requiredAtleast: 0);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: false);
      final rule2 = Rules(null, name: 'name', isRequired: false);
      final groupRule =
          GroupRules([rule1, rule2], name: 'group name', requiredAtleast: 1);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: false);
      final rule2 = Rules('xyz', name: 'name', isRequired: false);
      final rule3 = Rules('123', name: 'name', isRequired: false);
      final groupRule = GroupRules([rule1, rule2, rule3],
          name: 'group name', requiredAtleast: 3);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(rule3.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('', name: 'name', isRequired: false);
      final rule2 = Rules('', name: 'name', isRequired: false);
      final rule3 = Rules('', name: 'name', isRequired: false);
      final groupRule1 = GroupRules([rule1, rule2, rule3],
          name: 'group name', requiredAtleast: 0);
      final groupRule2 = GroupRules([rule1, rule2, rule3], name: 'group name');

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(rule3.hasError, equals(false));
      expect(groupRule1.hasError, equals(false));
      expect(groupRule2.hasError, equals(false));
    });
  });

  group('maxAllowed', () {
    test('should throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: false);
      final rule2 = Rules('xyz', name: 'name', isRequired: false);
      final rule3 = Rules('123', name: 'name', isRequired: false);
      final groupRule1 =
          GroupRules([rule1, rule2], name: 'group name', maxAllowed: 1);
      final groupRule2 =
          GroupRules([rule1, rule2, rule3], name: 'group name', maxAllowed: 2);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(groupRule1.error,
          contains('A maximum of 1 field is allowed in group name'));
      expect(groupRule1.hasError, equals(true));
      expect(groupRule2.error,
          contains('A maximum of 2 fields are allowed in group name'));
      expect(groupRule2.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final groupRule = GroupRules([], name: 'group name', maxAllowed: 1);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: false);
      final groupRule1 = GroupRules([], name: 'group name', maxAllowed: 0);
      final groupRule2 = GroupRules([rule1], name: 'group name', maxAllowed: 0);

      expect(rule1.hasError, equals(false));
      expect(groupRule1.hasError, equals(false));
      expect(groupRule2.error,
          contains('A maximum of 0 fields are allowed in group name'));
      expect(groupRule2.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules(null, name: 'value');
      final rule2 = Rules('', name: 'value');
      final groupRule =
          GroupRules([rule1, rule2], name: 'group rules', maxAllowed: 1);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('1', name: 'value');
      final rule2 = Rules('2', name: 'value');
      final groupRule =
          GroupRules([rule1, rule2], name: 'group rules', maxAllowed: 2);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('1', name: 'value');
      final rule2 = Rules('2', name: 'value');
      final groupRule =
          GroupRules([rule1, rule2], name: 'group rules', maxAllowed: 3);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: true);
      final rule2 = Rules('xyz', name: 'name', isRequired: true);
      final rule3 = Rules('123', name: 'name', isRequired: true);
      final groupRule2 = GroupRules([rule1, rule2, rule3], name: 'group name');

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(rule3.hasError, equals(false));
      expect(groupRule2.hasError, equals(false));
    });
  });
}
