import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';

class OnboardingPage extends StatelessWidget {
  final String text;
  final String imagePath;
  final String paragraph;

  const OnboardingPage({
    super.key,
    required this.text,
    required this.imagePath,
    required this.paragraph,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: AppColor.primary),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Text(text, style: AppText.bodyLarge.copyWith(color: AppColor.grey)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),

            Text(
              paragraph,
              style: AppText.bodySmall.copyWith(color: AppColor.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
