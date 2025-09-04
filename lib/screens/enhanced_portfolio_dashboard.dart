import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/portfolio_service.dart';
import '../widgets/portfolio_overview_card.dart';
import '../widgets/performance_chart_widget.dart';
import '../widgets/asset_allocation_chart.dart';
import '../widgets/goals_progress_widget.dart';
import '../widgets/alerts_widget.dart';
import '../widgets/quick_actions_widget.dart';

class EnhancedPortfolioDashboard extends StatefulWidget {
  final PortfolioService portfolioService;

  const EnhancedPortfolioDashboard({
    Key? key,
    required this.portfolioService,
  }) : super(key: key);

  @override
  State<EnhancedPortfolioDashboard> createState() => _EnhancedPortfolioDashboardState();
}

class _EnhancedPortfolioDashboardState extends State<EnhancedPortfolioDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  
  TimePeriod _selectedTimePeriod = TimePeriod.month;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await widget.portfolioService.initialize();
    _animationController.forward();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    
    await widget.portfolioService.loadPortfolioData();
    
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
          PopupMenuButton<TimePeriod>(
            icon: const Icon(Icons.timeline),
            onSelected: (period) {
              setState(() {
                _selectedTimePeriod = period;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TimePeriod.day,
                child: Text('1 Day'),
              ),
              const PopupMenuItem(
                value: TimePeriod.week,
                child: Text('1 Week'),
              ),
              const PopupMenuItem(
                value: TimePeriod.month,
                child: Text('1 Month'),
              ),
              const PopupMenuItem(
                value: TimePeriod.quarter,
                child: Text('3 Months'),
              ),
              const PopupMenuItem(
                value: TimePeriod.year,
                child: Text('1 Year'),
              ),
              const PopupMenuItem(
                value: TimePeriod.all,
                child: Text('All Time'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.trending_up), text: 'Performance'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Allocation'),
            Tab(icon: Icon(Icons.flag), text: 'Goals'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildPerformanceTab(),
            _buildAllocationTab(),
            _buildGoalsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Portfolio overview card
          PortfolioOverviewCard(
            summary: widget.portfolioService.getPortfolioSummary(),
            performance: widget.portfolioService.performance,
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 16),
          
          // Quick actions
          QuickActionsWidget(
            onAddInvestment: () => _showAddInvestmentDialog(),
            onViewMarketplace: () => _navigateToMarketplace(),
            onSetGoal: () => _showSetGoalDialog(),
            onViewReports: () => _navigateToReports(),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 16),
          
          // Recent transactions
          _buildRecentTransactions(),
          
          const SizedBox(height: 16),
          
          // Alerts
          AlertsWidget(
            alerts: widget.portfolioService.alerts,
            onAlertTap: _handleAlertTap,
            onMarkAsRead: _markAlertAsRead,
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Performance chart
          PerformanceChartWidget(
            data: widget.portfolioService.getPerformanceData(_selectedTimePeriod),
            timePeriod: _selectedTimePeriod,
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 16),
          
          // Performance metrics
          _buildPerformanceMetrics(),
          
          const SizedBox(height: 16),
          
          // Risk metrics
          _buildRiskMetrics(),
        ],
      ),
    );
  }

  Widget _buildAllocationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Asset allocation chart
          AssetAllocationChart(
            allocation: widget.portfolioService.getAssetAllocation(),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 16),
          
          // County distribution
          _buildCountyDistribution(),
          
          const SizedBox(height: 16),
          
          // Asset details
          _buildAssetDetails(),
        ],
      ),
    );
  }

  Widget _buildGoalsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Goals progress
          GoalsProgressWidget(
            goals: widget.portfolioService.goals,
            onGoalTap: _handleGoalTap,
            onAddGoal: _showSetGoalDialog,
            onEditGoal: _showEditGoalDialog,
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 16),
          
          // Goal recommendations
          _buildGoalRecommendations(),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = widget.portfolioService.transactions.take(5).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _navigateToTransactions(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (transactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No transactions yet'),
                ),
              )
            else
              ...transactions.map((transaction) => _buildTransactionItem(transaction)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(PortfolioTransaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getTransactionColor(transaction.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
              color: _getTransactionColor(transaction.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatTransactionDate(transaction.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.type == TransactionType.purchase ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _getTransactionColor(transaction.type),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    final performance = widget.portfolioService.performance;
    if (performance == null) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Total Return',
                    '\$${performance.totalReturn.toStringAsFixed(2)}',
                    Icons.trending_up,
                    performance.totalReturn >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'ROI',
                    '${performance.roiPercentage.toStringAsFixed(1)}%',
                    Icons.percent,
                    performance.roiPercentage >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Monthly Return',
                    '\$${performance.monthlyReturn.toStringAsFixed(2)}',
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Sharpe Ratio',
                    performance.sharpeRatio.toStringAsFixed(2),
                    Icons.analytics,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskMetrics() {
    final performance = widget.portfolioService.performance;
    if (performance == null) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risk Metrics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Max Drawdown',
                    '${performance.maxDrawdown.toStringAsFixed(1)}%',
                    Icons.trending_down,
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Volatility',
                    '${performance.volatility.toStringAsFixed(1)}%',
                    Icons.speed,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Beta',
                    performance.beta.toStringAsFixed(2),
                    Icons.compare_arrows,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Risk Score',
                    '${widget.portfolioService.getPortfolioSummary().riskScore.toStringAsFixed(0)}/100',
                    Icons.warning,
                    _getRiskColor(widget.portfolioService.getPortfolioSummary().riskScore),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountyDistribution() {
    final distribution = widget.portfolioService.getCountyDistribution();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'County Distribution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (distribution.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No county data available'),
                ),
              )
            else
              ...distribution.entries.map((entry) => _buildDistributionItem(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionItem(String county, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(county),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetDetails() {
    final myLiens = widget.portfolioService.myLiens;
    final myProducts = widget.portfolioService.myProducts;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildAssetTypeSection('Tax Liens', myLiens.length, Icons.real_estate_agent),
            const SizedBox(height: 12),
            _buildAssetTypeSection('Products', myProducts.length, Icons.store),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetTypeSection(String title, int count, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(title),
        const Spacer(),
        Text(
          '$count assets',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalRecommendations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goal Recommendations',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              'Diversify Your Portfolio',
              'Consider investing in different counties to reduce risk',
              Icons.pie_chart,
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              'Increase Monthly Investment',
              'Add \$500 monthly to reach your retirement goal faster',
              Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String description, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // Helper methods
  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return Colors.red;
      case TransactionType.sale:
        return Colors.green;
      case TransactionType.dividend:
      case TransactionType.interest:
        return Colors.blue;
      case TransactionType.fee:
        return Colors.orange;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return Icons.shopping_cart;
      case TransactionType.sale:
        return Icons.sell;
      case TransactionType.dividend:
      case TransactionType.interest:
        return Icons.account_balance_wallet;
      case TransactionType.fee:
        return Icons.receipt;
    }
  }

  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getRiskColor(double riskScore) {
    if (riskScore < 30) return Colors.green;
    if (riskScore < 60) return Colors.orange;
    return Colors.red;
  }

  // Navigation and dialog methods
  void _showAddInvestmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Investment'),
        content: const Text('Choose how you want to add a new investment to your portfolio.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToMarketplace();
            },
            child: const Text('Browse Marketplace'),
          ),
        ],
      ),
    );
  }

  void _showSetGoalDialog() {
    // TODO: Implement goal setting dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal setting dialog coming soon')),
    );
  }

  void _showEditGoalDialog(String goalId) {
    // TODO: Implement goal editing dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal editing dialog coming soon')),
    );
  }

  void _navigateToMarketplace() {
    // TODO: Navigate to marketplace
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigating to marketplace...')),
    );
  }

  void _navigateToReports() {
    // TODO: Navigate to reports
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reports coming soon')),
    );
  }

  void _navigateToTransactions() {
    // TODO: Navigate to transactions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction history coming soon')),
    );
  }

  void _handleAlertTap(PortfolioAlert alert) {
    if (alert.actionUrl != null) {
      // TODO: Navigate to alert action
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigating to ${alert.actionUrl}')),
      );
    }
  }

  void _markAlertAsRead(String alertId) {
    widget.portfolioService.markAlertAsRead(alertId);
  }

  void _handleGoalTap(PortfolioGoal goal) {
    // TODO: Show goal details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Goal details for ${goal.title}')),
    );
  }
}
