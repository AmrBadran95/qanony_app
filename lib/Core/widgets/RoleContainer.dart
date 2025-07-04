import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

Widget RoleContainer({
  Color color = AppColor.primary,
  VoidCallback? onTap,
  Color textColor = AppColor.light,
  required BuildContext context,
  required String text1,
  required String text2,
  required String text3,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.23,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: AppPadding.paddingSmall,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: AppPadding.paddingMedium,
              child: Center(
                child: Text(
                  text1,
                  style: AppText.appHeading.copyWith(color: textColor),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    text2,
                    style: AppText.bodyMedium.copyWith(color: textColor),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    text3,
                    style: AppText.bodyMedium.copyWith(color: textColor),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    ),
  );
}