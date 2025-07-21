import 'package:flutter/material.dart';

import '../styles/color.dart';
import '../styles/padding.dart';
import '../styles/text.dart';

class SubscriptionCard extends StatelessWidget {
  final String label;
  final Color labelColor;
  final IconData icon;
  final String priceText;
  final String title;
  final String option1;
  final String option2;
  final String option3;
  final String text1;
  final String text2;
  final String text3;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.label,
    required this.labelColor,
    required this.icon,
    required this.priceText,
    required this.title,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: AppPadding.paddingSmall,
            decoration: BoxDecoration(
              color: AppColor.light.withOpacity(0.8),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColor.primary, width: 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.028,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: AppText.headingMedium.copyWith(color: AppColor.dark),
                        ),
                        Text(
                          option1,
                          style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.stars,
                              color: AppColor.secondary,
                              size: MediaQuery.of(context).size.width * .03,
                            ),
                            Text(
                              text1,
                              style: AppText.labelSmall.copyWith(color: AppColor.dark.withOpacity(.5)),
                            ),
                          ],
                        ),
                        Text(
                          option2,
                          style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.stars,
                              color: AppColor.secondary,
                              size: MediaQuery.of(context).size.width * .03,
                            ),
                            Text(
                              text2,
                              style: AppText.labelSmall.copyWith(color: AppColor.dark.withOpacity(.5)),
                            ),
                          ],
                        ),
                        Text(
                          option3,
                          style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.stars,
                              color: AppColor.secondary,
                              size: MediaQuery.of(context).size.width * .03,
                            ),
                            Text(
                              text3,
                              style: AppText.labelSmall.copyWith(color: AppColor.dark.withOpacity(.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * .05),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.028,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .2,
                        height: MediaQuery.of(context).size.height * 0.075,
                        decoration: BoxDecoration(
                          color: labelColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            color: AppColor.light,
                            size: MediaQuery.of(context).size.width * .13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColor.dark, AppColor.grey],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: Text(
                          priceText,
                          style: AppText.bodyMedium.copyWith(
                            color: AppColor.light,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
            child: Container(
              width: MediaQuery.of(context).size.width * .25,
              height: MediaQuery.of(context).size.height * .03,
              color: labelColor,
              alignment: Alignment.center,
              child: Text(
                label,
                style: AppText.bodySmall.copyWith(color: AppColor.light),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
