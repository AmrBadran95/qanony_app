import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';

class CustomCalendar extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final EdgeInsets padding;
  final Color color;
  final TextStyle? textStyle;
  final Widget icon;

  const CustomCalendar({
    super.key,
    this.label = "اختر تاريخ الميلاد",
    this.width = double.infinity,
    this.height = 60,
    this.padding = AppPadding.paddingMedium,
    this.color = AppColor.grey,
    this.textStyle,
    this.icon = const Icon(Icons.calendar_today, color: AppColor.dark),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1700),
              lastDate: DateTime.now(),
              locale: const Locale('ar', 'EG'),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColor.secondary,
                      onPrimary: AppColor.light,
                      surface: AppColor.grey,
                      onSurface: AppColor.dark,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColor.dark,
                        textStyle: AppText.bodyLarge,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
          },
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style:
                      textStyle ??
                      AppText.bodyLarge.copyWith(color: AppColor.dark),
                ),
                icon,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
