// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mycoach/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyTrainerApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('App title test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyTrainerApp());

    // Verify that the app shows the my-trainer title
    expect(find.text('my-trainer'), findsOneWidget);
    expect(find.text('Welcome to my-trainer:'), findsOneWidget);
    expect(find.text('Your personal training companion'), findsOneWidget);
  });

  testWidgets('MyTrainerApp widget instantiation test', (WidgetTester tester) async {
    // Test that the MyTrainerApp can be instantiated
    const app = MyTrainerApp();
    expect(app, isA<StatelessWidget>());
    expect(app.runtimeType.toString(), 'MyTrainerApp');
  });
}