import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/font.dart';
import 'package:qanony/Core/styles/padding.dart';

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
                style: TextStyle(
                  fontFamily: AppFont.mainFont,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'تم رفض طلبك ! برجاء التأكد من صحه البيانات والمحاوله مره اخرى',
                style: TextStyle(
                  fontFamily: AppFont.mainFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.dark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // لما ندوس علي الزرار هنشوف بقي نروح فين دا الزرار بتاع تسجيل الدخول
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: AppPadding.paddingMedium,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'العوده الي تسجيل الدخول',
                    style: TextStyle(
                      fontFamily: AppFont.mainFont,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
