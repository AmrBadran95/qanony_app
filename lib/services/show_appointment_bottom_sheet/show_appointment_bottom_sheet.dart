import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qanony/services/show_appointment_bottom_sheet/show_booking_form_sheet.dart';

import '../../Core/styles/color.dart';
import '../../Core/styles/text.dart';

void showAppointmentBottomSheet({
  required BuildContext context,
  required List<DateTime> appointments,
  required String bookingType,
  required String price,
  required String lawyerId,
}) {
  final now = DateTime.now();
  final sortedAppointments = [
    ...appointments.where((appointment) => appointment.isAfter(now))
  ]..sort((a, b) => a.compareTo(b));

  Map<String, List<DateTime>> groupedAppointments = {};
  for (var appointment in sortedAppointments) {
    String dayKey = DateFormat.yMMMMd('ar').format(appointment);
    groupedAppointments.putIfAbsent(dayKey, () => []).add(appointment);
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.8,
        initialChildSize: 0.5,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Text(
                  "اختر ميعاد $bookingType",
                  style: AppText.title.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...groupedAppointments.entries.map((entry) {
                final dayName = DateFormat.EEEE('ar').format(entry.value.first);
                return ExpansionTile(
                  collapsedIconColor: AppColor.dark,
                  iconColor: AppColor.primary,
                  title: Text(
                    '$dayName - ${entry.key}',
                    style: AppText.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.dark,
                    ),
                  ),
                  children: entry.value.map((timeSlot) {
                    final time = DateFormat.jm('ar').format(timeSlot);
                    return ListTile(
                      title: Text(
                        "الساعة: $time",
                        style: AppText.bodySmall.copyWith(color: AppColor.dark),
                      ),
                      leading: Icon(
                        Icons.access_time_outlined,
                        color: AppColor.secondary,
                      ),
                      onTap: () {
                        showBookingForm(
                          context: context,
                          bookingType: bookingType,
                          price: price,
                          day: dayName,
                          date: " ${entry.key}",
                          time: time,
                          lawyerId: lawyerId,
                        );
                      },
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
