import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';

/// Animated modal for revealing simulation outcomes
///
/// Shows outcome with animations and educational content
class OutcomeRevealModal extends StatefulWidget {
  final SimulatedPosition position;
  final SimulationOutcome outcome;

  const OutcomeRevealModal({
    super.key,
    required this.position,
    required this.outcome,
  });

  static Future<void> show(
    BuildContext context, {
    required SimulatedPosition position,
    required SimulationOutcome outcome,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OutcomeRevealModal(
        position: position,
        outcome: outcome,
      ),
    );
  }

  @override
  State<OutcomeRevealModal> createState() => _OutcomeRevealModalState();
}

class _OutcomeRevealModalState extends State<OutcomeRevealModal>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showDetails = false;

  @override
  void initState() {
    super.initState();

    // Scale animation for icon
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Rotation animation for icon
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Slide animation for details
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _scaleController.forward();
    _rotationController.forward();

    // Show details after icon animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showDetails = true;
        });
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProfit = widget.outcome.profitLoss >= 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with animated icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getOutcomeColor().withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  // Animated icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: _getOutcomeColor().withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getOutcomeIcon(),
                          size: 60,
                          color: _getOutcomeColor(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Outcome title
                  Text(
                    _getOutcomeTitle(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getOutcomeColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Details section with slide animation
            if (_showDetails)
              SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property info
                      Text(
                        widget.position.propertyAddress,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.position.county}, ${widget.position.state}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Divider(height: 24),

                      // Financial summary
                      _buildFinancialRow(
                        'Purchase Price',
                        '\$${widget.position.purchasePrice.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _buildFinancialRow(
                        'Final Value',
                        '\$${widget.outcome.finalValue.toStringAsFixed(2)}',
                      ),
                      const Divider(height: 24),

                      // Profit/Loss highlight
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (isProfit ? Colors.green : Colors.red)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Profit/Loss',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${widget.outcome.profitLoss.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isProfit ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'ROI',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.outcome.roi >= 0 ? '+' : ''}${widget.outcome.roi.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isProfit ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Educational lesson
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 20,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Lesson Learned',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.outcome.lessonLearned,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // TODO: Navigate to portfolio or browse more
                              },
                              child: const Text('Try Again'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getOutcomeColor() {
    switch (widget.outcome.type) {
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

  IconData _getOutcomeIcon() {
    switch (widget.outcome.type) {
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

  String _getOutcomeTitle() {
    switch (widget.outcome.type) {
      case OutcomeType.redeemed:
        return 'Property Redeemed!';
      case OutcomeType.foreclosed:
        return 'Foreclosed - You Own It!';
      case OutcomeType.partialPayment:
        return 'Partial Payment';
      case OutcomeType.loss:
        return 'Investment Loss';
    }
  }
}
