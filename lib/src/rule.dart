import 'package:meta/meta.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/math.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/helpers/strings.dart';
import 'package:rules/src/models/rules_models.dart';

///
/// Rule Class: This is the basic building block, everything starts here.
/// Refer https://github.com/ganeshrvel/pub-rules/blob/master/README.md#1-rule-basic-rule for usage details
///
///
class Rule {
  // value for validation
  final String value;

  // placeholder name
  final String name;

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

  // if the validator fails then the corresponding [_errorTextsDict] key is added to this array.
  // which will be later used for parsing and outputing error text
  final _errorItemList = <String>[];

  // it holds the error texts; Note: maximum one error text, for now, is held here
  // this can change in the future
  final _errorList = <String>[];

  // default error text dictionary
  Map<String, String> get _errorTextsDict => {
        'isRequired': '{name} is required',
        'isEmail': '{name} is not a valid email address',
        'isPhone': '{name} is not a valid phone number',
        'isUrl': '{name} is not a valid URL',
        'isIp': '{name} is not a valid IP address',
        'isNumeric': '{name} is not a valid number',
        'isNumericDecimal': '{name} is not a valid decimal number',
        'isAlphaSpace': 'Only alphabets and spaces are allowed in {name}',
        'isAlphaNumeric': 'Only alphabets and numbers are allowed in {name}',
        'isAlphaNumericSpace':
            'Only alphabets, numbers and spaces are allowed in {name}',
        'regex': '{name} should match the pattern: {value}',
        'length': '{name} should be $length characters long',
        'minLength': '{name} should contain at least $minLength characters',
        'maxLength': '{name} should not exceed more than $maxLength characters',
        'greaterThan': '{name} should be greater than $greaterThan',
        'greaterThanEqualTo':
            '{name} should be greater than or equal to $greaterThanEqualTo',
        'lessThan': '{name} should be less than $lessThan',
        'lessThanEqualTo':
            '{name} should be less than or equal to $lessThanEqualTo',
        'equalTo': '{name} should be equal to $equalTo',
        'notEqualTo': '{name} should not be equal to $notEqualTo',
        'equalToInList':
            '{name} should be equal to any of these values ${(equalToInList ?? []).join(', ')}',
        'notEqualToInList':
            '{name} should not be equal to any of these values ${(notEqualToInList ?? []).join(', ')}',
        'shouldMatch': '{name} should be same as $shouldMatch',
        'shouldNotMatch': '{name} should not same as $shouldNotMatch',
        'inList':
            '{name} should be any of these values ${(inList ?? []).join(', ')}',
        'notInList':
            '{name} should not be any of these values ${(notInList ?? []).join(', ')}',
      };

  Rule(
    this.value, {
    @required this.name,
    this.customErrors,
    this.customErrorText,
    this.isEmail = false,
    this.isPhone = false,
    this.isIp = false,
    this.isUrl = false,
    this.isRequired = false,
    this.isNumeric = false,
    this.isNumericDecimal = false,
    this.isAlphaSpace = false,
    this.isAlphaNumeric = false,
    this.isAlphaNumericSpace = false,
    this.regex,
    this.length,
    this.minLength,
    this.maxLength,
    this.greaterThan,
    this.greaterThanEqualTo,
    this.lessThan,
    this.lessThanEqualTo,
    this.equalTo,
    this.notEqualTo,
    this.equalToInList,
    this.notEqualToInList,
    this.inList,
    this.notInList,
    this.shouldMatch,
    this.shouldNotMatch,
  }) {
    // throw an error is 'name' parameter is missing
    if (isNullOrEmpty(name)) {
      throw "Rule => \n'name' parameter is required";
    }

    _run();
  }

  RulesModel get _rulesModel => RulesModel(errorList: _errorList);

  // outputs the error text (string)
  String get error => _rulesModel.error;

  // outputs true if there is a validation error else false
  bool get hasError => isNotNullOrEmpty(error);

