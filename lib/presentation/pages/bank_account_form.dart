import 'package:flutter/cupertino.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';

class BankAccountForm extends StatelessWidget {
  const BankAccountForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "اسم البنك",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "اسم صاحب الحساب",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "رقم الحساب",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
