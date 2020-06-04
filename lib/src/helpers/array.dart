bool inArray(List array, dynamic x) {
  return array.contains(x);
}

bool isArrayIndexExists(int x, List<dynamic> array) {
  return array.isNotEmpty && x >= array.length - 1;
}

bool isValuesNull(List<dynamic> valueList) {
  for (final val in valueList) {
    if (val == null) {
      return true;
    }
  }

  return false;
}

bool isValuesNotNull(List<dynamic> valueList) {
  for (final val in valueList) {
    if (val != null) {
      return true;
    }
  }

  return false;
}

List<String> getNullValues(Map<String, dynamic> valueList) {
  final _returnList = <String>[];

  for (final value in valueList.entries) {
    if (value.value == null) {
      _returnList.add(value.key);
    }
  }

  return _returnList;
}

List<double> getParsedDoubleArray(List<String> valueList) {
  return valueList.map((value) => double.tryParse(value)).toList();
}
