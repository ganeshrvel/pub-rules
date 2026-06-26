import 'package:rules/src/core/ok_result.dart';
import 'package:rules/src/core/rule_failure.dart';

/// The outcome of validating a single value against a schema.
///
/// A [RuleResult] is either [Valid], holding the accepted value, or [Invalid],
/// holding the failure. Pattern match, or use [fold], to handle both arms
/// exhaustively.
///
/// ## How to consume a result
///
/// ```dart
/// Rule.string(name: 'Email').isRequired().isEmail().validate('a@b.com').fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'),
///     onNull: () => print('$name not provided'),
///   ),
///   onError: ({required name, required error}) => print(error.message),
/// );
/// ```
///
/// ## What gets promoted in each scenario
///
/// **String schema**
///
/// ```dart
/// // present value, passes isEmail → onValidatedValue promoted, value is 'a@b.com'
/// Rule.string(name: 'Email').isRequired().isEmail().validate('a@b.com').fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted
///     ...
///   ),
///   ...
/// );
///
/// // present value, fails isEmail → onError promoted
/// Rule.string(name: 'Email').isRequired().isEmail().validate('notanemail').fold(
///   ...
///   onError: ({required name, required error}) => print(error.message), // ← promoted
/// );
///
/// // empty string, required → onError promoted
/// Rule.string(name: 'Email').isRequired().validate('').fold(
///   ...
///   onError: ({required name, required error}) => print(error.message), // ← promoted, 'Email is required'
/// );
///
/// // empty string, optional → onNull promoted
/// Rule.string(name: 'Email').validate('').fold(
///   onOk: (ok, {required name}) => ok.fold(
///     ...
///     onNull: () => print('$name not provided'), // ← promoted
///   ),
///   ...
/// );
///
/// // null, optional → onNull promoted
/// Rule.string(name: 'Email').validate(null).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     ...
///     onNull: () => print('$name not provided'), // ← promoted
///   ),
///   ...
/// );
///
/// // all spaces, no trim, optional → onValidatedValue promoted, value is '   '
/// // spaces are non-empty so the value is treated as present
/// Rule.string(name: 'Bio').validate('   ').fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is '   '
///     ...
///   ),
///   ...
/// );
///
/// // all spaces, with trim, optional → onNull promoted
/// // trim collapses '   ' to '' which is absent
/// Rule.string(name: 'Bio').trim().validate('   ').fold(
///   onOk: (ok, {required name}) => ok.fold(
///     ...
///     onNull: () => print('$name not provided'), // ← promoted
///   ),
///   ...
/// );
///
/// // all spaces, with trim, required → onError promoted
/// // trim collapses '   ' to '' which fails required
/// Rule.string(name: 'Bio').isRequired().trim().validate('   ').fold(
///   ...
///   onError: ({required name, required error}) => print(error.message), // ← promoted, 'Bio is required'
/// );
///
/// // spaces around value, no trim → onValidatedValue promoted, value is '  john  '
/// Rule.string(name: 'Name').validate('  john  ').fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is '  john  '
///     ...
///   ),
///   ...
/// );
///
/// // spaces around value, with trim → onValidatedValue promoted, value is 'john'
/// Rule.string(name: 'Name').trim().validate('  john  ').fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is 'john'
///     ...
///   ),
///   ...
/// );
///
/// // trim + toLowerCase → onValidatedValue promoted, value is 'a@b.com'
/// Rule.string(name: 'Email').trim().toLowerCase().isEmail().validate('  A@B.COM  ').fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is 'a@b.com'
///     ...
///   ),
///   ...
/// );
/// ```
///
/// **Integer schema**
///
/// ```dart
/// // present value, passes → onValidatedValue promoted, value is 25
/// Rule.integer(name: 'Age').isRequired().greaterThan(0).validate(25).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is 25
///     ...
///   ),
///   ...
/// );
///
/// // zero — zero is a real value → onValidatedValue promoted, value is 0
/// Rule.integer(name: 'Score').validate(0).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is 0
///     ...
///   ),
///   ...
/// );
///
/// // null, optional → onNull promoted
/// Rule.integer(name: 'Age').validate(null).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     ...
///     onNull: () => print('$name not provided'), // ← promoted
///   ),
///   ...
/// );
///
/// // null, required → onError promoted
/// Rule.integer(name: 'Age').isRequired().validate(null).fold(
///   ...
///   onError: ({required name, required error}) => print(error.message), // ← promoted, 'Age is required'
/// );
///
/// // fails greaterThan → onError promoted
/// Rule.integer(name: 'Age').greaterThan(18).validate(10).fold(
///   ...
///   onError: ({required name, required error}) => print(error.message), // ← promoted, 'Age should be greater than 18'
/// );
/// ```
///
/// **Double schema**
///
/// ```dart
/// // present value, passes → onValidatedValue promoted, value is 9.99
/// Rule.double(name: 'Price').greaterThan(0.0).validate(9.99).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is 9.99
///     ...
///   ),
///   ...
/// );
///
/// // 0.0 — zero is a real value → onValidatedValue promoted, value is 0.0
/// Rule.double(name: 'Price').validate(0.0).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is 0.0
///     ...
///   ),
///   ...
/// );
///
/// // null, optional → onNull promoted
/// Rule.double(name: 'Price').validate(null).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     ...
///     onNull: () => print('$name not provided'), // ← promoted
///   ),
///   ...
/// );
///
/// // fails greaterThan → onError promoted
/// Rule.double(name: 'Price').greaterThan(0.0).validate(-1.5).fold(
///   ...
///   onError: ({required name, required error}) => print(error.message), // ← promoted, 'Price should be greater than 0.0'
/// );
/// ```
///
/// **Bool schema**
///
/// ```dart
/// // true, passes isTrue → onValidatedValue promoted, value is true
/// Rule.boolean(name: 'Terms').isRequired().isTrue().validate(true).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is true
///     ...
///   ),
///   ...
/// );
///
/// // false, fails isTrue → onError promoted
/// Rule.boolean(name: 'Terms').isRequired().isTrue().validate(false).fold(
///   ...
///   onError: ({required name, required error}) => print(error.message), // ← promoted, 'Terms must be true'
/// );
///
/// // false, no constraints → onValidatedValue promoted, value is false
/// Rule.boolean(name: 'Newsletter').validate(false).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     onValidatedValue: ({required value}) => print('$name: $value'), // ← promoted, value is false
///     ...
///   ),
///   ...
/// );
///
/// // null, optional → onNull promoted
/// Rule.boolean(name: 'Newsletter').validate(null).fold(
///   onOk: (ok, {required name}) => ok.fold(
///     ...
///     onNull: () => print('$name not provided'), // ← promoted
///   ),
///   ...
/// );
///
/// // null, required → onError promoted
/// Rule.boolean(name: 'Terms').isRequired().validate(null).fold(
///   ...
///   onError: ({required name, required error}) => print(error.message), // ← promoted, 'Terms is required'
/// );
/// ```
sealed class RuleResult<T extends Object> {
  const RuleResult({required this.name});

