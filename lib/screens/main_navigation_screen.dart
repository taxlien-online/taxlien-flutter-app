import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';
import '../services/onboarding_service.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme_export.dart';
import 'marketplace_screen.dart';
import 'my_investments_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;

  const MainNavigationScreen({
    super.key,
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Рынок',
      icon: Icons.store,
      screen: null, // Будет установлен в initState
    ),
    NavigationItem(
      title: 'Мои инвестиции',
      icon: Icons.trending_up,
      screen: null, // Будет установлен в initState
    ),
    NavigationItem(
      title: 'Поиск',
      icon: Icons.search,
      screen: null, // Будет установлен в initState
    ),
    NavigationItem(
      title: 'Профиль',
      icon: Icons.person,
      screen: null, // Будет установлен в initState
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Инициализация экранов
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
    
    _navigationItems[2].screen = SearchScreen(
      taxLienService: widget.taxLienService,
      databaseService: widget.databaseService,
    );
    
    _navigationItems[3].screen = ProfileScreen(
      authService: widget.authService,
      themeService: widget.themeService,
      localizationService: widget.localizationService,
      onboardingService: widget.onboardingService,
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