import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

class MyAppointmentCardWidget extends StatelessWidget {
  final String name;
  final String specialty;
  final String description;
  final String communication;
  final String date;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const MyAppointmentCardWidget({
    super.key,
    required this.name,
    required this.specialty,
    required this.description,
    required this.date,
    required this.communication,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person, size: 40.sp, color: AppColor.dark),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: AppText.labelLarge.fontSize,
                      color: AppColor.dark,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: AppText.labelSmall.fontSize,
                      color: AppColor.dark,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'طريقه التواصل:$communication',
                    style: TextStyle(
                      fontSize: AppText.labelSmall.fontSize,
                      color: AppColor.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'التاريخ: $date',
                    style: AppText.labelSmall.copyWith(color: AppColor.dark),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, color: AppColor.dark),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, color: AppColor.error),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
