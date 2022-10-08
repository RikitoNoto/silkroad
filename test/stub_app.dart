import 'package:flutter/material.dart';
import 'package:platform/platform.dart';

class StubApp extends StatelessWidget {

  const StubApp({
    super.key,
    required this.platform,
    this.home,
  });

  final Platform platform;
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'stub app',
        home: home,
    );
  }
}
