class Validation {
  final bool? isNameValid;
  final bool? isSalaryValid;

  Validation({required this.isNameValid, required this.isSalaryValid});

  bool isValid() {
    return ((isNameValid ?? true) && (isSalaryValid ?? true));
  }
}
