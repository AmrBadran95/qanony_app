import 'package:flutter/material.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';
import 'package:qanony/services/controllers/bank_account_controller.dart';
import 'package:qanony/services/validators/bank_account_validators.dart';

class BankAccountForm extends StatelessWidget {
  const BankAccountForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: BankAccountFormKey.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: BankAccountControllers.bankNameController,
            validator: BankAccountValidators.validateBankName,
            width: double.infinity,
            height: 60,
            label: "اسم البنك",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.text,
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: BankAccountControllers.accountHolderController,
            validator: BankAccountValidators.validateAccountHolder,
            width: double.infinity,
            height: 60,
            label: "اسم صاحب الحساب",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.name,
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: BankAccountControllers.accountNumberController,
            validator: BankAccountValidators.validateAccountNumber,
            width: double.infinity,
            height: 60,
            label: "رقم الحساب",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
