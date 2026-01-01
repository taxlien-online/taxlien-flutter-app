import 'package:flutter/material.dart';
import '../constants/simulator_constants.dart';

/// Upgrade prompt dialog for free users
///
/// Shows benefits of upgrading to premium
class UpgradePromptDialog extends StatelessWidget {
  final String reason;

  const UpgradePromptDialog({
    super.key,
    required this.reason,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String reason,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => UpgradePromptDialog(reason: reason),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[700]!, Colors.purple[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: 64,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Upgrade to Premium',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Benefits list
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Premium Benefits:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBenefit(
                    icon: Icons.folder_open,
                    title: 'Unlimited Portfolios',
                    description:
                        'Create as many portfolios as you want (vs ${SimulatorConstants.freeMaxPortfolios} for free)',
                  ),
                  _buildBenefit(
                    icon: Icons.list,
                    title: 'Unlimited Positions',
                    description:
                        'Simulate unlimited investments (vs ${SimulatorConstants.freeMaxPositions} for free)',
                  ),
                  _buildBenefit(
                    icon: Icons.speed,
                    title: 'Faster Simulation',
                    description: 'Access 2x and 4x speed modes',
                  ),
                  _buildBenefit(
                    icon: Icons.analytics,
                    title: 'Advanced Analytics',
                    description: 'Detailed performance reports and insights',
                  ),
                  _buildBenefit(
                    icon: Icons.cloud_download,
                    title: 'Export Data',
                    description: 'Download your simulation history as CSV',
                  ),
                  _buildBenefit(
                    icon: Icons.priority_high,
                    title: 'Priority Support',
                    description: 'Get help faster when you need it',
                  ),
                  const SizedBox(height: 24),

                  // Price
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Just \$9.99/month',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cancel anytime',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Maybe Later'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Upgrade Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: Colors.purple[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple upgrade banner for free users
class UpgradeBanner extends StatelessWidget {
  final VoidCallback onTap;

  const UpgradeBanner({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[700]!, Colors.purple[500]!],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.workspace_premium,
              color: Colors.amber,
              size: 32,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Premium',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Unlock unlimited portfolios & positions',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
