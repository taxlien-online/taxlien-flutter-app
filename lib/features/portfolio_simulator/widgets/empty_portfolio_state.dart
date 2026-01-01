import 'package:flutter/material.dart';

/// Empty state widget shown when user has no portfolios
///
/// Provides visual guidance and encourages user to create their first portfolio.
class EmptyPortfolioState extends StatelessWidget {
  final VoidCallback onCreatePortfolio;

  const EmptyPortfolioState({
    super.key,
    required this.onCreatePortfolio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Icon(
              Icons.pie_chart_outline,
              size: 120,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'No Portfolios Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'Create your first practice portfolio to start learning tax lien investing with virtual money.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Create Button
            ElevatedButton.icon(
              onPressed: onCreatePortfolio,
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Portfolio'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Features List
            _FeatureItem(
              icon: Icons.trending_up,
              title: 'Risk-Free Learning',
              description: 'Practice with \$100K virtual capital',
            ),
            const SizedBox(height: 16),
            _FeatureItem(
              icon: Icons.access_time,
              title: 'Accelerated Results',
              description: '1 hour = 1 week of simulation',
            ),
            const SizedBox(height: 16),
            _FeatureItem(
              icon: Icons.school,
              title: 'Learn From Outcomes',
              description: 'Get insights on every investment',
            ),
          ],
        ),
      ),
    );
  }
}

/// Feature item widget
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
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
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
