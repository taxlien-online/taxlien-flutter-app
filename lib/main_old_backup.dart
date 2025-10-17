import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_localizations/flutter_localizations.dart';
// import './l10n/app_localizations.dart';

// Core imports
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/services/magento_api_service.dart';
import 'core/services/hybrid_magento_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/localization_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/models/magento_models.dart';
import 'services/integrated_services.dart';

// Provider imports - defined in this file

// Widgets
import 'core/widgets/cloud_status_widget.dart';

// Screens
import 'screens/marketplace_screen.dart';
import 'screens/portfolio_dashboard_screen.dart';
import 'screens/ai_advisor_screen.dart';
import 'screens/preload_info_screen.dart';
import 'screens/sync_management_screen.dart';
import 'screens/rada_state_selector_screen.dart';
import 'screens/app_router_screen.dart';

// Services
import 'services/tax_lien_service.dart';
import 'services/tax_lien_magento_service.dart';
import 'services/auth_service.dart';
import 'services/ai_investment_advisor_service.dart';
import 'services/flutter_magento_cloud_service.dart' as magento_cloud;
import 'services/preload_service.dart';

// Widgets
import 'widgets/cloud_functions_status_widget.dart';

// NFT and ICP libraries
// import 'package:flutter_magento_messenger/flutter_magento_messenger.dart';
// import 'package:flutter_magento_notifications/flutter_magento_notifications.dart';

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

  runApp(
    provider.MultiProvider(
      providers: [
        provider.Provider(
            create: (_) => magento_cloud.FlutterMagentoCloudService()),
        provider.ChangeNotifierProxyProvider<
            magento_cloud.FlutterMagentoCloudService, HybridMagentoService>(
          create: (_) => HybridMagentoService(),
          update: (_, flutterMagentoService, hybridService) {
            hybridService?.setFlutterMagentoService(flutterMagentoService);
            return hybridService ??
                HybridMagentoService(
                    flutterMagentoService: flutterMagentoService);
          },
        ),
      ],
      child: const ProviderScope(
        child: TaxLienApp(),
      ),
    ),
  );
}

Future<void> _initializeServices() async {
  try {
    // Initialize secure storage
    await SecureStorageService.initialize();

    // Initialize preload data with .rada file support
    // This will load data from /assets/taxlien_data.rada and initialize scheduled sync
    await PreloadService.initializePreloadData();

    // Create default sync schedules for common states (disabled by default)
    // Users can enable them in settings
    await PreloadService.createDefaultSyncSchedules();

    if (kDebugMode) {
      // Print preload status for debugging
      final preloadStatus = await PreloadService.getPreloadStatus();
      print('Preload Status: ${preloadStatus['data_source']}');
      print('Using RADA data: ${preloadStatus['rada_file_loaded']}');

      if (PreloadService.offlineLoader != null) {
        final stats = await PreloadService.offlineLoader!.getDataStats();
        print('Offline Data Stats: $stats');
      }
    }

    // Initialize NFT client with ICP providers
    await _initializeNFTServices();

    // Initialize analytics (disabled for now to avoid Firebase issues)
    if (false && AppConstants.enableAnalytics) {
      await AnalyticsService.initialize();
    }

    // Initialize Magento Messenger (disabled - package not available)
    // await MessagingService().initialize();

    // Initialize Magento Notifications (disabled - package not available)
    // await NotificationManager().initialize();

    // Initialize notifications (disabled for now to avoid Firebase issues)
    if (false && AppConstants.enablePushNotifications) {
      await NotificationService.initialize();
    }
  } catch (e) {
    // Log error but don't crash the app
    if (kDebugMode) {
      print('Service initialization error: $e');
    }
  }
}

Future<void> _initializeNFTServices() async {
  try {
    // Initialize integrated services
    final integratedServices = IntegratedServices.instance;
    await integratedServices.initialize();

    // Store services globally for access throughout the app
    AppConstants.integratedServices = integratedServices;
    // AppConstants.nftClient = integratedServices.nftClient; // Temporarily disabled

    if (kDebugMode) {
      print('Integrated services initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing integrated services: $e');
    }
  }
}

