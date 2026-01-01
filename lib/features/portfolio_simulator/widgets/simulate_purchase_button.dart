import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/tax_lien_models.dart';
import '../models/simulated_portfolio.dart';
import '../models/simulated_position.dart';
import '../providers/simulator_provider.dart';
import '../constants/simulator_constants.dart';

/// Button widget for simulating property purchase
class SimulatePurchaseButton extends StatelessWidget {
  final TaxLien property;
  final SimulatedPortfolio portfolio;
  final double simulatedPrice;

  const SimulatePurchaseButton({
    super.key,
    required this.property,
    required this.portfolio,
    required this.simulatedPrice,
  });

  @override
  Widget build(BuildContext context) {
    final simulatorProvider = context.watch<SimulatorProvider>();
    final canAfford = portfolio.canAfford(simulatedPrice);
    final canAddPosition = simulatorProvider.canAddPosition(portfolio.id);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: (canAfford && canAddPosition)
            ? () => _handlePurchase(context)
            : null,
        icon: const Icon(Icons.shopping_cart),
        label: Text(_getButtonText(canAfford, canAddPosition)),
        style: ElevatedButton.styleFrom(
          backgroundColor: canAfford && canAddPosition
              ? Theme.of(context).primaryColor
              : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  String _getButtonText(bool canAfford, bool canAddPosition) {
    if (!canAfford) {
      return 'Insufficient Capital';
    }
    if (!canAddPosition) {
      return 'Position Limit Reached';
    }
    return 'Simulate Purchase - \$${simulatedPrice.toStringAsFixed(2)}';
  }

  Future<void> _handlePurchase(BuildContext context) async {
    final simulatorProvider = context.read<SimulatorProvider>();

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _buildConfirmationDialog(context),
    );

    if (confirmed != true) return;

    try {
      // Create simulated position
      final position = SimulatedPosition.create(
        portfolioId: portfolio.id,
        propertyId: property.id,
        propertyAddress: property.propertyAddress,
        county: property.county,
        state: property.state,
        purchasePrice: simulatedPrice,
        estimatedValue: property.estimatedValue,
        interestRate: property.interestRate,
        propertyType: property.propertyType,
        images: property.images,
      );

      // Add position to portfolio
      await simulatorProvider.addPosition(portfolio.id, position);

      // Show success feedback
      if (context.mounted) {
        _showSuccessDialog(context);
      }
    } catch (e) {
      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildConfirmationDialog(BuildContext context) {
    final potentialROI = ((property.estimatedValue - simulatedPrice) / simulatedPrice * 100);
    final remainingCapital = portfolio.availableCapital - simulatedPrice;

    return AlertDialog(
      title: const Text('Confirm Simulated Purchase'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.propertyAddress,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text('${property.county}, ${property.state}'),
          const Divider(height: 24),
          _buildDialogRow('Purchase Price', '\$${simulatedPrice.toStringAsFixed(2)}'),
          _buildDialogRow('Estimated Value', '\$${property.estimatedValue.toStringAsFixed(2)}'),
          _buildDialogRow('Potential ROI', '${potentialROI.toStringAsFixed(1)}%'),
          _buildDialogRow('Interest Rate', '${property.interestRate}%'),
          const Divider(height: 24),
          _buildDialogRow('Current Capital', '\$${portfolio.availableCapital.toStringAsFixed(2)}'),
          _buildDialogRow(
            'After Purchase',
            '\$${remainingCapital.toStringAsFixed(2)}',
            valueColor: remainingCapital >= 0 ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This is a simulation. No real money will be spent.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirm Purchase'),
        ),
      ],
    );
  }

  Widget _buildDialogRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 32),
            ),
            const SizedBox(width: 12),
            const Text('Purchase Successful!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your simulated position has been created.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Time Acceleration Active',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your investment is now simulating. '
                    'The outcome will be ready in ${SimulatorConstants.simulationDurationHours} hours '
                    '(simulated time: ${SimulatorConstants.simulationDurationHours * SimulatorConstants.timeAccelerationFactor} weeks).',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Browsing'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to portfolio
            },
            child: const Text('View Portfolio'),
          ),
        ],
      ),
    );
  }
}
