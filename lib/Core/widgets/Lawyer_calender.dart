import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => cubit.changeWeek(-1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
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

                    return GestureDetector(
                      onTap: () => cubit.selectDate(context, lawyerId, date),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.EEEE('ar').format(date),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
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
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${DateFormat.yMMMMEEEEd('ar').format(dateTime)} - ${DateFormat.jm('ar').format(dateTime)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
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
                          color: Colors.red,
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
