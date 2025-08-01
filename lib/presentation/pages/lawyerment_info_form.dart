import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qanony/Core/widgets/custom_calendar.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';
import 'package:qanony/data/static/lawyer_specializations.dart';
import 'package:qanony/services/controllers/lawyerment_controller.dart';
import 'package:qanony/services/cubits/registration_date/registration_date_cubit.dart';
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
            height: 100.sp,
            label: "نبذة عني",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
            maxLines: 3,
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: LawyermentInfoControllers.registrationNumberController,
            validator: LawyermentInfoValidators.validateRegistrationNumber,
            width: double.infinity,
            height: 60.sp,
            label: "رقم القيد بنقابة المحامين",
            keyboardType: TextInputType.number,
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          Builder(
            builder: (context) {
              return BlocBuilder<RegistrationDateCubit, RegistrationDateState>(
                builder: (context, dateState) {
                  final selectedDate = dateState is RegistrationDateSelected
                      ? dateState.selectedDate
                      : null;

                  return FormField<DateTime>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      return LawyermentInfoValidators.validateRegistrationDate(
                        selectedDate,
                      );
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCalendar(
                            label: "تاريخ القيد",
                            prevOnly: true,
                            selectedDate: selectedDate,
                            onDateSelected: (date) {
                              context.read<RegistrationDateCubit>().selectDate(
                                date,
                              );
                              state.didChange(date);
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
              );
            },
          ),

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          ValueListenableBuilder<List<String>>(
            valueListenable: LawyermentInfoControllers.specializationList,
            builder: (context, selectedList, _) {
              return GestureDetector(
                onTap: () async {
                  final result = await showDialog<List<String>>(
                    context: context,
                    builder: (context) {
                      final tempSelections = [...selectedList];
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: AppColor.grey,
                            title: Text(
                              "اختر التخصصات",
                              style: AppText.bodyMedium.copyWith(
                                color: AppColor.dark,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                children: lawyerSpecializations.map((item) {
                                  final isSelected = tempSelections.contains(
                                    item,
                                  );
                                  return CheckboxListTile(
                                    activeColor: AppColor.green,
                                    checkColor: AppColor.light,
                                    value: isSelected,
                                    title: Text(
                                      item,
                                      style: AppText.bodyMedium.copyWith(
                                        color: AppColor.dark,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          tempSelections.add(item);
                                        } else {
                                          tempSelections.remove(item);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "إلغاء",
                                  style: AppText.bodyMedium.copyWith(
                                    color: AppColor.dark,
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.pop(context, selectedList),
                              ),
                              TextButton(
                                child: Text(
                                  "تم",
                                  style: AppText.bodyMedium.copyWith(
                                    color: AppColor.dark,
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.pop(context, tempSelections),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  if (result != null) {
                    LawyermentInfoControllers.specializationList.value = result;
                  }
                },
                child: AbsorbPointer(
                  child: FormField<List<String>>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) =>
                        LawyermentInfoValidators.validateSpecializationList(
                          LawyermentInfoControllers.specializationList.value,
                        ),
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            controller: TextEditingController(
                              text: selectedList.join(', '),
                            ),
                            width: double.infinity,
                            height: 60.sp,
                            label: "التخصصات",
                            contentPadding: AppPadding.paddingMedium,
                            backgroundColor: AppColor.grey,
                            textStyle: AppText.bodyLarge.copyWith(
                              color: AppColor.dark,
                            ),
                            labelStyle: AppText.bodyLarge.copyWith(
                              color: AppColor.dark,
                            ),
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
                  ),
                ),
              );
            },
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
                            height: 60.sp,
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
                                          LawyermentInfoControllers.pickCardImage(
                                            source: ImageSource.gallery,
                                            state: state,
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
                                          LawyermentInfoControllers.pickCardImage(
                                            source: ImageSource.camera,
                                            state: state,
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              value,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
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
