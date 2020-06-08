import 'package:rules/src/group_rule.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/models/rules_models.dart';
import 'package:rules/src/rule.dart';

class CombinedRule {
  final List<Rule> rules;

  final List<GroupRule> groupRules;

  List<String> _errorList = <String>[];

  CombinedRule({
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
