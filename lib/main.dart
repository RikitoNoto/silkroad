import 'package:flutter/material.dart';
import 'app.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/option/option_manager.dart';
import 'package:silkroad/i18n/translations.g.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  LocaleSettings.useDeviceLocale();
  runApp(const SilkRoadApp(platform: LocalPlatform(),));
}

Future initialize() async{
  await OptionManager.initialize();
}
