import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';

class PaymentLawyerScreen extends StatelessWidget {
  const PaymentLawyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: Text(
          'متابعة الاشتراك',
          style: AppText.headingLarge.copyWith(color: AppColor.light),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.light),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: AppPadding.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: AppPadding.paddingMedium,
              decoration: BoxDecoration(
                color: AppColor.light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: AppPadding.paddingMedium,
                    decoration: BoxDecoration(
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'باقة المحامي المحترف.',
                      style: AppText.title.copyWith(color: AppColor.dark),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'تفاصيل الاشتراك:',
                      style: AppText.title.copyWith(color: AppColor.dark),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'منذ 05 يوليو 2023',
                      style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ينتهي 05 أغسطس 2023',
                      style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'مدفوع',
                      style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'الغاء الاشتراك',
              onTap: () {},
              width: double.infinity,
              height: 50,
              backgroundColor: AppColor.primary,
              textStyle: AppText.title,
              textColor: AppColor.light,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'العودة للصفحه الرئيسية',
              onTap: () {},
              width: double.infinity,
              height: 50,
              backgroundColor: AppColor.secondary,
              textStyle: AppText.title,
              textColor: AppColor.dark,
            ),
          ],
        ),
      ),
    );
  }
}
