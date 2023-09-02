import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:silkroad/version/version.dart';
import 'app.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/option/option_manager.dart';
import 'package:silkroad/i18n/translations.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final version = Version();
  DartPingIOS.register();
  await initialize();
  LocaleSettings.useDeviceLocale();
  runApp(SilkRoadApp(
    platform: const LocalPlatform(),
    version: version,
  ));
}

Future initialize() async {
  await OptionManager.initialize();
}
