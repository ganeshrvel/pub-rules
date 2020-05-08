import 'package:rules/src/rules.dart';

class ValidateRules {
  final List<Rules> rules;
  List<String> _errors;

  ValidateRules(this.rules);

  void run() {
    if (rules == null) {
      return;
    }

    for(final rule in rules){
      print(rule);
    }
  }
}
