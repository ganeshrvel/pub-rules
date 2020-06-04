import 'package:meta/meta.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/math.dart';
import 'package:rules/src/helpers/types.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/helpers/strings.dart';
import 'package:rules/src/models/rules_models.dart';

class Rules<T> {
  final T value;

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

  final List<String> inList;

  final List<String> notInList;

  final String shouldMatch;

  final String shouldNotMatch;

  final _errorItemList = <dynamic>[];

  final _errorList = <String>[];

  final Map<String, String> customErrorTexts;

  final _allowedValueDataTypes = [String];

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
        'inList':
            '{name} should be any of these values ${(inList ?? []).join(', ')}',
        'notInList':
            '{name} should not be any of these values ${(notInList ?? []).join(', ')}',
        'shouldMatch': '{name} should be same as $shouldMatch',
        'shouldNotMatch': '{name} should not same as $shouldNotMatch',
      };

  Rules(
    this.value, {
    @required this.name,
    this.customErrorTexts,
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
    if (isNull(value)) {
      throw "Rules => \nThe 'value' cannot be null.\n"
          "Use null-aware operator '??' if required.\n"
          'Example: `final rule = Rules(value ?? null)`.';
    }

    if (!isTypesEqual(T, _allowedValueDataTypes)) {
      throw "Rules => \n'$T' data type isn't supported yet.";
    }

    if (isNullOrEmpty(name)) {
      throw "Rules => \n'name' parameter is required";
    }

    _run();
  }

  RulesModel get _rulesModel => RulesModel(errorList: _errorList);

  String get error => _rulesModel.error;

  bool get hasError => isNotNullOrEmpty(error);

  void _run() {
    switch (T) {
      case String:
        _initStringValidation();

        break;

      default:
        break;
    }
  }

  void _initStringValidation() {
    final _allowedRulesList = {
      'isRequired': isRequired,
      'isNumeric': isNumeric,
      'isNumericDecimal': isNumericDecimal,
      'isEmail': isEmail,
      'isPhone': isPhone,
      'isUrl': isUrl,
      'isIp': isIp,
      'isAlphaSpace': isAlphaSpace,
      'isAlphaNumeric': isAlphaNumeric,
      'isAlphaNumericSpace': isAlphaNumericSpace,
      'regex': regex,
      'length': length,
      'minLength': minLength,
      'maxLength': maxLength,
      'greaterThan': greaterThan,
      'greaterThanEqualTo': greaterThanEqualTo,
      'lessThan': lessThan,
      'lessThanEqualTo': lessThanEqualTo,
      'equalTo': equalTo,
      'notEqualTo': notEqualTo,
      'equalToInList': equalToInList,
      'notEqualToInList': notEqualToInList,
      'inList': inList,
      'notInList': notInList,
      'shouldMatch': shouldMatch,
      'shouldNotMatch': shouldNotMatch,
    };

    if (isValuesNotNull(
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

    _beginValidation(_allowedRulesList);
  }

  void _processErrors() {
    if (isNullOrEmpty(_errorItemList)) {
      return;
    }

    for (final item in _errorItemList) {
      if (isNotNull(customErrorTexts) && customErrorTexts.containsKey(item)) {
        final _errorText = customErrorTexts[item];

        _assignErrorValues(_errorText);

        continue;
      }

      final _errorText = _errorTextsDict[item];

      _assignErrorValues(_errorText);
    }
  }

  void _assignErrorValues(String _errorText) {
    if (isNullOrEmpty(_errorText)) {
      return;
    }

    var _replacedErrorText = _errorText.replaceAll('{name}', name);

    switch (T) {
      case String:
        _replacedErrorText =
            _replacedErrorText.replaceAll('{value}', value as String);
        break;
      case int:
        _replacedErrorText =
            _replacedErrorText.replaceAll('{value}', (value as int).toString());
        break;
      case double:
        _replacedErrorText = _replacedErrorText.replaceAll(
            '{value}', (value as double).toString());
        break;
      case num:
        _replacedErrorText =
            _replacedErrorText.replaceAll('{value}', (value as num).toString());
        break;
    }

    _errorList.add(_replacedErrorText);
  }

  void _beginValidation(Map<String, dynamic> _allowedRulesList) {
    for (final key in _allowedRulesList.keys) {
      if (key == 'isRequired' &&
          isRequired == true &&
          _isRequiredCheckFailed()) {
        break;
      }

      if (key == 'isEmail' && isEmail == true && _isEmailCheckFailed()) {
        break;
      }

      if (key == 'isUrl' && isUrl == true && _isUrlCheckFailed()) {
        break;
      }

      if (key == 'isPhone' && isPhone == true && _isPhoneCheckFailed()) {
        break;
      }

      if (key == 'isIp' && isIp == true && _isIpCheckFailed()) {
        break;
      }

      if (key == 'isNumeric' && isNumeric == true && _isNumericCheckFailed()) {
        break;
      }

      if (key == 'isNumericDecimal' &&
          isNumericDecimal == true &&
          _isNumericDecimalCheckFailed()) {
        break;
      }

      if (key == 'isAlphaSpace' &&
          isAlphaSpace == true &&
          _isAlphaSpaceCheckFailed()) {
        break;
      }

      if (key == 'isAlphaNumeric' &&
          isAlphaNumeric == true &&
          _isAlphaNumericCheckFailed()) {
        break;
      }

      if (key == 'isAlphaNumericSpace' &&
          isAlphaNumericSpace == true &&
          _isAlphaNumericSpaceCheckFailed()) {
        break;
      }

      if (key == 'regex' && regex != null && _isRegexCheckFailed()) {
        break;
      }

      if (key == 'length' && length != null && _isLengthCheckFailed()) {
        break;
      }

      if (key == 'minLength' &&
          minLength != null &&
          _isMinLengthCheckFailed()) {
        break;
      }

      if (key == 'maxLength' &&
          maxLength != null &&
          _isMaxLengthCheckFailed()) {
        break;
      }

      if (key == 'greaterThan' &&
          greaterThan != null &&
          _isGreaterThanCheckFailed()) {
        break;
      }

      if (key == 'greaterThanEqualTo' &&
          greaterThanEqualTo != null &&
          _isGreaterThanEqualToCheckFailed()) {
        break;
      }

      if (key == 'lessThan' && lessThan != null && _isLessThanCheckFailed()) {
        break;
      }

      if (key == 'lessThanEqualTo' &&
          lessThanEqualTo != null &&
          _isLessThanEqualToCheckFailed()) {
        break;
      }

      if (key == 'equalTo' && equalTo != null && _isEqualToCheckFailed()) {
        break;
      }

      if (key == 'notEqualTo' &&
          notEqualTo != null &&
          _isNotEqualToCheckFailed()) {
        break;
      }

      if (key == 'equalToInList' &&
          equalToInList != null &&
          _isEqualToInListCheckFailed()) {
        break;
      }

      if (key == 'notEqualToInList' &&
          notEqualToInList != null &&
          _isNotEqualToInListCheckFailed()) {
        break;
      }

      if (key == 'inList' && inList != null && _isInListCheckFailed()) {
        break;
      }

      if (key == 'notInList' &&
          notInList != null &&
          _isNotInListCheckFailed()) {
        break;
      }

      if (key == 'shouldMatch' &&
          shouldMatch != null &&
          _isShouldMatchCheckFailed()) {
        break;
      }

      if (key == 'shouldNotMatch' &&
          shouldNotMatch != null &&
          _isShouldNotMatchCheckFailed()) {
        break;
      }
    }

    _processErrors();
  }

  bool _isRequiredCheckFailed() {
    if (isRequired && isNullOrEmpty(value)) {
      _errorItemList.add('isRequired');

      return true;
    }

    return false;
  }

  bool _isNumericCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringNumeric(value as String)) {
      _errorItemList.add('isNumeric');

      return true;
    }

    return false;
  }

  bool _isNumericDecimalCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isStringNumeric(value as String, allowDecimal: true)) {
      _errorItemList.add('isNumericDecimal');

      return true;
    }

    return false;
  }

  bool _isEmailCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringEmail(value as String)) {
      _errorItemList.add('isEmail');

      return true;
    }

    return false;
  }

  bool _isPhoneCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringPhone(value as String)) {
      _errorItemList.add('isPhone');

      return true;
    }

    return false;
  }

  bool _isUrlCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringUrl(value as String)) {
      _errorItemList.add('isUrl');

      return true;
    }

    return false;
  }

  bool _isIpCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringIp(value as String)) {
      _errorItemList.add('isIp');

      return true;
    }

    return false;
  }

  bool _isAlphaSpaceCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringAlphaSpace(value as String)) {
      _errorItemList.add('isAlphaSpace');

      return true;
    }

    return false;
  }

  bool _isAlphaNumericCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringAlphaNumeric(value as String)) {
      _errorItemList.add('isAlphaNumeric');

      return true;
    }

    return false;
  }

  bool _isAlphaNumericSpaceCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isStringAlphaNumericSpace(value as String)) {
      _errorItemList.add('isAlphaNumericSpace');

      return true;
    }

    return false;
  }

  bool _isRegexCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isStringRegexMatch(value as String, regex)) {
      _errorItemList.add('regex');

      return true;
    }

    return false;
  }

  bool _isLengthCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringLength(value as String, length)) {
      _errorItemList.add('length');

      return true;
    }

    return false;
  }

  bool _isMinLengthCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isStringMinLength(value as String, minLength)) {
      _errorItemList.add('minLength');

      return true;
    }

    return false;
  }

  bool _isMaxLengthCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isStringMaxLength(value as String, maxLength)) {
      _errorItemList.add('maxLength');

      return true;
    }

    return false;
  }

  bool _isGreaterThanCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueGreaterThan(double.tryParse(value as String), greaterThan)) {
      _errorItemList.add('greaterThan');

      return true;
    }

    return false;
  }

  bool _isGreaterThanEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueGreaterThanEqualTo(
            double.tryParse(value as String), greaterThanEqualTo)) {
      _errorItemList.add('greaterThanEqualTo');

      return true;
    }

    return false;
  }

  bool _isLessThanCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueLessThan(double.tryParse(value as String), lessThan)) {
      _errorItemList.add('lessThan');

      return true;
    }

    return false;
  }

  bool _isLessThanEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueLessThanEqualTo(
            double.tryParse(value as String), lessThanEqualTo)) {
      _errorItemList.add('lessThanEqualTo');

      return true;
    }

    return false;
  }

  bool _isEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        double.tryParse(value as String) != equalTo) {
      _errorItemList.add('equalTo');

      return true;
    }

    return false;
  }

  bool _isNotEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        double.tryParse(value as String) == notEqualTo) {
      _errorItemList.add('notEqualTo');

      return true;
    }

    return false;
  }

  bool _isEqualToInListCheckFailed() {
    if (isNotNullOrEmpty(value)) {
      final _value = double.tryParse(value as String);

      if (!inArray(equalToInList, _value)) {
        _errorItemList.add('equalToInList');

        return true;
      }
    }

    return false;
  }

  bool _isNotEqualToInListCheckFailed() {
    if (isNotNullOrEmpty(value)) {
      final _value = double.tryParse(value as String);

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
}
