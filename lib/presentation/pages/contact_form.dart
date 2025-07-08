import 'package:flutter/material.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Checkbox(
                value: false,
                onChanged: null,
                activeColor: AppColor.green,
              ),
              const SizedBox(width: 8),
              Text(
                "مكالمة صوتية / فيديو",
                style: AppText.bodyLarge.copyWith(color: AppColor.dark),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            label: "سعر الجلسة",
            backgroundColor: AppColor.grey,
            contentPadding: AppPadding.paddingMedium,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Checkbox(
                value: false,
                onChanged: null,
                activeColor: AppColor.green,
              ),
              const SizedBox(width: 8),
              Text(
                "حجز في المكتب",
                style: AppText.bodyLarge.copyWith(color: AppColor.dark),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            label: "سعر الجلسة",
            backgroundColor: AppColor.grey,
            contentPadding: AppPadding.paddingMedium,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
