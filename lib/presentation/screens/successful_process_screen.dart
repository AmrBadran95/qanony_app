import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';

class SuccessfulProcessScreen extends StatelessWidget {
  const SuccessfulProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: Text(
          'عملية ناجحـة',
          style: AppText.headingLarge.copyWith(color: AppColor.light),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPadding.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: size.height * 0.7,
              padding: AppPadding.paddingMedium,
              decoration: BoxDecoration(
                color: AppColor.light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 100,
                        color: AppColor.green,
                      ),
                      SizedBox(height: size.height * 0.015),
                      Text(
                        'تم الاشتراك بنجاح',
                        style: AppText.headingLarge.copyWith(
                          color: AppColor.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        'تفاصيل الاشتراك:',
                        style: AppText.headingMedium.copyWith(
                          color: AppColor.dark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'التاريخ: 22/2/2002',
                        style: AppText.headingMedium.copyWith(
                          color: AppColor.dark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'السعر: \$300',
                        style: AppText.headingMedium.copyWith(
                          color: AppColor.dark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'رقم العملية: 2343948387436',
                        style: AppText.headingMedium.copyWith(
                          color: AppColor.dark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'وسيلة الدفع: تحويل بنكي',
                        style: AppText.headingMedium.copyWith(
                          color: AppColor.dark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  CustomButton(
                    text: 'مشاركة',
                    onTap: () {},
                    width: double.infinity,
                    height: 50,
                    backgroundColor: AppColor.primary,
                    textStyle: AppText.title,
                    textColor: AppColor.light,
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.03),
            CustomButton(
              text: 'العودة للصفحة الرئيسية',
              onTap: () {},
              width: double.infinity,
              height: 50,
              backgroundColor: AppColor.secondary,
              textStyle: AppText.title,
              textColor: AppColor.dark,
            ),
          ],
        ),
      ),
    );
  }
}
