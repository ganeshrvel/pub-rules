import 'package:meta/meta.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/functs.dart';

class RulesModel {
  String error;
  List<String> errorList;

  RulesModel({
    @required this.errorList,
  }) {
    if (isNullOrEmpty(errorList) || !isArrayIndexExists(0, errorList)) {
      error = null;
      errorList = errorList ?? [];

      return;
    }

    error = errorList[0];
  }
}
