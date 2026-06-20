import 'package:rules/src/core/check.dart';
import 'package:rules/src/core/rule_check.dart';
import 'package:rules/src/core/schema.dart';

/// A schema for validating integer values.
final class IntSchema extends Schema<int> {
  const IntSchema._({
    required super.name,
    required super.checks,
    required super.required,
    required super.requiredError,
  });

  /// Creates an empty integer schema for a field named [name].
  IntSchema.empty({required super.name})
      : super(
          checks: const <Check<int>>[],
          required: false,
          requiredError: null,
        );

  @override
  RuleCheck get requiredCheckKind => IntCheck.isRequired;

  @override
  String get requiredTemplate => '{name} is required';

  @override
  bool isAbsent(int? value) => value == null;

  IntSchema _add(Check<int> check) {
    return IntSchema._(
      name: name,
      checks: [...checks, check],
      required: required,
      requiredError: requiredError,
    );
  }

  /// Marks the value as mandatory.
  IntSchema isRequired({String? error}) {
    return IntSchema._(
      name: name,
      checks: checks,
      required: true,
      requiredError: error,
    );
  }

  /// Requires the value to be greater than [than].
  IntSchema greaterThan(int than, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.greaterThan,
        evaluate: (value) =>
            value > than ? null : '{name} should be greater than $than',
        customError: error,
      ),
    );
  }

  /// Requires the value to be greater than or equal to [than].
  IntSchema greaterThanOrEqualTo(int than, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.greaterThanOrEqualTo,
        evaluate: (value) => value >= than
            ? null
            : '{name} should be greater than or equal to $than',
        customError: error,
      ),
    );
  }

  /// Requires the value to be less than [than].
  IntSchema lessThan(int than, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.lessThan,
        evaluate: (value) =>
            value < than ? null : '{name} should be less than $than',
        customError: error,
      ),
    );
  }

  /// Requires the value to be less than or equal to [than].
  IntSchema lessThanOrEqualTo(int than, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.lessThanOrEqualTo,
        evaluate: (value) => value <= than
            ? null
            : '{name} should be less than or equal to $than',
        customError: error,
      ),
    );
  }

  /// Requires the value to equal [to].
  IntSchema equalTo(int to, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.equalTo,
        evaluate: (value) =>
            value == to ? null : '{name} should be equal to $to',
        customError: error,
      ),
    );
  }

  /// Requires the value to differ from [to].
  IntSchema notEqualTo(int to, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.notEqualTo,
        evaluate: (value) =>
            value != to ? null : '{name} should not be equal to $to',
        customError: error,
      ),
    );
  }

  /// Requires the value to be one of [values].
  IntSchema inList(List<int> values, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.inList,
        evaluate: (value) => values.contains(value)
            ? null
            : '{name} should be any of these values ${values.join(', ')}',
        customError: error,
      ),
    );
  }

  /// Requires the value to be none of [values].
  IntSchema notInList(List<int> values, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.notInList,
        evaluate: (value) => !values.contains(value)
            ? null
            : '{name} should not be any of these values ${values.join(', ')}',
        customError: error,
      ),
    );
  }

  /// Requires the value to satisfy a custom [test].
  IntSchema check(bool Function(int value) test, {String? error}) {
    return _add(
      Check<int>(
        kind: IntCheck.check,
        evaluate: (value) => test(value) ? null : '{name} is invalid',
        customError: error,
      ),
    );
  }

  /// Validates with a [validator] that returns its own error message, or null
  /// when the value is valid.
  IntSchema refine(String? Function(int value) validator) {
    return _add(Check<int>(kind: IntCheck.refine, evaluate: validator));
  }
}
