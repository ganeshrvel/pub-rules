// ignore_for_file: avoid_print

/// Usage examples:
///
/// For more examples refer to https://github.com/ganeshrvel/pub-rules/blob/master/README.md
library;

import 'package:rules/rules.dart';

void main() {
  stringValidationExamples();
  integerValidationExamples();
  doubleValidationExamples();
  booleanValidationExamples();
  transformExamples();
  customErrorExamples();
  checkAndRefineExamples();
  foldExamples();
  patternMatchingExample();
  groupRuleExamples();
  combinedRuleExample();
}

void stringValidationExamples() {
  print('--- String Validation ---');

  final emailRule = Rule.string(name: 'Email').isRequired().isEmail();

  final validEmail = emailRule.parse('john@example.com');
  print(validEmail.ok); // true
  print(validEmail.validatedValue); // john@example.com

  final missingEmail = emailRule.parse('');
  print(missingEmail.hasError); // true
  print(missingEmail.error?.message); // Email is required

  final badEmail = emailRule.parse('notanemail');
  print(badEmail.hasError); // true
  print(badEmail.error?.message); // Email is not a valid email address

  final urlRule = Rule.string(name: 'Website').isUrl();
  print(urlRule.parse('https://example.com').ok); // true
  print(
    urlRule.parse('not a url').error?.message,
  ); // Website is not a valid URL

  final phoneRule = Rule.string(name: 'Phone').isPhone();
  print(phoneRule.parse('+1-9090909090').ok); // true

  final ipRule = Rule.string(name: 'IP Address').isIp();
  print(ipRule.parse('1.1.1.1').ok); // true
  print(
    ipRule.parse('999.999.999.999').error?.message,
  ); // IP Address is not a valid IP address

  final numericRule = Rule.string(name: 'Quantity').isNumeric();
  print(numericRule.parse('42').ok); // true
  print(
    numericRule.parse('4.2').error?.message,
  ); // Quantity is not a valid number

  final decimalRule = Rule.string(name: 'Price').isNumericDecimal();
  print(decimalRule.parse('19.99').ok); // true

  final alphaSpaceRule = Rule.string(name: 'Full Name').isAlphaSpace();
  print(alphaSpaceRule.parse('Jane Doe').ok); // true
  print(
    alphaSpaceRule.parse('Jane123').error?.message,
  ); // Only alphabets and spaces are allowed in Full Name

  final alphaNumericRule = Rule.string(name: 'Username').isAlphaNumeric();
  print(alphaNumericRule.parse('user123').ok); // true

  final alphaNumericSpaceRule =
      Rule.string(name: 'Title').isAlphaNumericSpace();
  print(alphaNumericSpaceRule.parse('Bread 20').ok); // true

  final regexRule =
      Rule.string(name: 'Code').regex(RegExp(r'^[A-Z]{3}-\d{4}$'));
  print(regexRule.parse('ABC-1234').ok); // true
  print(
    regexRule.parse('abc-1234').error?.message,
  ); // Code should match the pattern: ^[A-Z]{3}-\d{4}$

  final lengthRule = Rule.string(name: 'PIN').length(4);
  print(lengthRule.parse('1234').ok); // true
  print(
    lengthRule.parse('123').error?.message,
  ); // PIN should be 4 characters long

  final minLengthRule = Rule.string(name: 'Password').minLength(8);
  print(minLengthRule.parse('abcd1234').ok); // true
  print(
    minLengthRule.parse('abc').error?.message,
  ); // Password should contain at least 8 characters

  final maxLengthRule = Rule.string(name: 'Username').maxLength(16);
  print(
    maxLengthRule.parse('this_username_is_way_too_long').error?.message,
  ); // Username should not exceed more than 16 characters

  final greaterThanRule = Rule.string(name: 'Price').greaterThan(50);
  print(greaterThanRule.parse('100').ok); // true
  print(
    greaterThanRule.parse('10').error?.message,
  ); // Price should be greater than 50

  final greaterThanOrEqualRule =
      Rule.string(name: 'Score').greaterThanOrEqualTo(50);
  print(greaterThanOrEqualRule.parse('50').ok); // true

  final lessThanRule = Rule.string(name: 'Discount').lessThan(100);
  print(lessThanRule.parse('99').ok); // true

  final lessThanOrEqualRule =
      Rule.string(name: 'Discount').lessThanOrEqualTo(100);
  print(lessThanOrEqualRule.parse('100').ok); // true

  final equalToRule = Rule.string(name: 'Status').equalTo('active');
  print(equalToRule.parse('active').ok); // true
  print(
    equalToRule.parse('inactive').error?.message,
  ); // Status should be equal to active

  final notEqualToRule = Rule.string(name: 'Status').notEqualTo('blocked');
  print(notEqualToRule.parse('pending').ok); // true

  final inListRule = Rule.string(name: 'Role').inList(['admin', 'user']);
  print(inListRule.parse('admin').ok); // true
  print(
    inListRule.parse('guest').error?.message,
  ); // Role should be any of these values admin, user

  final notInListRule = Rule.string(name: 'Role').notInList(['blocked']);
  print(notInListRule.parse('admin').ok); // true

  final shouldMatchRule =
      Rule.string(name: 'Confirm Password').shouldMatch('abc123');
  print(shouldMatchRule.parse('abc123').ok); // true
  print(
    shouldMatchRule.parse('xyz789').error?.message,
  ); // Confirm Password should be same as abc123

  final shouldNotMatchRule =
      Rule.string(name: 'New Password').shouldNotMatch('oldPassword');
  print(shouldNotMatchRule.parse('newPassword').ok); // true

  print('');
}

