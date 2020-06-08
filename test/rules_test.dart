import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group("'name' should not be left empty", () {
    test('should throw an error', () {
      try {
        final rule = Rule('', name: '');

        expect(rule, contains("'name' parameter is required"));
      } catch (e) {
        expect(e, contains("'name' parameter is required"));
      }
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'Name');

      expect(rule.hasError, equals(false));
    });
  });

  group('Custom errors', () {
    test('should throw an error', () {
      final rule = Rule('',
          name: 'Name', isRequired: true, customErrorText: 'Name is invalid.');

      expect(rule.error, equals('Name is invalid.'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        '',
        name: 'Name',
        isRequired: true,
        customErrors: {'isRequired': 'Name is invalid.'},
      );

      expect(rule.error, equals('Name is invalid.'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        '',
        name: 'Name',
        isRequired: true,
        customErrorText: 'This is a master error',
        customErrors: {'isRequired': 'Name is invalid.'},
      );

      expect(rule.error, equals('This is a master error'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule(
        '',
        name: 'Name',
        isRequired: false,
        customErrorText: 'This is a master error',
        customErrors: {'isRequired': 'Name is invalid.'},
      );

      expect(rule.hasError, equals(false));
    });
  });

  group('isRequired', () {
    test('should throw an error', () {
      final rule = Rule('', name: 'name', isRequired: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(null, name: 'name', isRequired: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'name', isRequired: false);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'name');

      expect(rule.hasError, equals(false));
    });
  });

  group('isEmail', () {
    test('should throw an error', () {
      final rule = Rule('0', name: 'value', isNumeric: true, isEmail: true);

      expect(rule.error, contains('is not a valid email address'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('qwerty123.', name: 'value', isEmail: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('abc@xyz', name: 'value', isEmail: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isEmail: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isEmail: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc@xyz.com', name: 'value', isEmail: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc@xyz', name: 'value', isEmail: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('isPhone', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123', name: 'value', isPhone: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('+1234', name: 'value', isPhone: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isPhone: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isPhone: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('+918989797891', name: 'value', isPhone: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('08989797891', name: 'value', isPhone: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('+65898979789', name: 'value', isPhone: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('+1 (234) 56-89 901', name: 'value', isPhone: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('+65 (898) 979 789', name: 'value', isPhone: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('+', name: 'value', isPhone: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('isUrl', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123', name: 'value', isUrl: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('www.com', name: 'value', isUrl: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('www.x.co', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('www.x.co/', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('www.google.com', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('https://www.google.com', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('http://google.uk', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('http://www.google.co.in/404', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('http://www.google.co.in/404.html', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('http://google.jp', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('https://www.google.gr', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('http://www.google.fr', name: 'value', isUrl: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('+', name: 'value', isUrl: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('isIp', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123', name: 'value', isIp: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('255.255.255.256', name: 'value', isIp: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('30.168.1.255.1', name: 'value', isIp: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('192.168.1.256', name: 'value', isIp: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1.1.1.1.', name: 'value', isIp: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('192.168.1.255', name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('192.168.1.255', name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('21DA:D3:0:2F3B:2AA:FF:FE28:9C5A', name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('1200:0000:AB00:1234:0000:2552:7777:1313',
          name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('255.255.255.255', name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('127.0.0.1', name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('0.0.0.0', name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('2001:db8::a:74e6:b5f3:fe92:830e', name: 'value', isIp: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('+', name: 'value', isIp: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('isNumeric', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123.', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0.0', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('--1', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1-1', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('0', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-1', name: 'value', isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('0', name: 'value', isNumeric: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('isNumericDecimal', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123.', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('.', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('..', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0.', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0.0.0', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('--1', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1-1', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('0.0', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('0', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-1.0', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-1', name: 'value', isNumericDecimal: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('0', name: 'value', isNumericDecimal: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('isAlphaSpace', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123', name: 'value', isAlphaSpace: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1234', name: 'value', isAlphaSpace: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isAlphaSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isAlphaSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc xyz', name: 'value', isAlphaSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc', name: 'value', isAlphaSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc.xyz', name: 'value', isAlphaSpace: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('isAlphaNumeric', () {
    test('should throw an error', () {
      final rule = Rule('qwerty 123', name: 'value', isAlphaNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('.', name: 'value', isAlphaNumeric: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isAlphaNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isAlphaNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abcxyz', name: 'value', isAlphaNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc123', name: 'value', isAlphaNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc.xyz', name: 'value', isAlphaNumeric: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('isAlphaNumericSpace', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', isAlphaNumericSpace: true);

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', isAlphaNumericSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', isAlphaNumericSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc xyz', name: 'value', isAlphaNumericSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc123', name: 'value', isAlphaNumericSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc 123', name: 'value', isAlphaNumericSpace: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc.xyz', name: 'value', isAlphaNumericSpace: false);

      expect(rule.hasError, equals(false));
    });
  });

  group('length', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123', name: 'value', length: 3);

      expect(rule.error, contains('should be 3 characters long'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', length: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', length: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc xyz', name: 'value', length: 7);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', length: 0);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', length: 0);

      expect(rule.hasError, equals(false));
    });
  });

  group('minLength', () {
    test('should throw an error', () {
      final rule = Rule('13', name: 'value', minLength: 3);

      expect(rule.error, contains('should contain at least 3 characters'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc xyz', name: 'value', minLength: 7);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', minLength: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', minLength: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', minLength: 0);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', minLength: 0);

      expect(rule.hasError, equals(false));
    });
  });

  group('maxLength', () {
    test('should throw an error', () {
      final rule = Rule('abc', name: 'value', maxLength: 1);

      expect(rule.error, contains('should not exceed more than 1 characters'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', maxLength: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', maxLength: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc', name: 'value', maxLength: 7);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc xyz', name: 'value', maxLength: 7);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', maxLength: 0);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', maxLength: 0);

      expect(rule.hasError, equals(false));
    });
  });

  group('regex', () {
    test('should throw an error', () {
      final rule = Rule('123.', name: 'value', regex: r'^[a-zA-Z0-9\s]+$');

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', regex: r'^[a-zA-Z0-9\s]+$');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', regex: r'^[a-zA-Z0-9\s]+$');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc123', name: 'value', regex: r'^[a-zA-Z0-9\s]+$');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc xyz', name: 'value', regex: r'^[a-zA-Z0-9\s]+$');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value');

      expect(rule.hasError, equals(false));
    });
  });

  group('greaterThan', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', greaterThan: 8);

      expect(rule.error, contains('not a valid decimal number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0.0', name: 'value', greaterThan: 8);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0', name: 'value', greaterThan: 8);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0.0', name: 'value', greaterThan: 8, isNumeric: true);

      expect(rule.error, contains('not a valid number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0', name: 'value', greaterThan: 1, isNumeric: true);

      expect(rule.error, contains('should be greater than 1'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1', name: 'value', greaterThan: 1, isNumeric: true);

      expect(rule.error, contains('should be greater than 1'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', greaterThan: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', greaterThan: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('2', name: 'value', greaterThan: 1, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-0.9', name: 'value', greaterThan: -1);

      expect(rule.hasError, equals(false));
    });
  });

  group('greaterThanEqualTo', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', greaterThanEqualTo: 8);

      expect(rule.error, contains('not a valid decimal number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0.0', name: 'value', greaterThanEqualTo: 8);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0', name: 'value', greaterThanEqualTo: 8);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('0.0', name: 'value', greaterThanEqualTo: 8, isNumeric: true);

      expect(rule.error, contains('not a valid number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('0', name: 'value', greaterThanEqualTo: 1, isNumeric: true);

      expect(rule.error, contains('should be greater than or equal to 1'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', greaterThanEqualTo: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', greaterThanEqualTo: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('1', name: 'value', greaterThanEqualTo: 1, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('2', name: 'value', greaterThanEqualTo: 1, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('-2', name: 'value', greaterThanEqualTo: -2, isNumeric: true);

      expect(rule.hasError, equals(false));
    });
  });

  group('lessThan', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', lessThan: 8);

      expect(rule.error, contains('not a valid decimal number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8.0', name: 'value', lessThan: 0);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8', name: 'value', lessThan: 0);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8.0', name: 'value', lessThan: 0.0, isNumeric: true);

      expect(rule.error, contains('not a valid number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1', name: 'value', lessThan: 0, isNumeric: true);

      expect(rule.error, contains('should be less than 0'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1', name: 'value', lessThan: 1, isNumeric: true);

      expect(rule.error, contains('should be less than 1'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', lessThan: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', lessThan: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('1', name: 'value', lessThan: 2, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-2', name: 'value', lessThan: -1, isNumeric: true);

      expect(rule.hasError, equals(false));
    });
  });

  group('lessThanEqualTo', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', lessThanEqualTo: 8);

      expect(rule.error, contains('not a valid decimal number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8.0', name: 'value', lessThanEqualTo: 0);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8', name: 'value', lessThanEqualTo: 0);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('8.0', name: 'value', lessThanEqualTo: 0, isNumeric: true);

      expect(rule.error, contains('not a valid number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('1', name: 'value', lessThanEqualTo: 0, isNumeric: true);

      expect(rule.error, contains('should be less than or equal to 0'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', lessThanEqualTo: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', lessThanEqualTo: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('1', name: 'value', lessThanEqualTo: 1, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('1', name: 'value', lessThanEqualTo: 2.0, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('-10', name: 'value', lessThanEqualTo: -2.0, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-2.0', name: 'value', lessThanEqualTo: -2.0);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('-1', name: 'value', lessThanEqualTo: 2.0, isNumeric: true);

      expect(rule.hasError, equals(false));
    });
  });

  group('equalTo', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', equalTo: 8);

      expect(rule.error, contains('not a valid decimal number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8.0', name: 'value', equalTo: 0);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8', name: 'value', equalTo: 0);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8.0', name: 'value', equalTo: 0, isNumeric: true);

      expect(rule.error, contains('not a valid number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1', name: 'value', equalTo: 0, isNumeric: true);

      expect(rule.error, contains('should be equal to 0'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', equalTo: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', equalTo: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('1', name: 'value', equalTo: 1, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('1.0', name: 'value', equalTo: 1.0);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('-10', name: 'value', equalTo: -10.00, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-20.0', name: 'value', equalTo: -20.000);

      expect(rule.hasError, equals(false));
    });
  });

  group('notEqualTo', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', notEqualTo: 8);

      expect(rule.error, contains('not a valid decimal number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0', name: 'value', notEqualTo: 0);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('0.0', name: 'value', notEqualTo: 0, isNumeric: true);

      expect(rule.error, contains('not a valid number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('10.0', name: 'value', notEqualTo: 10.000);

      expect(rule.error, contains('should not be equal to 10.0'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', notEqualTo: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', notEqualTo: 1);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('0', name: 'value', notEqualTo: 1, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('0.0', name: 'value', notEqualTo: 1.0);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('-10', name: 'value', notEqualTo: -10.01, isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-20.0', name: 'value', notEqualTo: -20.001);

      expect(rule.hasError, equals(false));
    });
  });

  group('equalToInList', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', equalToInList: [8]);

      expect(rule.error, contains('not a valid decimal number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8.0', name: 'value', equalToInList: [0, 10]);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('8', name: 'value', equalToInList: []);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('8.0', name: 'value', equalToInList: [0], isNumeric: true);

      expect(rule.error, contains('not a valid number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('10', name: 'value', equalToInList: [0, 1, 2], isNumeric: true);

      expect(rule.error,
          contains('should be equal to any of these values 0.0, 1.0, 2.0'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', equalToInList: [0, 1, 2]);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', equalToInList: [0, 1, 2]);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('1', name: 'value', equalToInList: [1.0], isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('1.0', name: 'value', equalToInList: [1, 2.0]);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('-10', name: 'value', equalToInList: [-10.00], isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-20.0', name: 'value', equalToInList: [-20.000]);

      expect(rule.hasError, equals(false));
    });
  });

  group('notEqualToInList', () {
    test('should throw an error', () {
      final rule = Rule('.', name: 'value', notEqualToInList: [8]);

      expect(rule.error, contains('not a valid decimal number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('-10.001', name: 'value', notEqualToInList: [0, -10.001]);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('0.0', name: 'value', notEqualToInList: [0], isNumeric: true);

      expect(rule.error, contains('not a valid number'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1',
          name: 'value', notEqualToInList: [0, 1, 2], isNumeric: true);

      expect(rule.error,
          contains('should not be equal to any of these values 0.0, 1.0, 2.0'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', notEqualToInList: [0, 1, 2]);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', notEqualToInList: [0, 1, 2]);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('8', name: 'value', notEqualToInList: []);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('3', name: 'value', notEqualToInList: [1.0], isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('3.0', name: 'value', notEqualToInList: [1, 2.0]);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-1',
          name: 'value', notEqualToInList: [-10.00], isNumeric: true);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('-20.0', name: 'value', notEqualToInList: [20.000]);

      expect(rule.hasError, equals(false));
    });
  });

  group('inList', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123', name: 'value', inList: ['123']);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1', name: 'value', inList: ['123', 'xyz']);

      expect(rule.error, contains('should be any of these values 123, xyz'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', inList: ['123']);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', inList: ['123']);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('123', name: 'value', inList: ['123', 'xyz']);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc', name: 'value', inList: ['123', 'abc']);

      expect(rule.hasError, equals(false));
    });
  });

  group('notInList', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123', name: 'value', notInList: ['qwerty123']);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('xyz', name: 'value', notInList: ['123', 'xyz']);

      expect(
          rule.error, contains('should not be any of these values 123, xyz'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', notInList: ['123']);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', notInList: ['123']);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc', name: 'value', notInList: ['123', 'xyz']);

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('xyz', name: 'value', notInList: ['123', 'abc']);

      expect(rule.hasError, equals(false));
    });
  });

  group('shouldMatch', () {
    test('should throw an error', () {
      final rule = Rule('qwerty123', name: 'value', shouldMatch: '123');

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('1', name: 'value', shouldMatch: '123');

      expect(rule.error, contains('should be same as 123'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', shouldMatch: '');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule(null, name: 'value', shouldMatch: '');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('123', name: 'value', shouldMatch: '123');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc', name: 'value', shouldMatch: 'abc');

      expect(rule.hasError, equals(false));
    });
  });

  group('shouldNotMatch', () {
    test('should throw an error', () {
      final rule =
          Rule('qwerty123', name: 'value', shouldNotMatch: 'qwerty123');

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('xyz', name: 'value', shouldNotMatch: 'xyz');

      expect(rule.error, contains('should not same as xyz'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('', name: 'value', shouldNotMatch: '');

      expect(rule.hasError, equals(false));
    });

    test('should throw an error', () {
      final rule = Rule(null, name: 'value', shouldNotMatch: '');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('abc ', name: 'value', shouldNotMatch: 'abc');

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule = Rule('xyz', name: 'value', shouldNotMatch: ' xyz');

      expect(rule.hasError, equals(false));
    });
  });
}
