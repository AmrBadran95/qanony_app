import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';

class Alaa extends StatelessWidget {
  const Alaa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "حسبي الله و نعم الوكيل فيكي يا الاااااااااااااااء",
          style: AppText.headingLarge.copyWith(color: AppColor.primary),
        ),
      ),
    );
  }
}