void integerValidationExamples() {
  print('--- Integer Validation ---');

  final ageRule =
      Rule.integer(name: 'Age').isRequired().greaterThanOrEqualTo(18);
  print(ageRule.parse(25).ok); // true
  print(
    ageRule.parse(15).error?.message,
  ); // Age should be greater than or equal to 18
  print(ageRule.parse(null).error?.message); // Age is required

  print(
    Rule.integer(name: 'Score').parse(0).hasValidatedValue,
  ); // true, zero is present

  final greaterThanRule = Rule.integer(name: 'Quantity').greaterThan(0);
  print(greaterThanRule.parse(5).ok); // true
  print(
    greaterThanRule.parse(0).error?.message,
  ); // Quantity should be greater than 0

  final lessThanRule = Rule.integer(name: 'Attempts').lessThan(3);
  print(lessThanRule.parse(2).ok); // true

  final equalToRule = Rule.integer(name: 'Lives').equalTo(3);
  print(equalToRule.parse(3).ok); // true

  final notEqualToRule = Rule.integer(name: 'Code').notEqualTo(0);
  print(notEqualToRule.parse(1).ok); // true

  final inListRule = Rule.integer(name: 'Rating').inList([1, 2, 3, 4, 5]);
  print(inListRule.parse(3).ok); // true
  print(
    inListRule.parse(10).error?.message,
  ); // Rating should be any of these values 1, 2, 3, 4, 5

  final evenRule = Rule.integer(name: 'Number')
      .check((v) => v.isEven, error: '{name} must be even');
  print(evenRule.parse(4).ok); // true
  print(evenRule.parse(3).error?.message); // Number must be even

  print('');
}

void doubleValidationExamples() {
  print('--- Double Validation (Float) ---');

  final priceRule = Rule.double(name: 'Price').isRequired().greaterThan(0);
  print(priceRule.parse(9.99).ok); // true
  print(
    priceRule.parse(-5.0).error?.message,
  ); // Price should be greater than 0.0

  print(
    Rule.double(name: 'Balance').parse(0.0).hasValidatedValue,
  ); // true, zero is present

  final integerOnlyRule = Rule.double(name: 'Quantity').isInteger();
  print(integerOnlyRule.parse(5.0).ok); // true
  print(
    integerOnlyRule.parse(5.5).error?.message,
  ); // Quantity should be a whole number

  final rangeRule = Rule.double(name: 'Discount')
      .greaterThanOrEqualTo(0)
      .lessThanOrEqualTo(100);
  print(rangeRule.parse(50.0).ok); // true
  print(
    rangeRule.parse(150.0).error?.message,
  ); // Discount should be less than or equal to 100.0

  final equalToRule = Rule.double(name: 'Total').equalTo(10.0);
  print(
    equalToRule.parse(10.0).ok,
  ); // true, 10.0 and 10 compare equal as doubles

  print('');
}

void booleanValidationExamples() {
  print('--- Boolean Validation ---');

  final termsRule = Rule.boolean(name: 'Terms').isRequired().isTrue();
  print(termsRule.parse(true).ok); // true
  print(termsRule.parse(false).error?.message); // Terms must be true
  print(termsRule.parse(null).error?.message); // Terms is required

  print(
    Rule.boolean(name: 'Newsletter').parse(false).hasValidatedValue,
  ); // true, false is present

  final hiddenRule = Rule.boolean(name: 'Hidden').isFalse();
  print(hiddenRule.parse(false).ok); // true

  final equalToRule = Rule.boolean(name: 'Subscribed').equalTo(true);
  print(
    equalToRule.parse(false).error?.message,
  ); // Subscribed should be equal to true

  print('');
}

