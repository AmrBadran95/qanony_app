import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_calendar.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';
import 'package:qanony/data/static/egypt_governorates.dart';
import 'package:qanony/services/controllers/personal_info_controllers.dart';
import 'package:qanony/services/cubits/date_of_birth/date_of_birth_cubit.dart';
import 'package:qanony/services/validators/personal_info_validators.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: PersonalInfoFormKey.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: PersonalInfoControllers.fullNameController,
            validator: PersonalInfoValidators.validateFullName,
            width: double.infinity,
            label: "الاسم رباعي",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: PersonalInfoControllers.nationalIdController,
            validator: PersonalInfoValidators.validateNationalId,
            width: double.infinity,
            label: "الرقم القومي",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          FormField<String>(
            initialValue: PersonalInfoControllers.governorate.value,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: PersonalInfoValidators.validateGovernorate,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<String?>(
                    valueListenable: PersonalInfoControllers.governorate,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<String>(
                        value: value,
                        onChanged: (newValue) {
                          PersonalInfoControllers.governorate.value = newValue;
                          state.didChange(newValue);
                        },
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.dark,
                        ),
                        dropdownColor: AppColor.grey,
                        decoration: InputDecoration(
                          labelText: "اختر المحافظة",
                          labelStyle: AppText.bodyMedium.copyWith(
                            color: AppColor.dark,
                          ),
                          filled: true,
                          fillColor: AppColor.grey,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.dark),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.dark,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primary),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.dark,
                              width: 1,
                            ),
                          ),
                        ),
                        items: egyptGovernorates
                            .map(
                              (governorate) => DropdownMenuItem(
                                value: governorate,
                                child: Text(
                                  governorate,
                                  style: AppText.bodyMedium.copyWith(
                                    color: AppColor.dark,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
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

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: PersonalInfoControllers.fullAddressController,
            validator: PersonalInfoValidators.validateFullAddress,
            width: double.infinity,
            label: "العنوان بالكامل",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          Builder(
            builder: (context) {
              return FormField<DateTime>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (_) {
                  final state = context.read<DateOfBirthCubit>().state;
                  if (state is DateOfBirthSelected) {
                    return PersonalInfoValidators.validateBirthDate(
                      state.selectedDate,
                    );
                  }
                  return PersonalInfoValidators.validateBirthDate(null);
                },
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<DateOfBirthCubit, DateOfBirthState>(
                        builder: (context, dateState) {
                          DateTime? selectedDate;
                          if (dateState is DateOfBirthSelected) {
                            selectedDate = dateState.selectedDate;
                          }

                          return CustomCalendar(
                            label: "تاريخ الميلاد",
                            prevOnly: true,
                            selectedDate: selectedDate,
                            onDateSelected: (date) {
                              context.read<DateOfBirthCubit>().selectDate(date);
                              state.didChange(date);
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

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          Text(
            "النوع",
            style: AppText.bodyMedium.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          FormField<String>(
            initialValue: PersonalInfoControllers.gender.value,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: PersonalInfoValidators.validateGender,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<String?>(
                    valueListenable: PersonalInfoControllers.gender,
                    builder: (context, value, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: 'ذكر',
                              groupValue: value,
                              onChanged: (val) {
                                PersonalInfoControllers.gender.value = val;
                                state.didChange(val);
                              },
                              title: Text("ذكر", style: AppText.bodySmall),
                              activeColor: AppColor.dark,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              value: 'أنثى',
                              groupValue: value,
                              onChanged: (val) {
                                PersonalInfoControllers.gender.value = val;
                                state.didChange(val);
                              },
                              title: Text("أنثى", style: AppText.bodySmall),
                              activeColor: AppColor.dark,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
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

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          Center(
            child: FormField<String>(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) => PersonalInfoValidators.validateProfileImage(
                PersonalInfoControllers.profileImage.value,
              ),
              builder: (state) {
                return ValueListenableBuilder<String?>(
                  valueListenable: PersonalInfoControllers.profileImage,
                  builder: (context, value, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomButton(
                          text: "إضافة صورة شخصية",
                          width: double.infinity,
                          height: 50.h,
                          backgroundColor: AppColor.secondary,
                          textStyle: AppText.bodySmall.copyWith(
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
                                        style: AppText.bodySmall.copyWith(
                                          color: AppColor.dark,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        PersonalInfoControllers.pickProfileImage(
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
                                        style: AppText.bodySmall.copyWith(
                                          color: AppColor.dark,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        PersonalInfoControllers.pickProfileImage(
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
                        if (value != null) ...[
                          SizedBox(height: 10.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.sp),
                            child: Image.network(
                              value,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        if (state.hasError)
                          Padding(
                            padding: EdgeInsets.only(top: 8.sp),
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
        ],
      ),
    );
  }
}