/// Main application widget
class TaxLienApp extends ConsumerWidget {
  const TaxLienApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localizationProvider);
    // final authState = ref.watch(authProvider);
    // final magentoState = ref.watch(magentoProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Localization configuration
      locale: locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('uk', 'UA'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('de', 'DE'),
        Locale('zh', 'CN'),
        Locale('ja', 'JP'),
        Locale('ko', 'KR'),
        Locale('ar', 'SA'),
        Locale('hi', 'IN'),
        Locale('th', 'TH'),
        Locale('pl', 'PL'),
        Locale('pt', 'PT'),
        Locale('it', 'IT'),
        Locale('fi', 'FI'),
        Locale('et', 'EE'),
        Locale('he', 'IL'),
        Locale('km', 'KH'),
        Locale('lo', 'LA'),
        Locale('my', 'MM'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Home page - Shows onboarding for first-time users
      home: const AppRouterScreen(),

      // Error handling
      builder: (context, child) {
        return ErrorBoundary(
          child: child ?? const LoadingScreen(),
        );
      },
    );
  }
}

/// Error boundary widget to catch and handle errors gracefully
class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({
    super.key,
    required this.child,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Error? _error;

  @override
  void initState() {
    super.initState();
    _setupErrorHandling();
  }

  void _setupErrorHandling() {
    // Flutter error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      if (AppConstants.enableCrashlytics) {
        // Report to crashlytics
        // CrashlyticsService.recordFlutterError(details);
      }

      // Log error instead of showing dialog to avoid Navigator issues
      if (kDebugMode) {
        print('Flutter Error: ${details.exception}');
        print('Stack trace: ${details.stack}');
      }
    };

    // Platform error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      if (AppConstants.enableCrashlytics) {
        // Report to crashlytics
        // CrashlyticsService.recordError(error, stack);
      }

      // Log error instead of showing dialog to avoid Navigator issues
      if (kDebugMode) {
        print('Platform Error: $error');
        print('Stack trace: $stack');
      }

      return true;
    };
  }

  void _showErrorDialog(String error) {
    // Simply log the error to avoid Navigator context issues
    if (kDebugMode) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorScreen();
    }

    return widget.child;
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'An unexpected error occurred. Please try again.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading screen widget
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.account_balance,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // App name
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),

            // App description
            Text(
              AppConstants.appDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Loading indicator
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Global providers for the application
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

final localizationProvider = NotifierProvider<LocalizationNotifier, Locale>(() {
  return LocalizationNotifier();
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

final magentoProvider = NotifierProvider<MagentoNotifier, MagentoState>(() {
  return MagentoNotifier();
});

final hybridMagentoServiceProvider = Provider<HybridMagentoService>((ref) {
  return HybridMagentoService();
});

final flutterMagentoCloudServiceProvider =
    Provider<magento_cloud.FlutterMagentoCloudService>((ref) {
  return magento_cloud.FlutterMagentoCloudService();
});

/// Theme notifier for managing app theme
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final savedTheme = await ThemeService.getThemeMode();
    state = savedTheme;
  }

  Future<void> setTheme(ThemeMode theme) async {
    await ThemeService.setThemeMode(theme);
    state = theme;
  }

  Future<void> toggleTheme() async {
    final newTheme =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newTheme);
  }
}

/// Localization notifier for managing app locale
class LocalizationNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _loadLocale();
    return const Locale('en', 'US');
  }

  Future<void> _loadLocale() async {
    final savedLocale = await LocalizationService.getLocale();
    state = savedLocale;
  }

  Future<void> setLocale(Locale locale) async {
    await LocalizationService.setLocale(locale);
    state = locale;
  }
}

/// Auth state
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final MagentoCustomer? customer;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.customer,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    MagentoCustomer? customer,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      customer: customer ?? this.customer,
    );
  }
}

