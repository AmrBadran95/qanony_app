import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/font.dart';
import 'package:qanony/Core/styles/padding.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

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
                'برجاء الانتظار...',
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
                'تم إرسال بياناتك بنجاح ! عملية توثيق الهوية قيد المراجعه',
                style: TextStyle(
                  fontFamily: AppFont.mainFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.dark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
