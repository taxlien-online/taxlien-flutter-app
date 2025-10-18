import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/portfolio_service.dart';

class PerformanceChartWidget extends StatefulWidget {
  final List<PerformanceDataPoint> data;
  final TimePeriod timePeriod;

  const PerformanceChartWidget({
    Key? key,
    required this.data,
    required this.timePeriod,
  }) : super(key: key);

  @override
  State<PerformanceChartWidget> createState() => _PerformanceChartWidgetState();
}

class _PerformanceChartWidgetState extends State<PerformanceChartWidget> {
  bool _showGrid = true;
  bool _showPoints = true;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildChart(),
            const SizedBox(height: 16),
            _buildChartControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final totalReturn = _calculateTotalReturn();
    final isPositive = totalReturn >= 0;

    return Row(
      children: [
        Icon(
          Icons.trending_up,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'Performance Chart',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isPositive
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPositive ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Text(
            '${isPositive ? '+' : ''}${totalReturn.toStringAsFixed(1)}%',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: _showGrid,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval: _calculateInterval(),
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: _calculateXAxisInterval(),
                getTitlesWidget: (value, meta) {
                  return _buildBottomTitle(value, meta);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _calculateInterval(),
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return _buildLeftTitle(value, meta);
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          minX: 0,
          maxX: widget.data.length.toDouble() - 1,
          minY: _calculateMinY(),
          maxY: _calculateMaxY(),
          lineBarsData: [
            LineChartBarData(
              spots: _buildSpots(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: _showPoints,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                    strokeColor: Theme.of(context).colorScheme.surface,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final dataPoint = widget.data[touchedSpot.x.toInt()];
                  return LineTooltipItem(
                    '${_formatDate(dataPoint.date)}\n\$${dataPoint.value.toStringAsFixed(2)}',
                    TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
            getTouchLineStart: (data, index) => 0,
            getTouchLineEnd: (data, index) => double.infinity,
            touchSpotThreshold: 50,
          ),
        ),
      ),
    );
  }

  Widget _buildChartControls() {
    return Row(
      children: [
        _buildControlButton(
          'Grid',
          _showGrid,
          Icons.grid_on,
          () => setState(() => _showGrid = !_showGrid),
        ),
        const SizedBox(width: 8),
        _buildControlButton(
          'Points',
          _showPoints,
          Icons.circle,
          () => setState(() => _showPoints = !_showPoints),
        ),
        const Spacer(),
        Text(
          '${widget.data.length} data points',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildControlButton(
      String label, bool isActive, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.trending_up,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Performance Data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start investing to see your performance chart',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    if (value.toInt() >= widget.data.length) return const SizedBox.shrink();

    final dataPoint = widget.data[value.toInt()];
    return SideTitleWidget(
      meta: meta,
      child: Text(
        _formatDateShort(dataPoint.date),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        '\$${(value / 1000).toStringAsFixed(0)}k',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    return widget.data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }

  double _calculateTotalReturn() {
    if (widget.data.length < 2) return 0;

    final firstValue = widget.data.first.value;
    final lastValue = widget.data.last.value;

    return ((lastValue - firstValue) / firstValue) * 100;
  }

  double _calculateMinY() {
    if (widget.data.isEmpty) return 0;

    final minValue =
        widget.data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
    return minValue * 0.95; // 5% margin
  }

  double _calculateMaxY() {
    if (widget.data.isEmpty) return 100;

    final maxValue =
        widget.data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    return maxValue * 1.05; // 5% margin
  }

  double _calculateInterval() {
    final minY = _calculateMinY();
    final maxY = _calculateMaxY();
    final range = maxY - minY;

    if (range < 1000) return 100;
    if (range < 10000) return 1000;
    if (range < 100000) return 10000;
    return 100000;
  }

  double _calculateXAxisInterval() {
    final dataLength = widget.data.length;
    if (dataLength <= 10) return 1;
    if (dataLength <= 30) return 2;
    if (dataLength <= 100) return 5;
    return 10;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

class PerformanceMetricsCard extends StatelessWidget {
  final PortfolioPerformance performance;

  const PerformanceMetricsCard({
    Key? key,
    required this.performance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    context,
                    'Total Return',
                    '\$${performance.totalReturn.toStringAsFixed(2)}',
                    Icons.trending_up,
                    performance.totalReturn >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    context,
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
                    context,
                    'Monthly Return',
                    '\$${performance.monthlyReturn.toStringAsFixed(2)}',
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    context,
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

  Widget _buildMetricItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
}
