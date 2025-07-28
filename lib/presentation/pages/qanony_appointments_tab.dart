import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';

import '../../Core/widgets/qanony_appointment_widget.dart';

class QanonyAppointmentsTab extends StatelessWidget {
  const QanonyAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {
        "name": "أحمد محمد",
        "specialty": "قضيه جنائي",
        "description": "قضيه في القضايا الجنائية",
        "price": "1000",
        'date': "2023-10-01",
        'time': "10:00 AM",
      },
      {
        "name": "علي عبد الله",
        "specialty": "قضيه مدنيه",
        "description": "قضيه في قضايا الأسرة",
        "price": "800",
        'date': "2023-10-01",
        'time': "10:00 AM",
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final widthSmall = screenWidth * 0.02; // تقريبًا 8px على شاشة 400
    final widthMedium = screenWidth * 0.04; // تقريبًا 16px

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final item = appointments[index];
        return QanonyAppointmentCardWidget(
          name: item["name"]!,
          specialty: item["specialty"]!,
          description: item["description"]!,
          price: item["price"]!,
          date: item["date"]!,
          communication: item["communication"]!,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColor.dark,
                ),
                SizedBox(width: widthSmall),
                Text(
                  item["date"]!,
                  style: TextStyle(
                    fontSize: AppText.labelSmall.fontSize,
                    color: AppColor.dark,
                  ),
                ),
                SizedBox(width: widthMedium),
                const Icon(Icons.access_time, size: 18, color: AppColor.dark),
                SizedBox(width: widthSmall),
                Text(
                  item["time"]!,
                  style: TextStyle(
                    fontSize: AppText.labelSmall.fontSize,
                    color: AppColor.dark,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
