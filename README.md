# Rules

Type-safe, chainable validation library for Dart and Flutter.

Rules provides immutable, strongly typed validation schemas with a chainable API, sealed validation results, cross-field validation, and zero runtime dependencies.

```dart
final emailRule = Rule.string(
  name: 'Email',
).isRequired().isEmail();

final result = emailRule.parse('john@example.com');

print(result.ok); // true
```

## Features

* Fully typed schemas (string, integer, double, boolean)
* Immutable, reusable validation definitions
* Chainable builder API
* Sealed validation results
* Custom validators through check() and refine()
* Cross-field validation with GroupRule
* Form-wide validation aggregation with CombinedRule
* Built-in string transformations
* Per-check custom error messages with {name}/{value} templating
* Stable enum-based failure identifiers
* Pattern-matchable and fold-able validation results
* Dart and Flutter friendly
* Zero runtime dependencies

---

## Rules 2.x Users

Rules 3.x is a complete rewrite and introduces an entirely new API.

Earlier versions were based around a single untyped Rule object configured using boolean flags such as:

```dart
Rule(
isEmail: true,
isRequired: true,
);
```

Rules 3.x replaces that model with strongly typed schemas:

```dart
Rule.string(
name: 'Email',
).isRequired().isEmail();
```

There is no automated migration path between 2.x and 3.x.

If your project currently depends on Rules 2.x, continue using the 2.x release line:

* Package: Rules
* 2.x documentation: https://pub.dev/packages/rules/versions/2.2.0+1
* 3.x documentation: https://pub.dev/packages/rules

The remainder of this README documents the 3.x API.

---

## Installation

Go to https://pub.dev/packages/rules#-installing-tab- for the latest version of rules.

Then import it:

```dart
import 'package:rules/rules.dart';
```

### SDK Requirements

Rules 3.x requires:

```yaml
environment:
  sdk: ">=3.0.0 <4.0.0"
```

---

## Quick Start

```dart
final emailRule = Rule.string(
  name: 'Email',
)
    .trim()
    .toLowerCase()
    .isRequired()
    .isEmail();

final result = emailRule.parse(
  '  JOHN@EXAMPLE.COM  ',
);

print(result.ok);
print(result.validatedValue);
```

Output:

```text
true
john@example.com
```

---

## Available Schema Types

Rules ships with four strongly typed schema builders. Each one is created with a Rule factory and validated with parse(), which accepts a value of the matching type and returns a RuleResult.

### String

```dart
StringSchema Rule.string({required String name})
RuleResult<String> StringSchema.parse(String? value)
```

```dart
final rule = Rule.string(name: 'Name');

final result = rule.parse('John');
```

### Integer

```dart
IntSchema Rule.integer({required String name})
RuleResult<int> IntSchema.parse(int? value)
```

```dart
final rule = Rule.integer(name: 'Age');

final result = rule.parse(25);
```

### Double (Float)

```dart
DoubleSchema Rule.double({required String name})
RuleResult<double> DoubleSchema.parse(double? value)
```

```dart
final rule = Rule.double(name: 'Price');

final result = rule.parse(9.99);
```

### Boolean

```dart
BoolSchema Rule.boolean({required String name})
RuleResult<bool> BoolSchema.parse(bool? value)
```

```dart
final rule = Rule.boolean(name: 'Terms');

final result = rule.parse(true);
```

Each schema's parse() only accepts its own value type, so passing the wrong type is a compile error, not a runtime surprise.

---

## Reading Validation Results

Every schema returns a RuleResult<T>.

```dart
final result = Rule.string(
  name: 'Email',
)
    .isRequired()
    .isEmail()
    .parse('john@example.com');
```

Common properties:

```dart
bool get ok;
bool get hasError;
bool get hasValidatedValue;
T? get validatedValue;
RuleFailure? get error;
```

Example:

```dart
print(result.ok);
print(result.validatedValue);
```

Output:

```text
true
john@example.com
```

---

## Custom Error Messages and Templating

Every validator accepts an optional error to override its default message:

```dart
Rule.string(
  name: 'Email',
).isEmail(error: 'Please enter a valid email');
```

Both default and custom messages support two placeholders:

* {name}, the field's name
* {value}, the value being validated

```dart
Rule.integer(
  name: 'Age',
).greaterThan(18, error: '{name} must be over 18, got {value}');
```

