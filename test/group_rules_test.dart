import 'package:rules/rules.dart';
import 'package:rules/src/group_rule.dart';
import 'package:test/test.dart';

void main() {
  group("'name' should not be left empty", () {
    test('should throw an error', () {
      try {
        final rule = Rule('', name: 'value');
        final groupRule = GroupRule([rule], name: '');

        expect(groupRule, contains("'name' parameter is required"));
      } catch (e) {
        expect(e, contains("'name' parameter is required"));
      }
    });

    test('should throw an error', () {
      Rule rule1;
      final rule2 = Rule('', name: 'name', isRequired: true);
      final groupRule = GroupRule([rule1, rule2], name: 'group name');

      expect(rule1?.hasError, equals(null));
      expect(groupRule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'Name');
      final groupRule = GroupRule([rule], name: 'group name');

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      Rule rule1;
      Rule rule2;
      final groupRule = GroupRule([rule1, rule2], name: 'group name');

      expect(rule1?.hasError, equals(null));
      expect(rule2?.hasError, equals(null));
      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      Rule rule1;
      final rule2 = Rule('abc', name: 'name', isRequired: true);
      final groupRule = GroupRule([rule1, rule2], name: 'group name');

      expect(rule1?.hasError, equals(null));
      expect(groupRule.hasError, equals(false));
    });
  });

  group('Custom errors', () {
    test('should throw an error', () {
      final rule = Rule('',
          name: 'Name', isRequired: true, customErrorText: 'Name is invalid.');
      final groupRule = GroupRule([rule], name: 'group name');

      expect(groupRule.error, equals('Name is invalid.'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        '',
        name: 'Name',
        isRequired: true,
        customErrors: {'isRequired': 'Name is invalid.'},
      );
      final groupRule = GroupRule([rule], name: 'group name');

      expect(groupRule.error, equals('Name is invalid.'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        '',
        name: 'Name',
        isRequired: true,
        customErrorText: 'This is a master error',
        customErrors: {
          'isRequired': 'Name is invalid.',
        },
      );
      final groupRule = GroupRule([rule], name: 'group name');

      expect(groupRule.error, equals('Name is invalid.'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        '',
        name: 'Email',
        isRequired: true,
        isEmail: true,
        customErrorText: 'This is a master error',
        customErrors: {
          'isEmail': 'Email is invalid.',
        },
      );
      final groupRule = GroupRule([rule], name: 'group name');

      expect(groupRule.error, equals('This is a master error'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        '',
        name: 'Email',
        isRequired: true,
        customErrorText: 'This is a master error',
        customErrors: {
          'isEmail': 'Email is invalid.',
        },
      );
      final groupRule = GroupRule([rule], name: 'group name');

      expect(groupRule.error, equals('This is a master error'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        'abc',
        name: 'Name',
        isRequired: true,
        customErrorText: 'This is a master error',
        customErrors: {
          'isRequired': 'Name is invalid.',
        },
      );
      final groupRule = GroupRule(
        [rule],
        name: 'group name',
        maxAllowed: 0,
        customErrorText: 'This is a master group error',
      );

      expect(groupRule.error, equals('This is a master group error'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        'abc',
        name: 'Name',
        isRequired: true,
        customErrorText: 'This is a master error',
        customErrors: {
          'isRequired': 'Name is invalid.',
        },
      );
      final groupRule = GroupRule(
        [rule],
        name: 'group name',
        maxAllowed: 0,
        customErrorText: 'This is a master group error',
        customErrors: {
          'maxAllowed': 'Group input is invalid.',
        },
      );

      expect(groupRule.error, equals('Group input is invalid.'));
      expect(groupRule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule(
        '',
        name: 'Name',
        isRequired: false,
        customErrorText: 'This is a master error',
        customErrors: {'isRequired': 'Name is invalid.'},
      );
      final groupRule = GroupRule([rule], name: 'group name');

      expect(groupRule.hasError, equals(false));
    });
  });

  group("'name' should not be left empty", () {
    test('should throw an error', () {
      final rule = Rule('0', name: 'value', isEmail: true);
      final groupRule = GroupRule(
        [rule],
        name: 'group name',
      );

      expect(rule.error, contains('is not a valid email address'));
      expect(rule.hasError, equals(true));
      expect(groupRule.error, contains('is not a valid email address'));
      expect(groupRule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc@xyz.com', name: 'value', isEmail: true);
      final groupRule = GroupRule([rule], name: 'group name');

      expect(rule.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });
  });

  group('requiredAll', () {
    test('should throw an error', () {
      final rule = Rule('', name: 'name', isRequired: false);
      final groupRule =
          GroupRule([rule], name: 'group name', requiredAll: true);

      expect(rule.hasError, equals(false));
      expect(
          groupRule.error, contains('All fields are mandatory in group name'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule('', name: 'name', isRequired: false);
      final rule2 = Rule(null, name: 'name', isRequired: false);
      final groupRule =
          GroupRule([rule1, rule2], name: 'group name', requiredAll: true);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(
          groupRule.error, contains('All fields are mandatory in group name'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule('123', name: 'name', isRequired: false);
      final rule2 = Rule(null, name: 'name', isRequired: false);
      final groupRule =
          GroupRule([rule1, rule2], name: 'group name', requiredAll: true);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(
          groupRule.error, contains('All fields are mandatory in group name'));
      expect(groupRule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule('', name: 'name', isRequired: false);
      final rule2 = Rule(null, name: 'name', isRequired: true);
      final groupRule =
          GroupRule([rule1, rule2], name: 'group name', requiredAll: true);

      expect(rule2.error, contains('is required'));
      expect(rule2.hasError, equals(true));
      expect(groupRule.error, contains('is required'));
      expect(groupRule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('', name: 'name');
      final rule2 = Rule(null, name: 'name');
      final groupRule =
          GroupRule([rule1, rule2], name: 'group name', requiredAll: false);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final groupRule = GroupRule([], name: 'group name', requiredAll: true);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('', name: 'name');
      final rule2 = Rule(null, name: 'name');
      final groupRule = GroupRule([rule1, rule2], name: 'group name');

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });
  });

  group('requiredAtleast', () {
    test('should throw an error', () {
      try {
        final rule1 = Rule('', name: 'value');
        final rule2 = Rule('', name: 'value');
        final groupRule =
            GroupRule([rule1, rule2], name: 'group rule', requiredAtleast: 3);

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
      final rule1 = Rule('', name: 'name', isRequired: false);
      final rule2 = Rule(null, name: 'name', isRequired: false);
      final groupRule1 =
          GroupRule([rule1, rule2], name: 'group name', requiredAtleast: 1);
      final groupRule2 =
          GroupRule([rule1, rule2], name: 'group name', requiredAtleast: 2);

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
      final rule1 = Rule('', name: 'value');
      final rule2 = Rule('', name: 'value');
      final groupRule =
          GroupRule([rule1, rule2], name: 'group rule', requiredAtleast: 0);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: false);
      final rule2 = Rule(null, name: 'name', isRequired: false);
      final groupRule =
          GroupRule([rule1, rule2], name: 'group name', requiredAtleast: 1);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: false);
      final rule2 = Rule('xyz', name: 'name', isRequired: false);
      final rule3 = Rule('123', name: 'name', isRequired: false);
      final groupRule = GroupRule([rule1, rule2, rule3],
          name: 'group name', requiredAtleast: 3);

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(rule3.hasError, equals(false));
      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('', name: 'name', isRequired: false);
      final rule2 = Rule('', name: 'name', isRequired: false);
      final rule3 = Rule('', name: 'name', isRequired: false);
      final groupRule1 = GroupRule([rule1, rule2, rule3],
          name: 'group name', requiredAtleast: 0);
      final groupRule2 = GroupRule([rule1, rule2, rule3], name: 'group name');

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(rule3.hasError, equals(false));
      expect(groupRule1.hasError, equals(false));
      expect(groupRule2.hasError, equals(false));
    });
  });

  group('maxAllowed', () {
    test('should throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: false);
      final rule2 = Rule('xyz', name: 'name', isRequired: false);
      final rule3 = Rule('123', name: 'name', isRequired: false);
      final groupRule1 =
          GroupRule([rule1, rule2], name: 'group name', maxAllowed: 1);
      final groupRule2 =
          GroupRule([rule1, rule2, rule3], name: 'group name', maxAllowed: 2);

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
      final groupRule = GroupRule([], name: 'group name', maxAllowed: 1);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: false);
      final groupRule1 = GroupRule([], name: 'group name', maxAllowed: 0);
      final groupRule2 = GroupRule([rule1], name: 'group name', maxAllowed: 0);

      expect(rule1.hasError, equals(false));
      expect(groupRule1.hasError, equals(false));
      expect(groupRule2.error,
          contains('A maximum of 0 fields are allowed in group name'));
      expect(groupRule2.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule(null, name: 'value');
      final rule2 = Rule('', name: 'value');
      final groupRule =
          GroupRule([rule1, rule2], name: 'group rule', maxAllowed: 1);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('1', name: 'value');
      final rule2 = Rule('2', name: 'value');
      final groupRule =
          GroupRule([rule1, rule2], name: 'group rule', maxAllowed: 2);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('1', name: 'value');
      final rule2 = Rule('2', name: 'value');
      final groupRule =
          GroupRule([rule1, rule2], name: 'group rule', maxAllowed: 3);

      expect(groupRule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: true);
      final rule2 = Rule('xyz', name: 'name', isRequired: true);
      final rule3 = Rule('123', name: 'name', isRequired: true);
      final groupRule2 = GroupRule([rule1, rule2, rule3], name: 'group name');

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
      expect(rule3.hasError, equals(false));
      expect(groupRule2.hasError, equals(false));
    });
  });

  group('copyWith', () {
    test('should throw an error', () {
      final rule1 = Rule(
        'qwerty123',
        name: 'value',
        shouldNotMatch: 'qwerty123',
      );
      final rule2 = Rule(
        '',
        name: 'value',
      );
      final groupRule1 = GroupRule([rule1, rule2], name: 'group name');
      final groupRule2 = groupRule1.copyWith(requiredAll: true);

      expect(groupRule1.hasError, equals(true));
      expect(groupRule2.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        'qwerty123',
        name: 'value',
        shouldNotMatch: 'xyz',
      );
      final rule2 = rule1.copyWith(name: 'value', shouldMatch: 'abc');
      final groupRule1 = GroupRule([rule1, rule2], name: 'group name');
      final groupRule2 = groupRule1.copyWith(requiredAll: true);

      expect(groupRule1.error, contains('should be same as'));
      expect(groupRule1.hasError, equals(true));
      expect(groupRule2.error, contains('value should be same as abc'));
      expect(groupRule2.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '',
        name: 'value',
        shouldNotMatch: 'xyz',
      );
      final rule2 = rule1.copyWith(name: 'value', shouldMatch: 'abc');
      final groupRule1 = GroupRule([rule1, rule2], name: 'group name');
      final groupRule2 = groupRule1.copyWith(requiredAll: true);

      expect(groupRule1.hasError, equals(false));
      expect(
          groupRule2.error, contains('All fields are mandatory in group name'));
      expect(groupRule2.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '',
        name: 'value',
        shouldNotMatch: 'xyz',
      );
      final rule2 = rule1.copyWith(name: 'value', shouldMatch: 'abc');
      final groupRule1 = GroupRule([rule1, rule2], name: 'group name');
      final groupRule2 =
          groupRule1.copyWith(requiredAll: true, name: 'group name 2');

      expect(groupRule1.hasError, equals(false));
      expect(groupRule2.error,
          contains('All fields are mandatory in group name 2'));
      expect(groupRule2.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        'abc',
        name: 'value',
        shouldNotMatch: 'xyz',
      );
      final rule2 = rule1.copyWith(name: 'value', shouldMatch: 'abc');
      final groupRule1 = GroupRule([rule1, rule2], name: 'group name');
      final groupRule2 =
          groupRule1.copyWith(requiredAll: true, name: 'group name 2');

      expect(groupRule1.hasError, equals(false));
      expect(groupRule2.hasError, equals(false));
    });
  });
}
