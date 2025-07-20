import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/text.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final EdgeInsetsGeometry contentPadding;
  final double width;
  final double? height;
  final Color backgroundColor;
  final Color cursorColor;
  final bool filled;
  final Widget? logo;
  final int? maxLines;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.label,
    required this.textStyle,
    required this.labelStyle,
    required this.contentPadding,
    required this.width,
    this.height,
    required this.backgroundColor,
    this.maxLines = 1,
    this.filled = false,
    this.cursorColor = AppColor.dark,
    this.logo,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textDirection: TextDirection.rtl,
        style: textStyle,
        cursorColor: cursorColor,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          filled: true,
          fillColor: backgroundColor,
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
          contentPadding: contentPadding,
          prefixIcon: logo != null
              ? Padding(padding: const EdgeInsets.only(right: 32), child: logo)
              : null,
          errorStyle: AppText.bodySmall.copyWith(color: AppColor.primary),
        ),
      ),
    );
  }
}
