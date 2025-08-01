import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: AppPadding.paddingLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Text(
                text1,
                style: AppText.headingMedium.copyWith(color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15.h),
            Text(text2, style: AppText.bodySmall.copyWith(color: textColor)),
            SizedBox(height: 15.h),

            Text(text3, style: AppText.bodySmall.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
