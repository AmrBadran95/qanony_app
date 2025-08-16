import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

import '../../services/call/AppointmentPageForUser .dart';
import '../../services/firestore/order_firestore_service.dart';

class QanonyAppointmentCardWidget extends StatelessWidget {
  final String name;
  final String specialty;
  final String description;
  final String communication;
  final String price;
  final String date;
  final DateTime orderdate;
  final String orderId;

  final List<Widget>? children;

  const QanonyAppointmentCardWidget({
    super.key,
    required this.name,
    required this.specialty,
    required this.description,
    required this.price,
    required this.communication,
    required this.date,
    required this.orderdate,
    required this.orderId,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final orderService = OrderFirestoreService();

    final dateParts = date.split('•');
    final String dateOnly = dateParts[0].trim();
    final String timeOnly = dateParts.length > 1 ? dateParts[1].trim() : '';
    final DateTime parsedDate = DateTime.tryParse(dateOnly) ?? DateTime.now();
    final List<String> arabicDays = [
      'الأحد',
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
    ];
    final String dayName = arabicDays[parsedDate.weekday % 7];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                StreamBuilder<bool>(
                  stream: TimeStreamUtils.canDeleteAfterSession(orderdate, 2),
                  builder: (context, snapshot) {
                    final canDelete = snapshot.data ?? false;
                    if (!canDelete) {
                      return const SizedBox.shrink();
                    }

                    return Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: AppPadding.paddingSmall,
                            child: GestureDetector(
                              onTap: () {
                                orderService.deleteOrder(orderId);
                              },
                              child: Icon(
                                Icons.delete,
                                size: 24.sp,
                                color: AppColor.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: AppColor.dark, size: 20.sp),
                    SizedBox(width: 2.w),
                    Text(
                      name,
                      style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    communication,
                    style: AppText.labelSmall.copyWith(color: AppColor.light),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppPadding.small),

            Text(
              specialty,
              style: AppText.bodyMedium.copyWith(color: AppColor.dark),
            ),
            SizedBox(height: 4.h),
            Text(
              'الوصف: $description',
              style: AppText.bodyMedium.copyWith(color: AppColor.dark),
            ),
            SizedBox(height: AppPadding.small),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColor.darkgrey,
                ),
                const SizedBox(width: 4),
                Text(
                  "$dayName، $dateOnly",
                  style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                ),
              ],
            ),
            SizedBox(height: AppPadding.small),

            Row(
              children: [
                Icon(Icons.access_time, size: 18.sp, color: AppColor.darkgrey),
                SizedBox(width: 4.w),
                Text(
                  timeOnly,
                  style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                ),
              ],
            ),
            SizedBox(height: AppPadding.small),

            Row(
              children: [
                Icon(Icons.attach_money, size: 18.sp, color: AppColor.darkgrey),
                SizedBox(width: 4.w),
                Text(
                  " $price",
                  style: AppText.bodyMedium.copyWith(
                    color: AppColor.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            if (children != null && children!.isNotEmpty) ...[...children!],
          ],
        ),
      ),
    );
  }
}
