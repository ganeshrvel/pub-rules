import 'package:rules/src/helpers/functs.dart';

// check if a value is present in an array
bool inArray(List array, dynamic x) {
  return array.contains(x);
}

// check if an index is present in an array
bool isArrayIndexExists(List<dynamic> array, int x) {
  return array.isNotEmpty && x >= array.length - 1;
}

// return true if any value is found null
bool isNullExists(
  List<dynamic> valueList, {
  bool isEmpty = false,
}) {
  for (final val in valueList) {
    if (isEmpty) {
      if (isNullOrEmpty(val)) {
        return true;
      }
    } else if (val == null) {
      return true;
    }
  }

  return false;
}

// return true if any value is found not null
bool isNotNullExists(
  List<dynamic> valueList, {
  bool isEmpty = false,
}) {
  for (final val in valueList) {
    if (isEmpty) {
      if (isNotNullOrEmpty(val)) {
        return true;
      }
    } else if (val != null) {
      return true;
    }
  }

  return false;
}

// return all the null values in the array
List<String> getNullValues(Map<String, dynamic> valueList) {
  final _returnList = <String>[];

  for (final value in valueList.entries) {
    if (value.value == null) {
      _returnList.add(value.key);
    }
  }

  return _returnList;
}

// parse [string] values in the array to [double]
List<double> getParsedDoubleArray(List<String> valueList) {
  return valueList.map((value) => double.tryParse(value)).toList();
}
