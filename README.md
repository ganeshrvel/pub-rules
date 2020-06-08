### Introduction

##### Rules - Validation library for Dart and Flutter.

**Rules** is a simple yet powerful and feature-rich validation library for both dart and flutter. Less boilerplate code, easy to understand and developer-friendly.

### Installation

Go to https://pub.dev/packages/rules#-installing-tab- for the latest version of **rules**

### Concept

The Rules library has three parts
- Rule: Basic rule
- GroupRule: Group together the basic rules
- CombinedRule: Manage basic and group rules


### Usage

**Import the library**
```dart
import 'package:rules/rules.dart';
```

#### 1. Rule (Basic Rule)
These are the basic building blocks of the Rules library.

**Basic example**
```dart
const textFieldValue = 'abc@xyz.com';

final rule = Rule(
  textFieldValue, // value; string and null are accepted
  name: 'Text field' // placeholder value which will be used while displaying errors
);

print(rule.error);
// output: null
print(rule.hasError);
// output: false
```

**Example 1**
```dart
const textFieldValue = '';  // or const textFieldValue = null;

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isRequired: true,
);

print(rule.error);
// output: 'Text field is required'
print(rule.hasError);
// output: true

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

**Example 2**
```dart
const textFieldValue = 'abc@xyz';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isRequired: true,
  isEmail: true,
);

print(rule.error);
// output: 'Text field is not a valid email address'
print(rule.hasError);
// output: true

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

**Available options**
```dart
final String name; // mandatory

final bool isRequired;

final bool isEmail;

final bool isUrl;

final bool isPhone;

final bool isIp;

final bool isNumeric;

bool isNumericDecimal;

final bool isAlphaSpace;

final bool isAlphaNumeric;

final bool isAlphaNumericSpace;

final String regex;

final int length;

final int minLength;

final int maxLength;

final double greaterThan;

final double greaterThanEqualTo;

final double lessThan;

final double lessThanEqualTo;

final double equalTo;

final double notEqualTo;

final List<double> equalToInList;

final List<double> notEqualToInList;

final String shouldMatch;

final String shouldNotMatch;

final List<String> inList;

final List<String> notInList;

final String customErrorText;

final Map<String, String> customErrors;
```

###### isRequired: `bool`

```dart
const textFieldValue = '123';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isRequired: true, // throws an error for value = null or an empty string
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

- IMPORTANT: If the value is empty or null and 'isRequired' is false or not set then no errors will be thrown for the subsequent constraints.

```dart
const textFieldValue = ''; // or null

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isRequired: false,
  isEmail: true,
);

print(rule.hasError);
// output: false
```

###### isEmail: `bool`
```dart
const textFieldValue = 'abc@xyz.com';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isEmail: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### isUrl: `bool`
```dart
const textFieldValue = 'http://www.google.com';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isUrl: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### isPhone: `bool`
- It recognizes phone numbers starting with **+** or **0**, no length limitations and handles `#, x, ext, extension` extension conventions.

```dart
const textFieldValue = '+1-9090909090';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isPhone: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### isIp: `bool`
- It accepts both IPv4 and IPv6 addresses.


```dart
const textFieldValue = '1.1.1.1';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isIp: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### isNumeric: `bool`
- It accepts both 0, positive and negative integers. Decimals are not allowed.


```dart
const textFieldValue = '1'; // '-1', '0'

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isNumeric: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### isNumericDecimal: `bool`
- It accepts 0, postive and negative integers and decimals numbers.


```dart
const textFieldValue = '10.01'; // '-10.01' or '0.001'

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isNumericDecimal: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### isAlphaSpace: `bool`
- It accepts multiple spaces and alphabets (both upper and lower case).


```dart
const textFieldValue = 'Jane Doe';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isAlphaSpace: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### isAlphaNumeric: `bool`
- It accepts alphabets (both upper and lower case) and numbers.

```dart
const textFieldValue = 'username123';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isAlphaNumeric: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### isAlphaNumericSpace: `bool`
- It accepts multiple spaces, alphabets (both upper and lower case) and numbers.

```dart
const textFieldValue = 'Bread 20';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isAlphaNumericSpace: true,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### regex: `String`
- It accepts a custom regular expression string.

```dart
const textFieldValue = r'^[a-zA-Z0-9\s]+$';

