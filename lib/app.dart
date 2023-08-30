import 'package:flutter/material.dart';

import 'package:platform/platform.dart';

import 'package:silkroad/home/views/home_page.dart';
import 'package:silkroad/send/views/send_page.dart';
import 'package:silkroad/receive/views/receive_page.dart';
import 'package:silkroad/option/views/option_page.dart';
import 'package:silkroad/app_theme.dart';
import 'global.dart';

class SilkRoadApp extends StatelessWidget {
  const SilkRoadApp({
    super.key,
    required this.platform,
  });

  final Platform platform;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Silk road',
        theme: AppTheme.appThemeLight,
        darkTheme: AppTheme.appThemeDark,
        navigatorObservers: [kRouteObserver],
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              {
                return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomePage(platform: platform),
                );
              }
            case '/send':
              {
                return PageRouteBuilder(
                    pageBuilder: (_, __, ___) => SendPage(platform: platform),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return _buildSlideTransition(
                          tweenBegin: const Offset(-1.0, 0.0),
                          context: context,
                          animation: animation,
                          child: child);
                    });
              }

            case '/receive':
              {
                return PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        ReceivePage(platform: platform),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return _buildSlideTransition(
                          tweenBegin: const Offset(1.0, 0.0),
                          context: context,
                          animation: animation,
                          child: child);
                    });
              }

            case '/option':
              {
                return PageRouteBuilder(
                    pageBuilder: (_, __, ___) => OptionPage(platform: platform),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return _buildSlideTransition(
                          tweenBegin: const Offset(0.0, 1.0),
                          context: context,
                          animation: animation,
                          child: child);
                    });
              }

            default:
              {
                return MaterialPageRoute(
                    builder: (context) => HomePage(platform: platform));
              }
          }
        });
  }

  Widget _buildSlideTransition(
      {Offset tweenBegin = Offset.zero,
      Offset tweenEnd = Offset.zero,
      required BuildContext context,
      required Animation<double> animation,
      required Widget child,
      Curve curve = Curves.easeInOut}) {
    final Animatable<Offset> tween =
        Tween(begin: tweenBegin, end: tweenEnd).chain(CurveTween(curve: curve));
    final Animation<Offset> offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
