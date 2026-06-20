/// The string predicate set.
///
/// Every pattern is compiled once and reused, so repeated validation does no
/// repeated compilation work.
abstract final class StringValidators {
  static final RegExp _email = RegExp(
    r'^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)',
    caseSensitive: false,
  );

  static final RegExp _phone = RegExp(
    r'([0-9\s\-]{7,})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$',
  );

  static final RegExp _ip = RegExp(
    r'((^\s*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))\s*$)|(^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$))',
  );

  static final RegExp _localhostOrIpUrl = RegExp(
    r'^(https?):\/\/'
    r'(?:[a-zA-Z0-9._~:/?#\[\]@!$&()*+,;=%-]*@)?'
    '(?:'
    'localhost|'
    r'(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}'
    '(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
    ')'
    r'(?::\d{1,5})?'
    r'(?:\/[^\s]*)?$',
    caseSensitive: false,
  );

  static final RegExp _domainUrl = RegExp(
    r'^(?:(https?):\/\/)?'
    r'(?:[a-zA-Z0-9._~:/?#\[\]@!$&()*+,;=%-]*@)?'
    r'(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+'
    '[a-zA-Z]{2,}'
    r'(?::\d{1,5})?'
    r'(?:\/[^\s]*)?$',
    caseSensitive: false,
  );

  static final RegExp _numericWhole = RegExp(r'^-?\d+$');

  static final RegExp _numericDecimal = RegExp(r'^-?\d*\.{0,1}\d+$');

  static final RegExp _alphaSpace = RegExp(r'^[a-zA-Z\s]+$');

  static final RegExp _alphaNumeric = RegExp(r'^[a-zA-Z0-9]+$');

  static final RegExp _alphaNumericSpace = RegExp(r'^[a-zA-Z0-9\s]+$');

  static bool isEmail(String input) => _email.hasMatch(input);

  static bool isPhone(String input) => _phone.hasMatch(input);

  static bool isIp(String input) => _ip.hasMatch(input);

  static bool isAlphaSpace(String input) => _alphaSpace.hasMatch(input);

  static bool isAlphaNumeric(String input) => _alphaNumeric.hasMatch(input);

  static bool isAlphaNumericSpace(String input) =>
      _alphaNumericSpace.hasMatch(input);

  static bool regex(String input, RegExp pattern) => pattern.hasMatch(input);

  /// Whether [input] represents a whole number, or a decimal when
  /// [allowDecimal] is set.
  static bool isNumeric(String input, {bool allowDecimal = false}) {
    if (allowDecimal) {
      return _numericDecimal.hasMatch(input);
    }

    return _numericWhole.hasMatch(input);
  }

  /// Whether [input] is a valid URL. Localhost and bare IP hosts require an
  /// explicit protocol; named domains accept an optional one.
  static bool isUrl(String input) {
    return _localhostOrIpUrl.hasMatch(input) || _domainUrl.hasMatch(input);
  }
}
