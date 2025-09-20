import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/flutter_magento_cloud_service.dart';

/// Виджет для отображения статуса облачных функций
class CloudFunctionsStatusWidget extends StatelessWidget {
  final bool showDetails;
  final bool showUnsupported;

  const CloudFunctionsStatusWidget({
    Key? key,
    this.showDetails = false,
    this.showUnsupported = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FlutterMagentoCloudService>(
      builder: (context, cloudService, child) {
        final stats = cloudService.getCloudFunctionsStats();

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, stats),
                const SizedBox(height: 16),
                _buildStatusIndicator(context, stats),
                if (showDetails) ...[
                  const SizedBox(height: 16),
                  _buildDetailedStatus(context, cloudService),
                ],
                if (showUnsupported) ...[
                  const SizedBox(height: 16),
                  _buildUnsupportedFunctions(context, cloudService),
                ],
                if (cloudService.error != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorSection(context, cloudService),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> stats) {
    return Row(
      children: [
        Icon(
          Icons.cloud,
          color: stats['is_online'] ? Colors.green : Colors.orange,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Cloud Functions Status',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context
                .read<FlutterMagentoCloudService>()
                .refreshCloudFunctionsStatus();
          },
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(
      BuildContext context, Map<String, dynamic> stats) {
    final availabilityPercentage = stats['availability_percentage'] as int;
    final isOnline = stats['is_online'] as bool;
    final isAuthenticated = stats['is_authenticated'] as bool;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (!isOnline) {
      statusColor = Colors.red;
      statusText = 'Offline';
      statusIcon = Icons.cloud_off;
    } else if (availabilityPercentage >= 80) {
      statusColor = Colors.green;
      statusText = 'Fully Operational';
      statusIcon = Icons.check_circle;
    } else if (availabilityPercentage >= 50) {
      statusColor = Colors.orange;
      statusText = 'Partially Operational';
      statusIcon = Icons.warning;
    } else {
      statusColor = Colors.red;
      statusText = 'Limited Functionality';
      statusIcon = Icons.error;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$availabilityPercentage%',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: availabilityPercentage / 100,
            backgroundColor: statusColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                'Available',
                '${stats['currently_available']}/${stats['total_supported']}',
                Colors.green,
              ),
              _buildStatItem(
                context,
                'Auth',
                isAuthenticated ? 'Yes' : 'No',
                isAuthenticated ? Colors.green : Colors.orange,
              ),
              _buildStatItem(
                context,
                'Unsupported',
                '${stats['unsupported_count']}',
                Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildDetailedStatus(
      BuildContext context, FlutterMagentoCloudService cloudService) {
    return ExpansionTile(
      title: const Text('Detailed Status'),
      children: [
        ...cloudService.supportedCloudFunctions.map((function) {
          final isAvailable = cloudService.isCloudFunctionAvailable(function);
          return ListTile(
            leading: Icon(
              isAvailable ? Icons.check_circle : Icons.cancel,
              color: isAvailable ? Colors.green : Colors.red,
              size: 20,
            ),
            title: Text(_formatFunctionName(function)),
            subtitle: Text(
              isAvailable ? 'Available' : 'Unavailable',
              style: TextStyle(
                color: isAvailable ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildUnsupportedFunctions(
      BuildContext context, FlutterMagentoCloudService cloudService) {
    return ExpansionTile(
      title: const Text('Unsupported Functions'),
      subtitle: const Text(
        'These functions require custom implementation',
        style: TextStyle(fontSize: 12),
      ),
      children: [
        ...cloudService.unsupportedFunctions.map((function) {
          return ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: 20,
            ),
            title: Text(_formatFunctionName(function)),
            subtitle: const Text(
              'Requires custom implementation',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildErrorSection(
      BuildContext context, FlutterMagentoCloudService cloudService) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  cloudService.error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              cloudService.clearError();
            },
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  String _formatFunctionName(String functionName) {
    return functionName
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

/// Компактный виджет статуса для использования в AppBar или других местах
class CompactCloudStatusWidget extends StatelessWidget {
  const CompactCloudStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FlutterMagentoCloudService>(
      builder: (context, cloudService, child) {
        final stats = cloudService.getCloudFunctionsStats();
        final isOnline = stats['is_online'] as bool;
        final availabilityPercentage = stats['availability_percentage'] as int;

        Color statusColor;
        IconData statusIcon;

        if (!isOnline) {
          statusColor = Colors.red;
          statusIcon = Icons.cloud_off;
        } else if (availabilityPercentage >= 80) {
          statusColor = Colors.green;
          statusIcon = Icons.cloud_done;
        } else if (availabilityPercentage >= 50) {
          statusColor = Colors.orange;
          statusIcon = Icons.cloud_queue;
        } else {
          statusColor = Colors.red;
          statusIcon = Icons.cloud_off;
        }

        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const CloudFunctionsStatusWidget(
                    showDetails: true,
                    showUnsupported: true,
                  ),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: statusColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$availabilityPercentage%',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
