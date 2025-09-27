import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/tax_lien_service.dart';
import '../services/ai_investment_advisor_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../core/models/tax_lien_models.dart';

class PortfolioDashboardScreen extends StatefulWidget {
  final TaxLienService taxLienService;
  final AIInvestmentAdvisorService aiService;

  const PortfolioDashboardScreen({
    super.key,
    required this.taxLienService,
    required this.aiService,
  });

  @override
  State<PortfolioDashboardScreen> createState() => _PortfolioDashboardScreenState();
}

class _PortfolioDashboardScreenState extends State<PortfolioDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = true;
  PortfolioStats? _portfolioStats;
  MarketInsights? _marketInsights;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadDashboardData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      // Загружаем данные портфеля
      await widget.taxLienService.loadMyLiens();
      
      // Вычисляем статистику портфеля
      _portfolioStats = _calculatePortfolioStats();
      
      // Получаем рыночную аналитику
      _marketInsights = await widget.aiService.getMarketInsights(
        widget.taxLienService.availableLiens.cast<TaxLien>(),
      );
      
      _animationController.forward();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки данных: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  PortfolioStats _calculatePortfolioStats() {
    final myLiens = widget.taxLienService.myLiens;
    
    if (myLiens.isEmpty) {
      return PortfolioStats(
        totalInvestment: 0,
        currentValue: 0,
        totalReturn: 0,
        roiPercentage: 0,
        activeInvestments: 0,
        monthlyIncome: 0,
        performanceData: [],
        countyDistribution: {},
        riskDistribution: {'Low': 0, 'Medium': 0, 'High': 0},
      );
    }
    
    double totalInvestment = myLiens
        .map((lien) => lien.salePrice ?? lien.taxAmount)
        .reduce((a, b) => a + b);
    
    // Симуляция текущей стоимости (с учетом процентов)
    double currentValue = 0;
    for (LegacyTaxLien lien in myLiens) {
      double principal = lien.salePrice ?? lien.taxAmount;
      int monthsHeld = DateTime.now().difference(lien.auctionDate).inDays ~/ 30;
      double interest = principal * (lien.interestRate / 100) * (monthsHeld / 12);
      currentValue += principal + interest;
    }
    
    double totalReturn = currentValue - totalInvestment;
    double roiPercentage = totalInvestment > 0 ? (totalReturn / totalInvestment) * 100 : 0;
    
    // Месячный доход
    double monthlyIncome = totalInvestment * 0.015; // Примерно 1.5% в месяц
    
    // Данные производительности за последние 12 месяцев
    List<PerformanceData> performanceData = _generatePerformanceData();
    
    // Распределение по округам
    Map<String, double> countyDistribution = {};
    for (LegacyTaxLien lien in myLiens) {
      double investment = lien.salePrice ?? lien.taxAmount;
      countyDistribution[lien.county] = 
          (countyDistribution[lien.county] ?? 0) + investment;
    }
    
    // Распределение по рискам (симуляция)
    Map<String, double> riskDistribution = {
      'Low': totalInvestment * 0.4,
      'Medium': totalInvestment * 0.45,
      'High': totalInvestment * 0.15,
    };
    
    return PortfolioStats(
      totalInvestment: totalInvestment,
      currentValue: currentValue,
      totalReturn: totalReturn,
      roiPercentage: roiPercentage,
      activeInvestments: myLiens.length,
      monthlyIncome: monthlyIncome,
      performanceData: performanceData,
      countyDistribution: countyDistribution,
      riskDistribution: riskDistribution,
    );
  }

  List<PerformanceData> _generatePerformanceData() {
    List<PerformanceData> data = [];
    DateTime now = DateTime.now();
    
    for (int i = 11; i >= 0; i--) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      double value = 10000 + (i * 500) + (i * i * 100); // Растущий тренд
      data.add(PerformanceData(month, value));
    }
    
    return data;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Портфель')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой Портфель'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            children: [
              _buildPortfolioOverview(),
              const SizedBox(height: AppDimensions.lg),
              _buildPerformanceChart(),
              const SizedBox(height: AppDimensions.lg),
              _buildDistributionCharts(),
              const SizedBox(height: AppDimensions.lg),
              _buildMarketInsights(),
              const SizedBox(height: AppDimensions.lg),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Обзор Портфеля',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Общие инвестиции',
                    '\$${_portfolioStats!.totalInvestment.toStringAsFixed(0)}',
                    Icons.account_balance_wallet,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: _buildStatCard(
                    'Текущая стоимость',
                    '\$${_portfolioStats!.currentValue.toStringAsFixed(0)}',
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Общий доход',
                    '\$${_portfolioStats!.totalReturn.toStringAsFixed(0)}',
                    Icons.attach_money,
                    _portfolioStats!.totalReturn >= 0 ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: _buildStatCard(
                    'ROI',
                    '${_portfolioStats!.roiPercentage.toStringAsFixed(1)}%',
                    Icons.percent,
                    _portfolioStats!.roiPercentage >= 0 ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Активных инвестиций',
                    '${_portfolioStats!.activeInvestments}',
                    Icons.business_center,
                    AppColors.secondary,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: _buildStatCard(
                    'Месячный доход',
                    '\$${_portfolioStats!.monthlyIncome.toStringAsFixed(0)}',
                    Icons.calendar_month,
                    AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.sm),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppDimensions.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Динамика Портфеля',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${(value / 1000).toStringAsFixed(0)}K',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
                                         'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
                          final index = value.toInt();
                          if (index >= 0 && index < months.length) {
                            return Text(
                              months[index],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _portfolioStats!.performanceData
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
                          .toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.3),
                            AppColors.accent.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildDistributionCharts() {
    return Row(
      children: [
        Expanded(child: _buildCountyDistribution()),
        const SizedBox(width: AppDimensions.sm),
        Expanded(child: _buildRiskDistribution()),
      ],
    );
  }

  Widget _buildCountyDistribution() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'По округам',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: _getCountySections(),
                  centerSpaceRadius: 30,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1000.ms, delay: 400.ms).scale(begin: Offset(0.8, 0.8));
  }

  List<PieChartSectionData> _getCountySections() {
    final colors = [AppColors.primary, AppColors.secondary, AppColors.accent, AppColors.success];
    final entries = _portfolioStats!.countyDistribution.entries.toList();
    
    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final county = entry.value;
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: county.value,
        title: county.key,
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildRiskDistribution() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'По рискам',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: _getRiskSections(),
                  centerSpaceRadius: 30,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1000.ms, delay: 600.ms).scale(begin: Offset(0.8, 0.8));
  }

  List<PieChartSectionData> _getRiskSections() {
    return [
      PieChartSectionData(
        color: AppColors.success,
        value: _portfolioStats!.riskDistribution['Low']!,
        title: 'Низкий',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppColors.warning,
        value: _portfolioStats!.riskDistribution['Medium']!,
        title: 'Средний',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppColors.error,
        value: _portfolioStats!.riskDistribution['High']!,
        title: 'Высокий',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildMarketInsights() {
    if (_marketInsights == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Анализ Рынка AI',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _marketInsights!.marketTrend,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    _marketInsights!.recommendedAction,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                _buildInsightStat(
                  'Доступно',
                  '${_marketInsights!.totalAvailable}',
                  Icons.store,
                ),
                const SizedBox(width: AppDimensions.md),
                _buildInsightStat(
                  'Средняя ставка',
                  '${_marketInsights!.averageInterestRate.toStringAsFixed(1)}%',
                  Icons.percent,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1200.ms, delay: 800.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildInsightStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.xs),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: AppDimensions.xs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Быстрые Действия',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/marketplace');
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Купить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ai-advisor');
                    },
                    icon: const Icon(Icons.psychology),
                    label: const Text('AI Советы'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1400.ms, delay: 1000.ms).slideY(begin: 0.3, end: 0);
  }
}

class PortfolioStats {
  final double totalInvestment;
  final double currentValue;
  final double totalReturn;
  final double roiPercentage;
  final int activeInvestments;
  final double monthlyIncome;
  final List<PerformanceData> performanceData;
  final Map<String, double> countyDistribution;
  final Map<String, double> riskDistribution;

  PortfolioStats({
    required this.totalInvestment,
    required this.currentValue,
    required this.totalReturn,
    required this.roiPercentage,
    required this.activeInvestments,
    required this.monthlyIncome,
    required this.performanceData,
    required this.countyDistribution,
    required this.riskDistribution,
  });
}

class PerformanceData {
  final DateTime date;
  final double value;

  PerformanceData(this.date, this.value);
}
