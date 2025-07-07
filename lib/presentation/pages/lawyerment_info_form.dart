import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/widgets/custom_calendar.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';
import 'package:qanony/services/controllers/calendar_controller.dart';
import 'package:qanony/services/cubits/calendar/calendar_cubit.dart';

class LawyermentInfoForm extends StatelessWidget {
  const LawyermentInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            width: double.infinity,
            height: 100,
            label: "نبذة عني",
            contentPadding: AppPadding.paddingMedium,
            backgroundColor: AppColor.grey,
            textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            labelStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
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
            child: BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) {
                final selectedDate = CalendarController.getSelectedDate(state);

                return CustomCalendar(
                  label: "تاريخ القيد",
                  prevOnly: true,
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    CalendarController.updateDate(context, date);
                  },
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          CustomTextFormField(
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
            child: CustomButton(
              text: "صورة كارنية النقابة",
              onTap: () {},
              width: MediaQuery.of(context).size.width * 0.5,
              height: 50,
              backgroundColor: AppColor.secondary,
              textStyle: AppText.bodyLarge.copyWith(color: AppColor.dark),
            ),
          ),
        ],
      ),
    );
  }
}
