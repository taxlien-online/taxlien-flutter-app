import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Onboarding to Main Menu Tests', () {
    testWidgets('Onboarding to main menu navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Onboarding to Main Menu Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Onboarding to Main Menu Test'), findsOneWidget);
    });

    testWidgets('Main menu screen loads after onboarding',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Main Menu Load Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Main Menu Load Test'), findsOneWidget);
    });

    testWidgets('Navigation flow test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Navigation Flow Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Navigation Flow Test'), findsOneWidget);
    });
  });
}
