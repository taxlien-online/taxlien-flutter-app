import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that displays the current cloud/offline status
class CloudStatusWidget extends ConsumerWidget {
  final bool showLabel;
  final bool showIcon;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;

  const CloudStatusWidget({
    super.key,
    this.showLabel = true,
    this.showIcon = true,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You'll need to create a provider for HybridMagentoService
    // final hybridService = ref.watch(hybridMagentoServiceProvider);
    // For now, we'll create a mock status
    final status = _getMockStatus();

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? _getStatusColor(status['isOnline'], context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              _getStatusIcon(status['isOnline'], status['preferGraphQL']),
              size: 16,
              color: textColor ?? _getTextColor(status['isOnline'], context),
            ),
            if (showLabel) const SizedBox(width: 4),
          ],
          if (showLabel)
            Text(
              status['connectionStatus'],
              style: TextStyle(
                fontSize: fontSize ?? 12,
                fontWeight: FontWeight.w500,
                color: textColor ?? _getTextColor(status['isOnline'], context),
              ),
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getMockStatus() {
    // This would normally come from the hybrid service
    return {
      'isOnline': true,
      'connectionStatus': 'Cloud (GraphQL)',
      'preferGraphQL': true,
      'enableOfflineMode': true,
      'isAuthenticated': false,
    };
  }

  Color _getStatusColor(bool isOnline, BuildContext context) {
    if (isOnline) {
      return Colors.green.withOpacity(0.1);
    } else {
      return Colors.orange.withOpacity(0.1);
    }
  }

  Color _getTextColor(bool isOnline, BuildContext context) {
    if (isOnline) {
      return Colors.green.shade700;
    } else {
      return Colors.orange.shade700;
    }
  }

  IconData _getStatusIcon(bool isOnline, bool preferGraphQL) {
    if (isOnline) {
      return preferGraphQL ? Icons.cloud_sync : Icons.cloud;
    } else {
      return Icons.cloud_off;
    }
  }
}

/// Detailed cloud status card for settings or debug purposes
class CloudStatusCard extends ConsumerWidget {
  const CloudStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You'll need to create a provider for HybridMagentoService
    // final hybridService = ref.watch(hybridMagentoServiceProvider);
    final status = _getMockDetailedStatus();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  status['isOnline'] ? Icons.cloud : Icons.cloud_off,
                  color: status['isOnline'] ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Connection Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              'Status',
              status['connectionStatus'],
              status['isOnline'] ? Colors.green : Colors.orange,
            ),
            _buildStatusRow(
              'API Method',
              status['preferGraphQL'] ? 'GraphQL' : 'REST',
              Colors.blue,
            ),
            _buildStatusRow(
              'Offline Mode',
              status['enableOfflineMode'] ? 'Enabled' : 'Disabled',
              status['enableOfflineMode'] ? Colors.green : Colors.grey,
            ),
            _buildStatusRow(
              'Authentication',
              status['isAuthenticated'] ? 'Signed In' : 'Guest',
              status['isAuthenticated'] ? Colors.green : Colors.grey,
            ),
            if (status['restServiceLoading'] == true) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getMockDetailedStatus() {
    return {
      'isOnline': true,
      'connectionStatus': 'Cloud (GraphQL)',
      'preferGraphQL': true,
      'enableOfflineMode': true,
      'isAuthenticated': false,
      'restServiceLoading': false,
      'graphqlServiceInitialized': true,
    };
  }
}

/// Simple connection indicator dot
class ConnectionIndicator extends ConsumerWidget {
  final double size;

  const ConnectionIndicator({
    super.key,
    this.size = 8.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You'll need to create a provider for HybridMagentoService
    // For now, we'll simulate connectivity status
    final isOnline = DateTime.now().second % 2 ==
        0; // Alternates between online/offline for demo

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.orange,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Cloud settings tile for preferences
class CloudSettingsTile extends ConsumerWidget {
  const CloudSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      leading: const Icon(Icons.cloud_sync),
      title: const Text('Cloud Settings'),
      subtitle: const Text('Configure cloud synchronization'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Prefer GraphQL API'),
                subtitle: const Text('Use GraphQL when available (faster)'),
                value: true, // This would come from the service
                onChanged: (value) {
                  // Update preference
                },
              ),
              SwitchListTile(
                title: const Text('Enable Offline Mode'),
                subtitle: const Text('Cache data for offline use'),
                value: true, // This would come from the service
                onChanged: (value) {
                  // Update preference
                },
              ),
              SwitchListTile(
                title: const Text('Auto Sync'),
                subtitle: const Text('Automatically sync when online'),
                value: true, // This would come from the service
                onChanged: (value) {
                  // Update preference
                },
              ),
              const SizedBox(height: 16),
              const CloudStatusCard(),
            ],
          ),
        ),
      ],
    );
  }
}