final rule = Rule(
  textFieldValue,
  name: 'Text field'
  regex: r'^[a-zA-Z0-9\s]+$',
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### length: `int`
- Defines the length of the input string.

```dart
const textFieldValue = '9090909090';

final rule = Rule(
  textFieldValue,
  name: 'Phone Number'
  length: 10,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### minLength: `int`
- Defines the minimum length of the input string.


```dart
const textFieldValue = 'abcd12345';

final rule = Rule(
  textFieldValue,
  name: 'Password',
  minLength: 6,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### maxLength: `int`
- Defines the maximum length of the input string.

```dart
const textFieldValue = 'username12';

final rule = Rule(
  textFieldValue,
  name: 'Username',
  minLength: 10,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### greaterThan: `double`
- Checks if the input value is greater than the 'greaterThan' value.
- if 'isNumeric' is not set then the 'isNumericDecimal' constraint will be applied automatically.


```dart
const textFieldValue = '10';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  greaterThan: 0,
  isNumeric: true, // optional
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### greaterThanEqualTo: `double`
- Checks if the input value is greater than or equal to the 'greaterThanEqualTo' value.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.

```dart
const textFieldValue = '5.1';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  greaterThanEqualTo: 5.0,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### lessThan: `double`
- Checks if the input value is greater than or equal to the 'lessThan' value.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.

```dart
const textFieldValue = '1';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  lessThan: 2.0,
  isNumericDecimal: true, // optional
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### lessThanEqualTo: `double`
- Checks if the input value is greater than or equal to the 'lessThanEqualTo' value.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.

```dart
const textFieldValue = '2.0';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  lessThanEqualTo: 2.0,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### equalTo: `double`
- Checks if the input value is equal to the 'equalTo' value.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.

```dart
const textFieldValue = '2.0';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  equalTo: 2.0,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### notEqualTo: `double`
- Checks if the input value is equal to the 'notEqualTo' value. 
- It will throw an error if the values match.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.


```dart
const textFieldValue = '2.0';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  notEqualTo: 2.0,
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

###### equalToInList: `List<double>`
- Checks if the input value matches with any of the 'equalToInList' values.
- Note: This is a float comparison. 10.00 == 10 will be true.


```dart
const textFieldValue = '10';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  equalToInList: [0, 10],
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### notEqualToInList: `List<double>`
- Checks if the input value matches with any of the 'notEqualToInList' values.
- It will throw an error if there is a value match.
- Note: This is a float comparison. 10.00 == 10 will be true.


```dart
const textFieldValue = '10';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  notEqualToInList: [0, 10],
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### shouldMatch: `String`
- Checks if the input value matches with the 'shouldMatch' value.
- Note: This is a string comparison.

```dart
const textFieldValue = 'abc';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  shouldMatch: 'abc',
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```


###### shouldNotMatch: `String`
- Checks if the input value matches with the 'shouldNotMatch' value.
- It will throw an error if the values match.
- Note: This is a string comparison.

```dart
const textFieldValue = 'abc';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  shouldNotMatch: 'xyz',
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```



###### inList: `List<String>`
- Checks if the input value matches with any of the 'inList' values.
- Note: This is a string comparison.

```dart
const textFieldValue = 'abc';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  inList: ['abc', 'xyz'],
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```



###### notInList: `List<String>`
- Checks if the input value matches with any of the 'notInList' values.
- It will throw an error if there is a value match.
- Note: This is a string comparison.

```dart
const textFieldValue = 'abc';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  notInList: ['abc', 'xyz'],
);

if (rule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

**Custom Error**

###### Default errors

```dart
{
    'isRequired': '{name} is required',
    'isEmail': '{name} is not a valid email address',
    'isPhone': '{name} is not a valid phone number',
    'isUrl': '{name} is not a valid URL',
    'isIp': '{name} is not a valid IP address',
    'isNumeric': '{name} is not a valid number',
    'isNumericDecimal': '{name} is not a valid decimal number',
    'isAlphaSpace': 'Only alphabets and spaces are allowed in {name}',
    'isAlphaNumeric': 'Only alphabets and numbers are allowed in {name}',
    'isAlphaNumericSpace': 'Only alphabets, numbers and spaces are allowed in {name}',
    'regex': '{name} should match the pattern: {value}',
    'length': '{name} should be $length characters long',
    'minLength': '{name} should contain at least $minLength characters',
    'maxLength': '{name} should not exceed more than $maxLength characters',
    'greaterThan': '{name} should be greater than $greaterThan',
    'greaterThanEqualTo': '{name} should be greater than or equal to $greaterThanEqualTo',
    'lessThan': '{name} should be less than $lessThan',
    'lessThanEqualTo': '{name} should be less than or equal to $lessThanEqualTo',
    'equalTo': '{name} should be equal to $equalTo',
    'notEqualTo': '{name} should not be equal to $notEqualTo',
    'equalToInList': '{name} should be equal to any of these values ${(equalToInList ?? []).join(', ')}',
    'notEqualToInList': '{name} should not be equal to any of these values ${(notEqualToInList ?? []).join(', ')}',
    'shouldMatch': '{name} should be same as $shouldMatch',
    'shouldNotMatch': '{name} should not same as $shouldNotMatch',
    'inList': '{name} should be any of these values ${(inList ?? []).join(', ')}',
    'notInList': '{name} should not be any of these values ${(notInList ?? []).join(', ')}',
}
```

###### Override the default errors
- To override the error text of a particular option, set 'customErrors' as `{'optionName': '<Error Text>'`}.
- The 'optionName' key should match with one of the 'Available Options' for overriding the error text.
- Use {value} and {name} template variables in the 'customErrors' to display the input name and value respectively.
- To override all the error texts set 'customErrorText'.
- 'customErrorText' will override all the errors including 'customErrors'

```dart
const textFieldValue = ''; // or textFieldValue = 'xyz';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isRequired: true,
  isEmail: true,
  customErrors: {
                  'isRequired': 'Input is invalid.',
                  'isEmail': '{value} is an invalid value. Try another {name}.',
                },
);

// when textFieldValue = '';
print(rule.error);
// output: Input is invalid.

// when textFieldValue = 'xyz';
print(rule.error);
// output: xyz is an invalid value. Try another Text field.

```

```dart
const textFieldValue = '';

final rule = Rule(
  textFieldValue,
  name: 'Text field',
  isRequired: true,
  isEmail: true,
  customErrorText: 'Invalid email address',
);

print(rule.error);
// output: Invalid email address

```

#### 2. GroupRule
Group the Basic Rule together

**Basic example**
```dart
const textFieldValue = 'abc@xyz.com';

final rule = Rule(
  textFieldValue, 
  name: 'Text field',
);

final groupRule = GroupRule(
  [rule], // value; List of Rule
  name: 'Group name', // placeholder value which will be used while displaying errors
);

print(groupRule.error);
// output: null
print(groupRule.hasError);
// output: false

if (groupRule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

**Example 1**
```dart
const textFieldValue1 = '';  // or const textFieldValue = null;
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
  name: 'Group name', // placeholder value which will be used while displaying errors
);

