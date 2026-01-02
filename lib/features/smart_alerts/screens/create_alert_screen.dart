import 'package:flutter/material.dart';
import '../models/alert_criteria.dart';
import '../models/property_alert.dart';
import '../widgets/criteria_builder.dart';
import '../constants/alert_constants.dart';

/// Create/Edit Alert Screen
///
/// Builder interface for creating property alerts with multiple criteria
class CreateAlertScreen extends StatefulWidget {
  final PropertyAlert? existingAlert;
  final String userId;
  final bool isPremium;
  final Function(PropertyAlert) onSave;

  const CreateAlertScreen({
    super.key,
    this.existingAlert,
    required this.userId,
    required this.onSave,
    this.isPremium = false,
  });

  @override
  State<CreateAlertScreen> createState() => _CreateAlertScreenState();
}

class _CreateAlertScreenState extends State<CreateAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<AlertCriteria> _criteria = [];
  String _frequency = AlertConstants.frequencyImmediate;
  List<String> _notificationChannels = ['push'];
  bool _isPriority = false;
  DateTime? _expiresAt;

  @override
  void initState() {
    super.initState();

    if (widget.existingAlert != null) {
      _nameController.text = widget.existingAlert!.name;
      _descriptionController.text = widget.existingAlert!.description ?? '';
      _criteria = List.from(widget.existingAlert!.criteria);
      _frequency = widget.existingAlert!.frequency;
      _notificationChannels = List.from(widget.existingAlert!.notificationChannels);
      _isPriority = widget.existingAlert!.isPriority;
      _expiresAt = widget.existingAlert!.expiresAt;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addCriteria(AlertCriteria criteria) {
    final maxCriteria = widget.isPremium
        ? AlertConstants.premiumCriteriaLimit
        : AlertConstants.freeCriteriaLimit;

    if (_criteria.length >= maxCriteria) {
      _showLimitReachedDialog();
      return;
    }

    setState(() {
      _criteria.add(criteria);
    });
  }

  void _removeCriteria(String criteriaId) {
    setState(() {
      _criteria.removeWhere((c) => c.id == criteriaId);
    });
  }

  void _saveAlert() {
    if (!_formKey.currentState!.validate()) return;

    if (_criteria.isEmpty) {
      _showErrorDialog(AlertConstants.errorInvalidCriteria);
      return;
    }

    final alert = widget.existingAlert != null
        ? widget.existingAlert!.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            criteria: _criteria,
            frequency: _frequency,
            notificationChannels: _notificationChannels,
            isPriority: _isPriority,
            expiresAt: _expiresAt,
            updatedAt: DateTime.now(),
          )
        : PropertyAlert.create(
            userId: widget.userId,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            criteria: _criteria,
            frequency: _frequency,
            notificationChannels: _notificationChannels,
            isPriority: _isPriority,
            expiresAt: _expiresAt,
          );

    widget.onSave(alert);
    Navigator.pop(context);
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criteria Limit Reached'),
        content: Text(
          widget.isPremium
              ? AlertConstants.errorCriteriaLimitReached
              : '${AlertConstants.errorCriteriaLimitReached}\n\nUpgrade to Premium for up to ${AlertConstants.premiumCriteriaLimit} criteria per alert!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (!widget.isPremium)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to paywall
              },
              child: const Text('Upgrade'),
            ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingAlert != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Alert' : 'Create Alert'),
        actions: [
          TextButton(
            onPressed: _saveAlert,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Alert name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Alert Name',
                hintText: 'e.g., High ROI Florida Properties',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an alert name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description (optional)
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add notes about this alert',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Criteria section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Criteria (${_criteria.length}/${widget.isPremium ? AlertConstants.premiumCriteriaLimit : AlertConstants.freeCriteriaLimit})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () => _showCriteriaBuilder(),
                  color: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (_criteria.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_alert,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No criteria added yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add matching criteria',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._criteria.map((criteria) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(_getCriteriaIcon(criteria.type)),
                    title: Text(criteria.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeCriteria(criteria.id),
                    ),
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Frequency
            _buildSection(
              title: 'Notification Frequency',
              child: DropdownButtonFormField<String>(
                value: _frequency,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'immediate',
                    child: Text('Instant (as soon as match found)'),
                  ),
                  DropdownMenuItem(
                    value: 'hourly',
                    child: Text('Hourly Digest'),
                  ),
                  DropdownMenuItem(
                    value: 'daily',
                    child: Text('Daily Digest'),
                  ),
                  DropdownMenuItem(
                    value: 'weekly',
                    child: Text('Weekly Digest'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _frequency = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Notification channels
            _buildSection(
              title: 'Notification Channels',
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Push Notifications'),
                    value: _notificationChannels.contains('push'),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _notificationChannels.add('push');
                        } else {
                          _notificationChannels.remove('push');
                        }
                      });
                    },
                  ),
                  if (widget.isPremium) ...[
                    CheckboxListTile(
                      title: const Text('Email'),
                      value: _notificationChannels.contains('email'),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _notificationChannels.add('email');
                          } else {
                            _notificationChannels.remove('email');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('SMS'),
                      value: _notificationChannels.contains('sms'),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _notificationChannels.add('sms');
                          } else {
                            _notificationChannels.remove('sms');
                          }
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Priority toggle
            SwitchListTile(
              title: const Text('High Priority'),
              subtitle: const Text('Get notifications even in Do Not Disturb mode'),
              value: _isPriority,
              onChanged: (value) {
                setState(() {
                  _isPriority = value;
                });
              },
            ),

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAlert,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  isEditing ? 'Update Alert' : 'Create Alert',
                  style: const TextStyle(
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

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  IconData _getCriteriaIcon(String type) {
    switch (type) {
      case 'location':
        return Icons.location_on;
      case 'roi':
        return Icons.trending_up;
      case 'price':
        return Icons.attach_money;
      case 'property_type':
        return Icons.home;
      case 'interest_rate':
        return Icons.percent;
      default:
        return Icons.filter_list;
    }
  }

  void _showCriteriaBuilder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CriteriaBuilder(
        onAdd: _addCriteria,
      ),
    );
  }
}
