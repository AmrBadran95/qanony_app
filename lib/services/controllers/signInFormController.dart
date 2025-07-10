import 'package:flutter/material.dart';

class SignInControllers {
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  static void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
class SignFormKey {
  static final formKey = GlobalKey<FormState>();
}
