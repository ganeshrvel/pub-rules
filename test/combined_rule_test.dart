import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group('CombinedRule', () {
    test('two required empty fields produce two errors', () {
      final field1 = Rule.string(name: 'name').isRequired().bind('');
      final field2 = Rule.string(name: 'email').isRequired().bind('');
      final combined = CombinedRule(fields: [field1, field2]);

      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 2);
    });

    test('group surfaces an inner required failure', () {
      final field1 = Rule.string(name: 'name').isRequired().bind('');
      final group = GroupRule(
        name: 'name',
        fields: [field1],
        requiredAll: true,
      );
      final combined = CombinedRule(groups: [group]);

      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 1);
    });

    test('maxAllowed exceeded surfaces the custom group error', () {
      final field1 = Rule.string(name: 'name').bind('abc');
      final group = GroupRule(
        name: 'name',
        fields: [field1],
        maxAllowed: 0,
        maxAllowedError: 'Group error',
      );
      final combined = CombinedRule(groups: [group]);

      expect(combined.errorList[0], contains('Group error'));
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 1);
    });

    test('field error inside a group wins over the group constraint', () {
      final field1 = Rule.string(name: 'name').isRequired().bind('');
      final group = GroupRule(
        name: 'name',
        fields: [field1],
        maxAllowed: 0,
        maxAllowedError: 'Group error',
      );
      final combined = CombinedRule(groups: [group]);

      expect(combined.errorList[0], contains('is required'));
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 1);
    });

    test('same failing field counted in fields and inside its group', () {
      final field1 = Rule.string(name: 'name').isRequired().bind('');
      final group = GroupRule(
        name: 'name',
        fields: [field1],
        maxAllowed: 0,
        maxAllowedError: 'Group error',
      );
      final combined = CombinedRule(fields: [field1], groups: [group]);

      expect(combined.errorList[0], contains('is required'));
      expect(combined.errorList[1], contains('is required'));
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 2);
    });

    test('valid field plus exceeded group yields only the group error', () {
      final field1 = Rule.string(name: 'name').isRequired().bind('abc');
      final group = GroupRule(
        name: 'name',
        fields: [field1],
        maxAllowed: 0,
        maxAllowedError: 'Group error',
      );
      final combined = CombinedRule(fields: [field1], groups: [group]);

      expect(combined.errorList[0], contains('Group error'));
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 1);
    });

    test('fields then groups, in declared order, four errors', () {
      final r1 = Rule.string(name: 'name').isRequired().bind('abc');
      final group1 = GroupRule(
        name: 'name',
        fields: [r1],
        maxAllowed: 0,
        maxAllowedError: 'Group 1 error',
      );

      final r2 =
          Rule.string(name: 'name').isRequired().isNumericDecimal().bind('abc');
      final r3 = Rule.string(name: 'value').bind('');
      final group2 = GroupRule(
        name: 'name',
        fields: [r2, r3],
        requiredAtLeast: 2,
        requiredAtLeastError: 'Group 2 error',
      );

      final r4 = Rule.string(name: 'name').isRequired().isNumeric().bind('abc');
      final r5 = Rule.string(name: 'name').isRequired().isEmail().bind('abc');

      final combined = CombinedRule(
        fields: [r4, r5],
        groups: [group1, group2],
      );

      expect(combined.errorList[0], contains('is not a valid number'));
      expect(combined.errorList[1], contains('is not a valid email address'));
      expect(combined.errorList[2], contains('Group 1 error'));
      expect(combined.errorList[3], contains('is not a valid decimal number'));
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 4);
    });

    test('inner field failure surfaces from both groups', () {
      final r1 = Rule.string(name: 'name').isRequired().bind('abc');
      final r11 = Rule.string(name: 'rule11').isEmail().bind('abc');
      final group1 = GroupRule(
        name: 'groupRule1',
        fields: [r1, r11],
        maxAllowed: 0,
      );
      final group2 = GroupRule(
        name: 'groupRule2',
        fields: [r1, r11],
        requiredAtLeast: 2,
        requiredAtLeastError: 'Group 2 error',
      );

      final r4 = Rule.string(name: 'name').isRequired().isNumeric().bind('abc');
      final r5 = Rule.string(name: 'name').isRequired().isEmail().bind('abc');

      final combined = CombinedRule(
        fields: [r4, r5],
        groups: [group1, group2],
      );

      expect(combined.errorList[0], contains('is not a valid number'));
      expect(combined.errorList[1], contains('is not a valid email address'));
      expect(combined.errorList[2], contains('is not a valid email address'));
      expect(
        combined.errorList[3],
        contains('rule11 is not a valid email address'),
      );
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 4);
    });

    test('null entries are skipped, two errors remain', () {
      const RuleField<String>? field1 = null;
      const RuleField<String>? field3 = null;
      const GroupRule? group1 = null;
      const GroupRule? group2 = null;

      final r2 =
          Rule.string(name: 'name').isRequired().isNumericDecimal().bind('1.1');
      final group3 = GroupRule(
        name: 'name',
        fields: [r2],
        maxAllowed: 0,
        maxAllowedError: 'Group 2 error',
      );

      final r4 = Rule.string(name: 'name').isRequired().isNumeric().bind('1.1');

      final combined = CombinedRule(
        fields: [field1, field3, r4],
        groups: [group1, group2, group3],
      );

      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 2);
    });

    test('two empty optional fields produce no error', () {
      final field1 = Rule.string(name: 'name').bind('');
      final field2 = Rule.string(name: 'email').bind('');
      final combined = CombinedRule(fields: [field1, field2]);

      expect(combined.hasError, equals(false));
      expect(combined.errorList.length, 0);
    });

    test('empty group with requiredAll passes', () {
      const group = GroupRule(name: 'name', fields: [], requiredAll: true);
      const combined = CombinedRule(groups: [group]);

      expect(combined.hasError, equals(false));
      expect(combined.errorList.length, 0);
    });

    test('all fields and groups valid produces no error', () {
      final r1 = Rule.string(name: 'name').isRequired().bind('abc');
      final group1 = GroupRule(
        name: 'name',
        fields: [r1],
        maxAllowed: 1,
        maxAllowedError: 'Group 1 error',
      );

      final r2 =
          Rule.string(name: 'name').isRequired().isNumericDecimal().bind('1.1');
      final r3 = Rule.string(name: 'value').bind('abcd');
      final group2 = GroupRule(
        name: 'name',
        fields: [r2, r3],
        requiredAtLeast: 2,
        requiredAtLeastError: 'Group 2 error',
      );

      final r4 = Rule.string(name: 'name').isRequired().isNumeric().bind('10');
      final r5 =
          Rule.string(name: 'name').isRequired().isEmail().bind('abc@xyz.com');

      final combined = CombinedRule(
        fields: [r4, r5],
        groups: [group1, group2],
      );

      expect(combined.hasError, equals(false));
      expect(combined.errorList.length, 0);
    });

    test('empty combined produces no error', () {
      const combined = CombinedRule();

      expect(combined.hasError, equals(false));
      expect(combined.errorList.length, 0);
    });

    test('null entries with a satisfied requiredAtLeast passes', () {
      const RuleField<String>? field1 = null;
      const RuleField<String>? field3 = null;
      const GroupRule? group1 = null;
      const GroupRule? group2 = null;

      final r2 =
          Rule.string(name: 'name').isRequired().isNumericDecimal().bind('1.1');
      final group3 = GroupRule(
        name: 'name',
        fields: [r2],
        requiredAtLeast: 1,
        requiredAtLeastError: 'Group 2 error',
      );

      final combined = CombinedRule(
        fields: [field1, field3],
        groups: [group1, group2, group3],
      );

      expect(combined.hasError, equals(false));
      expect(combined.errorList.length, 0);
    });

    test('matching constraints across a group pass', () {
      final r1 = Rule.string(name: 'value').shouldNotMatch('xyz').bind('abc');
      final r2 = Rule.string(name: 'value')
          .shouldNotMatch('xyz')
          .shouldMatch('abc')
          .bind('abc');
      final group1 = GroupRule(name: 'group name', fields: [r1, r2]);
      final group2 = GroupRule(
        name: 'group name 2',
        fields: [r1, r2],
        requiredAll: true,
      );

      expect(group1.hasError, equals(false));
      expect(group2.hasError, equals(false));
    });
  });

  group('CombinedRule with mixed types', () {
    test('string, int, and bool fields all fail together', () {
      final r1 = Rule.string(name: 'name').isRequired().bind('');
      final r2 = Rule.integer(name: 'age').isRequired().bind(null);
      final r3 = Rule.boolean(name: 'terms').isTrue().bind(false);

      final combined = CombinedRule(fields: [r1, r2, r3]);

      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 3);
      expect(combined.errorList[0], contains('name is required'));
      expect(combined.errorList[1], contains('age is required'));
      expect(combined.errorList[2], contains('terms must be true'));
    });

    test('string, int, bool, and double fields all pass', () {
      final r1 = Rule.string(name: 'name').isRequired().bind('John');
      final r2 = Rule.integer(name: 'age').greaterThan(0).bind(25);
      final r3 = Rule.boolean(name: 'terms').isTrue().bind(true);
      final r4 = Rule.double(name: 'price').greaterThan(0.0).bind(9.99);

      final combined = CombinedRule(fields: [r1, r2, r3, r4]);

      expect(combined.hasError, equals(false));
      expect(combined.errorList.length, 0);
    });

    test('mixed-type group requiring all fails when one is absent', () {
      final r1 = Rule.string(name: 'name').bind('John');
      final r2 = Rule.integer(name: 'age').bind(null);
      final group = GroupRule(
        name: 'profile',
        fields: [r1, r2],
        requiredAll: true,
      );
      final combined = CombinedRule(groups: [group]);

      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 1);
      expect(combined.errorList[0],
          contains('All fields are mandatory in profile'),);
    });

    test('mixed-type group requiredAtLeast satisfied by bool and double', () {
      final r1 = Rule.string(name: 'nickname').bind('');
      final r2 = Rule.boolean(name: 'subscribed').bind(true);
      final r3 = Rule.double(name: 'rating').bind(4.5);
      final group = GroupRule(
        name: 'preferences',
        fields: [r1, r2, r3],
        requiredAtLeast: 2,
      );

      expect(group.hasError, equals(false));
    });

    test('mixed-type group maxAllowed exceeded across int and double', () {
      final r1 = Rule.integer(name: 'primaryPhone').bind(1234567890);
      final r2 = Rule.double(name: 'secondaryPhone').bind(9876543210.0);
      final group = GroupRule(
        name: 'contact',
        fields: [r1, r2],
        maxAllowed: 1,
        maxAllowedError: 'Choose only one contact method',
      );
      final combined = CombinedRule(groups: [group]);

      expect(combined.errorList[0], equals('Choose only one contact method'));
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 1);
    });

    test('bool field failure inside group wins over requiredAll', () {
      final r1 = Rule.boolean(name: 'terms').isRequired().isTrue().bind(false);
      final group = GroupRule(
        name: 'agreement',
        fields: [r1],
        requiredAll: true,
      );
      final combined = CombinedRule(groups: [group]);

      expect(combined.errorList[0], contains('terms must be true'));
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 1);
    });

    test('double field failure inside group wins over maxAllowed', () {
      final r1 = Rule.double(name: 'price').greaterThan(0.0).bind(-5.0);
      final group = GroupRule(
        name: 'pricing',
        fields: [r1],
        maxAllowed: 0,
        maxAllowedError: 'Pricing group error',
      );
      final combined = CombinedRule(groups: [group]);

      expect(
          combined.errorList[0], contains('price should be greater than 0.0'),);
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 1);
    });

    test('same failing int field counted directly and inside its group', () {
      final r1 = Rule.integer(name: 'age').isRequired().bind(null);
      final group = GroupRule(
        name: 'profile',
        fields: [r1],
        maxAllowed: 0,
        maxAllowedError: 'Profile group error',
      );
      final combined = CombinedRule(fields: [r1], groups: [group]);

      expect(combined.errorList[0], contains('age is required'));
      expect(combined.errorList[1], contains('age is required'));
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 2);
    });

    test('fields then groups across four types, in declared order', () {
      final r1 = Rule.string(name: 'name').isRequired().isEmail().bind('abc');
      final r2 = Rule.integer(name: 'age').greaterThan(18).bind(10);
      final group1 = GroupRule(
        name: 'group1',
        fields: [Rule.boolean(name: 'terms').isTrue().bind(false)],
        maxAllowed: 0,
        maxAllowedError: 'Group 1 error',
      );
      final group2 = GroupRule(
        name: 'group2',
        fields: [Rule.double(name: 'price').greaterThan(0.0).bind(-1.0)],
        requiredAtLeast: 2,
        requiredAtLeastError: 'Group 2 error',
      );

      final combined = CombinedRule(
        fields: [r1, r2],
        groups: [group1, group2],
      );

      expect(combined.errorList[0], contains('is not a valid email address'));
      expect(combined.errorList[1], contains('age should be greater than 18'));
      expect(combined.errorList[2], contains('terms must be true'));
      expect(
          combined.errorList[3], contains('price should be greater than 0.0'),);
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 4);
    });

    test('null entries mixed with int, bool, and double fields are skipped',
        () {
      const RuleField<int>? field1 = null;
      const RuleField<bool>? field2 = null;
      const GroupRule? group1 = null;

      final r3 = Rule.double(name: 'price').greaterThan(0.0).bind(-2.0);
      final group2 = GroupRule(
        name: 'pricing',
        fields: [r3],
        maxAllowed: 0,
        maxAllowedError: 'Pricing error',
      );

      final r4 = Rule.integer(name: 'age').isRequired().bind(null);

      final combined = CombinedRule(
        fields: [field1, field2, r4],
        groups: [group1, group2],
      );

      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 2);
    });

    test('all four types valid together with no errors', () {
      final r1 = Rule.string(name: 'name').isRequired().bind('John');
      final r2 = Rule.integer(name: 'age').greaterThan(0).bind(30);
      final r3 = Rule.boolean(name: 'terms').isTrue().bind(true);
      final r4 = Rule.double(name: 'price').greaterThan(0.0).bind(9.99);

      final group = GroupRule(
        name: 'allValid',
        fields: [r1, r2, r3, r4],
        requiredAll: true,
      );

      final combined = CombinedRule(
        fields: [r1, r2, r3, r4],
        groups: [group],
      );

      expect(combined.hasError, equals(false));
      expect(combined.errorList.length, 0);
    });
  });

  group('CombinedRule and GroupRule custom message templates', () {
    test('requiredAll custom error substitutes the group name', () {
      final r1 = Rule.string(name: 'firstName').bind('');
      final group = GroupRule(
        name: 'Personal Info',
        fields: [r1],
        requiredAll: true,
        requiredAllError: '{name} needs every field filled in',
      );

      expect(group.error, equals('Personal Info needs every field filled in'));
    });

    test('requiredAtLeast custom error substitutes the group name', () {
      final r1 = Rule.string(name: 'email').bind('');
      final r2 = Rule.string(name: 'phone').bind('');
      final group = GroupRule(
        name: 'Contact Method',
        fields: [r1, r2],
        requiredAtLeast: 1,
        requiredAtLeastError: 'Pick at least one option in {name}',
      );

      expect(group.error, equals('Pick at least one option in Contact Method'));
    });

    test('maxAllowed custom error substitutes the group name', () {
      final r1 = Rule.string(name: 'email').bind('a');
      final r2 = Rule.string(name: 'phone').bind('b');
      final group = GroupRule(
        name: 'Preferred Contact',
        fields: [r1, r2],
        maxAllowed: 1,
        maxAllowedError: 'Too many choices in {name}',
      );

      expect(group.error, equals('Too many choices in Preferred Contact'));
    });

    test('requiredAll default message uses the built-in template', () {
      final r1 = Rule.boolean(name: 'flag').bind(null);
      final group = GroupRule(
        name: 'Settings',
        fields: [r1],
        requiredAll: true,
      );

      expect(group.error, equals('All fields are mandatory in Settings'));
    });

    test('requiredAtLeast default message pluralizes for more than one field',
        () {
      final r1 = Rule.integer(name: 'a').bind(null);
      final r2 = Rule.integer(name: 'b').bind(null);
      final r3 = Rule.integer(name: 'c').bind(null);
      final group = GroupRule(
        name: 'Numbers',
        fields: [r1, r2, r3],
        requiredAtLeast: 2,
      );

      expect(group.error, equals('At least 2 fields are required in Numbers'));
    });

    test('requiredAtLeast default message stays singular for exactly one', () {
      final r1 = Rule.integer(name: 'a').bind(null);
      final group = GroupRule(
        name: 'Numbers',
        fields: [r1],
        requiredAtLeast: 1,
      );

      expect(group.error, equals('At least 1 field is required in Numbers'));
    });

    test('maxAllowed default message pluralizes for more than one field', () {
      final r1 = Rule.double(name: 'a').bind(1.0);
      final r2 = Rule.double(name: 'b').bind(2.0);
      final r3 = Rule.double(name: 'c').bind(3.0);
      final group = GroupRule(
        name: 'Numbers',
        fields: [r1, r2, r3],
        maxAllowed: 1,
      );

      expect(group.error, equals('A maximum of 1 field is allowed in Numbers'));
    });

    test('maxAllowed default message stays singular for exactly one allowed',
        () {
      final r1 = Rule.double(name: 'a').bind(1.0);
      final r2 = Rule.double(name: 'b').bind(2.0);
      final group = GroupRule(
        name: 'Numbers',
        fields: [r1, r2],
        maxAllowed: 1,
      );

      expect(group.error, equals('A maximum of 1 field is allowed in Numbers'));
    });

    test('combined surfaces a templated group error alongside field errors',
        () {
      final r1 = Rule.string(name: 'username').isRequired().bind('');
      final r2 = Rule.boolean(name: 'terms').bind(null);
      final group = GroupRule(
        name: 'Sign Up',
        fields: [r2],
        requiredAll: true,
        requiredAllError: 'Complete every field in {name} to continue',
      );

      final combined = CombinedRule(fields: [r1], groups: [group]);

      expect(combined.errorList[0], contains('username is required'));
      expect(
        combined.errorList[1],
        equals('Complete every field in Sign Up to continue'),
      );
      expect(combined.hasError, equals(true));
      expect(combined.errorList.length, 2);
    });
  });
}
