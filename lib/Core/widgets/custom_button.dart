import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double height;
  final Color backgroundColor;
  final TextStyle textStyle;
  final IconData? icon;
  final Color textColor;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    required this.height,
    required this.backgroundColor,
    required this.textStyle,
    this.icon,
    this.textColor = AppColor.light,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: onTap == null
              ? backgroundColor.withAlpha(150)
              : backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: AppColor.dark,
                size: MediaQuery.of(context).size.width * 0.07,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(color: textColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}
