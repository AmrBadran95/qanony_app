import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qanony/data/models/lawyer_model.dart';
import 'package:qanony/services/controllers/bank_account_controller.dart';
import 'package:qanony/services/controllers/contact_controller.dart';
import 'package:qanony/services/controllers/lawyerment_controller.dart';
import 'package:qanony/services/controllers/personal_info_controllers.dart';
import 'package:qanony/services/cubits/date_of_birth/date_of_birth_cubit.dart';
import 'package:qanony/services/cubits/registration_date/registration_date_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';

part 'lawyer_confirmation_state.dart';

class LawyerConfirmationCubit extends Cubit<LawyerConfirmationState> {
  final String uid;
  final String email;
  final String phone;
  final DateOfBirthCubit dateOfBirthCubit;
  final RegistrationDateCubit registrationDateCubit;

  LawyerConfirmationCubit({
    required this.uid,
    required this.email,
    required this.phone,
    required this.dateOfBirthCubit,
    required this.registrationDateCubit,
  }) : super(LawyerConfirmationInitial());

  void validateAllForms({
    required bool agreedToTerms,
    required bool confirmedData,
  }) {
    PersonalInfoFormKey.formKey.currentState?.save();
    LawyermentInfoFormKey.formKey.currentState?.save();
    BankAccountFormKey.formKey.currentState?.save();
    ContactFormKey.formKey.currentState?.save();

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

  Future<void> submitLawyerData({
    required String uid,
    required String email,
    required String phone,
    required DateTime? dateOfBirth,
    required DateTime? registrationDate,
  }) async {
    emit(LawyerConfirmationLoading());

    try {
      final lawyer = LawyerModel(
        uid: uid,
        email: email,
        phone: phone,
        fullName: PersonalInfoControllers.fullNameController.text,
        nationalId: PersonalInfoControllers.nationalIdController.text.trim(),
        governorate: PersonalInfoControllers.governorate.value,
        address: PersonalInfoControllers.fullAddressController.text,
        dateOfBirth: dateOfBirth,
        gender: PersonalInfoControllers.gender.value,
        profilePictureUrl: PersonalInfoControllers.profileImage.value,
        bio: LawyermentInfoControllers.aboutMeController.text,
        registrationNumber: LawyermentInfoControllers
            .registrationNumberController
            .text
            .trim(),
        registrationDate: registrationDate,
        specialty: LawyermentInfoControllers.specializationList.value,
        cardImageUrl: LawyermentInfoControllers.cardImage.value,
        bankName: BankAccountControllers.bankNameController.text,
        accountHolderName: BankAccountControllers.accountHolderController.text,
        accountNumber: BankAccountControllers.accountNumberController.text
            .trim(),
        offersCall: ContactControllers.callEnabled.value,
        callPrice: double.tryParse(
          ContactControllers.callPriceController.text.trim(),
        ),
        offersOffice: ContactControllers.officeEnabled.value,
        officePrice: double.tryParse(
          ContactControllers.officePriceController.text.trim(),
        ),
        subscriptionType: 'free',
        subscriptionStart: DateTime.now(),
        subscriptionEnd: DateTime.now().add(Duration(days: 30)),
      );

      await LawyerFirestoreService().createLawyer(lawyer);

      emit(LawyerConfirmationSubmitted());
    } catch (e) {
      emit(LawyerConfirmationSubmissionFailed("حدث خطأ أثناء إرسال البيانات"));
    }
  }
}
