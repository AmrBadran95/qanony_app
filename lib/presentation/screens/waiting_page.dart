import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

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
                style: AppText.headingMedium.copyWith(color: AppColor.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.sp),
              Text(
                '.تم إرسال بياناتك بنجاح ! عملية توثيق الهوية قيد المراجعه',
                style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
