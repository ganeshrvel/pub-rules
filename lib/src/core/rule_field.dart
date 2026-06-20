import 'package:rules/src/core/rule_failure.dart';
import 'package:rules/src/core/rule_result.dart';
import 'package:rules/src/core/schema.dart';

/// A schema paired with a concrete value, ready for group validation.
///
/// This is the common currency a group operates on: it exposes the field
/// [name], whether a value [isPresent], and the [failure] if any, without the
/// group needing to know the value's static type.
abstract interface class Validatable {
  /// The field's display name.
  String get name;

  /// Whether a non-absent value was supplied.
  bool get isPresent;

  /// The failure for this field, or null when it is valid.
  RuleFailure? get failure;
}

/// A typed binding of a [Schema] to a value.
final class RuleField<T extends Object> implements Validatable {
  RuleField({required this.schema, required this.value});

  /// The schema the value is validated against.
  final Schema<T> schema;

  /// The bound value.
  final T? value;

  /// The cached validation outcome for the bound value.
  late final RuleResult<T> result = schema.parse(value);

  @override
  String get name => schema.name;

  @override
  bool get isPresent => !schema.isAbsent(schema.prepare(value));

  @override
  RuleFailure? get failure => result.error;
}
