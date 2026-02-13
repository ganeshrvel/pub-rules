## 2.1.2

Bug fix:

- Test fixes

## 2.1.1

New feature:

- Added support for URLs with credentials (RFC 3986 compliant) to handle authentication in URLs (e.g., `https://user@example.com` or `https://user:pass@example.com/path`)

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
