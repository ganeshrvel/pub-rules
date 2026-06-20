import 'package:rules/src/core/check.dart';
import 'package:rules/src/core/rule_check.dart';
import 'package:rules/src/core/schema.dart';
import 'package:rules/src/validators/string_validators.dart';

/// The numeric form of the value being validated, or null if it didn't
/// parse as a number.
double? _parseNumericValue(String value) {
  if (!StringValidators.isNumeric(value, allowDecimal: true)) {
    return null;
  }

  return double.parse(value);
}

const String _notANumberTemplate = '{name} is not a valid number';

/// A schema for validating string values.
final class StringSchema extends Schema<String> {
  /// Creates an empty string schema for a field named [name].
  StringSchema.empty({required super.name})
      : _trim = false,
        _lowerCase = false,
        _upperCase = false,
        super(
          checks: const <Check<String>>[],
          required: false,
          requiredError: null,
        );

  const StringSchema._({
    required super.name,
    required super.checks,
    required super.required,
    required super.requiredError,
    required bool trim,
    required bool lowerCase,
    required bool upperCase,
  })  : _trim = trim,
        _lowerCase = lowerCase,
        _upperCase = upperCase;

  final bool _trim;

  final bool _lowerCase;

  final bool _upperCase;

  @override
  RuleCheck get requiredCheckKind => StringCheck.isRequired;

  @override
  String get requiredTemplate => '{name} is required';

  @override
  bool isAbsent(String? value) => value == null || value.isEmpty;

  @override
  String? prepare(String? value) {
    if (value == null) {
      return null;
    }

    var result = value;

    if (_trim) {
      result = result.trim();
    }

    if (_lowerCase) {
      result = result.toLowerCase();
    }

    if (_upperCase) {
      result = result.toUpperCase();
    }

    return result;
  }

  StringSchema _add(Check<String> check) {
    return StringSchema._(
      name: name,
      checks: [...checks, check],
      required: required,
      requiredError: requiredError,
      trim: _trim,
      lowerCase: _lowerCase,
      upperCase: _upperCase,
    );
  }

  StringSchema _copy({
    bool? required,
    String? requiredError,
    bool? trim,
    bool? lowerCase,
    bool? upperCase,
  }) {
    return StringSchema._(
      name: name,
      checks: checks,
      required: required ?? this.required,
      requiredError: requiredError ?? this.requiredError,
      trim: trim ?? _trim,
      lowerCase: lowerCase ?? _lowerCase,
      upperCase: upperCase ?? _upperCase,
    );
  }

  /// Marks the value as mandatory.
  StringSchema isRequired({String? error}) {
    return _copy(required: true, requiredError: error);
  }

  /// Strips leading and trailing whitespace before any constraint runs.
  StringSchema trim() => _copy(trim: true);

  /// Lower-cases the value before any constraint runs.
  StringSchema toLowerCase() => _copy(lowerCase: true, upperCase: false);

  /// Upper-cases the value before any constraint runs.
  StringSchema toUpperCase() => _copy(upperCase: true, lowerCase: false);

