class PersonalInfoValidators {
  static String? validateFullName(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty || value == "الاسم رباعي") {
      return 'الاسم مطلوب';
    }

    final words = trimmed.split(' ');
    if (words.length < 4) {
      return 'من فضلك أدخل الاسم رباعي';
    }

    return null;
  }

  static String? validateNationalId(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty || value == "الرقم القومي") {
      return 'الرقم القومي مطلوب';
    }

    final arabicNumberRegex = RegExp(r'^[\d\u0660-\u0669]{14}$');
    if (!arabicNumberRegex.hasMatch(trimmed)) {
      return 'الرقم القومي يجب أن يكون 14 رقمًا';
    }

    return null;
  }

  static String? validateGovernorate(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty || value == "المحافظة") {
      return 'من فضلك اختر المحافظة';
    }
    return null;
  }

  static String? validateFullAddress(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty || trimmed == "العنوان بالكامل") {
      return 'العنوان مطلوب';
    }

    if (trimmed.length < 10) {
      return 'يرجى كتابة عنوان أوضح (10 أحرف على الأقل)';
    }

    return null;
  }

  static String? validateBirthDate(DateTime? date) {
    if (date == null) {
      return 'من فضلك اختر تاريخ الميلاد';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء اختيار النوع';
    }
    return null;
  }

  static String? validateProfileImage(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء اختيار صورة شخصية';
    }
    return null;
  }
}
