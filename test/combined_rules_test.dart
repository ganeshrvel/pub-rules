import 'package:rules/rules.dart';
import 'package:rules/src/group_rules.dart';
import 'package:test/test.dart';

void main() {
  group('CombinedRules', () {
    test('should throw an error', () {
      final rule1 = Rules('', name: 'name', isRequired: true);
      final rule2 = Rules('', name: 'email', isRequired: true);
      final combinedRules = CombinedRules(rules: [rule1, rule2]);

      expect(combinedRules.hasError, equals(true));
      expect(combinedRules.errorList.length, 2);
    });

    test('should throw an error', () {
      final rule1 = Rules(
        '',
        name: 'name',
        isRequired: true,
      );
      final groupRule = GroupRules(
        [rule1],
        name: 'name',
        requiredAll: true,
      );
      final combinedRules = CombinedRules(
        groupRules: [groupRule],
      );

      expect(combinedRules.hasError, equals(true));
      expect(combinedRules.errorList.length, 1);
    });

    test('should throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: false);
      final groupRule = GroupRules([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group error');
      final combinedRules = CombinedRules(groupRules: [groupRule]);

      expect(combinedRules.errorList[0], contains('Group error'));
      expect(combinedRules.hasError, equals(true));
      expect(combinedRules.errorList.length, 1);
    });

    test('should throw an error', () {
      final rule1 = Rules('', name: 'name', isRequired: true);
      final groupRule = GroupRules([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group error');
      final combinedRules = CombinedRules(groupRules: [groupRule]);

      expect(combinedRules.errorList[0], contains('is required'));
      expect(combinedRules.hasError, equals(true));
      expect(combinedRules.errorList.length, 1);
    });

    test('should throw an error', () {
      final rule1 = Rules('', name: 'name', isRequired: true);
      final groupRule = GroupRules([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group error');
      final combinedRules =
          CombinedRules(rules: [rule1], groupRules: [groupRule]);

      expect(combinedRules.errorList[0], contains('is required'));
      expect(combinedRules.errorList[1], contains('is required'));
      expect(combinedRules.hasError, equals(true));
      expect(combinedRules.errorList.length, 2);
    });

    test('should throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: true);
      final groupRule = GroupRules([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group error');
      final combinedRules =
          CombinedRules(rules: [rule1], groupRules: [groupRule]);

      expect(combinedRules.errorList[0], contains('Group error'));
      expect(combinedRules.hasError, equals(true));
      expect(combinedRules.errorList.length, 1);
    });

    test('should throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: true);
      final groupRule1 = GroupRules([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group 1 error');

      final rule2 =
          Rules('abc', name: 'name', isRequired: true, isNumericDecimal: true);
      final rule3 = Rules('', name: 'value');
      final groupRule2 = GroupRules([rule2, rule3],
          name: 'name', requiredAtleast: 2, customErrorText: 'Group 2 error');

      final rule4 =
          Rules('abc', name: 'name', isRequired: true, isNumeric: true);
      final rule5 = Rules('abc', name: 'name', isRequired: true, isEmail: true);

      final combinedRules = CombinedRules(
          rules: [rule4, rule5], groupRules: [groupRule1, groupRule2]);

      expect(combinedRules.errorList[0], contains('is not a valid number'));
      expect(
          combinedRules.errorList[1], contains('is not a valid email address'));
      expect(combinedRules.errorList[2], contains('Group 1 error'));
      expect(combinedRules.errorList[3],
          contains('is not a valid decimal number'));
      expect(combinedRules.hasError, equals(true));
      expect(combinedRules.errorList.length, 4);
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('', name: 'name');
      final rule2 = Rules('', name: 'email');
      final combinedRules = CombinedRules(rules: [rule1, rule2]);

      expect(combinedRules.hasError, equals(false));
      expect(combinedRules.errorList.length, 0);
    });

    test('should NOT throw an error', () {
      final groupRule = GroupRules([], name: 'name', requiredAll: true);
      final combinedRules = CombinedRules(groupRules: [groupRule]);

      expect(combinedRules.hasError, equals(false));
      expect(combinedRules.errorList.length, 0);
    });

    test('should NOT throw an error', () {
      final rule1 = Rules('abc', name: 'name', isRequired: true);
      final groupRule1 = GroupRules([rule1],
          name: 'name', maxAllowed: 1, customErrorText: 'Group 1 error');

      final rule2 =
          Rules('1.1', name: 'name', isRequired: true, isNumericDecimal: true);
      final rule3 = Rules('abcd', name: 'value');
      final groupRule2 = GroupRules([rule2, rule3],
          name: 'name', requiredAtleast: 2, customErrorText: 'Group 2 error');

      final rule4 =
          Rules('10', name: 'name', isRequired: true, isNumeric: true);
      final rule5 =
          Rules('abc@xyz.com', name: 'name', isRequired: true, isEmail: true);

      final combinedRules = CombinedRules(
          rules: [rule4, rule5], groupRules: [groupRule1, groupRule2]);

      expect(combinedRules.hasError, equals(false));
      expect(combinedRules.errorList.length, 0);
    });

    test('should NOT throw an error', () {
      final combinedRules = CombinedRules();

      expect(combinedRules.hasError, equals(false));
      expect(combinedRules.errorList.length, 0);
    });
  });
}
