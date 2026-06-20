import 'package:rules/rules.dart';
import 'package:test/test.dart';

void main() {
  group('field-level failures surface first', () {
    test('a required empty field fails the group', () {
      final field = Rule.string(name: 'name').isRequired().bind('');
      final group = GroupRule(name: 'group name', fields: [field]);

      expect(group.hasError, equals(true));
    });

    test('null field entries are skipped', () {
      const RuleField<String>? field1 = null;
      final field2 = Rule.string(name: 'name').isRequired().bind('');
      final group = GroupRule(name: 'group name', fields: [field1, field2]);

      expect(group.hasError, equals(true));
    });

    test('an empty optional field passes', () {
      final field = Rule.string(name: 'Name').bind('');
      final group = GroupRule(name: 'group name', fields: [field]);

      expect(group.hasError, equals(false));
    });

    test('all-null fields pass', () {
      const RuleField<String>? field1 = null;
      const RuleField<String>? field2 = null;
      const group = GroupRule(name: 'group name', fields: [field1, field2]);

      expect(group.hasError, equals(false));
    });

    test('present required field with a null sibling passes', () {
      const RuleField<String>? field1 = null;
      final field2 = Rule.string(name: 'name').isRequired().bind('abc');
      final group = GroupRule(name: 'group name', fields: [field1, field2]);

      expect(group.hasError, equals(false));
    });

    test('a typed validator failure surfaces through the group', () {
      final field = Rule.string(name: 'value').isEmail().bind('0');
      final group = GroupRule(name: 'group name', fields: [field]);

      expect(group.error, contains('is not a valid email address'));
      expect(group.hasError, equals(true));
    });

    test('a valid field passes the group', () {
      final field = Rule.string(name: 'value').isEmail().bind('abc@xyz.com');
      final group = GroupRule(name: 'group name', fields: [field]);

      expect(group.hasError, equals(false));
    });
  });

  group('custom field errors surface through the group', () {
    test('custom required message surfaces', () {
      final field = Rule.string(name: 'Name')
          .isRequired(error: 'Name is invalid.')
          .bind('');
      final group = GroupRule(name: 'group name', fields: [field]);

      expect(group.error, equals('Name is invalid.'));
      expect(group.hasError, equals(true));
    });

    test('custom group maxAllowed message surfaces', () {
      final field = Rule.string(name: 'Name').isRequired().bind('abc');
      final group = GroupRule(
        name: 'group name',
        fields: [field],
        maxAllowed: 0,
        maxAllowedError: 'This is a master group error',
      );

      expect(group.error, equals('This is a master group error'));
      expect(group.hasError, equals(true));
    });

    test('an optional empty field passes regardless of its custom message', () {
      final field = Rule.string(name: 'Name').bind('');
      final group = GroupRule(name: 'group name', fields: [field]);

      expect(group.hasError, equals(false));
    });
  });

  group('requiredAll', () {
    test('a single absent field fails requiredAll', () {
      final field = Rule.string(name: 'name').bind('');
      final group = GroupRule(
        name: 'group name',
        fields: [field],
        requiredAll: true,
      );

      expect(group.error, contains('All fields are mandatory in group name'));
      expect(group.hasError, equals(true));
    });

    test('any absent field fails requiredAll', () {
      final field1 = Rule.string(name: 'name').bind('');
      final field2 = Rule.string(name: 'name').bind(null);
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAll: true,
      );

      expect(group.error, contains('All fields are mandatory in group name'));
      expect(group.hasError, equals(true));
    });

    test('one present and one absent still fails requiredAll', () {
      final field1 = Rule.string(name: 'name').bind('123');
      final field2 = Rule.string(name: 'name').bind(null);
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAll: true,
      );

      expect(group.error, contains('All fields are mandatory in group name'));
      expect(group.hasError, equals(true));
    });

    test('all present passes requiredAll', () {
      final field1 = Rule.string(name: 'name').bind('abc');
      final field2 = Rule.string(name: 'name').bind('xyz');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAll: true,
      );

      expect(group.hasError, equals(false));
    });
  });

  group('requiredAtLeast', () {
    test('requiredAtLeast 0 always passes', () {
      final field1 = Rule.string(name: 'value').bind('');
      final field2 = Rule.string(name: 'value').bind('');
      final group = GroupRule(
        name: 'group rule',
        fields: [field1, field2],
        requiredAtLeast: 0,
      );

      expect(group.hasError, equals(false));
    });

    test('one present satisfies requiredAtLeast 1', () {
      final field1 = Rule.string(name: 'name').bind('abc');
      final field2 = Rule.string(name: 'name').bind(null);
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAtLeast: 1,
      );

      expect(group.hasError, equals(false));
    });

    test('three present satisfies requiredAtLeast 3', () {
      final field1 = Rule.string(name: 'name').bind('abc');
      final field2 = Rule.string(name: 'name').bind('xyz');
      final field3 = Rule.string(name: 'name').bind('123');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2, field3],
        requiredAtLeast: 3,
      );

      expect(group.hasError, equals(false));
    });

    test('too few present fails requiredAtLeast', () {
      final field1 = Rule.string(name: 'name').bind('abc');
      final field2 = Rule.string(name: 'name').bind('');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAtLeast: 2,
      );

      expect(
        group.error,
        contains('At least 2 fields are required in group name'),
      );
      expect(group.hasError, equals(true));
    });

    test('singular wording for requiredAtLeast 1', () {
      final field1 = Rule.string(name: 'name').bind('');
      final group = GroupRule(
        name: 'group name',
        fields: [field1],
        requiredAtLeast: 1,
      );

      expect(
        group.error,
        contains('At least 1 field is required in group name'),
      );
      expect(group.hasError, equals(true));
    });
  });

  group('maxAllowed', () {
    test('exceeding the max fails with singular and plural wording', () {
      final field1 = Rule.string(name: 'name').bind('abc');
      final field2 = Rule.string(name: 'name').bind('xyz');
      final field3 = Rule.string(name: 'name').bind('123');
      final group1 = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        maxAllowed: 1,
      );
      final group2 = GroupRule(
        name: 'group name',
        fields: [field1, field2, field3],
        maxAllowed: 2,
      );

      expect(
        group1.error,
        contains('A maximum of 1 field is allowed in group name'),
      );
      expect(group1.hasError, equals(true));
      expect(
        group2.error,
        contains('A maximum of 2 fields are allowed in group name'),
      );
      expect(group2.hasError, equals(true));
    });

    test('empty group never exceeds the max', () {
      const group = GroupRule(name: 'group name', fields: [], maxAllowed: 1);

      expect(group.hasError, equals(false));
    });

    test('maxAllowed 0 fails when a value is present', () {
      final field1 = Rule.string(name: 'name').bind('abc');
      const group1 = GroupRule(name: 'group name', fields: [], maxAllowed: 0);
      final group2 =
          GroupRule(name: 'group name', fields: [field1], maxAllowed: 0);

      expect(group1.hasError, equals(false));
      expect(
        group2.error,
        contains('A maximum of 0 fields are allowed in group name'),
      );
      expect(group2.hasError, equals(true));
    });

    test('absent values do not count toward maxAllowed', () {
      final field1 = Rule.string(name: 'value').bind(null);
      final field2 = Rule.string(name: 'value').bind('');
      final group = GroupRule(
        name: 'group rule',
        fields: [field1, field2],
        maxAllowed: 1,
      );

      expect(group.hasError, equals(false));
    });

    test('present count equal to max passes', () {
      final field1 = Rule.string(name: 'value').bind('1');
      final field2 = Rule.string(name: 'value').bind('2');
      final group = GroupRule(
        name: 'group rule',
        fields: [field1, field2],
        maxAllowed: 2,
      );

      expect(group.hasError, equals(false));
    });

    test('present count below max passes', () {
      final field1 = Rule.string(name: 'value').bind('1');
      final field2 = Rule.string(name: 'value').bind('2');
      final group = GroupRule(
        name: 'group rule',
        fields: [field1, field2],
        maxAllowed: 3,
      );

      expect(group.hasError, equals(false));
    });
  });

  group('matching constraints across a group', () {
    test('non-matching constraints pass', () {
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

  group('mixed-type fields in a group', () {
    test('int and bool fields validated together in a group', () {
      final r1 = Rule.integer(name: 'age').isRequired().bind(null);
      final r2 = Rule.boolean(name: 'terms').isTrue().bind(false);
      final group = GroupRule(name: 'signup', fields: [r1, r2]);

      expect(group.error, contains('age is required'));
      expect(group.hasError, equals(true));
    });

    test('first field passes, second field fails, group surfaces the second',
        () {
      final r1 = Rule.boolean(name: 'terms').isTrue().bind(true);
      final r2 = Rule.double(name: 'price').greaterThan(0.0).bind(-5.0);
      final group = GroupRule(name: 'checkout', fields: [r1, r2]);

      expect(group.error, contains('price should be greater than 0.0'));
      expect(group.hasError, equals(true));
    });

    test('mixed types all valid pass the group', () {
      final r1 = Rule.string(name: 'name').isRequired().bind('John');
      final r2 = Rule.integer(name: 'age').greaterThan(0).bind(25);
      final r3 = Rule.boolean(name: 'terms').isTrue().bind(true);
      final r4 = Rule.double(name: 'price').greaterThan(0.0).bind(9.99);
      final group = GroupRule(
        name: 'profile',
        fields: [r1, r2, r3, r4],
        requiredAll: true,
      );

      expect(group.hasError, equals(false));
    });

    test('mixed-type requiredAtLeast satisfied by non-string fields', () {
      final r1 = Rule.string(name: 'nickname').bind('');
      final r2 = Rule.integer(name: 'age').bind(25);
      final r3 = Rule.boolean(name: 'subscribed').bind(true);
      final group = GroupRule(
        name: 'preferences',
        fields: [r1, r2, r3],
        requiredAtLeast: 2,
      );

      expect(group.hasError, equals(false));
    });

    test('mixed-type maxAllowed exceeded across double and int', () {
      final r1 = Rule.double(name: 'primary').bind(1.5);
      final r2 = Rule.integer(name: 'secondary').bind(2);
      final group = GroupRule(
        name: 'contact',
        fields: [r1, r2],
        maxAllowed: 1,
      );

      expect(
          group.error, contains('A maximum of 1 field is allowed in contact'),);
      expect(group.hasError, equals(true));
    });
  });

  group('custom messages for requiredAtLeast and maxAllowed', () {
    test('custom requiredAtLeast message overrides the default', () {
      final field1 = Rule.string(name: 'email').bind('');
      final field2 = Rule.string(name: 'phone').bind('');
      final group = GroupRule(
        name: 'contact',
        fields: [field1, field2],
        requiredAtLeast: 1,
        requiredAtLeastError: 'Pick at least one contact method',
      );

      expect(group.error, equals('Pick at least one contact method'));
      expect(group.hasError, equals(true));
    });

    test('custom maxAllowed message overrides the default', () {
      final field1 = Rule.string(name: 'email').bind('a');
      final field2 = Rule.string(name: 'phone').bind('b');
      final group = GroupRule(
        name: 'contact',
        fields: [field1, field2],
        maxAllowed: 1,
        maxAllowedError: 'Choose only one contact method',
      );

      expect(group.error, equals('Choose only one contact method'));
      expect(group.hasError, equals(true));
    });

    test('custom requiredAll message overrides the default', () {
      final field = Rule.string(name: 'name').bind('');
      final group = GroupRule(
        name: 'profile',
        fields: [field],
        requiredAll: true,
        requiredAllError: 'Every field in profile is mandatory',
      );

      expect(group.error, equals('Every field in profile is mandatory'));
      expect(group.hasError, equals(true));
    });

    test('custom message substitutes the group name placeholder', () {
      final field = Rule.string(name: 'name').bind('');
      final group = GroupRule(
        name: 'Personal Info',
        fields: [field],
        requiredAll: true,
        requiredAllError: 'Complete every field in {name} to continue',
      );

      expect(group.error,
          equals('Complete every field in Personal Info to continue'),);
    });
  });

  group('multiple group constraints combined', () {
    test('requiredAtLeast checked before maxAllowed when both configured', () {
      final field1 = Rule.string(name: 'a').bind('');
      final field2 = Rule.string(name: 'b').bind('');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAtLeast: 1,
        maxAllowed: 1,
      );

      expect(
          group.error, contains('At least 1 field is required in group name'),);
    });

    test('maxAllowed evaluated when requiredAtLeast already satisfied', () {
      final field1 = Rule.string(name: 'a').bind('x');
      final field2 = Rule.string(name: 'b').bind('y');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAtLeast: 1,
        maxAllowed: 1,
      );

      expect(group.error,
          contains('A maximum of 1 field is allowed in group name'),);
    });

    test('requiredAll checked before requiredAtLeast when both configured', () {
      final field1 = Rule.string(name: 'a').bind('');
      final field2 = Rule.string(name: 'b').bind('x');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAll: true,
        requiredAtLeast: 1,
      );

      expect(group.error, contains('All fields are mandatory in group name'));
    });

    test('all three constraints satisfied simultaneously passes', () {
      final field1 = Rule.string(name: 'a').bind('x');
      final field2 = Rule.string(name: 'b').bind('y');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAll: true,
        requiredAtLeast: 1,
        maxAllowed: 2,
      );

      expect(group.hasError, equals(false));
    });
  });

  group('boundary and edge cases', () {
    test('requiredAtLeast negative value never fails', () {
      final field1 = Rule.string(name: 'a').bind('');
      final group = GroupRule(
        name: 'group name',
        fields: [field1],
        requiredAtLeast: -1,
      );

      expect(group.hasError, equals(false));
    });

    test('empty fields list with requiredAtLeast 0 passes', () {
      const group = GroupRule(
        name: 'group name',
        fields: [],
        requiredAtLeast: 0,
      );

      expect(group.hasError, equals(false));
    });

    test('single field exactly meeting requiredAtLeast passes', () {
      final field1 = Rule.string(name: 'a').bind('x');
      final group = GroupRule(
        name: 'group name',
        fields: [field1],
        requiredAtLeast: 1,
      );

      expect(group.hasError, equals(false));
    });

    test('group with only null entries and requiredAll passes', () {
      const RuleField<String>? field1 = null;
      const RuleField<String>? field2 = null;
      const group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAll: true,
      );

      expect(group.hasError, equals(false));
    });

    test('group with only null entries and maxAllowed 0 passes', () {
      const RuleField<String>? field1 = null;
      const group = GroupRule(
        name: 'group name',
        fields: [field1],
        maxAllowed: 0,
      );

      expect(group.hasError, equals(false));
    });

    test('field-level failure wins even when group constraints would also pass',
        () {
      final field1 = Rule.string(name: 'email').isEmail().bind('notanemail');
      final group = GroupRule(
        name: 'group name',
        fields: [field1],
        requiredAtLeast: 0,
        maxAllowed: 5,
      );

      expect(group.error, contains('is not a valid email address'));
      expect(group.hasError, equals(true));
    });
  });

  group('matching constraints across mixed-type fields', () {
    test('numeric equality constraints pass across a group', () {
      final r1 = Rule.integer(name: 'a').equalTo(5).bind(5);
      final r2 = Rule.double(name: 'b').equalTo(5.0).bind(5.0);
      final group = GroupRule(name: 'group name', fields: [r1, r2]);

      expect(group.hasError, equals(false));
    });

    test('one numeric mismatch fails the group', () {
      final r1 = Rule.integer(name: 'a').equalTo(5).bind(5);
      final r2 = Rule.double(name: 'b').equalTo(5.0).bind(6.0);
      final group = GroupRule(name: 'group name', fields: [r1, r2]);

      expect(group.error, contains('should be equal to 5'));
      expect(group.hasError, equals(true));
    });
  });


  group('trim and presence inside a group', () {
    test('all-spaces field without trim counts as present', () {
      final field = Rule.string(name: 'name').bind('   ');
      final group = GroupRule(
        name: 'group name',
        fields: [field],
        requiredAtLeast: 1,
      );

      expect(group.hasError, equals(false));
    });

    test('all-spaces field with trim counts as absent', () {
      final field = Rule.string(name: 'name').trim().bind('   ');
      final group = GroupRule(
        name: 'group name',
        fields: [field],
        requiredAtLeast: 1,
      );

      expect(group.error, contains('At least 1 field is required in group name'));
      expect(group.hasError, equals(true));
    });

    test('all-spaces field with trim and isRequired fails as a field error, not a group error', () {
      final field = Rule.string(name: 'name').isRequired().trim().bind('   ');
      final group = GroupRule(
        name: 'group name',
        fields: [field],
        requiredAtLeast: 1,
      );

      expect(group.error, equals('name is required'));
      expect(group.hasError, equals(true));
    });

    test('spaces around real content with trim still counts as present', () {
      final field = Rule.string(name: 'name').trim().bind('  john  ');
      final group = GroupRule(
        name: 'group name',
        fields: [field],
        requiredAtLeast: 1,
      );

      expect(group.hasError, equals(false));
    });

    test('one trimmed-empty field and one real field satisfies requiredAtLeast 1', () {
      final field1 = Rule.string(name: 'a').trim().bind('   ');
      final field2 = Rule.string(name: 'b').trim().bind('  hello  ');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAtLeast: 1,
      );

      expect(group.hasError, equals(false));
    });

    test('trimmed-empty fields do not count toward maxAllowed', () {
      final field1 = Rule.string(name: 'a').trim().bind('   ');
      final field2 = Rule.string(name: 'b').trim().bind('   ');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        maxAllowed: 0,
      );

      expect(group.hasError, equals(false));
    });

    test('untrimmed all-spaces fields do count toward maxAllowed', () {
      final field1 = Rule.string(name: 'a').bind('   ');
      final field2 = Rule.string(name: 'b').bind('   ');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        maxAllowed: 0,
      );

      expect(group.error, contains('A maximum of 0 fields are allowed in group name'));
      expect(group.hasError, equals(true));
    });

    test('trim makes requiredAll fail when content trims to nothing', () {
      final field1 = Rule.string(name: 'a').trim().bind('  hello  ');
      final field2 = Rule.string(name: 'b').trim().bind('   ');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAll: true,
      );

      expect(group.error, contains('All fields are mandatory in group name'));
      expect(group.hasError, equals(true));
    });

    test('without trim, all-spaces fields satisfy requiredAll', () {
      final field1 = Rule.string(name: 'a').bind('  hello  ');
      final field2 = Rule.string(name: 'b').bind('   ');
      final group = GroupRule(
        name: 'group name',
        fields: [field1, field2],
        requiredAll: true,
      );

      expect(group.hasError, equals(false));
    });
  });
}
