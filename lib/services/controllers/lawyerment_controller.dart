import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qanony/services/auth/auth_service.dart';
import 'package:qanony/services/helpers/cloudinary_service.dart';

class LawyermentInfoControllers {
  static final aboutMeController = TextEditingController();
  static final registrationNumberController = TextEditingController();
  static final specializationController = TextEditingController();

  static final cardImage = ValueNotifier<String?>(null);

  static Future<void> pickCardImage({
    required ImageSource source,
    required FormFieldState<String> state,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final userId = AuthService().currentUser?.uid;

      if (userId == null) {
        state.didChange(null);
        debugPrint("لا يوجد مستخدم مسجل حاليًا");
        return;
      }

      try {
        final imageUrl = await CloudinaryService().uploadImage(
          file: imageFile,
          type: 'card',
          userId: userId,
        );
        cardImage.value = imageUrl;
        state.didChange(imageUrl);
      } catch (e) {
        state.didChange(null);
        debugPrint("خطأ في رفع كارت المحامي: $e");
      }
    }
  }

  static void dispose() {
    aboutMeController.dispose();
    registrationNumberController.dispose();
    specializationController.dispose();
    cardImage.dispose();
  }
}

class LawyermentInfoFormKey {
  static final formKey = GlobalKey<FormState>();
}
