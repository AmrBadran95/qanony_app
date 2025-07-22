class ContactValidators {
  static String? validateSessionPrice(String? value, bool isEnabled) {
    if (!isEnabled) return null;

    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return 'يرجى إدخال سعر الجلسة';
    }

    final priceRegex = RegExp(r'^[\d\u0660-\u0669]+(\.[\d\u0660-\u0669]+)?$');

    if (!priceRegex.hasMatch(trimmed)) {
      return 'يرجى إدخال رقم صحيح أو عشري';
    }

    final converted = convertArabicNumbersToEnglish(trimmed);

    final parsed = double.tryParse(converted);
    if (parsed == null || parsed <= 0) {
      return 'أدخل رقمًا أكبر من صفر';
    }

    return null;
  }

  static String convertArabicNumbersToEnglish(String input) {
    const arabicNums = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishNums = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabicNums.length; i++) {
      input = input.replaceAll(arabicNums[i], englishNums[i]);
    }
    return input;
  }
}
