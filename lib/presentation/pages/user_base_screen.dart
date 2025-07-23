import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/presentation/screens/notification-screen.dart';
import 'package:qanony/services/cubits/notification/cubit/notification_cubit.dart';

import '../screens/user_home_screen.dart';

class UserBaseScreen extends StatelessWidget {
  final Widget body;
  final Color HomeColor;
  final Color SearchColor;
  final Color AppointmentsColor;
  final Color RequestsColor;

  const UserBaseScreen({super.key, required this.body,
    this.HomeColor=AppColor.light,
    this.SearchColor=AppColor.light,
    this.AppointmentsColor=AppColor.light,
    this.RequestsColor=AppColor.light

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.light,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColor.primary,
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(AppPadding.small),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: CircleAvatar(
                  radius: 40,
                  // backgroundImage: AssetImage('assets/images/lawyer 1.png'),
                ),
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(

              right: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "قانوني",
                  style: AppText.headingMedium.copyWith(color: AppColor.light),
                ),

                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) =>
                                  NotificationCubit()..loadNotifications(),
                              child: const NotificationScreen(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.notifications_none_sharp,
                        size: MediaQuery.of(context).size.width * 0.095,
                        color: AppColor.light,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 12, top: 13),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.03,
                        height: MediaQuery.of(context).size.width * 0.03,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: AppColor.light,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColor.primary),
              child: Text(
                'حسابي',
                style: AppText.headingLarge.copyWith(color: AppColor.light),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('الملف الشخصي'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('الإعدادات'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: () {},
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: AppPadding.paddingSmall,
        width: double.infinity,
        color: AppColor.primary,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserHomeScreen()));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.home_sharp,
                          size: 20,
                          color: HomeColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "الرئيسية",
                          style: AppText.labelSmall.copyWith(
                            color: HomeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(
                          Icons.search,
                          size: 20,
                          color: SearchColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "البحث",
                          style: AppText.labelSmall.copyWith(
                            color: SearchColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(
                          Icons.access_alarm_sharp,
                          size: 20,
                          color:AppointmentsColor
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "مواعيدي",
                          style: AppText.labelSmall.copyWith(
                              color:AppointmentsColor
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(
                          Icons.assignment_sharp,
                          size: 20,
                          color: RequestsColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "طلباتي",
                          style: AppText.labelSmall.copyWith(
                            color: RequestsColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
