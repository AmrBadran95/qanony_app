class LawyermentInfoValidators {
  static String? validateAboutMe(String? value) {
    if (value == null || value.trim().isEmpty) return "يرجى كتابة نبذة عنك";
    return null;
  }

  static String? validateRegistrationNumber(String? value) {
    if (value == null || value.isEmpty) return "رقم القيد مطلوب";
    return null;
  }

  static String? validateRegistrationDate(DateTime? date) {
    if (date == null) {
      return "يرجى اختيار تاريخ القيد";
    }
    return null;
  }

  static String? validateSpecialization(String? value) {
    if (value == null || value.trim().isEmpty) return "يرجى كتابة التخصص";
    return null;
  }

  static String? validateCardImage(String? path) {
    if (path == null || path.isEmpty) return "يرجى تحميل صورة الكارنيه";
    return null;
  }
}
