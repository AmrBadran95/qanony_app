import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/core/widgets/custom_calendar.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "الاسم رباعي",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "الرقم القومي",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "المحافظة",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "العنوان بالكامل",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          const CustomCalendar(),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Text(
            "النوع",
            style: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  title: Text(
                    "ذكر",
                    style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                  ),
                  value: "male",
                  groupValue: "none",
                  onChanged: null,
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text(
                    "أنثى",
                    style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                  ),
                  value: "female",
                  groupValue: "none",
                  onChanged: null,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Center(
            child: CustomButton(
              text: "أضف صورة شخصية",
              onTap: () {},
              width: MediaQuery.of(context).size.width * .5,
              height: 60,
              backgroundColor: AppColor.secondary,
              textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            ),
          ),
        ],
      ),
    );
  }
}
