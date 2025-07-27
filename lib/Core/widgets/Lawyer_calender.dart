import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/color.dart';
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      "${cubit.selectedDate.day} ${DateFormat.MMMM('ar').format(cubit.selectedDate)}",
                      style: AppText.title.copyWith(color: AppColor.dark),
                    ),
                    const Spacer(),
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
              ),

              const SizedBox(height: 8),

              // Days Row
              SizedBox(
                height: 80,
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
                          width: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
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
                              const SizedBox(height: 6),
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

              const SizedBox(height: 16),

              // Appointments
              ...cubit.appointments.asMap().entries.map((entry) {
                final index = entry.key;
                final dateTime = entry.value;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: AppColor.dark,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${DateFormat.yMMMMEEEEd('ar').format(dateTime)} - ${DateFormat.jm('ar').format(dateTime)}',
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColor.dark,
                          size: 20,
                        ),
                        onPressed: () => cubit.selectDate(
                          context,
                          lawyerId,
                          dateTime,
                          index,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColor.primary,
                          size: 20,
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
