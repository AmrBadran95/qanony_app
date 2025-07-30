import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';

class Alaa extends StatelessWidget {
  const Alaa({super.key});

  double responsivePadding(BuildContext context, double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (basePadding / 375) * screenWidth;
  }

  @override
  Widget build(BuildContext context) {
    final paddingValue = responsivePadding(context, AppPadding.medium);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingValue),
        child: Center(
          child: Text(
            "حسبي الله و نعم الوكيل فيكي يا الاااااااااااااااء",
            style: AppText.headingLarge.copyWith(color: AppColor.primary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
