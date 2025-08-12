import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';
import '../services/onboarding_service.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/user_preferences_service.dart';
import '../theme/app_theme_export.dart';
import 'main_navigation_screen.dart';

class InteractiveOnboardingScreen extends StatefulWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;
  final UserPreferencesService userPreferencesService;

  const InteractiveOnboardingScreen({
    super.key,
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
    required this.userPreferencesService,
  });

  @override
  State<InteractiveOnboardingScreen> createState() => _InteractiveOnboardingScreenState();
}

class _InteractiveOnboardingScreenState extends State<InteractiveOnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentPage = 0;
  bool _isLoading = false;

  // User preferences
  String? _selectedInvestmentType; // 'lien' or 'deed'
  String? _selectedProfitType; // 'guaranteed' or 'collateral'
  List<String> _selectedCounties = [];
  double _investmentAmount = 1000.0;
  String _experienceLevel = 'beginner'; // 'beginner', 'intermediate', 'expert'
  bool _wantsNotifications = true;
  bool _wantsAutoBidding = false;

  // Available counties data
  final List<CountyData> _availableCounties = [
    CountyData('fl_dixie', 'Dixie County', 'FL', 'High interest rates, rural properties'),
    CountyData('fl_columbia', 'Columbia County', 'FL', 'Mixed urban/rural, good returns'),
    CountyData('fl_lafayette', 'Lafayette County', 'FL', 'Agricultural land, stable values'),
    CountyData('fl_bradford', 'Bradford County', 'FL', 'Small county, high competition'),
    CountyData('fl_okeechobee', 'Okeechobee County', 'FL', 'Lake area, tourism potential'),
    CountyData('fl_suwannee', 'Suwannee County', 'FL', 'River properties, natural beauty'),
    CountyData('fl_union', 'Union County', 'FL', 'Forest land, hunting properties'),
    CountyData('fl_clay', 'Clay County', 'FL', 'Suburban growth, family homes'),
    CountyData('fl_alachua', 'Alachua County', 'FL', 'University town, student housing'),
    CountyData('fl_polk', 'Polk County', 'FL', 'Central location, diverse properties'),
  ];

  final List<OnboardingStep> _steps = [
    OnboardingStep(
      id: 'welcome',
      title: 'Welcome to TaxLien Marketplace',
      subtitle: 'Your gateway to profitable real estate investments',
      type: OnboardingStepType.welcome,
    ),
    OnboardingStep(
      id: 'investment_type',
      title: 'What interests you more?',
      subtitle: 'Choose your primary investment focus',
      type: OnboardingStepType.investmentType,
    ),
    OnboardingStep(
      id: 'profit_preference',
      title: 'What matters most to you?',
      subtitle: 'Select your priority investment goal',
      type: OnboardingStepType.profitPreference,
    ),
    OnboardingStep(
      id: 'county_selection',
      title: 'Select your preferred counties',
      subtitle: 'Choose up to 5 counties to focus on',
      type: OnboardingStepType.countySelection,
    ),
    OnboardingStep(
      id: 'investment_amount',
      title: 'What\'s your investment budget?',
      subtitle: 'Set your typical investment amount',
      type: OnboardingStepType.investmentAmount,
    ),
    OnboardingStep(
      id: 'experience_level',
      title: 'What\'s your experience level?',
      subtitle: 'Help us customize your experience',
      type: OnboardingStepType.experienceLevel,
    ),
    OnboardingStep(
      id: 'preferences',
      title: 'Additional preferences',
      subtitle: 'Customize your investment experience',
      type: OnboardingStepType.preferences,
    ),
    OnboardingStep(
      id: 'summary',
      title: 'Perfect! Here\'s your setup',
      subtitle: 'Review your personalized configuration',
      type: OnboardingStepType.summary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return _buildStep(_steps[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: List.generate(
              _steps.length,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index <= _currentPage
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Step ${_currentPage + 1} of ${_steps.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(OnboardingStep step) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                step.subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _buildStepContent(step),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(OnboardingStep step) {
    switch (step.type) {
      case OnboardingStepType.welcome:
        return _buildWelcomeStep();
      case OnboardingStepType.investmentType:
        return _buildInvestmentTypeStep();
      case OnboardingStepType.profitPreference:
        return _buildProfitPreferenceStep();
      case OnboardingStepType.countySelection:
        return _buildCountySelectionStep();
      case OnboardingStepType.investmentAmount:
        return _buildInvestmentAmountStep();
      case OnboardingStepType.experienceLevel:
        return _buildExperienceLevelStep();
      case OnboardingStepType.preferences:
        return _buildPreferencesStep();
      case OnboardingStepType.summary:
        return _buildSummaryStep();
    }
  }

  Widget _buildWelcomeStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(60),
          ),
          child: Icon(
            Icons.trending_up,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Let\'s personalize your investment experience',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'We\'ll ask you a few questions to customize your dashboard and investment recommendations.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInvestmentTypeStep() {
    return Column(
      children: [
        _buildOptionCard(
          title: 'Tax Liens',
          subtitle: 'Earn guaranteed interest rates',
          description: 'Invest in unpaid property taxes and earn high interest rates (up to 18%) with government backing.',
          icon: Icons.receipt_long,
          isSelected: _selectedInvestmentType == 'lien',
          onTap: () => setState(() => _selectedInvestmentType = 'lien'),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          title: 'Tax Deeds',
          subtitle: 'Own the property',
          description: 'Purchase properties at auction for pennies on the dollar when owners don\'t redeem their liens.',
          icon: Icons.home,
          isSelected: _selectedInvestmentType == 'deed',
          onTap: () => setState(() => _selectedInvestmentType = 'deed'),
        ),
      ],
    );
  }

  Widget _buildProfitPreferenceStep() {
    return Column(
      children: [
        _buildOptionCard(
          title: 'Guaranteed Profit',
          subtitle: 'Steady income from interest',
          description: 'Focus on tax liens with high interest rates for predictable returns.',
          icon: Icons.security,
          isSelected: _selectedProfitType == 'guaranteed',
          onTap: () => setState(() => _selectedProfitType = 'guaranteed'),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          title: 'Collateral Property',
          subtitle: 'Potential for property ownership',
          description: 'Invest in liens where property owners are likely to default, giving you ownership.',
          icon: Icons.key,
          isSelected: _selectedProfitType == 'collateral',
          onTap: () => setState(() => _selectedProfitType = 'collateral'),
        ),
      ],
    );
  }

  Widget _buildCountySelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select up to 5 counties:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _availableCounties.length,
            itemBuilder: (context, index) {
              final county = _availableCounties[index];
              final isSelected = _selectedCounties.contains(county.id);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  title: Text('${county.name}, ${county.state}'),
                  subtitle: Text(county.description),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true && _selectedCounties.length < 5) {
                        _selectedCounties.add(county.id);
                      } else if (value == false) {
                        _selectedCounties.remove(county.id);
                      }
                    });
                  },
                  secondary: Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
              );
            },
          ),
        ),
        if (_selectedCounties.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Selected: ${_selectedCounties.length}/5',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInvestmentAmountStep() {
    return Column(
      children: [
        Text(
          '\$${_investmentAmount.toInt()}',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Slider(
          value: _investmentAmount,
          min: 100,
          max: 10000,
          divisions: 99,
          label: '\$${_investmentAmount.toInt()}',
          onChanged: (value) {
            setState(() {
              _investmentAmount = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$100', style: Theme.of(context).textTheme.bodySmall),
            Text('\$10,000', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'This will be your typical investment amount per lien',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExperienceLevelStep() {
    return Column(
      children: [
        _buildExperienceCard(
          title: 'Beginner',
          subtitle: 'New to tax lien investing',
          description: 'We\'ll provide detailed explanations and conservative recommendations.',
          icon: Icons.school,
          isSelected: _experienceLevel == 'beginner',
          onTap: () => setState(() => _experienceLevel = 'beginner'),
        ),
        const SizedBox(height: 16),
        _buildExperienceCard(
          title: 'Intermediate',
          subtitle: 'Some experience with liens',
          description: 'Balanced approach with moderate risk and detailed analytics.',
          icon: Icons.trending_up,
          isSelected: _experienceLevel == 'intermediate',
          onTap: () => setState(() => _experienceLevel = 'intermediate'),
        ),
        const SizedBox(height: 16),
        _buildExperienceCard(
          title: 'Expert',
          subtitle: 'Experienced investor',
          description: 'Advanced tools and high-risk, high-reward opportunities.',
          icon: Icons.psychology,
          isSelected: _experienceLevel == 'expert',
          onTap: () => setState(() => _experienceLevel = 'expert'),
        ),
      ],
    );
  }

  Widget _buildPreferencesStep() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Get alerts for new auctions and important updates'),
          value: _wantsNotifications,
          onChanged: (value) => setState(() => _wantsNotifications = value),
          secondary: const Icon(Icons.notifications),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Auto-Bidding'),
          subtitle: const Text('Automatically place bids up to your maximum amount'),
          value: _wantsAutoBidding,
          onChanged: (value) => setState(() => _wantsAutoBidding = value),
          secondary: const Icon(Icons.auto_awesome),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Investment Profile',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildSummaryItem('Investment Type', _selectedInvestmentType == 'lien' ? 'Tax Liens' : 'Tax Deeds'),
        _buildSummaryItem('Profit Focus', _selectedProfitType == 'guaranteed' ? 'Guaranteed Interest' : 'Property Ownership'),
        _buildSummaryItem('Counties', _selectedCounties.length > 0 ? '${_selectedCounties.length} selected' : 'None selected'),
        _buildSummaryItem('Investment Amount', '\$${_investmentAmount.toInt()}'),
        _buildSummaryItem('Experience Level', _experienceLevel.capitalize()),
        _buildSummaryItem('Notifications', _wantsNotifications ? 'Enabled' : 'Disabled'),
        _buildSummaryItem('Auto-Bidding', _wantsAutoBidding ? 'Enabled' : 'Disabled'),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'We\'ll customize your dashboard based on these preferences and show you the most relevant investment opportunities.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Back'),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _handleNext : null,
              child: Text(_currentPage < _steps.length - 1 ? 'Next' : 'Get Started'),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_steps[_currentPage].type) {
      case OnboardingStepType.welcome:
        return true;
      case OnboardingStepType.investmentType:
        return _selectedInvestmentType != null;
      case OnboardingStepType.profitPreference:
        return _selectedProfitType != null;
      case OnboardingStepType.countySelection:
        return _selectedCounties.isNotEmpty;
      case OnboardingStepType.investmentAmount:
        return _investmentAmount >= 100;
      case OnboardingStepType.experienceLevel:
        return _experienceLevel.isNotEmpty;
      case OnboardingStepType.preferences:
        return true;
      case OnboardingStepType.summary:
        return true;
    }
  }

  void _handleNext() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    // Save user preferences
    final preferences = UserPreferences(
      investmentType: _selectedInvestmentType,
      profitType: _selectedProfitType,
      selectedCounties: _selectedCounties,
      investmentAmount: _investmentAmount,
      experienceLevel: _experienceLevel,
      notifications: _wantsNotifications,
      autoBidding: _wantsAutoBidding,
      createdAt: DateTime.now(),
    );
    
    await widget.userPreferencesService.savePreferences(preferences);

    await widget.onboardingService.completeOnboarding();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(
            localizationService: widget.localizationService,
            themeService: widget.themeService,
            onboardingService: widget.onboardingService,
            taxLienService: widget.taxLienService,
            authService: widget.authService,
            databaseService: widget.databaseService,
            userPreferencesService: widget.userPreferencesService,
          ),
        ),
      );
    }
  }
}

class OnboardingStep {
  final String id;
  final String title;
  final String subtitle;
  final OnboardingStepType type;

  OnboardingStep({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

enum OnboardingStepType {
  welcome,
  investmentType,
  profitPreference,
  countySelection,
  investmentAmount,
  experienceLevel,
  preferences,
  summary,
}

class CountyData {
  final String id;
  final String name;
  final String state;
  final String description;

  CountyData(this.id, this.name, this.state, this.description);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
