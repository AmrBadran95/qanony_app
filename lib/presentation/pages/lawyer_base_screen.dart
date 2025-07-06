import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

class LawyerBaseScreen extends StatelessWidget {
  final Widget body;

  const LawyerBaseScreen({super.key, required this.body});



  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width * 0.08;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.01,

          ),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "قانوني",
                style: AppText.headingMedium.copyWith(color: AppColor.light),
              ),
              Stack(
                children: [
                  Icon(
                    Icons.notifications_none_sharp,
                    size: MediaQuery.of(context).size.width * 0.095,
                    color: AppColor.light,
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: 4,top:4),
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
      bottomNavigationBar: Container(
        padding: AppPadding.paddingSmall,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.089,

        color: AppColor.primary,

        child:
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.005),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Icon(Icons.home_sharp, size: iconSize, color: AppColor.light),
                    Text(
                      "الرئيسية",
                      style: AppText.labelSmall.copyWith(color: AppColor.light),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Icon(
                      Icons.access_alarm_sharp,
                      size: iconSize,
                      color: AppColor.light,
                    ),
                    Text(
                      "مواعيدي",
                      style: AppText.labelSmall.copyWith(color: AppColor.light),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Icon(
                      Icons.assignment_sharp,
                      size: iconSize,
                      color: AppColor.light,
                    ),
                    Text(
                      "طلباتي",
                      style: AppText.labelSmall.copyWith(color: AppColor.light),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Icon(
                      Icons.logout_sharp,
                      size: iconSize,
                      color: AppColor.light,
                    ),
                    Text(
                      "تسجيل الخروج",
                      style: AppText.labelSmall.copyWith(color: AppColor.light),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
