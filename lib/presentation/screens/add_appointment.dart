import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/widgets/custom_calendar.dart';
import 'package:qanony/Core/widgets/custom_text_form_field.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/data/static/case_types.dart';
import 'package:qanony/services/controllers/calendar_controller.dart';
import 'package:qanony/services/cubits/calendar/calendar_cubit.dart';

class AddAppointment extends StatelessWidget {
  const AddAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    // final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.light),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'إضافة موعد',
          style: AppText.title.copyWith(color: AppColor.light),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.medium),
        child: BlocProvider(
          create: (context) => CalendarCubit(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                width: double.infinity,
                label: 'اسم العميل',
                textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
                labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
                contentPadding: AppPadding.paddingSmall,
                backgroundColor: AppColor.grey,
              ),
              SizedBox(height: pageHeight * 0.02),
              DropdownButtonFormField<String>(
                value: null,
                items: caseTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (_) {},
                decoration: InputDecoration(
                  labelText: 'نوع القضية',
                  labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
                  filled: true,
                  fillColor: AppColor.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: AppPadding.paddingSmall,
                ),
              ),
              SizedBox(height: pageHeight * 0.02),
              CustomTextFormField(
                label: 'وصف الموعد',
                textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
                labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
                contentPadding: AppPadding.paddingSmall,
                width: double.infinity,
                backgroundColor: AppColor.grey,
              ),
              SizedBox(height: pageHeight * 0.02),
              CustomTextFormField(
                label: 'السعر بالجنيه',
                keyboardType: TextInputType.number,
                textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
                labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
                contentPadding: AppPadding.paddingSmall,
                width: double.infinity,
                backgroundColor: AppColor.grey,
              ),
              SizedBox(height: pageHeight * 0.02),
              BlocBuilder<CalendarCubit, CalendarState>(
                builder: (context, state) {
                  final selectedDate = CalendarController.getSelectedDate(
                    state,
                  );

                  return CustomCalendar(
                    label: "تاريخ الموعد",
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      CalendarController.updateDate(context, date);
                    },
                  );
                },
              ),
              SizedBox(height: pageHeight * 0.03),
              Center(
                child: CustomButton(
                  text: 'اضافه قضيه',
                  onTap: () {},
                  width: 200,
                  height: 50,
                  backgroundColor: AppColor.secondary,
                  textStyle: const TextStyle(
                    color: AppColor.light,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
