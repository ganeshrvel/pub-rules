import 'package:rules/src/core/check.dart';
import 'package:rules/src/core/message.dart';
import 'package:rules/src/core/rule_check.dart';
import 'package:rules/src/core/rule_failure.dart';
import 'package:rules/src/core/rule_field.dart';
import 'package:rules/src/core/rule_result.dart';

/// The base of every value schema.
///
/// A schema is an immutable definition: it holds a field [name], an ordered
/// list of [checks], and the required configuration, but no value. Calling
/// [validate] runs the definition against a supplied value and yields a typed
/// [RuleResult]. Builder methods on concrete subclasses return new schema
/// instances rather than mutating in place, so a schema is safe to reuse
/// across many values.
///
/// ```dart
/// final schema = Rule.string(name: 'Email').isRequired().isEmail();
///
/// final r1 = schema.validate('abc@xyz.com'); // Valid
/// final r2 = schema.validate('');            // Invalid — required
/// final r3 = schema.validate('notanemail');  // Invalid — isEmail
/// ```
abstract base class Schema<T extends Object> {
  const Schema({
    required this.name,
    required this.checks,
    required this.required,
    required this.requiredError,
  });

  /// The field's display name, used in error messages.
  final String name;

  /// The ordered constraints applied once a value is present.
  final List<Check<T>> checks;

  /// Whether a value must be present.
  final bool required;

  /// Override for the message shown when a required value is absent.
  final String? requiredError;

  /// Whether [value] counts as absent for this type.
  bool isAbsent(T? value);

  /// The check identity reported when a required value is absent.
  RuleCheck get requiredCheckKind;

  /// The default message template for an absent required value.
  String get requiredTemplate;

  /// Transforms a raw value before any constraint runs.
  T? prepare(T? value) => value;

  /// Validates [value] against this schema.
  RuleResult<T> validate(T? value) {
    final prepared = prepare(value);

    if (isAbsent(prepared)) {
      if (required) {
        final template = requiredError ?? requiredTemplate;
        final message = Message.resolve(template, name: name, value: '');

        return Invalid<T>(
          name: name,
          failure: RuleFailure(
            name: name,
            message: message,
            check: requiredCheckKind,
          ),
        );
      }

      // An absent optional value carries no validated value.
      return Valid<T>(name: name, value: null);
    }

    final present = prepared!;

    for (final check in checks) {
      final template = check.run(value: present);

      if (template != null) {
        final message = Message.resolve(
          template,
          name: name,
          value: present.toString(),
        );

        return Invalid<T>(
          name: name,
          failure: RuleFailure(
            name: name,
            message: message,
            check: check.kind,
          ),
        );
      }
    }

    return Valid<T>(name: name, value: present);
  }

  /// Binds this schema to a [value] for use inside a group.
  RuleField<T> bind(T? value) {
    return RuleField<T>(schema: this, value: value);
  }
}
