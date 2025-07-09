import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qanony/services/controllers/bank_account_controller.dart';
import 'package:qanony/services/controllers/contact_controller.dart';
import 'package:qanony/services/controllers/lawyerment_controller.dart';
import 'package:qanony/services/controllers/personal_info_controllers.dart';

part 'lawyer_confirmation_state.dart';

class LawyerConfirmationCubit extends Cubit<LawyerConfirmationState> {
  LawyerConfirmationCubit() : super(LawyerConfirmationInitial());

  void validateAllForms({
    required bool agreedToTerms,
    required bool confirmedData,
  }) {
    final personalValid =
        PersonalInfoFormKey.formKey.currentState?.validate() ?? false;
    final lawyerValid =
        LawyermentInfoFormKey.formKey.currentState?.validate() ?? false;
    final bankValid =
        BankAccountFormKey.formKey.currentState?.validate() ?? false;
    final contactValid =
        ContactFormKey.formKey.currentState?.validate() ?? false;

    if (!confirmedData || !agreedToTerms) {
      emit(
        LawyerConfirmationValidationError(
          "يجب الموافقة على الشروط والإقرار بالبيانات",
        ),
      );
    } else if (!personalValid || !lawyerValid || !bankValid || !contactValid) {
      emit(
        LawyerConfirmationValidationError("تأكد من ملء جميع الحقول بشكل صحيح"),
      );
    } else {
      emit(LawyerConfirmationValidationSuccess());
    }
  }

  // void submitToFirebaseDemo() async {
  //   try {
  //     await Future.delayed(const Duration(seconds: 2));
  //     emit(LawyerConfirmationSubmitted());
  //   } catch (e) {
  //     emit(LawyerConfirmationSubmissionFailed("حدث خطأ أثناء الإرسال"));
  //   }
  // }
}
