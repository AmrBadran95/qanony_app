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

    final widthMedium = screenWidth * 0.04;
    final heightMedium = screenHeight * 0.015;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, size: 40, color: AppColor.dark),
                SizedBox(width: widthMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppText.bodyMedium),
                      SizedBox(height: heightMedium),
                      Text(
                        specialty,
                        style: TextStyle(
                          fontSize: AppText.labelLarge.fontSize,
                          color: AppColor.dark,
                        ),
                      ),
                      SizedBox(height: heightMedium),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: AppText.labelSmall.fontSize,
                          color: AppColor.dark,
                        ),
                      ),
                      SizedBox(height: heightMedium),
                      Text(
                        "$date",
                        style: TextStyle(
                          fontSize: AppText.labelLarge.fontSize,
                          color: AppColor.dark,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: widthMedium),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$communication",
                      style: TextStyle(
                        fontSize: AppText.labelSmall.fontSize,
                        color: AppColor.dark,
                      ),
                    ),
                    SizedBox(height: heightMedium),
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
