import 'package:rules/src/core/check.dart';
import 'package:rules/src/core/rule_check.dart';
import 'package:rules/src/core/schema.dart';

/// A schema for validating boolean values.
final class BoolSchema extends Schema<bool> {
  const BoolSchema._({
    required super.name,
    required super.checks,
    required super.required,
    required super.requiredError,
  });

  /// Creates an empty boolean schema for a field named [name].
  BoolSchema.empty({required super.name})
      : super(
          checks: const <Check<bool>>[],
          required: false,
          requiredError: null,
        );

  @override
  RuleCheck get requiredCheckKind => BoolCheck.isRequired;

  @override
  String get requiredTemplate => '{name} is required';

  @override
  bool isAbsent(bool? value) => value == null;

  BoolSchema _add(Check<bool> check) {
    return BoolSchema._(
      name: name,
      checks: [...checks, check],
      required: required,
      requiredError: requiredError,
    );
  }

  /// Marks the value as mandatory.
  BoolSchema isRequired({String? error}) {
    return BoolSchema._(
      name: name,
      checks: checks,
      required: true,
      requiredError: error,
    );
  }

  /// Requires the value to be true.
  BoolSchema isTrue({String? error}) {
    return _add(
      Check<bool>(
        kind: BoolCheck.isTrue,
        evaluate: (value) => value ? null : '{name} must be true',
        customError: error,
      ),
    );
  }

  /// Requires the value to be false.
  BoolSchema isFalse({String? error}) {
    return _add(
      Check<bool>(
        kind: BoolCheck.isFalse,
        evaluate: (value) => !value ? null : '{name} must be false',
        customError: error,
      ),
    );
  }

  /// Requires the value to equal [to].
  // ignore: avoid_positional_boolean_parameters
  BoolSchema equalTo(bool to, {String? error}) {
    return _add(
      Check<bool>(
        kind: BoolCheck.equalTo,
        evaluate: (value) =>
            value == to ? null : '{name} should be equal to $to',
        customError: error,
      ),
    );
  }

  /// Requires the value to satisfy a custom [test].
  // ignore: avoid_positional_boolean_parameters
  BoolSchema check(bool Function(bool value) test, {String? error}) {
    return _add(
      Check<bool>(
        kind: BoolCheck.check,
        evaluate: (value) => test(value) ? null : '{name} is invalid',
        customError: error,
      ),
    );
  }

  /// Validates with a [validator] that returns its own error message, or null
  /// when the value is valid.
  // ignore: avoid_positional_boolean_parameters
  BoolSchema refine(String? Function(bool value) validator) {
    return _add(Check<bool>(kind: BoolCheck.refine, evaluate: validator));
  }
}
