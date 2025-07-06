import 'package:flutter/material.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/presentation/pages/multi_stepper_form.dart';

class LawyerInformation extends StatelessWidget {
  const LawyerInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.paddingSmall,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "المعلومات الشخصية",
                    style: AppText.title.copyWith(color: AppColor.dark),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .01),
                  const Icon(Icons.person, color: AppColor.dark, size: 40),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              const MultiStepperForm(),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Row(
                children: [
                  const Checkbox(
                    value: false,
                    onChanged: null,
                    activeColor: AppColor.green,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .01),
                  Expanded(
                    child: Text(
                      "أقر أن البيانات السابقة صحيحة وأنا مسئول عنها",
                      style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Row(
                children: [
                  const Checkbox(
                    value: false,
                    onChanged: null,
                    activeColor: AppColor.green,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .01),
                  Expanded(
                    child: Text(
                      "أوافق على الشروط والأحكام",
                      style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              CustomButton(
                text: "تأكيد البيانات",
                onTap: () {},
                width: MediaQuery.of(context).size.width,
                height: 60,
                backgroundColor: AppColor.primary,
                textStyle: AppText.bodyLarge.copyWith(color: AppColor.light),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
