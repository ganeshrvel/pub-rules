/// A type-safe, schema-first validation library for Dart.
///
/// Every value type has a dedicated schema builder, reached through [Rule]:
/// [Rule.string], [Rule.integer], [Rule.double] and [Rule.boolean]. A schema
/// is an immutable description of the constraints a value must satisfy.
/// Constraints are added through chained builder methods, each returning a new
/// schema, so a schema can be defined once and safely reused across many
/// values.
///
/// Running [Schema.parse] against a value yields a sealed [RuleResult]: either
/// [Valid], carrying the accepted value, or [Invalid], carrying a
/// [RuleFailure]. A result can be inspected through [RuleResult.ok],
/// [RuleResult.hasValidatedValue], [RuleResult.hasError], [RuleResult.validatedValue] and
/// [RuleResult.error], or consumed exhaustively with [RuleResult.fold].
///
/// ```dart
/// import 'package:rules/rules.dart';
///
/// final result = Rule.string(name: 'Email')
///     .isRequired()
///     .isEmail()
///     .parse('user@example.com');
///
/// if (result.hasError) {
///   print(result.error?.message);
/// }
/// ```
///
/// A schema can also be bound to a value with [Schema.bind] to produce a
/// [RuleField], the unit that [GroupRule] and [CombinedRule] operate on.
/// [GroupRule] applies cardinality constraints across a set of fields;
/// [CombinedRule] aggregates the failures of many fields and groups into a
/// single list.
///
/// The library is commonly imported under the `R` prefix:
///
/// ```dart
/// import 'package:rules/rules.dart' as R;
///
/// final age = R.Rule.integer(name: 'Age').isRequired().parse(21);
/// ```
library;

import 'package:rules/rules.dart';

export 'src/core/check.dart';
export 'src/core/ok_result.dart';
export 'src/core/rule_check.dart';
export 'src/core/rule_failure.dart';
export 'src/core/rule_field.dart';
export 'src/core/rule_result.dart';
export 'src/core/schema.dart';
export 'src/group/combined_rule.dart';
export 'src/group/group_rule.dart';
export 'src/rule.dart';
export 'src/schemas/bool_schema.dart';
export 'src/schemas/double_schema.dart';
export 'src/schemas/int_schema.dart';
export 'src/schemas/string_schema.dart';