  /// The display name of the field this result belongs to.
  final String name;

  /// Whether validation passed.
  ///
  /// True for both a present value that satisfied all constraints and an
  /// optional field that was left absent.
  bool get ok => this is Valid<T>;

  /// Whether validation failed.
  bool get hasError => this is Invalid<T>;

  /// Whether this result carries a usable value.
  ///
  /// True only when validation passed **and** the input was non-empty after
  /// any transforms (trim, toLowerCase, toUpperCase) ran. False in every
  /// other case:
  ///
  /// - the field was required and the value was absent → [hasError] is true
  /// - the field was optional and the value was absent, empty, or became
  ///   empty after trimming → [ok] is true but [hasValidatedValue] is false
  /// - validation failed on a constraint such as `isEmail` → [hasError] is true
  ///
  /// Examples:
  ///
  /// ```dart
  /// // present value, passes — true
  /// Rule.string(name: 'Name').isRequired().validate('John').hasValidatedValue; // true
  ///
  /// // present value, optional — true
  /// Rule.string(name: 'Name').validate('John').hasValidatedValue; // true
  ///
  /// // empty string, optional — false (nothing was provided)
  /// Rule.string(name: 'Name').validate('').hasValidatedValue; // false
  ///
  /// // null, optional — false
  /// Rule.string(name: 'Name').validate(null).hasValidatedValue; // false
  ///
  /// // all spaces, no trim, optional — false (spaces are treated as absent)
  /// Rule.string(name: 'Name').validate('   ').hasValidatedValue; // false
  ///
  /// // all spaces, with trim, optional — false (trims to empty, still absent)
  /// Rule.string(name: 'Name').trim().validate('   ').hasValidatedValue; // false
  ///
  /// // all spaces, with trim, required — false (trims to empty, fails required)
  /// Rule.string(name: 'Name').isRequired().trim().validate('   ').hasValidatedValue; // false
  ///
  /// // spaces around value, with trim — true (trims to 'john', present)
  /// Rule.string(name: 'Name').trim().validate('  john  ').hasValidatedValue; // true
  ///
  /// // spaces around value, without trim — the value is non-empty so it is
  /// // treated as present and passes through untouched
  /// Rule.string(name: 'Name').validate('  john  ').hasValidatedValue; // true
  ///
  /// // validation failed — false
  /// Rule.string(name: 'Name').isEmail().validate('notanemail').hasValidatedValue; // false
  ///
  /// // integer, null optional — false
  /// Rule.integer(name: 'Age').validate(null).hasValidatedValue; // false
  ///
  /// // integer, zero present — true (zero is a real value)
  /// Rule.integer(name: 'Age').validate(0).hasValidatedValue; // true
  ///
  /// // bool, false present — true (false is a real value)
  /// Rule.boolean(name: 'Terms').validate(false).hasValidatedValue; // true
  /// ```
  bool get hasValidatedValue => switch (this) {
        Valid(:final value) => value != null,
        Invalid() => false,
      };