print(groupRule.error);
// output: 'Text field 1 is required'
print(groupRule.hasError);
// output: true

```

**Available options**

```dart
final String name; // mandatory

final bool requiredAll;

final int requiredAtleast;

final int maxAllowed;

final String customErrorText;

final Map<String, String> customErrors;
```

###### requiredAll: `bool`
- Checks if all basic rules have a value.

```dart
const textFieldValue1 = 'abc';
const textFieldValue2 = '';

final rule1 = Rule(
  textFieldValue1,
  name: 'Text field',
  isRequired: true,
); // Validation OK

final rule2 = Rule(
  textFieldValue2,
  name: 'Text field',
); // Validation OK

final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  requiredAll: true,
);

print(groupRule.error);
// output: All fields are mandatory in Group name

```

- IMPORTANT: If any of the basic rules have validation errors then GroupRule will throw those errors first.
- The group validation wouldn't happen until all basic rules pass the validation.

```dart
const textFieldValue1 = 'abc';  // or const textFieldValue = null;
const textFieldValue2 = 'xyz@abc';

final rule1 = Rule(
  textFieldValue1,
  name: 'Text field 1',
  isRequired: true,
); // Validation OK

final rule2 = Rule(
  textFieldValue2,
  name: 'Text field 2',
  isEmail: true,
); // Validation FAILED

final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name'
);

print(groupRule.error);
// output: 'Text field 2 is not a valid email address'
print(groupRule.hasError);
// output: true

if (groupRule.hasError) {
// some action on error
}
else {
// Some action on success
}
```

- IMPORTANT: If the input basic rules list is an empty array or null and 'isRequiredAll' is false or not set then no errors will be thrown for the subsequent constraints.

```dart
final groupRule = GroupRule(
  [],
  name: 'Group name'
);

print(groupRule.hasError);
// output: false
```

###### requiredAtleast: `int`
- Defines the minimum number of basic rules that should have a value.
- The number of basic rules in a GroupRule should be greater than the 'requiredAtleast' value else it will throw an exception.
- If the 'requiredAtleast' is 0 then it will pass the validation.

```dart
const textFieldValue1 = 'abc';
const textFieldValue2 = '';

