import 'package:rules/src/abstract_rule.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/helpers/group_rule_functs.dart';
import 'package:rules/src/helpers/strings.dart';
import 'package:rules/src/models/rule_model.dart';
import 'package:rules/src/rule.dart';

///
/// GroupRule Class: Group together and validate the basic rules .
/// Refer https://github.com/ganeshrvel/pub-rules/blob/master/README.md#2-grouprule for usage details
///
///
class GroupRule implements AbstractRule {
  // Rules list for validation
  final List<Rule?> rulesList;

  // placeholder name
  final String name;

  final bool? requiredAll;

  final int? requiredAtleast;

  final int? maxAllowed;

  final String? customErrorText;

  final Map<String, String>? customErrors;

  // if the validator fails then the corresponding [_errorTextsDict] key is added to this array.
  // which will be later used for parsing and outputing error text
  final List<String> _errorItemList = <String>[];

  // it holds the error texts; Note: maximum one error text, for now, is held here
  // this can change in the future
  final List<String> _errorList = <String>[];

  // default error text dictionary
  Map<String, String> get _errorTextsDict => {
        'requiredAll': 'All fields are mandatory in {name}',
        'requiredAtleast':
            'At least $requiredAtleast ${plural('field', value: requiredAtleast, verb: true)} required in {name}',
        'maxAllowed':
            'A maximum of $maxAllowed ${plural('field', value: maxAllowed, verb: true)} allowed in {name}',
      };

  // Extend [GroupRule]
  GroupRule copyWith({
    String? name,
    bool? requiredAll,
    int? requiredAtleast,
    int? maxAllowed,
    String? customErrorText,
    Map<String, String>? customErrors,
  }) {
    return GroupRule(
      rulesList,
      name: name ?? this.name,
      requiredAll: requiredAll ?? this.requiredAll,
      requiredAtleast: requiredAtleast ?? this.requiredAtleast,
      maxAllowed: maxAllowed ?? this.maxAllowed,
      customErrorText: customErrorText ?? this.customErrorText,
      customErrors: customErrors ?? this.customErrors,
    );
  }

  GroupRule(
    this.rulesList, {
    required this.name,
    this.requiredAll,
    this.requiredAtleast,
    this.maxAllowed,
    this.customErrorText,
    this.customErrors,
  }) {
    if (isNullOrEmpty(name)) {
      throw "Group Rule => \n'name' parameter is required";
    }

    if (isNotNull(requiredAtleast) && rulesList.length < requiredAtleast!) {
      throw "Group Rule => \nA minimum of 'requiredAtleast' number of ($requiredAtleast) rules are required";
    }

    _run();
  }

  RuleModel get _ruleModel => RuleModel(errorList: _errorList);

  ///
  /// outputs the error text (string)
  ///
  String? get error => _ruleModel.error;

  @override
  bool get hasError => isNotNullOrEmpty(error);

  // starting point
  void _run() {
    _preProcessRulesErrors();

    // if [rulesList] clears the validation then continue with the group rule validation
    if (hasError) {
      return;
    }

    _beginValidation();

    _processErrors();
  }

  // preprocess [rulesList] errors first
  void _preProcessRulesErrors() {
    for (final rule in rulesList) {
      final error = rule?.error;

      if (isNotNullOrEmpty(error)) {
        _errorList.add(error!);

        break;
      }
    }
  }

  // the validation happens here
  bool _beginValidation() {
    return (requiredAll == true && _isRequiredCheckFailed()) ||
        (requiredAtleast != null && _isRequiredAtleastCheckFailed()) ||
        (maxAllowed != null && _isMaxAllowedCheckFailed());
  }

  bool _isRequiredCheckFailed() {
    if (requiredAll!) {
      if (isEmptyRuleValueExists(rulesList)) {
        _errorItemList.add('requiredAll');

        return true;
      }
    }

    return false;
  }

  bool _isRequiredAtleastCheckFailed() {
    if (requiredAtleast! > 0) {
      final _nonEmptyValues = getAllNonEmptyRules(rulesList);

      if (_nonEmptyValues.length < requiredAtleast!) {
        _errorItemList.add('requiredAtleast');

        return true;
      }
    }

    return false;
  }

  bool _isMaxAllowedCheckFailed() {
    final _nonEmptyValues = getAllNonEmptyRules(rulesList);

    if (_nonEmptyValues.length > maxAllowed!) {
      _errorItemList.add('maxAllowed');

      return true;
    }

    return false;
  }

  // process errors from [_errorItemList]
  void _processErrors() {
    if (isNullOrEmpty(_errorItemList)) {
      return;
    }

    for (final item in _errorItemList) {
      if (isNotNull(customErrors) && customErrors!.containsKey(item)) {
        final _errorText = customErrors![item];

        _assignErrorValues(_errorText);

        continue;
      }

      if (isNotNullOrEmpty(customErrorText)) {
        _assignErrorValues(customErrorText);

        return;
      }

      final _errorText = _errorTextsDict[item];

      _assignErrorValues(_errorText);
    }
  }

  // update [_errorList] if any error is found
  void _assignErrorValues(String? _errorText) {
    if (isNullOrEmpty(_errorText)) {
      return;
    }

    final _replacedErrorText = _errorText!.replaceAll('{name}', name);

    _errorList.add(_replacedErrorText);
  }
}
