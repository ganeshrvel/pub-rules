import 'package:meta/meta.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/models/rules_models.dart';

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
    'isRequired': '{name} is required',
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

    _run();
  }

  RulesModel get _rulesModel => RulesModel(errorList: _errorList);

  String get error => _rulesModel.error;

  void _run() {
    switch (T) {
      case String:
        _checkString();

        break;

      default:
        break;
    }
  }

  void _checkString() {
    var _allowedRulesList = <String, dynamic>{};

    _allowedRulesList = {
      'isRequired': isRequired,
    };

    final _checkAllowedRulesList = getNullValues(_allowedRulesList);

    if (isNotNullOrEmpty(_checkAllowedRulesList)) {
      throw "These rules aren't supported for '$T' value input => '${_checkAllowedRulesList.join()}'";
    }

    _beginValidation(_allowedRulesList);
  }

  void _beginValidation(Map<String, dynamic> _allowedRulesList) {
    for (final key in _allowedRulesList.keys) {
      if (key == 'isRequired') {
        _checkRequired();
        break;
      }
    }

    _processErrors();
  }

  void _checkRequired() {
    if (isRequired && isNullOrEmpty(value)) {
      _errorItemList.add('isRequired');
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
