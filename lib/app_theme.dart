import 'package:flutter/material.dart';

class AppTheme{

  static const Color _backgroundColorLight = Colors.white;
  static const Color _backgroundColorDark = Colors.black;
  static final Color? _secondaryBackgroundColorLight = Colors.grey[100];
  static final Color? _secondaryBackgroundColorDark = Colors.grey[600];
  static const Color _foregroundColorLight = Colors.black;
  static const Color _foregroundColorDark = Colors.white;
  static final Color? _foregroundColorDisableLight = Colors.grey[600];
  static final Color? _foregroundColorDisableDark = Colors.grey[600];

  static const double _appBarElevation = 0.0;

  static const Color _appBackgroundColorLight = Color(0xFFFFFFFF);
  static const Color _appBarColorLight = _appBackgroundColorLight;
  static const Color _elevatedButtonColorLight = Color(0xFFFAFAFA);

  static const Color _appBackgroundColorDark = Color(0xFF303030);
  static const Color _appBarColorDark = _appBackgroundColorDark;
  static const Color _elevatedButtonColorDark = Color(0xFF505050);
  static const Color _iconColorDark = Color(0xFFFFFFFF);

  static const Color _appIconColorLightBlue = Color(0xFF38B6FF);
  static const Color _appIconColorGrassGreen = Color(0xFF7ED957);

  static const Color appIconColor1 = _appIconColorLightBlue;
  static const Color appIconColor2 = _appIconColorGrassGreen;

  static const String appFontFamily = 'Noto_Sans_JP';

  static const MaterialColor materialWhite = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50  : Color(0xFFFFFFFF),
      100 : Color(0xFFFFFFFF),
      200 : Color(0xB3FFFFFF),
      300 : Color(0x99FFFFFF),
      400 : Color(0x8AFFFFFF),
      500 : Color(0x62FFFFFF),
      600 : Color(0x4DFFFFFF),
      700 : Color(0x3DFFFFFF),
      800 : Color(0x1FFFFFFF),
      900 : Color(0x1FFFFFFF),
    },
  );

  static const MaterialColor materialBlack = MaterialColor(
    0xFF000000,
    <int, Color>{
      50  : Color(0xDD000000),
      100 : Color(0x8A000000),
      200 : Color(0x73000000),
      300 : Color(0x61000000),
      400 : Color(0x42000000),
      500 : Color(0x1F000000),
      600 : Color(0x4DFFFFFF),
      700 : Color(0x3DFFFFFF),
      800 : Color(0x1FFFFFFF),
      900 : Color(0x1FFFFFFF),
    },
  );

  /// app theme light
  static final ThemeData appThemeLight = ThemeData(
    primarySwatch: materialWhite,
    appBarTheme: const AppBarTheme(
      color: _appBarColorLight,
      elevation: _appBarElevation,
    ),
    scaffoldBackgroundColor: _appBackgroundColorLight,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(_elevatedButtonColorLight),
      ),
    ),
    fontFamily: appFontFamily,
  );

  /// app theme dark
  static final ThemeData appThemeDark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      color: _appBarColorDark,
      elevation: _appBarElevation,
    ),
    scaffoldBackgroundColor: _appBackgroundColorDark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(_elevatedButtonColorDark),
      ),
    ),

    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: appFontFamily,
    ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
      fontFamily: appFontFamily,
    ),
  );

  static Color getSecondaryBackgroundColor(BuildContext context){
    Color? backgroundColor;
    if(MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      backgroundColor = _secondaryBackgroundColorLight!;
    }
    else{
      backgroundColor = _secondaryBackgroundColorDark!;
    }
    return backgroundColor;
  }

  static Color getForegroundColor(BuildContext context){

    Color foregroundColor;
    if(MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      foregroundColor = _foregroundColorLight;
    }
    else{
      foregroundColor = _foregroundColorDark;
    }
    return foregroundColor;
  }

  static Color getForegroundDisableColor(BuildContext context){

    Color foregroundColor;
    if(MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      foregroundColor = _foregroundColorDisableLight!;
    }
    else{
      foregroundColor = _foregroundColorDisableDark!;
    }
    return foregroundColor;
  }

  static Color getBackgroundColor(BuildContext context){
    Color backgroundColor;
    if(MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      backgroundColor = _backgroundColorLight;
    }
    else{
      backgroundColor = _backgroundColorDark;
    }
    return backgroundColor;
  }

  static Color getButtonForegroundColor(BuildContext context, bool enable){
    return enable ? getForegroundColor(context) : getForegroundDisableColor(context);
  }
}
