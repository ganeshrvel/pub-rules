import 'package:meta/meta.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/helpers/group_rules_functs.dart';
import 'package:rules/src/models/rules_models.dart';
import 'package:rules/src/rules.dart';

class GroupRules {
  final List<Rules> ruleList;

  final String name;

  final bool isRequiredAll;

  final String customErrorText;

  final Map<String, String> customErrors;

  final _errorItemList = <String>[];

  final _errorList = <String>[];

  Map<String, String> get _errorTextsDict => {
        'isRequiredAll': 'All values are mandatory in {name}',
//        'isRequiredAll': 'All values are mandatory in {name}',
      };

  GroupRules(
    this.ruleList, {
    @required this.name,
    this.isRequiredAll,
    this.customErrorText,
    this.customErrors,
  }) {
    if (isNullOrEmpty(name)) {
      throw "Group Rules => \n'name' parameter is required";
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
      final error = rule.error;

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
    if (isRequiredAll == true && _isRequiredCheckFailed()) {
      return;
    }
  }

  bool _isRequiredCheckFailed() {
    if (isRequiredAll) {
      if (isEmptyRuleValueExists(ruleList)) {
        _errorItemList.add('isRequiredAll');

        return true;
      }
    }

    return false;
  }
}
