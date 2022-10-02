// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/home/home.dart';

import 'package:silkroad/main.dart';
import 'package:silkroad/send/views/send_view.dart';
import 'package:silkroad/receive/views/receive_view.dart';

void main() {
  testWidgets('display the home page when start application', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('transition to the send page when push send button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('Send')));
    await tester.pumpAndSettle();

    expect(find.byType(SendPage), findsOneWidget);
  });

  testWidgets('transition to the receive page when push receive button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('Receive')));
    await tester.pumpAndSettle();

    expect(find.byType(ReceivePage), findsOneWidget);
  });

}
