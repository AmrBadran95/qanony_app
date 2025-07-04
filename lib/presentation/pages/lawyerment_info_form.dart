import 'package:flutter/material.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/core/widgets/custom_calendar.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';

class LawyermentInfoForm extends StatelessWidget {
  const LawyermentInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            width: double.infinity,
            height: 100,
            hintText: "نبذة عني",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "رقم القيد بنقابة المحامين",
            keyboardType: TextInputType.number,
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          const CustomCalendar(label: "تاريخ القيد"),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
            width: double.infinity,
            height: 60,
            hintText: "التخصص",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            hintStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Center(
            child: CustomButton(
              text: "صورة كارنية النقابة",
              onTap: () {},
              width: MediaQuery.of(context).size.width * 0.5,
              height: 50,
              backgroundColor: AppColor.secondary,
              textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            ),
          ),
        ],
      ),
    );
  }
}
