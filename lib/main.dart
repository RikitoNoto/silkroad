import 'package:flutter/material.dart';
import 'app.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/option/option_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(const SilkRoadApp(platform: LocalPlatform(),));
}

Future initialize() async{
  await OptionManager.initialize();
}
//TODO: i18n
