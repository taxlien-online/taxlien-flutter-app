import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/user_preferences_service.dart';
import '../services/tax_lien_service.dart';

class NFTOnboardingScreen extends StatefulWidget {
  final UserPreferencesService preferencesService;
  final TaxLienService taxLienService;
  final VoidCallback onComplete;

  const NFTOnboardingScreen({
    super.key,
    required this.preferencesService,
    required this.taxLienService,
    required this.onComplete,
  });

  @override
  State<NFTOnboardingScreen> createState() => _NFTOnboardingScreenState();
}

class _NFTOnboardingScreenState extends State<NFTOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _wantsNFTTokenization = false;
  bool _wantsICPNFT = false;
  bool _wantsTraditionalNFT = false;
  bool _wantsFractionalOwnership = false;
  bool _wantsLiquidityPool = false;
  double _nftInvestmentPercentage = 25.0;
  bool _isLoading = false;

  final List<NFTFeature> _nftFeatures = [
    NFTFeature(
      title: 'ICP Blockchain',
      subtitle: 'Internet Computer Protocol',
      description: 'Decentralized, fast, and secure blockchain for tax lien tokenization',
      icon: Icons.cloud,
      color: Colors.blue,
      benefits: [
        'Sub-second finality',
        'Low transaction costs',
        'Built-in identity management',
        'Scalable infrastructure'
      ],
    ),
    NFTFeature(
      title: 'Traditional NFT',
      subtitle: 'Ethereum/Polygon',
      description: 'Standard NFT tokens on popular blockchains',
      icon: Icons.token,
      color: Colors.purple,
      benefits: [
        'Wide adoption',
        'Established ecosystem',
        'Multiple marketplaces',
        'Proven technology'
      ],
    ),
    NFTFeature(
      title: 'Fractional Ownership',
      subtitle: 'Split large liens',
      description: 'Divide expensive tax liens into smaller, affordable pieces',
      icon: Icons.pie_chart,
      color: Colors.green,
      benefits: [
        'Lower entry barriers',
        'Diversification',
        'Liquidity options',
        'Risk distribution'
      ],
    ),
    NFTFeature(
      title: 'Liquidity Pool',
      subtitle: 'Automated trading',
      description: 'Automated market making for instant buying and selling',
      icon: Icons.water_drop,
      color: Colors.orange,
      benefits: [
        'Instant liquidity',
        'Price discovery',
        'Reduced slippage',
        'Automated trading'
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFT Tokenization'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildNFTOverview(),
                const SizedBox(height: 32),
                _buildBlockchainSelection(),
                const SizedBox(height: 32),
                _buildNFTFeatures(),
                const SizedBox(height: 32),
                _buildInvestmentAllocation(),
                const SizedBox(height: 32),
                _buildBenefitsSection(),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          'Tokenize Your Tax Liens',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Transform your tax lien investments into digital assets on the blockchain',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildNFTOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'What is NFT Tokenization?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'NFT tokenization converts your tax lien investments into digital tokens on the blockchain. This provides:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildBenefitItem('Liquidity', 'Sell your tokens instantly on NFT marketplaces'),
            _buildBenefitItem('Transparency', 'All transactions recorded on the blockchain'),
            _buildBenefitItem('Accessibility', 'Invest in tax liens with smaller amounts'),
            _buildBenefitItem('Security', 'Immutable ownership records'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildBlockchainSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Blockchain',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildBlockchainOption(
          title: 'ICP (Internet Computer)',
          subtitle: 'Recommended for Tax Liens',
          description: 'Fast, secure, and cost-effective blockchain specifically designed for DeFi applications',
          icon: Icons.cloud,
          color: Colors.blue,
          isSelected: _wantsICPNFT,
          onTap: () => setState(() {
            _wantsICPNFT = true;
            _wantsTraditionalNFT = false;
          }),
        ),
        const SizedBox(height: 12),
        _buildBlockchainOption(
          title: 'Traditional (Ethereum/Polygon)',
          subtitle: 'Established Ecosystem',
          description: 'Widely adopted blockchains with extensive marketplace support',
          icon: Icons.token,
          color: Colors.purple,
          isSelected: _wantsTraditionalNFT,
          onTap: () => setState(() {
            _wantsTraditionalNFT = true;
            _wantsICPNFT = false;
          }),
        ),
      ],
    );
  }

  Widget _buildBlockchainOption({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? color.withOpacity(0.1) : null,
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
                    const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _buildNFTFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NFT Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureToggle(
          title: 'Fractional Ownership',
          subtitle: 'Split large tax liens into smaller tokens',
          description: 'Invest in expensive properties with smaller amounts',
          isSelected: _wantsFractionalOwnership,
          onChanged: (value) => setState(() => _wantsFractionalOwnership = value),
        ),
        const SizedBox(height: 12),
        _buildFeatureToggle(
          title: 'Liquidity Pool',
          subtitle: 'Automated trading for instant liquidity',
          description: 'Buy and sell tokens instantly without waiting for buyers',
          isSelected: _wantsLiquidityPool,
          onChanged: (value) => setState(() => _wantsLiquidityPool = value),
        ),
      ],
    );
  }

  Widget _buildFeatureToggle({
    required String title,
    required String subtitle,
    required String description,
    required bool isSelected,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
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
        value: isSelected,
        onChanged: onChanged,
        secondary: Icon(
          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
    );
  }

  Widget _buildInvestmentAllocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NFT Investment Allocation',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What percentage of your investments would you like to tokenize as NFTs?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            '${_nftInvestmentPercentage.toInt()}%',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _nftInvestmentPercentage,
          min: 0,
          max: 100,
          divisions: 20,
          label: '${_nftInvestmentPercentage.toInt()}%',
          onChanged: (value) {
            setState(() {
              _nftInvestmentPercentage = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: Theme.of(context).textTheme.bodySmall),
            Text('100%', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 16),
        _buildAllocationInfo(),
      ],
    );
  }

  Widget _buildAllocationInfo() {
    final preferences = widget.preferencesService.preferences;
    final investmentAmount = preferences?.investmentAmount ?? 1000.0;
    final nftAmount = (investmentAmount * _nftInvestmentPercentage / 100);
    final traditionalAmount = investmentAmount - nftAmount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investment Breakdown',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildAllocationRow('NFT Tokens', nftAmount, Colors.blue),
            _buildAllocationRow('Traditional Liens', traditionalAmount, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(
            '\$${amount.toInt()}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits of NFT Tokenization',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: _nftFeatures.length,
          itemBuilder: (context, index) {
            return _buildFeatureCard(_nftFeatures[index]);
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(NFTFeature feature) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: feature.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                feature.icon,
                color: feature.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feature.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              feature.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: feature.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feature.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            ...feature.benefits.take(2).map((benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    size: 12,
                    color: feature.color,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      benefit,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _completeNFTOnboarding,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    'Complete NFT Setup',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            // Skip NFT setup
            widget.onComplete();
          },
          child: const Text('Skip for Now'),
        ),
      ],
    );
  }

  void _completeNFTOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Save NFT preferences
      final currentPreferences = widget.preferencesService.preferences;
      if (currentPreferences != null) {
        final updatedPreferences = currentPreferences.copyWith(
          wantsNFTTokenization: true,
          wantsICPNFT: _wantsICPNFT,
          wantsTraditionalNFT: _wantsTraditionalNFT,
          wantsFractionalOwnership: _wantsFractionalOwnership,
          wantsLiquidityPool: _wantsLiquidityPool,
          nftInvestmentPercentage: _nftInvestmentPercentage,
        );
        await widget.preferencesService.savePreferences(updatedPreferences);
      } else {
        // Create new preferences if none exist
        final newPreferences = UserPreferences(
          investmentType: null,
          profitType: null,
          selectedCounties: [],
          selectedStates: [],
          investmentAmount: 1000.0,
          experienceLevel: 'beginner',
          notifications: true,
          autoBidding: false,
          wantsNFTTokenization: true,
          wantsICPNFT: _wantsICPNFT,
          wantsTraditionalNFT: _wantsTraditionalNFT,
          wantsFractionalOwnership: _wantsFractionalOwnership,
          wantsLiquidityPool: _wantsLiquidityPool,
          nftInvestmentPercentage: _nftInvestmentPercentage,
          createdAt: DateTime.now(),
        );
        await widget.preferencesService.savePreferences(newPreferences);
      }

      // Haptic feedback
      HapticFeedback.lightImpact();

      // Complete onboarding
      widget.onComplete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving NFT preferences: $e'),
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

class NFTFeature {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> benefits;

  NFTFeature({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.benefits,
  });
}
