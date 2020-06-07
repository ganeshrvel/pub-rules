import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/main.dart';

bool isEmptyRuleValueExists(List<Rules> _rulesList) {
  for (final rule in _rulesList) {
    if (isNullOrEmpty(rule.value)) {
      return true;
    }
  }

  return false;
}
