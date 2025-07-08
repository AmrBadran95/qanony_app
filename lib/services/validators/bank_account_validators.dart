class BankAccountValidators {
  static String? validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'اسم البنك مطلوب';
    }
    return null;
  }

  static String? validateAccountHolder(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'اسم صاحب الحساب مطلوب';
    }
    return null;
  }

  static String? validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الحساب مطلوب';
    } else if (value.length < 6) {
      return 'رقم الحساب غير صحيح';
    }
    return null;
  }
}
