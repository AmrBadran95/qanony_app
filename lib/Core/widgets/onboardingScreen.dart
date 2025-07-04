import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';

import 'package:flutter/material.dart';

class onboardingPage extends StatelessWidget {
  final String text;
  final String imagePath;
  final String paragraph;

  const onboardingPage({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.paragraph,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        Text(
          text,
          style: AppText.title.copyWith(
            color: AppColor.grey,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.06),

        Text(
          paragraph,
          style: AppText.bodySmall.copyWith(
            color: AppColor.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
