import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/data/repos/stripe_connect_repo.dart';
import 'package:qanony/presentation/pages/multi_stepper_form.dart';
import 'package:qanony/presentation/screens/lawyer_connect.dart';
import 'package:qanony/services/controllers/lawyer_info_confirmation_controller.dart';
import 'package:qanony/services/cubits/connect/connect_cubit.dart';
import 'package:qanony/services/cubits/date_of_birth/date_of_birth_cubit.dart';
import 'package:qanony/services/cubits/lawyer_confirmation/lawyer_confirmation_cubit.dart';
import 'package:qanony/services/cubits/registration_date/registration_date_cubit.dart';
import 'package:qanony/services/cubits/stepper/multi_stepper_cubit.dart';

class LawyerInformation extends StatelessWidget {
  final String uid;
  final String email;
  final String phone;

  const LawyerInformation({
    super.key,
    required this.uid,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MultiStepperCubit()),
        BlocProvider(create: (_) => DateOfBirthCubit()),
        BlocProvider(create: (_) => RegistrationDateCubit()),
      ],
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => LawyerConfirmationCubit(
              uid: uid,
              email: email,
              phone: phone,
              dateOfBirthCubit: context.read<DateOfBirthCubit>(),
              registrationDateCubit: context.read<RegistrationDateCubit>(),
            ),
            child: Scaffold(
              body: SafeArea(
                child:
                    BlocConsumer<
                      LawyerConfirmationCubit,
                      LawyerConfirmationState
                    >(
                      listener: (context, state) {
                        if (state is LawyerConfirmationValidationError ||
                            state is LawyerConfirmationSubmissionFailed) {
                          final msg = state is LawyerConfirmationValidationError
                              ? state.message
                              : (state as LawyerConfirmationSubmissionFailed)
                                    .message;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                msg,
                                style: AppText.bodySmall.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                              backgroundColor: AppColor.grey,
                            ),
                          );
                        }

                        if (state is LawyerConfirmationSubmitted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => ConnectCubit(ConnectRepo()),
                                child: LawyerConnect(
                                  lawyerId: uid,
                                  email: email,
                                ),
                              ),
                            ),
                            (route) => false,
                          );
                        }

                        if (state is LawyerConfirmationValidationSuccess) {
                          Future.microtask(() {
                            DateTime? dob;
                            DateTime? regDate;

                            if (context.mounted) {
                              final dobState = context
                                  .read<DateOfBirthCubit>()
                                  .state;
                              if (dobState is DateOfBirthSelected) {
                                dob = dobState.selectedDate;
                              }
                              final regDateState = context
                                  .read<RegistrationDateCubit>()
                                  .state;
                              if (regDateState is RegistrationDateSelected) {
                                regDate = regDateState.selectedDate;
                              }
                              context
                                  .read<LawyerConfirmationCubit>()
                                  .submitLawyerData(
                                    uid: uid,
                                    email: email,
                                    phone: phone,
                                    dateOfBirth: dob,
                                    registrationDate: regDate,
                                  );
                            }
                          });
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is LawyerConfirmationLoading;

                        return Padding(
                          padding: AppPadding.verticalLarge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "المعلومات الشخصية",
                                    style: AppText.title.copyWith(
                                      color: AppColor.dark,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  const Icon(
                                    Icons.person,
                                    color: AppColor.dark,
                                    size: 40,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              const Expanded(child: MultiStepperForm()),
                              SizedBox(height: 10.h),
                              ValueListenableBuilder<bool>(
                                valueListenable:
                                    ConfirmationControllers.confirmedInfo,
                                builder: (_, value, _) {
                                  return CheckboxListTile(
                                    value: value,
                                    onChanged: (val) =>
                                        ConfirmationControllers
                                                .confirmedInfo
                                                .value =
                                            val ?? false,
                                    title: Text(
                                      "أقر أن البيانات السابقة صحيحة وأنا مسئول عنها.",
                                      style: AppText.bodySmall.copyWith(
                                        color: AppColor.dark,
                                      ),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: AppColor.green,
                                  );
                                },
                              ),

                              ValueListenableBuilder<bool>(
                                valueListenable:
                                    ConfirmationControllers.agreedToTerms,
                                builder: (_, value, _) {
                                  return CheckboxListTile(
                                    value: value,
                                    onChanged: (val) =>
                                        ConfirmationControllers
                                                .agreedToTerms
                                                .value =
                                            val ?? false,
                                    title: Text(
                                      "أوافق على الشروط والأحكام.",
                                      style: AppText.bodySmall.copyWith(
                                        color: AppColor.dark,
                                      ),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: AppColor.green,
                                  );
                                },
                              ),

                              Padding(
                                padding: AppPadding.horizontalLarge,
                                child: CustomButton(
                                  text: isLoading
                                      ? "جارٍ الإرسال..."
                                      : "تأكيد البيانات",
                                  onTap: () {
                                    if (isLoading) return;

                                    final confirmed = ConfirmationControllers
                                        .confirmedInfo
                                        .value;
                                    final agreed = ConfirmationControllers
                                        .agreedToTerms
                                        .value;

                                    context
                                        .read<LawyerConfirmationCubit>()
                                        .validateAllForms(
                                          agreedToTerms: agreed,
                                          confirmedData: confirmed,
                                        );
                                  },
                                  width: double.infinity,
                                  height: 60,
                                  backgroundColor: isLoading
                                      ? AppColor.grey
                                      : AppColor.secondary,
                                  textStyle: AppText.bodySmall.copyWith(
                                    color: AppColor.dark,
                                  ),
                                  textColor: AppColor.dark,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