```dart
final rule = Rule.integer(name: 'Age').greaterThan(18, error: '{name} must be over 18, got {value}');

print(rule.parse(10).error?.message);
```

Output:

```text
Age must be over 18, got 10
```

refine() uses the same placeholders in the string it returns on failure. See Custom Validation below.

---

## String Validation

Create a string schema:

```dart
final rule = Rule.string(
  name: 'Email',
);
```

### Required

```dart
StringSchema isRequired({String? error})
```

```dart
Rule.string(
  name: 'Email',
).isRequired();
```

A null or empty string fails isRequired. If isRequired() is not chained, a missing value simply passes with no error and skips every other check.

### Transforms

Transforms run before validation, in this order: trim(), then toLowerCase() or toUpperCase().

```dart
StringSchema trim()
StringSchema toLowerCase()
StringSchema toUpperCase()
```

```dart
Rule.string(
  name: 'Email',
)
    .trim()
    .toLowerCase();
```

Example:

```dart
final result = Rule.string(
  name: 'Email',
)
    .trim()
    .toLowerCase()
    .isEmail()
    .parse('  JOHN@EXAMPLE.COM  ');

print(result.validatedValue);
```

Output:

```text
john@example.com
```

### Format Validation

```dart
StringSchema isEmail({String? error})
StringSchema isUrl({String? error})
StringSchema isPhone({String? error})
StringSchema isIp({String? error})
StringSchema isNumeric({String? error})
StringSchema isNumericDecimal({String? error})
```

Example:

```dart
final result = Rule.string(
  name: 'Website',
)
    .isUrl()
    .parse('https://example.com');

print(result.ok);
```

Output:

```text
true
```

```dart
final result = Rule.string(
  name: 'Website',
)
    .isUrl()
    .parse('not a url');

print(result.error?.message);
```

Output:

```text
Website is not a valid URL
```

### Length Validation

```dart
StringSchema length(int equals, {String? error})
StringSchema minLength(int characters, {String? error})
StringSchema maxLength(int characters, {String? error})
```

Example:

```dart
final result = Rule.string(
  name: 'Password',
)
    .minLength(8)
    .maxLength(32)
    .parse('abc');

print(result.error?.message);
```

Output:

```text
Password should contain at least 8 characters
```

### Character Validation

```dart
StringSchema isAlphaSpace({String? error})
StringSchema isAlphaNumeric({String? error})
StringSchema isAlphaNumericSpace({String? error})
StringSchema regex(RegExp pattern, {String? error})
```

### Numeric Comparison

```dart
StringSchema greaterThan(String than, {String? error})
StringSchema greaterThanOrEqualTo(String than, {String? error})
StringSchema lessThan(String than, {String? error})
StringSchema lessThanOrEqualTo(String than, {String? error})
```

These parse both the value and the comparison target as numbers first, then compare them, so '9' is treated as greater than '8', decimals and all.

```dart
final passResult = Rule.string(
  name: 'Price',
).greaterThan('99.5').parse('100');

print(passResult.ok);
```

Output:

```text
true
```

```dart
final failResult = Rule.string(
  name: 'Price',
).greaterThan('99.5').parse('9');

print(failResult.error?.message);
```

Output:

```text
Price should be greater than 99.5
```

'9' sorts before '99.5' as plain text, but as numbers 9 is not greater than 99.5, so the check still fails correctly.

```dart
final result = Rule.string(
  name: 'Price',
).lessThanOrEqualTo('10').parse('abc');

print(result.error?.message);
```

Output:

```text
Price is not a valid number
```

If either side is not a valid number, the check fails with that exact message, {name} is not a valid number, rather than attempting the comparison at all.

### Equality Comparison

```dart
StringSchema equalTo(String to, {String? error})
StringSchema notEqualTo(String to, {String? error})
```

These compare the string exactly as written. No number parsing is involved, so they work just as well on plain text.

```dart
final result = Rule.string(
  name: 'Status',
).equalTo('active').parse('active');

print(result.ok);
```

Output:

```text
true
```

```dart
final result = Rule.string(
  name: 'Status',
).equalTo('100').parse('100.0');

print(result.error?.message);
```

Output:

```text
Status should be equal to 100
```

'100' and '100.0' are different strings, even though they are the same number. equalTo and notEqualTo never parse numbers.

### Collection Validation

```dart
StringSchema inList(List<String> values, {String? error})
StringSchema notInList(List<String> values, {String? error})
```

