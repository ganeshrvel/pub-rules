### Introduction

##### Rules - Powerful and feature-rich validation library for both Dart and Flutter.

**Rules** is a simple yet powerful and feature-rich validation library for both dart and flutter.


#### Features
- Highly flexible
- Easy to understand
- Less boilerplate code
- Custom error handling
- Override individual errors
- Flutter friendly
- State management libraries friendly ([Mobx example included](https://github.com/ganeshrvel/pub-rules#flutter-mobx "Mobx example included"))

### Installation

Go to https://pub.dev/packages/rules#-installing-tab- for the latest version of **rules**

### Concept

The Rules library has three parts
- Rule: Basic rule
- GroupRule: Group together and validate the basic rules
- CombinedRule: Validate multiple basic rules and group rules together


### Usage

**Import the library**
```dart
import 'package:rules/rules.dart';
```

#### 1. Rule (Basic Rule)
This is the basic building block, everything starts here.

**Basic example**
```dart
void main() {
  const textFieldValue = 'abc@xyz.com';

  final rule = Rule(
    textFieldValue, // value; string and null are accepted
    name: 'Text field', // placeholder value which will be used while displaying errors
  );

  print(rule.error);
  // output: null
  print(rule.hasError);
  // output: false
}
```

**Example 1**
```dart
void main() {
  const textFieldValue = ''; // or const textFieldValue = null;

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
  } else {
    // Some action on success
  }
}

```

**Example 2**
```dart
void main() {
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
  } else {
    // Some action on success
  }
}

```

**Available options**
```dart
String name; // mandatory

bool isRequired;

bool isEmail;

bool isUrl;

bool isPhone;

bool isIp;

bool isNumeric;

bool isNumericDecimal;

bool isAlphaSpace;

bool isAlphaNumeric;

bool isAlphaNumericSpace;

RegExp regex;

int length;

int minLength;

int maxLength;

double greaterThan;

double greaterThanEqualTo;

double lessThan;

double lessThanEqualTo;

double equalTo;

double notEqualTo;

List<double> equalToInList;

List<double> notEqualToInList;

String shouldMatch;

String shouldNotMatch;

List<String> inList;

List<String> notInList;

String customErrorText;

Map<String, String> customErrors;
```

###### isRequired: `bool`

```dart
void main() {
  const textFieldValue = '123';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isRequired: true, // throws an error for value = null or an empty string
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

- IMPORTANT: If the value is empty or null and 'isRequired' is false or not set then no errors will be thrown for the subsequent constraints.

```dart
void main() {
  const textFieldValue = ''; // or null

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isRequired: false,
    isEmail: true,
  );

  print(rule.hasError);
  // output: false
}
```

###### isEmail: `bool`
```dart
void main() {
  const textFieldValue = 'abc@xyz.com';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isEmail: true,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

###### isUrl: `bool`
```dart
void main() {
  const textFieldValue = 'http://www.google.com';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isUrl: true,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

###### isPhone: `bool`
- It recognizes the phone numbers starting with **+** or **0**, no length limitations and handles `#, x, ext, extension` extension conventions.

```dart
void main() {
  const textFieldValue = '+1-9090909090';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isPhone: true,
  );

  if (rule.hasError) {
  // some action on error
  } else {
  // Some action on success
  }
}
```

###### isIp: `bool`
- It accepts both IPv4 and IPv6 addresses.


```dart
void main() {
  const textFieldValue = '1.1.1.1';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isIp: true,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

###### isNumeric: `bool`
- It accepts both 0, positive and negative integers. Decimals are not allowed.


```dart
void main() {
  const textFieldValue = '1'; // '-1', '0'

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isNumeric: true,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### isNumericDecimal: `bool`
- It accepts 0, postive and negative integers and decimals numbers.


```dart
void main() {
  const textFieldValue = '10.01'; // '-10.01' or '0.001'

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isNumericDecimal: true,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### isAlphaSpace: `bool`
- It accepts multiple spaces and alphabets (both upper and lower case).


```dart
void main() {
  const textFieldValue = 'Jane Doe';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isAlphaSpace: true,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### isAlphaNumeric: `bool`
- It accepts alphabets (both upper and lower case) and numbers.

```dart
void main() {
  const textFieldValue = 'username123';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isAlphaNumeric: true,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### isAlphaNumericSpace: `bool`
- It accepts multiple spaces, alphabets (both upper and lower case) and numbers.

```dart
void main() {
  const textFieldValue = 'Bread 20';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isAlphaNumericSpace: true,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

###### regex: `RegExp`
- It accepts a custom regular expression string.

```dart
void main() {
  const textFieldValue = 'abc123';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    regex: RegExp(
      r'^[a-zA-Z0-9\s]+$',
      caseSensitive: false,
    ),
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

###### length: `int`
- Defines the length of the input string.

```dart
void main() {
  const textFieldValue = '9090909090';

  final rule = Rule(
    textFieldValue,
    name: 'Phone Number',
    length: 10,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

###### minLength: `int`
- Defines the minimum length of the input string.


```dart
void main() {
  const textFieldValue = 'abcd12345';

  final rule = Rule(
    textFieldValue,
    name: 'Password',
    minLength: 6,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}

```

###### maxLength: `int`
- Defines the maximum length of the input string.

```dart
void main() {
  const textFieldValue = 'username12';

  final rule = Rule(
    textFieldValue,
    name: 'Username',
    minLength: 10,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}

```

###### greaterThan: `double`
- Checks if the input value is greater than the 'greaterThan' value.
- if 'isNumeric' is not set then the 'isNumericDecimal' constraint will be applied automatically.


```dart
void main() {
  const textFieldValue = '10';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    greaterThan: 0,
    isNumeric: true, // optional
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

###### greaterThanEqualTo: `double`
- Checks if the input value is greater than or equal to the 'greaterThanEqualTo' value.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.

```dart
void main() {
  const textFieldValue = '5.1';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    greaterThanEqualTo: 5.0,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}

```

###### lessThan: `double`
- Checks if the input value is greater than or equal to the 'lessThan' value.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.

```dart
void main() {
  const textFieldValue = '1';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    lessThan: 2.0,
    isNumericDecimal: true, // optional
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}

```

###### lessThanEqualTo: `double`
- Checks if the input value is greater than or equal to the 'lessThanEqualTo' value.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.

```dart
void main() {
  const textFieldValue = '2.0';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    lessThanEqualTo: 2.0,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### equalTo: `double`
- Checks if the input value is equal to the 'equalTo' value.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.

```dart
void main() {
  const textFieldValue = '2.0';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    equalTo: 2.0,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### notEqualTo: `double`
- Checks if the input value is equal to the 'notEqualTo' value. 
- It will throw an error if the values match.
- if 'isNumeric' is not set then 'isNumericDecimal' constraint will be applied automatically.


```dart
void main() {
  const textFieldValue = '2.0';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    notEqualTo: 2.0,
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

###### equalToInList: `List<double>`
- Checks if the input value matches with any of the 'equalToInList' values.
- Note: This is a float comparison. 10.00 == 10 will be true.


```dart
void main() {
  const textFieldValue = '10';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    equalToInList: [0, 10],
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### notEqualToInList: `List<double>`
- Checks if the input value matches with any of the 'notEqualToInList' values.
- It will throw an error if there is a value match.
- Note: This is a float comparison. 10.00 == 10 will be true.


```dart
void main() {
  const textFieldValue = '10';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    notEqualToInList: [0, 10],
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### shouldMatch: `String`
- Checks if the input value matches with the 'shouldMatch' value.
- Note: This is a string comparison.

```dart
void main() {
  const textFieldValue = 'abc';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    shouldMatch: 'abc',
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```


###### shouldNotMatch: `String`
- Checks if the input value matches with the 'shouldNotMatch' value.
- It will throw an error if the values match.
- Note: This is a string comparison.

```dart
void main() {
  const textFieldValue = 'abc';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    shouldNotMatch: 'xyz',
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}

```



###### inList: `List<String>`
- Checks if the input value matches with any of the 'inList' values.
- Note: This is a string comparison.

```dart
void main() {
  const textFieldValue = 'abc';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    inList: ['abc', 'xyz'],
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```



###### notInList: `List<String>`
- Checks if the input value matches with any of the 'notInList' values.
- It will throw an error if there is a value match.
- Note: This is a string comparison.

```dart
void main() {
  const textFieldValue = 'abc';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    notInList: ['abc', 'xyz'],
  );

  if (rule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```

**Custom Error**

###### Default errors

```
'isRequired': '{name} is required'
'isEmail': '{name} is not a valid email address'
'isPhone': '{name} is not a valid phone number'
'isUrl': '{name} is not a valid URL'
'isIp': '{name} is not a valid IP address'
'isNumeric': '{name} is not a valid number'
'isNumericDecimal': '{name} is not a valid decimal number'
'isAlphaSpace': 'Only alphabets and spaces are allowed in {name}'
'isAlphaNumeric': 'Only alphabets and numbers are allowed in {name}'
'isAlphaNumericSpace': 'Only alphabets, numbers and spaces are allowed in {name}'
'regex': '{name} should match the pattern: {regex.pattern}'
'length': '{name} should be $length characters long'
'minLength': '{name} should contain at least $minLength characters'
'maxLength': '{name} should not exceed more than $maxLength characters'
'greaterThan': '{name} should be greater than $greaterThan'
'greaterThanEqualTo': '{name} should be greater than or equal to $greaterThanEqualTo'
'lessThan': '{name} should be less than $lessThan'
'lessThanEqualTo': '{name} should be less than or equal to $lessThanEqualTo'
'equalTo': '{name} should be equal to $equalTo'
'notEqualTo': '{name} should not be equal to $notEqualTo'
'equalToInList': '{name} should be equal to any of these values $equalToInList'
'notEqualToInList': '{name} should not be equal to any of these values $notEqualToInList'
'shouldMatch': '{name} should be same as $shouldMatch'
'shouldNotMatch': '{name} should not same as $shouldNotMatch'
'inList': '{name} should be any of these values $inList'
'notInList': '{name} should not be any of these values $notInList'
```

###### Override the default errors
- To override the error text of a particular option, set 'customErrors' as `{'optionName': '<Error Text>'`}.
- The 'optionName' key should match with one of the 'Available Options' for overriding the error text.
- Use {value} and {name} template variables in the 'customErrors' to display the input name and value respectively.
- To override all default error texts set 'customErrorText'.
- Note: 'customErrorText' will only override the default errors. 'customErrors' will be given the highest priority.

```dart
void main() {
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
}

```

```dart
void main() {
  const textFieldValue = '123';

  final rule = Rule(
    textFieldValue,
    name: 'Text field',
    isRequired: true,
    isEmail: true,
    customErrorText: 'Invalid email address',
  );

  print(rule.error);
  // output: Invalid email address
}
```

**Extension**
- Extend and override the constraints of a rule using 'copyWith' method

```dart
void main() {
  const textFieldValue = 'abc';

  final rule1 = Rule(
    textFieldValue,
    name: 'Text field 1',
    isAlpha: true,
    customErrorText: 'Only alphabets allowed',
  );

  final rule2 = rule1.copyWith(
    name: 'Text field 2',
    isEmail: true,
    customErrorText: 'Invalid email address',
  );

  print(rule1.error);
  // output: null
  print(rule2.error);
  // output: Invalid email address
}
```

- The child rule will default to the constraint values of the parent unless they are set explicitly in the child.

```dart
void main() {
  const textFieldValue = '';

  // parent rule
  final rule1 = Rule(
    textFieldValue,
    name: 'Text field',
    isRequired: true,
    customErrorText: 'Invalid input',
  );

  // child rule
  final rule2 = rule1.copyWith(
    isRequired: false,
  );

  print(rule1.error);
  // output: Invalid input
  print(rule2.error);
  // output: null
}
```

#### 2. GroupRule
Group together and validate the basic rules 

**Basic example**
```dart
void main() {
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
  } else {
    // Some action on success
  }
}
```

**Example 1**
```dart
void main() {
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
    name: 'Group name', // placeholder value which will be used while displaying errors
  );

  print(groupRule.error);
  // output: 'Text field 1 is required'
  print(groupRule.hasError);
  // output: true
}

```

**Available options**

```dart
String name; // mandatory

bool requiredAll;

int requiredAtleast;

int maxAllowed;

String customErrorText;

Map<String, String> customErrors;
```

###### requiredAll: `bool`
- Checks if all basic rules have a value.

```dart
void main() {
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
}
```

- IMPORTANT: If any of the basic rules have validation errors then GroupRule will throw those errors first.
- The group validation wouldn't happen until all basic rules pass the validation.

```dart
void main() {
  const textFieldValue1 = 'abc'; // or const textFieldValue = null;
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

  final groupRule = GroupRule([rule1, rule2], name: 'Group name');

  print(groupRule.error);
  // output: 'Text field 2 is not a valid email address'
  print(groupRule.hasError);
  // output: true

  if (groupRule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}

```

- IMPORTANT: If the input basic rules list is an empty array or null and 'isRequiredAll' is false or not set then no errors will be thrown for the subsequent constraints.

```dart
void main() {
  final groupRule = GroupRule([], name: 'Group name');

  print(groupRule.hasError);
  // output: false
}

```

###### requiredAtleast: `int`
- Defines the minimum number of basic rules that should have a value.
- The number of basic rules in a GroupRule should be greater than the 'requiredAtleast' value else it will throw an exception.
- If the 'requiredAtleast' is 0 then it will pass the validation.

```dart
void main() {
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
}
```

```dart
void main() {
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
}
```

###### maxAllowed: `int`
- The maximum number of basic rules that are allowed to have a value.

```dart
void main() {
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
}
```

```dart
void main() {
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
}
```

**Custom Error**

###### Default errors
- Plurality for 'requiredAtleast' and 'maxAllowed' error texts will be automatically detected.

```
'requiredAll': 'All fields are mandatory in {name}'
'requiredAtleast': 'At least $requiredAtleast field(s) is/are required in {name}'
'maxAllowed': 'A maximum of $maxAllowed field(s) is/are allowed in {name}'
```

###### Override the default errors
- To override the error text of a particular option, set 'customErrors' as `{'optionName': '<Error Text>'`}.
- The 'optionName' key should match with one of the 'Available Options' for overriding the error text.
- Use {value} and {name} template variables in the 'customErrors' to display the input name and value respectively.
- To override all default error texts set 'customErrorText'.
- Note: 'customErrorText' will only override the default errors. 'customErrors' will be given the highest priority.

```dart
void main() {
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
}
```

```dart
void main() {
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

  print(groupRule.error);
  // output: Invalid input.
}
```

**Extension**
- Extend and override the constraints of a group rule using 'copyWith' method.
- The child rule will default to the constraint values of the parent unless they are set explicitly in the child.

```dart
void main() {
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

  // parent
  final groupRule1 = GroupRule(
    [rule1, rule2],
    name: 'Group name 1',
    requiredAll: true,
    customErrorText: 'Invalid input for Group 1',
  ); // Validation FAILED

  // child
  final groupRule2 = groupRule1.copyWith(
    name: 'Group name 2',
    requiredAll: false,
    customErrorText: 'Invalid input for Group 2',
  ); // Validation OK

  print(groupRule1.error);
  // output: Invalid input for Group 1

  print(groupRule2.error);
  // output: null
}
```

```dart
void main() {
  const textFieldValue1 = 'abc';

  final rule1 = Rule(
    textFieldValue1,
    name: 'Text field',
    isRequired: true,
  ); // Validation OK

  final rule2 = rule1.copyWith(
    name: 'Text field',
  ); // Validation OK

  // parent
  final groupRule1 = GroupRule(
    [rule1, rule2],
    name: 'Group name 1',
    requiredAll: true,
    customErrorText: 'Invalid input for Group 1',
  ); // Validation OK

  // child
  final groupRule2 = groupRule1.copyWith(
    name: 'Group name 2',
    requiredAll: false,
    customErrorText: 'Invalid input for Group 2',
  ); // Validation OK

  print(groupRule1.error);
  // output: null

  print(groupRule2.error);
  // output: null
}
```

#### 3. CombinedRule
Manage multiple Rules and GroupRules

- Both 'Rule' and/or 'GroupRule' are accepted as inputs.
- Errors of both 'Rule' and 'GroupRule', if any, are combined into a list.
- Order of appearance of error texts in CombinedRule errorList: 
    1. Rule
    2. GroupRule

**Basic example**
```dart
void main() {
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

  print(combinedRule.errorList);
  // output: ['Text field 3 is required', 'All fields are mandatory in Group name']

  print(combinedRule.hasError);
  // output: true

  if (combinedRule.hasError) {
    // some action on error
  } else {
    // Some action on success
  }
}
```    
    
**Available options**
```dart
List<Rule> rules;

List<GroupRule> groupRules;
```
    
###### rules: `List<Rule>`
```dart
void main() {
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
}
```

###### groupRules: `List<GroupRule>`
```dart
void main() {
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
}
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

Mobx Store
```dart
class UpdateUserStore = _UpdateUserStoreBase
    with _$UpdateUserStore;

abstract class _UpdateUserStoreBase with Store {
  @observable
  String profileName;

  @observable
  String profileEmail;

  @computed
  Rules get profileNameInputRule {
    final rule = Rules(
      profileName,
      name: 'Name',
      isRequired: false,
      isAlphaSpace: true,
      customErrorText: 'Invalid name',
    );

    return rule;
  }

  @computed
  Rules get profileEmailInputRule {
    final rule = Rules(
      profileEmail,
      name: 'Name',
      isRequired: false,
      isEmail: true,
      customErrorText: 'Invalid email',
    );

    return rule;
  }

  @computed
  bool get isContinueButtonEnabled {
    final groupRule = GroupRules(
      [profileEmailInputRule, profileNameInputRule],
      name: 'Continue Button',
      requiredAll: true,
    );

    return !groupRule.hasError;
  }

  @action
  void setProfileName(String value) {
    profileName = value;
  }

  @action
  void setProfileEmail(String value) {
    profileEmail = value;
  }
}
```

Widget
```dart
class _UpdateUserScreen extends State<UpdateUserScreen> {
  UpdateUserStore _updateUserStore = UpdateUserStore();

  void _handleProfileNameOnChange(String value) {
    _updateUserStore.setProfileName(value);
  }

  void _handleProfileEmailOnChange(String value) {
    _updateUserStore.setProfileEmail(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Display.getWidth(context),
      height: Display.getHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Observer(
            builder: (_) {
              final _errorText = _updateUserStore.profileNameInputRule?.error;

              return TextField(
                onChanged: (String value) {
                  _handleProfileNameOnChange(value);
                },
                decoration: InputDecoration(
                  hintText: 'Name',
                  errorText: _errorText,
                ),
              );
            },
          ),
          Observer(
            builder: (_) {
              final _errorText = _updateUserStore.profileEmailInputRule?.error;

              return TextField(
                onChanged: (String value) {
                  _handleProfileEmailOnChange(value);
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText: _errorText,
                ),
              );
            },
          ),
          Observer(
            builder: (_) {
              final _isContinueButtonEnabled =
                  _updateUserStore.isContinueButtonEnabled;

              if (!_isContinueButtonEnabled) {
                return Container();
              }

              return FlatButton(
                onPressed: () {},
                child: const Text('Continue'),
              );
            },
          ),
        ],
      ),
    );
  }
}

```

### Changelogs
##### 1.1.0
Breaking changes:
  - `regex` now expects a RegExp object instead of String

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
Rules | Powerful and feature-rich validation library for both Dart and Flutter. [MIT License](https://github.com/ganeshrvel/pub-rules/blob/master/LICENSE "MIT License").

Copyright © 2018 - Present Ganesh Rathinavel
