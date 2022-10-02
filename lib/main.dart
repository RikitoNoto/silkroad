import 'package:flutter/material.dart';
import 'package:silkroad/home/views/home_view.dart';
import 'package:silkroad/send/views/send_view.dart';
import 'package:silkroad/receive/views/receive_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: materialWhite,
      ),
      darkTheme: ThemeData.dark(),
      // home: const HomePage(),

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