### Field Matching

```dart
StringSchema shouldMatch(String other, {String? error})
StringSchema shouldNotMatch(String other, {String? error})
```

### Custom Validation

```dart
StringSchema check(bool Function(String value) test, {String? error})
StringSchema refine(String? Function(String value) validator)
```

```dart
final rule = Rule.string(
  name: 'User ID',
).check(
  (value) => value.startsWith('USR'),
  error: '{name} must start with USR',
);

print(rule.parse('ABC123').error?.message);
```

Output:

```text
User ID must start with USR
```

```dart
final rule = Rule.string(
  name: 'User ID',
).refine(
  (value) {
    if (value.startsWith('USR')) {
      return null;
    }

    return '{name} must start with USR';
  },
);

print(rule.parse('ABC123').error?.message);
```

Output:

```text
User ID must start with USR
```

---

## Integer Validation

Create an integer schema:

```dart
final rule = Rule.integer(
  name: 'Age',
);
```

### Available Validators

```dart
IntSchema isRequired({String? error})

IntSchema greaterThan(int than, {String? error})
IntSchema greaterThanOrEqualTo(int than, {String? error})

IntSchema lessThan(int than, {String? error})
IntSchema lessThanOrEqualTo(int than, {String? error})

IntSchema equalTo(int to, {String? error})
IntSchema notEqualTo(int to, {String? error})

IntSchema inList(List<int> values, {String? error})
IntSchema notInList(List<int> values, {String? error})

IntSchema check(bool Function(int value) test, {String? error})
IntSchema refine(String? Function(int value) validator)
```

Example:

```dart
final ageRule = Rule.integer(
  name: 'Age',
)
    .isRequired()
    .greaterThanOrEqualTo(18);

print(ageRule.parse(15).error?.message);
```

Output:

```text
Age should be greater than or equal to 18
```

0 is a valid, present value. It is not treated as missing.

---

## Double Validation (Float)

Create a double schema (Float):

```dart
final rule = Rule.double(
  name: 'Price',
);
```

### Available Validators

```dart
DoubleSchema isRequired({String? error})

DoubleSchema isInteger({String? error})

DoubleSchema greaterThan(double than, {String? error})
DoubleSchema greaterThanOrEqualTo(double than, {String? error})

DoubleSchema lessThan(double than, {String? error})
DoubleSchema lessThanOrEqualTo(double than, {String? error})

DoubleSchema equalTo(double to, {String? error})
DoubleSchema notEqualTo(double to, {String? error})

DoubleSchema inList(List<double> values, {String? error})
DoubleSchema notInList(List<double> values, {String? error})

DoubleSchema check(bool Function(double value) test, {String? error})
DoubleSchema refine(String? Function(double value) validator)
```

Example:

```dart
final priceRule = Rule.double(
  name: 'Price',
)
    .greaterThan(0);

print(priceRule.parse(-5.0).error?.message);
```

Output:

```text
Price should be greater than 0.0
```

isInteger() checks that the value has no fractional part. It does not convert the value to an int.

---

## Boolean Validation

Create a boolean schema:

```dart
final rule = Rule.boolean(
  name: 'Terms',
);
```

### Available Validators

```dart
BoolSchema isRequired({String? error})

BoolSchema isTrue({String? error})
BoolSchema isFalse({String? error})
BoolSchema equalTo(bool to, {String? error})

BoolSchema check(bool Function(bool value) test, {String? error})
BoolSchema refine(String? Function(bool value) validator)
```

Example:

```dart
final termsRule = Rule.boolean(
  name: 'Terms',
)
    .isRequired()
    .isTrue();

print(termsRule.parse(false).error?.message);
```

Output:

```text
Terms must be true
```

isTrue() and isFalse() are shortcuts for the more general equalTo(). Pick whichever reads better at the call site.

```dart
final termsRule = Rule.boolean(
  name: 'Terms',
)
    .isRequired()
    .equalTo(true);

print(termsRule.parse(false).error?.message);
```

Output:

```text
Terms should be equal to true
```

false is a valid, present value. It is not treated as missing.

---

## Fold

fold is a one-call way to handle both the success and failure case without an if or switch. Whatever you return from onOk or onError becomes the final return value of fold itself, so message below ends up holding either the formatted success string or the formatted error string, nothing else:

```dart
final message = result.fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) {
    // you can return back a custom string by manipulating it, for example:
    // return 'Some error occurred: ${error.message}';
    // or check error.message / error.check and branch into a different message
    return error.message;
  },
);
```

