import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/color.dart';
import '../styles/padding.dart';
import '../styles/text.dart';

class SubscriptionCard extends StatelessWidget {
  final String label;
  final Color labelColor;
  final IconData icon;
  final String priceText;
  final String title;
  final String option1;
  final String option2;
  final String option3;

  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.label,
    required this.labelColor,
    required this.icon,
    required this.priceText,
    required this.title,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: AppPadding.paddingSmall,
            decoration: BoxDecoration(
              color: AppColor.grey.withAlpha((0.7 * 255).round()),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColor.primary, width: 2.w),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.035,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: AppText.bodyMedium.copyWith(
                            color: AppColor.dark,
                          ),
                        ),
                        Text(
                          option1,
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                        ),

                        Text(
                          option2,
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                        ),

                        Text(
                          option3,
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.sp, left: 10.sp),
                  child: Column(
                    children: [
                      Container(
                        width: 40.sp,
                        height: 40.sp,
                        decoration: BoxDecoration(
                          color: labelColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(icon, color: AppColor.light, size: 24.sp),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        priceText,
                        style: AppText.bodySmall.copyWith(
                          color: AppColor.dark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * .02,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * .28,
              height: MediaQuery.of(context).size.height * .03,
              color: labelColor,
              alignment: Alignment.center,
              child: Text(
                label,
                style: AppText.labelSmall.copyWith(color: AppColor.light),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
