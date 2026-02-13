// Checks whether the given string [input] is a decimal number
bool isStringNumeric(String input, {bool allowDecimal = false}) {
  RegExp regExp;

  const regexWithoutDecimal = r'^-?\d+$';
  const regexWithDecimal = r'^-?\d*\.{0,1}\d+$';

  if (allowDecimal) {
    regExp = RegExp(regexWithDecimal);
  } else {
    regExp = RegExp(regexWithoutDecimal);
  }

  return regExp.hasMatch(input);
}

// Checks whether the given string [input] is a valid email address
bool isStringEmail(String input) {
  const regex =
      r'^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)';
  final regExp = RegExp(regex, caseSensitive: false);

  return regExp.hasMatch(input);
}

// Checks whether the given string [input] is a valid phone number
bool isStringPhone(String input) {
  const regex = r'([0-9\s\-]{7,})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$';
  final regExp = RegExp(regex);

  return regExp.hasMatch(input);
}

/// Validates URLs according to RFC 3986 with practical considerations.
///
/// Rules:
/// - Localhost and IP addresses REQUIRE protocol (http:// or https://)
/// - Domain names allow optional protocol
/// - Supports credentials in URLs (user:pass@host or publickey@host)
/// - Empty strings and null values are considered valid (no error)
///
/// Examples:
/// - Valid: https://key@tld.io/123, http://localhost:8080, www.example.com
/// - Invalid: localhost, 192.168.1.1, qwerty123
bool isStringUrl(String value) {
  // Empty or null is valid (no error)
  if (value.isEmpty) return true;

  // Localhost and IP addresses: REQUIRE protocol
  final localhostOrIpPattern = RegExp(
    r'^(https?):\/\/' // Protocol REQUIRED (http or https)
    r'(?:[a-zA-Z0-9._~:/?#\[\]@!$&()*+,;=%-]*@)?' // Optional credentials (RFC 3986)
    '(?:' // Start host alternatives
    'localhost|' // Localhost
    r'(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}' // IPv4 (0-255)
    '(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' // IPv4 last octet
    ')' // End host alternatives
    r'(?::\d{1,5})?' // Optional port (1-65535)
    r'(?:\/[^\s]*)?$', // Optional path
    caseSensitive: false,
  );

  // Domain names: Protocol OPTIONAL
  final domainPattern = RegExp(
    r'^(?:(https?):\/\/)?' // Protocol OPTIONAL
    r'(?:[a-zA-Z0-9._~:/?#\[\]@!$&()*+,;=%-]*@)?' // Optional credentials (RFC 3986)
    r'(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+' // Subdomain(s) + domain
    '[a-zA-Z]{2,}' // TLD (minimum 2 chars)
    r'(?::\d{1,5})?' // Optional port
    r'(?:\/[^\s]*)?$', // Optional path
    caseSensitive: false,
  );

  return localhostOrIpPattern.hasMatch(value) || domainPattern.hasMatch(value);
}

// Checks whether the given string [input] is a valid phone IP
bool isStringIp(String input) {
  const regex =
      r'((^\s*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))\s*$)|(^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$))';
  final regExp = RegExp(regex);

  return regExp.hasMatch(input);
}

// Checks whether the given string [input] contains only alphabets and spaces
bool isStringAlphaSpace(String input) {
  final regExp = RegExp(r'^[a-zA-Z\s]+$');

  return regExp.hasMatch(input);
}

// Checks whether the given string [input] contains only alphabets and numbers
bool isStringAlphaNumeric(String input) {
  final regExp = RegExp(r'^[a-zA-Z0-9]+$');

  return regExp.hasMatch(input);
}

// Checks whether the given string [input] contains only alphabets, numbers and spaces
bool isStringAlphaNumericSpace(String input) {
  final regExp = RegExp(r'^[a-zA-Z0-9\s]+$');

  return regExp.hasMatch(input);
}

// Checks whether the given string [input] matches the [regex]
bool isStringRegexMatch(String input, RegExp regex) {
  return regex.hasMatch(input);
}

// Match the string length
bool isStringLength(String input, int? length) {
  return input.length == length;
}

// Match the minimum string length
bool isStringMinLength(String input, int length) {
  return input.length >= length;
}

// Match the maximum string length
bool isStringMaxLength(String input, int length) {
  return input.length <= length;
}

// add plurality to a string
String plural(
  String text, {
  required int? value,
  bool verb = false,
}) {
  if (value == 1) {
    return '$text${verb ? ' is' : ''}';
  } else {
    return '${text}s${verb ? ' are' : ''}';
  }
}
