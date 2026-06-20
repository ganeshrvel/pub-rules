import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group('isRequired', () {
    test('null fails', () {
      final r = Rule.string(name: 'Name').isRequired().parse(null);
      expect(r.hasError, isTrue);
      expect(r.error?.message, equals('Name is required'));
      expect(r.error?.check, equals(StringCheck.isRequired));
    });
    test('empty string fails', () {
      final r = Rule.string(name: 'Name').isRequired().parse('');
      expect(r.hasError, isTrue);
      expect(r.error?.message, equals('Name is required'));
    });
    test('present value passes', () {
      final r = Rule.string(name: 'Name').isRequired().parse('abc');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('abc'));
    });
    test('null optional passes', () {
      final r = Rule.string(name: 'Name').parse(null);
      expect(r.ok, isTrue);
    });
    test('empty optional passes', () {
      final r = Rule.string(name: 'Name').parse('');
      expect(r.ok, isTrue);
    });
    test('custom required message', () {
      final r = Rule.string(name: 'Name')
          .isRequired(error: 'Name is invalid.')
          .parse('');
      expect(r.error?.message, equals('Name is invalid.'));
    });
  });

  group('isEmail', () {
    test('valid email passes', () {
      final r = Rule.string(name: 'Email').isEmail().parse('abc@xyz.com');
      expect(r.ok, isTrue);
    });
    test('missing tld fails', () {
      final r = Rule.string(name: 'Email').isEmail().parse('abc@xyz');
      expect(r.error?.message, equals('Email is not a valid email address'));
    });
    test('custom error override', () {
      final r = Rule.string(name: 'Email')
          .isEmail(error: 'Email is invalid.')
          .parse('abc@xyz');
      expect(r.error?.message, equals('Email is invalid.'));
    });
  });

  group('isUrl', () {
    test('protocol url passes', () {
      final r =
          Rule.string(name: 'value').isUrl().parse('http://www.google.com');
      expect(r.ok, isTrue);
    });
    test('bare domain passes', () {
      final r = Rule.string(name: 'value').isUrl().parse('www.google.com');
      expect(r.ok, isTrue);
    });
    test('localhost without protocol fails', () {
      final r = Rule.string(name: 'value').isUrl().parse('localhost');
      expect(r.error?.message, contains('is not a valid URL'));
    });
    test('plain text fails', () {
      final r = Rule.string(name: 'value').isUrl().parse('not a url');
      expect(r.hasError, isTrue);
    });
  });

  group('isPhone', () {
    test('valid phone passes', () {
      final r = Rule.string(name: 'value').isPhone().parse('+1-9090909090');
      expect(r.ok, isTrue);
    });
    test('non-phone fails', () {
      final r = Rule.string(name: 'value').isPhone().parse('abc');
      expect(r.error?.message, contains('is not a valid phone number'));
    });
  });

  group('isIp', () {
    test('valid ipv4 passes', () {
      final r = Rule.string(name: 'value').isIp().parse('1.1.1.1');
      expect(r.ok, isTrue);
    });
    test('non-ip fails', () {
      final r = Rule.string(name: 'value').isIp().parse('abc');
      expect(r.error?.message, contains('is not a valid IP address'));
    });
  });

  group('isNumeric', () {
    test('positive integer passes', () {
      final r = Rule.string(name: 'value').isNumeric().parse('1');
      expect(r.ok, isTrue);
    });
    test('zero passes', () {
      final r = Rule.string(name: 'value').isNumeric().parse('0');
      expect(r.ok, isTrue);
    });
    test('negative integer passes', () {
      final r = Rule.string(name: 'value').isNumeric().parse('-1');
      expect(r.ok, isTrue);
    });
    test('decimal fails', () {
      final r = Rule.string(name: 'value').isNumeric().parse('1.5');
      expect(r.error?.message, contains('is not a valid number'));
    });
    test('alpha fails', () {
      final r = Rule.string(name: 'value').isNumeric().parse('abc');
      expect(r.hasError, isTrue);
    });
    test('custom error override', () {
      final r = Rule.string(name: 'value')
          .isNumeric(error: 'not a number')
          .parse('abc');
      expect(r.error?.message, equals('not a number'));
    });
  });

  group('isNumericDecimal', () {
    test('decimal passes', () {
      final r = Rule.string(name: 'value').isNumericDecimal().parse('10.01');
      expect(r.ok, isTrue);
    });
    test('negative decimal passes', () {
      final r = Rule.string(name: 'value').isNumericDecimal().parse('-10.01');
      expect(r.ok, isTrue);
    });
    test('leading zero decimal passes', () {
      final r = Rule.string(name: 'value').isNumericDecimal().parse('0.001');
      expect(r.ok, isTrue);
    });
    test('whole number passes', () {
      final r = Rule.string(name: 'value').isNumericDecimal().parse('5');
      expect(r.ok, isTrue);
    });
    test('alpha fails', () {
      final r = Rule.string(name: 'value').isNumericDecimal().parse('abc');
      expect(r.error?.message, contains('is not a valid decimal number'));
    });
  });

  group('isAlphaSpace', () {
    test('letters and spaces pass', () {
      final r = Rule.string(name: 'value').isAlphaSpace().parse('Jane Doe');
      expect(r.ok, isTrue);
    });
    test('digits fail', () {
      final r = Rule.string(name: 'value').isAlphaSpace().parse('abc123');
      expect(
        r.error?.message,
        equals('Only alphabets and spaces are allowed in value'),
      );
    });
  });

  group('isAlphaNumeric', () {
    test('letters and digits pass', () {
      final r =
          Rule.string(name: 'value').isAlphaNumeric().parse('username123');
      expect(r.ok, isTrue);
    });
    test('space fails', () {
      final r = Rule.string(name: 'value').isAlphaNumeric().parse('user name');
      expect(
        r.error?.message,
        equals('Only alphabets and numbers are allowed in value'),
      );
    });
  });

  group('isAlphaNumericSpace', () {
    test('letters digits and spaces pass', () {
      final r =
          Rule.string(name: 'value').isAlphaNumericSpace().parse('Bread 20');
      expect(r.ok, isTrue);
    });
    test('symbol fails', () {
      final r =
          Rule.string(name: 'value').isAlphaNumericSpace().parse('Bread@20');
      expect(
        r.error?.message,
        equals('Only alphabets, numbers and spaces are allowed in value'),
      );
    });
  });

  group('matches', () {
    test('matching pattern passes', () {
      final r = Rule.string(name: 'value').regex(RegExp(r'^\d+$')).parse('123');
      expect(r.ok, isTrue);
    });
    test('non-matching pattern fails', () {
      final r = Rule.string(name: 'value').regex(RegExp(r'^\d+$')).parse('abc');
      expect(r.error?.message, contains('should match the pattern'));
    });
  });

  group('length constraints', () {
    test('exact length passes', () {
      final r = Rule.string(name: 'value').length(3).parse('abc');
      expect(r.ok, isTrue);
    });
    test('wrong length fails', () {
      final r = Rule.string(name: 'value').length(3).parse('ab');
      expect(r.error?.message, equals('value should be 3 characters long'));
    });
    test('minLength boundary passes', () {
      final r = Rule.string(name: 'value').minLength(3).parse('abc');
      expect(r.ok, isTrue);
    });
    test('below minLength fails', () {
      final r = Rule.string(name: 'value').minLength(3).parse('ab');
      expect(
        r.error?.message,
        equals('value should contain at least 3 characters'),
      );
    });
    test('maxLength boundary passes', () {
      final r = Rule.string(name: 'value').maxLength(3).parse('abc');
      expect(r.ok, isTrue);
    });
    test('above maxLength fails', () {
      final r = Rule.string(name: 'value').maxLength(3).parse('abcd');
      expect(
        r.error?.message,
        equals('value should not exceed more than 3 characters'),
      );
    });
  });

  group('comparisons', () {
    test('equalTo mismatch fails', () {
      final r = Rule.string(name: 'value').equalTo('abc').parse('xyz');
      expect(r.error?.message, equals('value should be equal to abc'));
    });
    test('notEqualTo match fails', () {
      final r = Rule.string(name: 'value').notEqualTo('abc').parse('abc');
      expect(r.error?.message, equals('value should not be equal to abc'));
    });
  });

  group('numeric comparisons on strings', () {
    test('greaterThan passes for larger whole numbers', () {
      final r = Rule.string(name: 'v').greaterThan('5').parse('10');
      expect(r.ok, isTrue);
    });

    test('greaterThan fails for smaller whole numbers', () {
      final r = Rule.string(name: 'v').greaterThan('10').parse('5');
      expect(r.error?.message, equals('v should be greater than 10'));
    });

    test('greaterThan compares numerically, not lexicographically', () {
      final r = Rule.string(name: 'v').greaterThan('9').parse('10');
      expect(r.ok, isTrue);
    });

    test('greaterThanOrEqualTo passes at the boundary', () {
      final r = Rule.string(name: 'v').greaterThanOrEqualTo('5').parse('5');
      expect(r.ok, isTrue);
    });

    test('lessThan passes for smaller whole numbers', () {
      final r = Rule.string(name: 'v').lessThan('10').parse('5');
      expect(r.ok, isTrue);
    });

    test('lessThan compares numerically, not lexicographically', () {
      final r = Rule.string(name: 'v').lessThan('10').parse('9');
      expect(r.ok, isTrue);
    });

    test('lessThanOrEqualTo passes at the boundary', () {
      final r = Rule.string(name: 'v').lessThanOrEqualTo('5').parse('5');
      expect(r.ok, isTrue);
    });

    test('greaterThan passes for decimal values', () {
      final r = Rule.string(name: 'v').greaterThan('5.5').parse('5.6');
      expect(r.ok, isTrue);
    });

    test('greaterThan fails for smaller decimal values', () {
      final r = Rule.string(name: 'v').greaterThan('5.5').parse('5.4');
      expect(r.error?.message, equals('v should be greater than 5.5'));
    });

    test('lessThanOrEqualTo passes for an exact decimal boundary', () {
      final r = Rule.string(name: 'v').lessThanOrEqualTo('9.99').parse('9.99');
      expect(r.ok, isTrue);
    });

    test('greaterThan handles negative numbers correctly', () {
      final r = Rule.string(name: 'v').greaterThan('-10').parse('-5');
      expect(r.ok, isTrue);
    });

    test('lessThan handles negative decimal numbers correctly', () {
      final r = Rule.string(name: 'v').lessThan('-1.5').parse('-2.5');
      expect(r.ok, isTrue);
    });
  });

  group('numeric comparisons reject non-numeric input', () {
    test('greaterThan fails when the value is not numeric', () {
      final r = Rule.string(name: 'v').greaterThan('5').parse('abc');
      expect(r.error?.message, equals('v is not a valid number'));
    });

    test('lessThan fails when the value is not numeric', () {
      final r = Rule.string(name: 'v').lessThan('5').parse('abc');
      expect(r.error?.message, equals('v is not a valid number'));
    });

    test('greaterThanOrEqualTo fails when the value is not numeric', () {
      final r = Rule.string(name: 'v').greaterThanOrEqualTo('5').parse('abc');
      expect(r.error?.message, equals('v is not a valid number'));
    });

    test('lessThanOrEqualTo fails when the value is not numeric', () {
      final r = Rule.string(name: 'v').lessThanOrEqualTo('5').parse('abc');
      expect(r.error?.message, equals('v is not a valid number'));
    });

    test('greaterThan fails when the comparison target itself is not numeric',
        () {
      final r = Rule.string(name: 'v').greaterThan('abc').parse('5');
      expect(r.error?.message, equals('v is not a valid number'));
    });

    test('greaterThan fails when both value and target are non-numeric', () {
      final r = Rule.string(name: 'v').greaterThan('xyz').parse('abc');
      expect(r.error?.message, equals('v is not a valid number'));
    });

    test('greaterThan fails for an empty target string', () {
      final r = Rule.string(name: 'v').greaterThan('').parse('5');
      expect(r.error?.message, equals('v is not a valid number'));
    });

    test('custom error overrides the not-a-number message', () {
      final r = Rule.string(name: 'v')
          .greaterThan('5', error: 'Enter digits only - invalid {value}')
          .parse('abc');
      expect(r.error?.message, equals('Enter digits only - invalid abc'));
    });

    test('custom error also overrides the failed-comparison message', () {
      final r =
          Rule.string(name: 'v').lessThan('5', error: 'Too big').parse('10');
      expect(r.error?.message, equals('Too big'));
    });
  });

  group('lists', () {
    test('inList membership passes', () {
      final r = Rule.string(name: 'value').inList(['a', 'b']).parse('a');
      expect(r.ok, isTrue);
    });
    test('inList membership fails', () {
      final r = Rule.string(name: 'value').inList(['a', 'b']).parse('c');
      expect(
        r.error?.message,
        equals('value should be any of these values a, b'),
      );
    });
    test('notInList membership passes', () {
      final r = Rule.string(name: 'value').notInList(['a', 'b']).parse('c');
      expect(r.ok, isTrue);
    });
    test('notInList membership fails', () {
      final r = Rule.string(name: 'value').notInList(['a', 'b']).parse('a');
      expect(
        r.error?.message,
        equals('value should not be any of these values a, b'),
      );
    });
  });

  group('shouldMatch / shouldNotMatch', () {
    test('shouldMatch passes', () {
      final r = Rule.string(name: 'value').shouldMatch('abc').parse('abc');
      expect(r.ok, isTrue);
    });
    test('shouldMatch fails', () {
      final r = Rule.string(name: 'value').shouldMatch('abc').parse('xyz');
      expect(r.error?.message, equals('value should be same as abc'));
    });
    test('shouldNotMatch passes', () {
      final r = Rule.string(name: 'value').shouldNotMatch('xyz').parse('abc');
      expect(r.ok, isTrue);
    });
    test('shouldNotMatch fails', () {
      final r = Rule.string(name: 'value').shouldNotMatch('xyz').parse('xyz');
      expect(r.error?.message, equals('value should not be same as xyz'));
    });
  });

  group('transforms', () {
    test('untrimmed email fails', () {
      final r = Rule.string(name: 'email').isEmail().parse('  abc@xyz.com  ');
      expect(r.hasError, isTrue);
    });
    test('trim before email passes', () {
      final r =
          Rule.string(name: 'email').trim().isEmail().parse('  abc@xyz.com  ');
      expect(r.ok, isTrue);
    });
    test('trim to empty fails required', () {
      final r = Rule.string(name: 'name').isRequired().trim().parse('  ');
      expect(r.hasError, isTrue);
    });
    test('trim to empty passes optional', () {
      final r = Rule.string(name: 'name').trim().parse('  ');
      expect(r.ok, isTrue);
    });
    test('lowercase value has no uppercase match', () {
      final r = Rule.string(name: 'Name').regex(RegExp('[A-Z]')).parse('abc');
      expect(r.hasError, isTrue);
    });
    test('toUpperCase makes the uppercase match pass', () {
      final r = Rule.string(name: 'Name')
          .toUpperCase()
          .regex(RegExp('[A-Z]'))
          .parse('abc');
      expect(r.ok, isTrue);
    });
    test('toLowerCase makes the lowercase match pass', () {
      final r = Rule.string(name: 'Name')
          .toLowerCase()
          .regex(RegExp('[a-z]'))
          .parse('ABC');
      expect(r.ok, isTrue);
    });
  });

  group('check', () {
    test('predicate passes', () {
      final r =
          Rule.string(name: 'value').check((v) => v.length > 2).parse('abc');
      expect(r.ok, isTrue);
    });
    test('predicate fails with default message', () {
      final r =
          Rule.string(name: 'value').check((v) => v.length > 2).parse('a');
      expect(r.error?.message, equals('value is invalid'));
    });
    test('predicate fails with custom message', () {
      final r = Rule.string(name: 'value')
          .check((v) => false, error: '{name} is bad')
          .parse('abc');
      expect(r.error?.message, equals('value is bad'));
    });
  });

  group('refine', () {
    test('returns the error string', () {
      final r = Rule.string(name: 'value')
          .refine((v) => 'custom error from validator')
          .parse('qwerty123');
      expect(r.error?.message, equals('custom error from validator'));
    });
    test('supports the name placeholder', () {
      final r = Rule.string(name: 'value')
          .refine((v) => '{name} failed custom validation')
          .parse('qwerty123');
      expect(r.error?.message, equals('value failed custom validation'));
    });
    test('supports the value placeholder', () {
      final r = Rule.string(name: 'value')
          .refine((v) => 'input {value} is not allowed')
          .parse('qwerty123');
      expect(r.error?.message, equals('input qwerty123 is not allowed'));
    });
    test('returns the exact string from the callback', () {
      final r = Rule.string(name: 'value').refine((v) {
        final invalid = v.split('').where((c) => c == 'b').toList();
        return 'contains forbidden chars: ${invalid.join(', ')}';
      }).parse('bad');
      expect(r.error?.message, equals('contains forbidden chars: b'));
    });
    test('null return passes', () {
      final r =
          Rule.string(name: 'value').refine((v) => null).parse('qwerty123');
      expect(r.ok, isTrue);
    });
    test('skipped for empty value', () {
      final r = Rule.string(name: 'value')
          .refine((v) => 'this should not be reached')
          .parse('');
      expect(r.ok, isTrue);
    });
    test('skipped for null value', () {
      final r = Rule.string(name: 'value')
          .refine((v) => 'this should not be reached')
          .parse(null);
      expect(r.ok, isTrue);
    });
    test('supports both name and value placeholders', () {
      final r = Rule.string(name: 'File name').refine((value) {
        final invalidChars =
            value.split('').where((c) => r'<>:"/\|?*'.contains(c)).toList();

        if (invalidChars.isEmpty) {
          return null;
        }

        return '{name} "{value}" contains unsupported characters: '
            '${invalidChars.join(', ')}';
      }).parse('my<file>.txt');
      expect(
        r.error?.message,
        equals(
          'File name "my<file>.txt" contains unsupported characters: <, >',
        ),
      );
    });
  });

  group('ordering and short-circuit', () {
    test('required fires before later checks', () {
      final r = Rule.string(name: 'Email')
          .isRequired(error: 'This is a master error')
          .isEmail(error: 'Email is invalid.')
          .parse('');
      expect(r.error?.message, equals('This is a master error'));
      expect(r.error?.check, equals(StringCheck.isRequired));
    });
    test('first failing check wins', () {
      final r =
          Rule.string(name: 'value').isAlphaSpace().isEmail().parse('123');
      expect(
        r.error?.message,
        equals('Only alphabets and spaces are allowed in value'),
      );
      expect(r.error?.check, equals(StringCheck.isAlphaSpace));
    });
    test('checks skipped for absent optional value', () {
      final r = Rule.string(name: 'value').isEmail().parse('');
      expect(r.ok, isTrue);
      expect(r.hasValidatedValue, isFalse);
    });
  });

  group('trim interactions', () {
    test('trim + isRequired, value with only spaces fails', () {
      final r = Rule.string(name: 'Name').trim().isRequired().parse('   ');
      expect(r.hasError, isTrue);
      expect(r.error?.message, equals('Name is required'));
    });

    test('trim + isRequired, value with spaces around text passes', () {
      final r = Rule.string(name: 'Name').trim().isRequired().parse('  john  ');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('john'));
    });

    test('trim + isEmail, spaces around valid email passes', () {
      final r =
          Rule.string(name: 'Email').trim().isEmail().parse('  abc@xyz.com  ');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('abc@xyz.com'));
    });

    test('trim + isEmail, spaces around invalid email fails', () {
      final r =
          Rule.string(name: 'Email').trim().isEmail().parse('  notanemail  ');
      expect(r.hasError, isTrue);
      expect(r.error?.check, equals(StringCheck.isEmail));
    });

    test('trim + isNumeric, spaces around number passes', () {
      final r = Rule.string(name: 'v').trim().isNumeric().parse('  123  ');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('123'));
    });

    test('trim + minLength, length checked after trim', () {
      final r = Rule.string(name: 'v').trim().minLength(3).parse('  ab  ');
      expect(r.hasError, isTrue);
      expect(r.error?.message, contains('at least 3 characters'));
    });

    test('trim + minLength, trimmed value meets length passes', () {
      final r = Rule.string(name: 'v').trim().minLength(3).parse('  abc  ');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('abc'));
    });

    test('trim + maxLength, trimmed value within limit passes', () {
      final r = Rule.string(name: 'v').trim().maxLength(3).parse('  abc  ');
      expect(r.ok, isTrue);
    });

    test('trim + maxLength, trimmed value exceeds limit fails', () {
      final r = Rule.string(name: 'v').trim().maxLength(3).parse('  abcd  ');
      expect(r.hasError, isTrue);
    });

    test('trim + isAlphaSpace, trimmed value passes', () {
      final r =
          Rule.string(name: 'v').trim().isAlphaSpace().parse('  Jane Doe  ');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('Jane Doe'));
    });

    test('trim collapses to empty, optional, hasValidatedValue is false', () {
      final r = Rule.string(name: 'v').trim().parse('   ');
      expect(r.ok, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });

    test('trim + shouldMatch, trimmed value matches passes', () {
      final r =
          Rule.string(name: 'v').trim().shouldMatch('abc').parse('  abc  ');
      expect(r.ok, isTrue);
    });

    test('trim + shouldMatch, trimmed value does not match fails', () {
      final r =
          Rule.string(name: 'v').trim().shouldMatch('abc').parse('  xyz  ');
      expect(r.hasError, isTrue);
    });

    test('trim + refine, refine receives trimmed value', () {
      final r = Rule.string(name: 'v')
          .trim()
          .refine((v) => v == 'abc' ? null : 'not abc')
          .parse('  abc  ');
      expect(r.ok, isTrue);
    });

    test('trim + refine, refine sees trimmed not raw', () {
      final r = Rule.string(name: 'v')
          .trim()
          .refine((v) => v == '  abc  ' ? null : 'was trimmed')
          .parse('  abc  ');
      expect(r.hasError, isTrue);
      expect(r.error?.message, equals('was trimmed'));
    });
  });

  group('toLowerCase interactions', () {
    test('toLowerCase + isEmail, uppercased email passes', () {
      final r = Rule.string(name: 'Email')
          .toLowerCase()
          .isEmail()
          .parse('ABC@XYZ.COM');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('abc@xyz.com'));
    });

    test('toLowerCase + matches uppercase pattern fails', () {
      final r = Rule.string(name: 'v')
          .toLowerCase()
          .regex(RegExp(r'^[A-Z]+$'))
          .parse('ABC');
      expect(r.hasError, isTrue);
    });

    test('toLowerCase + matches lowercase pattern passes', () {
      final r = Rule.string(name: 'v')
          .toLowerCase()
          .regex(RegExp(r'^[a-z]+$'))
          .parse('ABC');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('abc'));
    });

    test('toLowerCase + shouldMatch, compared after lowering', () {
      final r =
          Rule.string(name: 'v').toLowerCase().shouldMatch('abc').parse('ABC');
      expect(r.ok, isTrue);
    });

    test('toLowerCase + refine, refine receives lowered value', () {
      final r = Rule.string(name: 'v')
          .toLowerCase()
          .refine((v) => v == 'abc' ? null : 'not abc')
          .parse('ABC');
      expect(r.ok, isTrue);
    });

    test('toLowerCase + isAlphaNumeric passes', () {
      final r =
          Rule.string(name: 'v').toLowerCase().isAlphaNumeric().parse('ABC123');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('abc123'));
    });
  });

  group('toUpperCase interactions', () {
    test('toUpperCase + matches uppercase pattern passes', () {
      final r = Rule.string(name: 'v')
          .toUpperCase()
          .regex(RegExp(r'^[A-Z]+$'))
          .parse('abc');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('ABC'));
    });

    test('toUpperCase + shouldMatch, compared after uppercasing', () {
      final r =
          Rule.string(name: 'v').toUpperCase().shouldMatch('ABC').parse('abc');
      expect(r.ok, isTrue);
    });

    test('toUpperCase + shouldNotMatch passes', () {
      final r = Rule.string(name: 'v')
          .toUpperCase()
          .shouldNotMatch('abc')
          .parse('abc');
      expect(r.ok, isTrue);
    });

    test('toUpperCase + refine, refine receives uppercased value', () {
      final r = Rule.string(name: 'v')
          .toUpperCase()
          .refine((v) => v == 'ABC' ? null : 'not ABC')
          .parse('abc');
      expect(r.ok, isTrue);
    });
  });

  group('trim + toLowerCase + toUpperCase combined', () {
    test('trim + toLowerCase together', () {
      final r = Rule.string(name: 'Email')
          .trim()
          .toLowerCase()
          .isEmail()
          .parse('  ABC@XYZ.COM  ');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('abc@xyz.com'));
    });

    test('trim + toUpperCase together', () {
      final r =
          Rule.string(name: 'Name').trim().toUpperCase().parse('  john  ');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('JOHN'));
    });

    test('toLowerCase then toUpperCase, last wins', () {
      final r = Rule.string(name: 'v')
          .toLowerCase()
          .toUpperCase()
          .regex(RegExp(r'^[A-Z]+$'))
          .parse('abc');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('ABC'));
    });

    test('toUpperCase then toLowerCase, last wins', () {
      final r = Rule.string(name: 'v')
          .toUpperCase()
          .toLowerCase()
          .regex(RegExp(r'^[a-z]+$'))
          .parse('ABC');
      expect(r.ok, isTrue);
      expect(r.validatedValue, equals('abc'));
    });
  });

  group('refine placeholder combinations', () {
    test('name placeholder resolved', () {
      final r = Rule.string(name: 'Username')
          .refine((v) => '{name} is not allowed')
          .parse('bad');
      expect(r.error?.message, equals('Username is not allowed'));
    });

    test('value placeholder resolved', () {
      final r =
          Rule.string(name: 'v').refine((v) => 'got {value}').parse('hello');
      expect(r.error?.message, equals('got hello'));
    });

    test('both name and value placeholders resolved', () {
      final r = Rule.string(name: 'Field')
          .refine((v) => '{name} received {value}')
          .parse('abc');
      expect(r.error?.message, equals('Field received abc'));
    });

    test('refine after trim sees trimmed value in placeholder', () {
      final r = Rule.string(name: 'v')
          .trim()
          .refine((v) => 'got {value}')
          .parse('  hello  ');
      expect(r.error?.message, equals('got hello'));
    });

    test('refine after toLowerCase sees lowered value in placeholder', () {
      final r = Rule.string(name: 'v')
          .toLowerCase()
          .refine((v) => 'got {value}')
          .parse('HELLO');
      expect(r.error?.message, equals('got hello'));
    });

    test('refine returns null for valid complex logic', () {
      final r = Rule.string(name: 'Code').refine((v) {
        if (v.length != 6) {
          return '{name} must be 6 chars';
        }

        if (!v.startsWith('A')) {
          return '{name} must start with A';
        }

        return null;
      }).parse('A12345');
      expect(r.ok, isTrue);
    });

    test('refine complex logic first condition fails', () {
      final r = Rule.string(name: 'Code').refine((v) {
        if (v.length != 6) {
          return '{name} must be 6 chars';
        }

        if (!v.startsWith('A')) {
          return '{name} must start with A';
        }

        return null;
      }).parse('A123');
      expect(r.error?.message, equals('Code must be 6 chars'));
    });

    test('refine complex logic second condition fails', () {
      final r = Rule.string(name: 'Code').refine((v) {
        if (v.length != 6) {
          return '{name} must be 6 chars';
        }

        if (!v.startsWith('A')) {
          return '{name} must start with A';
        }

        return null;
      }).parse('B12345');
      expect(r.error?.message, equals('Code must start with A'));
    });

    test('refine with forbidden char detection', () {
      final r = Rule.string(name: 'File name').refine((v) {
        final invalid =
            v.split('').where((c) => r'<>:"/\|?*'.contains(c)).toList();

        if (invalid.isEmpty) {
          return null;
        }

        return '{name} "{value}" contains unsupported characters: '
            '${invalid.join(', ')}';
      }).parse('my<file>.txt');
      expect(
        r.error?.message,
        equals(
          'File name "my<file>.txt" contains unsupported characters: <, >',
        ),
      );
    });
  });

  group('check combinations', () {
    test('check fires before refine', () {
      final r = Rule.string(name: 'v')
          .check((v) => false, error: '{name} failed check')
          .refine((v) => 'should not reach')
          .parse('abc');
      expect(r.error?.message, equals('v failed check'));
      expect(r.error?.check, equals(StringCheck.check));
    });

    test('check passes, refine fires', () {
      final r = Rule.string(name: 'v')
          .check((v) => true)
          .refine((v) => 'refine error')
          .parse('abc');
      expect(r.error?.message, equals('refine error'));
      expect(r.error?.check, equals(StringCheck.refine));
    });

    test('check with name placeholder', () {
      final r = Rule.string(name: 'Field')
          .check((v) => false, error: '{name} is bad')
          .parse('abc');
      expect(r.error?.message, equals('Field is bad'));
    });

    test('check passes when predicate returns true', () {
      final r =
          Rule.string(name: 'v').check((v) => v.startsWith('A')).parse('Abc');
      expect(r.ok, isTrue);
    });

    test('check fails when predicate returns false', () {
      final r =
          Rule.string(name: 'v').check((v) => v.startsWith('A')).parse('abc');
      expect(r.hasError, isTrue);
      expect(r.error?.check, equals(StringCheck.check));
    });

    test('multiple checks, first failure wins', () {
      final r = Rule.string(name: 'v')
          .check((v) => false, error: 'first')
          .check((v) => false, error: 'second')
          .parse('abc');
      expect(r.error?.message, equals('first'));
    });

    test('multiple checks, first passes second fails', () {
      final r = Rule.string(name: 'v')
          .check((v) => true, error: 'first')
          .check((v) => false, error: 'second')
          .parse('abc');
      expect(r.error?.message, equals('second'));
    });
  });

  group('isRequired ordering with other checks', () {
    test('isRequired fires before isEmail', () {
      final r = Rule.string(name: 'Email').isRequired().isEmail().parse('');
      expect(r.error?.check, equals(StringCheck.isRequired));
    });

    test('isRequired fires before isNumeric', () {
      final r = Rule.string(name: 'v').isRequired().isNumeric().parse('');
      expect(r.error?.check, equals(StringCheck.isRequired));
    });

    test('isRequired fires before minLength', () {
      final r = Rule.string(name: 'v').isRequired().minLength(3).parse('');
      expect(r.error?.check, equals(StringCheck.isRequired));
    });

    test('isRequired fires before refine', () {
      final r = Rule.string(name: 'v')
          .isRequired()
          .refine((v) => 'should not reach')
          .parse('');
      expect(r.error?.check, equals(StringCheck.isRequired));
    });

    test('isRequired fires before check', () {
      final r = Rule.string(name: 'v')
          .isRequired()
          .check((v) => false, error: 'should not reach')
          .parse('');
      expect(r.error?.check, equals(StringCheck.isRequired));
    });

    test('isRequired with custom error fires before isEmail', () {
      final r = Rule.string(name: 'Email')
          .isRequired(error: 'Enter your email')
          .isEmail()
          .parse('');
      expect(r.error?.message, equals('Enter your email'));
    });
  });

  group('per-check error overrides', () {
    test('isEmail custom error', () {
      final r = Rule.string(name: 'Email')
          .isEmail(error: 'Email is invalid.')
          .parse('notanemail');
      expect(r.error?.message, equals('Email is invalid.'));
    });

    test('isUrl custom error', () {
      final r = Rule.string(name: 'v').isUrl(error: 'Bad URL').parse('notaurl');
      expect(r.error?.message, equals('Bad URL'));
    });

    test('isPhone custom error', () {
      final r = Rule.string(name: 'v').isPhone(error: 'Bad phone').parse('abc');
      expect(r.error?.message, equals('Bad phone'));
    });

    test('isIp custom error', () {
      final r = Rule.string(name: 'v').isIp(error: 'Bad IP').parse('abc');
      expect(r.error?.message, equals('Bad IP'));
    });

    test('isNumeric custom error', () {
      final r =
          Rule.string(name: 'v').isNumeric(error: 'Not a number').parse('abc');
      expect(r.error?.message, equals('Not a number'));
    });

    test('isNumericDecimal custom error', () {
      final r = Rule.string(name: 'v')
          .isNumericDecimal(error: 'Not a decimal')
          .parse('abc');
      expect(r.error?.message, equals('Not a decimal'));
    });

    test('isAlphaSpace custom error', () {
      final r = Rule.string(name: 'v')
          .isAlphaSpace(error: 'Letters only')
          .parse('123');
      expect(r.error?.message, equals('Letters only'));
    });

    test('isAlphaNumeric custom error', () {
      final r = Rule.string(name: 'v')
          .isAlphaNumeric(error: 'Alphanumeric only')
          .parse('abc 123');
      expect(r.error?.message, equals('Alphanumeric only'));
    });

    test('isAlphaNumericSpace custom error', () {
      final r = Rule.string(name: 'v')
          .isAlphaNumericSpace(error: 'Alphanumeric and spaces only')
          .parse('abc@123');
      expect(r.error?.message, equals('Alphanumeric and spaces only'));
    });

    test('minLength custom error', () {
      final r =
          Rule.string(name: 'v').minLength(5, error: 'Too short').parse('abc');
      expect(r.error?.message, equals('Too short'));
    });

    test('maxLength custom error', () {
      final r =
          Rule.string(name: 'v').maxLength(3, error: 'Too long').parse('abcde');
      expect(r.error?.message, equals('Too long'));
    });

    test('length custom error', () {
      final r =
          Rule.string(name: 'v').length(4, error: 'Must be 4').parse('abc');
      expect(r.error?.message, equals('Must be 4'));
    });

    test('greaterThan custom error', () {
      final r =
          Rule.string(name: 'v').greaterThan('b', error: 'Too low').parse('a');
      expect(r.error?.message, equals('Too low'));
    });

    test('lessThan custom error', () {
      final r =
          Rule.string(name: 'v').lessThan('b', error: 'Too high').parse('c');
      expect(r.error?.message, equals('Too high'));
    });

    test('equalTo custom error', () {
      final r = Rule.string(name: 'v')
          .equalTo('abc', error: 'Must be abc')
          .parse('xyz');
      expect(r.error?.message, equals('Must be abc'));
    });

    test('notEqualTo custom error', () {
      final r = Rule.string(name: 'v')
          .notEqualTo('abc', error: 'Cannot be abc')
          .parse('abc');
      expect(r.error?.message, equals('Cannot be abc'));
    });

    test('inList custom error', () {
      final r = Rule.string(name: 'v')
          .inList(['a', 'b'], error: 'Pick a or b').parse('c');
      expect(r.error?.message, equals('Pick a or b'));
    });

    test('notInList custom error', () {
      final r = Rule.string(name: 'v')
          .notInList(['a', 'b'], error: 'Cannot be a or b').parse('a');
      expect(r.error?.message, equals('Cannot be a or b'));
    });

    test('shouldMatch custom error', () {
      final r = Rule.string(name: 'v')
          .shouldMatch('abc', error: 'Must match abc')
          .parse('xyz');
      expect(r.error?.message, equals('Must match abc'));
    });

    test('shouldNotMatch custom error', () {
      final r = Rule.string(name: 'v')
          .shouldNotMatch('xyz', error: 'Cannot be xyz')
          .parse('xyz');
      expect(r.error?.message, equals('Cannot be xyz'));
    });

    test('matches custom error', () {
      final r = Rule.string(name: 'v')
          .regex(RegExp(r'^\d+$'), error: 'Digits only')
          .parse('abc');
      expect(r.error?.message, equals('Digits only'));
    });
  });

  group('validatedValue and hasValidatedValue across types', () {
    test('string present value, hasValidatedValue true', () {
      final r = Rule.string(name: 'v').isRequired().parse('hello');
      expect(r.hasValidatedValue, isTrue);
      expect(r.validatedValue, equals('hello'));
    });

    test('string empty optional, hasValidatedValue false', () {
      final r = Rule.string(name: 'v').parse('');
      expect(r.ok, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });

    test('string null optional, hasValidatedValue false', () {
      final r = Rule.string(name: 'v').parse(null);
      expect(r.ok, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });

    test('string failed validation, hasValidatedValue false', () {
      final r = Rule.string(name: 'v').isEmail().parse('notanemail');
      expect(r.hasError, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });

    test('string after trim, validatedValue is trimmed', () {
      final r = Rule.string(name: 'v').trim().parse('  hello  ');
      expect(r.hasValidatedValue, isTrue);
      expect(r.validatedValue, equals('hello'));
    });

    test('string spaces no trim, hasValidatedValue true value is spaces', () {
      final r = Rule.string(name: 'v').parse('   ');
      expect(r.hasValidatedValue, isTrue);
      expect(r.validatedValue, equals('   '));
    });

    test('string spaces with trim, hasValidatedValue false', () {
      final r = Rule.string(name: 'v').trim().parse('   ');
      expect(r.ok, isTrue);
      expect(r.hasValidatedValue, isFalse);
      expect(r.validatedValue, isNull);
    });
  });

  group('fold result', () {
    test('onValidatedValue promoted for present valid string', () {
      final promoted = Rule.string(name: 'v').isRequired().parse('hello').fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value,
              onNull: () => null,
            ),
            onError: ({required name, required error}) => null,
          );
      expect(promoted, equals('hello'));
    });

    test('onNull promoted for empty optional string', () {
      final nullFired = Rule.string(name: 'v').parse('').fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => false,
              onNull: () => true,
            ),
            onError: ({required name, required error}) => false,
          );
      expect(nullFired, isTrue);
    });

    test('onNull promoted for null optional integer', () {
      final nullFired = Rule.integer(name: 'Age').parse(null).fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => false,
              onNull: () => true,
            ),
            onError: ({required name, required error}) => false,
          );
      expect(nullFired, isTrue);
    });

    test('onValidatedValue promoted for integer zero', () {
      final promoted = Rule.integer(name: 'Score').parse(0).fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value,
              onNull: () => null,
            ),
            onError: ({required name, required error}) => null,
          );
      expect(promoted, equals(0));
    });

    test('onError promoted for failed required string', () {
      final errorMessage = Rule.string(name: 'v').isRequired().parse('').fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => null,
              onNull: () => null,
            ),
            onError: ({required name, required error}) => error.message,
          );
      expect(errorMessage, equals('v is required'));
    });

    test('onError promoted for failed isEmail', () {
      final errorMessage =
          Rule.string(name: 'Email').isEmail().parse('notanemail').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => null,
                  onNull: () => null,
                ),
                onError: ({required name, required error}) => error.message,
              );
      expect(errorMessage, equals('Email is not a valid email address'));
    });

    test('name is passed correctly into onOk', () {
      final foldedName = Rule.string(name: 'MyField').parse('hello').fold(
            onOk: (ok, {required name}) => name,
            onError: ({required name, required error}) => name,
          );
      expect(foldedName, equals('MyField'));
    });

    test('name is passed correctly into onError', () {
      final foldedName =
          Rule.string(name: 'MyField').isRequired().parse('').fold(
                onOk: (ok, {required name}) => name,
                onError: ({required name, required error}) => name,
              );
      expect(foldedName, equals('MyField'));
    });

    test('fold with int from onOk and String from onError both assign', () {
      final result = Rule.string(name: 'Email')
          .isEmail(error: 'Invalid email format')
          .parse('notanemail')
          .fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value.length,
              onNull: () => 0,
            ),
            onError: ({required name, required error}) => error.message,
          );

      expect(result, equals('Invalid email format'));
    });

    test('fold with String from onOk and bool from onError both assign', () {
      final result = Rule.string(name: 'Email')
          .isEmail(error: 'Invalid email format')
          .parse('notanemail')
          .fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value,
              onNull: () => '',
            ),
            onError: ({required name, required error}) => false,
          );

      expect(result, equals(false));
    });

    test('fold with bool from onOk and int from onError both assign', () {
      final result = Rule.string(name: 'Email')
          .isEmail(error: 'Invalid email format')
          .parse('notanemail')
          .fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => true,
              onNull: () => false,
            ),
            onError: ({required name, required error}) => -1,
          );

      expect(result, equals(-1));
    });

    test('onValidatedValue assigns the raw value for required and valid email',
        () {
      final display =
          Rule.string(name: 'Email').isRequired().isEmail().parse('').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value,
                  onNull: () => '',
                ),
                onError: ({required name, required error}) => error.message,
              );
      expect(display, equals('Email is required'));
    });

    test('onValidatedValue assigns the raw value for a valid email', () {
      final display =
          Rule.string(name: 'Email').isEmail().parse('user@example.com').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value,
                  onNull: () => '',
                ),
                onError: ({required name, required error}) => error.message,
              );
      expect(display, equals('user@example.com'));
    });

    test('onValidatedValue assigns a name-prefixed value for a valid email',
        () {
      final display =
          Rule.string(name: 'Email').isEmail().parse('user@example.com').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => '$name: $value',
                  onNull: () => '',
                ),
                onError: ({required name, required error}) => error.message,
              );
      expect(display, equals('Email: user@example.com'));
    });

    test('onValidatedValue assigns an upper-cased value for a valid email', () {
      final display =
          Rule.string(name: 'Email').isEmail().parse('user@example.com').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value.toUpperCase(),
                  onNull: () => '',
                ),
                onError: ({required name, required error}) => error.message,
              );
      expect(display, equals('USER@EXAMPLE.COM'));
    });

    test('onValidatedValue assigns the value length for a valid email', () {
      final length =
          Rule.string(name: 'Email').isEmail().parse('user@example.com').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value.length,
                  onNull: () => 0,
                ),
                onError: ({required name, required error}) => -1,
              );
      expect(length, equals(16));
    });

    test('onValidatedValue assigns true for a valid email', () {
      final isValid =
          Rule.string(name: 'Email').isEmail().parse('user@example.com').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => true,
                  onNull: () => false,
                ),
                onError: ({required name, required error}) => false,
              );
      expect(isValid, isTrue);
    });

    test('onNull assigns empty string for a null optional phone', () {
      final display = Rule.string(name: 'Phone').parse(null).fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value,
              onNull: () => '',
            ),
            onError: ({required name, required error}) => error.message,
          );
      expect(display, equals(''));
    });

    test('onNull assigns a name-prefixed message for an empty optional phone',
        () {
      final display = Rule.string(name: 'Phone').parse('').fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value,
              onNull: () => '$name not provided',
            ),
            onError: ({required name, required error}) => error.message,
          );
      expect(display, equals('Phone not provided'));
    });

    test('onNull assigns a literal placeholder for a null optional phone', () {
      final display = Rule.string(name: 'Phone').parse(null).fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value,
              onNull: () => 'N/A',
            ),
            onError: ({required name, required error}) => error.message,
          );
      expect(display, equals('N/A'));
    });

    test('onNull assigns zero length for an empty optional phone', () {
      final length = Rule.string(name: 'Phone').parse('').fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value.length,
              onNull: () => 0,
            ),
            onError: ({required name, required error}) => -1,
          );
      expect(length, equals(0));
    });

    test('onNull assigns false for a null optional phone', () {
      final isValid = Rule.string(name: 'Phone').parse(null).fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => true,
              onNull: () => false,
            ),
            onError: ({required name, required error}) => false,
          );
      expect(isValid, isFalse);
    });

    test('onError assigns the message for a required empty email', () {
      final display =
          Rule.string(name: 'Email').isRequired().isEmail().parse('').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value,
                  onNull: () => '',
                ),
                onError: ({required name, required error}) => error.message,
              );
      expect(display, equals('Email is required'));
    });

    test('onError assigns a message containing the failure reason', () {
      final display =
          Rule.string(name: 'Email').isEmail().parse('notanemail').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value,
                  onNull: () => '',
                ),
                onError: ({required name, required error}) => error.message,
              );
      expect(display, contains('not a valid email'));
    });

    test('onError assigns a name-prefixed message for an invalid email', () {
      final display =
          Rule.string(name: 'Email').isEmail().parse('notanemail').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value,
                  onNull: () => '',
                ),
                onError: ({required name, required error}) =>
                    '$name: ${error.message}',
              );
      expect(display, contains('Email:'));
    });

    test('onError assigns an upper-cased message for an invalid email', () {
      final display =
          Rule.string(name: 'Email').isEmail().parse('notanemail').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value,
                  onNull: () => '',
                ),
                onError: ({required name, required error}) =>
                    error.message.toUpperCase(),
              );
      expect(display, equals('EMAIL IS NOT A VALID EMAIL ADDRESS'));
    });

    test('onError assigns a formatted message for a custom email error', () {
      final display = Rule.string(name: 'Email')
          .isEmail(error: 'Invalid email format')
          .parse('notanemail')
          .fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => '',
              onNull: () => '',
            ),
            onError: ({required name, required error}) =>
                '[ERROR] ${error.message}',
          );
      expect(display, equals('[ERROR] Invalid email format'));
    });

    test('onOk and onError both assign booleans for an invalid email', () {
      final isValid =
          Rule.string(name: 'Email').isEmail().parse('notanemail').fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => true,
                  onNull: () => true,
                ),
                onError: ({required name, required error}) => false,
              );
      expect(isValid, isFalse);
    });

    test('fold onNull promoted after trim collapses to empty', () {
      final nullFired = Rule.string(name: 'v').trim().parse('   ').fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => false,
              onNull: () => true,
            ),
            onError: ({required name, required error}) => false,
          );
      expect(nullFired, isTrue);
    });

    test('fold onValidatedValue for bool false', () {
      final promoted = Rule.boolean(name: 'Newsletter').parse(false).fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => value,
              onNull: () => null,
            ),
            onError: ({required name, required error}) => null,
          );
      expect(promoted, equals(false));
    });

    test('fold onNull for bool null optional', () {
      final nullFired = Rule.boolean(name: 'Newsletter').parse(null).fold(
            onOk: (ok, {required name}) => ok.fold(
              onValidatedValue: ({required value}) => false,
              onNull: () => true,
            ),
            onError: ({required name, required error}) => false,
          );
      expect(nullFired, isTrue);
    });

    test('fold onValidatedValue for double', () {
      final promoted =
          Rule.double(name: 'Price').greaterThan(0.0).parse(9.99).fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => value,
                  onNull: () => null,
                ),
                onError: ({required name, required error}) => null,
              );
      expect(promoted, equals(9.99));
    });

    test('fold onError for double that fails constraint', () {
      final errorMessage =
          Rule.double(name: 'Price').greaterThan(0.0).parse(-1.5).fold(
                onOk: (ok, {required name}) => ok.fold(
                  onValidatedValue: ({required value}) => null,
                  onNull: () => null,
                ),
                onError: ({required name, required error}) => error.message,
              );
      expect(errorMessage, equals('Price should be greater than 0.0'));
    });
  });
}
