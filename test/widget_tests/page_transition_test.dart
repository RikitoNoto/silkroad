// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:silkroad/home/home.dart';

import 'package:silkroad/app.dart';
import 'package:silkroad/send/send.dart';
import 'package:silkroad/receive/receive.dart';
import 'package:silkroad/parameter.dart';
import 'package:silkroad/version/version.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  Map<String, Object> map = <String, Object>{};
  map[Params.name.toString()] = '';
  SharedPreferences.setMockInitialValues(map);
  await OptionManager.initialize();

  testWidgets('display the home page when start application',
      (WidgetTester tester) async {
    // Since Future processing is performed in initState, runAsync.
    await tester.runAsync(() async {
      await tester.pumpWidget(SilkRoadApp(
        platform: const LocalPlatform(),
        version: VersionWithGithubApi.forTest(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  testWidgets('transition to the send page when push send button',
      (WidgetTester tester) async {
    // Since Future processing is performed in initState, runAsync.
    await tester.runAsync(() async {
      await tester.pumpWidget(SilkRoadApp(
        platform: const LocalPlatform(),
        version: VersionWithGithubApi.forTest(),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('Send')));
      await tester.pumpAndSettle();

      expect(find.byType(SendPage), findsOneWidget);
    });
  });

  testWidgets('transition to the receive page when push receive button',
      (WidgetTester tester) async {
    // Since Future processing is performed in initState, runAsync.
    await tester.runAsync(() async {
      await tester.pumpWidget(SilkRoadApp(
        platform: const LocalPlatform(),
        version: VersionWithGithubApi.forTest(),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('Receive')));
      await tester.pumpAndSettle();

      expect(find.byType(ReceivePage), findsOneWidget);
    });
  });
}
