import 'package:flutter/material.dart';
import '../models/simulated_portfolio.dart';
import '../services/simulator_storage_service.dart';
import '../constants/simulator_constants.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/create_portfolio_dialog.dart';
import '../widgets/empty_portfolio_state.dart';
import '../../../core/routing/app_router.dart';

/// Portfolio Simulator Dashboard Screen
///
/// Main entry point for the Portfolio Simulator feature.
/// Displays list of user's simulated portfolios and allows creating new ones.
class SimulatorDashboardScreen extends StatefulWidget {
  final String? userId;

  const SimulatorDashboardScreen({
    super.key,
    this.userId,
  });

  @override
  State<SimulatorDashboardScreen> createState() =>
      _SimulatorDashboardScreenState();
}

class _SimulatorDashboardScreenState extends State<SimulatorDashboardScreen> {
  final _storageService = SimulatorStorageService.instance;
  List<SimulatedPortfolio> _portfolios = [];
  bool _isLoading = true;
  bool _isPremium = false; // TODO: Get from subscription service

  @override
  void initState() {
    super.initState();
    _loadPortfolios();
  }

  /// Load portfolios from storage
  Future<void> _loadPortfolios() async {
    setState(() => _isLoading = true);
    try {
      final userId = widget.userId ?? 'demo_user'; // TODO: Get from auth service
      final portfolios = await _storageService.getPortfolios(userId);
      setState(() {
        _portfolios = portfolios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load portfolios: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show create portfolio dialog
  Future<void> _showCreatePortfolioDialog() async {
    // Check portfolio limit for free users
    if (!_isPremium &&
        _portfolios.length >= SimulatorConstants.freeMaxPortfolios) {
      _showUpgradeDialog();
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CreatePortfolioDialog(isPremium: _isPremium),
    );

    if (result != null && mounted) {
      await _createPortfolio(
        name: result['name'] as String,
        capital: result['capital'] as double,
      );
    }
  }

  /// Create a new portfolio
  Future<void> _createPortfolio({
    required String name,
    required double capital,
  }) async {
    try {
      final userId = widget.userId ?? 'demo_user'; // TODO: Get from auth service
      final portfolio = SimulatedPortfolio.create(
        name: name,
        userId: userId,
        startingCapital: capital,
      );

      await _storageService.savePortfolio(portfolio);
      await _loadPortfolios();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(SimulatorConstants.successPortfolioCreated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create portfolio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show upgrade dialog for free users
  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text(SimulatorConstants.errorMaxPortfolios),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to paywall
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  /// Handle portfolio card tap
  void _onPortfolioTap(SimulatedPortfolio portfolio) {
    // Navigate to property browse screen
    Navigator.of(context).pushNamed(
      AppRouter.simulatorPropertyBrowse,
      arguments: portfolio,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Simulator'),
        actions: [
          // Leaderboard button
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: 'Leaderboard',
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRouter.simulatorLeaderboard,
                arguments: widget.userId ?? 'demo_user',
              );
            },
          ),
          // Settings/Help button
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () {
              // TODO: Show tutorial/help
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _portfolios.isEmpty
              ? EmptyPortfolioState(
                  onCreatePortfolio: _showCreatePortfolioDialog,
                )
              : RefreshIndicator(
                  onRefresh: _loadPortfolios,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Portfolios',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_portfolios.length} ${_portfolios.length == 1 ? 'portfolio' : 'portfolios'}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Portfolio Grid
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                SimulatorConstants.portfolioGridColumns,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemCount: _portfolios.length,
                          itemBuilder: (context, index) {
                            final portfolio = _portfolios[index];
                            return PortfolioCard(
                              portfolio: portfolio,
                              onTap: () => _onPortfolioTap(portfolio),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: _portfolios.isEmpty
          ? null // Hide FAB when empty state is shown
          : FloatingActionButton.extended(
              onPressed: _showCreatePortfolioDialog,
              icon: const Icon(Icons.add),
              label: const Text('New Portfolio'),
            ),
    );
  }
}
