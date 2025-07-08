import 'package:flutter/material.dart';

class ContactControllers {
  static final callPriceController = TextEditingController();
  static final officePriceController = TextEditingController();

  static final callEnabled = ValueNotifier<bool>(false);
  static final officeEnabled = ValueNotifier<bool>(false);

  static void dispose() {
    callPriceController.dispose();
    officePriceController.dispose();
    callEnabled.dispose();
    officeEnabled.dispose();
  }
}

class ContactFormKey {
  static final formKey = GlobalKey<FormState>();
}
