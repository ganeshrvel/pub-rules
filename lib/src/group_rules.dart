import 'package:meta/meta.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/models/rules_models.dart';
import 'package:rules/src/rules.dart';

class GroupRules {
  final String name;

  final List<Rules> ruleList;

  final String customErrorText;

  final Map<String, String> customErrors;

  final _errorItemList = <String>[];

  final _errorList = <String>[];

  Map<String, String> get _errorTextsDict => {
        'isRequired': '{name} is required'
      };

  GroupRules(
    this.ruleList, {
    @required this.name,
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

  void _beginValidation() {}

  void _preProcessRulesErrors() {
    if (isNotNullOrEmpty(ruleList) && isArrayIndexExists(ruleList, 0)) {
      final error = ruleList[0].error;

      _errorList.add(error);

      return;
    }
  }
}
