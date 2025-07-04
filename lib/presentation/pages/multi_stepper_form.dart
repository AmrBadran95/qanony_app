import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/presentation/pages/bank_account_form.dart';
import 'package:qanony/presentation/pages/contact_form.dart';
import 'package:qanony/presentation/pages/lawyerment_info_form.dart';
import 'package:qanony/presentation/pages/personal_info_form.dart';

class MultiStepperForm extends StatelessWidget {
  const MultiStepperForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.vertical,
      currentStep: 1,
      connectorColor: WidgetStateProperty.all(AppColor.dark),
      onStepContinue: () {},
      onStepCancel: () {},
      controlsBuilder: (context, details) {
        return Padding(
          padding: AppPadding.verticalSmall,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                text: "متابعة",
                onTap: details.onStepContinue ?? () {},
                width: 120,
                height: 50,
                backgroundColor: AppColor.green,
                textStyle: AppText.bodyLarge.copyWith(color: AppColor.light),
              ),
              const SizedBox(width: 16),
              CustomButton(
                text: "رجوع",
                onTap: details.onStepCancel ?? () {},
                width: 120,
                height: 50,
                backgroundColor: AppColor.primary,
                textStyle: AppText.bodyLarge.copyWith(color: AppColor.light),
              ),
            ],
          ),
        );
      },
      steps: const [
        Step(
          title: Text('البيانات الشخصية'),
          content: PersonalInfoForm(),
          isActive: true,
          state: StepState.complete,
        ),
        Step(
          title: Text('بيانات المحاماة'),
          content: LawyermentInfoForm(),
          isActive: true,
          state: StepState.editing,
        ),
        Step(
          title: Text('بيانات الحساب البنكي'),
          content: BankAccountForm(),
          isActive: true,
          state: StepState.editing,
        ),
        Step(
          title: Text('طريفة التواصل'),
          content: ContactForm(),
          isActive: true,
          state: StepState.error,
        ),
      ],
    );
  }
}
