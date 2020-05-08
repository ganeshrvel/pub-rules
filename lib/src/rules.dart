import 'package:meta/meta.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/functs.dart';

class Rules<T> {
  final T value;

  final String name;

  final bool isRequired;

  final bool isNumeric;

  final _errorItemList = <dynamic>[];

  final _errorList = <String>[];

  final Map<String, String> customErrorTexts;

  final _allowedValueDataTypes = [
    String,
  ];

  final Map<String, String> _errorTexts = {
    'required': '{name} is required',
  };

  Rules(
    this.value, {
    @required this.name,
    this.isRequired,
    this.isNumeric,
    this.customErrorTexts,
  }) {
    if (!isTypesEqual(T, _allowedValueDataTypes)) {
      throw "'$T' data type isn't supported yet.";
    }

    if (isNullOrEmpty(name)) {
      throw "'name' parameter is required";
    }
  }

  _RulesModel run() {
    switch (T) {
      case String:
        return _checkString();

      default:
        return null;
    }
  }

  _RulesModel _checkString() {
    var _allowedRulesList = <String, dynamic>{};

    _allowedRulesList = {
      'required': required,
    };

    final _checkAllowedRulesList = getNullValues(_allowedRulesList);

    if (isNotNullOrEmpty(_checkAllowedRulesList)) {
      throw "These rules aren't supported for '$T' value input => '${_checkAllowedRulesList.join()}'";
    }

    _beginValidation(_allowedRulesList);

    return _RulesModel(
      errorList: _errorList,
    );
  }

  void _beginValidation(Map<String, dynamic> _allowedRulesList) {
    for (final key in _allowedRulesList.keys) {
      switch (key) {
        case 'required':
          _checkRequired();
          break;

        default:
          break;
      }
    }

    _processErrors();
  }

  void _checkRequired() {
    if (isNullOrEmpty(value)) {
      _errorItemList.add('required');
    }
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
}

class _RulesModel {
  String error;
  final List<String> errorList;

  _RulesModel({
    @required this.errorList,
  }) {
    if (isNullOrEmpty(errorList) || !isArrayIndexExists(0, errorList)) {
      error = null;

      return;
    }

    error = errorList[0];
  }
}
