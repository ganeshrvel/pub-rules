import 'package:rules/src/group_rule.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/models/rule_model.dart';
import 'package:rules/src/rule.dart';

///
/// CombinedRule Class: Validate multiple basic rules and group rules together
/// Refer https://github.com/ganeshrvel/pub-rules/blob/master/README.md#1-combinedrule for usage details
///
///
class CombinedRule {
  ///
  /// Rules list for validation
  ///
  final List<Rule?>? rules;

  ///
  /// GroupRules list for validation
  ///
  final List<GroupRule?>? groupRules;

  List<String?> _errorList = <String>[];

  CombinedRule({
    this.rules,
    this.groupRules,
  }) {
    _run();
  }

  RuleModel get _ruleModel => RuleModel(errorList: _errorList);

  ///
  /// outputs the list of error texts
  ///
  List<String?> get errorList => _ruleModel.errorList;

  ///
  /// outputs true if there is a validation error else false
  ///
  bool get hasError => isNotNullOrEmpty(errorList);

  // starting point
  void _run() {
    _processRulesErrors();
    _processGroupRulesErrors();
  }

  // process [rules] errors
  void _processRulesErrors() {
    for (final rule in rules ?? []) {
      final _error = rule?.error as String?;

      if (isNotNullOrEmpty(_error)) {
        // spread the errors into [_errorList]
        _errorList = [..._errorList, _error];
      }
    }
  }

  // process [groupRules] errors
  void _processGroupRulesErrors() {
    for (final rule in groupRules ?? []) {
      final _error = rule?.error as String?;

      if (isNotNullOrEmpty(_error)) {
        // spread the errors into [_errorList]
        _errorList = [..._errorList, _error];
      }
    }
  }
}
