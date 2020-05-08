import 'package:rules/rules.dart';

void main() {
  const _name = 'd';

  final _nameRule =
      Rules(_name, name: 'Name', isRequired: true, customErrorTexts: {});

  print(_nameRule.run().errorList);

  //final _validareObj = ValidateRules([_nameRule]);

  /*print(_validareObj.run());
  print(_validareObj.gerErrors());*/
}
