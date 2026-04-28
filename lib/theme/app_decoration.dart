import 'package:ai_interior/theme/theme.dart';
import 'package:flutter/material.dart';

class AppDecoration {
  // Fill decorations

  static BoxDecoration get fillonErrorContainer =>
      BoxDecoration(color: theme.colorScheme.onErrorContainer);

  static BoxDecoration get fillPrimaryContainer => BoxDecoration(
    color: theme.colorScheme.primaryContainer.withValues(alpha: 1),
  );

  static BoxDecoration get fillWhiteA => BoxDecoration(
    color: appTheme.whiteA700
  );

  // Gradient decorations
  static BoxDecoration get gradientGrayToPrimaryContainer => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(0.5, 0),

      end: Alignment(0.5, 1),
      colors: [
        appTheme.gray90000,
        theme.colorScheme.primaryContainer.withValues(alpha: 1),
      ],
    ),
  );

  static BoxDecoration get gradientPinkToIndigoAB => BoxDecoration(
    border: Border.all(color: appTheme.whiteA700, width: 0.5),

    gradient: LinearGradient(

      colors: [
        Color.fromRGBO(246, 131, 193, 1),
        Color.fromRGBO(246, 131, 193, 0.6),
        Color.fromRGBO(0, 0, 0, 0.4),
        Color.fromRGBO(113, 106, 243, 0.59),
        Color.fromRGBO(113, 106, 243, 0.7)

      ],
    ),
  );

  // Outline decorations
  static BoxDecoration get outline => BoxDecoration();

  static BoxDecoration get outlineGray => BoxDecoration(
    color: Color(0XFF19191C),
    border: Border.all(color: appTheme.gray800, width: 1),
  );

  static BoxDecoration get outlineGrayF => BoxDecoration(
    color: theme.colorScheme.primary,
    border: Border.all(color: appTheme.gray7003f, width: 1),
  );
}

class BorderRadiusStyle {
  // Circle borders

  static BorderRadius get circleBorder142 => BorderRadius.circular(
    142,

    // Rounded borders
  );static BorderRadius get circleBorder14 => BorderRadius.circular(
    14,

    // Rounded borders
  );

  static BorderRadius get roundedBorder24 => BorderRadius.circular(24);

  static BorderRadius get roundedBorder12 => BorderRadius.circular(12);

  static BorderRadius get roundedBorder164 => BorderRadius.circular(164);

  static BorderRadius get roundedBorder30 => BorderRadius.circular(30);
}
