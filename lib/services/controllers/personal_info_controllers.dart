import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      profileImage.value = pickedFile.path;
      state.didChange(pickedFile.path);
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
