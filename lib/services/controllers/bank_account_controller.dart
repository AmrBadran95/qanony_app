import 'package:flutter/material.dart';

class BankAccountControllers {
  static final bankNameController = TextEditingController();
  static final accountHolderController = TextEditingController();
  static final accountNumberController = TextEditingController();

  static void dispose() {
    bankNameController.dispose();
    accountHolderController.dispose();
    accountNumberController.dispose();
  }
}

class BankAccountFormKey {
  static final formKey = GlobalKey<FormState>();
}
