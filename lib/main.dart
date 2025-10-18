import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'services/localization_service.dart';
import 'services/theme_service.dart';
import 'services/onboarding_service.dart';
import 'services/tax_lien_service.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/user_preferences_service.dart';
import 'services/server_connection_service.dart';
import 'services/ai_investment_advisor_service.dart';
import 'services/tax_lien_magento_service.dart';
import 'services/magento_marketplace_service.dart';
import 'core/services/hybrid_magento_service.dart';
import 'core/services/magento_api_service.dart';
import 'core/providers/magento_marketplace_provider.dart';
import 'core/mocks/nft_mocks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize services
  await _initializeServices();

  // Create Magento providers
  final magentoProvider = MagentoMarketplaceProvider();
  final magentoService = MagentoMarketplaceService(magentoProvider);

  // Initialize Magento (use demo store for now)
  try {
    await magentoProvider.initialize(
      baseUrl: 'https://luma-demo.scandipwa.com/',
      connectionTimeout: 30000,
      receiveTimeout: 30000,
      supportedLanguages: ['en', 'ru', 'th', 'zh'],
    );
    if (kDebugMode) {
      print('✅ Magento marketplace initialized');
    }
  } catch (e) {
    if (kDebugMode) {
      print('⚠️ Magento initialization failed: $e');
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: magentoProvider),
        Provider.value(value: magentoService),
      ],
      child: const ProviderScope(child: TaxLienApp()),
    ),
  );
}

Future<void> _initializeServices() async {
  // Initialize database
  try {
    await DatabaseService.instance.initialize();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing database: $e');
    }
  }
}

// Create global NFT client instance (using mock for now)
NFTClient _createNFTClient() {
  return NFTClient();
}

class TaxLienApp extends StatefulWidget {
  const TaxLienApp({super.key});

  @override
  State<TaxLienApp> createState() => _TaxLienAppState();
}

class _TaxLienAppState extends State<TaxLienApp> {
  late AppRouterDependencies _routerDependencies;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    // Initialize services
    final localizationService = LocalizationService();
    final themeService = ThemeService();
    final onboardingService = OnboardingService();
    final taxLienService = TaxLienService();
    final authService = AuthService();
    final databaseService = DatabaseService.instance;
    final userPreferencesService = UserPreferencesService();
    final serverConnectionService = ServerConnectionService();
    final aiInvestmentAdvisorService = AIInvestmentAdvisorService();

    // Initialize Magento services
    final hybridMagentoService = HybridMagentoService(
      restService: MagentoApiService(),
    );
    final taxLienMagentoService = TaxLienMagentoService(hybridMagentoService);

    // Initialize NFT client
    final nftClient = _createNFTClient();

    _routerDependencies = AppRouterDependencies(
      localizationService: localizationService,
      themeService: themeService,
      onboardingService: onboardingService,
      taxLienService: taxLienService,
      authService: authService,
      databaseService: databaseService,
      userPreferencesService: userPreferencesService,
      serverConnectionService: serverConnectionService,
      aiInvestmentAdvisorService: aiInvestmentAdvisorService,
      taxLienMagentoService: taxLienMagentoService,
      nftClient: nftClient,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to Magento provider for updates
    final magentoProvider = context.watch<MagentoMarketplaceProvider>();

    return MaterialApp(
      title: 'TaxLien.online',
      debugShowCheckedModeBanner: false,

      // Localization settings
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('th', ''), // Thai
        Locale('ru', ''), // Russian
        Locale('zh', ''), // Chinese
        Locale('he', ''), // Hebrew
        Locale('hi', ''), // Hindi
        Locale('uk', ''), // Ukrainian
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use English as default
        return supportedLocales.first;
      },

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Blue color
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // Use centralized router
      initialRoute: AppRouter.home,
      onGenerateRoute: (settings) =>
          AppRouter.generateRoute(settings, _routerDependencies),
    );
  }
}

// Placeholder class for SimpleHomeScreen reference (used by app_router_screen.dart)
class SimpleHomeScreen extends StatelessWidget {
  const SimpleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to main navigation instead
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, AppRouter.mainNavigation);
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
