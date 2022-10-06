import 'package:flutter/material.dart';
import 'app.dart';
import 'package:platform/platform.dart';

void main() {
  runApp(const SilkRoadApp(platform: LocalPlatform(),));
}

