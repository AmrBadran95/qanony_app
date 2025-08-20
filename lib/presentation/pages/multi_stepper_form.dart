import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
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
                style: AppText.bodySmall.copyWith(color: AppColor.green),
              ),
              backgroundColor: AppColor.grey,
            ),
          );
        } else if (state is MultiStepperStepError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'يرجى تعبئة جميع الحقول المطلوبة',
                style: AppText.bodySmall.copyWith(color: AppColor.error),
              ),
              backgroundColor: AppColor.grey,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLastStep)
                    CustomButton(
                      text: "متابعة",
                      onTap: details.onStepContinue ?? () {},
                      width: 120.w,
                      height: 50.h,
                      backgroundColor: AppColor.green,
                      textStyle: AppText.bodySmall.copyWith(
                        color: AppColor.light,
                      ),
                    ),
                  SizedBox(width: 24.sp),
                  if (currentStep > 0)
                    CustomButton(
                      text: "رجوع",
                      onTap: details.onStepCancel ?? () {},
                      width: 120.w,
                      height: 50.h,
                      backgroundColor: AppColor.error,
                      textStyle: AppText.bodySmall.copyWith(
                        color: AppColor.light,
                      ),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text(
                'البيانات الشخصية',
                style: AppText.bodyMedium.copyWith(color: AppColor.dark),
              ),
              content: const PersonalInfoForm(),
              isActive: currentStep >= 0,
              state: currentStep > 0
                  ? StepState.complete
                  : state is MultiStepperStepError && currentStep == 0
                  ? StepState.error
                  : StepState.indexed,
            ),
            Step(
              title: Text(
                'بيانات المحاماة',
                style: AppText.bodyMedium.copyWith(color: AppColor.dark),
              ),
              content: const LawyermentInfoForm(),
              isActive: currentStep >= 1,
              state: currentStep > 1
                  ? StepState.complete
                  : state is MultiStepperStepError && currentStep == 1
                  ? StepState.error
                  : StepState.indexed,
            ),
            Step(
              title: Text(
                'طريقة التواصل',
                style: AppText.bodyMedium.copyWith(color: AppColor.dark),
              ),
              content: const ContactForm(),
              isActive: currentStep >= 2,
              state: state is MultiStepperStepError && currentStep == 2
                  ? StepState.error
                  : StepState.indexed,
            ),
          ],
        );
      },
    );
  }
}
