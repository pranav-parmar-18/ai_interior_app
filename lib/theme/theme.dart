import 'package:flutter/material.dart';

String _appTheme = "lightCode";

LightCodeColors get appTheme => ThemeHelper().themeColor();

ThemeData get theme => ThemeHelper().themeData();



class ThemeHelper {

  final Map<String, LightCodeColors> _supportedCustomColor = {
    'LightCode': LightCodeColors(),
  };
  final Map<String, ColorScheme> _supportedColorScheme = {
    'LightCode': ColorSchemes.lightCodeColorScheme,
  };

  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;

    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(color: appTheme.purple300, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  LightCodeColors themeColor() => _getThemeColors();


  ThemeData themeData() => _getThemeData();
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodyLarge: TextStyle(
      color: appTheme.gray60002,
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      color: appTheme.whiteA700,
      fontSize: 24,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w800,
    ),
    labelLarge: TextStyle(
      color: appTheme.whiteA700,
      fontSize: 13,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: appTheme.gray400,
      fontSize: 11,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: appTheme.whiteA700,
      fontSize: 20,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: appTheme.whiteA700,
      fontSize: 18,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: appTheme.gray600,
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
  );
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF7F68F6),
    primaryContainer: Color.fromRGBO(0, 0, 0, 1),
    onErrorContainer: Color(0XFFFFFFFF),
    onError: Color(0XFF7E7E84),
    errorContainer: Color(0X66474749),
    onPrimary: Color(0X7FAD91FF),
    onPrimaryContainer: Color(0XFF262626),
  );
}

class LightCodeColors {
  Color get amber400 => Color(0XFFFFCA28);
  Color get amber500 => Color(0XFFFFC107);
  Color get amber600 => Color(0XFFF48400);
  Color get amber60001 => Color(0XFFFFB300);
  Color get amberA700 => Color(0XFFEDA600);
  Color get black900 => Color(0xFF000000);
  // Blue
  Color get blue500 => Color(0XFF2196F3);
  Color get blue800 => Color(0XFF156500);
  Color get blue900 => Color(0XFF0D47A1);
  Color get blueA700 => Color(0XFF0E6DFE);
  // BlueGray
  Color get deepPurple300 => Color(0XFFA662EC);
  Color get deepPurple30001 => Color(0XFF956AEC);
  // Gray
  Color get gray400 => Color(0XFFC1B383);
  Color get gray40001 => Color(0XFFBDBDBD);
  Color get gray50 => Color (0XFFF0F8FF);
  Color get gray600 => Color(0XFF7E7E84);
  Color get gray60002 => Color(0XFF7B787B);
  Color get gray700 => Color(0XFF616161);
  Color get gray7003f => Color(0X3F626262);
  Color get gray800 => Color(0XFF474749);
  Color get gray900 => Color(0XFF111111);
  // Indigo
  Color get indigoA20097 => Color(0X97716AF3);
  // IndigoA
  Color get indigoA200B2 => Color(0XB2716AF2);
  // LightBlue
  Color get lightBlue800 => Color(0XFF0386BE);
  // Pink
  Color get pink20099 => Color(0X99F683C1);
  Color get pink300 => Color(0XFFEF5592);
  Color get blueGray900 => Color(0XFF35363B);
  Color get blueGray100 => Color(0XFFD9D9D9);
  Color get deepPurple200 => Color(0XFFBAA8ED);
  Color get deepPurple4007f => Color(0X7F704FD0);
  Color get deepPurpleA200 => Color(0XFF7968F9);
  Color get deepPurpleA400 => Color(0XFF6A28EA);
  Color get gray200 => Color(0XFFF0F0F0);
  Color get gray20001 => Color(0XFFEEEEEE);
  Color get gray500 => Color(0XFF9B9BA4);
  Color get gray60001 => Color(0XFF757575);
  Color get gray90000 => Color(0X00121212);
  Color get pink200 => Color(0XFFF683C0);
  Color get pink20001 => Color(0XFFF386AB);
  Color get pink400 => Color(0XFFDA2E75);
  Color get pinkA100 => Color(0XFFEE6EC6);
  Color get pinkA10001 => Color(0XFFF9879A);
  Color get pinkA10002 => Color(0XFFF9869E);
  Color get purple300 => Color(0XFFE36FC9);
  Color get purple30001 => Color(0XFFB27CDA);
  Color get whiteA700 => Color(0XFFFFFFFF);
  Color get yellow300 => Color(0XFFFFF176);
  Color get yellow400 => Color(0XFFFFEE58);
  Color get yellow600 => Color(0XFFFDD835);
  Color get yellowA100 => Color(0XFFFFF891);
  Color get redA100 => Color(0XFFFE8C92);
}
