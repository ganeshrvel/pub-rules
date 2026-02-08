import 'package:rules/src/abstract_rule.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/functs.dart';
import 'package:rules/src/helpers/math.dart';
import 'package:rules/src/helpers/strings.dart';
import 'package:rules/src/models/rule_model.dart';
import 'package:rules/src/models/rule_options.dart';

typedef Validator = bool Function(String value);

///
/// Rule Class: This is the basic building block, everything starts here.
/// Refer https://github.com/ganeshrvel/pub-rules/blob/master/README.md#1-rule-basic-rule for usage details
///
///
class Rule implements AbstractRule {
  // value for validation
  String? value;

  // placeholder name
  final String name;

  final bool isRequired;

  final bool isEmail;

  final bool isUrl;

  final bool isPhone;

  final bool isIp;

  final bool isNumeric;

  bool isNumericDecimal;

  final bool isAlphaSpace;

  final bool isAlphaNumeric;

  final bool isAlphaNumericSpace;

  final RegExp? regex;

  final int? length;

  final int? minLength;

  final int? maxLength;

  final double? greaterThan;

  final double? greaterThanEqualTo;

  final double? lessThan;

  final double? lessThanEqualTo;

  final double? equalTo;

  final double? notEqualTo;

  final List<double>? equalToInList;

  final List<double>? notEqualToInList;

  final String? shouldMatch;

  final String? shouldNotMatch;

  final Validator? shouldPass;

  final List<String>? inList;

  final List<String>? notInList;

  final String? customErrorText;

  final Map<String, String>? customErrors;

  // Rule options
  RuleOptions? options;

  // if the validator fails then the corresponding [_errorTextsDict] key is added to this array.
  // which will be later used for parsing and outputing error text
  final List<String> _errorItemList = <String>[];

  // it holds the error texts; Note: maximum one error text, for now, is held here
  // this can change in the future
  final List<String> _errorList = <String>[];

