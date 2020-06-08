import 'dart:collection';

// check if the value is null or empty
bool isNullOrEmpty(dynamic x) {
  assert(x == null ||
      x is String ||
      x is List ||
      x is Map ||
      x is HashMap ||
      x is Set);

  if (x == null) {
    return true;
  }

  if (x is String) {
    return x.isEmpty;
  }

  if (x is List) {
    return x.isEmpty;
  }

  if (x is Map) {
    return x.isEmpty;
  }

  if (x is HashMap) {
    return x.isEmpty;
  }

  if (x is Set) {
    return x.isEmpty;
  }

  return true;
}

// check if the value is not null or not empty
bool isNotNullOrEmpty(dynamic x) {
  assert(x == null ||
      x is String ||
      x is List ||
      x is Map ||
      x is HashMap ||
      x is Set);

  if (x == null) {
    return false;
  }

  if (x is String) {
    return x.isNotEmpty;
  }

  if (x is List) {
    return x.isNotEmpty;
  }

  if (x is Map) {
    return x.isNotEmpty;
  }

  if (x is HashMap) {
    return x.isNotEmpty;
  }

  if (x is Set) {
    return x.isNotEmpty;
  }

  return false;
}

// check if the value is null
bool isNull(dynamic x) {
  return x == null;
}

// check if the value is not null
bool isNotNull(dynamic x) {
  return x != null;
}
