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
      final rule = Rule(
        '',
        name: 'Name',
        isRequired: true,
        customErrorText: 'Name is invalid.',
      );

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

      expect(rule.error, equals('Name is invalid.'));
      expect(rule.hasError, equals(true));
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

      expect(rule.error, equals('This is a master error'));
      expect(rule.hasError, equals(true));
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

  group('rule options', () {
    group('trim', () {
      test('should throw an error', () {
        final rule = Rule(
          '  abc@xyz.com  ',
          name: 'email',
          isEmail: true,
        );

        expect(rule.hasError, equals(true));
      });

      test('should throw an error', () {
        final rule = Rule(
          '  abc@xyz.com  ',
          name: 'email',
          isEmail: true,
          options: RuleOptions(),
        );

        expect(rule.hasError, equals(true));
      });

      test('should throw an error', () {
        final rule = Rule(
          '  abc@xyz.com  ',
          name: 'email',
          isEmail: true,
          options: RuleOptions(
            trim: false,
          ),
        );

        expect(rule.hasError, equals(true));
      });

      test('should throw an error', () {
        final rule = Rule(
          '  ',
          name: 'name',
          isRequired: true,
          options: RuleOptions(
            trim: true,
          ),
        );

        expect(rule.hasError, equals(true));
      });

      test('should not throw an error', () {
        final rule = Rule(
          '  ',
          name: 'name',
          isRequired: false,
          options: RuleOptions(
            trim: true,
          ),
        );

        expect(rule.hasError, equals(false));
      });

      test('should not throw an error', () {
        final rule = Rule(
          '  abc@xyz.com  ',
          name: 'email',
          isEmail: true,
          options: RuleOptions(
            trim: true,
          ),
        );

        expect(rule.hasError, equals(false));
      });
    });

    group('upperCase', () {
      test('should throw an error', () {
        final rule = Rule(
          'abc',
          name: 'Name',
          regex: RegExp('[A-Z]'),
        );

        expect(rule.hasError, equals(true));
      });

      test('should throw an error', () {
        final rule = Rule(
          'abc',
          name: 'Name',
          options: RuleOptions(
            upperCase: false,
          ),
          regex: RegExp('[A-Z]'),
        );

        expect(rule.hasError, equals(true));
      });

      test('should not throw an error', () {
        final rule = Rule(
          'abc',
          name: 'Name',
          options: RuleOptions(
            upperCase: true,
          ),
          regex: RegExp('[A-Z]'),
        );

        expect(rule.hasError, equals(false));
      });

      test('should not throw an error', () {
        final rule = Rule(
          'abc XYZ',
          name: 'Name',
          options: RuleOptions(
            upperCase: true,
          ),
          regex: RegExp('[A-Z]'),
        );

        expect(rule.hasError, equals(false));
      });
    });

    group('lowerCase', () {
      test('should throw an error', () {
        final rule = Rule(
          'ABC',
          name: 'Name',
          regex: RegExp('[a-z]'),
        );

        expect(rule.hasError, equals(true));
      });

      test('should throw an error', () {
        final rule = Rule(
          'ABC',
          name: 'Name',
          options: RuleOptions(
            lowerCase: false,
          ),
          regex: RegExp('[a-z]'),
        );

        expect(rule.hasError, equals(true));
      });

      test('should not throw an error', () {
        final rule = Rule(
          'ABC',
          name: 'Name',
          options: RuleOptions(
            lowerCase: true,
          ),
          regex: RegExp('[a-z]'),
        );

        expect(rule.hasError, equals(false));
      });

      test('should not throw an error', () {
        final rule = Rule(
          'ABC xyz',
          name: 'Name',
          options: RuleOptions(
            lowerCase: true,
          ),
          regex: RegExp('[a-z]'),
        );

        expect(rule.hasError, equals(false));
      });
    });

    group('combination of options', () {
      test('should throw an error', () {
        try {
          final rule = Rule(
            '   ABC@xyz.com    ',
            name: 'Email',
            options: RuleOptions(
              trim: true,
              upperCase: true,
              lowerCase: true,
            ),
            isEmail: true,
          );

          expect(
            rule,
            contains(
              "Both 'lowerCase' and 'upperCase' in the rule options cannot be true",
            ),
          );
        } catch (e) {
          expect(
            e,
            contains(
              "Both 'lowerCase' and 'upperCase' in the rule options cannot be true",
            ),
          );
        }
      });

      test('should not throw an error', () {
        final rule = Rule(
          '   ABC@xyz.com    ',
          name: 'Email',
          options: RuleOptions(
            trim: true,
            lowerCase: true,
          ),
          isEmail: true,
        );

        expect(rule.hasError, equals(false));
        expect(rule.value, equals('abc@xyz.com'));
      });

      test('should not throw an error', () {
        final rule = Rule(
          '   ABC@xyz.com    ',
          name: 'Email',
          options: RuleOptions(
            trim: true,
            upperCase: true,
          ),
          isEmail: true,
        );

        expect(rule.hasError, equals(false));
        expect(rule.value, equals('ABC@XYZ.COM'));
      });
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

    test('should throw an error', () {
      final rule = Rule('abc.....f@xyz', name: 'value', isEmail: true);

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('abc...a..f@xyz', name: 'value', isEmail: true);

      expect(rule.hasError, equals(true));
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
    test('should throw an error - invalid string', () {
      final rule = Rule('qwerty123', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error - https://www.com', () {
      final rule = Rule('https://www.com', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - www.com', () {
      final rule = Rule('www.com', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - empty string', () {
      final rule = Rule('', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - null value', () {
      final rule = Rule(null, name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - www.x.co', () {
      final rule = Rule('www.x.co', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - www.x.co/', () {
      final rule = Rule('www.x.co/', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - www.google.com', () {
      final rule = Rule('www.google.com', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://www.google.com', () {
      final rule = Rule('https://www.google.com', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://google.uk', () {
      final rule = Rule('http://google.uk', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://www.google.co.in/404', () {
      final rule =
          Rule('http://www.google.co.in/404', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://www.google.co.in/404.html', () {
      final rule =
          Rule('http://www.google.co.in/404.html', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://google.jp', () {
      final rule = Rule('http://google.jp', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://www.google.gr', () {
      final rule = Rule('https://www.google.gr', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://www.google.fr', () {
      final rule = Rule('http://www.google.fr', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - isUrl false allows anything', () {
      final rule = Rule('+', name: 'value', isUrl: false);
      expect(rule.hasError, equals(false));
    });

    // Localhost tests - INVALID without protocol
    test('should throw an error - localhost without protocol', () {
      final rule = Rule('localhost', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true)); // ERROR - needs protocol
    });

    test('should throw an error - localhost:8080 without protocol', () {
      final rule = Rule('localhost:8080', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true)); // ERROR - needs protocol
    });

    // Localhost tests - VALID with protocol
    test('should NOT throw an error - http://localhost', () {
      final rule = Rule('http://localhost', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://localhost', () {
      final rule = Rule('https://localhost', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://localhost:8080', () {
      final rule = Rule('http://localhost:8080', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://localhost:8080', () {
      final rule = Rule('https://localhost:8080', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://localhost:8087', () {
      final rule = Rule('http://localhost:8087', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://localhost:8087', () {
      final rule = Rule('https://localhost:8087', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://localhost:3000/api/users', () {
      final rule =
          Rule('http://localhost:3000/api/users', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://localhost:4200/dashboard', () {
      final rule =
          Rule('https://localhost:4200/dashboard', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    // IP address tests - INVALID without protocol
    test('should throw an error - IP 127.0.0.1 without protocol', () {
      final rule = Rule('127.0.0.1', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true)); // ERROR - needs protocol
    });

    test('should throw an error - IP 192.168.1.1 without protocol', () {
      final rule = Rule('192.168.1.1', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true)); // ERROR - needs protocol
    });

    test('should throw an error - IP 127.0.0.1:8080 without protocol', () {
      final rule = Rule('127.0.0.1:8080', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true)); // ERROR - needs protocol
    });

    // IP address tests - VALID with protocol
    test('should NOT throw an error - http://127.0.0.1', () {
      final rule = Rule('http://127.0.0.1', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://127.0.0.1', () {
      final rule = Rule('https://127.0.0.1', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://127.0.0.1:8080', () {
      final rule = Rule('http://127.0.0.1:8080', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://127.0.0.1:8080', () {
      final rule = Rule('https://127.0.0.1:8080', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://192.168.1.1', () {
      final rule = Rule('http://192.168.1.1', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://192.168.1.1', () {
      final rule = Rule('https://192.168.1.1', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://192.168.1.1:3000', () {
      final rule = Rule('http://192.168.1.1:3000', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://192.168.1.1:3000', () {
      final rule = Rule('https://192.168.1.1:3000', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://192.168.1.1:8080/api', () {
      final rule =
          Rule('http://192.168.1.1:8080/api', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://192.168.1.1:8080/api', () {
      final rule =
          Rule('https://192.168.1.1:8080/api', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - http://10.0.0.1:5000', () {
      final rule = Rule('http://10.0.0.1:5000', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - https://10.0.0.1:5000', () {
      final rule = Rule('https://10.0.0.1:5000', name: 'value', isUrl: true);
      expect(rule.hasError, equals(false));
    });

    // URL with credentials tests - WITH protocol
    test('should NOT throw an error - URL with public key credential', () {
      final rule = Rule(
        'https://abc123@o123456.ingest.sentry.io/7890123',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - Sentry DSN EU region', () {
      final rule = Rule(
        'https://publickey@org.ingest.de.sentry.io/123456',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - URL with user:pass credentials', () {
      final rule = Rule(
        'https://user:password@example.com/path',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - URL with credentials on localhost', () {
      final rule = Rule(
        'http://admin:secret@localhost:8080/api',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - URL with credentials on IP', () {
      final rule = Rule(
        'https://user:pass@192.168.1.1:3000/admin',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - URL with special chars in credentials',
        () {
      final rule = Rule(
        'https://user%40email.com:p%40ssw0rd@example.com',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    // Single credential (no password) without protocol - INVALID for localhost/IP
    test(
        'should throw an error - single credential on localhost without protocol',
        () {
      final rule = Rule(
        'secret@localhost',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(true)); // ERROR - localhost needs protocol
    });

    test('should throw an error - single credential on IP without protocol',
        () {
      final rule = Rule(
        'token@192.168.1.1',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(true)); // ERROR - IP needs protocol
    });

    // Single credential (no password) without protocol - VALID for domains
    test(
        'should NOT throw an error - single credential on domain without protocol',
        () {
      final rule = Rule(
        'secret@api.example.com',
        name: 'value',
        isUrl: true,
      );
      expect(
          rule.hasError, equals(false)); // OK - domain allows optional protocol
    });

    test(
        'should NOT throw an error - single credential on subdomain without protocol',
        () {
      final rule = Rule(
        'publickey@org.ingest.sentry.io',
        name: 'value',
        isUrl: true,
      );
      expect(
          rule.hasError, equals(false)); // OK - domain allows optional protocol
    });

    // User:pass credentials without protocol - INVALID for localhost/IP
    test('should throw an error - user:pass on localhost without protocol', () {
      final rule = Rule(
        'admin:secret@localhost',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(true)); // ERROR - localhost needs protocol
    });

    test('should throw an error - user:pass on localhost:port without protocol',
        () {
      final rule = Rule(
        'admin:secret@localhost:8080/api',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(true)); // ERROR - localhost needs protocol
    });

    test(
        'should throw an error - user:pass on localhost with path without protocol',
        () {
      final rule = Rule(
        'admin:secret@localhost/api',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(true)); // ERROR - localhost needs protocol
    });

    test('should throw an error - user:pass on IP without protocol', () {
      final rule = Rule(
        'user:pass@192.168.1.1:3000/admin',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(true)); // ERROR - IP needs protocol
    });

    test('should throw an error - user:pass on IP without protocol or port',
        () {
      final rule = Rule(
        'user:pass@127.0.0.1',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(true)); // ERROR - IP needs protocol
    });

    // User:pass credentials without protocol - VALID for domains
    test('should NOT throw an error - user:pass on domain without protocol',
        () {
      final rule = Rule(
        'user:password@example.com/path',
        name: 'value',
        isUrl: true,
      );
      expect(
          rule.hasError, equals(false)); // OK - domain allows optional protocol
    });

    test('should NOT throw an error - user:pass on subdomain without protocol',
        () {
      final rule = Rule(
        'admin:secret@api.example.com/endpoint',
        name: 'value',
        isUrl: true,
      );
      expect(
          rule.hasError, equals(false)); // OK - domain allows optional protocol
    });

    test(
        'should NOT throw an error - user:pass on domain with port without protocol',
        () {
      final rule = Rule(
        'user:pass@example.com:8080',
        name: 'value',
        isUrl: true,
      );
      expect(
          rule.hasError, equals(false)); // OK - domain allows optional protocol
    });

    // Edge cases
    test('should NOT throw an error - domain with multiple subdomains', () {
      final rule = Rule(
        'https://api.v2.staging.example.com/endpoint',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - URL with query parameters', () {
      final rule = Rule(
        'https://example.com/search?q=test&page=1',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - URL with hash fragment', () {
      final rule = Rule(
        'https://example.com/docs#section-1',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error - URL with port and path', () {
      final rule = Rule(
        'https://example.com:8443/api/v1/users',
        name: 'value',
        isUrl: true,
      );
      expect(rule.hasError, equals(false));
    });

    test('should throw an error - invalid TLD', () {
      final rule = Rule('https://example', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true));
    });

    test('should throw an error - missing domain', () {
      final rule = Rule('https://', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true));
    });

    test('should throw an error - malformed URL', () {
      final rule = Rule('ht!tp://example.com', name: 'value', isUrl: true);
      expect(rule.hasError, equals(true));
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
      final rule = Rule(
        '1200:0000:AB00:1234:0000:2552:7777:1313',
        name: 'value',
        isIp: true,
      );

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
      final rule = Rule(
        '123.',
        name: 'value',
        regex: RegExp(
          r'^[a-zA-Z0-9\s]+$',
          caseSensitive: false,
        ),
      );

      expect(
        rule.error,
        contains('should match the pattern: ^[a-zA-Z0-9\\s]+\$'),
      );
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule =
          Rule('123.', name: 'value', regex: RegExp(r'^[a-zA-Z0-9\s]+$'));

      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule = Rule('', name: 'value', regex: RegExp(r'^[a-zA-Z0-9\s]+$'));

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule(null, name: 'value', regex: RegExp(r'^[a-zA-Z0-9\s]+$'));

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('abc123', name: 'value', regex: RegExp(r'^[a-zA-Z0-9\s]+$'));

      expect(rule.hasError, equals(false));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('abc xyz', name: 'value', regex: RegExp(r'^[a-zA-Z0-9\s]+$'));

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
      final rule = Rule('-10', name: 'value', equalTo: -10.00, isNumeric: true);

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

      expect(
        rule.error,
        contains('should be equal to any of these values 0.0, 1.0, 2.0'),
      );
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
      final rule = Rule(
        '1',
        name: 'value',
        notEqualToInList: [0, 1, 2],
        isNumeric: true,
      );

      expect(
        rule.error,
        contains('should not be equal to any of these values 0.0, 1.0, 2.0'),
      );
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
      final rule = Rule(
        '-1',
        name: 'value',
        notEqualToInList: [-10.00],
        isNumeric: true,
      );

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
        rule.error,
        contains('should not be any of these values 123, xyz'),
      );
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

      expect(rule.error, contains('should not be same as xyz'));
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

  group('shouldPass', () {
    test('should throw an error', () {
      final rule =
          Rule('qwerty123', name: 'value', shouldPass: (value) => false);

      expect(rule.error, equals('value is invalid'));
      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule(
        'qwerty123',
        name: 'value',
        shouldPass: (value) => false,
        customErrors: {'shouldPass': '{name} is not valid'},
      );

      expect(rule.error, equals('value is not valid'));
      expect(rule.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule =
          Rule('qwerty123', name: 'value', shouldPass: (value) => true);

      expect(rule.hasError, equals(false));
    });
  });

  group('copyWith', () {
    test('should throw an error', () {
      final rule =
          Rule('qwerty123', name: 'value', shouldNotMatch: 'qwerty123');

      expect(rule.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule = Rule('xyz', name: 'value', shouldNotMatch: 'xyz');

      expect(rule.error, contains('should not be same as xyz'));
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

    test('should throw an error', () {
      final rule1 = Rule(
        'xyz',
        name: 'value',
        isRequired: true,
      );
      final rule2 = rule1.copyWith(
        isEmail: true,
      );

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '',
        name: 'value',
        isRequired: false,
      );
      final rule2 = rule1.copyWith(
        isRequired: true,
      );

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '',
        name: 'value',
        isRequired: true,
      );
      final rule2 = rule1.copyWith(
        isRequired: false,
      );

      expect(rule1.hasError, equals(true));
      expect(rule2.hasError, equals(false));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '123',
        name: 'value',
        isRequired: true,
        isAlphaSpace: true,
        customErrorText: 'invalid value for rule 1',
      );
      final rule2 = rule1.copyWith(
        isRequired: false,
        isNumeric: true,
        customErrorText: 'invalid value for rule 2',
      );

      final rule3 = rule1.copyWith(
        isRequired: false,
        isNumeric: true,
      );

      expect(rule1.hasError, equals(true));
      expect(rule1.error, contains('invalid value for rule 1'));
      expect(rule2.hasError, equals(true));
      expect(rule2.error, contains('invalid value for rule 2'));
      expect(rule3.hasError, equals(true));
      expect(rule3.error, contains('invalid value for rule 1'));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '123',
        name: 'value',
        isRequired: true,
        isAlphaSpace: true,
        customErrorText: 'invalid value for rule 1',
      );
      final rule2 = rule1.copyWith(
        isRequired: false,
        isAlphaSpace: false,
        isNumeric: true,
        customErrorText: 'invalid value for rule 2',
      );

      final rule3 = rule1.copyWith(
        isRequired: false,
        isNumeric: true,
      );

      expect(rule1.hasError, equals(true));
      expect(rule1.error, contains('invalid value for rule 1'));
      expect(rule2.hasError, equals(false));
      expect(rule3.hasError, equals(true));
      expect(rule3.error, contains('invalid value for rule 1'));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '123',
        name: 'value',
        isRequired: true,
        isAlphaSpace: true,
      );
      final rule2 = rule1.copyWith(
        isRequired: false,
        isNumeric: true,
      );

      expect(rule1.hasError, equals(true));
      expect(
        rule1.error,
        contains('Only alphabets and spaces are allowed in value'),
      );
      expect(rule2.hasError, equals(true));
      expect(
        rule2.error,
        contains('Only alphabets and spaces are allowed in value'),
      );
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '123',
        name: 'value',
        isRequired: true,
        isAlphaSpace: true,
      );
      final rule2 = rule1.copyWith(
        isRequired: false,
        isNumeric: true,
      );
      final rule3 = rule2.copyWith(
        isRequired: false,
        isEmail: true,
      );

      expect(rule1.hasError, equals(true));
      expect(
        rule1.error,
        contains('Only alphabets and spaces are allowed in value'),
      );
      expect(rule2.hasError, equals(true));
      expect(
        rule2.error,
        contains('Only alphabets and spaces are allowed in value'),
      );
      expect(rule3.hasError, equals(true));
      expect(rule3.error, contains('not a valid email address'));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '',
        name: 'value 1',
        isRequired: false,
      );
      final rule2 = rule1.copyWith(
        name: 'value 2',
        isRequired: true,
      );

      expect(rule1.hasError, equals(false));
      expect(rule2.error, contains('value 2 is required'));
      expect(rule2.hasError, equals(true));
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '123',
        name: 'value 1',
        isAlphaSpace: true,
      );
      final rule2 = rule1.copyWith(
        name: 'value 2',
        isRequired: false,
        isEmail: true,
      );

      expect(
        rule1.error,
        contains('Only alphabets and spaces are allowed in value 1'),
      );
      expect(rule1.hasError, equals(true));
      expect(rule2.error, contains('value 2 is not a valid email address'));
      expect(rule2.hasError, equals(true));
    });

    test('should NOT throw an error', () {
      final rule1 = Rule(
        '123',
        name: 'value',
        isRequired: true,
        customErrorText: 'invalid value for rule 1',
      );
      final rule2 = rule1.copyWith(
        isRequired: false,
        isNumeric: true,
        customErrorText: 'invalid value for rule 2',
      );

      expect(rule1.hasError, equals(false));
      expect(rule2.hasError, equals(false));
    });
  });
}
