import 'package:rules/src/core/rule_check.dart';
import 'package:rules/src/core/rule_failure.dart';
import 'package:rules/src/core/rule_field.dart';

/// Base type for all group validation results.
///
/// A group validation can either succeed ([GroupValid]) or fail
/// ([GroupInvalid]).
sealed class GroupResult {
  const GroupResult();
}

/// The group passed validation.
///
/// This means:
/// - every field in the group passed its own validation
/// - all configured group rules were satisfied
final class GroupValid extends GroupResult {
  const GroupValid();
}

/// The group failed validation.
///
/// A failure can come from:
/// - a field inside the group
/// - [GroupCheck.requiredAll]
/// - [GroupCheck.requiredAtLeast]
/// - [GroupCheck.maxAllowed]
///
/// Field failures always take priority. If a field is invalid,
/// group-level rules are not evaluated.
///
/// Only one failure is ever returned.
final class GroupInvalid extends GroupResult {
  const GroupInvalid({required this.failure});

  /// Details about the validation failure.
  final RuleFailure failure;
}

/// Validates multiple fields as a single group.
///
/// A [GroupRule] validates relationships between fields rather than the
/// contents of a single value.
///
/// Individual values are validated by their own schemas. A group validation
/// is useful when multiple fields are related and must satisfy additional
/// rules together.
///
/// Supported group rules:
///
/// - [requiredAll] - every field must be present
/// - [requiredAtLeast] - at least N fields must be present
/// - [maxAllowed] - no more than N fields may be present
///
/// Presence is determined by [Validatable.isPresent].
///
/// Common use cases:
///
/// - Require all address fields to be completed.
/// - Require at least one contact method.
/// - Allow only one option from a set of fields.
/// - Validate a related set of fields as a single unit.
///
/// Example:
///
/// Require at least one contact method:
///
/// ```dart
/// final email = Rule.string(name: 'Email').bind('');
/// final phone = Rule.string(name: 'Phone').bind('1234567890');
///
/// final group = GroupRule(
///   name: 'Contact Details',
///   fields: [email, phone],
///   requiredAtLeast: 1,
/// );
///
/// print(group.hasError); // false
/// ```
///
/// Require every field:
///
/// ```dart
/// final firstName = Rule.string(name: 'First Name').bind('John');
/// final lastName = Rule.string(name: 'Last Name').bind('');
///
/// final group = GroupRule(
///   name: 'Profile',
///   fields: [firstName, lastName],
///   requiredAll: true,
/// );
///
/// print(group.error);
/// // All fields are mandatory in Profile
/// ```
///
/// Allow only one contact method:
///
/// ```dart
/// final email = Rule.string(name: 'Email').bind('abc@xyz.com');
/// final phone = Rule.string(name: 'Phone').bind('1234567890');
///
/// final group = GroupRule(
///   name: 'Preferred Contact Method',
///   fields: [email, phone],
///   maxAllowed: 1,
/// );
///
/// print(group.hasError); // true
/// ```
///
/// Validation order:
///
/// 1. Validate every field.
/// 2. Apply [requiredAll].
/// 3. Apply [requiredAtLeast].
/// 4. Apply [maxAllowed].
///
/// Validation stops at the first failure.
///
/// Field validation errors always take priority over group-level failures.
///
/// For example, if a field fails its own validation and the group also
/// violates [maxAllowed], only the field failure is reported.
///
/// Null entries inside [fields] are ignored.
final class GroupRule {
  const GroupRule({
    required this.name,
    required this.fields,
    this.requiredAll = false,
    this.requiredAtLeast,
    this.maxAllowed,
    this.requiredAllError,
    this.requiredAtLeastError,
    this.maxAllowedError,
  });

  /// Name of the group.
  ///
  /// Used when generating group-level error messages and stored in any
  /// produced [RuleFailure].
  ///
  /// The placeholder `{name}` in custom error messages is replaced with
  /// this value.
  ///
  /// Example:
  ///
  /// ```dart
  /// name: 'Contact Details'
  /// ```
  final String name;

  /// Fields that belong to this group.
  ///
  /// Every field must implement [Validatable].
  ///
  /// Individual field validation is performed before any group-level
  /// validation rules are evaluated.
  ///
  /// Presence checks used by [requiredAll], [requiredAtLeast], and
  /// [maxAllowed] are based on each field's [Validatable.isPresent]
  /// value.
  ///
  /// Null entries are ignored.
  final List<Validatable?> fields;

  /// Requires every field in the group to be present.
  ///
  /// Presence is determined using [Validatable.isPresent].
  ///
  /// Example:
  ///
  /// ```dart
  /// requiredAll: true
  /// ```
  ///
  /// If any field is absent, validation fails with
  /// [GroupCheck.requiredAll].
  ///
  /// This rule is commonly used when a group represents a set of fields
  /// that must be completed together.
  final bool requiredAll;