The inner ok.fold then tells you whether a value was actually provided (onValidatedValue), or whether the field ended up empty (onNull).

error inside onError is not just a string. It is the same RuleFailure you would get from result.error anywhere else, so error.message is only the most common thing to pull out of it. You also get error.name (the field name) and error.check (the enum identifying which validator failed).

```dart
final message = Rule.string(name: 'Email').isEmail().parse('notanemail').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => value,
    onNull: () => '',
  ),
  onError: ({required name, required error}) {
    // manipulating the message instead of returning error.message as-is
    return 'An error occurred: ${error.message}';
  },
);
```

Output:

```text
An error occurred: Email is not a valid email address
```

```dart
final message = Rule.string(name: 'Email').isEmail().parse('notanemail').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => value,
    onNull: () => '',
  ),
  onError: ({required name, required error}) {
    // branching on error.check to return a different message per validator
    if (error.check == StringCheck.isEmail) {
      return 'Please double-check the email address for $name';
    }

    return error.message;
  },
);
```

Output:

```text
Please double-check the email address for Email
```

Whatever onError returns is exactly what fold hands back to the caller. There is no extra step afterward where the original message sneaks back in, so it is safe to fully replace it.

onOk does not have to call ok.fold at all. If you only care about the field name, or you want to ignore the present or absent distinction entirely, you can return straight from onOk:

```dart
final fieldName = Rule.string(name: 'Email').isRequired().parse('hello').fold(
  onOk: (ok, {required name}) => name,
  onError: ({required name, required error}) => name,
);
```

Output:

```text
Email
```

You can also switch on ok instead of calling ok.fold, if a pattern match reads better at the call site:

```dart
final message = Rule.string(name: 'Bio').parse('   ').fold(
  onOk: (ok, {required name}) => switch (ok) {
    OkValidatedValue(:final value) => '$name: $value',
    OkNull() => '$name not provided',
  },
  onError: ({required name, required error}) => error.message,
);
```

Output:

```text
Bio:    
```

onNull does not just mean the caller passed null. It also fires when a transform like trim() turns a non-empty input into an empty one, so a string of spaces can start out looking present and still end up promoting onNull once it has been cleaned up. The examples below walk through exactly when each branch fires.

---

## Fold Examples

A value is present and passes. This line is promoted because the value is present and every check passed, so onValidatedValue fires:

```dart
final message = Rule.string(name: 'Email').isRequired().isEmail().parse('a@b.com').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) => error.message,
);
```

Output:

```text
Email: a@b.com
```

A value is present but fails a check. This line is promoted because isEmail failed, so onError fires and ok.fold is never reached:

```dart
final message = Rule.string(name: 'Email').isRequired().isEmail().parse('notanemail').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) {
    // manipulate the message instead of returning it as-is
    return 'Invalid: ${error.message}';
  },
);
```

Output:

```text
Invalid: Email is not a valid email address
```

An empty string on a required field. This line is promoted because isRequired fails before the field is ever checked for absence, so onError fires, not onNull:

```dart
final message = Rule.string(name: 'Email').isRequired().parse('').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) => error.message,
);
```

Output:

```text
Email is required
```

The same empty string on an optional field. This line is promoted because there is no isRequired to fail, so the empty string is simply treated as absent and onNull fires:

```dart
final message = Rule.string(name: 'Email').parse('').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) => error.message,
);
```

Output:

```text
Email not provided
```

null on an optional field. This line is promoted for the same reason as the empty string above, since null and an empty string are both treated as absent:

```dart
final message = Rule.string(name: 'Email').parse(null).fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) {
    // you could also inspect error.name here if you needed it
    return error.message;
  },
);
```

Output:

```text
Email not provided
```

A string of only spaces, with no trim() chained. This line is promoted because the spaces make the string non-empty, so the field counts as present and onValidatedValue fires with the spaces intact:

```dart
final message = Rule.string(name: 'Bio').parse('   ').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: "$value"',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) => error.message,
);
```

Output:

```text
Bio: "   "
```

The same input with trim() chained. This is the case worth remembering: trim collapses the spaces to an empty string before the absence check runs, so what looked like a present value a moment ago is now promoted through onNull instead:

```dart
final message = Rule.string(name: 'Bio').trim().parse('   ').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: "$value"',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) => error.message,
);
```

