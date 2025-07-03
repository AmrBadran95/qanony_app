import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

class QanonyAppointmentCardWidget extends StatelessWidget {
  final String name;
  final String specialty;
  final String description;
  final String price;
  final String date;
  final String time;

  const QanonyAppointmentCardWidget({
    super.key,
    required this.name,
    required this.specialty,
    required this.description,
    required this.price,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, size: 40, color: AppColor.dark),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppText.bodyMedium),
                      const SizedBox(height: 4),
                      Text(
                        specialty,
                        style: TextStyle(
                          fontSize: AppText.labelLarge.fontSize,
                          color: AppColor.dark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: AppText.laberSmall.fontSize,
                          color: AppColor.dark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "محادثة فيديو",
                      style: TextStyle(
                        fontSize: AppText.laberSmall.fontSize,
                        color: AppColor.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "المبلغ: $price",
                      style: TextStyle(
                        fontSize: AppText.labelLarge.fontSize,
                        color: AppColor.dark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, size: 18, color: AppColor.dark),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: AppText.laberSmall.fontSize,
                    color: AppColor.dark,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 18, color: AppColor.dark),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: AppText.laberSmall.fontSize,
                    color: AppColor.dark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
