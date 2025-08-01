import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/core/styles/font.dart';

class AppText {
  static TextStyle get appHeading => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get headingLarge => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get headingMedium => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get title => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get labelLarge => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
  );
}
