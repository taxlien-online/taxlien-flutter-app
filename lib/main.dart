import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'services/localization_service.dart';
import 'services/theme_service.dart';
import 'services/onboarding_service.dart';
import 'services/tax_lien_service.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/user_preferences_service.dart';
import 'screens/interactive_onboarding_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final localizationService = LocalizationService();
  final themeService = ThemeService();
  final onboardingService = OnboardingService();
  final taxLienService = TaxLienService();
  final authService = AuthService();
  final databaseService = DatabaseService();
  final userPreferencesService = UserPreferencesService();
  
  await localizationService.initialize();
  await themeService.initialize();
  await onboardingService.initialize();
  await taxLienService.initialize();
  await authService.initialize();
  await databaseService.initialize();
  await userPreferencesService.initialize();
  
  runApp(TaxLienApp(
    localizationService: localizationService,
    themeService: themeService,
    onboardingService: onboardingService,
    taxLienService: taxLienService,
    authService: authService,
    databaseService: databaseService,
    userPreferencesService: userPreferencesService,
  ));
}

class TaxLienApp extends StatelessWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;
  final UserPreferencesService userPreferencesService;
  
  const TaxLienApp({
    super.key, 
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
    required this.userPreferencesService,
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
                  ? InteractiveOnboardingScreen(
                      onboardingService: onboardingService,
                      localizationService: localizationService,
                      themeService: themeService,
                      taxLienService: taxLienService,
                      authService: authService,
                      databaseService: databaseService,
                      userPreferencesService: userPreferencesService,
                    )
                  : MainNavigationScreen(
                      localizationService: localizationService,
                      themeService: themeService,
                      onboardingService: onboardingService,
                      taxLienService: taxLienService,
                      authService: authService,
                      databaseService: databaseService,
                      userPreferencesService: userPreferencesService,
                    ),
            );
          },
        );
      },
    );
  }
}


