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
      // 50  : Color(0x1AFFFFFF),
      // 100 : Color(0x1FFFFFFF),
      // 200 : Color(0x3DFFFFFF),
      // 300 : Color(0x4DFFFFFF),
      // 400 : Color(0x62FFFFFF),
      // 500 : Color(0x8AFFFFFF),
      // 600 : Color(0x99FFFFFF),
      // 700 : Color(0xB3FFFFFF),
      // 800 : Color(0xFFFFFFFF),
      // 900 : Color(0xFFFFFFFF),
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
      routes: {
        '/' : (context) => const HomePage(),
        '/send' : (context) => const SendPage(),
        '/receive' : (context) => const ReceivePage(),
      },
    );
  }
}
