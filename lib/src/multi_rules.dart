import 'package:rules/src/group_rules.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/models/rules_models.dart';
import 'package:rules/src/rules.dart';

class MultiRules {
  final List<Rules> rules;

  final List<GroupRules> groupRules;

  List<String> _errorList = <String>[];

  MultiRules({
    this.rules,
    this.groupRules,
  }) {
    _run();
  }

  RulesModel get _rulesModel => RulesModel(errorList: _errorList);

  List<String> get errorList => _rulesModel.errorList;

  bool get hasError => isNotNullOrEmpty(errorList);

  void _run() {
    _processRulesErrors();
    _processGroupRulesErrors();
  }

  void _processRulesErrors() {
    for (final rule in rules ?? []) {
      final _ruleError = rule.error as String;

      if (isNotNullOrEmpty(_ruleError)) {
        _errorList = [..._errorList, _ruleError];
      }
    }
  }

  void _processGroupRulesErrors() {
    for (final rule in groupRules ?? []) {
      final _ruleError = rule.error as String;

      if (isNotNullOrEmpty(_ruleError)) {
        _errorList = [..._errorList, _ruleError];
      }
    }
  }
}
