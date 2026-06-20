/// Resolves the `{name}` and `{value}` placeholders inside an error template.
///
/// `{name}` is replaced with the field's display name and `{value}` with the
/// string form of the value under validation.
abstract final class Message {
  static String resolve(
    String template, {
    required String name,
    required String value,
  }) {
    return template.replaceAll('{name}', name).replaceAll('{value}', value);
  }
}
