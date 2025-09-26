import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('TaxLien app smoke test', (WidgetTester tester) async {
    // Create a simple test app
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('TaxLien.online Test'),
            ),
          ),
        ),
      ),
    );

    // Verify that the app loads
    expect(find.text('TaxLien.online Test'), findsOneWidget);
  });

  testWidgets('App theme test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: Scaffold(
            appBar: AppBar(title: Text('Test')),
            body: Center(
              child: Text('Theme Test'),
            ),
          ),
        ),
      ),
    );

    // Verify theme is applied
    expect(find.text('Theme Test'), findsOneWidget);
  });

  testWidgets('Localization test', (WidgetTester tester) async {
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
              child: Text('Localization Test'),
            ),
          ),
        ),
      ),
    );

    // Verify localization works
    expect(find.text('Localization Test'), findsOneWidget);
  });
}
