import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';
import '../services/onboarding_service.dart';
import '../services/tax_lien_service.dart';
// Replaced with flutter_nft and flutter_icp libraries
// import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
// import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
import '../core/constants/app_constants.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/user_preferences_service.dart';
import '../services/education_service.dart';
import '../services/paywall_trigger_service.dart';
import '../services/referral_service.dart';
import '../theme/app_theme_export.dart';

// ... (keep imports)

class MainNavigationScreen extends StatefulWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;
  final UserPreferencesService userPreferencesService;
  final EducationService educationService;
  final PaywallTriggerService? paywallTriggerService;
  final ReferralService? referralService;
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
    required this.userPreferencesService,
    required this.educationService,
    this.paywallTriggerService,
    this.referralService,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  late PageController _pageController;
  late NFTClient _nftClient;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Marketplace',
      icon: Icons.store,
      screen: null, // Will be set in initState
    ),
    NavigationItem(
      title: 'My Investments',
      icon: Icons.trending_up,
      screen: null, // Will be set in initState
    ),
    NavigationItem(
      title: 'NFTs',
      icon: Icons.collections,
      screen: null, // Will be set in initState
    ),
    NavigationItem(
      title: 'Education',
      icon: Icons.school,
      screen: null, // Will be set in initState
    ),
    NavigationItem(
      title: 'Search',
      icon: Icons.search,
      screen: null, // Will be set in initState
    ),
    NavigationItem(
      title: 'Profile',
      icon: Icons.person,
      screen: null, // Will be set in initState
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _nftClient = NFTClient();

    // Initialize screens - Requires TaxLienMagentoService
    // Temporarily using mock marketplace until properly configured
    _navigationItems[0].screen = const Scaffold(
      body: Center(
        child: Text('Marketplace - Configure TaxLienMagentoService'),
      ),
    );

    _navigationItems[1].screen = MyInvestmentsScreen(
      taxLienService: widget.taxLienService,
      authService: widget.authService,
      databaseService: widget.databaseService,
    );

    _navigationItems[2].screen = NFTDashboardScreen(
      nftClient: _nftClient,
      taxLienService: widget.taxLienService,
    );

    _navigationItems[3].screen = EducationDashboardScreen(
      eduService: widget.educationService,
    );

    _navigationItems[4].screen = SearchScreen(
      taxLienService: widget.taxLienService,
      databaseService: widget.databaseService,
      paywallTriggerService: widget.paywallTriggerService,
    );

    _navigationItems[5].screen = ProfileScreen(
      authService: widget.authService,
      themeService: widget.themeService,
      localizationService: widget.localizationService,
      onboardingService: widget.onboardingService,
      referralService: widget.referralService,
      nftClient: _nftClient,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _navigationItems.map((item) => item.screen!).toList(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: _navigationItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.title,
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  Widget? screen;

  NavigationItem({
    required this.title,
    required this.icon,
    this.screen,
  });
}
