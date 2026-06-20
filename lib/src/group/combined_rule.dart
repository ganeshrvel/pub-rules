import 'package:rules/rules.dart';

/// Collects validation failures from multiple fields and groups.
///
/// A [CombinedRule] is typically used at the final stage of validation,
/// after individual fields and groups have already been defined.
///
/// Unlike a [Schema], which validates a single value, or a [GroupRule],
/// which validates relationships between a set of fields, [CombinedRule]
/// performs no validation of its own.
///
/// Instead, it gathers failures from:
///
/// - individual fields
/// - group validations
///
/// and exposes them as a single collection.
///
/// This is useful when validating an entire form, wizard, settings page,
/// API request, or any other object that contains multiple independent
/// validation rules.
///
/// Example:
///
/// ```dart
/// final email =
///     Rule.string(name: 'Email')
///         .isEmail()
///         .bind('invalid');
///
/// final password =
///     Rule.string(name: 'Password')
///         .isRequired()
///         .bind('');
///
/// final contactEmail =
///     Rule.string(name: 'Contact Email')
///         .bind('abc@xyz.com');
///
/// final contactPhone =
///     Rule.string(name: 'Contact Phone')
///         .bind('1234567890');
///
/// final contactGroup = GroupRule(
///   name: 'Contact Method',
///   fields: [contactEmail, contactPhone],
///   maxAllowed: 1,
///   maxAllowedError: 'Choose only one contact method',
/// );
///
/// final combined = CombinedRule(
///   fields: [email, password],
///   groups: [contactGroup],
/// );
///
/// print(combined.errorList);
/// ```
///
/// Output:
///
/// ```text
/// [
///   'Email is not a valid email address',
///   'Password is required',
///   'Choose only one contact method'
/// ]
/// ```
///
/// Failure ordering is preserved.
///
/// Field failures are always collected before group failures:
///
/// 1. Field failures are collected in the order they appear in [fields].
/// 2. Group failures are collected in the order they appear in [groups].
///
/// This predictable ordering makes it suitable for displaying validation
/// errors directly to users.
///
/// A group contributes at most one failure because [GroupRule] stops
/// validation after its first failing condition.
///
/// Null entries in [fields] and [groups] are ignored.
final class CombinedRule {
  const CombinedRule({
    this.fields = const [],
    this.groups = const [],
  });

  /// Individual fields to validate.
  ///
  /// Each field must implement [Validatable].
  ///
  /// Any field whose [Validatable.failure] is non-null contributes a
  /// failure to [failures].
  ///
  /// Failures appear in the same order as the fields in this list.
  ///
  /// Null entries are ignored.
  final List<Validatable?> fields;

  /// Groups to validate.
  ///
  /// Each group's [GroupRule.result] is evaluated.
  ///
  /// If a group returns [GroupInvalid], its failure is added to
  /// [failures].
  ///
  /// Group failures are appended after all field failures.
  ///
  /// Null entries are ignored.
  final List<GroupRule?> groups;

  /// All validation failures collected from [fields] and [groups].
  ///
  /// Failures are returned in a stable order:
  ///
  /// 1. Field failures, in the order fields were declared.
  /// 2. Group failures, in the order groups were declared.
  ///
  /// A field can appear more than once if it is validated directly and
  /// also participates in a failing group.
  ///
  /// Example:
  ///
  /// ```dart
  /// final field =
  ///     Rule.string(name: 'Name').isRequired().bind('');
  ///
  /// final group = GroupRule(
  ///   name: 'Profile',
  ///   fields: [field],
  ///   requiredAll: true,
  /// );
  ///
  /// final combined = CombinedRule(
  ///   fields: [field],
  ///   groups: [group],
  /// );
  ///
  /// print(combined.errorList.length);
  /// // 2
  /// ```
  ///
  /// Each [GroupRule] contributes at most one failure because a group
  /// stops validation after its first failing rule.
  ///
  /// Returns an empty list when validation succeeds.
  List<RuleFailure> get failures {
    final result = <RuleFailure>[];

    for (final field in fields) {
      final failure = field?.failure;
      if (failure != null) {
        result.add(failure);
      }
    }

    for (final group in groups) {
      final outcome = group?.result;
      if (outcome is GroupInvalid) {
        result.add(outcome.failure);
      }
    }

    return result;
  }

  /// All validation messages as plain strings.
  ///
  /// This is a convenience wrapper around [failures] that extracts
  /// [RuleFailure.message] from each failure.
  ///
  /// Example:
  ///
  /// ```dart
  /// final errors = combinedRule.errorList;
  /// ```
  List<String> get errorList =>
      failures.map((failure) => failure.message).toList();

  /// Whether any validation failures exist.
  ///
  /// Equivalent to:
  ///
  /// ```dart
  /// failures.isNotEmpty
  /// ```
  bool get hasError => failures.isNotEmpty;
}
