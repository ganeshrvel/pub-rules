import 'package:rules/src/schemas/bool_schema.dart';
import 'package:rules/src/schemas/double_schema.dart';
import 'package:rules/src/schemas/int_schema.dart';
import 'package:rules/src/schemas/string_schema.dart';

/// The entry point for building value schemas.
///
/// Each factory returns an empty, immutable schema for a field named `name`.
/// Constraints are added with chained builder methods, and the schema is run
/// against a value with `parse`.
abstract final class Rule {
  /// Creates a [StringSchema] for a field named [name].
  static StringSchema string({required String name}) {
    return StringSchema.empty(name: name);
  }

  /// Creates an [IntSchema] for a field named [name].
  static IntSchema integer({required String name}) {
    return IntSchema.empty(name: name);
  }

  /// Creates a [DoubleSchema] for a field named [name].
  static DoubleSchema double({required String name}) {
    return DoubleSchema.empty(name: name);
  }

  /// Creates a [BoolSchema] for a field named [name].
  static BoolSchema boolean({required String name}) {
    return BoolSchema.empty(name: name);
  }
}
