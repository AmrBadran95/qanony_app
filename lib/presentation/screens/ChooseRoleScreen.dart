import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';

import '../../Core/widgets/RoleContainer.dart';


class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
            body:    Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColor.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  RoleContainer(
                    color: AppColor.primary,
                    onTap: () {
                      // Handle tap for User role
                    },

                    context: context,
                    text1: "أنا محامى",
                    text2: "كمحامٍ، يمكنك تقديم خدماتك، إدارة جلساتك، والتواصل مع عملائك بسهولة.",
                    text3: "ابدأ رحلتك القانونية الآن.",
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
                  RoleContainer(
                    color: AppColor.secondary,
                    onTap: () {
                      // Handle tap for User role
                    },

                    context: context,
                    text1: "أنا عميل",
                    text2: "كعميل، يمكنك حجز جلسة مع محامٍ، طرح استشاراتك، وتتبع حالتك القانونية بكل سهولة.",
                    text3: "ابدأ رحلتك نحو حل قانوني واضح.",
                    textColor: AppColor.dark,
                  )
                ],
              ),
            ),


    );
  }
}
