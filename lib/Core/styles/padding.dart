import 'package:flutter/rendering.dart';

class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;

  static const EdgeInsets paddingSmall = EdgeInsets.all(small);
  static const EdgeInsets paddingMedium = EdgeInsets.all(medium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(large);
  static const EdgeInsets paddingExtraLarge = EdgeInsets.all(extraLarge);

  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(
    horizontal: small,
  );
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(
    horizontal: medium,
  );
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(
    horizontal: large,
  );
  static const EdgeInsets horizontalExtraLarge = EdgeInsets.symmetric(
    horizontal: extraLarge,
  );

  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: small);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(
    vertical: medium,
  );
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: large);
  static const EdgeInsets verticalExtraLarge = EdgeInsets.symmetric(
    vertical: extraLarge,
  );
}
