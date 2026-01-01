import 'package:flutter/material.dart';
import '../models/simulated_portfolio.dart';

/// Card widget displaying portfolio summary
///
/// Shows portfolio name, total value, ROI, and position count.
/// Tapping the card navigates to portfolio detail screen.
class PortfolioCard extends StatelessWidget {
  final SimulatedPortfolio portfolio;
  final VoidCallback onTap;

  const PortfolioCard({
    super.key,
    required this.portfolio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositiveROI = portfolio.roi >= 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surface.withOpacity(0.95),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Portfolio Name
              Row(
                children: [
                  Expanded(
                    child: Text(
                      portfolio.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (portfolio.isArchived)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Archived',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Total Value
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Total Value',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '\$${portfolio.totalValue.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),

              // ROI and Positions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ROI
                  Expanded(
                    child: _StatItem(
                      icon: isPositiveROI
                          ? Icons.trending_up
                          : Icons.trending_down,
                      label: 'ROI',
                      value: '${portfolio.roi >= 0 ? '+' : ''}${portfolio.roi.toStringAsFixed(2)}%',
                      color: isPositiveROI ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Positions
                  Expanded(
                    child: _StatItem(
                      icon: Icons.pie_chart,
                      label: 'Positions',
                      value: '${portfolio.positionCount}',
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Available Capital
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Capital',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '\$${portfolio.availableCapital.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper widget for displaying stat items
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
