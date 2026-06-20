/// The present-or-absent arm of a successful validation.
///
/// A successful outcome either carries a concrete value
/// ([OkValidatedValue]) or stands for an optional field that was left absent
/// ([OkNull]). Folding over an [OkResult] separates these two outcomes without
/// a manual null check.
sealed class OkResult<T extends Object> {
  const OkResult();

  /// Resolves the present and absent outcomes.
  R fold<R>({
    required R Function({required T value}) onValidatedValue,
    required R Function() onNull,
  });
}

/// A successful outcome carrying a concrete, validated value.
final class OkValidatedValue<T extends Object> extends OkResult<T> {
  const OkValidatedValue(this.value);

  /// The validated value.
  final T value;

  @override
  R fold<R>({
    required R Function({required T value}) onValidatedValue,
    required R Function() onNull,
  }) {
    return onValidatedValue(value: value);
  }
}

/// A successful outcome for an optional field that was left absent.
final class OkNull<T extends Object> extends OkResult<T> {
  const OkNull();

  @override
  R fold<R>({
    required R Function({required T value}) onValidatedValue,
    required R Function() onNull,
  }) {
    return onNull();
  }
}