  // default error text dictionary
  Map<String, String> get _errorTextsDict => {
        'isRequired': '{name} is required',
        'isEmail': '{name} is not a valid email address',
        'isPhone': '{name} is not a valid phone number',
        'isUrl': '{name} is not a valid URL',
        'isIp': '{name} is not a valid IP address',
        'isNumeric': '{name} is not a valid number',
        'isNumericDecimal': '{name} is not a valid decimal number',
        'isAlphaSpace': 'Only alphabets and spaces are allowed in {name}',
        'isAlphaNumeric': 'Only alphabets and numbers are allowed in {name}',
        'isAlphaNumericSpace':
            'Only alphabets, numbers and spaces are allowed in {name}',
        'regex':
            '{name} should match the pattern: ${regex != null ? regex!.pattern : ''}',
        'length': '{name} should be $length characters long',
        'minLength': '{name} should contain at least $minLength characters',
        'maxLength': '{name} should not exceed more than $maxLength characters',
        'greaterThan': '{name} should be greater than $greaterThan',
        'greaterThanEqualTo':
            '{name} should be greater than or equal to $greaterThanEqualTo',
        'lessThan': '{name} should be less than $lessThan',
        'lessThanEqualTo':
            '{name} should be less than or equal to $lessThanEqualTo',
        'equalTo': '{name} should be equal to $equalTo',
        'notEqualTo': '{name} should not be equal to $notEqualTo',
        'equalToInList':
            '{name} should be equal to any of these values ${(equalToInList ?? []).join(', ')}',
        'notEqualToInList':
            '{name} should not be equal to any of these values ${(notEqualToInList ?? []).join(', ')}',
        'shouldMatch': '{name} should be same as $shouldMatch',
        'shouldNotMatch': '{name} should not be same as $shouldNotMatch',
        'shouldPass': '{name} is invalid',
        'inList':
            '{name} should be any of these values ${(inList ?? []).join(', ')}',
        'notInList':
            '{name} should not be any of these values ${(notInList ?? []).join(
          ', ',
        )}',
      };

  // Extend [Rule]
  Rule copyWith({
    String? name,
    bool? isRequired,
    bool? isEmail,
    bool? isUrl,
    bool? isPhone,
    bool? isIp,
    bool? isNumeric,
    bool? isNumericDecimal,
    bool? isAlphaSpace,
    bool? isAlphaNumeric,
    bool? isAlphaNumericSpace,
    RegExp? regex,
    int? length,
    int? minLength,
    int? maxLength,
    double? greaterThan,
    double? greaterThanEqualTo,
    double? lessThan,
    double? lessThanEqualTo,
    double? equalTo,
    double? notEqualTo,
    List<double>? equalToInList,
    List<double>? notEqualToInList,
    String? shouldMatch,
    String? shouldNotMatch,
    Validator? shouldPass,
    List<String>? inList,
    List<String>? notInList,
    String? customErrorText,
    Map<String, String>? customErrors,
    RuleOptions? options,
  }) {
    return Rule(
      value,
      name: name ?? this.name,
      isRequired: isRequired ?? this.isRequired,
      isEmail: isEmail ?? this.isEmail,
      isUrl: isUrl ?? this.isUrl,
      isPhone: isPhone ?? this.isPhone,
      isIp: isIp ?? this.isIp,
      isNumeric: isNumeric ?? this.isNumeric,
      isNumericDecimal: isNumericDecimal ?? this.isNumericDecimal,
      isAlphaSpace: isAlphaSpace ?? this.isAlphaSpace,
      isAlphaNumeric: isAlphaNumeric ?? this.isAlphaNumeric,
      isAlphaNumericSpace: isAlphaNumericSpace ?? this.isAlphaNumericSpace,
      regex: regex ?? this.regex,
      length: length ?? this.length,
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
      greaterThan: greaterThan ?? this.greaterThan,
      greaterThanEqualTo: greaterThanEqualTo ?? this.greaterThanEqualTo,
      lessThan: lessThan ?? this.lessThan,
      lessThanEqualTo: lessThanEqualTo ?? this.lessThanEqualTo,
      equalTo: equalTo ?? this.equalTo,
      notEqualTo: notEqualTo ?? this.notEqualTo,
      equalToInList: equalToInList ?? this.equalToInList,
      notEqualToInList: notEqualToInList ?? this.notEqualToInList,
      shouldMatch: shouldMatch ?? this.shouldMatch,
      shouldNotMatch: shouldNotMatch ?? this.shouldNotMatch,
      shouldPass: shouldPass ?? this.shouldPass,
      inList: inList ?? this.inList,
      notInList: notInList ?? this.notInList,
      customErrorText: customErrorText ?? this.customErrorText,
      customErrors: customErrors ?? this.customErrors,
      options: options ?? this.options,
    );
  }

  Rule(
    this.value, {
    required this.name,
    this.customErrors,
    this.customErrorText,
    this.isEmail = false,
    this.isPhone = false,
    this.isIp = false,
    this.isUrl = false,
    this.isRequired = false,
    this.isNumeric = false,
    this.isNumericDecimal = false,
    this.isAlphaSpace = false,
    this.isAlphaNumeric = false,
    this.isAlphaNumericSpace = false,
    this.regex,
    this.length,
    this.minLength,
    this.maxLength,
    this.greaterThan,
    this.greaterThanEqualTo,
    this.lessThan,
    this.lessThanEqualTo,
    this.equalTo,
    this.notEqualTo,
    this.equalToInList,
    this.notEqualToInList,
    this.inList,
    this.notInList,
    this.shouldMatch,
    this.shouldNotMatch,
    this.shouldPass,
    this.options,
  }) {
    // throw an error is 'name' parameter is missing
    if (isNullOrEmpty(name)) {
      throw "Rule => \n'name' parameter is required";
    }

    _applyOptions();
    _run();
  }

  RuleModel get _ruleModel => RuleModel(errorList: _errorList);

  ///
  /// outputs the error text (string)
  ///
  String? get error => _ruleModel.error;

  @override
  bool get hasError => isNotNullOrEmpty(error);

  void _applyOptions() {
    options ??= RuleOptions();

    // trim [value] if [options.trim] is true
    if (options!.trim == true) {
      if (isNotNullOrEmpty(value)) {
        value = value!.trim();
      }
    }

    // Converts all characters in [value] to lower case if [options.lowerCase] is true
    if (options!.lowerCase == true) {
      if (isNotNullOrEmpty(value)) {
        value = value!.toLowerCase();
      }
    }

    // Converts all characters in [value] to upper case if [options.upperCase] is true
    if (options!.upperCase == true) {
      if (isNotNullOrEmpty(value)) {
        value = value!.toUpperCase();
      }
    }
  }

  // entry point
  void _run() {
    // if any of these values are found to be not null then either [isNumeric] or [isNumericDecimal] is applied automatically.
    // if [isNumeric] is false then [isNumericDecimal] will be applied
    if (isNotNullExists(
          [
            greaterThan,
            greaterThanEqualTo,
            lessThan,
            lessThanEqualTo,
            equalTo,
            notEqualTo,
            equalToInList,
            notEqualToInList,
          ],
        ) &&
        isNumeric != true) {
      isNumericDecimal = true;
    }

    _beginValidation();

    _processErrors();
  }

  // the validation happens here
  bool _beginValidation() {
    return (isRequired && _isRequiredCheckFailed()) ||
        (isEmail && _isEmailCheckFailed()) ||
        (isUrl && _isUrlCheckFailed()) ||
        (isPhone && _isPhoneCheckFailed()) ||
        (isIp && _isIpCheckFailed()) ||
        (isNumeric && _isNumericCheckFailed()) ||
        (isNumericDecimal && _isNumericDecimalCheckFailed()) ||
        (isAlphaSpace && _isAlphaSpaceCheckFailed()) ||
        (isAlphaNumeric && _isAlphaNumericCheckFailed()) ||
        (isAlphaNumericSpace && _isAlphaNumericSpaceCheckFailed()) ||
        (regex != null && _isRegexCheckFailed()) ||
        (length != null && _isLengthCheckFailed()) ||
        (minLength != null && _isMinLengthCheckFailed()) ||
        (maxLength != null && _isMaxLengthCheckFailed()) ||
        (greaterThan != null && _isGreaterThanCheckFailed()) ||
        (greaterThanEqualTo != null && _isGreaterThanEqualToCheckFailed()) ||
        (lessThan != null && _isLessThanCheckFailed()) ||
        (lessThanEqualTo != null && _isLessThanEqualToCheckFailed()) ||
        (equalTo != null && _isEqualToCheckFailed()) ||
        (notEqualTo != null && _isNotEqualToCheckFailed()) ||
        (equalToInList != null && _isEqualToInListCheckFailed()) ||
        (notEqualToInList != null && _isNotEqualToInListCheckFailed()) ||
        (inList != null && _isInListCheckFailed()) ||
        (notInList != null && _isNotInListCheckFailed()) ||
        (shouldMatch != null && _isShouldMatchCheckFailed()) ||
        (shouldNotMatch != null && _isShouldNotMatchCheckFailed()) ||
        (shouldPass != null && _isShouldPassCheckFailed());
  }

  bool _isRequiredCheckFailed() {
    if (isRequired && isNullOrEmpty(value)) {
      _errorItemList.add('isRequired');

      return true;
    }

    return false;
  }

  bool _isNumericCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringNumeric(value!)) {
      _errorItemList.add('isNumeric');

      return true;
    }

    return false;
  }

  bool _isNumericDecimalCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isStringNumeric(value!, allowDecimal: true)) {
      _errorItemList.add('isNumericDecimal');

      return true;
    }

    return false;
  }

  bool _isEmailCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringEmail(value!)) {
      _errorItemList.add('isEmail');

      return true;
    }

    return false;
  }

  bool _isPhoneCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringPhone(value!)) {
      _errorItemList.add('isPhone');

      return true;
    }

    return false;
  }

  bool _isUrlCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringUrl(value!)) {
      _errorItemList.add('isUrl');

      return true;
    }

    return false;
  }

  bool _isIpCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringIp(value!)) {
      _errorItemList.add('isIp');

      return true;
    }

    return false;
  }

  bool _isAlphaSpaceCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringAlphaSpace(value!)) {
      _errorItemList.add('isAlphaSpace');

      return true;
    }

    return false;
  }

  bool _isAlphaNumericCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringAlphaNumeric(value!)) {
      _errorItemList.add('isAlphaNumeric');

      return true;
    }

    return false;
  }

  bool _isAlphaNumericSpaceCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringAlphaNumericSpace(value!)) {
      _errorItemList.add('isAlphaNumericSpace');

      return true;
    }

    return false;
  }

  bool _isRegexCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringRegexMatch(value!, regex!)) {
      _errorItemList.add('regex');

      return true;
    }

    return false;
  }

  bool _isLengthCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringLength(value!, length)) {
      _errorItemList.add('length');

      return true;
    }

    return false;
  }

  bool _isMinLengthCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringMinLength(value!, minLength!)) {
      _errorItemList.add('minLength');

      return true;
    }

    return false;
  }

  bool _isMaxLengthCheckFailed() {
    if (isNotNullOrEmpty(value) && !isStringMaxLength(value!, maxLength!)) {
      _errorItemList.add('maxLength');

      return true;
    }

    return false;
  }

  bool _isGreaterThanCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueGreaterThan(double.tryParse(value!)!, greaterThan!)) {
      _errorItemList.add('greaterThan');

      return true;
    }

    return false;
  }

  bool _isGreaterThanEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueGreaterThanEqualTo(
          double.tryParse(value!)!,
          greaterThanEqualTo!,
        )) {
      _errorItemList.add('greaterThanEqualTo');

      return true;
    }

    return false;
  }

  bool _isLessThanCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueLessThan(double.tryParse(value!)!, lessThan!)) {
      _errorItemList.add('lessThan');

      return true;
    }

    return false;
  }

  bool _isLessThanEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        !isValueLessThanEqualTo(double.tryParse(value!)!, lessThanEqualTo!)) {
      _errorItemList.add('lessThanEqualTo');

      return true;
    }

    return false;
  }

  bool _isEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) && double.tryParse(value!) != equalTo) {
      _errorItemList.add('equalTo');

      return true;
    }

    return false;
  }

  bool _isNotEqualToCheckFailed() {
    if (isNotNullOrEmpty(value) && double.tryParse(value!) == notEqualTo) {
      _errorItemList.add('notEqualTo');

      return true;
    }

    return false;
  }

  bool _isEqualToInListCheckFailed() {
    if (isNotNullOrEmpty(value)) {
      final _value = double.tryParse(value!);

      if (!inArray(equalToInList!, _value)) {
        _errorItemList.add('equalToInList');

        return true;
      }
    }

    return false;
  }

  bool _isNotEqualToInListCheckFailed() {
    if (isNotNullOrEmpty(value)) {
      final _value = double.tryParse(value!);

      if (inArray(notEqualToInList!, _value)) {
        _errorItemList.add('notEqualToInList');

        return true;
      }
    }

    return false;
  }

  bool _isInListCheckFailed() {
    if (isNotNullOrEmpty(value) && !inArray(inList!, value)) {
      _errorItemList.add('inList');

      return true;
    }

    return false;
  }

  bool _isNotInListCheckFailed() {
    if (isNotNullOrEmpty(value) && inArray(notInList!, value)) {
      _errorItemList.add('notInList');

      return true;
    }

    return false;
  }

  bool _isShouldMatchCheckFailed() {
    if (isNotNullOrEmpty(value) && shouldMatch != value) {
      _errorItemList.add('shouldMatch');

      return true;
    }

    return false;
  }

  bool _isShouldNotMatchCheckFailed() {
    if (isNotNullOrEmpty(value) && shouldNotMatch == value) {
      _errorItemList.add('shouldNotMatch');

      return true;
    }

    return false;
  }

  bool _isShouldPassCheckFailed() {
    if (isNotNullOrEmpty(value) &&
        shouldPass != null &&
        shouldPass!(value!) == false) {
      _errorItemList.add('shouldPass');
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

    var _replacedErrorText = _errorText!.replaceAll('{name}', name);

    _replacedErrorText =
        _replacedErrorText.replaceAll('{value}', value ?? 'null');

    _errorList.add(_replacedErrorText);
  }
}
