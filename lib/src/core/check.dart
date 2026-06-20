import 'package:rules/src/core/rule_check.dart';

/// A single constraint applied to a present (non-absent) value.
final class Check<T extends Object> {
  const Check({
    required this.kind,
    required this.evaluate,
    this.customError,
  });

  /// The identity of the constraint, surfaced on failure.
  final RuleCheck kind;

  /// Returns null when the value passes, otherwise an unresolved error template
  /// that may contain `{name}` and `{value}` placeholders.
  final String? Function(T value) evaluate;

  /// An inline override applied in place of the produced template on failure.
  final String? customError;

  /// Runs the constraint against [value], returning null when it passes.
  String? run({required T value}) {
    final failure = evaluate(value);

    if (failure == null) {
      return null;
    }

    return customError ?? failure;
  }
}
