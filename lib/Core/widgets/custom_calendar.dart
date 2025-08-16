import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/text.dart';

class CustomCalendar extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color color;
  final TextStyle? textStyle;
  final Widget icon;
  final bool prevOnly;
  final DateTime? selectedDate;
  final void Function(DateTime)? onDateSelected;

  const CustomCalendar({
    super.key,
    required this.label,
    this.width = double.infinity,
    this.height,
    this.padding,
    this.color = AppColor.grey,
    this.textStyle,
    this.icon = const Icon(Icons.calendar_today, color: AppColor.dark),
    this.prevOnly = false,
    this.selectedDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: selectedDate != null ? label : null,
        labelStyle: AppText.bodySmall.copyWith(color: AppColor.dark),
        filled: true,
        fillColor: color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.dark),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.dark, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.dark, width: 1),
        ),
        contentPadding: padding,
      ),
      child: InkWell(
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(1700),
            lastDate: prevOnly
                ? DateTime.now()
                : DateTime.now().add(const Duration(days: 730)),
            locale: const Locale('ar', 'EG'),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.primary,
                    onPrimary: AppColor.light,
                    surface: AppColor.grey,
                    onSurface: AppColor.dark,
                  ),
                  textTheme: TextTheme(
                    titleLarge: AppText.title,
                    bodyLarge: AppText.bodyLarge,
                    bodyMedium: AppText.bodyMedium,
                    labelLarge: AppText.bodySmall,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.dark,
                      textStyle: AppText.bodySmall,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null && onDateSelected != null) {
            onDateSelected!(pickedDate);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? "${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}"
                  : label,
              style:
                  textStyle ??
                  AppText.bodyMedium.copyWith(color: AppColor.dark),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
