import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPadding {
  static double small = 8.w;
  static double medium = 16.w;
  static double large = 24.w;
  static double extraLarge = 32.w;

  static EdgeInsets get paddingSmall => EdgeInsets.all(small);
  static EdgeInsets get paddingMedium => EdgeInsets.all(medium);
  static EdgeInsets get paddingLarge => EdgeInsets.all(large);
  static EdgeInsets get paddingExtraLarge => EdgeInsets.all(extraLarge);

  static EdgeInsets get horizontalSmall =>
      EdgeInsets.symmetric(horizontal: small);
  static EdgeInsets get horizontalMedium =>
      EdgeInsets.symmetric(horizontal: medium);
  static EdgeInsets get horizontalLarge =>
      EdgeInsets.symmetric(horizontal: large);
  static EdgeInsets get horizontalExtraLarge =>
      EdgeInsets.symmetric(horizontal: extraLarge);

  static EdgeInsets get verticalSmall => EdgeInsets.symmetric(vertical: small);
  static EdgeInsets get verticalMedium =>
      EdgeInsets.symmetric(vertical: medium);
  static EdgeInsets get verticalLarge => EdgeInsets.symmetric(vertical: large);
  static EdgeInsets get verticalExtraLarge =>
      EdgeInsets.symmetric(vertical: extraLarge);
}