Output:

```text
Bio not provided
```

The same trimmed field, but now required. This line is promoted because the post-trim emptiness fails isRequired, so onError fires instead of onNull:

```dart
final message = Rule.string(name: 'Bio').isRequired().trim().parse('   ').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: "$value"',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) {
    // you could format this differently for required-field errors specifically
    return error.message;
  },
);
```

Output:

```text
Bio is required
```

Transforms applied together. This line is promoted because trim and toLowerCase both run before isEmail, so the value handed to onValidatedValue is already cleaned up:

```dart
final message = Rule.string(name: 'Email').trim().toLowerCase().isEmail().parse('  A@B.COM  ').fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) => error.message,
);
```

Output:

```text
Email: a@b.com
```

0 and false as real values. Both of these lines are promoted through onValidatedValue, because zero and false are real present values, not absence:

```dart
final scoreMessage = Rule.integer(name: 'Score').parse(0).fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) => error.message,
);

final newsletterMessage = Rule.boolean(name: 'Newsletter').parse(false).fold(
  onOk: (ok, {required name}) => ok.fold(
    onValidatedValue: ({required value}) => '$name: $value',
    onNull: () => '$name not provided',
  ),
  onError: ({required name, required error}) => error.message,
);
```

Output:

```text
Score: 0
Newsletter: false
```

---

## Pattern Matching

```dart
switch (result) {
  case Valid(:final value):
    print(value);

  case Invalid(:final failure):
    print(failure.message);
}
```

---

## Validation Order

Within a single schema, checks run in this order and stop at the first failure:

1. Transforms (trim, toLowerCase or toUpperCase) on string schemas only
2. isRequired
3. Every other validator, in the order it was chained, including check() and refine() wherever they appear

```dart
final result = Rule.string(
  name: 'Password',
).isRequired().refine((v) => 'unreachable').parse(null);

print(result.error?.message);
```

Output:

```text
Password is required
```

The refine() never runs because isRequired already failed.

---

## Custom Validation

### check()

```dart
StringSchema check(bool Function(String value) test, {String? error})
IntSchema check(bool Function(int value) test, {String? error})
DoubleSchema check(bool Function(double value) test, {String? error})
BoolSchema check(bool Function(bool value) test, {String? error})
```

Returns true for success.

```dart
final rule = Rule.integer(
  name: 'Number',
)
    .check(
      (value) => value.isEven,
      error: '{name} must be even',
    );

print(rule.parse(3).error?.message);
```

Output:

```text
Number must be even
```

### refine()

```dart
StringSchema refine(String? Function(String value) validator)
IntSchema refine(String? Function(int value) validator)
DoubleSchema refine(String? Function(double value) validator)
BoolSchema refine(String? Function(bool value) validator)
```

Returns an error message for failure, or null for success. The returned string is used as-is and supports {name}/{value}.

```dart
final rule = Rule.integer(
  name: 'Age',
)
    .refine(
      (value) {
        if (value >= 18) {
          return null;
        }

        return '{name} must be at least 18, got {value}';
      },
    );

print(rule.parse(15).error?.message);
```

Output:

```text
Age must be at least 18, got 15
```

check() and refine() run in the order they are chained, alongside every other validator. Both follow the same first-failure-wins order described below.

---

## RuleFailure

```dart
final class RuleFailure {
  final String name;
  final String message;
  final RuleCheck check;
}
```

Failed validations return a RuleFailure.

```dart
final result = Rule.string(
  name: 'Email',
)
    .isEmail()
    .parse('invalid');

print(result.error?.message);
print(result.error?.check);
```

Output:

```text
Email is not a valid email address
StringCheck.isEmail
```

The check property provides a stable enum identifier suitable for application logic, analytics, localization, or error handling.

---

## RuleField

```dart
RuleField<T> bind(T? value)
```

A RuleField binds a schema to a concrete value.

```dart
final emailField = Rule.string(
  name: 'Email',
)
    .isEmail()
    .bind('john@example.com');
```

This is primarily used by GroupRule and CombinedRule.

---

## Group Validation

GroupRule validates relationships between multiple fields. Every field is validated on its own first. Group-level rules only run once all fields have individually passed. If a field fails its own check, that is the failure you get, and the group rule is not evaluated at all.

