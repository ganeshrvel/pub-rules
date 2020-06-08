### Introduction

##### Rules - Validation library for Dart and Flutter.

**Rules** is a simple yet powerful and feature-rich validation library for both dart and flutter. Less boilerplate code, easy to understand and developer-friendly.

### Installation

Go to https://pub.dev/packages/rules#-installing-tab- for the latest version of **rules**

### Concept

The Rules library has three parts
- Rules: Basic rules
- GroupRules: Grouped rules
- CombinedRules: Manage Rules and GroupRules


### Usage

**Import the library**
```dart
import 'package:rules/rules.dart';
```

#### 1. Rules (Basic Rules)
- These are the basic building blocks of the Rules library.

**Basic example**
```dart
final textFieldValue = 'abc@xyz.com';

final rule = Rules(
  textFieldValue, // value; string and null are accepted
  name: 'Text field value' // placeholder value which will be used while displaying errors
);

print(rule.error);
// output: null
print(rule.hasError)
// output: false
```

**Example 1**
```dart
final textFieldValue = '';  // or final textFieldValue = null;

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
  isRequired: true,
);

print(rule.error);
// output: 'Text field value is required'
print(rule.hasError)
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
final textFieldValue = 'abc@xyz';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
  isRequired: true,
  isEmail: true,
);

print(rule.error);
// output: 'Text field value is not a valid email address'
print(rule.hasError)
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
final textFieldValue = '123';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
  isRequired: true, // throws an error for value = null or an empty string
);

if (rule.hasError) {
	// some action on error
}
else {
	// Some action on success
}
```

- IMPORTANT: If the value is empty or null and 'isRequired' is false or not set then no error will be thrown for any other constraints.

```dart
final textFieldValue = ''; // or null

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
  isRequired: false,
  isEmail: true,
);

print(rule.hasError);
// output: false
```

###### isEmail: `bool`
```dart
final textFieldValue = 'abc@xyz.com';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = 'http://www.google.com';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '+1-9090909090';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '1.1.1.1';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '1'; // '-1', '0'

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '10.01'; // '-10.01' or '0.001'

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = 'Jane Doe';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = 'username123';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = 'Bread 20';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = r'^[a-zA-Z0-9\s]+$';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '9090909090';

final rule = Rules(
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
final textFieldValue = 'abcd12345';

final rule = Rules(
  textFieldValue,
  name: 'Password'
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
final textFieldValue = 'username12';

final rule = Rules(
  textFieldValue,
  name: 'Username'
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
final textFieldValue = '10';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '5.1';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '1';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '2.0';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '2.0';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '2.0';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '10';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = '10';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = 'abc';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = 'abc';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = 'abc';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
final textFieldValue = 'abc';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
- To override the error text of a particular option, set 'customErrors' as {'optionName': '<Error Text>'}.
- The 'optionName' key should match with one of the 'Available Options' for overriding the error text.
- Use {value} and {name} template variables in the 'customErrors' to display the input name and value respectively.
- To override all the error texts set 'customErrorText'.
- 'customErrorText' will override all the errors including 'customErrors'

```dart
final textFieldValue = ''; // or textFieldValue = 'xyz';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
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
// output: xyz is an invalid value. Try another Text field value.

```

```dart
final textFieldValue = '';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
  isRequired: true,
  isEmail: true,
  customErrorText: 'Invalid email address',
);

print(rule.error);
// output: Invalid email address

```

#### 2. GroupRules
- Group together Rules using GroupRules

**Basic example**
```dart
final textFieldValue = 'abc@xyz.com';

final rule = Rules(
  textFieldValue, 
  name: 'Text field value' 
);

final groupRule = GroupRules(
  [rule], // value; List of Rules
  name: 'Group name', // placeholder value which will be used while displaying errors
);

print(groupRule.error);
// output: null
print(groupRule.hasError)
// output: false
```

**Example 1**
```dart
final textFieldValue1 = '';  // or final textFieldValue = null;
final textFieldValue2 = '';

final rule1 = Rules(
  textFieldValue1,
  name: 'Text field value 1'
  isRequired: true,
);

final rule2 = Rules(
  textFieldValue2,
  name: 'Text field value 2'
  isEmail: true,
);

final groupRule = GroupRules(
  [rule1, rule2], // value; List of Rules
  name: 'Group name', // placeholder value which will be used while displaying errors
);

print(groupRule.error);
// output: 'Text field value 1 is required'
print(groupRule.hasError)
// output: true

if (groupRule.hasError) {
	// some action on error
}
else {
	// Some action on success
}
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

```dart
final textFieldValue = 'abc';

final rule = Rules(
  textFieldValue,
  name: 'Text field value'
  isRequired: true,
);

final groupRule = GroupRules(
  [rule],
  name: 'Group name',
  requiredAll: true  
);

print(groupRule.error);
// output: All fields are mandatory in Group name

```

- IMPORTANT: If any of Basics Rules which were passed to the GroupRules have validation errors then GroupRules will throw those errors first.
- The group validation wouldn't happen until all Rules pass the validation.

```dart
final textFieldValue1 = 'abc';  // or final textFieldValue = null;
final textFieldValue2 = 'xyz@abc';

final rule1 = Rules(
  textFieldValue1,
  name: 'Text field value 1'
  isRequired: true,
);

final rule2 = Rules(
  textFieldValue2,
  name: 'Text field value 2'
  isEmail: true,
);

final groupRule = GroupRules(
  [rule1, rule2],
  name: 'Group name'
);

print(groupRule.error);
// output: 'Text field value 2 is not a valid email address'
print(groupRule.hasError)
// output: true

if (groupRule.hasError) {
	// some action on error
}
else {
	// Some action on success
}
```

- IMPORTANT: If the input Rules list is an empty array or null and 'isRequiredAll' is false or not set then no error will be thrown for any other constraints.

```dart
final groupRule = GroupRules(
  [],
  name: 'Group name'
);

print(groupRule.hasError);
// output: false
```


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
