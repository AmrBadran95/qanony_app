import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';


Widget onboardingPage({
  required String text,
  required imagepath,
  required String paragraph,
  required BuildContext context,


}) {


  return Column(

      children: [
        Image.asset(imagepath,width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.3,),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        Text(text,
        style: AppText.title.copyWith(
        color: AppColor.grey
    ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.06),

        Text(paragraph,
          style: AppText.bodySmall.copyWith(
            color: AppColor.secondary,

          ),
          textAlign: TextAlign.center,
        )

      ],
    );

}