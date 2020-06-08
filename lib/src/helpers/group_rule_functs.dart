import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/main.dart';

bool isEmptyRuleValueExists(List<Rule> _rulesList) {
  for (final rule in _rulesList) {
    if (isNullOrEmpty(rule.value)) {
      return true;
    }
  }

  return false;
}

List<Rule> getAllNonEmptyRules(List<Rule> _rulesList) {
  return _rulesList.where((a) => isNotNullOrEmpty(a.value)).toList();
}
