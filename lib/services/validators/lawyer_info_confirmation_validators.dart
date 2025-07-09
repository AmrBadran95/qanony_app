class ConfirmationValidators {
  static String? validateCheckbox(bool value, String message) {
    if (!value) return message;
    return null;
  }
}
