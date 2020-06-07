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
}
