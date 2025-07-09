import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LawyermentInfoControllers {
  static final aboutMeController = TextEditingController();
  static final registrationNumberController = TextEditingController();
  static final specializationController = TextEditingController();
  static final cardImage = ValueNotifier<String?>(null);

  static Future<void> pickProfileImage({
    required ImageSource source,
    required FormFieldState<String> state,
    required dynamic profileImage,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImage.value = pickedFile.path;
      state.didChange(pickedFile.path);
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
