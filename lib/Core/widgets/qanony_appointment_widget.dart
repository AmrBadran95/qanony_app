import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

class QanonyAppointmentCardWidget extends StatelessWidget {
  final String name;
  final String specialty;
  final String description;
  final String communication;
  final String price;
  final String date;
  final List<Widget>? children;

  const QanonyAppointmentCardWidget({
    super.key,
    required this.name,
    required this.specialty,
    required this.description,
    required this.price,
    required this.communication,
    required this.date,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final heightMedium = screenHeight * 0.015;

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
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: AppColor.dark, size: 20),
                    const SizedBox(width: 2),
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppText.title.copyWith(color: AppColor.dark),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
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
            const SizedBox(height: AppPadding.small),

            Text(
              specialty,
              style: AppText.bodyMedium.copyWith(color: AppColor.dark),
            ),
            const SizedBox(height: 4),
            Text(
              'الوصف: $description',
              style: AppText.bodyMedium.copyWith(color: AppColor.dark),
            ),
            const SizedBox(height: AppPadding.small),

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
            const SizedBox(height: AppPadding.small),

            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 18,
                  color: AppColor.darkgrey,
                ),
                const SizedBox(width: 4),
                Text(
                  timeOnly,
                  style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                ),
              ],
            ),
            const SizedBox(height: AppPadding.small),

            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 18,
                  color: AppColor.darkgrey,
                ),
                const SizedBox(width: 4),
                Text(
                  " $price",
                  style: AppText.bodyMedium.copyWith(
                    color: AppColor.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            if (children != null && children!.isNotEmpty) ...[
              SizedBox(height: heightMedium),
              ...children!,
            ],
          ],
        ),
      ),
    );
  }
}
