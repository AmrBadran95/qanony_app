import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  static String handle(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case "email-already-in-use":
          return "هذا البريد الإلكتروني مستخدم بالفعل.";
        case "invalid-email":
          return "البريد الإلكتروني غير صالح.";
        case "weak-password":
          return "كلمة المرور ضعيفة. يجب أن تكون 6 أحرف على الأقل.";
        case "user-not-found":
          return "لا يوجد مستخدم بهذا البريد الإلكتروني.";
        case "wrong-password":
        case "invalid-credential":
          return "كلمة المرور غير صحيحة.";
        case "too-many-requests":
          return "عدد محاولات تسجيل الدخول كبير. الرجاء المحاولة لاحقًا.";
        case "network-request-failed":
          return "فشل في الاتصال بالإنترنت. تأكد من الشبكة.";
        case "internal-error":
          return "حدث خطأ داخلي. حاول مرة أخرى.";
        case "user-disabled":
          return "تم تعطيل هذا الحساب من قبل الإدارة.";
        default:
          return "حدث خطأ غير متوقع. حاول مرة أخرى.";
      }
    } else {
      return "حدث خطأ غير متوقع. حاول مرة أخرى.";
    }
  }
}
