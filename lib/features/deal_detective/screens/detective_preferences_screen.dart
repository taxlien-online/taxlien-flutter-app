import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_preferences.dart';

/// Deal Detective preferences and filters screen
///
/// Configure matching criteria for personalized property feed
class DetectivePreferencesScreen extends StatefulWidget {
  final UserPreferences initialPreferences;
  final Function(UserPreferences) onSave;

  const DetectivePreferencesScreen({
    super.key,
    required this.initialPreferences,
    required this.onSave,
  });

  @override
  State<DetectivePreferencesScreen> createState() =>
      _DetectivePreferencesScreenState();
}

class _DetectivePreferencesScreenState
    extends State<DetectivePreferencesScreen> {
  late double _minPrice;
  late double _maxPrice;
  late double _minROI;
  late List<String> _selectedCounties;
  late List<String> _selectedStates;
  late List<String> _selectedPropertyTypes;

  bool _hasChanges = false;

  // Available options
  final List<String> _availableStates = [
    'AL',
    'AZ',
    'AR',
    'CA',
    'CO',
    'FL',
    'GA',
    'IL',
    'IN',
    'IA',
    'KS',
    'KY',
    'LA',
    'MD',
    'MI',
    'MO',
    'NV',
    'NJ',
    'NY',
    'NC',
    'OH',
    'OK',
    'PA',
    'SC',
    'TN',
    'TX',
    'VA',
    'WV',
  ];

  final List<String> _availablePropertyTypes = [
    'Single Family',
    'Multi Family',
    'Condo',
    'Townhouse',
    'Vacant Land',
    'Commercial',
    'Industrial',
    'Mixed Use',
  ];

  @override
  void initState() {
    super.initState();
    _minPrice = widget.initialPreferences.minPrice;
    _maxPrice = widget.initialPreferences.maxPrice;
    _minROI = widget.initialPreferences.minROI;
    _selectedCounties = List.from(widget.initialPreferences.preferredCounties);
    _selectedStates = List.from(widget.initialPreferences.preferredStates);
    _selectedPropertyTypes =
        List.from(widget.initialPreferences.preferredPropertyTypes);
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _savePreferences() async {
    final preferences = UserPreferences(
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minROI: _minROI,
      preferredCounties: _selectedCounties,
      preferredStates: _selectedStates,
      preferredPropertyTypes: _selectedPropertyTypes,
    );

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'detective_preferences',
      jsonEncode(preferences.toJson()),
    );

    // Callback
    widget.onSave(preferences);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Preferences'),
        content: const Text(
          'Are you sure you want to reset all preferences to default values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _minPrice = 0;
                _maxPrice = 500000;
                _minROI = 30.0;
                _selectedCounties.clear();
                _selectedStates.clear();
                _selectedPropertyTypes.clear();
                _hasChanges = true;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        actions: [
          TextButton(
            onPressed: _resetToDefaults,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            'Customize Your Feed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your preferences to see properties that match your investment criteria',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 32),

          // Price Range
          _buildSection(
            title: 'Price Range',
            icon: Icons.attach_money,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${_minPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_maxPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                RangeSlider(
                  values: RangeValues(_minPrice, _maxPrice),
                  min: 0,
                  max: 1000000,
                  divisions: 100,
                  labels: RangeLabels(
                    '\$${_minPrice.toStringAsFixed(0)}',
                    '\$${_maxPrice.toStringAsFixed(0)}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _minPrice = values.start;
                      _maxPrice = values.end;
                      _markChanged();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Minimum ROI
          _buildSection(
            title: 'Minimum ROI',
            icon: Icons.trending_up,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Target Return:'),
                    Text(
                      '${_minROI.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _minROI,
                  min: 0,
                  max: 200,
                  divisions: 40,
                  label: '${_minROI.toStringAsFixed(1)}%',
                  onChanged: (value) {
                    setState(() {
                      _minROI = value;
                      _markChanged();
                    });
                  },
                ),
                Text(
                  'Only show properties with potential ROI above this threshold',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // States
          _buildSection(
            title: 'Preferred States',
            icon: Icons.map,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedStates.isEmpty
                      ? 'All states'
                      : '${_selectedStates.length} selected',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableStates.map((state) {
                    final isSelected = _selectedStates.contains(state);
                    return FilterChip(
                      label: Text(state),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedStates.add(state);
                          } else {
                            _selectedStates.remove(state);
                          }
                          _markChanged();
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Property Types
          _buildSection(
            title: 'Property Types',
            icon: Icons.home_work,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedPropertyTypes.isEmpty
                      ? 'All property types'
                      : '${_selectedPropertyTypes.length} selected',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availablePropertyTypes.map((type) {
                    final isSelected = _selectedPropertyTypes.contains(type);
                    return FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPropertyTypes.add(type);
                          } else {
                            _selectedPropertyTypes.remove(type);
                          }
                          _markChanged();
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // County input (custom)
          _buildSection(
            title: 'Preferred Counties',
            icon: Icons.location_city,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add specific counties you\'re interested in',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                if (_selectedCounties.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedCounties.map((county) {
                      return Chip(
                        label: Text(county),
                        onDeleted: () {
                          setState(() {
                            _selectedCounties.remove(county);
                            _markChanged();
                          });
                        },
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _showAddCountyDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add County'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _hasChanges ? _savePreferences : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Save Preferences',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your preferences help us show you the most relevant properties first',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _showAddCountyDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add County'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'County Name',
            hintText: 'e.g., Los Angeles',
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final county = controller.text.trim();
              if (county.isNotEmpty &&
                  !_selectedCounties.contains(county)) {
                setState(() {
                  _selectedCounties.add(county);
                  _markChanged();
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
