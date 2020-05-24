import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/models/rules_models.dart';
import 'package:rules/src/rules.dart';

class MultiRules {
  final List<Rules> _ruleList;
  List<String> _errorList = <String>[];

  MultiRules(this._ruleList) {
    _run();
  }

  RulesModel get _rulesModel => RulesModel(errorList: _errorList);

  List<String> get errorList => _rulesModel.errorList;

  void _run() {
    for (final rule in _ruleList ?? []) {
      final _ruleError = rule.error as String;

      if (isNotNullOrEmpty(_ruleError)) {
        _errorList = [..._errorList, _ruleError];
      }
    }
  }
}
