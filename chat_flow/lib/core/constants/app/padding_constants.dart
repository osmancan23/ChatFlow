import 'package:flutter/material.dart';

@immutable
class PaddingConstants {
  const PaddingConstants._();

  // Genel padding değerleri
  static const double xxxSmall = 4;
  static const double xxSmall = 8;
  static const double xSmall = 12;
  static const double small = 16;
  static const double medium = 20;
  static const double large = 24;
  static const double xLarge = 32;
  static const double xxLarge = 40;

  // EdgeInsets - All
  static const EdgeInsets paddingAllXXXSmall = EdgeInsets.all(xxxSmall);
  static const EdgeInsets paddingAllXXSmall = EdgeInsets.all(xxSmall);
  static const EdgeInsets paddingAllXSmall = EdgeInsets.all(xSmall);
  static const EdgeInsets paddingAllSmall = EdgeInsets.all(small);
  static const EdgeInsets paddingAllMedium = EdgeInsets.all(medium);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(large);
  static const EdgeInsets paddingAllXLarge = EdgeInsets.all(xLarge);
  static const EdgeInsets paddingAllXXLarge = EdgeInsets.all(xxLarge);

  // EdgeInsets - Symmetric Horizontal
  static const EdgeInsets paddingHorizontalXXXSmall = EdgeInsets.symmetric(horizontal: xxxSmall);
  static const EdgeInsets paddingHorizontalXXSmall = EdgeInsets.symmetric(horizontal: xxSmall);
  static const EdgeInsets paddingHorizontalXSmall = EdgeInsets.symmetric(horizontal: xSmall);
  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: small);
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: medium);
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: large);

  // EdgeInsets - Symmetric Vertical
  static const EdgeInsets paddingVerticalXXXSmall = EdgeInsets.symmetric(vertical: xxxSmall);
  static const EdgeInsets paddingVerticalXXSmall = EdgeInsets.symmetric(vertical: xxSmall);
  static const EdgeInsets paddingVerticalXSmall = EdgeInsets.symmetric(vertical: xSmall);
  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(vertical: small);
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: medium);
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: large);

  // Custom combinations
  static const EdgeInsets paddingTextFieldContent = EdgeInsets.symmetric(
    horizontal: small,
    vertical: medium,
  );
  
  static const EdgeInsets paddingBottomSheet = EdgeInsets.fromLTRB(small, xSmall, small, small);
  
  static const EdgeInsets paddingListView = EdgeInsets.symmetric(
    horizontal: small,
    vertical: xxSmall,
  );

  static const EdgeInsets paddingCard = EdgeInsets.all(small);
} 