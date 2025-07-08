import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qanony/Core/widgets/custom_calendar.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';
import 'package:qanony/services/controllers/calendar_controller.dart';
import 'package:qanony/services/controllers/lawyerment_controller.dart';
import 'package:qanony/services/cubits/calendar/calendar_cubit.dart';
import 'package:qanony/services/validators/lawyerment_info_validators.dart';

class LawyermentInfoForm extends StatelessWidget {
  const LawyermentInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: LawyermentInfoFormKey.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: LawyermentInfoControllers.aboutMeController,
            validator: LawyermentInfoValidators.validateAboutMe,
            width: double.infinity,
            height: 100,
            label: "نبذة عني",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            maxLines: 3,
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: LawyermentInfoControllers.registrationNumberController,
            validator: LawyermentInfoValidators.validateRegistrationNumber,
            width: double.infinity,
            height: 60,
            label: "رقم القيد بنقابة المحامين",
            keyboardType: TextInputType.number,
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          BlocProvider(
            create: (context) => CalendarCubit(),
            child: Builder(
              builder: (context) {
                return FormField<DateTime>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final selectedDate = CalendarController.getSelectedDate(
                      context.read<CalendarCubit>().state,
                    );
                    return LawyermentInfoValidators.validateRegistrationDate(
                      selectedDate,
                    );
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<CalendarCubit, CalendarState>(
                          builder: (context, calendarState) {
                            final selectedDate =
                                CalendarController.getSelectedDate(
                                  calendarState,
                                );
                            return CustomCalendar(
                              label: "تاريخ القيد",
                              prevOnly: true,
                              selectedDate: selectedDate,
                              onDateSelected: (date) {
                                CalendarController.updateDate(context, date);
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  state.didChange(date);
                                });
                              },
                            );
                          },
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              state.errorText!,
                              style: AppText.bodySmall.copyWith(
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: LawyermentInfoControllers.specializationController,
            validator: LawyermentInfoValidators.validateSpecialization,
            width: double.infinity,
            height: 60,
            label: "التخصص",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          Center(
            child: FormField<String>(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) => LawyermentInfoValidators.validateCardImage(
                LawyermentInfoControllers.cardImage.value,
              ),
              builder: (state) {
                return ValueListenableBuilder<String?>(
                  valueListenable: LawyermentInfoControllers.cardImage,
                  builder: (context, value, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CustomButton(
                            text: "صورة كارنيه النقابة",
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 60,
                            backgroundColor: AppColor.secondary,
                            textStyle: AppText.bodyLarge.copyWith(
                              color: AppColor.dark,
                            ),
                            textColor: AppColor.dark,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                builder: (_) => Padding(
                                  padding: AppPadding.paddingExtraLarge,
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                          Icons.photo_library,
                                          color: AppColor.secondary,
                                        ),
                                        title: Text(
                                          "اختيار من المعرض",
                                          style: AppText.bodyLarge.copyWith(
                                            color: AppColor.dark,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          LawyermentInfoControllers.pickProfileImage(
                                            source: ImageSource.gallery,
                                            state: state,
                                            profileImage:
                                                LawyermentInfoControllers
                                                    .cardImage,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.camera_alt,
                                          color: AppColor.secondary,
                                        ),
                                        title: Text(
                                          "استخدام الكاميرا",
                                          style: AppText.bodyLarge.copyWith(
                                            color: AppColor.dark,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          LawyermentInfoControllers.pickProfileImage(
                                            source: ImageSource.camera,
                                            state: state,
                                            profileImage:
                                                LawyermentInfoControllers
                                                    .cardImage,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (value != null) ...[
                          Text(
                            value,
                            style: AppText.bodySmall.copyWith(
                              color: AppColor.dark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(value),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                        if (state.hasError)
                          Text(
                            state.errorText!,
                            style: AppText.bodySmall.copyWith(
                              color: AppColor.primary,
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