```dart
const GroupRule({
  required String name,
  required List<Validatable?> fields,
  bool requiredAll = false,
  int? requiredAtLeast,
  int? maxAllowed,
  String? requiredAllError,
  String? requiredAtLeastError,
  String? maxAllowedError,
})
```

Parameters:

* name: the display name used in the group's own error messages. Required.
* fields: the list of bound fields to validate as a group, typically produced with schema.bind(value). Null entries in the list are ignored. Required.
* requiredAll: when true, every field in fields must be present. Defaults to false.
* requiredAtLeast: when set, at least this many fields must be present. A null value disables this check.
* maxAllowed: when set, no more than this many fields may be present. A null value disables this check.
* requiredAllError: overrides the default message used when requiredAll fails.
* requiredAtLeastError: overrides the default message used when requiredAtLeast fails.
* maxAllowedError: overrides the default message used when maxAllowed fails.

Group-level checks run in this order, stopping at the first failure: requiredAll, then requiredAtLeast, then maxAllowed. This only happens after every individual field has already passed its own validation.

### requiredAll

Fails if any field in the group is absent.

```dart
final group = GroupRule(
  name: 'Profile',
  fields: [
    firstName,
    lastName,
  ],
  requiredAll: true,
);

print(group.error);
```

Output:

```text
All fields are mandatory in Profile
```

### requiredAtLeast

Fails if fewer than the given number of fields are present.

```dart
final group = GroupRule(
  name: 'Contact Details',
  fields: [
    email,
    phone,
  ],
  requiredAtLeast: 1,
);

print(group.hasError);
```

Output:

```text
false
```

### maxAllowed

Fails if more than the given number of fields are present.

```dart
final group = GroupRule(
  name: 'Preferred Contact Method',
  fields: [
    email,
    phone,
  ],
  maxAllowed: 1,
);

print(group.hasError);
```

Output:

```text
true
```

### Custom Group Errors

Each rule above has a matching error override:

```dart
String? requiredAllError;
String? requiredAtLeastError;
String? maxAllowedError;
```

```dart
final group = GroupRule(
  name: 'Preferred Contact Method',
  fields: [email, phone],
  maxAllowed: 1,
  maxAllowedError: 'Choose only one contact method',
);

print(group.error);
```

Output:

```text
Choose only one contact method
```

### Reading Results

```dart
GroupResult get result;
String? get error;
bool get hasError;
```

---

## Combined Validation

CombinedRule aggregates validation failures from fields and groups into one ordered list. It does not validate anything itself. It just collects failures that already happened.

```dart
const CombinedRule({
  List<Validatable?> fields = const [],
  List<GroupRule?> groups = const [],
})
```

```dart
final combined = CombinedRule(
  fields: [
    emailField,
    passwordField,
  ],
  groups: [
    contactGroup,
  ],
);

if (combined.hasError) {
  print(combined.errorList);
}
```

Example output:

```text
[
  Email is not a valid email address,
  Password is required,
  Choose only one contact method
]
```

Order matters here. Every individual field is checked first, in the order you listed them, and only after that are the groups checked, in the order you listed them. So in the example above, the email and password failures always show up before anything from contactGroup, even if contactGroup was constructed first.

---

## Flutter

Rules has no Flutter dependency and no opinion on state management. A schema is just a plain Dart object, so it plugs into whatever you are already using.

### Plain StatefulWidget

```dart
class _SignupFormState extends State<SignupForm> {
  String email = '';
  String phone = '';

  final emailRule = Rule.string(name: 'Email').isRequired().isEmail();
  final phoneRule = Rule.string(name: 'Phone').isRequired().isPhone();

  bool get canContinue {
    final group = GroupRule(
      name: 'Continue',
      fields: [
        emailRule.bind(email),
        phoneRule.bind(phone),
      ],
      requiredAll: true,
    );

    return !group.hasError;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() => email = value),
          decoration: InputDecoration(
            errorText: emailRule.parse(email).error?.message,
          ),
        ),
        TextField(
          onChanged: (value) => setState(() => phone = value),
          decoration: InputDecoration(
            errorText: phoneRule.parse(phone).error?.message,
          ),
        ),
        ElevatedButton(
          onPressed: canContinue ? () {} : null,
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
```

### ValueNotifier

```dart
final email = ValueNotifier('');
final emailRule = Rule.string(name: 'Email').isRequired().isEmail();

ValueListenableBuilder(
  valueListenable: email,
  builder: (context, value, _) {
    return TextField(
      onChanged: (v) => email.value = v,
      decoration: InputDecoration(
        errorText: emailRule.parse(value).error?.message,
      ),
    );
  },
);
```