  /// Requires a syntactically valid email address.
  StringSchema isEmail({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isEmail,
        evaluate: (value) => StringValidators.isEmail(value)
            ? null
            : '{name} is not a valid email address',
        customError: error,
      ),
    );
  }

  /// Requires a syntactically valid URL.
  StringSchema isUrl({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isUrl,
        evaluate: (value) =>
            StringValidators.isUrl(value) ? null : '{name} is not a valid URL',
        customError: error,
      ),
    );
  }

  /// Requires a valid phone number.
  StringSchema isPhone({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isPhone,
        evaluate: (value) => StringValidators.isPhone(value)
            ? null
            : '{name} is not a valid phone number',
        customError: error,
      ),
    );
  }

  /// Requires a valid IPv4 or IPv6 address.
  StringSchema isIp({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isIp,
        evaluate: (value) => StringValidators.isIp(value)
            ? null
            : '{name} is not a valid IP address',
        customError: error,
      ),
    );
  }

  /// Requires the value to be a whole number.
  StringSchema isNumeric({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isNumeric,
        evaluate: (value) => StringValidators.isNumeric(value)
            ? null
            : '{name} is not a valid number',
        customError: error,
      ),
    );
  }

  /// Requires the value to be a number, with decimals permitted.
  StringSchema isNumericDecimal({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isNumericDecimal,
        evaluate: (value) =>
            StringValidators.isNumeric(value, allowDecimal: true)
                ? null
                : '{name} is not a valid decimal number',
        customError: error,
      ),
    );
  }

  /// Restricts the value to alphabetic characters and spaces.
  StringSchema isAlphaSpace({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isAlphaSpace,
        evaluate: (value) => StringValidators.isAlphaSpace(value)
            ? null
            : 'Only alphabets and spaces are allowed in {name}',
        customError: error,
      ),
    );
  }

  /// Restricts the value to alphabetic characters and digits.
  StringSchema isAlphaNumeric({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isAlphaNumeric,
        evaluate: (value) => StringValidators.isAlphaNumeric(value)
            ? null
            : 'Only alphabets and numbers are allowed in {name}',
        customError: error,
      ),
    );
  }

  /// Restricts the value to alphabetic characters, digits and spaces.
  StringSchema isAlphaNumericSpace({String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.isAlphaNumericSpace,
        evaluate: (value) => StringValidators.isAlphaNumericSpace(value)
            ? null
            : 'Only alphabets, numbers and spaces are allowed in {name}',
        customError: error,
      ),
    );
  }

  /// Requires the value to match regex [pattern].
  StringSchema regex(RegExp pattern, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.regex,
        evaluate: (value) => StringValidators.regex(value, pattern)
            ? null
            : '{name} should match the pattern: ${pattern.pattern}',
        customError: error,
      ),
    );
  }

  /// Requires an exact character count of [equals].
  StringSchema length(int equals, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.length,
        evaluate: (value) => value.length == equals
            ? null
            : '{name} should be $equals characters long',
        customError: error,
      ),
    );
  }

  /// Requires at least [characters] characters.
  StringSchema minLength(int characters, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.minLength,
        evaluate: (value) => value.length >= characters
            ? null
            : '{name} should contain at least $characters characters',
        customError: error,
      ),
    );
  }

  /// Requires at most [characters] characters.
  StringSchema maxLength(int characters, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.maxLength,
        evaluate: (value) => value.length <= characters
            ? null
            : '{name} should not exceed more than $characters characters',
        customError: error,
      ),
    );
  }

  /// Requires the value, parsed as a number, to be greater than [than].
  StringSchema greaterThan(num than, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.greaterThan,
        evaluate: (value) {
          final parsedValue = _parseNumericValue(value);

          if (parsedValue == null) {
            return _notANumberTemplate;
          }

          return parsedValue > than
              ? null
              : '{name} should be greater than $than';
        },
        customError: error,
      ),
    );
  }

  /// Requires the value, parsed as a number, to be greater than or equal to
  /// [than].
  StringSchema greaterThanOrEqualTo(num than, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.greaterThanOrEqualTo,
        evaluate: (value) {
          final parsedValue = _parseNumericValue(value);

          if (parsedValue == null) {
            return _notANumberTemplate;
          }

          return parsedValue >= than
              ? null
              : '{name} should be greater than or equal to $than';
        },
        customError: error,
      ),
    );
  }

  /// Requires the value, parsed as a number, to be less than [than].
  StringSchema lessThan(num than, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.lessThan,
        evaluate: (value) {
          final parsedValue = _parseNumericValue(value);

          if (parsedValue == null) {
            return _notANumberTemplate;
          }

          return parsedValue < than ? null : '{name} should be less than $than';
        },
        customError: error,
      ),
    );
  }

  /// Requires the value, parsed as a number, to be less than or equal to
  /// [than].
  StringSchema lessThanOrEqualTo(num than, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.lessThanOrEqualTo,
        evaluate: (value) {
          final parsedValue = _parseNumericValue(value);

          if (parsedValue == null) {
            return _notANumberTemplate;
          }

          return parsedValue <= than
              ? null
              : '{name} should be less than or equal to $than';
        },
        customError: error,
      ),
    );
  }

  /// Requires the value to equal [to].
  StringSchema equalTo(String to, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.equalTo,
        evaluate: (value) =>
            value == to ? null : '{name} should be equal to $to',
        customError: error,
      ),
    );
  }

  /// Requires the value to differ from [to].
  StringSchema notEqualTo(String to, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.notEqualTo,
        evaluate: (value) =>
            value != to ? null : '{name} should not be equal to $to',
        customError: error,
      ),
    );
  }

  /// Requires the value to be one of [values].
  StringSchema inList(List<String> values, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.inList,
        evaluate: (value) => values.contains(value)
            ? null
            : '{name} should be any of these values ${values.join(', ')}',
        customError: error,
      ),
    );
  }

  /// Requires the value to be none of [values].
  StringSchema notInList(List<String> values, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.notInList,
        evaluate: (value) => !values.contains(value)
            ? null
            : '{name} should not be any of these values ${values.join(', ')}',
        customError: error,
      ),
    );
  }

  /// Requires the value to equal [other].
  StringSchema shouldMatch(String other, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.shouldMatch,
        evaluate: (value) =>
            value == other ? null : '{name} should be same as $other',
        customError: error,
      ),
    );
  }

  /// Requires the value to differ from [other].
  StringSchema shouldNotMatch(String other, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.shouldNotMatch,
        evaluate: (value) =>
            value != other ? null : '{name} should not be same as $other',
        customError: error,
      ),
    );
  }

  /// Requires the value to satisfy a custom [test].
  StringSchema check(bool Function(String value) test, {String? error}) {
    return _add(
      Check<String>(
        kind: StringCheck.check,
        evaluate: (value) => test(value) ? null : '{name} is invalid',
        customError: error,
      ),
    );
  }

  /// Validates with a [validator] that returns its own error message, or null
  /// when the value is valid. The returned string may use `{name}` and
  /// `{value}`.
  StringSchema refine(String? Function(String value) validator) {
    return _add(
      Check<String>(
        kind: StringCheck.refine,
        evaluate: validator,
      ),
    );
  }
}
