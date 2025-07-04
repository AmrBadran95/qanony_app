import 'package:flutter/material.dart';
import 'package:qanony/Core/shared/Decider.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class splashscreen extends StatelessWidget {
  const splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SplashScreenView(
      navigateRoute: Decider(),
      duration: 5000,
      imageSize: 400,
      imageSrc: "assets/images/Logo.png",
      text:
      '''قانوني  
      
       
للمحـاماة و الأستشارات القانونية 
      ''',
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 26.0,
      ),
      colors: [
        AppColor.grey,
        AppColor.light


      ],

      backgroundColor: AppColor.primary,

    );
  }
}
