// check if the [inputType] is matching with [typeList]
bool isTypesEqual(Type inputType, List<Type> typeList) {
  for (final type in typeList) {
    if (type == inputType) {
      return true;
    }
  }

  return false;
}
