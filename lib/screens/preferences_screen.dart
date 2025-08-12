import 'package:flutter/material.dart';
import '../services/user_preferences_service.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';

class PreferencesScreen extends StatefulWidget {
  final UserPreferencesService preferencesService;
  final LocalizationService localizationService;
  final ThemeService themeService;

  const PreferencesScreen({
    super.key,
    required this.preferencesService,
    required this.localizationService,
    required this.themeService,
  });

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String? _selectedInvestmentType;
  String? _selectedProfitType;
  List<String> _selectedCounties = [];
  double _investmentAmount = 1000.0;
  String _experienceLevel = 'beginner';
  bool _wantsNotifications = true;
  bool _wantsAutoBidding = false;
  bool _isLoading = false;

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

  @override
  void initState() {
    super.initState();
    _loadCurrentPreferences();
  }

  void _loadCurrentPreferences() {
    final preferences = widget.preferencesService.preferences;
    if (preferences != null) {
      setState(() {
        _selectedInvestmentType = preferences.investmentType;
        _selectedProfitType = preferences.profitType;
        _selectedCounties = List.from(preferences.selectedCounties);
        _investmentAmount = preferences.investmentAmount;
        _experienceLevel = preferences.experienceLevel;
        _wantsNotifications = preferences.notifications;
        _wantsAutoBidding = preferences.autoBidding;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Preferences'),
        actions: [
          if (widget.preferencesService.hasPreferences)
            TextButton(
              onPressed: _savePreferences,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInvestmentTypeSection(),
                  const SizedBox(height: 24),
                  _buildProfitPreferenceSection(),
                  const SizedBox(height: 24),
                  _buildCountySelectionSection(),
                  const SizedBox(height: 24),
                  _buildInvestmentAmountSection(),
                  const SizedBox(height: 24),
                  _buildExperienceLevelSection(),
                  const SizedBox(height: 24),
                  _buildAdditionalPreferencesSection(),
                  const SizedBox(height: 32),
                  if (widget.preferencesService.hasPreferences)
                    _buildResetButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildInvestmentTypeSection() {
    return _buildSection(
      title: 'Investment Type',
      subtitle: 'What interests you more?',
      child: Column(
        children: [
          _buildOptionCard(
            title: 'Tax Liens',
            subtitle: 'Earn guaranteed interest rates',
            description: 'Invest in unpaid property taxes and earn high interest rates (up to 18%) with government backing.',
            icon: Icons.receipt_long,
            isSelected: _selectedInvestmentType == 'lien',
            onTap: () => setState(() => _selectedInvestmentType = 'lien'),
          ),
          const SizedBox(height: 12),
          _buildOptionCard(
            title: 'Tax Deeds',
            subtitle: 'Own the property',
            description: 'Purchase properties at auction for pennies on the dollar when owners don\'t redeem their liens.',
            icon: Icons.home,
            isSelected: _selectedInvestmentType == 'deed',
            onTap: () => setState(() => _selectedInvestmentType = 'deed'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitPreferenceSection() {
    return _buildSection(
      title: 'Profit Preference',
      subtitle: 'What matters most to you?',
      child: Column(
        children: [
          _buildOptionCard(
            title: 'Guaranteed Profit',
            subtitle: 'Steady income from interest',
            description: 'Focus on tax liens with high interest rates for predictable returns.',
            icon: Icons.security,
            isSelected: _selectedProfitType == 'guaranteed',
            onTap: () => setState(() => _selectedProfitType = 'guaranteed'),
          ),
          const SizedBox(height: 12),
          _buildOptionCard(
            title: 'Collateral Property',
            subtitle: 'Potential for property ownership',
            description: 'Invest in liens where property owners are likely to default, giving you ownership.',
            icon: Icons.key,
            isSelected: _selectedProfitType == 'collateral',
            onTap: () => setState(() => _selectedProfitType = 'collateral'),
          ),
        ],
      ),
    );
  }

  Widget _buildCountySelectionSection() {
    return _buildSection(
      title: 'Preferred Counties',
      subtitle: 'Select up to 5 counties to focus on',
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
          if (_selectedCounties.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Selected: ${_selectedCounties.length}/5',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInvestmentAmountSection() {
    return _buildSection(
      title: 'Investment Amount',
      subtitle: 'Your typical investment amount per lien',
      child: Column(
        children: [
          Text(
            '\$${_investmentAmount.toInt()}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$100', style: Theme.of(context).textTheme.bodySmall),
              Text('\$10,000', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceLevelSection() {
    return _buildSection(
      title: 'Experience Level',
      subtitle: 'Help us customize your experience',
      child: Column(
        children: [
          _buildExperienceCard(
            title: 'Beginner',
            subtitle: 'New to tax lien investing',
            description: 'We\'ll provide detailed explanations and conservative recommendations.',
            icon: Icons.school,
            isSelected: _experienceLevel == 'beginner',
            onTap: () => setState(() => _experienceLevel = 'beginner'),
          ),
          const SizedBox(height: 12),
          _buildExperienceCard(
            title: 'Intermediate',
            subtitle: 'Some experience with liens',
            description: 'Balanced approach with moderate risk and detailed analytics.',
            icon: Icons.trending_up,
            isSelected: _experienceLevel == 'intermediate',
            onTap: () => setState(() => _experienceLevel = 'intermediate'),
          ),
          const SizedBox(height: 12),
          _buildExperienceCard(
            title: 'Expert',
            subtitle: 'Experienced investor',
            description: 'Advanced tools and high-risk, high-reward opportunities.',
            icon: Icons.psychology,
            isSelected: _experienceLevel == 'expert',
            onTap: () => setState(() => _experienceLevel = 'expert'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalPreferencesSection() {
    return _buildSection(
      title: 'Additional Preferences',
      subtitle: 'Customize your investment experience',
      child: Column(
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
      ),
    );
  }

  Widget _buildResetButton() {
    return Center(
      child: TextButton(
        onPressed: _showResetConfirmation,
        child: const Text('Reset to Default Preferences'),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        child,
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
      elevation: isSelected ? 2 : 1,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
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
      elevation: isSelected ? 2 : 1,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
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

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Preferences'),
        content: const Text('Are you sure you want to reset all your preferences to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetPreferences();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetPreferences() {
    setState(() {
      _selectedInvestmentType = null;
      _selectedProfitType = null;
      _selectedCounties = [];
      _investmentAmount = 1000.0;
      _experienceLevel = 'beginner';
      _wantsNotifications = true;
      _wantsAutoBidding = false;
    });
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
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

      await widget.preferencesService.savePreferences(preferences);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class CountyData {
  final String id;
  final String name;
  final String state;
  final String description;

  CountyData(this.id, this.name, this.state, this.description);
}
