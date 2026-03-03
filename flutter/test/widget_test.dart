import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mycoach/main.dart';

void main() {
  testWidgets('MyCoach smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyCoachApp());

    // Verify that our welcome text is displayed.
    expect(find.text('Bienvenue dans MyCoach'), findsOneWidget);
    expect(find.text('Votre application de coaching sportif'), findsOneWidget);
  });
}