import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/main.dart';

// check if the array has an empty rule value
bool isEmptyRuleValueExists(List<Rule?> _rulesList) {
  for (final rule in _rulesList) {
    if (isNullOrEmpty(rule!.value)) {
      return true;
    }
  }

  return false;
}

// return all non empty rule from the array
List<Rule?> getAllNonEmptyRules(List<Rule?> _rulesList) {
  return _rulesList.where((a) => isNotNullOrEmpty(a!.value)).toList();
}
