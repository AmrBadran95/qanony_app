import 'package:flutter/cupertino.dart';

class SignUpControllers {
  static final emailController = TextEditingController();
  static final phoneController = TextEditingController();
  static final passwordController = TextEditingController();
  static final confirmPasswordController = TextEditingController();

  static void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

class SignUpFormKey {
  static final formKey = GlobalKey<FormState>();
}