import 'package:meta/meta.dart';
import 'package:rules/src/helpers/array.dart';
import 'package:rules/src/helpers/functs.dart';

// rules model
class RulesModel {
  String error;
  List<String> errorList;

  RulesModel({
    @required this.errorList,
  }) {
    if (isNotNullOrEmpty(errorList) && isArrayIndexExists(errorList, 0)) {
      error = errorList[0];

      return;
    }

    error = null;
    errorList = errorList ?? [];
  }
}
