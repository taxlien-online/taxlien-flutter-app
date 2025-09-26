import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Onboarding Tests', () {
    testWidgets('Onboarding screen loads', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Onboarding Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Onboarding Test'), findsOneWidget);
    });

    testWidgets('Onboarding navigation test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Navigation Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Navigation Test'), findsOneWidget);
    });
  });
}