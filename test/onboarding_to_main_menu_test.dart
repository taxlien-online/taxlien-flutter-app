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
      // Сбрасываем онбординг для тестирования
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

      // Проверяем, что отображается экран онбординга
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Welcome to FreeDome Manager'), findsOneWidget);
    });

    testWidgets('should show main menu when onboarding completed', (WidgetTester tester) async {
      // Завершаем онбординг
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

      // Проверяем, что отображается главное меню
      expect(find.byType(MainMenuScreen), findsOneWidget);
      expect(find.text('FreeDome Manager'), findsOneWidget);
    });

    testWidgets('should complete onboarding and navigate to main menu', (WidgetTester tester) async {
      // Сбрасываем онбординг для тестирования
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

      // Проверяем, что отображается экран онбординга
      expect(find.byType(OnboardingScreen), findsOneWidget);

      // Переходим к последнему шагу
      for (int i = 0; i < onboardingService.totalSteps - 1; i++) {
        await onboardingService.nextStep();
        await tester.pump();
      }

      // Нажимаем кнопку "Get Started"
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);
      
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();

      // Проверяем, что онбординг завершен
      expect(onboardingService.isOnboardingCompleted, isTrue);
    });

    testWidgets('should skip onboarding and navigate to main menu', (WidgetTester tester) async {
      // Сбрасываем онбординг для тестирования
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

      // Проверяем, что отображается экран онбординга
      expect(find.byType(OnboardingScreen), findsOneWidget);

      // Нажимаем кнопку "Skip"
      final skipButton = find.text('Skip');
      expect(skipButton, findsOneWidget);
      
      await tester.tap(skipButton);
      await tester.pumpAndSettle();

      // Подтверждаем пропуск
      final confirmSkipButton = find.text('Skip');
      expect(confirmSkipButton, findsOneWidget);
      
      await tester.tap(confirmSkipButton);
      await tester.pumpAndSettle();

      // Проверяем, что онбординг пропущен
      expect(onboardingService.isOnboardingSkipped, isTrue);
    });

    testWidgets('should show correct onboarding steps', (WidgetTester tester) async {
      // Сбрасываем онбординг для тестирования
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

      // Проверяем первый шаг
      expect(find.text('Welcome to FreeDome Manager'), findsOneWidget);
      expect(find.text('Your gateway to digital freedom and spiritual connection'), findsOneWidget);

      // Переходим к следующему шагу
      await onboardingService.nextStep();
      await tester.pump();

      // Проверяем второй шаг
      expect(find.text('Connect to FreeDome'), findsOneWidget);
      expect(find.text('Establish a secure connection to your FreeDome network'), findsOneWidget);

      // Переходим к следующему шагу
      await onboardingService.nextStep();
      await tester.pump();

      // Проверяем третий шаг
      expect(find.text('Dome Control'), findsOneWidget);
      expect(find.text('Control your dome settings and configurations'), findsOneWidget);
    });

    testWidgets('should show main menu with correct navigation options', (WidgetTester tester) async {
      // Завершаем онбординг
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

      // Проверяем наличие основных элементов меню
      expect(find.text('FreeDome Manager'), findsOneWidget);
      expect(find.text('Playback Controls'), findsOneWidget);
      expect(find.text('Calibration'), findsOneWidget);
      expect(find.text('Media Files'), findsOneWidget);
      expect(find.text('Projection Settings'), findsOneWidget);
      expect(find.text('Language Settings'), findsOneWidget);
      expect(find.text('Connection Status'), findsOneWidget);
    });
  });
} 