import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';
import '../services/onboarding_service.dart';
import '../services/tax_lien_service.dart';
import '../services/nft_service.dart';
import '../services/wallet_service.dart';
import '../services/yuku_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/user_preferences_service.dart';
import '../theme/app_theme_export.dart';
import 'main_navigation_screen.dart';
import 'nft_onboarding_screen.dart';
import 'wallet_connection_screen.dart';

class InteractiveOnboardingScreen extends StatefulWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final NFTService nftService;
  final WalletService walletService;
  final YukuService yukuService;
  final AuthService authService;
  final DatabaseService databaseService;
  final UserPreferencesService userPreferencesService;

  const InteractiveOnboardingScreen({
    super.key,
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.nftService,
    required this.walletService,
    required this.yukuService,
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
  List<String> _selectedInvestmentTypes = []; // 'lien' and/or 'deed'
  String? _selectedProfitType; // 'guaranteed' or 'collateral'
  List<String> _selectedCounties = [];
  List<String> _selectedStates = []; // New: for state-level selection
  double _investmentAmount = 1000.0;
  String _experienceLevel = 'beginner'; // 'beginner', 'intermediate', 'expert'
  bool _wantsNotifications = true;
  bool _wantsAutoBidding = false;

  // Hierarchical data structure for states and counties
  final List<StateData> _availableStates = [
    StateData(
      'FL',
      'Florida',
      [
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
      ],
    ),
    StateData(
      'TX',
      'Texas',
      [
        CountyData('tx_harris', 'Harris County', 'TX', 'Houston metro area, diverse opportunities'),
        CountyData('tx_dallas', 'Dallas County', 'TX', 'Dallas metro area, commercial properties'),
        CountyData('tx_travis', 'Travis County', 'TX', 'Austin area, tech boom properties'),
        CountyData('tx_bexar', 'Bexar County', 'TX', 'San Antonio area, historic properties'),
      ],
    ),
    StateData(
      'CA',
      'California',
      [
        CountyData('ca_los_angeles', 'Los Angeles County', 'CA', 'LA metro area, high-value properties'),
        CountyData('ca_san_diego', 'San Diego County', 'CA', 'Coastal properties, tourism potential'),
        CountyData('ca_orange', 'Orange County', 'CA', 'Suburban growth, family homes'),
      ],
    ),
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
      title: 'What interests you?',
      subtitle: 'Choose your investment focus (select one or both)',
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
      title: 'Select your preferred locations',
      subtitle: 'Choose states and/or specific counties',
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
      id: 'nft_tokenization',
      title: 'NFT Tokenization',
      subtitle: 'Transform your investments into digital assets',
      type: OnboardingStepType.nftTokenization,
    ),
    OnboardingStep(
      id: 'wallet_connection',
      title: 'Connect Wallet',
      subtitle: 'Connect your crypto wallet for NFT management',
      type: OnboardingStepType.walletConnection,
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
      case OnboardingStepType.nftTokenization:
        return _buildNFTTokenizationStep();
      case OnboardingStepType.walletConnection:
        return _buildWalletConnectionStep();
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
          isSelected: _selectedInvestmentTypes.contains('lien'),
          onTap: () {
            setState(() {
              if (_selectedInvestmentTypes.contains('lien')) {
                _selectedInvestmentTypes.remove('lien');
              } else {
                _selectedInvestmentTypes.add('lien');
              }
            });
          },
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          title: 'Tax Deeds',
          subtitle: 'Own the property',
          description: 'Purchase properties at auction for pennies on the dollar when owners don\'t redeem their liens.',
          icon: Icons.home,
          isSelected: _selectedInvestmentTypes.contains('deed'),
          onTap: () {
            setState(() {
              if (_selectedInvestmentTypes.contains('deed')) {
                _selectedInvestmentTypes.remove('deed');
              } else {
                _selectedInvestmentTypes.add('deed');
              }
            });
          },
        ),
        if (_selectedInvestmentTypes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You can select both investment types to diversify your portfolio',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          'Select states and/or specific counties:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'You can select entire states or specific counties within states',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _availableStates.length,
            itemBuilder: (context, stateIndex) {
              final state = _availableStates[stateIndex];
              final isStateSelected = _selectedStates.contains(state.code);
              final selectedCountiesInState = _selectedCounties
                  .where((countyId) => countyId.startsWith(state.code.toLowerCase()))
                  .length;
              final totalCountiesInState = state.counties.length;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: isStateSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              // Select entire state
                              _selectedStates.add(state.code);
                              // Remove individual counties from this state
                              _selectedCounties.removeWhere((countyId) => 
                                  countyId.startsWith(state.code.toLowerCase()));
                            } else {
                              // Deselect entire state
                              _selectedStates.remove(state.code);
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.name} (${state.code})',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isStateSelected)
                              Text(
                                'All ${totalCountiesInState} counties selected',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            else if (selectedCountiesInState > 0)
                              Text(
                                '$selectedCountiesInState of $totalCountiesInState counties selected',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  children: [
                    if (!isStateSelected) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: state.counties.map((county) {
                            final isCountySelected = _selectedCounties.contains(county.id);
                            
                            return CheckboxListTile(
                              title: Text(county.name),
                              subtitle: Text(county.description),
                              value: isCountySelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedCounties.add(county.id);
                                  } else {
                                    _selectedCounties.remove(county.id);
                                  }
                                });
                              },
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        if (_selectedStates.isNotEmpty || _selectedCounties.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Locations:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                if (_selectedStates.isNotEmpty) ...[
                  Text(
                    'States: ${_selectedStates.map((stateCode) => _availableStates.firstWhere((s) => s.code == stateCode).name).join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (_selectedCounties.isNotEmpty) ...[
                  if (_selectedStates.isNotEmpty) const SizedBox(height: 4),
                  Text(
                    'Counties: ${_selectedCounties.length} selected',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
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

  Widget _buildNFTTokenizationStep() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.token,
            size: 40,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'NFT Tokenization',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Transform your tax lien investments into digital assets on the blockchain for enhanced liquidity and transparency.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildNFTFeatureCard(
          title: 'ICP Blockchain',
          subtitle: 'Recommended for Tax Liens',
          description: 'Fast, secure, and cost-effective blockchain',
          icon: Icons.cloud,
          color: Colors.blue,
          isSelected: true,
        ),
        const SizedBox(height: 16),
        _buildNFTFeatureCard(
          title: 'Fractional Ownership',
          subtitle: 'Split large liens into tokens',
          description: 'Invest in expensive properties with smaller amounts',
          icon: Icons.pie_chart,
          color: Colors.green,
          isSelected: true,
        ),
        const SizedBox(height: 16),
        _buildNFTFeatureCard(
          title: 'Liquidity Pool',
          subtitle: 'Instant trading',
          description: 'Buy and sell tokens instantly',
          icon: Icons.water_drop,
          color: Colors.orange,
          isSelected: true,
        ),
        const SizedBox(height: 32),
        Text(
          'Would you like to explore NFT tokenization options?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Skip NFT setup
                },
                child: const Text('Skip for Now'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to detailed NFT screen
                  _showNFTOnboardingScreen();
                },
                child: const Text('Learn More'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletConnectionStep() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 40,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Connect Your Wallet',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Connect your crypto wallet to manage NFT tax liens, participate in trading, and access DeFi features.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildWalletFeatureCard(
          title: 'MetaMask',
          subtitle: 'Most Popular',
          description: 'Browser extension wallet with wide support',
          icon: Icons.account_balance_wallet,
          color: Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildWalletFeatureCard(
          title: 'WalletConnect',
          subtitle: 'Universal Connection',
          description: 'Connect any wallet via QR code',
          icon: Icons.wifi,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildWalletFeatureCard(
          title: 'Coinbase Wallet',
          subtitle: 'User Friendly',
          description: 'Easy-to-use wallet from Coinbase',
          icon: Icons.account_circle,
          color: Colors.blue,
        ),
        const SizedBox(height: 32),
        Text(
          'Would you like to connect a wallet now?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Skip wallet connection
                },
                child: const Text('Skip for Now'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to wallet connection screen
                  _showWalletConnectionScreen();
                },
                child: const Text('Connect Wallet'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletFeatureCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNFTFeatureCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return Card(
      elevation: isSelected ? 2 : 1,
      color: isSelected ? color.withOpacity(0.1) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
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
                      color: isSelected ? color : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? color : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _showNFTOnboardingScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NFTOnboardingScreen(
          preferencesService: widget.userPreferencesService,
          taxLienService: widget.taxLienService,
          onComplete: () {
            Navigator.of(context).pop();
            // Continue to next step
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }

  void _showWalletConnectionScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletConnectionScreen(
          walletService: widget.walletService,
          onWalletConnected: () {
            Navigator.of(context).pop();
            // Continue to next step
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
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
        _buildSummaryItem('Investment Type', _selectedInvestmentTypes.length > 0 ? _selectedInvestmentTypes.map((type) => type == 'lien' ? 'Tax Liens' : 'Tax Deeds').join(', ') : 'None selected'),
        _buildSummaryItem('Profit Focus', _selectedProfitType == 'guaranteed' ? 'Guaranteed Interest' : 'Property Ownership'),
        _buildSummaryItem('Locations', _buildLocationSummary()),
        _buildSummaryItem('Investment Amount', '\$${_investmentAmount.toInt()}'),
        _buildSummaryItem('Experience Level', _experienceLevel.capitalize()),
        _buildSummaryItem('Notifications', _wantsNotifications ? 'Enabled' : 'Disabled'),
        _buildSummaryItem('Auto-Bidding', _wantsAutoBidding ? 'Enabled' : 'Disabled'),
        _buildSummaryItem('NFT Tokenization', widget.userPreferencesService.wantsNFTTokenization ? 'Enabled' : 'Disabled'),
        if (widget.userPreferencesService.wantsNFTTokenization) ...[
          _buildSummaryItem('Blockchain', widget.userPreferencesService.wantsICPNFT ? 'ICP' : 'Traditional'),
          _buildSummaryItem('NFT Allocation', '${widget.userPreferencesService.nftInvestmentPercentage.toInt()}%'),
        ],
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

  String _buildLocationSummary() {
    final List<String> parts = [];
    
    if (_selectedStates.isNotEmpty) {
      final stateNames = _selectedStates.map((stateCode) => 
          _availableStates.firstWhere((s) => s.code == stateCode).name).join(', ');
      parts.add('States: $stateNames');
    }
    
    if (_selectedCounties.isNotEmpty) {
      parts.add('Counties: ${_selectedCounties.length} selected');
    }
    
    if (parts.isEmpty) {
      return 'None selected';
    }
    
    return parts.join('; ');
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
        return _selectedInvestmentTypes.isNotEmpty;
      case OnboardingStepType.profitPreference:
        return _selectedProfitType != null;
              case OnboardingStepType.countySelection:
        return _selectedStates.isNotEmpty || _selectedCounties.isNotEmpty;
      case OnboardingStepType.investmentAmount:
        return _investmentAmount >= 100;
      case OnboardingStepType.experienceLevel:
        return _experienceLevel.isNotEmpty;
      case OnboardingStepType.preferences:
        return true;
      case OnboardingStepType.nftTokenization:
        return true;
      case OnboardingStepType.walletConnection:
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
      investmentType: _selectedInvestmentTypes.join(','),
      profitType: _selectedProfitType,
      selectedCounties: _selectedCounties,
      selectedStates: _selectedStates,
      investmentAmount: _investmentAmount,
      experienceLevel: _experienceLevel,
      notifications: _wantsNotifications,
      autoBidding: _wantsAutoBidding,
      wantsNFTTokenization: true, // Default to true for now
      wantsICPNFT: true,
      wantsTraditionalNFT: false,
      wantsFractionalOwnership: true,
      wantsLiquidityPool: true,
      nftInvestmentPercentage: 25.0,
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
              nftService: widget.nftService,
              walletService: widget.walletService,
              yukuService: widget.yukuService,
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
  nftTokenization,
  walletConnection,
  summary,
}

class CountyData {
  final String id;
  final String name;
  final String state;
  final String description;

  CountyData(this.id, this.name, this.state, this.description);
}

class StateData {
  final String code;
  final String name;
  final List<CountyData> counties;

  StateData(this.code, this.name, this.counties);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
