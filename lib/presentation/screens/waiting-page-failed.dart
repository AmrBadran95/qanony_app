import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';

class WaitingPageFailed extends StatelessWidget {
  const WaitingPageFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      body: Center(
        child: Padding(
          padding: AppPadding.paddingLarge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'عمليه غير ناجحه!',
                style: AppText.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'تم رفض طلبك ! برجاء التأكد من صحه البيانات والمحاوله مره اخرى',
                style: AppText.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'العوده الي تسجيل الدخول',
                onTap: () {
                  Navigator.pop(context);
                },
                width: double.infinity,
                height: 50,
                backgroundColor: AppColor.primary,
                textStyle: AppText.bodyMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
