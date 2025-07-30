import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';

class PaymentLawyerScreen extends StatelessWidget {
  const PaymentLawyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                color: AppColor.light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.04),
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
                  SizedBox(height: size.height * 0.02),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'تفاصيل الاشتراك:',
                      style: AppText.title.copyWith(color: AppColor.dark),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
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
            SizedBox(height: size.height * 0.03),
            CustomButton(
              text: 'الغاء الاشتراك',
              onTap: () {},
              width: double.infinity,
              height: size.height * 0.06,
              backgroundColor: AppColor.primary,
              textStyle: AppText.title,
              textColor: AppColor.light,
            ),
            SizedBox(height: size.height * 0.02),
            CustomButton(
              text: 'العودة للصفحه الرئيسية',
              onTap: () {},
              width: double.infinity,
              height: size.height * 0.06,
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