A schema is immutable, so it is safe to keep it as a final alongside the notifier and reuse it on every rebuild.

### MobX

```dart
abstract class _SignupStoreBase with Store {
  @observable
  String email = '';

  @observable
  String phone = '';

  final emailRule = Rule.string(name: 'Email').isRequired().isEmail();
  final phoneRule = Rule.string(name: 'Phone').isRequired().isPhone();

  @computed
  String? get emailError => emailRule.parse(email).error?.message;

  @computed
  String? get phoneError => phoneRule.parse(phone).error?.message;

  @computed
  bool get canContinue {
    final group = GroupRule(
      name: 'Continue',
      fields: [
        emailRule.bind(email),
        phoneRule.bind(phone),
      ],
      requiredAll: true,
    );

    return !group.hasError;
  }

  @action
  void setEmail(String value) => email = value;
}
```

```dart
Observer(
  builder: (_) {
    return TextField(
      onChanged: store.setEmail,
      decoration: InputDecoration(errorText: store.emailError),
    );
  },
);
```

### Signals

```dart
final email = signal('');
final emailRule = Rule.string(name: 'Email').isRequired().isEmail();

final emailError = computed(() => emailRule.parse(email.value).error?.message);
```

```dart
Watch((context) {
  return TextField(
    onChanged: (v) => email.value = v,
    decoration: InputDecoration(errorText: emailError.value),
  );
});
```

In every case the pattern is the same: keep the schema itself outside of your reactive state, since it does not change, and only re-run parse() on the current value when you need a fresh result.

---

## API Reference

### StringSchema

```dart
isRequired({String? error})

trim()
toLowerCase()
toUpperCase()

isEmail({String? error})
isUrl({String? error})
isPhone({String? error})
isIp({String? error})

isNumeric({String? error})
isNumericDecimal({String? error})

isAlphaSpace({String? error})
isAlphaNumeric({String? error})
isAlphaNumericSpace({String? error})

regex(RegExp pattern, {String? error})

length(int equals, {String? error})
minLength(int characters, {String? error})
maxLength(int characters, {String? error})

greaterThan(String than, {String? error})
greaterThanOrEqualTo(String than, {String? error})

lessThan(String than, {String? error})
lessThanOrEqualTo(String than, {String? error})

equalTo(String to, {String? error})
notEqualTo(String to, {String? error})

inList(List<String> values, {String? error})
notInList(List<String> values, {String? error})

shouldMatch(String other, {String? error})
shouldNotMatch(String other, {String? error})

check(bool Function(String value) test, {String? error})
refine(String? Function(String value) validator)
```

### IntSchema

```dart
isRequired({String? error})

greaterThan(int than, {String? error})
greaterThanOrEqualTo(int than, {String? error})

lessThan(int than, {String? error})
lessThanOrEqualTo(int than, {String? error})

equalTo(int to, {String? error})
notEqualTo(int to, {String? error})

inList(List<int> values, {String? error})
notInList(List<int> values, {String? error})

check(bool Function(int value) test, {String? error})
refine(String? Function(int value) validator)
```

### DoubleSchema (Float)

```dart
isRequired({String? error})

isInteger({String? error})

greaterThan(double than, {String? error})
greaterThanOrEqualTo(double than, {String? error})

lessThan(double than, {String? error})
lessThanOrEqualTo(double than, {String? error})

equalTo(double to, {String? error})
notEqualTo(double to, {String? error})

inList(List<double> values, {String? error})
notInList(List<double> values, {String? error})

check(bool Function(double value) test, {String? error})
refine(String? Function(double value) validator)
```

### BoolSchema

```dart
isRequired({String? error})

isTrue({String? error})
isFalse({String? error})
equalTo(bool to, {String? error})

check(bool Function(bool value) test, {String? error})
refine(String? Function(bool value) validator)
```

---

## Contacts

Please feel free to contact me at ganeshrvel@outlook.com

---

## About

* Author: Ganesh Rathinavel (https://www.linkedin.com/in/ganeshrvel)
* Package URL: https://pub.dev/packages/rules
* Repo URL: https://github.com/ganeshrvel/pub-rules
* Contacts: ganeshrvel@outlook.com

---

## License

MIT License

Copyright 2018 - Present Ganesh Rathinavel
