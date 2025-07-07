import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

class UserBaseScreen extends StatelessWidget {
  final Widget body;
  const UserBaseScreen({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(AppPadding.small),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                backgroundColor: AppColor.secondary,
                child: const Icon(
                  Icons.person_2_outlined,
                  color: AppColor.dark,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "قانوني",
          style: AppText.headingLarge.copyWith(color: AppColor.light),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: AppColor.secondary,
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColor.dark,
                ),
              ),
            ),
          ),
        ],
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
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.home_sharp,
                          size: 20,
                          color: AppColor.light,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "الرئيسية",
                          style: AppText.laberSmall.copyWith(
                            color: AppColor.light,
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
                        const Icon(
                          Icons.search,
                          size: 20,
                          color: AppColor.light,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "البحث",
                          style: AppText.laberSmall.copyWith(
                            color: AppColor.light,
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
                        const Icon(
                          Icons.access_alarm_sharp,
                          size: 20,
                          color: AppColor.light,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "مواعيدي",
                          style: AppText.laberSmall.copyWith(
                            color: AppColor.light,
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
                        const Icon(
                          Icons.assignment_sharp,
                          size: 20,
                          color: AppColor.light,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "طلباتي",
                          style: AppText.laberSmall.copyWith(
                            color: AppColor.light,
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
