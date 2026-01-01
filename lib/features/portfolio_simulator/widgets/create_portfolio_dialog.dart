import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/simulator_constants.dart';

/// Dialog for creating a new simulated portfolio
///
/// Allows user to input portfolio name and starting capital.
/// Validates inputs and returns the data to caller.
class CreatePortfolioDialog extends StatefulWidget {
  final bool isPremium;

  const CreatePortfolioDialog({
    super.key,
    required this.isPremium,
  });

  @override
  State<CreatePortfolioDialog> createState() => _CreatePortfolioDialogState();
}

class _CreatePortfolioDialogState extends State<CreatePortfolioDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _capitalController = TextEditingController(
    text: SimulatorConstants.defaultStartingCapital.toStringAsFixed(0),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _capitalController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final capital = double.tryParse(_capitalController.text) ??
          SimulatorConstants.defaultStartingCapital;

      Navigator.of(context).pop({
        'name': name,
        'capital': capital,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Create Portfolio',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Portfolio Name Field
                Text(
                  'Portfolio Name',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Practice Portfolio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.folder_outlined),
                  ),
                  maxLength: SimulatorConstants.maxPortfolioNameLength,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Portfolio name is required';
                    }
                    if (value.trim().length <
                        SimulatorConstants.minPortfolioNameLength) {
                      return 'Name must be at least ${SimulatorConstants.minPortfolioNameLength} character';
                    }
                    if (!RegExp(SimulatorConstants.portfolioNameRegex)
                        .hasMatch(value.trim())) {
                      return SimulatorConstants.errorInvalidName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Starting Capital Field
                Text(
                  'Starting Capital',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _capitalController,
                  decoration: InputDecoration(
                    hintText: '100000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                    suffixText: 'USD',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Starting capital is required';
                    }
                    final capital = double.tryParse(value);
                    if (capital == null) {
                      return 'Please enter a valid number';
                    }
                    if (capital < SimulatorConstants.minimumPurchaseAmount) {
                      return 'Minimum capital: \$${SimulatorConstants.minimumPurchaseAmount.toStringAsFixed(0)}';
                    }
                    if (capital > SimulatorConstants.maximumCapital) {
                      return 'Maximum capital: \$${SimulatorConstants.maximumCapital.toStringAsFixed(0)}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Quick Select Buttons
                Wrap(
                  spacing: 8,
                  children: [
                    _QuickSelectChip(
                      label: '\$50K',
                      value: 50000,
                      onTap: (value) => _capitalController.text = value.toString(),
                    ),
                    _QuickSelectChip(
                      label: '\$100K',
                      value: 100000,
                      onTap: (value) => _capitalController.text = value.toString(),
                    ),
                    _QuickSelectChip(
                      label: '\$250K',
                      value: 250000,
                      onTap: (value) => _capitalController.text = value.toString(),
                    ),
                    _QuickSelectChip(
                      label: '\$500K',
                      value: 500000,
                      onTap: (value) => _capitalController.text = value.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.isPremium
                              ? 'Practice with virtual money. No real funds at risk!'
                              : 'Free users: 1 portfolio, 5 positions max. Upgrade for unlimited.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Create Portfolio'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Quick select chip for common capital amounts
class _QuickSelectChip extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onTap;

  const _QuickSelectChip({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () => onTap(value),
      avatar: const Icon(Icons.touch_app, size: 16),
    );
  }
}
