import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qanony/services/auth/auth_service.dart';
import 'package:qanony/services/helpers/cloudinary_service.dart';

class PersonalInfoControllers {
  static final fullNameController = TextEditingController();
  static final nationalIdController = TextEditingController();
  static final fullAddressController = TextEditingController();

  static final governorate = ValueNotifier<String?>(null);
  static final gender = ValueNotifier<String?>(null);
  static final profileImage = ValueNotifier<String?>(null);

  static Future<void> pickProfileImage({
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
          type: 'profile',
          userId: userId,
        );
        profileImage.value = imageUrl;
        state.didChange(imageUrl);
      } catch (e) {
        state.didChange(null);
        debugPrint("خطأ في رفع الصورة: $e");
      }
    }
  }

  static void dispose() {
    fullNameController.dispose();
    nationalIdController.dispose();
    fullAddressController.dispose();
    governorate.dispose();
    gender.dispose();
    profileImage.dispose();
  }
}

class PersonalInfoFormKey {
  static final formKey = GlobalKey<FormState>();
}
