import 'dart:core';

import 'package:rules/rules.dart';

/// Stable, code-comparable identifier for a validation constraint,
/// decoupled from the human-readable [RuleFailure.message].
///
/// Every concrete check enum implements this so [RuleFailure.check] can be
/// typed uniformly across schema types while [code] stays a fixed string
/// regardless of message wording or localization.
abstract interface class RuleCheck {
  /// Stable identifier, unique within the implementing enum.
  String get code;
}

/// Constraint identifiers for [StringSchema].
enum StringCheck implements RuleCheck {
  /// Check if value is missing or blank.
  isRequired,

  /// Check if value is a valid email address.
  isEmail,

  /// Check if value is a valid URL.
  isUrl,

  /// Check if value is a valid phone number.
  isPhone,

  /// Check if value is a valid IPv4 or IPv6 address.
  isIp,

  /// Check if value is a whole number (digits only, optional leading `-`).
  isNumeric,

  /// Check if value is a number (digits, optional decimal point, optional leading `-`).
  isNumericDecimal,

  /// Check if value contains only letters and spaces.
  isAlphaSpace,

  /// Check if value contains only letters and digits.
  isAlphaNumeric,

  /// Check if value contains only letters, digits, and spaces.
  isAlphaNumericSpace,

  /// Check if value matches the given [RegExp].
  regex,

  /// Check if value's character count equals the required length.
  length,

  /// Check if value has at least the required minimum length.
  minLength,

  /// Check if value has at most the allowed maximum length.
  maxLength,

  /// Check if value sorts lexicographically after the comparison value.
  greaterThan,

  /// Check if value sorts lexicographically at or after the comparison value.
  greaterThanOrEqualTo,

  /// Check if value sorts lexicographically before the comparison value.
  lessThan,

  /// Check if value sorts lexicographically at or before the comparison value.
  lessThanOrEqualTo,

  /// Check if value equals the required value.
  equalTo,

  /// Check if value differs from the value it's supposed to not equal.
  notEqualTo,

  /// Check if value is one of the allowed values.
  inList,

  /// Check if value is none of the disallowed values.
  notInList,

  /// Check if value matches the value it's supposed to match.
  shouldMatch,

  /// Check if value differs from the value it's supposed to not match.
  shouldNotMatch,

  /// Check if value passes a custom predicate from `.check(...)`.
  check,

  /// Check if value passes a custom validator from `.refine(...)`.
  refine;

  @override
  String get code => name;
}

/// Constraint identifiers for [IntSchema].
enum IntCheck implements RuleCheck {
  /// Check if value is missing.
  isRequired,

  /// Check if value is greater than the comparison value.
  greaterThan,

  /// Check if value is greater than or equal to the comparison value.
  greaterThanOrEqualTo,

  /// Check if value is less than the comparison value.
  lessThan,

  /// Check if value is less than or equal to the comparison value.
  lessThanOrEqualTo,

  /// Check if value equals the required value.
  equalTo,

  /// Check if value differs from the value it's supposed to not equal.
  notEqualTo,

  /// Check if value is one of the allowed values.
  inList,

  /// Check if value is none of the disallowed values.
  notInList,

  /// Check if value passes a custom predicate from `.check(...)`.
  check,

  /// Check if value passes a custom validator from `.refine(...)`.
  refine;

  @override
  String get code => name;
}

/// Constraint identifiers for [DoubleSchema].
enum DoubleCheck implements RuleCheck {
  /// Check if value is missing.
  isRequired,

  /// Check if value is a whole number with no fractional part.
  isInteger,

  /// Check if value is greater than the comparison value.
  greaterThan,

  /// Check if value is greater than or equal to the comparison value.
  greaterThanOrEqualTo,

  /// Check if value is less than the comparison value.
  lessThan,

  /// Check if value is less than or equal to the comparison value.
  lessThanOrEqualTo,

  /// Check if value equals the required value.
  equalTo,

  /// Check if value differs from the value it's supposed to not equal.
  notEqualTo,

  /// Check if value is one of the allowed values.
  inList,

  /// Check if value is none of the disallowed values.
  notInList,

  /// Check if value passes a custom predicate from `.check(...)`.
  check,

  /// Check if value passes a custom validator from `.refine(...)`.
  refine;

  @override
  String get code => name;
}

/// Constraint identifiers for [BoolSchema].
enum BoolCheck implements RuleCheck {
  /// Check if value is missing.
  isRequired,

  /// Check if value is true.
  isTrue,

  /// Check if value is false.
  isFalse,

  /// Check if value equals the required value.
  equalTo,

  /// Check if value passes a custom predicate from `.check(...)`.
  check,

  /// Check if value passes a custom validator from `.refine(...)`.
  refine;

  @override
  String get code => name;
}

/// Constraint identifiers for [GroupRule]'s cardinality checks.
enum GroupCheck implements RuleCheck {
  /// Check if every field in the group is present.
  requiredAll,

  /// Check if at least the configured minimum number of fields is present.
  requiredAtLeast,

  /// Check if at most the configured maximum number of fields is present.
  maxAllowed;

  @override
  String get code => name;
}
