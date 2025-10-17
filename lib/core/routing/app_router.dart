import 'package:flutter/material.dart';
import '../../screens/main_navigation_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/search_screen.dart';
import '../../screens/marketplace_screen.dart';
import '../../screens/portfolio_dashboard_screen.dart';
import '../../screens/ai_advisor_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/nft_dashboard_screen.dart';
import '../../screens/main_menu_screen.dart';
import '../../screens/admin_panel_screen.dart';
import '../../screens/calibration_screen.dart';
import '../../screens/connection_status_screen.dart';
import '../../screens/language_settings_screen.dart';
import '../../screens/marketplace_packages_screen.dart';
import '../../screens/media_management_screen.dart';
import '../../screens/my_investments_screen.dart';
import '../../screens/onboarding_management_screen.dart';
import '../../screens/plug_wallet_screen.dart';
import '../../screens/preferences_screen.dart';
import '../../screens/preload_info_screen.dart';
import '../../screens/rada_file_selector_screen.dart';
import '../../screens/rada_state_selector_screen.dart';
import '../../screens/server_settings_screen.dart';
import '../../screens/tax_lien_content_manager_screen.dart';
import '../../screens/wallet_settings_screen.dart';
import '../../screens/yuku_integration_demo_screen.dart';
import '../../screens/yuku_marketplace_screen.dart';
import '../../services/localization_service.dart';
import '../../services/theme_service.dart';
import '../../services/onboarding_service.dart';
import '../../services/tax_lien_service.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/user_preferences_service.dart';
import '../../services/server_connection_service.dart';
import '../../services/ai_investment_advisor_service.dart';
import '../../services/tax_lien_magento_service.dart';
import '../mocks/nft_mocks.dart';

/// Централизованный роутер для всех экранов приложения
class AppRouter {
  // Route names
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String mainNavigation = '/main';
  static const String mainMenu = '/main-menu';
  static const String settings = '/settings';
  static const String search = '/search';
  static const String advancedSearch = '/advanced-search';
  static const String marketplace = '/marketplace';
  static const String marketplacePackages = '/marketplace-packages';
  static const String portfolio = '/portfolio';
  static const String enhancedPortfolio = '/enhanced-portfolio';
  static const String unifiedPortfolio = '/unified-portfolio';
  static const String aiAdvisor = '/ai-advisor';
  static const String profile = '/profile';
  static const String nftDashboard = '/nft-dashboard';
  static const String myInvestments = '/my-investments';
  static const String auction = '/auction';
  static const String preferences = '/preferences';
  static const String languageSettings = '/language-settings';
  static const String adminPanel = '/admin-panel';
  static const String domeControl = '/dome-control';
  static const String calibration = '/calibration';
  static const String connectionStatus = '/connection-status';
  static const String serverSettings = '/server-settings';
  static const String mediaManagement = '/media-management';
  static const String taxLienContentManager = '/tax-lien-content-manager';
  static const String syncManagement = '/sync-management';
  static const String onboardingManagement = '/onboarding-management';
  static const String interactiveOnboarding = '/interactive-onboarding';
  static const String preloadInfo = '/preload-info';
  static const String radaFileSelector = '/rada-file-selector';
  static const String radaStateSelector = '/rada-state-selector';
  static const String projectionSettings = '/projection-settings';
  static const String plugWallet = '/plug-wallet';
  static const String walletConnection = '/wallet-connection';
  static const String walletSettings = '/wallet-settings';
  static const String yukuMarketplace = '/yuku-marketplace';
  static const String yukuDemo = '/yuku-demo';
  static const String unifiedAnalytics = '/unified-analytics';

