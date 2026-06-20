# Changelog

## 3.0.0

This is a complete, ground-up rewrite of the library. Everything is breaking since the 2.x line.
There is no migration path. Schemas must be rebuilt using the new chaining API.

If you need the old API, pin to the last 2.x
release: https://pub.dev/packages/rules/versions/2.2.0+1 (sdk: '>=2.12.0 <4.0.0'). 3.0.0 and above
requires sdk: '>=3.0.0 <4.0.0'.

### Breaking changes

- Removed the single untyped `Rule` class and its flat constructor of boolean/value flags (
  `isRequired`, `isEmail`, `isUrl`, `isPhone`, `isIp`, `isNumeric`, `isNumericDecimal`,
  `isAlphaSpace`, `isAlphaNumeric`, `isAlphaNumericSpace`, `regex`, `length`, `minLength`,
  `maxLength`, `greaterThan`, `greaterThanEqualTo`, `lessThan`, `lessThanEqualTo`, `equalTo`,
  `notEqualTo`, `equalToInList`, `notEqualToInList`, `shouldMatch`, `shouldNotMatch`, `shouldPass`,
  `shouldPassOrCustomError`, `inList`, `notInList`) passed in one constructor call
- Removed `RuleOptions` (`trim`, `lowerCase`, `upperCase` as constructor options). These are now
  schema methods (`.trim()`, `.toLowerCase()`, `.toUpperCase()`) chained directly on a
  `StringSchema`
- Removed `customErrorText` (a single string overriding every default message on a rule) and
  `customErrors` (a `Map<String, String>` keyed by option name). Every constraint method now takes
  its own optional `error` parameter directly
- Removed `Rule.copyWith()` and `GroupRule.copyWith()`. Schemas are immutable and rebuilt via
  chaining instead of copied and partially overridden
- Removed the implicit type coercion where every value, regardless of declared constraint, was
  passed and compared as a `String`. Values are now strongly typed per schema (`String`, `int`,
  `double`, `bool`)
- Removed the implicit "use `isNumericDecimal` automatically when `isNumeric` isn't set" behavior
  for numeric comparison constraints on string input. String-schema numeric comparisons now always
  parse both operands as decimals; integer and double schemas take typed `int`/`double` operands
  directly and never parse strings at all
- Removed `rule.error` / `rule.hasError` / `rule.value` as plain nullable getters on a mutable rule
  object. Replaced by the sealed `RuleResult<T>` returned from `.parse(value)`, read via `ok`,
  `hasError`, `hasValidatedValue`, `validatedValue`, and `error`, or consumed exhaustively via
  pattern matching or `fold`
- Removed the old `GroupRule([rule1, rule2], name: ...)` positional-list constructor. `GroupRule`
  now takes `fields: [...]` as a named parameter of `Validatable` (typically `RuleField`, produced
  by `schema.bind(value)`)
- Removed the old `CombinedRule(rules: [...], groupRules: [...])` field names. Renamed to
  `CombinedRule(fields: [...], groups: [...])`
- Removed `requiredAtleast` (lowercase l) on `GroupRule`. Renamed to `requiredAtLeast`
- Removed the exception thrown when a `GroupRule`'s field count was smaller than `requiredAtleast`.
  Out-of-range values are now handled gracefully by comparing against however many fields are
  actually present
- Removed string-keyed error identification (`'isRequired'`, `'isEmail'`, etc. as `Map` keys in
  `customErrors`). Replaced by stable, code-comparable `RuleCheck` enums (`StringCheck`, `IntCheck`,
  `DoubleCheck`, `BoolCheck`, `GroupCheck`), exposed as `RuleFailure.check`
- Removed `shouldPass` and `shouldPassOrCustomError` as separate, overlapping constraint slots.
  Unified into `check(bool Function(T) test, {error})` and `refine(String? Function(T) validator)`,
  available identically across every schema type
- Removed direct boolean-flag validation of non-`String` types through the single `Rule` class.
  Booleans, ints, and doubles each now have a dedicated schema (`BoolSchema`, `IntSchema`,
  `DoubleSchema`) with their own constraint set

### New APIs

- `Rule.string(name:)`, `Rule.integer(name:)`, `Rule.double(name:)`, `Rule.boolean(name:)` factories
  returning `StringSchema`, `IntSchema`, `DoubleSchema`, `BoolSchema` respectively
- Chainable builder methods on every schema, each returning a new immutable schema instance
- `StringSchema.trim()`, `.toLowerCase()`, `.toUpperCase()` as chained transform methods, applied in
  that order before any constraint runs
- Per-constraint `error` parameter on every builder method
- `{name}` and `{value}` placeholder resolution on both default and custom messages, and on
  `refine()` return strings
- `RuleResult<T>` sealed type (`Valid<T>` / `Invalid<T>`), with `ok`, `hasError`,
  `hasValidatedValue`, `validatedValue`, and `error` getters
- `RuleResult.fold()` for exhaustive resolution of both outcomes in one call
- `check(bool Function(T) test, {error})` on every schema type
- `refine(String? Function(T) validator)` on every schema type
- `GroupRule` rebuilt around `fields: List<Validatable?>`, with `requiredAll`, `requiredAtLeast`,
  `maxAllowed`, and matching error overrides
- `GroupResult` sealed type (`GroupValid` / `GroupInvalid`)
- `CombinedRule` rebuilt around `fields: List<Validatable?>` and `groups: List<GroupRule?>`,
  exposing `failures`, `errorList`, and `hasError`
- `BoolSchema.equalTo(bool to, {error})` as the general form behind `isTrue()`/`isFalse()`
- `StringSchema.regex(RegExp pattern, {error})` replacing the old `matches()` naming

---

## 2.2.0+1

New feature:

- Added `shouldPassOrCustomError`

## 2.1.2

Bug fix:

- Test fixes

## 2.1.1

New feature:

- Added support for URLs with credentials (RFC 3986 compliant) to handle authentication in URLs (
  e.g., `https://user@example.com` or `https://user:pass@example.com/path`)

## 2.1.0

New feature:

- Improved `isUrl` check to correctly validate https?://localhost and https?://<ip>

## 2.0.0

New feature:

- Added `shouldPass`

## 2.0.0-nullsafety.0

Added nullsafety

## 1.2.0+3

Fixes:

- Fixed `email` validation

## 1.2.0+1

New feature:

- Added `trim`, `upperCase` and `lowerCase` rule **options**

## 1.1.0

Breaking changes:

- `regex` now expects a RegExp object instead of String

## 1.0.2+1

- Added copyWith extension method for Rule and GroupRule

## 1.0.1+7

- Updated and cleaned README

## 1.0.1+5

- Updates: Now 'customErrors' has higher priority than 'customErrorText'

## 1.0.1+4

- README updated
- Docs updated

## 1.0.0

- Initial release
- Rules
- GroupRules
- CombinedRules
