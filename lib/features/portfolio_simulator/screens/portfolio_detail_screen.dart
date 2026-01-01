import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/simulated_portfolio.dart';
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';
import '../providers/simulator_provider.dart';
import '../widgets/position_card.dart';
import '../widgets/portfolio_stats_card.dart';
import '../widgets/performance_chart.dart';
import '../../../core/routing/app_router.dart';

/// Portfolio Detail Screen
///
/// Shows detailed view of a simulated portfolio including:
/// - Performance statistics
/// - Position list
/// - Performance chart
class PortfolioDetailScreen extends StatefulWidget {
  final SimulatedPortfolio portfolio;

  const PortfolioDetailScreen({
    super.key,
    required this.portfolio,
  });

  @override
  State<PortfolioDetailScreen> createState() => _PortfolioDetailScreenState();
}

class _PortfolioDetailScreenState extends State<PortfolioDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPositions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPositions() async {
    final provider = context.read<SimulatorProvider>();
    await provider.setActivePortfolio(widget.portfolio.id);
  }

  void _navigateToBrowseProperties() {
    Navigator.of(context).pushNamed(
      AppRouter.simulatorPropertyBrowse,
      arguments: widget.portfolio,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<SimulatorProvider>();
    final positions = provider.positions;

    // Calculate stats
    final activePositions =
        positions.where((p) => p.status == PositionStatus.simulating).toList();
    final completedPositions = positions
        .where((p) =>
            p.status == PositionStatus.outcomeReady ||
            p.status == PositionStatus.completed)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.portfolio.name),
            Text(
              'Portfolio Details',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard, size: 20)),
            Tab(text: 'Active', icon: Icon(Icons.access_time, size: 20)),
            Tab(text: 'Completed', icon: Icon(Icons.check_circle, size: 20)),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPositions,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(provider),
                  _buildActiveTab(activePositions, provider),
                  _buildCompletedTab(completedPositions, provider),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToBrowseProperties,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Browse Properties'),
      ),
    );
  }

  Widget _buildOverviewTab(SimulatorProvider provider) {
    final positions = provider.positions;
    final completedPositions = positions.where((p) =>
        p.status == PositionStatus.outcomeReady ||
        p.status == PositionStatus.completed);

    // Calculate total P&L
    double totalProfitLoss = 0;
    int wins = 0;
    int losses = 0;

    for (final position in completedPositions) {
      final outcome = provider.getOutcome(position.id);
      if (outcome != null) {
        totalProfitLoss += outcome.profitLoss;
        if (outcome.profitLoss > 0) {
          wins++;
        } else {
          losses++;
        }
      }
    }

    final winRate = completedPositions.isEmpty
        ? 0.0
        : (wins / completedPositions.length) * 100;
    final avgROI = completedPositions.isEmpty
        ? 0.0
        : (totalProfitLoss / widget.portfolio.investedValue) * 100;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Capital Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Capital',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '\$${widget.portfolio.availableCapital.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Starting Capital'),
                    Text(
                      '\$${widget.portfolio.startingCapital.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Invested Value'),
                    Text(
                      '\$${widget.portfolio.investedValue.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Stats Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            PortfolioStatsCard(
              title: 'Total Positions',
              value: '${positions.length}',
              icon: Icons.list,
              color: Colors.blue,
            ),
            PortfolioStatsCard(
              title: 'Win Rate',
              value: '${winRate.toStringAsFixed(1)}%',
              icon: Icons.trending_up,
              color: Colors.green,
            ),
            PortfolioStatsCard(
              title: 'Profit/Loss',
              value: '\$${totalProfitLoss.toStringAsFixed(2)}',
              icon: Icons.attach_money,
              color: totalProfitLoss >= 0 ? Colors.green : Colors.red,
            ),
            PortfolioStatsCard(
              title: 'Avg ROI',
              value: '${avgROI.toStringAsFixed(1)}%',
              icon: Icons.percent,
              color: avgROI >= 0 ? Colors.green : Colors.red,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Performance Chart
        if (completedPositions.isNotEmpty) ...[
          const Text(
            'Performance Over Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: PerformanceChart(
              positions: positions.toList(),
              outcomes: completedPositions
                  .map((p) => provider.getOutcome(p.id))
                  .whereType<SimulationOutcome>()
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActiveTab(
    List<SimulatedPosition> positions,
    SimulatorProvider provider,
  ) {
    if (positions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No active simulations',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _navigateToBrowseProperties,
              child: const Text('Start Simulating'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final position = positions[index];
        return PositionCard(
          position: position,
          outcome: null,
        );
      },
    );
  }

  Widget _buildCompletedTab(
    List<SimulatedPosition> positions,
    SimulatorProvider provider,
  ) {
    if (positions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No completed simulations',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start simulating to see results here',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final position = positions[index];
        final outcome = provider.getOutcome(position.id);

        return PositionCard(
          position: position,
          outcome: outcome,
        );
      },
    );
  }
}
