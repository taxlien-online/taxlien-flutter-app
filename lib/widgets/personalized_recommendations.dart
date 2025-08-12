import 'package:flutter/material.dart';
import '../services/user_preferences_service.dart';
import '../services/tax_lien_service.dart';

class PersonalizedRecommendations extends StatelessWidget {
  final UserPreferencesService preferencesService;
  final TaxLienService taxLienService;

  const PersonalizedRecommendations({
    super.key,
    required this.preferencesService,
    required this.taxLienService,
  });

  @override
  Widget build(BuildContext context) {
    if (!preferencesService.hasPreferences) {
      return _buildNoPreferencesCard(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildRecommendationsList(context),
      ],
    );
  }

  Widget _buildNoPreferencesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.person_add,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Personalize Your Experience',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your profile to get personalized investment recommendations',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to preferences screen
              },
              child: const Text('Set Preferences'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.recommend,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'Recommended for You',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsList(BuildContext context) {
    final preferences = preferencesService.preferences!;
    final recommendations = _generateRecommendations(preferences);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        return _buildRecommendationCard(context, recommendations[index]);
      },
    );
  }

  Widget _buildRecommendationCard(BuildContext context, InvestmentRecommendation recommendation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: recommendation.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    recommendation.icon,
                    color: recommendation.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        recommendation.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: recommendation.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    recommendation.matchPercentage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: recommendation.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              recommendation.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to filtered marketplace
                    },
                    child: const Text('View Opportunities'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to specific recommendation
                  },
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<InvestmentRecommendation> _generateRecommendations(UserPreferences preferences) {
    final recommendations = <InvestmentRecommendation>[];

    // Investment type recommendations
    if (preferences.investmentType == 'lien') {
      recommendations.add(
        InvestmentRecommendation(
          title: 'High-Interest Tax Liens',
          subtitle: 'Based on your preference for guaranteed returns',
          description: 'Focus on liens with interest rates above 12% in your selected counties. These provide steady income with government backing.',
          icon: Icons.trending_up,
          color: Colors.green,
          matchPercentage: '95% Match',
        ),
      );
    } else if (preferences.investmentType == 'deed') {
      recommendations.add(
        InvestmentRecommendation(
          title: 'Property Acquisition Opportunities',
          subtitle: 'Based on your interest in property ownership',
          description: 'Look for liens in areas with high default rates where you might acquire properties at significant discounts.',
          icon: Icons.home,
          color: Colors.blue,
          matchPercentage: '90% Match',
        ),
      );
    }

    // Profit type recommendations
    if (preferences.profitType == 'guaranteed') {
      recommendations.add(
        InvestmentRecommendation(
          title: 'Conservative Investment Strategy',
          subtitle: 'Based on your preference for guaranteed profits',
          description: 'Focus on liens with high interest rates and low-risk properties in stable neighborhoods.',
          icon: Icons.security,
          color: Colors.orange,
          matchPercentage: '88% Match',
        ),
      );
    } else if (preferences.profitType == 'collateral') {
      recommendations.add(
        InvestmentRecommendation(
          title: 'High-Risk, High-Reward Strategy',
          subtitle: 'Based on your interest in property acquisition',
          description: 'Target liens on properties with high market values but distressed owners who may default.',
          icon: Icons.key,
          color: Colors.purple,
          matchPercentage: '85% Match',
        ),
      );
    }

    // County-specific recommendations
    if (preferences.selectedCounties.isNotEmpty) {
      final countyNames = preferences.selectedCounties
          .map((id) => _getCountyDisplayName(id))
          .join(', ');
      
      recommendations.add(
        InvestmentRecommendation(
          title: 'County-Specific Opportunities',
          subtitle: 'Based on your selected counties: $countyNames',
          description: 'We\'ve identified the best opportunities in your preferred counties based on current market conditions.',
          icon: Icons.location_on,
          color: Colors.red,
          matchPercentage: '92% Match',
        ),
      );
    }

    // Experience level recommendations
    if (preferences.experienceLevel == 'beginner') {
      recommendations.add(
        InvestmentRecommendation(
          title: 'Beginner-Friendly Investments',
          subtitle: 'Based on your experience level',
          description: 'Start with smaller liens in well-established areas with clear documentation and predictable outcomes.',
          icon: Icons.school,
          color: Colors.teal,
          matchPercentage: '87% Match',
        ),
      );
    } else if (preferences.experienceLevel == 'expert') {
      recommendations.add(
        InvestmentRecommendation(
          title: 'Advanced Investment Strategies',
          subtitle: 'Based on your experience level',
          description: 'Explore complex liens, bulk purchases, and distressed property opportunities with higher potential returns.',
          icon: Icons.psychology,
          color: Colors.indigo,
          matchPercentage: '93% Match',
        ),
      );
    }

    // Investment amount recommendations
    if (preferences.investmentAmount >= 5000) {
      recommendations.add(
        InvestmentRecommendation(
          title: 'Premium Investment Opportunities',
          subtitle: 'Based on your investment budget',
          description: 'With your budget, you can access higher-value liens and bulk purchase opportunities for better diversification.',
          icon: Icons.attach_money,
          color: Colors.amber,
          matchPercentage: '89% Match',
        ),
      );
    }

    return recommendations.take(5).toList(); // Limit to 5 recommendations
  }

  String _getCountyDisplayName(String countyId) {
    final countyMap = {
      'fl_dixie': 'Dixie County',
      'fl_columbia': 'Columbia County',
      'fl_lafayette': 'Lafayette County',
      'fl_bradford': 'Bradford County',
      'fl_okeechobee': 'Okeechobee County',
      'fl_suwannee': 'Suwannee County',
      'fl_union': 'Union County',
      'fl_clay': 'Clay County',
      'fl_alachua': 'Alachua County',
      'fl_polk': 'Polk County',
    };
    
    return countyMap[countyId] ?? countyId;
  }
}

class InvestmentRecommendation {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String matchPercentage;

  InvestmentRecommendation({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.matchPercentage,
  });
}
