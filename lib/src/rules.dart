import 'package:meta/meta.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/helpers/strings.dart';
import 'package:rules/src/models/rules_models.dart';

class Rules<T> {
  final T value;

  final String name;

  final bool isRequired;

  final bool isNumeric;

  final bool isNumericDecimal;

  final bool isEmail;

  final bool isAlphaSpace;

  final int length;

  final int minLength;

  final _errorItemList = <dynamic>[];

  final _errorList = <String>[];

  final Map<String, String> customErrorTexts;

  final _allowedValueDataTypes = [String];

  final Map<String, String> _errorTexts = {
    'isRequired': '{name} is required',
    'isNumeric': '{name} is not a valid number',
    'isNumericDecimal': '{name} is not a valid number',
    'isEmail': '{name} is not a valid email address',
    'isAlphaSpace': 'Only alphabets and spaces are allowed in {name}',
    'length': '{name} should be {value} characters long',
    'minLength': '{name} should be minimum {value} characters long',
  };

  Rules(
    this.value, {
    @required this.name,
    this.isRequired = false,
    this.isNumeric = false,
    this.isNumericDecimal = false,
    this.isEmail = false,
    this.isAlphaSpace = false,
    this.length,
    this.minLength,
    this.customErrorTexts,
  }) {
    if (isNull(value)) {
      throw "The 'value' cannot be null.\n"
          "Use null-aware operator '??' if required.\n"
          'Example: `final rule = Rules(value ?? null)`.';
    }

    if (!isTypesEqual(T, _allowedValueDataTypes)) {
      throw "'$T' data type isn't supported yet.";
    }

    if (isNullOrEmpty(name)) {
      throw "'name' parameter is required";
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
      'length': length,
      'minLength': minLength,
      'isAlphaSpace': isAlphaSpace,
    };

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

      final _errorText = _errorTexts[item];

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

      if (key == 'isNumeric' && isNumeric == true && _isNumericCheckFailed()) {
        break;
      }

      if (key == 'isNumericDecimal' &&
          isNumericDecimal == true &&
          _isNumericDecimalCheckFailed()) {
        break;
      }

      if (key == 'isEmail' && isEmail == true && _isEmailCheckFailed()) {
        break;
      }

      if (key == 'isAlphaSpace' &&
          isAlphaSpace == true &&
          _isAlphaSpaceCheckFailed()) {
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
    if (!isStringNumeric(value as String)) {
      _errorItemList.add('isNumeric');

      return true;
    }

    return false;
  }

  bool _isNumericDecimalCheckFailed() {
    if (!isStringNumeric(value as String, allowDecimal: true)) {
      _errorItemList.add('isNumericDecimal');

      return true;
    }

    return false;
  }

  bool _isEmailCheckFailed() {
    if (!isStringEmail(value as String)) {
      _errorItemList.add('isEmail');

      return true;
    }

    return false;
  }

  bool _isAlphaSpaceCheckFailed() {
    if (!isStringAlphaSpace(value as String)) {
      _errorItemList.add('isAlphaSpace');

      return true;
    }

    return false;
  }

  bool _isLengthCheckFailed() {
    if (!isStringLength(value as String, length)) {
      _errorItemList.add('length');

      return true;
    }

    return false;
  }

  bool _isMinLengthCheckFailed() {
    if (!isStringMinLength(value as String, minLength)) {
      _errorItemList.add('minLength');

      return true;
    }

    return false;
  }
}
