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

  String get error => _rulesModel.error;

  void _run() {
    for (final rule in _ruleList ?? []) {
      final _ruleErrorList = rule.errorList;

      if (isNotNullOrEmpty(_ruleErrorList)) {
        _errorList = [..._errorList, ..._ruleErrorList];
      }
    }
  }
}
