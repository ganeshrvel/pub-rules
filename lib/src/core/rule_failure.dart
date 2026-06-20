import 'package:rules/src/core/rule_check.dart';

/// Describes a single validation failure.
///
/// Carries the resolved, display-ready [message], the field [name] it belongs
/// to, and the [check] that produced it for programmatic handling.
final class RuleFailure {
  const RuleFailure({
    required this.name,
    required this.message,
    required this.check,
  });

  /// The display name of the field the failure belongs to.
  final String name;

  /// The resolved, display-ready error message.
  final String message;

  /// The constraint that produced the failure.
  final RuleCheck check;

  @override
  String toString() => message;
}
