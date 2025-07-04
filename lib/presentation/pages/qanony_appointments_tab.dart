import 'package:flutter/material.dart';

import '../../Core/widgets/qanony_appointment_widget.dart';

class QanonyAppointmentsTab extends StatelessWidget {
  const QanonyAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {
        "name": "أحمد محمد",
        "specialty": "قضيه جنائي",
        "description": " قضيه في القضايا الجنائية",
        "price": "1000",
        'date': "2023-10-01",
        'time': "10:00 AM",
      },
      {
        "name": "علي عبد الله",
        "specialty": "قضيه مدنيه",
        "description": " قضيه في قضايا الأسرة",
        "price": "800",
        'date': "2023-10-01",
        'time': "10:00 AM",
      },
    ];

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
          time: item["time"]!,
        );
      },
    );
  }
}
