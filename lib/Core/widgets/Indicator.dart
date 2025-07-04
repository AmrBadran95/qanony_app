import 'package:flutter/material.dart';
import '../styles/color.dart';

class Indicator extends StatelessWidget {
  final bool active;
  final double width;
  final Color activeColor;
  final Color inactiveColor;
  final double radius;
  final double height;

  const Indicator({
    super.key,
    required this.active,
    this.width = 30,
    this.activeColor = AppColor.secondary,
    this.inactiveColor = AppColor.grey,
    this.radius = 100,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? width : 10,
      height: height,
      decoration: BoxDecoration(
        color: active ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
