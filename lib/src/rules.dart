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

  final bool isEmail;

  final bool isAlphaSpace;

  final _errorItemList = <dynamic>[];

  final _errorList = <String>[];

  final Map<String, String> customErrorTexts;

  final _allowedValueDataTypes = [
    String,
  ];

  final Map<String, String> _errorTexts = {
    'isRequired': '{name} is required',
    'isNumeric': '{name} is not numeric',
    'isEmail': '{name} is not a valid email address',
    'isAlphaSpace': 'Only alphabets and spaces are allowed in {name}',
  };

  Rules(
    this.value, {
    @required this.name,
    this.isRequired = false,
    this.isNumeric = false,
    this.isEmail = false,
    this.isAlphaSpace = false,
    this.customErrorTexts,
  }) {
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
      'isEmail': isEmail,
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
      if (key == 'isRequired' && isRequired == true && _checkRequired()) {
        break;
      }

      if (key == 'isNumeric' && isNumeric == true && _checkNumeric()) {
        break;
      }

      if (key == 'isEmail' && isEmail == true && _checkEmail()) {
        break;
      }

      if (key == 'isAlphaSpace' && isAlphaSpace == true && _checkAlphaSpace()) {
        break;
      }
    }

    _processErrors();
  }

  bool _checkRequired() {
    if (isRequired && isNullOrEmpty(value)) {
      _errorItemList.add('isRequired');

      return true;
    }

    return false;
  }

  bool _checkNumeric() {
    if (!isStringNumeric(value as String)) {
      _errorItemList.add('isNumeric');

      return true;
    }

    return false;
  }

  bool _checkEmail() {
    if (!isStringEmail(value as String)) {
      _errorItemList.add('isEmail');

      return true;
    }

    return false;
  }

  bool _checkAlphaSpace() {
    if (!isStringAlphaSpace(value as String)) {
      _errorItemList.add('isAlphaSpace');

      return true;
    }

    return false;
  }
}