  // starting point
  void _run() {
    // if any of these values are found to be not null then either [isNumeric] or [isNumericDecimal] is turned on automatically.
    // if [isNumeric] is false then [isNumericDecimal] will be set
    if (isNotNullExists(
          [
            greaterThan,
            greaterThanEqualTo,
            lessThan,
            lessThanEqualTo,
            equalTo,
            notEqualTo,
            equalToInList,
            notEqualToInList,
          ],
        ) &&
        isNumeric != true) {
      isNumericDecimal = true;
    }

    _beginValidation();

    _processErrors();
  }

  // the validation happens here
  void _beginValidation() {
    if (isRequired == true && _isRequiredCheckFailed()) {
      return;
    }

    if (isEmail == true && _isEmailCheckFailed()) {
      return;
    }

    if (isUrl == true && _isUrlCheckFailed()) {
      return;
    }

    if (isPhone == true && _isPhoneCheckFailed()) {
      return;
    }

    if (isIp == true && _isIpCheckFailed()) {
      return;
    }

    if (isNumeric == true && _isNumericCheckFailed()) {
      return;
    }

    if (isNumericDecimal == true && _isNumericDecimalCheckFailed()) {
      return;
    }

    if (isAlphaSpace == true && _isAlphaSpaceCheckFailed()) {
      return;
    }

    if (isAlphaNumeric == true && _isAlphaNumericCheckFailed()) {
      return;
    }

    if (isAlphaNumericSpace == true && _isAlphaNumericSpaceCheckFailed()) {
      return;
    }

    if (regex != null && _isRegexCheckFailed()) {
      return;
    }

    if (length != null && _isLengthCheckFailed()) {
      return;
    }

    if (minLength != null && _isMinLengthCheckFailed()) {
      return;
    }

    if (maxLength != null && _isMaxLengthCheckFailed()) {
      return;
    }

    if (greaterThan != null && _isGreaterThanCheckFailed()) {
      return;
    }

    if (greaterThanEqualTo != null && _isGreaterThanEqualToCheckFailed()) {
      return;
    }

    if (lessThan != null && _isLessThanCheckFailed()) {
      return;
    }

    if (lessThanEqualTo != null && _isLessThanEqualToCheckFailed()) {
      return;
    }

    if (equalTo != null && _isEqualToCheckFailed()) {
      return;
    }

    if (notEqualTo != null && _isNotEqualToCheckFailed()) {
      return;
    }

    if (equalToInList != null && _isEqualToInListCheckFailed()) {
      return;
    }

    if (notEqualToInList != null && _isNotEqualToInListCheckFailed()) {
      return;
    }

    if (inList != null && _isInListCheckFailed()) {
      return;
    }

    if (notInList != null && _isNotInListCheckFailed()) {
      return;
    }

    if (shouldMatch != null && _isShouldMatchCheckFailed()) {
      return;
    }

    if (shouldNotMatch != null && _isShouldNotMatchCheckFailed()) {
      return;
    }
  }

  bool _isRequiredCheckFailed() {
    if (isRequired && isNullOrEmpty(value)) {
      _errorItemList.add('isRequired');

      return true;
    }

    return false;
  }

