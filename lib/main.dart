import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'services/localization_service.dart';
import 'services/theme_service.dart';
import 'services/onboarding_service.dart';
import 'services/tax_lien_service.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация сервисов
  final localizationService = LocalizationService();
  final themeService = ThemeService();
  final onboardingService = OnboardingService();
  final taxLienService = TaxLienService();
  final authService = AuthService();
  final databaseService = DatabaseService();
  
  await localizationService.initialize();
  await themeService.initialize();
  await onboardingService.initialize();
  await taxLienService.initialize();
  await authService.initialize();
  await databaseService.initialize();
  
  runApp(TaxLienApp(
    localizationService: localizationService,
    themeService: themeService,
    onboardingService: onboardingService,
    taxLienService: taxLienService,
    authService: authService,
    databaseService: databaseService,
  ));
}

class TaxLienApp extends StatelessWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;
  
  const TaxLienApp({
    super.key, 
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: themeService,
          builder: (context, child) {
            return MaterialApp(
              title: 'TaxLien Marketplace',
              locale: localizationService.currentLocale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeService.themeMode,
              home: onboardingService.shouldShowOnboarding()
                  ? OnboardingScreen(
                      onboardingService: onboardingService,
                      localizationService: localizationService,
                      themeService: themeService,
                      taxLienService: taxLienService,
                      authService: authService,
                      databaseService: databaseService,
                    )
                  : MainNavigationScreen(
                      localizationService: localizationService,
                      themeService: themeService,
                      onboardingService: onboardingService,
                      taxLienService: taxLienService,
                      authService: authService,
                      databaseService: databaseService,
                    ),
            );
          },
        );
      },
    );
  }
}


