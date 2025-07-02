import 'package:flutter/material.dart';
import 'package:qanony/core/styles/color.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final EdgeInsetsGeometry contentPadding;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color cursorColor;
  final bool filled;
  final Widget? logo;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    required this.textStyle,
    required this.hintStyle,
    required this.contentPadding,
    required this.width,
    required this.height,
    required this.backgroundColor,
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
      height: height,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textDirection: TextDirection.rtl,
        style: textStyle,
        cursorColor: cursorColor,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle,
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: contentPadding,
          suffixIcon: logo != null
              ? Padding(padding: const EdgeInsets.only(right: 32), child: logo)
              : null,
        ),
      ),
    );
  }
}