final rule1 = Rule(
  textFieldValue1,
  name: 'Text field',
); // Validation OK

final rule2 = Rule(
  textFieldValue2,
  name: 'Text field',
); // Validation OK

final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  requiredAtleast: 2,
);

print(groupRule.error);
// output: At least 2 fields are required in Group name

```

```dart
const textFieldValue1 = 'abc';
const textFieldValue2 = 'xyz';

final rule1 = Rule(
  textFieldValue1,
  name: 'Text field',
); // Validation OK

final rule2 = Rule(
  textFieldValue2,
  name: 'Text field',
); // Validation OK

final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  requiredAtleast: 2,
);

print(groupRule.error);
// output: null

print(groupRule.hasError);
// output: false

```

###### maxAllowed: `int`
- The maximum number of basic rules that are allowed to have a value.

```dart
const textFieldValue1 = 'abc';
const textFieldValue2 = 'xyz';

final rule1 = Rule(
  textFieldValue1,
  name: 'Text field',
); // Validation OK

final rule2 = Rule(
  textFieldValue2,
  name: 'Text field',
); // Validation OK

final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  maxAllowed: 1,
);

print(groupRule.error);
// output: A maximum of 1 field is allowed in Group name

```

```dart
const textFieldValue1 = 'abc';
const textFieldValue2 = '';

final rule1 = Rule(
  textFieldValue1,
  name: 'Text field',
); // Validation OK

final rule2 = Rule(
  textFieldValue2,
  name: 'Text field',
); // Validation OK

final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  maxAllowed: 1,
);

print(groupRule.error);
// output: null

print(groupRule.hasError);
// output: false

```

**Custom Error**

###### Default errors
- Plurality for 'requiredAtleast' and 'maxAllowed' error texts will be automatically detected.

```dart
{
  'requiredAll': 'All fields are mandatory in {name}',
  'requiredAtleast': 'At least $requiredAtleast field(s) is/are required in {name}',
  'maxAllowed': 'A maximum of $maxAllowed field(s) is/are allowed in {name}',
}
```

###### Override the default errors
- To override the error text of a particular option, set 'customErrors' as `{'optionName': '<Error Text>'`}.
- The 'optionName' key should match with one of the 'Available Options' for overriding the error text.
- Use {value} and {name} template variables in the 'customErrors' to display the input name and value respectively.
- To override all the error texts set 'customErrorText'.
- 'customErrorText' will override all the errors including 'customErrors'.

```dart
const textFieldValue1 = 'abc';
const textFieldValue2 = '';

final rule1 = Rule(
  textFieldValue1,
  name: 'Text field',
  isRequired: true,
); // Validation OK

final rule2 = Rule(
  textFieldValue2,
  name: 'Text field',
); // Validation OK

final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  requiredAll: true,
  customErrors: {
                  'requiredAll': 'Input is invalid.',
                },
);

print(groupRule.error);
// output: Input is invalid.

```

```dart
const textFieldValue1 = 'abc';
const textFieldValue2 = '';

final rule1 = Rule(
  textFieldValue1,
  name: 'Text field',
  isRequired: true,
); // Validation OK

final rule2 = Rule(
  textFieldValue2,
  name: 'Text field',
); // Validation OK

final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  requiredAll: true,
  customErrorText: 'Invalid input.',
);

print(rule.error);
// output: Invalid input.

```


#### 1. CombinedRule
Manage basic and group rules

- Both 'Rule' and/or 'GroupRule' are accepted as inputs.
- Errors of both 'Rule' and 'GroupRule', if any, are combined into a list.
- Order of appearance of error texts in CombinedRule errorList: 
    1. Rule
    2. GroupRule

**Basic example**
```dart
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
final groupRule = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  requiredAll: true
); // Validation FAILED


const textFieldValue3 = '';
final rule3 = Rule(
  textFieldValue3, 
  name: 'Text field 3',
  isRequired: true,
);  // Validation FAILED


final combinedRule = CombinedRule(
  rules: [rule3],
  groupRules: [groupRule],
);

print(combinedRule.errorList);
// output: ['Text field 3 is required', 'All fields are mandatory in Group name']

print(combinedRule.hasError);
// output: true

if (combinedRule.hasError) {
// some action on error
}
else {
// Some action on success
}
```    
    
**Available options**
```dart
final List<Rule> rules;

