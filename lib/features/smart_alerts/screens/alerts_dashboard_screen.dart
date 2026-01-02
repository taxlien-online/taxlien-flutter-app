import 'package:flutter/material.dart';
import '../models/property_alert.dart';
import '../models/alert_match.dart';
import '../screens/create_alert_screen.dart';
import '../widgets/alert_card.dart';
import '../widgets/match_card.dart';
import '../constants/alert_constants.dart';

/// Alerts Dashboard Screen
///
/// Main screen showing user's alerts and recent matches
class AlertsDashboardScreen extends StatefulWidget {
  final String userId;
  final bool isPremium;

  const AlertsDashboardScreen({
    super.key,
    required this.userId,
    this.isPremium = false,
  });

  @override
  State<AlertsDashboardScreen> createState() => _AlertsDashboardScreenState();
}

class _AlertsDashboardScreenState extends State<AlertsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PropertyAlert> _alerts = [];
  List<AlertMatch> _matches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load from API/database
      // For now, using mock data
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _alerts = []; // Will be populated from backend
        _matches = [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createAlert() {
    // Check alert limit
    final maxAlerts = widget.isPremium
        ? AlertConstants.premiumAlertLimit
        : AlertConstants.freeAlertLimit;

    if (_alerts.length >= maxAlerts) {
      _showLimitDialog();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAlertScreen(
          userId: widget.userId,
          isPremium: widget.isPremium,
          onSave: (alert) {
            setState(() {
              _alerts.add(alert);
            });
            // TODO: Save to backend
            _showSuccessSnackbar(AlertConstants.successAlertCreated);
          },
        ),
      ),
    );
  }

  void _editAlert(PropertyAlert alert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAlertScreen(
          userId: widget.userId,
          isPremium: widget.isPremium,
          existingAlert: alert,
          onSave: (updatedAlert) {
            setState(() {
              final index = _alerts.indexWhere((a) => a.id == updatedAlert.id);
              if (index != -1) {
                _alerts[index] = updatedAlert;
              }
            });
            // TODO: Update in backend
            _showSuccessSnackbar(AlertConstants.successAlertUpdated);
          },
        ),
      ),
    );
  }

  void _deleteAlert(PropertyAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: Text('Are you sure you want to delete "${alert.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _alerts.removeWhere((a) => a.id == alert.id);
              });
              // TODO: Delete from backend
              Navigator.pop(context);
              _showSuccessSnackbar(AlertConstants.successAlertDeleted);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleAlertStatus(PropertyAlert alert) {
    final newStatus = alert.status == 'active' ? 'paused' : 'active';
    final updatedAlert = alert.copyWith(status: newStatus);

    setState(() {
      final index = _alerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        _alerts[index] = updatedAlert;
      }
    });

    // TODO: Update in backend
    _showSuccessSnackbar(
      newStatus == 'active'
          ? AlertConstants.successAlertResumed
          : AlertConstants.successAlertPaused,
    );
  }

  void _showLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert Limit Reached'),
        content: Text(
          widget.isPremium
              ? AlertConstants.errorAlertLimitReached
              : '${AlertConstants.errorAlertLimitReached}\n\nFree: ${AlertConstants.freeAlertLimit} alerts\nPremium: ${AlertConstants.premiumAlertLimit} alerts',
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

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Alerts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Alerts'),
            Tab(text: 'Matches'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAlertsTab(),
                _buildMatchesTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createAlert,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAlertsTab() {
    if (_alerts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.notifications_none,
        title: 'No Alerts Yet',
        description:
            'Create your first alert to get notified about matching properties',
        actionLabel: 'Create Alert',
        onAction: _createAlert,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _alerts.length,
        itemBuilder: (context, index) {
          final alert = _alerts[index];
          return AlertCard(
            alert: alert,
            onEdit: () => _editAlert(alert),
            onDelete: () => _deleteAlert(alert),
            onToggleStatus: () => _toggleAlertStatus(alert),
          );
        },
      ),
    );
  }

  Widget _buildMatchesTab() {
    if (_matches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'No Matches Yet',
        description:
            'We\'ll notify you when properties match your alert criteria',
        actionLabel: null,
        onAction: null,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _matches.length,
        itemBuilder: (context, index) {
          final match = _matches[index];
          return MatchCard(
            match: match,
            onTap: () {
              // TODO: Navigate to property detail
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
