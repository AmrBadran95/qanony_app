import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
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
        'communication': "واتساب",
      },
      {
        "name": "علي عبد الله",
        "specialty": "قضيه مدنيه",
        "description": "قضيه في قضايا الأسرة",
        "price": "800",
        'date': "2023-10-01",
        'time': "10:00 AM",
        'communication': "مكالمة",
      },
    ];

    return ListView.builder(
      itemCount: appointments.length,
      padding: AppPadding.verticalMedium,
      itemBuilder: (context, index) {
        final item = appointments[index];
        return Padding(
          padding: AppPadding.verticalSmall,
          child: QanonyAppointmentCardWidget(
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
                  SizedBox(width: AppPadding.small),
                  Text(
                    item["date"]!,
                    style: TextStyle(
                      fontSize: AppText.labelSmall.fontSize,
                      color: AppColor.dark,
                    ),
                  ),
                  SizedBox(width: AppPadding.medium),
                  const Icon(Icons.access_time, size: 18, color: AppColor.dark),
                  SizedBox(width: AppPadding.small),
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
          ),
        );
      },
    );
  }
}
