import 'package:flutter/material.dart';
import 'package:silkroad/home/views/home_view.dart';
import 'package:silkroad/send/views/send_view.dart';
import 'package:silkroad/receive/views/receive_view.dart';

void main() {
  runApp(const SilkRoadApp());
}

class SilkRoadApp extends StatelessWidget {
  final MaterialColor materialWhite = const MaterialColor(
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

  final MaterialColor materialBlack = const MaterialColor(
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silk road',
      theme: ThemeData(
        primarySwatch: materialWhite,
      ),
      darkTheme: ThemeData.dark().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          ),
        ),
      ),
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
