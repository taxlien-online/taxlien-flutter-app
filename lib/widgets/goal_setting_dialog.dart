import 'package:flutter/material.dart';
import '../services/portfolio_service.dart';

class GoalSettingDialog extends StatefulWidget {
  final PortfolioGoal? initialGoal;
  final Function(PortfolioGoal) onSave;

  const GoalSettingDialog({
    Key? key,
    this.initialGoal,
    required this.onSave,
  }) : super(key: key);

  @override
  State<GoalSettingDialog> createState() => _GoalSettingDialogState();
}

class _GoalSettingDialogState extends State<GoalSettingDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _targetAmountController;
  late final TextEditingController _currentAmountController;
  late DateTime _targetDate;
  late GoalPriority _priority;
  late GoalStatus _status;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    final goal = widget.initialGoal;
    _titleController = TextEditingController(text: goal?.title ?? '');
    _targetAmountController = TextEditingController(text: goal?.targetAmount.toString() ?? '');
    _currentAmountController = TextEditingController(text: goal?.currentAmount.toString() ?? '');
    _targetDate = goal?.targetDate ?? DateTime.now().add(const Duration(days: 365));
    _priority = goal?.priority ?? GoalPriority.medium;
    _status = goal?.status ?? GoalStatus.active;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialGoal != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Goal' : 'Set New Goal'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Title',
                    hintText: 'e.g., Retirement Fund, Emergency Fund',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a goal title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _targetAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Target Amount (\$)',
                    hintText: '100000',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter target amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _currentAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Current Amount (\$)',
                    hintText: '5000',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter current amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount < 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 16),
                _buildPrioritySelector(),
                const SizedBox(height: 16),
                _buildStatusSelector(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveGoal,
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Target Date',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          '${_targetDate.day}/${_targetDate.month}/${_targetDate.year}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: GoalPriority.values.map((priority) {
            return Expanded(
              child: RadioListTile<GoalPriority>(
                title: Text(_getPriorityLabel(priority)),
                value: priority,
                groupValue: _priority,
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
                dense: true,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: GoalStatus.values.map((status) {
            return Expanded(
              child: RadioListTile<GoalStatus>(
                title: Text(_getStatusLabel(status)),
                value: status,
                groupValue: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                dense: true,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getPriorityLabel(GoalPriority priority) {
    switch (priority) {
      case GoalPriority.low:
        return 'Low';
      case GoalPriority.medium:
        return 'Medium';
      case GoalPriority.high:
        return 'High';
    }
  }

  String _getStatusLabel(GoalStatus status) {
    switch (status) {
      case GoalStatus.active:
        return 'Active';
      case GoalStatus.paused:
        return 'Paused';
      case GoalStatus.completed:
        return 'Completed';
      case GoalStatus.cancelled:
        return 'Cancelled';
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    
    if (date != null) {
      setState(() {
        _targetDate = date;
      });
    }
  }

  void _saveGoal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final targetAmount = double.parse(_targetAmountController.text);
    final currentAmount = double.parse(_currentAmountController.text);

    if (currentAmount > targetAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current amount cannot be greater than target amount'),
        ),
      );
      return;
    }

    final goal = PortfolioGoal(
      id: widget.initialGoal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      targetDate: _targetDate,
      priority: _priority,
      status: _status,
    );

    widget.onSave(goal);
    Navigator.of(context).pop();
  }
}