  /// Requires at least this many fields to be present.
  ///
  /// Example:
  ///
  /// ```dart
  /// requiredAtLeast: 2
  /// ```
  ///
  /// If fewer than the required number of fields are present,
  /// validation fails with [GroupCheck.requiredAtLeast].
  ///
  /// This rule is commonly used when several alternative inputs are
  /// available and only a minimum number must be supplied.
  ///
  /// A value of `null` disables this rule.
  final int? requiredAtLeast;

  /// Allows at most this many fields to be present.
  ///
  /// Example:
  ///
  /// ```dart
  /// maxAllowed: 1
  /// ```
  ///
  /// Commonly used when multiple fields are available but only one
  /// should be supplied.
  ///
  /// If more than the allowed number of fields are present,
  /// validation fails with [GroupCheck.maxAllowed].
  ///
  /// A value of `null` disables this rule.
  final int? maxAllowed;

  /// Custom error message used when [requiredAll] fails.
  ///
  /// If provided, this replaces the default message.
  ///
  /// The placeholder `{name}` is replaced with the group's name.
  ///
  /// Example:
  ///
  /// ```dart
  /// requiredAllError: 'All fields in {name} are required'
  /// ```
  final String? requiredAllError;

  /// Custom error message used when [requiredAtLeast] fails.
  ///
  /// If provided, this replaces the default message.
  ///
  /// The placeholder `{name}` is replaced with the group's name.
  final String? requiredAtLeastError;

  /// Custom error message used when [maxAllowed] fails.
  ///
  /// If provided, this replaces the default message.
  ///
  /// The placeholder `{name}` is replaced with the group's name.
  final String? maxAllowedError;

  /// Executes validation and returns the outcome.
  ///
  /// Validation is performed in two stages:
  ///
  /// 1. Every field is validated.
  /// 2. Group-level rules are evaluated.
  ///
  /// Field failures always take priority over group-level failures.
  ///
  /// Returns:
  ///
  /// - [GroupValid] when validation succeeds.
  /// - [GroupInvalid] when validation fails.
  ///
  /// Only the first failure is returned.
  GroupResult get result {
    final fieldFailure = _firstFieldFailure();
    if (fieldFailure != null) {
      return GroupInvalid(failure: fieldFailure);
    }

    final groupFailure = _groupFailure();
    if (groupFailure != null) {
      return GroupInvalid(failure: groupFailure);
    }

    return const GroupValid();
  }

  /// Returns the validation error message.
  ///
  /// Returns `null` when validation succeeds.
  String? get error => switch (result) {
        GroupValid() => null,
        GroupInvalid(:final failure) => failure.message,
      };

  /// Whether validation failed.
  ///
  /// Equivalent to:
  ///
  /// ```dart
  /// result is GroupInvalid
  /// ```
  bool get hasError => result is GroupInvalid;

  RuleFailure? _firstFieldFailure() {
    for (final field in fields) {
      if (field == null) {
        continue;
      }

      final failure = field.failure;
      if (failure != null) {
        return failure;
      }
    }

    return null;
  }

  RuleFailure? _groupFailure() {
    final present = fields.whereType<Validatable>().where((f) => f.isPresent);
    final presentCount = present.length;
    final totalCount = fields.whereType<Validatable>().length;

    if (requiredAll && presentCount < totalCount) {
      return _failure(
        kind: GroupCheck.requiredAll,
        custom: requiredAllError,
        fallback: 'All fields are mandatory in {name}',
      );
    }

    final atLeast = requiredAtLeast;
    if (atLeast != null && atLeast > 0 && presentCount < atLeast) {
      return _failure(
        kind: GroupCheck.requiredAtLeast,
        custom: requiredAtLeastError,
        fallback: 'At least $atLeast ${_plural('field', atLeast, verb: true)} '
            'required in {name}',
      );
    }

    final max = maxAllowed;
    if (max != null && presentCount > max) {
      return _failure(
        kind: GroupCheck.maxAllowed,
        custom: maxAllowedError,
        fallback: 'A maximum of $max ${_plural('field', max, verb: true)} '
            'allowed in {name}',
      );
    }

    return null;
  }

  RuleFailure _failure({
    required GroupCheck kind,
    required String? custom,
    required String fallback,
  }) {
    final template = custom ?? fallback;

    return RuleFailure(
      name: name,
      message: template.replaceAll('{name}', name),
      check: kind,
    );
  }

  String _plural(String word, int count, {bool verb = false}) {
    if (count == 1) {
      return '$word${verb ? ' is' : ''}';
    }

    return '${word}s${verb ? ' are' : ''}';
  }
}
