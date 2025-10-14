import 'package:flutter/material.dart';
import '../services/onboarding_service.dart';
import '../services/onboarding_data_provider.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/user_preferences_service.dart';
import 'onboarding_screen.dart';
import '../main.dart' show SimpleHomeScreen;

/// App router screen that decides whether to show onboarding or main screen
class AppRouterScreen extends StatefulWidget {
  const AppRouterScreen({super.key});

  @override
  State<AppRouterScreen> createState() => _AppRouterScreenState();
}

class _AppRouterScreenState extends State<AppRouterScreen> {
  bool _isChecking = true;
  bool _shouldShowOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    try {
      final onboardingService = OnboardingService();
      await onboardingService.initialize();

      // Check if we should show onboarding
      final shouldShow = onboardingService.shouldShowOnboarding();

      setState(() {
        _shouldShowOnboarding = shouldShow;
        _isChecking = false;
      });
    } catch (e) {
      // If error, skip onboarding
      setState(() {
        _shouldShowOnboarding = false;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_shouldShowOnboarding) {
      return OnboardingScreen(
        localizationService: LocalizationService(),
        themeService: ThemeService(),
        onboardingService: OnboardingService(),
        taxLienService: TaxLienService(),
        authService: AuthService(),
        databaseService: DatabaseService(),
        userPreferencesService: UserPreferencesService(),
      );
    }

    return const SimpleHomeScreen();
  }
}
