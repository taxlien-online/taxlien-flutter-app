import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/integrated_services.dart';
import '../core/constants/app_constants.dart';

/// Виджет для отображения статуса всех интеграций
class IntegrationStatusWidget extends StatefulWidget {
  final bool showDetails;
  final bool isCompact;

  const IntegrationStatusWidget({
    super.key,
    this.showDetails = false,
    this.isCompact = false,
  });

  @override
  State<IntegrationStatusWidget> createState() =>
      _IntegrationStatusWidgetState();
}

class _IntegrationStatusWidgetState extends State<IntegrationStatusWidget> {
  IntegratedServices? _integratedServices;
  Map<String, bool> _servicesStatus = {};
  Map<String, dynamic> _integrationStats = {};

  @override
  void initState() {
    super.initState();
    _integratedServices = AppConstants.integratedServices;
    _updateStatus();
  }

  void _updateStatus() {
    if (_integratedServices != null) {
      setState(() {
        _servicesStatus = _integratedServices!.getServicesStatus();
        _integrationStats = _integratedServices!.getIntegrationStats();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_integratedServices == null) {
      return const SizedBox.shrink();
    }

    if (widget.isCompact) {
      return _buildCompactStatus();
    }

    return _buildFullStatus();
  }

  Widget _buildCompactStatus() {
    final allServicesOnline = _servicesStatus.values.every((status) => status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: allServicesOnline
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: allServicesOnline ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            allServicesOnline ? Icons.cloud_done : Icons.cloud_off,
            size: 16,
            color: allServicesOnline ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            allServicesOnline ? 'All Online' : 'Some Offline',
            style: TextStyle(
              fontSize: 12,
              color: allServicesOnline ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.integration_instructions),
                const SizedBox(width: 8),
                const Text(
                  'Integration Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _updateStatus,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceStatus('Magento', _servicesStatus['magento'] ?? false),
            _buildServiceStatus('NFT', _servicesStatus['nft'] ?? false),
            _buildServiceStatus('Wallet', _servicesStatus['wallet'] ?? false),
            _buildServiceStatus('Yuku', _servicesStatus['yuku'] ?? false),
            if (widget.showDetails) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildDetailedStats(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStatus(String serviceName, bool isOnline) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.check_circle : Icons.error,
            color: isOnline ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            serviceName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: isOnline ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Statistics',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (_integrationStats['magento'] != null)
          _buildMagentoStats(_integrationStats['magento']),
        if (_integrationStats['nft'] != null)
          _buildNFTStats(_integrationStats['nft']),
        if (_integrationStats['wallet'] != null)
          _buildWalletStats(_integrationStats['wallet']),
        if (_integrationStats['yuku'] != null)
          _buildYukuStats(_integrationStats['yuku']),
      ],
    );
  }

  Widget _buildMagentoStats(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Magento',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Online: ${stats['isOnline']}'),
            Text('Authenticated: ${stats['isAuthenticated']}'),
            Text('Cloud Functions: ${stats['cloudFunctions']?.length ?? 0}'),
          ],
        ),
      ),
    );
  }

  Widget _buildNFTStats(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NFT', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('My NFTs: ${stats['myNFTs']}'),
            Text('Marketplace NFTs: ${stats['marketplaceNFTs']}'),
            Text('Initialized: ${stats['isInitialized']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletStats(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Connected: ${stats['isConnected']}'),
            if (stats['principalId'] != null)
              Text('Principal: ${stats['principalId']}'),
            if (stats['accountId'] != null)
              Text('Account: ${stats['accountId']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildYukuStats(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Yuku Marketplace',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Active Listings: ${stats['activeListings']}'),
            Text('My Listings: ${stats['myListings']}'),
            Text('My Offers: ${stats['myOffers']}'),
            Text('Received Offers: ${stats['receivedOffers']}'),
          ],
        ),
      ),
    );
  }
}

/// Компактный виджет статуса для AppBar
class CompactIntegrationStatusWidget extends StatelessWidget {
  const CompactIntegrationStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const IntegrationStatusWidget(
      isCompact: true,
    );
  }
}

/// Диалог с детальной информацией об интеграциях
class IntegrationStatusDialog extends StatelessWidget {
  const IntegrationStatusDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Integration Status'),
      content: const IntegrationStatusWidget(
        showDetails: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (AppConstants.integratedServices != null)
          TextButton(
            onPressed: () async {
              await AppConstants.integratedServices!.reconnectAll();
              Navigator.of(context).pop();
            },
            child: const Text('Reconnect All'),
          ),
      ],
    );
  }
}