  /// The value as it looked after transforms ran and validation passed.
  ///
  /// This is the clean, ready-to-use form of the input. Any trim,
  /// toLowerCase or toUpperCase that was chained on the schema has already
  /// been applied. If validation failed or nothing was provided, this is null.
  ///
  /// Examples:
  ///
  /// ```dart
  /// // basic present value
  /// Rule.string(name: 'Name').validate('John').validatedValue; // 'John'
  ///
  /// // trim applied — leading and trailing spaces removed
  /// Rule.string(name: 'Name').trim().validate('  John  ').validatedValue; // 'John'
  ///
  /// // toLowerCase applied
  /// Rule.string(name: 'Name').toLowerCase().validate('JOHN').validatedValue; // 'john'
  ///
  /// // toUpperCase applied
  /// Rule.string(name: 'Name').toUpperCase().validate('john').validatedValue; // 'JOHN'
  ///
  /// // trim + toLowerCase together
  /// Rule.string(name: 'Email').trim().toLowerCase().validate('  ABC@XYZ.COM  ').validatedValue; // 'abc@xyz.com'
  ///
  /// // all spaces without trim — isAbsent fires on the raw value '   '?
  /// // no — '   '.isEmpty is false, so it is present, no transforms, stays '   '
  /// Rule.string(name: 'Name').validate('   ').validatedValue; // '   '
  ///
  /// // all spaces with trim — trims to '', isAbsent fires, optional so null
  /// Rule.string(name: 'Name').trim().validate('   ').validatedValue; // null
  ///
  /// // empty string optional — null (absent)
  /// Rule.string(name: 'Name').validate('').validatedValue; // null
  ///
  /// // null optional — null
  /// Rule.string(name: 'Name').validate(null).validatedValue; // null
  ///
  /// // validation failed — null
  /// Rule.string(name: 'Name').isEmail().validate('notanemail').validatedValue; // null
  ///
  /// // integer present — the int value itself
  /// Rule.integer(name: 'Age').validate(25).validatedValue; // 25
  ///
  /// // integer zero — zero, not null (zero is a real value)
  /// Rule.integer(name: 'Age').validate(0).validatedValue; // 0
  ///
  /// // integer null optional — null
  /// Rule.integer(name: 'Age').validate(null).validatedValue; // 0
  ///
  /// // double present after passing greaterThan
  /// Rule.double(name: 'Price').greaterThan(0.0).validate(9.99).validatedValue; // 9.99
  ///
  /// // bool false present — false, not null
  /// Rule.boolean(name: 'Terms').validate(false).validatedValue; // false
  ///
  /// // bool null optional — null
  /// Rule.boolean(name: 'Terms').validate(null).validatedValue; // null
  /// ```
  T? get validatedValue => switch (this) {
        Valid(:final value) => value,
        Invalid() => null,
      };

  /// The failure, or null when validation succeeded.
  RuleFailure? get error => switch (this) {
        Valid() => null,
        Invalid(:final failure) => failure,
      };

  /// Resolves the success and failure arms exhaustively.
  ///
  /// [onOk] receives an [OkResult] that folds further to distinguish a present
  /// validated value from an absent optional field.
  R fold<R>({
    required R Function(OkResult<T> ok, {required String name}) onOk,
    required R Function({
      required String name,
      required RuleFailure error,
    }) onError,
  }) {
    return switch (this) {
      Valid(:final value) => onOk(
          value == null ? OkNull<T>() : OkValidatedValue<T>(value),
          name: name,
        ),
      Invalid(:final failure) => onError(name: name, error: failure),
    };
  }
}

/// A successful validation outcome.
final class Valid<T extends Object> extends RuleResult<T> {
  const Valid({required super.name, required this.value});

  /// The accepted value.
  ///
  /// Null only when an optional field was left absent.
  final T? value;
}

/// A failed validation outcome.
final class Invalid<T extends Object> extends RuleResult<T> {
  const Invalid({required super.name, required this.failure});

  /// The failure describing why validation did not pass.
  final RuleFailure failure;
}
