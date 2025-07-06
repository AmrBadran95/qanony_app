import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

class RoleContainer extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;
  final Color textColor;
  final String text1;
  final String text2;
  final String text3;

  const RoleContainer({
    super.key,
    this.color = AppColor.primary,
    this.onTap,
    this.textColor = AppColor.light,
    required this.text1,
    required this.text2,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
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
        padding: AppPadding.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                text1,
                style: AppText.appHeading.copyWith(color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(text2, style: AppText.bodyMedium.copyWith(color: textColor)),
            SizedBox(height: screenHeight * 0.01),
            Text(text3, style: AppText.bodyMedium.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