/// Auth notifier for managing authentication state
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _initialize();
    return const AuthState();
  }

  Future<void> _initialize() async {
    // Check if user is already authenticated
    final customer = await MagentoApiService().getCurrentCustomer();
    if (customer != null) {
      state = state.copyWith(
        isAuthenticated: true,
        customer: customer,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await MagentoApiService().authenticateCustomer(
        email: email,
        password: password,
      );

      if (success) {
        final customer = await MagentoApiService().getCurrentCustomer();
        state = state.copyWith(
          isAuthenticated: true,
          customer: customer,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid email or password',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final customer = await MagentoApiService().createCustomer(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (customer != null) {
        // Auto-login after registration
        return await login(email, password);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Registration failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> logout() async {
    MagentoApiService().logout();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Magento state
class MagentoState {
  final bool isLoading;
  final String? error;
  final MagentoProductList? products;
  final MagentoCart? cart;
  final List<MagentoOrder>? orders;
  final MagentoWishlist? wishlist;

  const MagentoState({
    this.isLoading = false,
    this.error,
    this.products,
    this.cart,
    this.orders,
    this.wishlist,
  });

  MagentoState copyWith({
    bool? isLoading,
    String? error,
    MagentoProductList? products,
    MagentoCart? cart,
    List<MagentoOrder>? orders,
    MagentoWishlist? wishlist,
  }) {
    return MagentoState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
      cart: cart ?? this.cart,
      orders: orders ?? this.orders,
      wishlist: wishlist ?? this.wishlist,
    );
  }
}

/// Magento notifier for managing Magento data
class MagentoNotifier extends Notifier<MagentoState> {
  @override
  MagentoState build() {
    return const MagentoState();
  }

  Future<void> loadProducts({
    int page = 1,
    int pageSize = AppConstants.defaultPageSize,
    String? searchQuery,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await MagentoApiService().getProducts(
        page: page,
        pageSize: pageSize,
        searchQuery: searchQuery,
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      state = state.copyWith(
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadCart(String cartId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cart = await MagentoApiService().getCart(cartId);
      state = state.copyWith(
        cart: cart,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orders = await MagentoApiService().getCustomerOrders();
      state = state.copyWith(
        orders: orders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadWishlist() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final wishlist = await MagentoApiService().getWishlist();
      state = state.copyWith(
        wishlist: wishlist,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<String?> createCart() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cartId = await MagentoApiService().createCart();
      state = state.copyWith(isLoading: false);
      return cartId;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<bool> addToCart({
    required String cartId,
    required String sku,
    required int quantity,
    Map<String, dynamic>? productOption,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await MagentoApiService().addToCart(
        cartId: cartId,
        sku: sku,
        quantity: quantity,
        productOption: productOption,
      );

      if (success) {
        // Reload cart to get updated state
        await loadCart(cartId);
      }

      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateCartItem({
    required String cartId,
    required int itemId,
    required int quantity,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await MagentoApiService().updateCartItem(
        cartId: cartId,
        itemId: itemId,
        quantity: quantity,
      );

      if (success) {
        // Reload cart to get updated state
        await loadCart(cartId);
      }

      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> removeFromCart({
    required String cartId,
    required int itemId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await MagentoApiService().removeFromCart(
        cartId: cartId,
        itemId: itemId,
      );

      if (success) {
        // Reload cart to get updated state
        await loadCart(cartId);
      }

      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Enhanced home screen with new features
class SimpleHomeScreen extends StatefulWidget {
  const SimpleHomeScreen({super.key});

  @override
  State<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends State<SimpleHomeScreen> {
  int _selectedIndex = 0;
  late TaxLienService _taxLienService;
  late AIInvestmentAdvisorService _aiService;
  late AuthService _authService;
  late TaxLienMagentoService _taxLienMagentoService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    _taxLienService = TaxLienService();
    _aiService = AIInvestmentAdvisorService();
    _authService = AuthService();

    // Get HybridMagentoService from provider
    final hybridMagentoService =
        provider.Provider.of<HybridMagentoService>(context, listen: false);
    _taxLienMagentoService = TaxLienMagentoService(hybridMagentoService);

    // Set Magento service for tax lien service
    _taxLienService.setMagentoService(_taxLienMagentoService);

    // Initialize services
    _taxLienService.initialize();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String> _getCurrentStatesText() async {
    final selectedStates = PreloadService.getSelectedStates();

    if (selectedStates.contains('ALL')) {
      return 'Все штаты';
    } else if (selectedStates.length == 1) {
      final state = selectedStates.first;
      final stateNames = {
        'FL': 'Florida',
        'AZ': 'Arizona',
        'DEMO': 'Demo',
      };
      return stateNames[state] ?? state;
    } else {
      return '${selectedStates.length} штатов выбрано';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          MarketplaceScreen(
            taxLienService: _taxLienService,
            authService: _authService,
            taxLienMagentoService: _taxLienMagentoService,
          ),
          PortfolioDashboardScreen(
            taxLienService: _taxLienService,
            aiService: _aiService,
          ),
          AIAdvisorScreen(
            taxLienService: _taxLienService,
            aiService: _aiService,
          ),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Маркетплейс',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Портфель',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'AI Советник',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaxLien.online'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: const [
          CompactCloudStatusWidget(),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.account_balance,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Добро пожаловать в',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const Text(
                    'TaxLien.online',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ваша платформа для инвестиций в налоговые закладные',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick actions
            Text(
              'Быстрые действия',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildActionCard(
                  'Поиск закладных',
                  'Найти лучшие предложения',
                  Icons.search,
                  Colors.blue,
                  () => _onItemTapped(1),
                ),
                _buildActionCard(
                  'AI Анализ',
                  'Получить рекомендации AI',
                  Icons.psychology,
                  Colors.purple,
                  () => _onItemTapped(3),
                ),
                _buildActionCard(
                  'Мой портфель',
                  'Статистика и аналитика',
                  Icons.pie_chart,
                  Colors.green,
                  () => _onItemTapped(2),
                ),
                _buildActionCard(
                  'Обучение',
                  'Изучить основы',
                  Icons.school,
                  Colors.orange,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Раздел обучения в разработке')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Features section
            Text(
              'Новые возможности',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AI Инвестиционный консультант',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Умный анализ рисков и рекомендации по инвестициям',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text('Анализ рисков'),
                          backgroundColor: Colors.green,
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Chip(
                          label: Text('Персональные рекомендации'),
                          backgroundColor: Colors.blue,
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Chip(
                          label: Text('Рыночная аналитика'),
                          backgroundColor: Colors.orange,
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: const [
          CloudStatusWidget(
            showIcon: true,
            showLabel: true,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Профиль пользователя',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Гость',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Settings
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Личные данные'),
                    subtitle: const Text('Управление профилем'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('В разработке')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Безопасность'),
                    subtitle:
                        const Text('Пароль и двухфакторная аутентификация'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('В разработке')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  const CloudSettingsTile(),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Уведомления'),
                    subtitle: const Text('Настройка push-уведомлений'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('В разработке')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App Info
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('О приложении'),
                    subtitle: Text('Версия ${AppConstants.appVersion}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: AppConstants.appName,
                        applicationVersion: AppConstants.appVersion,
                        applicationLegalese: '© 2024 TaxLien.online',
                        children: [
                          const SizedBox(height: 16),
                          Text(AppConstants.appDescription),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Support Development',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Donations accepted at:',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: SelectableText(
                              AppConstants.donationAddress,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Данные приложения'),
                    subtitle: const Text('Исторические данные и прелоад'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreloadInfoScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.map),
                    title: const Text('Выбор штатов'),
                    subtitle: FutureBuilder<String>(
                      future: _getCurrentStatesText(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? 'Загрузка...',
                        );
                      },
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RadaStateSelectorScreen(),
                        ),
                      );

                      if (result == true && mounted) {
                        setState(() {}); // Обновить UI
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.sync),
                    title: const Text('Управление синхронизацией'),
                    subtitle:
                        const Text('Расписание загрузки данных по штатам'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SyncManagementScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Помощь'),
                    subtitle: const Text('FAQ и поддержка'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('В разработке')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout/Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Функция входа в разработке')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Войти в аккаунт'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
