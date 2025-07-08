import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/presentation/pages/multi_stepper_form.dart';
import 'package:qanony/presentation/screens/waiting_page.dart';
import 'package:qanony/services/controllers/lawyer_info_confirmation_controller.dart';
import 'package:qanony/services/cubits/lawyer_confirmation/lawyer_confirmation_cubit.dart';
import 'package:qanony/services/cubits/stepper/multi_stepper_cubit.dart';

class LawyerInformation extends StatelessWidget {
  const LawyerInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MultiStepperCubit()),
        BlocProvider(create: (context) => LawyerConfirmationCubit()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<LawyerConfirmationCubit, LawyerConfirmationState>(
            listener: (context, state) {
              if (state is LawyerConfirmationValidationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: AppText.bodyLarge.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                    backgroundColor: AppColor.grey,
                  ),
                );
              } else if (state is LawyerConfirmationValidationSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => WaitingPage(),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Padding(
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .01,
                        ),
                        const Icon(
                          Icons.person,
                          color: AppColor.dark,
                          size: 40,
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .01),

                    const Expanded(child: MultiStepperForm()),

                    SizedBox(height: MediaQuery.of(context).size.height * .01),
                    ValueListenableBuilder<bool>(
                      valueListenable: ConfirmationControllers.confirmedInfo,
                      builder: (context, value, _) {
                        return CheckboxListTile(
                          value: value,
                          onChanged: (val) =>
                              ConfirmationControllers.confirmedInfo.value =
                                  val ?? false,
                          title: Text(
                            "أقر أن البيانات السابقة صحيحة وأنا مسئول عنها",
                            style: AppText.bodyMedium.copyWith(
                              color: AppColor.dark,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColor.green,
                        );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .01),
                    ValueListenableBuilder<bool>(
                      valueListenable: ConfirmationControllers.agreedToTerms,
                      builder: (context, value, _) {
                        return CheckboxListTile(
                          value: value,
                          onChanged: (val) =>
                              ConfirmationControllers.agreedToTerms.value =
                                  val ?? false,
                          title: Text(
                            "أوافق على الشروط والأحكام",
                            style: AppText.bodyMedium.copyWith(
                              color: AppColor.dark,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColor.green,
                        );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .01),
                    CustomButton(
                      text: "تأكيد البيانات",
                      onTap: () {
                        final confirmedData =
                            ConfirmationControllers.confirmedInfo.value;
                        final agreedToTerms =
                            ConfirmationControllers.agreedToTerms.value;

                        context
                            .read<LawyerConfirmationCubit>()
                            .validateAllForms(
                              agreedToTerms: agreedToTerms,
                              confirmedData: confirmedData,
                            );
                      },
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      backgroundColor: AppColor.secondary,
                      textStyle: AppText.bodyLarge.copyWith(
                        color: AppColor.dark,
                      ),
                      textColor: AppColor.dark,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
