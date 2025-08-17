import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freedome_manager/services/onboarding_service.dart';
import 'package:freedome_manager/services/localization_service.dart';
import 'package:freedome_manager/services/theme_service.dart';
import 'package:freedome_manager/services/server_connection_service.dart';
import 'package:freedome_manager/screens/onboarding_screen.dart';
import 'package:freedome_manager/screens/main_menu_screen.dart';

void main() {
  group('Onboarding to Main Menu Transition', () {
    late OnboardingService onboardingService;
    late LocalizationService localizationService;
    late ThemeService themeService;
    late ServerConnectionService serverConnectionService;

    setUp(() async {
      onboardingService = OnboardingService();
      localizationService = LocalizationService();
      themeService = ThemeService();
      serverConnectionService = ServerConnectionService();

      await onboardingService.initialize();
      await localizationService.initialize();
      await themeService.initialize();
      await serverConnectionService.initialize();
    });

    testWidgets('should show onboarding when not completed', (WidgetTester tester) async {
      // Reset onboarding for testing
      await onboardingService.resetOnboarding();

      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onboardingService: onboardingService,
            localizationService: localizationService,
            themeService: themeService,
            serverConnectionService: serverConnectionService,
          ),
        ),
      );

      // Check that onboarding screen is displayed
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Welcome to TaxLien.online'), findsOneWidget);
    });

    testWidgets('should show main menu when onboarding completed', (WidgetTester tester) async {
      // Complete onboarding
      await onboardingService.completeOnboarding();

      await tester.pumpWidget(
        MaterialApp(
          home: onboardingService.shouldShowOnboarding()
              ? OnboardingScreen(
                  onboardingService: onboardingService,
                  localizationService: localizationService,
                  themeService: themeService,
                  serverConnectionService: serverConnectionService,
                )
              : MainMenuScreen(
                  localizationService: localizationService,
                  themeService: themeService,
                  onboardingService: onboardingService,
                  serverConnectionService: serverConnectionService,
                ),
        ),
      );

      // Check that main menu is displayed
      expect(find.byType(MainMenuScreen), findsOneWidget);
      expect(find.text('TaxLien.online'), findsOneWidget);
    });

    testWidgets('should complete onboarding and navigate to main menu', (WidgetTester tester) async {
      // Reset onboarding for testing
      await onboardingService.resetOnboarding();

      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onboardingService: onboardingService,
            localizationService: localizationService,
            themeService: themeService,
            serverConnectionService: serverConnectionService,
          ),
        ),
      );

      // Check that onboarding screen is displayed
      expect(find.byType(OnboardingScreen), findsOneWidget);

      // Go to last step
      for (int i = 0; i < onboardingService.totalSteps - 1; i++) {
        await onboardingService.nextStep();
        await tester.pump();
      }

      // Press "Get Started" button
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);
      
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();

      // Check that onboarding is completed
      expect(onboardingService.isOnboardingCompleted, isTrue);
    });

    testWidgets('should skip onboarding and navigate to main menu', (WidgetTester tester) async {
      // Reset onboarding for testing
      await onboardingService.resetOnboarding();

      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onboardingService: onboardingService,
            localizationService: localizationService,
            themeService: themeService,
            serverConnectionService: serverConnectionService,
          ),
        ),
      );

      // Check that onboarding screen is displayed
      expect(find.byType(OnboardingScreen), findsOneWidget);

      // Press "Skip" button
      final skipButton = find.text('Skip');
      expect(skipButton, findsOneWidget);
      
      await tester.tap(skipButton);
      await tester.pumpAndSettle();

      // Confirm skip
      final confirmSkipButton = find.text('Skip');
      expect(confirmSkipButton, findsOneWidget);
      
      await tester.tap(confirmSkipButton);
      await tester.pumpAndSettle();

      // Check that onboarding is skipped
      expect(onboardingService.isOnboardingSkipped, isTrue);
    });

    testWidgets('should show correct onboarding steps', (WidgetTester tester) async {
      // Reset onboarding for testing
      await onboardingService.resetOnboarding();

      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onboardingService: onboardingService,
            localizationService: localizationService,
            themeService: themeService,
            serverConnectionService: serverConnectionService,
          ),
        ),
      );

      // Check first step
      expect(find.text('Welcome to TaxLien.online'), findsOneWidget);
      expect(find.text('Your gateway to digital freedom and spiritual connection'), findsOneWidget);

      // Go to next step
      await onboardingService.nextStep();
      await tester.pump();

      // Check second step
      expect(find.text('Connect to FreeDome'), findsOneWidget);
      expect(find.text('Establish a secure connection to your FreeDome network'), findsOneWidget);

      // Go to next step
      await onboardingService.nextStep();
      await tester.pump();

      // Check third step
      expect(find.text('Dome Control'), findsOneWidget);
      expect(find.text('Control your dome settings and configurations'), findsOneWidget);
    });

    testWidgets('should show main menu with correct navigation options', (WidgetTester tester) async {
      // Complete onboarding
      await onboardingService.completeOnboarding();

      await tester.pumpWidget(
        MaterialApp(
          home: MainMenuScreen(
            localizationService: localizationService,
            themeService: themeService,
            onboardingService: onboardingService,
            serverConnectionService: serverConnectionService,
          ),
        ),
      );

      // Check for main menu elements
      expect(find.text('TaxLien.online'), findsOneWidget);
      expect(find.text('Playback Controls'), findsOneWidget);
      expect(find.text('Calibration'), findsOneWidget);
      expect(find.text('Media Files'), findsOneWidget);
      expect(find.text('Projection Settings'), findsOneWidget);
      expect(find.text('Language Settings'), findsOneWidget);
      expect(find.text('Connection Status'), findsOneWidget);
    });
  });
} 