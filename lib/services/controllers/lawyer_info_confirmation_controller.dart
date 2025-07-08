import 'package:flutter/material.dart';

class ConfirmationControllers {
  static final agreedToTerms = ValueNotifier<bool>(false);
  static final confirmedInfo = ValueNotifier<bool>(false);

  static void dispose() {
    agreedToTerms.dispose();
    confirmedInfo.dispose();
  }
}
