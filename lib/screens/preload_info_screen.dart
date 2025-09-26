import 'package:flutter/material.dart';
import '../services/preload_service.dart';

/// Screen to display preload data information and status
/// Shows historical data from tax24.sql and offline capabilities
class PreloadInfoScreen extends StatefulWidget {
  const PreloadInfoScreen({Key? key}) : super(key: key);

  @override
  State<PreloadInfoScreen> createState() => _PreloadInfoScreenState();
}

class _PreloadInfoScreenState extends State<PreloadInfoScreen> {
  Map<String, dynamic>? _preloadStatus;
  Map<String, dynamic>? _preloadSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreloadInfo();
  }

  Future<void> _loadPreloadInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await PreloadService.getPreloadStatus();
      final summary = await PreloadService.getPreloadSummary();

      setState(() {
        _preloadStatus = status;
        _preloadSummary = summary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading preload info: $e')),
        );
      }
    }
  }

  Future<void> _refreshPreloadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await PreloadService.refreshPreloadData();
      if (success) {
        await _loadPreloadInfo();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Preload data refreshed successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to refresh preload data')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error refreshing preload data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preload Data Info'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPreloadData,
            tooltip: 'Refresh Preload Data',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_preloadStatus == null) {
      return const Center(
        child: Text('Failed to load preload information'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildSummaryCard(),
          const SizedBox(height: 16),
          _buildDataSourceCard(),
          const SizedBox(height: 16),
          _buildFeaturesCard(),
          const SizedBox(height: 16),
          _buildHistoricalDataCard(),
          const SizedBox(height: 16),
          _buildActionsCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final isAvailable = _preloadStatus?['is_available'] ?? false;
    final needsUpdate = _preloadStatus?['needs_update'] ?? true;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAvailable ? Icons.check_circle : Icons.error,
                  color: isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Preload Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isAvailable ? 'Data Available' : 'Data Not Available',
              style: TextStyle(
                color: isAvailable ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (needsUpdate) ...[
              const SizedBox(height: 4),
              const Text(
                'Update Required',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    if (_preloadSummary == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
                'Total Products', '${_preloadSummary?['total_products'] ?? 0}'),
            _buildInfoRow('Total Categories',
                '${_preloadSummary?['total_categories'] ?? 0}'),
            _buildInfoRow('Historical Counties',
                '${_preloadSummary?['historical_counties'] ?? 0}'),
            _buildInfoRow('Data Size',
                _preloadSummary?['data_size_estimate'] ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSourceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Source',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Historical data from tax24.sql:'),
            const SizedBox(height: 4),
            const Text('• Polk County (2024) - 1,250 liens'),
            const Text('• Dixie County (2024) - 850 liens'),
            const Text('• Putnam County (2024) - 1,100 liens'),
            const SizedBox(height: 8),
            const Text('Combined with demo data for offline functionality'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final features =
        _preloadSummary?['features_available'] as List<dynamic>? ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Offline Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature.toString())),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricalDataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historical Data (2024)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Total Counties', '3'),
            _buildInfoRow('Total Liens', '3,200'),
            _buildInfoRow('Total Investment Opportunity', '\$4,685,000'),
            _buildInfoRow('Average Interest Rate', '18.0%'),
            _buildInfoRow('Redemption Period', '1 year'),
            _buildInfoRow('Risk Assessment', 'Medium'),
            _buildInfoRow('Liquidity', 'High'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _refreshPreloadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Preload Data'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _loadPreloadInfo,
                icon: const Icon(Icons.info),
                label: const Text('Reload Information'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
