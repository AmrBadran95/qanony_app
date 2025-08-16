import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/services/cubits/lawyer_caleder/calender_cubit.dart';

class WeeklyCalendarWidget extends StatelessWidget {
  final String lawyerId;
  const WeeklyCalendarWidget({super.key, required this.lawyerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LawyerScheduleCubit()..loadAppointments(lawyerId),
      child: BlocBuilder<LawyerScheduleCubit, LawyerScheduleState>(
        builder: (context, state) {
          final cubit = context.read<LawyerScheduleCubit>();
          final weekDates = cubit.getWeekDates();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.medium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${cubit.selectedDate.day} ${DateFormat.MMMM('ar').format(cubit.selectedDate)}",
                      style: AppText.title.copyWith(color: AppColor.dark),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: AppColor.dark,
                          ),
                          onPressed: () {
                            final previousWeekStart = DateTime.now().add(
                              Duration(days: 7 * (cubit.weekOffset - 1)),
                            );
                            final now = DateTime.now();
                            final todayOnly = DateTime(
                              now.year,
                              now.month,
                              now.day,
                            );

                            if (previousWeekStart.isBefore(todayOnly)) return;

                            cubit.changeWeek(-1);
                          },
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                            color: AppColor.dark,
                          ),
                          onPressed: () => cubit.changeWeek(1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.sp),

              SizedBox(
                height: 80.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weekDates.length,
                  itemBuilder: (context, index) {
                    final date = weekDates[index];
                    final isSelected = cubit.isSameDate(
                      date,
                      cubit.selectedDate,
                    );
                    final isPastDate = date.isBefore(
                      DateTime.now().subtract(const Duration(days: 1)),
                    );

                    return GestureDetector(
                      onTap: isPastDate
                          ? null
                          : () => cubit.selectDate(context, lawyerId, date),
                      child: Opacity(
                        opacity: isPastDate ? 0.4 : 1.0,
                        child: Container(
                          width: 60.w,
                          margin: EdgeInsets.symmetric(
                            horizontal: AppPadding.small,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.EEEE('ar').format(date),
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColor.light
                                      : AppColor.darkgrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 6.sp),
                              Text(
                                '${date.day}',
                                style: AppText.title.copyWith(
                                  color: isSelected
                                      ? AppColor.light
                                      : AppColor.dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16.sp),

              ...cubit.appointments.asMap().entries.map((entry) {
                final index = entry.key;
                final dateTime = entry.value;

                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 4.sp,
                    horizontal: 12.sp,
                  ),
                  padding: EdgeInsets.all(AppPadding.medium),
                  decoration: BoxDecoration(
                    color: AppColor.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 24.sp,
                        color: AppColor.dark,
                      ),
                      SizedBox(width: 8.sp),
                      Expanded(
                        child: Text(
                          '${DateFormat.yMMMMEEEEd('ar').format(dateTime)} - ${DateFormat.jm('ar').format(dateTime)}',
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: AppColor.dark,
                          size: 24.sp,
                        ),
                        onPressed: () => cubit.selectDate(
                          context,
                          lawyerId,
                          dateTime,
                          index,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AppColor.error,
                          size: 24.sp,
                        ),
                        onPressed: () =>
                            cubit.deleteAppointment(lawyerId, index),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
