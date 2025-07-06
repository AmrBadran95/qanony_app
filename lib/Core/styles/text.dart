import 'package:flutter/rendering.dart';
import 'package:qanony/core/styles/font.dart';

class AppText {
  static const TextStyle appHeading = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headingLarge = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headingMedium = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle title = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFont.mainFont,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
}
