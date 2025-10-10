import 'package:flutter/material.dart';
import '../../core/admin_panel/admin_config.dart';
import '../../core/admin_panel/data_provider.dart';

/// Admin Dashboard showing statistics and quick actions
class AdminDashboard extends StatefulWidget {
  final AdminDataProvider dataProvider;
  final List<AdminResource> resources;

  const AdminDashboard({
    super.key,
    required this.dataProvider,
    required this.resources,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, int> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);

    try {
      final stats = <String, int>{};

      // Load count for each resource
      for (final resource in widget.resources) {
        try {
          final result = await widget.dataProvider.getList(
            resource.name,
            pagination: PaginationConfig(page: 1, pageSize: 1),
          );
          stats[resource.name] = result.total;
        } catch (e) {
          stats[resource.name] = 0;
        }
      }

      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to TaxLien Admin',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your tax liens, documents, and content',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 32),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  _buildQuickActions(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: widget.resources.length,
      itemBuilder: (context, index) {
        final resource = widget.resources[index];
        final count = _stats[resource.name] ?? 0;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  resource.icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  resource.label,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.resources
              .where((r) => r.canCreate)
              .map((resource) => ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Show create dialog
                    },
                    icon: Icon(resource.icon),
                    label: Text('New ${resource.label}'),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
