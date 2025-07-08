import 'package:flutter/material.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';
import 'package:qanony/services/controllers/contact_controller.dart';
import 'package:qanony/services/validators/contact_validators.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: ContactFormKey.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),

          ValueListenableBuilder<bool>(
            valueListenable: ContactControllers.callEnabled,
            builder: (context, isChecked, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) =>
                            ContactControllers.callEnabled.value = value!,
                        activeColor: AppColor.green,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Text(
                        "مكالمة صوتية / فيديو",
                        style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                      ),
                    ],
                  ),
                  if (isChecked) ...[
                    CustomTextFormField(
                      controller: ContactControllers.callPriceController,
                      validator: (value) =>
                          ContactValidators.validateSessionPrice(
                            value,
                            isChecked,
                          ),
                      width: double.infinity,
                      height: 60,
                      label: "سعر الجلسة",
                      backgroundColor: AppColor.grey,
                      contentPadding: AppPadding.paddingMedium,
                      textStyle: AppText.bodyLarge.copyWith(
                        color: AppColor.dark,
                      ),
                      labelStyle: AppText.bodyLarge.copyWith(
                        color: AppColor.dark,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  ],
                ],
              );
            },
          ),

          ValueListenableBuilder<bool>(
            valueListenable: ContactControllers.officeEnabled,
            builder: (context, isChecked, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) =>
                            ContactControllers.officeEnabled.value = value!,
                        activeColor: AppColor.green,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Text(
                        "حجز في المكتب",
                        style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                      ),
                    ],
                  ),
                  if (isChecked) ...[
                    CustomTextFormField(
                      controller: ContactControllers.officePriceController,
                      validator: (value) =>
                          ContactValidators.validateSessionPrice(
                            value,
                            isChecked,
                          ),
                      width: double.infinity,
                      height: 60,
                      label: "سعر الجلسة",
                      backgroundColor: AppColor.grey,
                      contentPadding: AppPadding.paddingMedium,
                      textStyle: AppText.bodyLarge.copyWith(
                        color: AppColor.dark,
                      ),
                      labelStyle: AppText.bodyLarge.copyWith(
                        color: AppColor.dark,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