  bool _isNumericCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringNumeric(value)) {
      _errorItemList.add('isNumeric');

      return true;
    }

    return false;
  }

  bool _isNumericDecimalCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isStringNumeric(value, allowDecimal: true)) {
      _errorItemList.add('isNumericDecimal');

      return true;
    }

    return false;
  }

  bool _isEmailCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringEmail(value)) {
      _errorItemList.add('isEmail');

      return true;
    }

    return false;
  }

  bool _isPhoneCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringPhone(value)) {
      _errorItemList.add('isPhone');

      return true;
    }

    return false;
  }

  bool _isUrlCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringUrl(value)) {
      _errorItemList.add('isUrl');

      return true;
    }

    return false;
  }

  bool _isIpCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringIp(value)) {
      _errorItemList.add('isIp');

      return true;
    }

    return false;
  }

  bool _isAlphaSpaceCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringAlphaSpace(value)) {
      _errorItemList.add('isAlphaSpace');

      return true;
    }

    return false;
  }

  bool _isAlphaNumericCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringAlphaNumeric(value)) {
      _errorItemList.add('isAlphaNumeric');

      return true;
    }

    return false;
  }

  bool _isAlphaNumericSpaceCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringAlphaNumericSpace(value)) {
      _errorItemList.add('isAlphaNumericSpace');

      return true;
    }

    return false;
  }

  bool _isRegexCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringRegexMatch(value, regex)) {
      _errorItemList.add('regex');

      return true;
    }

    return false;
  }

  bool _isLengthCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringLength(value, length)) {
      _errorItemList.add('length');

      return true;
    }

    return false;
  }

  bool _isMinLengthCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringMinLength(value, minLength)) {
      _errorItemList.add('minLength');

      return true;
    }

    return false;
  }

  bool _isMaxLengthCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringMaxLength(value, maxLength)) {
      _errorItemList.add('maxLength');

      return true;
    }

    return false;
  }

  bool _isGreaterThanCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueGreaterThan(double.tryParse(value), greaterThan)) {
      _errorItemList.add('greaterThan');

      return true;
    }

    return false;
  }

  bool _isGreaterThanEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueGreaterThanEqualTo(
            double.tryParse(value), greaterThanEqualTo)) {
      _errorItemList.add('greaterThanEqualTo');

      return true;
    }

    return false;
  }

  bool _isLessThanCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueLessThan(double.tryParse(value), lessThan)) {
      _errorItemList.add('lessThan');

      return true;
    }

    return false;
  }

  bool _isLessThanEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueLessThanEqualTo(double.tryParse(value), lessThanEqualTo)) {
      _errorItemList.add('lessThanEqualTo');

      return true;
    }

    return false;
  }

  bool _isEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) && double.tryParse(value) != equalTo) {
      _errorItemList.add('equalTo');

      return true;
    }

    return false;
  }

  bool _isNotEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) && double.tryParse(value) == notEqualTo) {
      _errorItemList.add('notEqualTo');

      return true;
    }

    return false;
  }

  bool _isEqualToInListCheckFailed() {
    if (isNotNullOrEmpty(value)) {
      final _value = double.tryParse(value);

      if (!inArray(equalToInList, _value)) {
        _errorItemList.add('equalToInList');

        return true;
      }
    }

    return false;
  }

  bool _isNotEqualToInListCheckFailed() {
    if (isNotNullOrEmpty(value)) {
      final _value = double.tryParse(value);

      if (inArray(notEqualToInList, _value)) {
        _errorItemList.add('notEqualToInList');

        return true;
      }
    }

    return false;
  }

  bool _isInListCheckFailed() {
    if (isNotNullOrEmpty(value) && !inArray(inList, value)) {
      _errorItemList.add('inList');

      return true;
    }

    return false;
  }

  bool _isNotInListCheckFailed() {
    if (isNotNullOrEmpty(value) && inArray(notInList, value)) {
      _errorItemList.add('notInList');

      return true;
    }

    return false;
  }

  bool _isShouldMatchCheckFailed() {
    if (isNotNullOrEmpty(value) && shouldMatch != value) {
      _errorItemList.add('shouldMatch');

      return true;
    }

    return false;
  }

  bool _isShouldNotMatchCheckFailed() {
    if (isNotNullOrEmpty(value) && shouldNotMatch == value) {
      _errorItemList.add('shouldNotMatch');

      return true;
    }

    return false;
  }

  // process errors from [_errorItemList]
  void _processErrors() {
    if (isNullOrEmpty(_errorItemList)) {
      return;
    }

    if (isNotNullOrEmpty(customErrorText)) {
      _assignErrorValues(customErrorText);

      return;
    }

    for (final item in _errorItemList) {
      if (isNotNull(customErrors) && customErrors.containsKey(item)) {
        final _errorText = customErrors[item];

        _assignErrorValues(_errorText);

        continue;
      }

      final _errorText = _errorTextsDict[item];

      _assignErrorValues(_errorText);
    }
  }

  // update [_errorList] if any error is found
  void _assignErrorValues(String _errorText) {
    if (isNullOrEmpty(_errorText)) {
      return;
    }

    var _replacedErrorText = _errorText.replaceAll('{name}', name);

    _replacedErrorText =
        _replacedErrorText.replaceAll('{value}', value ?? 'null');

    _errorList.add(_replacedErrorText);
  }
}