final List<GroupRule> groupRules;
```
    
###### rules: `List<Rule>`
```dart
const textFieldValue1 = '';
const textFieldValue2 = 'abc@xyz';
const textFieldValue3 = '';

final rule1 = Rule(
  textFieldValue1, 
  name: 'Text field 1',
); // Validation OK
final rule2 = Rule(
  textFieldValue2, 
  name: 'Text field 2',
  isEmail: true,
); // Validation FAILED
final rule3 = Rule(
  textFieldValue3, 
  name: 'Text field 3',
  isRequired: true,
  customErrorText: 'Invalid field input',
); // Validation FAILED


final combinedRule = CombinedRule(
  rules: [rule1, rule2, rule3],
);

print(combinedRule.errorList);
// output: ['Text field 2 is not a valid email address', 'Invalid field input']

print(combinedRule.hasError);
// output: true
```

###### groupRules: `List<GroupRule>`
```dart
const textFieldValue1 = '';
const textFieldValue2 = 'abc@xyz';

final rule1 = Rule(
  textFieldValue1, 
  name: 'Text field 1',
); // Validation OK
final rule2 = Rule(
  textFieldValue2, 
  name: 'Text field 2',
  isEmail: true,
); // Validation FAILED
final groupRule1 = GroupRule(
  [rule1, rule2],
  name: 'Group name',
  requiredAll: true,
  customErrorText: 'Invalid input',
); // Validation FAILED

final groupRule2 = GroupRule(
  [],
  name: 'Group name',
); // Validation OK


final combinedRule = CombinedRule(
  groupRules: [groupRule1, groupRule2],
);

print(combinedRule.errorList);
// output: ['Invalid input']

print(combinedRule.hasError);
// output: true
```

#### Flutter

```dart
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String emailInput;

  String phoneInput;

  void _handleEmailTextFieldOnChange(String value) {
    setState(() {
      emailInput = value;
    });
  }

  void _handlePhoneTextFieldOnChange(String value) {
    setState(() {
      phoneInput = value;
    });
  }

  Rule get emailInputRule {
    return Rule(
      emailInput,
      name: 'Email',
      isAlphaSpace: true,
      isRequired: true,
      customErrorText: 'Invalid Email',
    );
  }

  Rule get phoneInputRule {
    return Rule(
      phoneInput,
      name: 'Phone',
      isPhone: true,
      isRequired: true,
      customErrorText: 'Invalid Phone',
    );
  }

  bool get isContinueBtnEnabled {
    final groupRule = GroupRule(
      [emailInputRule, phoneInputRule],
      name: 'Continue Button',
      requiredAll: true,
    );

    return !groupRule.hasError;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (String value) {
                _handleEmailTextFieldOnChange(value);
              },
              decoration: InputDecoration(
                hintText: 'Email address',
                errorText: emailInputRule?.error ?? null,
              ),
            ),
            TextField(
              onChanged: (String value) {
                _handlePhoneTextFieldOnChange(value);
              },
              decoration: InputDecoration(
                hintText: 'Phone',
                errorText: phoneInputRule?.error ?? null,
              ),
            ),
            if (isContinueBtnEnabled)
              FlatButton(
                onPressed: () {
                  // call api
                },
                child: const Text('Continue'),
              )
            else
              Container()
          ],
        ),
      ),
    );
  }
}
```

#### Flutter Mobx



### Buy me a coffee
Help me keep the app FREE and open for all.
Paypal me: [paypal.me/ganeshrvel](https://paypal.me/ganeshrvel "paypal.me/ganeshrvel")

### Contacts
Please feel free to contact me at ganeshrvel@outlook.com

### About

- Author: [Ganesh Rathinavel](https://www.linkedin.com/in/ganeshrvel "Ganesh Rathinavel")
- License: [MIT](https://github.com/ganeshrvel/openmtp/blob/master/LICENSE "MIT")
- Package URL: [https://pub.dev/packages/rules](https://pub.dev/packages/rules "https://pub.dev/packages/rules")
- Repo URL: [https://github.com/ganeshrvel/pub-rules](https://github.com/ganeshrvel/pub-rules/ "https://github.com/ganeshrvel/pub-rules")
- Contacts: ganeshrvel@outlook.com

### License
Rules | Validation library for Dart and Flutter. [MIT License](https://github.com/ganeshrvel/pub-rules/blob/master/LICENSE "MIT License").

Copyright © 2018 - Present Ganesh Rathinavel
