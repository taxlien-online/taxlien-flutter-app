import 'package:flutter/material.dart';
import '../../screens/main_navigation_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/search_screen.dart';
import '../../screens/marketplace_screen.dart';
import '../../screens/magento_marketplace_screen.dart';
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
import '../../screens/paywall_screen.dart';
import '../../screens/advanced_search_screen.dart';
import '../../screens/auction_screen.dart';
import '../../screens/enhanced_portfolio_dashboard.dart';
import '../../screens/interactive_onboarding_screen.dart';
import '../../screens/projection_settings_screen.dart';
import '../../screens/sync_management_screen.dart';
import '../../screens/unified_analytics_screen.dart';
import '../../screens/unified_portfolio_dashboard_screen.dart';
import '../../screens/wallet_connection_screen.dart';
import '../../screens/product_detail_screen.dart';
import '../../screens/nft_onboarding_screen.dart';
import '../../screens/education_dashboard_screen.dart';
import '../../screens/lesson_player_screen.dart';
import '../../screens/quiz_screen.dart';
import '../../features/portfolio_simulator/screens/simulator_dashboard_screen.dart';
import '../../features/portfolio_simulator/screens/property_browse_screen.dart';
import '../../features/portfolio_simulator/screens/leaderboard_screen.dart';
import '../../features/portfolio_simulator/models/simulated_portfolio.dart';
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
import '../../services/wallet_service.dart';
import '../../services/nft_service.dart';
import '../../services/yuku_service.dart';
import '../../services/plug_wallet_service.dart';
import '../../services/portfolio_service.dart';
import '../../services/unified_portfolio_service.dart';
import '../../services/realtime_bidding_service.dart';
import '../../services/magento_service.dart';
import '../../services/trial_service.dart';
import '../../services/paywall_trigger_service.dart';
import '../../services/education_service.dart';
import '../../services/referral_service.dart';
import '../mocks/nft_mocks.dart';
import '../services/dome_service.dart';
import '../services/magento_api_service.dart';

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
  static const String magentoMarketplace = '/magento-marketplace';
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
  static const String paywall = '/paywall';
  static const String productDetail = '/product-detail';
  static const String nftOnboarding = '/nft-onboarding';
  static const String educationDashboard = '/education';
  static const String lessonPlayer = '/lesson-player';
  static const String quiz = '/quiz';
  static const String portfolioSimulator = '/portfolio-simulator';
  static const String simulatorPropertyBrowse = '/simulator-property-browse';
  static const String simulatorLeaderboard = '/simulator-leaderboard';

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
        final initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MainNavigationScreen(
            localizationService: dependencies.localizationService,
            themeService: dependencies.themeService,
            onboardingService: dependencies.onboardingService,
            taxLienService: dependencies.taxLienService,
            authService: dependencies.authService,
            databaseService: dependencies.databaseService,
            userPreferencesService: dependencies.userPreferencesService,
            educationService: dependencies.educationService,
            paywallTriggerService: dependencies.paywallTriggerService,
            referralService: dependencies.referralService,
            initialIndex: initialIndex,
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
            paywallTriggerService: dependencies.paywallTriggerService,
          ),
        );

      case advancedSearch:
        return MaterialPageRoute(
          builder: (_) => AdvancedSearchScreen(
            taxLienService: dependencies.taxLienService,
            magentoApiService: MagentoApiService(),
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

      case magentoMarketplace:
        return MaterialPageRoute(
          builder: (_) => const MagentoMarketplaceScreen(),
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
        return MaterialPageRoute(
          builder: (_) => EnhancedPortfolioDashboard(
            portfolioService: PortfolioService(),
          ),
        );

      case unifiedPortfolio:
        return MaterialPageRoute(
          builder: (_) => UnifiedPortfolioDashboardScreen(
            portfolioService: UnifiedPortfolioService(
              taxLienService: dependencies.taxLienService,
              nftService: NFTService.instance,
              databaseService: dependencies.databaseService,
            ),
            taxLienService: dependencies.taxLienService,
            nftService: NFTService.instance,
          ),
        );

      case aiAdvisor:
        return MaterialPageRoute(
          builder: (_) => AIAdvisorScreen(
            taxLienService: dependencies.taxLienService,
            aiService: dependencies.aiInvestmentAdvisorService,
            paywallTriggerService: dependencies.paywallTriggerService,
          ),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(
            authService: dependencies.authService,
            themeService: dependencies.themeService,
            localizationService: dependencies.localizationService,
            onboardingService: dependencies.onboardingService,
            referralService: dependencies.referralService,
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
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('auction')) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('Auction data not provided'),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => AuctionScreen(
            biddingService: RealtimeBiddingService(),
            auction: args['auction'],
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
            domeService: DomeService(),
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
        return MaterialPageRoute(
          builder: (_) => const SyncManagementScreen(),
        );

      case onboardingManagement:
        return MaterialPageRoute(
          builder: (_) => const OnboardingManagementScreen(),
        );

      case interactiveOnboarding:
        return MaterialPageRoute(
          builder: (_) => InteractiveOnboardingScreen(
            localizationService: dependencies.localizationService,
            themeService: dependencies.themeService,
            onboardingService: dependencies.onboardingService,
            taxLienService: dependencies.taxLienService,
            nftService: NFTService.instance,
            walletService: WalletService(),
            yukuService: YukuService(),
            plugWalletService: PlugWalletService.instance,
            authService: dependencies.authService,
            databaseService: dependencies.databaseService,
            userPreferencesService: dependencies.userPreferencesService,
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
        return MaterialPageRoute(
          builder: (_) => ProjectionSettingsScreen(
            serverConnectionService: dependencies.serverConnectionService,
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
          builder: (_) => WalletConnectionScreen(
            walletService: WalletService(),
            onWalletConnected: () {
              Navigator.of(_).pop();
            },
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

      case paywall:
        bool canDismiss = true;
        PaywallReason? reason;

        if (settings.arguments is bool) {
          canDismiss = settings.arguments as bool;
        } else if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          canDismiss = args['canDismiss'] ?? true;
          reason = args['reason'];
        } else if (settings.arguments is PaywallReason) {
          reason = settings.arguments as PaywallReason;
        }

        return MaterialPageRoute(
          builder: (_) => PaywallScreen(
            canDismiss: canDismiss,
            reason: reason,
          ),
        );

      case unifiedAnalytics:
        return MaterialPageRoute(
          builder: (_) => UnifiedAnalyticsScreen(
            portfolioService: UnifiedPortfolioService(
              taxLienService: dependencies.taxLienService,
              nftService: NFTService.instance,
              databaseService: dependencies.databaseService,
            ),
          ),
        );

      case productDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('product')) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('Product data not provided'),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(
            product: args['product'],
            authService: dependencies.authService,
            databaseService: dependencies.databaseService,
            magentoService: MagentoService(),
          ),
        );

      case nftOnboarding:
        return MaterialPageRoute(
          builder: (_) => NFTOnboardingScreen(
            preferencesService: dependencies.userPreferencesService,
            taxLienService: dependencies.taxLienService,
            onComplete: () {
              Navigator.of(_).pop();
            },
          ),
        );

      case educationDashboard:
        return MaterialPageRoute(
          builder: (_) => EducationDashboardScreen(
            eduService: dependencies.educationService,
          ),
        );

      case lessonPlayer:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('lesson')) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Lesson data not provided')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => LessonPlayerScreen(
            lesson: args['lesson'],
            eduService: dependencies.educationService,
          ),
        );

      case quiz:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('lesson')) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Quiz data not provided')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => QuizScreen(
            lesson: args['lesson'],
            eduService: dependencies.educationService,
          ),
        );

      case portfolioSimulator:
        return MaterialPageRoute(
          builder: (_) => const SimulatorDashboardScreen(),
        );

      case simulatorPropertyBrowse:
        final portfolio = settings.arguments as SimulatedPortfolio;
        return MaterialPageRoute(
          builder: (_) => PropertyBrowseScreen(portfolio: portfolio),
        );

      case simulatorLeaderboard:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => LeaderboardScreen(userId: userId),
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
    BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Замена текущего маршрута
  static Future<T?> replaceTo<T extends Object?, TO extends Object?>(
    BuildContext context, String routeName, {TO? result, Object? arguments}) {
    return Navigator.pushReplacementNamed<T, TO>(context, routeName, result: result, arguments: arguments);
  }

  /// Удаление всех маршрутов и навигация к новому
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil<T>(context, routeName, (route) => false, arguments: arguments);
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
  final TrialService? trialService;
  final PaywallTriggerService? paywallTriggerService;
  final EducationService educationService;
  final ReferralService? referralService;

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
    required this.educationService,
    this.trialService,
    this.paywallTriggerService,
    this.referralService,
  });
}