  /// Генерация маршрутов для приложения
  static Route<dynamic> generateRoute(
    RouteSettings settings,
    AppRouterDependencies dependencies,
  ) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            localizationService: dependencies.localizationService,
            themeService: dependencies.themeService,
            onboardingService: dependencies.onboardingService,
            taxLienService: dependencies.taxLienService,
            authService: dependencies.authService,
            databaseService: dependencies.databaseService,
            userPreferencesService: dependencies.userPreferencesService,
          ),
        );

      case onboarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            localizationService: dependencies.localizationService,
            themeService: dependencies.themeService,
            onboardingService: dependencies.onboardingService,
            taxLienService: dependencies.taxLienService,
            authService: dependencies.authService,
            databaseService: dependencies.databaseService,
            userPreferencesService: dependencies.userPreferencesService,
          ),
        );

      case mainNavigation:
        return MaterialPageRoute(
          builder: (_) => MainNavigationScreen(
            localizationService: dependencies.localizationService,
            themeService: dependencies.themeService,
            onboardingService: dependencies.onboardingService,
            taxLienService: dependencies.taxLienService,
            authService: dependencies.authService,
            databaseService: dependencies.databaseService,
            userPreferencesService: dependencies.userPreferencesService,
          ),
        );

      case mainMenu:
        return MaterialPageRoute(
          builder: (_) => MainMenuScreen(
            localizationService: dependencies.localizationService,
            themeService: dependencies.themeService,
            onboardingService: dependencies.onboardingService,
            serverConnectionService: dependencies.serverConnectionService,
          ),
        );

      case AppRouter.settings:
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(
            themeService: dependencies.themeService,
            localizationService: dependencies.localizationService,
          ),
        );

      case search:
        return MaterialPageRoute(
          builder: (_) => SearchScreen(
            taxLienService: dependencies.taxLienService,
            databaseService: dependencies.databaseService,
          ),
        );

      case advancedSearch:
        // Requires MagentoApiService parameter
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Advanced Search - Configure parameters'),
            ),
          ),
        );

      case marketplace:
        return MaterialPageRoute(
          builder: (_) => MarketplaceScreen(
            taxLienService: dependencies.taxLienService,
            authService: dependencies.authService,
            taxLienMagentoService: dependencies.taxLienMagentoService,
          ),
        );

      case marketplacePackages:
        return MaterialPageRoute(
          builder: (_) => const MarketplacePackagesScreen(),
        );

      case portfolio:
        return MaterialPageRoute(
          builder: (_) => PortfolioDashboardScreen(
            taxLienService: dependencies.taxLienService,
            aiService: dependencies.aiInvestmentAdvisorService,
          ),
        );

      case enhancedPortfolio:
        // Requires specific parameters
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Enhanced Portfolio Dashboard'),
            ),
          ),
        );

      case unifiedPortfolio:
        // Requires specific parameters
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Unified Portfolio Dashboard'),
            ),
          ),
        );

      case aiAdvisor:
        return MaterialPageRoute(
          builder: (_) => AIAdvisorScreen(
            taxLienService: dependencies.taxLienService,
            aiService: dependencies.aiInvestmentAdvisorService,
          ),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(
            authService: dependencies.authService,
            themeService: dependencies.themeService,
            localizationService: dependencies.localizationService,
            onboardingService: dependencies.onboardingService,
            nftClient: dependencies.nftClient,
          ),
        );

      case nftDashboard:
        return MaterialPageRoute(
          builder: (_) => NFTDashboardScreen(
            nftClient: dependencies.nftClient,
            taxLienService: dependencies.taxLienService,
          ),
        );

      case myInvestments:
        return MaterialPageRoute(
          builder: (_) => MyInvestmentsScreen(
            taxLienService: dependencies.taxLienService,
            authService: dependencies.authService,
            databaseService: dependencies.databaseService,
          ),
        );

      case auction:
        // Requires AuctionService
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Auction Screen'),
            ),
          ),
        );

      case preferences:
        return MaterialPageRoute(
          builder: (_) => PreferencesScreen(
            localizationService: dependencies.localizationService,
            themeService: dependencies.themeService,
            preferencesService: dependencies.userPreferencesService,
          ),
        );

      case languageSettings:
        return MaterialPageRoute(
          builder: (_) => LanguageSettingsScreen(
            localizationService: dependencies.localizationService,
          ),
        );

      case adminPanel:
        return MaterialPageRoute(
          builder: (_) => AdminPanelScreen(
            serverConnectionService: dependencies.serverConnectionService,
          ),
        );

      case calibration:
        return MaterialPageRoute(
          builder: (_) => CalibrationScreen(
            domeService: dependencies.serverConnectionService,
          ),
        );

      case connectionStatus:
        return MaterialPageRoute(
          builder: (_) => ConnectionStatusScreen(
            serverService: dependencies.serverConnectionService,
          ),
        );

      case serverSettings:
        return MaterialPageRoute(
          builder: (_) => ServerSettingsScreen(
            serverService: dependencies.serverConnectionService,
          ),
        );

      case mediaManagement:
        return MaterialPageRoute(
          builder: (_) => const MediaManagementScreen(),
        );

      case taxLienContentManager:
        return MaterialPageRoute(
          builder: (_) => TaxLienContentManagerScreen(
            serverConnectionService: dependencies.serverConnectionService,
          ),
        );

      case syncManagement:
        // Requires SyncService
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Sync Management Screen'),
            ),
          ),
        );

      case onboardingManagement:
        return MaterialPageRoute(
          builder: (_) => const OnboardingManagementScreen(),
        );

      case interactiveOnboarding:
        // Requires OnboardingController
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Interactive Onboarding Screen'),
            ),
          ),
        );

      case preloadInfo:
        return MaterialPageRoute(
          builder: (_) => const PreloadInfoScreen(),
        );

      case radaFileSelector:
        return MaterialPageRoute(
          builder: (_) => const RadaFileSelectorScreen(),
        );

      case radaStateSelector:
        return MaterialPageRoute(
          builder: (_) => const RadaStateSelectorScreen(),
        );

      case projectionSettings:
        // Requires ProjectionService
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Projection Settings Screen'),
            ),
          ),
        );

      case plugWallet:
        return MaterialPageRoute(
          builder: (_) => PlugWalletScreen(
            nftClient: dependencies.nftClient,
          ),
        );

      case walletConnection:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Wallet Connection Screen - Configure WalletService'),
            ),
          ),
        );

      case walletSettings:
        return MaterialPageRoute(
          builder: (_) => WalletSettingsScreen(
            nftClient: dependencies.nftClient,
          ),
        );

      case yukuMarketplace:
        return MaterialPageRoute(
          builder: (_) => YukuMarketplaceScreen(
            nftClient: dependencies.nftClient,
          ),
        );

      case yukuDemo:
        return MaterialPageRoute(
          builder: (_) => YukuIntegrationDemoScreen(
            nftClient: dependencies.nftClient,
          ),
        );

      case unifiedAnalytics:
        // Requires AnalyticsService
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Unified Analytics Screen'),
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Навигация к именованному маршруту
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Замена текущего маршрута
  static Future<T?> replaceTo<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Удаление всех маршрутов и навигация к новому
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Возврат назад
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  /// Проверка возможности вернуться назад
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}

/// Зависимости для роутера
class AppRouterDependencies {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;
  final UserPreferencesService userPreferencesService;
  final ServerConnectionService serverConnectionService;
  final AIInvestmentAdvisorService aiInvestmentAdvisorService;
  final TaxLienMagentoService taxLienMagentoService;
  final NFTClient nftClient;

  AppRouterDependencies({
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
    required this.userPreferencesService,
    required this.serverConnectionService,
    required this.aiInvestmentAdvisorService,
    required this.taxLienMagentoService,
    required this.nftClient,
  });
}
