import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';
import '../services/onboarding_service.dart';
import '../services/tax_lien_service.dart';
import '../services/nft_service.dart';
import '../services/wallet_service.dart';
import '../services/yuku_service.dart';
import '../services/plug_wallet_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/user_preferences_service.dart';
import '../theme/app_theme_export.dart';
import 'marketplace_screen.dart';
import 'my_investments_screen.dart';
import 'nft_dashboard_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final NFTService nftService;
  final WalletService walletService;
  final YukuService yukuService;
  final PlugWalletService plugWalletService;
  final AuthService authService;
  final DatabaseService databaseService;
  final UserPreferencesService userPreferencesService;

  const MainNavigationScreen({
    super.key,
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.nftService,
    required this.walletService,
    required this.yukuService,
    required this.plugWalletService,
    required this.authService,
    required this.databaseService,
    required this.userPreferencesService,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

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
    _pageController = PageController();
    
    // Initialize screens
    _navigationItems[0].screen = MarketplaceScreen(
      taxLienService: widget.taxLienService,
      authService: widget.authService,
      databaseService: widget.databaseService,
    );
    
    _navigationItems[1].screen = MyInvestmentsScreen(
      taxLienService: widget.taxLienService,
      authService: widget.authService,
      databaseService: widget.databaseService,
    );
    
    _navigationItems[2].screen = NFTDashboardScreen(
      nftService: widget.nftService,
      taxLienService: widget.taxLienService,
    );
    
    _navigationItems[3].screen = SearchScreen(
      taxLienService: widget.taxLienService,
      databaseService: widget.databaseService,
    );
    
    _navigationItems[4].screen = ProfileScreen(
      authService: widget.authService,
      themeService: widget.themeService,
      localizationService: widget.localizationService,
      onboardingService: widget.onboardingService,
      walletService: widget.walletService,
      yukuService: widget.yukuService,
      plugWalletService: widget.plugWalletService,
      nftService: widget.nftService,
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