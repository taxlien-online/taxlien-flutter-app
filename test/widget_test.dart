// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:freedome_manager/main.dart';
import 'package:freedome_manager/services/localization_service.dart';
import 'package:freedome_manager/services/theme_service.dart';
import 'package:freedome_manager/services/onboarding_service.dart';

void main() {
  testWidgets('FreeDome app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final localizationService = LocalizationService();
    final themeService = ThemeService();
    final onboardingService = OnboardingService();
    
    await localizationService.initialize();
    await themeService.initialize();
    await onboardingService.initialize();
    
    await tester.pumpWidget(FreeDomeApp(
      localizationService: localizationService,
      themeService: themeService,
      onboardingService: onboardingService,
    ));

    // Verify that the app title is displayed
    expect(find.text('TaxLien.online'), findsOneWidget);
  });
}