void transformExamples() {
  print('--- Transforms ---');

  final emailRule = Rule.string(name: 'Email').trim().toLowerCase().isEmail();
  final transformed = emailRule.parse('  JOHN@EXAMPLE.COM  ');
  print(transformed.validatedValue); // john@example.com

  final upperRule = Rule.string(name: 'Code').toUpperCase();
  print(upperRule.parse('abc123').validatedValue); // ABC123

  final trimOnlyRule = Rule.string(name: 'Bio').parse('   ');
  print(
    trimOnlyRule.hasValidatedValue,
  ); // true, spaces are non-empty without trim()

  final trimmedRule = Rule.string(name: 'Bio').trim().parse('   ');
  print(trimmedRule.hasValidatedValue); // false, trim collapses to empty

  print('');
}

void customErrorExamples() {
  print('--- Custom Error Messages and Templating ---');

  final rule =
      Rule.string(name: 'Email').isEmail(error: 'Please enter a valid email');
  print(rule.parse('bad').error?.message); // Please enter a valid email

  final templatedRule = Rule.integer(name: 'Age')
      .greaterThan(18, error: '{name} must be over 18, got {value}');
  print(templatedRule.parse(10).error?.message); // Age must be over 18, got 10

  print('');
}

void checkAndRefineExamples() {
  print('--- check() and refine() ---');

  final checkRule = Rule.string(name: 'User ID').check(
    (value) => value.startsWith('USR'),
    error: '{name} must start with USR',
  );
  print(
    checkRule.parse('ABC123').error?.message,
  ); // User ID must start with USR

  final refineRule = Rule.integer(name: 'Age').refine((value) {
    if (value >= 18) {
      return null;
    }

    return '{name} must be at least 18, got {value}';
  });
  print(refineRule.parse(15).error?.message); // Age must be at least 18, got 15
  print(refineRule.parse(21).ok); // true

  print('');
}

void foldExamples() {
  print('--- Fold ---');

  final result =
      Rule.string(name: 'Email').isRequired().isEmail().parse('a@b.com');

  final message = result.fold(
    onOk: (ok, {required name}) => ok.fold(
      onValidatedValue: ({required value}) => '$name: $value',
      onNull: () => '$name not provided',
    ),
    onError: ({required name, required error}) {
      // you can return back a custom string by manipulating it, for example:
      return 'Some error occurred: ${error.message}';
    },
  );
  print(message); // Email: a@b.com

  final errorResult = Rule.string(name: 'Email').isEmail().parse('notanemail');
  final errorMessage = errorResult.fold(
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
  print(errorMessage); // Please double-check the email address for Email

  print('');
}

void patternMatchingExample() {
  print('--- Pattern Matching ---');

  final result =
      Rule.string(name: 'Email').isRequired().isEmail().parse('a@b.com');

  switch (result) {
    case Valid(:final value):
      print('Valid: $value'); // Valid: a@b.com

    case Invalid(:final failure):
      print('Invalid: ${failure.message}');
  }

  print('');
}

void groupRuleExamples() {
  print('--- Group Validation ---');

  final firstName = Rule.string(name: 'First Name').bind('John');
  final lastName = Rule.string(name: 'Last Name').bind('');

  final requiredAllGroup = GroupRule(
    name: 'Profile',
    fields: [firstName, lastName],
    requiredAll: true,
  );
  print(requiredAllGroup.error); // All fields are mandatory in Profile

  final email = Rule.string(name: 'Email').bind('');
  final phone = Rule.string(name: 'Phone').bind('1234567890');

  final requiredAtLeastGroup = GroupRule(
    name: 'Contact Details',
    fields: [email, phone],
    requiredAtLeast: 1,
  );
  print(requiredAtLeastGroup.hasError); // false

  final preferredEmail = Rule.string(name: 'Email').bind('abc@xyz.com');
  final preferredPhone = Rule.string(name: 'Phone').bind('1234567890');

  final maxAllowedGroup = GroupRule(
    name: 'Preferred Contact Method',
    fields: [preferredEmail, preferredPhone],
    maxAllowed: 1,
    maxAllowedError: 'Choose only one contact method',
  );
  print(maxAllowedGroup.error); // Choose only one contact method

  print('');
}

void combinedRuleExample() {
  print('--- Combined Validation ---');

  final emailField = Rule.string(name: 'Email').isEmail().bind('invalid');
  final passwordField = Rule.string(name: 'Password').isRequired().bind('');

  final contactEmail = Rule.string(name: 'Contact Email').bind('abc@xyz.com');
  final contactPhone = Rule.string(name: 'Contact Phone').bind('1234567890');

  final contactGroup = GroupRule(
    name: 'Contact Method',
    fields: [contactEmail, contactPhone],
    maxAllowed: 1,
    maxAllowedError: 'Choose only one contact method',
  );

  final combined = CombinedRule(
    fields: [emailField, passwordField],
    groups: [contactGroup],
  );

  print(combined.hasError); // true
  print(combined.errorList);
  // [
  //   Email is not a valid email address,
  //   Password is required,
  //   Choose only one contact method
  // ]

  print('');
}
