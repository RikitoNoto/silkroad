import 'package:flutter/material.dart';
import 'package:silkroad/home/views/home_view.dart';
import 'package:silkroad/send/views/send_view.dart';
import 'package:silkroad/receive/views/receive_view.dart';

class SilkRoadApp extends StatelessWidget {
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

  const SilkRoadApp({super.key});

  static const double _appBarElevation = 0.4;
  static const Color _appBackgroundColorLight = Color(0xFFFFFFFF);
  static const Color _appBarColorLight = _appBackgroundColorLight;
  static const Color _elevatedButtonColorLight = Color(0xFFFAFAFA);

  static const Color _appBackgroundColorDark = Color(0xFF303030);
  static const Color _appBarColorDark = _appBackgroundColorDark;
  static const Color _elevatedButtonColorDark = Color(0xFF505050);


  /// light theme
  static final ThemeData _appThemeLight = ThemeData(
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
  );

  /// dark theme
  static final ThemeData _appThemeDark = ThemeData.dark().copyWith(
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
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Silk road',
        theme: _appThemeLight,
        darkTheme: _appThemeDark,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch(settings.name) {
            case '/': {
              return PageRouteBuilder(
                pageBuilder: (_, __, ___)=> const HomePage(),
              );
            }
            case '/send': {
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___)=> const SendPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child){
                    return _buildSlideTransition(tweenBegin: const Offset(-1.0, 0.0), context: context, animation: animation, child: child);
                  }
              );
            }

            case '/receive': {
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___)=> const ReceivePage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child){
                    return _buildSlideTransition(tweenBegin: const Offset(1.0, 0.0), context: context, animation: animation, child: child);
                  }
              );
            }
            default: {
              return MaterialPageRoute(builder: (context) => const HomePage());
            }
          }
        }
    );
  }

  Widget _buildSlideTransition({Offset tweenBegin = Offset.zero, Offset tweenEnd = Offset.zero, required BuildContext context, required Animation<double> animation, required Widget child, Curve curve=Curves.easeInOut}){
    final Animatable<Offset> tween = Tween(begin: tweenBegin, end: tweenEnd).chain(CurveTween(curve: curve));
    final Animation<Offset> offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
