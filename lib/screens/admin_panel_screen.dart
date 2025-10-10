import 'package:flutter/material.dart';
import '../core/admin_panel/admin_config.dart';
import '../core/admin_panel/data_provider.dart';
import '../services/admin_panel_data_provider.dart';
import '../services/admin_panel_config.dart';
import '../services/server_connection_service.dart';
import '../widgets/admin/admin_resource_list.dart';
import '../widgets/admin/admin_dashboard.dart';

/// Modern Admin Panel Screen with comprehensive management capabilities
///
/// Features:
/// - Dashboard with statistics
/// - Resource management (CRUD operations)
/// - Search and filtering
/// - Sorting and pagination
/// - Export functionality
/// - Responsive design
class AdminPanelScreen extends StatefulWidget {
  final ServerConnectionService serverConnectionService;

  const AdminPanelScreen({
    super.key,
    required this.serverConnectionService,
  });

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late AdminDataProvider _dataProvider;
  late AdminConfig _config;
  late List<AdminResource> _resources;
  bool _isInitialized = false;
  String? _errorMessage;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAdminPanel();
  }

  Future<void> _initializeAdminPanel() async {
    try {
      // Create data provider using existing API service
      _dataProvider = TaxLienDataProvider(
        apiService: widget.serverConnectionService.apiService,
        configService: widget.serverConnectionService.configService,
      );

      // Create admin configuration
      _config = TaxLienAdminConfig.createConfig();

      // Create resources
      _resources = TaxLienAdminConfig.createResources();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize admin panel: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _buildErrorScreen();
    }

    if (!_isInitialized) {
      return _buildLoadingScreen();
    }

    // Check server connection
    if (!widget.serverConnectionService.isConnected) {
      return _buildNoConnectionScreen();
    }

    // Build admin panel with navigation
    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          _buildSidebar(),
          // Main content area
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: [
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.admin_panel_settings, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            _config.appName,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Divider(),
        ],
      ),
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        ..._resources.map((resource) => NavigationRailDestination(
              icon: Icon(resource.icon),
              label: Text(resource.label),
            )),
      ],
    );
  }

  Widget _buildContent() {
    if (_selectedIndex == 0) {
      return AdminDashboard(
        dataProvider: _dataProvider,
        resources: _resources,
      );
    }

    final resource = _resources[_selectedIndex - 1];
    return AdminResourceList(
      resource: resource,
      dataProvider: _dataProvider,
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                _initializeAdminPanel();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing Admin Panel...'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoConnectionScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Server Not Connected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Please connect to a server to use the admin panel.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.settings),
              label: const Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
