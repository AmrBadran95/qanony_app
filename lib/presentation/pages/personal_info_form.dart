import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: PersonalInfoControllers.nationalIdController,
            validator: PersonalInfoValidators.validateNationalId,
            width: double.infinity,
            label: "الرقم القومي",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          FormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: PersonalInfoValidators.validateGovernorate,
            builder: (state) {
              return ValueListenableBuilder<String?>(
                valueListenable: PersonalInfoControllers.governorate,
                builder: (context, value, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        value: value,
                        onChanged: (newValue) {
                          PersonalInfoControllers.governorate.value = newValue;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            state.didChange(newValue);
                          });
                        },
                        items: egyptGovernorates
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'المحافظة',
                          filled: true,
                          fillColor: AppColor.grey,
                          labelStyle: AppText.bodyLarge.copyWith(
                            color: AppColor.dark,
                          ),
                          contentPadding: AppPadding.paddingMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColor.dark),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                        dropdownColor: AppColor.grey,
                        borderRadius: BorderRadius.circular(8),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColor.dark,
                        ),
                        isExpanded: true,
                      ),
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
          SizedBox(height: MediaQuery.of(context).size.height * .01),

          CustomTextFormField(
            controller: PersonalInfoControllers.fullAddressController,
            validator: PersonalInfoValidators.validateFullAddress,
            width: double.infinity,
            label: "العنوان بالكامل",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
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
                              WidgetsBinding.instance.addPostFrameCallback((_) {
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

          SizedBox(height: MediaQuery.of(context).size.height * .01),

          Text(
            "النوع",
            style: AppText.bodyLarge.copyWith(color: AppColor.dark),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          FormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: PersonalInfoValidators.validateGender,
            builder: (state) {
              return ValueListenableBuilder<String?>(
                valueListenable: PersonalInfoControllers.gender,
                builder: (context, value, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: "male",
                              groupValue: value,
                              onChanged: (val) {
                                PersonalInfoControllers.gender.value = val;
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  state.didChange(val);
                                });
                              },
                              title: Text(
                                "ذكر",
                                style: AppText.bodyLarge.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                              fillColor: WidgetStateProperty.all(AppColor.dark),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              value: "female",
                              groupValue: value,
                              onChanged: (val) {
                                PersonalInfoControllers.gender.value = val;
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  state.didChange(val);
                                });
                              },
                              title: Text(
                                "أنثى",
                                style: AppText.bodyLarge.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                              fillColor: WidgetStateProperty.all(AppColor.dark),
                            ),
                          ),
                        ],
                      ),
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
                                        style: AppText.bodyLarge.copyWith(
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
                          const SizedBox(height: 10),
                          Text(
                            value,
                            style: AppText.bodySmall.copyWith(
                              color: AppColor.dark,
                            ),
                          ),
                          const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
