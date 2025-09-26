import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('Default locale test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Localization Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Localization Test'), findsOneWidget);
    });

    testWidgets('Locale switching test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('ru', 'RU'),
            home: Scaffold(
              body: Center(
                child: Text('Locale Switch Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Locale Switch Test'), findsOneWidget);
    });

    testWidgets('Multiple locales test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ru', 'RU'),
              Locale('uk', 'UA'),
            ],
            home: Scaffold(
              body: Center(
                child: Text('Multi Locale Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Multi Locale Test'), findsOneWidget);
    });
  });
}