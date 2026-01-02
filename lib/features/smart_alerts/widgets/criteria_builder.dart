import 'package:flutter/material.dart';
import '../models/alert_criteria.dart';

/// Criteria Builder Widget
///
/// Bottom sheet for creating individual alert criteria
class CriteriaBuilder extends StatefulWidget {
  final Function(AlertCriteria) onAdd;

  const CriteriaBuilder({
    super.key,
    required this.onAdd,
  });

  @override
  State<CriteriaBuilder> createState() => _CriteriaBuilderState();
}

class _CriteriaBuilderState extends State<CriteriaBuilder> {
  String _selectedType = 'location';
  String _selectedOperator = 'equals';
  final _valueController = TextEditingController();
  final _secondaryValueController = TextEditingController();

  // Available operators for each type
  final Map<String, List<Map<String, String>>> _operators = {
    'location': [
      {'value': 'equals', 'label': 'Is'},
      {'value': 'contains', 'label': 'Contains'},
    ],
    'roi': [
      {'value': 'greater_than', 'label': 'Greater than'},
      {'value': 'less_than', 'label': 'Less than'},
      {'value': 'between', 'label': 'Between'},
    ],
    'price': [
      {'value': 'greater_than', 'label': 'Greater than'},
      {'value': 'less_than', 'label': 'Less than'},
      {'value': 'between', 'label': 'Between'},
    ],
    'property_type': [
      {'value': 'equals', 'label': 'Is'},
    ],
    'interest_rate': [
      {'value': 'greater_than', 'label': 'Greater than'},
      {'value': 'less_than', 'label': 'Less than'},
      {'value': 'between', 'label': 'Between'},
    ],
  };

  @override
  void dispose() {
    _valueController.dispose();
    _secondaryValueController.dispose();
    super.dispose();
  }

  void _addCriteria() {
    // Validate input
    if (_valueController.text.trim().isEmpty) {
      _showError('Please enter a value');
      return;
    }

    if (_selectedOperator == 'between' &&
        _secondaryValueController.text.trim().isEmpty) {
      _showError('Please enter a second value for range');
      return;
    }

    // Parse value based on type
    dynamic value;
    dynamic secondaryValue;

    try {
      if (_selectedType == 'roi' ||
          _selectedType == 'price' ||
          _selectedType == 'interest_rate') {
        value = double.parse(_valueController.text.trim());
        if (_selectedOperator == 'between') {
          secondaryValue = double.parse(_secondaryValueController.text.trim());
        }
      } else {
        value = _valueController.text.trim();
        if (_selectedOperator == 'between') {
          secondaryValue = _secondaryValueController.text.trim();
        }
      }
    } catch (e) {
      _showError('Invalid value format');
      return;
    }

    final criteria = AlertCriteria(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      operator: _selectedOperator,
      value: value,
      secondaryValue: secondaryValue,
    );

    widget.onAdd(criteria);
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Criteria',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Criteria type
            const Text(
              'Criteria Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'location',
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 20),
                      SizedBox(width: 8),
                      Text('Location'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'roi',
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, size: 20),
                      SizedBox(width: 8),
                      Text('ROI'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'price',
                  child: Row(
                    children: [
                      Icon(Icons.attach_money, size: 20),
                      SizedBox(width: 8),
                      Text('Price'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'property_type',
                  child: Row(
                    children: [
                      Icon(Icons.home, size: 20),
                      SizedBox(width: 8),
                      Text('Property Type'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'interest_rate',
                  child: Row(
                    children: [
                      Icon(Icons.percent, size: 20),
                      SizedBox(width: 8),
                      Text('Interest Rate'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                  _selectedOperator = _operators[_selectedType]!.first['value']!;
                  _valueController.clear();
                  _secondaryValueController.clear();
                });
              },
            ),

            const SizedBox(height: 16),

            // Operator
            const Text(
              'Condition',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedOperator,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _operators[_selectedType]!.map((op) {
                return DropdownMenuItem(
                  value: op['value'],
                  child: Text(op['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOperator = value!;
                  _secondaryValueController.clear();
                });
              },
            ),

            const SizedBox(height: 16),

            // Value input
            const Text(
              'Value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildValueInput(),

            // Secondary value for "between" operator
            if (_selectedOperator == 'between') ...[
              const SizedBox(height: 12),
              const Text(
                'To',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildSecondaryValueInput(),
            ],

            const SizedBox(height: 24),

            // Add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addCriteria,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Add Criteria',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueInput() {
    if (_selectedType == 'property_type') {
      return DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Select property type',
        ),
        items: const [
          DropdownMenuItem(value: 'Single Family', child: Text('Single Family')),
          DropdownMenuItem(value: 'Multi Family', child: Text('Multi Family')),
          DropdownMenuItem(value: 'Condo', child: Text('Condo')),
          DropdownMenuItem(value: 'Townhouse', child: Text('Townhouse')),
          DropdownMenuItem(value: 'Vacant Land', child: Text('Vacant Land')),
          DropdownMenuItem(value: 'Commercial', child: Text('Commercial')),
        ],
        onChanged: (value) {
          _valueController.text = value ?? '';
        },
      );
    }

    String hintText;
    TextInputType keyboardType;

    switch (_selectedType) {
      case 'location':
        hintText = 'e.g., Los Angeles, CA or Florida';
        keyboardType = TextInputType.text;
        break;
      case 'roi':
        hintText = 'e.g., 50 (for 50%)';
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
        break;
      case 'price':
        hintText = 'e.g., 10000';
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
        break;
      case 'interest_rate':
        hintText = 'e.g., 12 (for 12%)';
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
        break;
      default:
        hintText = 'Enter value';
        keyboardType = TextInputType.text;
    }

    return TextField(
      controller: _valueController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildSecondaryValueInput() {
    String hintText;
    TextInputType keyboardType;

    switch (_selectedType) {
      case 'roi':
        hintText = 'e.g., 100 (for 100%)';
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
        break;
      case 'price':
        hintText = 'e.g., 50000';
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
        break;
      case 'interest_rate':
        hintText = 'e.g., 18 (for 18%)';
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
        break;
      default:
        hintText = 'Enter value';
        keyboardType = TextInputType.text;
    }

    return TextField(
      controller: _secondaryValueController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
      keyboardType: keyboardType,
    );
  }
}
