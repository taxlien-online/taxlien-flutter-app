import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/unified_portfolio_service.dart';
import '../services/enhanced_yuku_service.dart';

/// Unified Analytics Screen
/// Shows performance metrics and insights for both asset types
class UnifiedAnalyticsScreen extends StatefulWidget {
  final UnifiedPortfolioService portfolioService;
  final EnhancedYukuService? yukuService;

  const UnifiedAnalyticsScreen({
    super.key,
    required this.portfolioService,
    this.yukuService,
  });

  @override
  State<UnifiedAnalyticsScreen> createState() => _UnifiedAnalyticsScreenState();
}

class _UnifiedAnalyticsScreenState extends State<UnifiedAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Обзор', icon: Icon(Icons.dashboard)),
            Tab(text: 'Доходность', icon: Icon(Icons.trending_up)),
            Tab(text: 'Распределение', icon: Icon(Icons.pie_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildPerformanceTab(),
          _buildDistributionTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return AnimatedBuilder(
      animation: widget.portfolioService,
      builder: (context, _) {
        final stats = widget.portfolioService.stats;
        if (stats == null) return const Center(child: CircularProgressIndicator());

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPI Cards
              Row(
                children: [
                  Expanded(
                    child: _buildKPICard(
                      'Общая стоимость',
                      '\$${stats.totalValue.toStringAsFixed(0)}',
                      Icons.account_balance_wallet,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKPICard(
                      'Средний ROI',
                      '${stats.weightedROI.toStringAsFixed(1)}%',
                      Icons.trending_up,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildKPICard(
                      'Активов',
                      '${stats.totalCount}',
                      Icons.layers,
                      Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKPICard(
                      'Заблокировано',
                      '${stats.lockedCount}',
                      Icons.lock,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Comparison Chart
              const Text(
                'Сравнение: Залоги vs NFT',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: stats.traditionalValue,
                            color: Colors.blue,
                            width: 40,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: stats.nftValue,
                            color: Colors.purple,
                            width: 40,
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value == 0 ? 'Залоги' : 'NFT',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceTab() {
    return const Center(
      child: Text('Performance charts will be here'),
    );
  }

  Widget _buildDistributionTab() {
    return const Center(
      child: Text('Distribution charts will be here'),
    );
  }

  Widget _buildKPICard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

