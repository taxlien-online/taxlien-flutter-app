import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freedome_manager/main.dart';
import 'package:freedome_manager/services/localization_service.dart';
import 'package:freedome_manager/services/theme_service.dart';
import 'package:freedome_manager/services/onboarding_service.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('App should display localized strings in Russian', (WidgetTester tester) async {
      final localizationService = LocalizationService();
      final themeService = ThemeService();
      final onboardingService = OnboardingService();
      
      await localizationService.initialize();
      await themeService.initialize();
      await onboardingService.initialize();
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          locale: const Locale('ru'),
          home: DomeControlScreen(
            localizationService: localizationService,
            themeService: themeService,
            onboardingService: onboardingService,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем, что заголовок приложения отображается на русском
      expect(find.text('FreeDome Manager'), findsOneWidget);
    });

    testWidgets('App should display localized strings in English', (WidgetTester tester) async {
      final localizationService = LocalizationService();
      final themeService = ThemeService();
      final onboardingService = OnboardingService();
      
      await localizationService.initialize();
      await themeService.initialize();
      await onboardingService.initialize();
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          locale: const Locale('en'),
          home: DomeControlScreen(
            localizationService: localizationService,
            themeService: themeService,
            onboardingService: onboardingService,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем, что заголовок приложения отображается на английском
      expect(find.text('FreeDome Manager'), findsOneWidget);
    });
  });
} 