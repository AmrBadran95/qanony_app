import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

class LawyerBaseScreen extends StatelessWidget {
  final Widget body;
  const LawyerBaseScreen({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Padding(
          padding: AppPadding.paddingLarge,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "قانوني",
                style: AppText.headingLarge.copyWith(color: AppColor.light),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.secondary,
                ),
                child: const Icon(
                  Icons.notifications_none_sharp,
                  size: 40,
                  color: AppColor.dark,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: AppPadding.paddingSmall,
        width: double.infinity,
        height: 100,
        color: AppColor.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  const Icon(Icons.home_sharp, size: 40, color: AppColor.light),
                  Text(
                    "الرئيسية",
                    style: AppText.labelLarge.copyWith(color: AppColor.light),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  const Icon(
                    Icons.access_alarm_sharp,
                    size: 40,
                    color: AppColor.light,
                  ),
                  Text(
                    "مواعيدي",
                    style: AppText.labelLarge.copyWith(color: AppColor.light),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  const Icon(
                    Icons.assignment_sharp,
                    size: 40,
                    color: AppColor.light,
                  ),
                  Text(
                    "طلباتي",
                    style: AppText.labelLarge.copyWith(color: AppColor.light),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  const Icon(
                    Icons.logout_sharp,
                    size: 40,
                    color: AppColor.light,
                  ),
                  Text(
                    "تسجيل الخروج",
                    style: AppText.labelLarge.copyWith(color: AppColor.light),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
