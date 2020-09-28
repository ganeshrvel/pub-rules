class RuleOptions {
  /// Removes any leading and trailing whitespace
  bool trim;

  /// Converts all characters to lower case.
  bool lowerCase;

  /// Converts all characters to upper case.
  bool upperCase;

  // Extend [RuleOptions]
  RuleOptions copyWith({
    bool trim,
    bool lowerCase,
    bool upperCase,
  }) {
    return RuleOptions(
      trim: this.trim,
      lowerCase: this.lowerCase,
      upperCase: this.upperCase,
    );
  }

  RuleOptions({
    this.trim,
    this.lowerCase,
    this.upperCase,
  }) {
    trim = trim ?? false;
    lowerCase = lowerCase ?? false;
    upperCase = upperCase ?? false;

    if(lowerCase && upperCase){
      throw "Both 'lowerCase' and 'upperCase' in the rule options cannot be true";
    }
  }
}
