import 'package:rules/src/core/check.dart';
import 'package:rules/src/core/rule_check.dart';
import 'package:rules/src/core/schema.dart';

/// A schema for validating double values.
final class DoubleSchema extends Schema<double> {
  const DoubleSchema._({
    required super.name,
    required super.checks,
    required super.required,
    required super.requiredError,
  });

  /// Creates an empty double schema for a field named [name].
  DoubleSchema.empty({required super.name})
      : super(
          checks: const <Check<double>>[],
          required: false,
          requiredError: null,
        );

  @override
  RuleCheck get requiredCheckKind => DoubleCheck.isRequired;

  @override
  String get requiredTemplate => '{name} is required';

  @override
  bool isAbsent(double? value) => value == null;

  DoubleSchema _add(Check<double> check) {
    return DoubleSchema._(
      name: name,
      checks: [...checks, check],
      required: required,
      requiredError: requiredError,
    );
  }

  /// Marks the value as mandatory.
  DoubleSchema isRequired({String? error}) {
    return DoubleSchema._(
      name: name,
      checks: checks,
      required: true,
      requiredError: error,
    );
  }

  /// Requires the value to be a whole number.
  DoubleSchema isInteger({String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.isInteger,
        evaluate: (value) => value.truncateToDouble() == value
            ? null
            : '{name} should be a whole number',
        customError: error,
      ),
    );
  }

  /// Requires the value to be greater than [than].
  DoubleSchema greaterThan(double than, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.greaterThan,
        evaluate: (value) =>
            value > than ? null : '{name} should be greater than $than',
        customError: error,
      ),
    );
  }

  /// Requires the value to be greater than or equal to [than].
  DoubleSchema greaterThanOrEqualTo(double than, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.greaterThanOrEqualTo,
        evaluate: (value) => value >= than
            ? null
            : '{name} should be greater than or equal to $than',
        customError: error,
      ),
    );
  }

  /// Requires the value to be less than [than].
  DoubleSchema lessThan(double than, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.lessThan,
        evaluate: (value) =>
            value < than ? null : '{name} should be less than $than',
        customError: error,
      ),
    );
  }

  /// Requires the value to be less than or equal to [than].
  DoubleSchema lessThanOrEqualTo(double than, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.lessThanOrEqualTo,
        evaluate: (value) => value <= than
            ? null
            : '{name} should be less than or equal to $than',
        customError: error,
      ),
    );
  }

  /// Requires the value to equal [to].
  DoubleSchema equalTo(double to, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.equalTo,
        evaluate: (value) =>
            value == to ? null : '{name} should be equal to $to',
        customError: error,
      ),
    );
  }

  /// Requires the value to differ from [to].
  DoubleSchema notEqualTo(double to, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.notEqualTo,
        evaluate: (value) =>
            value != to ? null : '{name} should not be equal to $to',
        customError: error,
      ),
    );
  }

  /// Requires the value to be one of [values].
  DoubleSchema inList(List<double> values, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.inList,
        evaluate: (value) => values.contains(value)
            ? null
            : '{name} should be any of these values ${values.join(', ')}',
        customError: error,
      ),
    );
  }

  /// Requires the value to be none of [values].
  DoubleSchema notInList(List<double> values, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.notInList,
        evaluate: (value) => !values.contains(value)
            ? null
            : '{name} should not be any of these values ${values.join(', ')}',
        customError: error,
      ),
    );
  }

  /// Requires the value to satisfy a custom [test].
  DoubleSchema check(bool Function(double value) test, {String? error}) {
    return _add(
      Check<double>(
        kind: DoubleCheck.check,
        evaluate: (value) => test(value) ? null : '{name} is invalid',
        customError: error,
      ),
    );
  }

  /// Validates with a [validator] that returns its own error message, or null
  /// when the value is valid.
  DoubleSchema refine(String? Function(double value) validator) {
    return _add(Check<double>(kind: DoubleCheck.refine, evaluate: validator));
  }
}
