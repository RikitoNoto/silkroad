// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:platform/platform.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:silkroad/app.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';
import 'package:silkroad/receive/receive.dart';

@GenerateMocks([ReceiveProvider])
void main() {
  group('ip selector test', () {
    testWidgets('should be display an ip address any of the address list', (WidgetTester tester) async {
      await tester.pumpWidget(const ReceivePage(platform: LocalPlatform()));
      await tester.pumpAndSettle();





      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });
  });
}
