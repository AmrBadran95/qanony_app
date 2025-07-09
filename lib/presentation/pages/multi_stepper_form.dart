import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/presentation/pages/bank_account_form.dart';
import 'package:qanony/presentation/pages/contact_form.dart';
import 'package:qanony/presentation/pages/lawyerment_info_form.dart';
import 'package:qanony/presentation/pages/personal_info_form.dart';
import 'package:qanony/services/cubits/stepper/multi_stepper_cubit.dart';

class MultiStepperForm extends StatelessWidget {
  const MultiStepperForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MultiStepperCubit, MultiStepperState>(
      listener: (context, state) {
        if (state is MultiStepperSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم إرسال البيانات بنجاح',
                style: AppText.title.copyWith(color: AppColor.light),
              ),
              backgroundColor: AppColor.green,
            ),
          );
        } else if (state is MultiStepperStepError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'يرجى تعبئة جميع الحقول المطلوبة',
                style: AppText.title.copyWith(color: AppColor.light),
              ),
              backgroundColor: AppColor.primary,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<MultiStepperCubit>();
        final currentStep = cubit.currentStep;
        final isLastStep = currentStep == cubit.formKeys.length - 1;

        return Stepper(
          type: StepperType.vertical,
          connectorColor: WidgetStateProperty.all(AppColor.dark),
          currentStep: currentStep,
          onStepTapped: (index) => cubit.goToStep(index),
          onStepContinue: cubit.nextStep,
          onStepCancel: cubit.backStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: AppPadding.verticalSmall,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!isLastStep)
                    CustomButton(
                      text: "متابعة",
                      onTap: details.onStepContinue ?? () {},
                      width: 120,
                      height: 50,
                      backgroundColor: AppColor.green,
                      textStyle: AppText.bodyLarge.copyWith(
                        color: AppColor.light,
                      ),
                    ),
                  if (currentStep > 0)
                    CustomButton(
                      text: "رجوع",
                      onTap: details.onStepCancel ?? () {},
                      width: 120,
                      height: 50,
                      backgroundColor: AppColor.primary,
                      textStyle: AppText.bodyLarge.copyWith(
                        color: AppColor.light,
                      ),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text('البيانات الشخصية'),
              content: const PersonalInfoForm(),
              isActive: currentStep >= 0,
              state: currentStep > 0
                  ? StepState.complete
                  : state is MultiStepperStepError && currentStep == 0
                  ? StepState.error
                  : StepState.indexed,
            ),
            Step(
              title: Text('بيانات المحاماة'),
              content: const LawyermentInfoForm(),
              isActive: currentStep >= 1,
              state: currentStep > 1
                  ? StepState.complete
                  : state is MultiStepperStepError && currentStep == 1
                  ? StepState.error
                  : StepState.indexed,
            ),
            Step(
              title: Text('بيانات الحساب البنكي'),
              content: const BankAccountForm(),
              isActive: currentStep >= 2,
              state: currentStep > 2
                  ? StepState.complete
                  : state is MultiStepperStepError && currentStep == 2
                  ? StepState.error
                  : StepState.indexed,
            ),
            Step(
              title: Text('طريفة التواصل'),
              content: const ContactForm(),
              isActive: currentStep >= 3,
              state: state is MultiStepperStepError && currentStep == 3
                  ? StepState.error
                  : StepState.indexed,
            ),
          ],
        );
      },
    );
  }
}
