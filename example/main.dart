/// Usage examples:
///
/// For more examples refer to https://github.com/ganeshrvel/pub-rules/blob/master/README.md

import 'package:rules/rules.dart';
import 'package:rules/src/helpers/logging.dart';

void rule() {
  const textFieldValue = 'abc@xyz';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isRequired: true,
    isEmail: true,
  );

  log(rule.error);
  // output: 'Text field is not a valid email address'
  log(rule.hasError);
  // output: true

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}

void groupRule() {
  const textFieldValue1 = ''; // or const textFieldValue = null;
  const textFieldValue2 = '';

  final rule1 = Rule(
    textFieldValue1,
    name: 'Text field 1',
    isRequired: true,
  );

  final rule2 = Rule(
    textFieldValue2,
    name: 'Text field 2',
    isEmail: true,
  );

  final groupRule = GroupRule(
    [rule1, rule2], // value; List of Rule
    name:
        'Group name', // placeholder value which will be used while displaying errors
  );

  log(groupRule.error);
  // output: 'Text field 1 is required'
  log(groupRule.hasError);
  // output: true
}

void combinedRule() {
  const textFieldValue1 = '';
  const textFieldValue2 = 'abc@xyz.com';

  final rule1 = Rule(
    textFieldValue1,
    name: 'Text field 1',
  ); // Validation OK
  final rule2 = Rule(
    textFieldValue2,
    name: 'Text field 2',
    isEmail: true,
  ); // Validation OK
  final groupRule = GroupRule([rule1, rule2],
      name: 'Group name', requiredAll: true); // Validation FAILED

  const textFieldValue3 = '';
  final rule3 = Rule(
    textFieldValue3,
    name: 'Text field 3',
    isRequired: true,
  ); // Validation FAILED

  final combinedRule = CombinedRule(
    rules: [rule3],
    groupRules: [groupRule],
  );

  log(combinedRule.errorList);
  // output: ['Text field 3 is required', 'All fields are mandatory in Group name']

  log(combinedRule.hasError);
  // output: true

  if (combinedRule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
