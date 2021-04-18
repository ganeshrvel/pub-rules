import 'package:rules/src/helpers/functs.dart';

// check if a value is present in an array
bool inArray(List array, dynamic x) {
  return array.contains(x);
}

// return true if any value is found null
bool isNullExists(
  List<dynamic> list, {
  bool isEmpty = false,
}) =>
    list.indexWhere((v) => isEmpty ? isNullOrEmpty(v) : (v == null)) != -1;

// return true if any value is found not null
bool isNotNullExists(List<dynamic> list) =>
    list.indexWhere((v) => v != null) != -1;

// parse [string] values in the array to [double]
List<double?> getParsedDoubleArray(List<String> valueList) {
  return valueList.map((value) => double.tryParse(value)).toList();
}
