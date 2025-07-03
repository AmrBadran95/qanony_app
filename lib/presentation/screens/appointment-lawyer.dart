import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/text.dart';

import '../../Core/styles/color.dart';
import '../pages/lawyer_base_screen.dart';
import '../pages/my_appointments_tab.dart';
import '../pages/qanony_appointments_tab.dart';

class AppointmentLawyer extends StatelessWidget {
  const AppointmentLawyer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: LawyerBaseScreen(
        body: Column(
          children: [
            const TabBar(
              labelColor: AppColor.dark,
              unselectedLabelColor: AppColor.grey,
              indicatorColor: AppColor.secondary,
              tabs: [
                Tab(child: Text("مواعيدى", style: AppText.bodyLarge)),
                Tab(child: Text("مواعيد قانونى", style: AppText.bodyLarge)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [MyAppointmentsTab(), QanonyAppointmentsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
