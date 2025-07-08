import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qanony/services/controllers/bank_account_controller.dart';
import 'package:qanony/services/controllers/contact_controller.dart';
import 'package:qanony/services/controllers/lawyerment_controller.dart';
import 'package:qanony/services/controllers/personal_info_controllers.dart';

part 'multi_stepper_state.dart';

class MultiStepperCubit extends Cubit<MultiStepperState> {
  MultiStepperCubit() : super(MultiStepperInitial());

  int currentStep = 0;

  final formKeys = [
    PersonalInfoFormKey.formKey,
    LawyermentInfoFormKey.formKey,
    BankAccountFormKey.formKey,
    ContactFormKey.formKey,
  ];

  void nextStep() {
    final currentFormKey = formKeys[currentStep];

    if (currentFormKey.currentState?.validate() ?? false) {
      if (currentStep < formKeys.length - 1) {
        currentStep++;
        emit(MultiStepperStepChanged(currentStep));
      } else {
        emit(MultiStepperSubmitted());
      }
    } else {
      emit(MultiStepperStepError(currentStep));
    }
  }

  void backStep() {
    if (currentStep > 0) {
      currentStep--;
      emit(MultiStepperStepChanged(currentStep));
    }
  }

  void goToStep(int stepIndex) {
    final currentFormKey = formKeys[currentStep];
    final isValid = currentFormKey.currentState?.validate() ?? false;

    if (!isValid) {
      emit(MultiStepperStepError(currentStep));
      return;
    }

    if (stepIndex >= 0 && stepIndex < formKeys.length) {
      currentStep = stepIndex;
      emit(MultiStepperStepChanged(currentStep));
    }
  }

  void resetStepper() {
    currentStep = 0;
    emit(MultiStepperInitial());
  }

  void disposeControllers() {
    PersonalInfoControllers.dispose();
    LawyermentInfoControllers.dispose();
    BankAccountControllers.dispose();
    ContactControllers.dispose();
  }
}
