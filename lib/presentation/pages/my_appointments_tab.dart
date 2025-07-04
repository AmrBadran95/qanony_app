import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';

import '../../Core/widgets/my_appointments_widget.dart';
import '../screens/add-appointment.dart';

class MyAppointmentsTab extends StatelessWidget {
  const MyAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {
        "name": "أحمد محمد",
        "specialty": "قضيه جنائيه",
        "description": " قضيه في القضايا الجنائية",
        "price": "1000",
      },
      {
        "name": "علي عبد الله",
        "specialty": "قضيه مدنيه",
        "description": " قضيه في قضايا الأسرة",
        "price": "800",
      },
    ];

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final item = appointments[index];
            return MyAppointmentCardWidget(
              name: item["name"]!,
              specialty: item["specialty"]!,
              description: item["description"]!,
              price: item["price"]!,
              onDelete: () {},
              onEdit: () {},
            );
          },
        ),

        Positioned(
          bottom: 16,
          left: 16,
          child: FloatingActionButton(
            backgroundColor: AppColor.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAppointment()),
              );
            },
            child: const Icon(Icons.add, size: 30, color: AppColor.light),
          ),
        ),
      ],
    );
  }
}
