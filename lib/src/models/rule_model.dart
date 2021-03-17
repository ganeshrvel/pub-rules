import 'package:rules/src/helpers/functs.dart';

// rules model
class RuleModel {
  String? error;
  List<String> errorList;

  RuleModel({
    required this.errorList,
  }) {
    if (isNotNullOrEmpty(errorList)) {
      error = errorList[0];
      return;
    }

    error = null;
    errorList = errorList;
  }
}
