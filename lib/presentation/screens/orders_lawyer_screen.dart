import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/qanony_appointment_widget.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';

class OrdersLawyerScreen extends StatelessWidget {
  const OrdersLawyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.35;
    const buttonHeight = 40.0;

    return LawyerBaseScreen(
      body: SingleChildScrollView(
        padding: AppPadding.paddingMedium,
        child: Column(
          children: List.generate(
            5,
            (index) => QanonyAppointmentCardWidget(
              name: 'الاء ايمن',
              specialty: 'جنائيات',
              description: 'اي وصف في الحياه تت تت',
              price: '\$200',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: 'قبول',
                      onTap: () {},
                      width: buttonWidth,
                      height: buttonHeight,
                      backgroundColor: AppColor.green,
                      textStyle: AppText.bodyMedium,
                    ),
                    CustomButton(
                      text: 'رفض',
                      onTap: () {},
                      width: buttonWidth,
                      height: buttonHeight,
                      backgroundColor: AppColor.primary,
                      textStyle: AppText.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
