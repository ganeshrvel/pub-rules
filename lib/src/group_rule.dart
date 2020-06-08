import 'package:meta/meta.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/helpers/group_rule_functs.dart';
import 'package:rules/src/helpers/strings.dart';
import 'package:rules/src/models/rules_models.dart';
import 'package:rules/src/rule.dart';

class GroupRule {
  final List<Rule> ruleList;

  final String name;

  final bool requiredAll;

  final int requiredAtleast;

  final int maxAllowed;

  final String customErrorText;

  final Map<String, String> customErrors;

  final _errorItemList = <String>[];

  final _errorList = <String>[];

  Map<String, String> get _errorTextsDict => {
        'requiredAll': 'All fields are mandatory in {name}',
        'requiredAtleast':
            'At least $requiredAtleast ${plural('field', value: requiredAtleast, verb: true)} required in {name}',
        'maxAllowed':
            'A maximum of $maxAllowed ${plural('field', value: maxAllowed, verb: true)} allowed in {name}',
      };

  GroupRule(
    this.ruleList, {
    @required this.name,
    this.requiredAll,
    this.requiredAtleast,
    this.maxAllowed,
    this.customErrorText,
    this.customErrors,
  }) {
    if (isNullOrEmpty(name)) {
      throw "Group Rule => \n'name' parameter is required";
    }

    if (isNotNull(requiredAtleast) && ruleList.length < requiredAtleast) {
      throw "Group Rule => \nA minimum of 'requiredAtleast' number of ($requiredAtleast) rules are required";
    }

    _run();
  }

  RulesModel get _rulesModel => RulesModel(errorList: _errorList);

  String get error => _rulesModel.error;

  bool get hasError => isNotNullOrEmpty(error);

  void _run() {
    _preProcessRulesErrors();

    if (hasError) {
      return;
    }

    _beginValidation();

    _processErrors();
  }

  void _preProcessRulesErrors() {
    for (final rule in ruleList) {
      final error = rule?.error;

      if (isNotNullOrEmpty(error)) {
        _errorList.add(error);

        break;
      }
    }
  }

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

  void _assignErrorValues(String _errorText) {
    if (isNullOrEmpty(_errorText)) {
      return;
    }

    final _replacedErrorText = _errorText.replaceAll('{name}', name);

    _errorList.add(_replacedErrorText);
  }

  void _beginValidation() {
    if (requiredAll == true && _isRequiredCheckFailed()) {
      return;
    }

    if (requiredAtleast != null && _isRequiredAtleastCheckFailed()) {
      return;
    }

    if (maxAllowed != null && _isMaxAllowedCheckFailed()) {
      return;
    }
  }

  bool _isRequiredCheckFailed() {
    if (requiredAll) {
      if (isEmptyRuleValueExists(ruleList)) {
        _errorItemList.add('requiredAll');

        return true;
      }
    }

    return false;
  }

  bool _isRequiredAtleastCheckFailed() {
    if (requiredAtleast > 0) {
      final _nonEmptyValues = getAllNonEmptyRules(ruleList);

      if (_nonEmptyValues.length < requiredAtleast) {
        _errorItemList.add('requiredAtleast');

        return true;
      }
    }

    return false;
  }

  bool _isMaxAllowedCheckFailed() {
    final _nonEmptyValues = getAllNonEmptyRules(ruleList);

    if (_nonEmptyValues.length > maxAllowed) {
      _errorItemList.add('maxAllowed');

      return true;
    }

    return false;
  }
}
