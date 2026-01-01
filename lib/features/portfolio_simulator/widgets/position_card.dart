import 'package:flutter/material.dart';
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';

/// Widget displaying a simulated position
class PositionCard extends StatelessWidget {
  final SimulatedPosition position;
  final SimulationOutcome? outcome;

  const PositionCard({
    super.key,
    required this.position,
    this.outcome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = outcome != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isCompleted ? () => _showOutcomeDetails(context) : null,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property image
                  if (position.images.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        position.images.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.home, size: 32),
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 12),

                  // Property info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          position.propertyAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${position.county}, ${position.state}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStatusChip(),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Financial details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailColumn('Purchase Price',
                      '\$${position.purchasePrice.toStringAsFixed(2)}'),
                  _buildDetailColumn('Est. Value',
                      '\$${position.estimatedValue.toStringAsFixed(2)}'),
                  if (isCompleted && outcome != null)
                    _buildDetailColumn(
                      'Final Value',
                      '\$${outcome!.finalValue.toStringAsFixed(2)}',
                      valueColor: outcome!.profitLoss >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                ],
              ),

              // Outcome summary (if completed)
              if (isCompleted && outcome != null) ...[
                const Divider(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getOutcomeColor(outcome!.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getOutcomeIcon(outcome!.type),
                        color: _getOutcomeColor(outcome!.type),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getOutcomeTitle(outcome!.type),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getOutcomeColor(outcome!.type),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'P/L: \$${outcome!.profitLoss.toStringAsFixed(2)} (${outcome!.roi.toStringAsFixed(1)}% ROI)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ],

              // Time info (if active)
              if (!isCompleted) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Text(
                      _getTimeRemainingText(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (position.status) {
      case PositionStatus.purchased:
        backgroundColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue[700]!;
        text = 'Purchased';
        break;
      case PositionStatus.simulating:
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange[700]!;
        text = 'Simulating';
        break;
      case PositionStatus.outcomeReady:
        backgroundColor = Colors.purple.withOpacity(0.2);
        textColor = Colors.purple[700]!;
        text = 'Ready';
        break;
      case PositionStatus.completed:
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green[700]!;
        text = 'Completed';
        break;
      case PositionStatus.closed:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey[700]!;
        text = 'Closed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value,
      {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _getTimeRemainingText() {
    final now = DateTime.now();
    final timeRemaining = position.timeUntilOutcome(now, 1.0);

    if (timeRemaining.inMinutes < 60) {
      return '${timeRemaining.inMinutes}m remaining';
    } else if (timeRemaining.inHours < 24) {
      return '${timeRemaining.inHours}h remaining';
    } else {
      return '${timeRemaining.inDays}d remaining';
    }
  }

  Color _getOutcomeColor(OutcomeType type) {
    switch (type) {
      case OutcomeType.redeemed:
        return Colors.green;
      case OutcomeType.foreclosed:
        return Colors.blue;
      case OutcomeType.partialPayment:
        return Colors.orange;
      case OutcomeType.loss:
        return Colors.red;
    }
  }

  IconData _getOutcomeIcon(OutcomeType type) {
    switch (type) {
      case OutcomeType.redeemed:
        return Icons.check_circle;
      case OutcomeType.foreclosed:
        return Icons.home;
      case OutcomeType.partialPayment:
        return Icons.account_balance;
      case OutcomeType.loss:
        return Icons.error;
    }
  }

  String _getOutcomeTitle(OutcomeType type) {
    switch (type) {
      case OutcomeType.redeemed:
        return 'Redeemed';
      case OutcomeType.foreclosed:
        return 'Foreclosed - You Own Property';
      case OutcomeType.partialPayment:
        return 'Partial Payment';
      case OutcomeType.loss:
        return 'Loss';
    }
  }

  void _showOutcomeDetails(BuildContext context) {
    if (outcome == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getOutcomeIcon(outcome!.type),
                  color: _getOutcomeColor(outcome!.type),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  _getOutcomeTitle(outcome!.type),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildOutcomeDetailRow('Purchase Price',
                '\$${position.purchasePrice.toStringAsFixed(2)}'),
            _buildOutcomeDetailRow(
                'Final Value', '\$${outcome!.finalValue.toStringAsFixed(2)}'),
            _buildOutcomeDetailRow(
              'Profit/Loss',
              '\$${outcome!.profitLoss.toStringAsFixed(2)}',
              valueColor:
                  outcome!.profitLoss >= 0 ? Colors.green : Colors.red,
            ),
            _buildOutcomeDetailRow(
              'ROI',
              '${outcome!.roi.toStringAsFixed(1)}%',
              valueColor:
                  outcome!.roi >= 0 ? Colors.green : Colors.red,
            ),
            const Divider(height: 32),
            const Text(
              'Lesson Learned',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(outcome!.lessonLearned),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeDetailRow(String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
