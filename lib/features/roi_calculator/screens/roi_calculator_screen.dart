import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/calculation_result.dart';
import '../constants/calculator_constants.dart';

/// ROI Calculator Screen
///
/// Interactive calculator with sliders and real-time results
class ROICalculatorScreen extends StatefulWidget {
  const ROICalculatorScreen({super.key});

  @override
  State<ROICalculatorScreen> createState() => _ROICalculatorScreenState();
}

class _ROICalculatorScreenState extends State<ROICalculatorScreen> {
  double _taxAmount = 10000;
  double _interestRate = 12.0;
  int _holdingMonths = 12;
  double _valueMultiplier = 3.0;
  String _selectedScenario = CalculatorConstants.scenarioRedemption;

  @override
  Widget build(BuildContext context) {
    final result = _calculate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ROI Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveCalculation(result),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareCalculation(result),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            'Calculate Your Return',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adjust the sliders to see how different scenarios affect your ROI',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 24),

          // Tax Amount Slider
          _buildSlider(
            label: 'Tax Amount',
            value: _taxAmount,
            min: CalculatorConstants.minTaxAmount,
            max: CalculatorConstants.maxTaxAmount,
            divisions: 99,
            displayValue: '\$${_taxAmount.toStringAsFixed(0)}',
            onChanged: (value) => setState(() => _taxAmount = value),
          ),

          const SizedBox(height: 16),

          // Interest Rate Slider
          _buildSlider(
            label: 'Interest Rate',
            value: _interestRate,
            min: CalculatorConstants.minInterestRate,
            max: CalculatorConstants.maxInterestRate,
            divisions: 50,
            displayValue: '${_interestRate.toStringAsFixed(1)}%',
            onChanged: (value) => setState(() => _interestRate = value),
          ),

          const SizedBox(height: 16),

          // Holding Period Slider
          _buildSlider(
            label: 'Holding Period',
            value: _holdingMonths.toDouble(),
            min: CalculatorConstants.minHoldingMonths.toDouble(),
            max: CalculatorConstants.maxHoldingMonths.toDouble(),
            divisions: 35,
            displayValue: '$_holdingMonths months',
            onChanged: (value) =>
                setState(() => _holdingMonths = value.round()),
          ),

          const SizedBox(height: 16),

          // Property Value Multiplier
          _buildSlider(
            label: 'Property Value (×Tax Amount)',
            value: _valueMultiplier,
            min: CalculatorConstants.minValueMultiplier,
            max: CalculatorConstants.maxValueMultiplier,
            divisions: 90,
            displayValue: '${_valueMultiplier.toStringAsFixed(1)}x',
            onChanged: (value) => setState(() => _valueMultiplier = value),
          ),

          const SizedBox(height: 24),

          // Scenario Selector
          const Text(
            'Scenario',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'redemption',
                label: Text('Redemption'),
                icon: Icon(Icons.check_circle, size: 16),
              ),
              ButtonSegment(
                value: 'foreclosure',
                label: Text('Foreclosure'),
                icon: Icon(Icons.home, size: 16),
              ),
            ],
            selected: {_selectedScenario},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedScenario = newSelection.first;
              });
            },
          ),

          const SizedBox(height: 24),

          // Results Card
          _buildResultsCard(result),

          const SizedBox(height: 24),

          // Breakdown Card
          _buildBreakdownCard(result),

          const SizedBox(height: 24),

          // Comparison Chart
          _buildComparisonChart(),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String displayValue,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              displayValue,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildResultsCard(CalculationResult result) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ROI Percentage
            Text(
              result.roiDisplayText,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: result.isProfitable ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Return on Investment',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Net Profit
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Net Profit: ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  result.profitLossText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: result.isProfitable ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Annualized ROI
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Annualized: ${result.annualizedROIText}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(CalculationResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBreakdownRow('Investment', result.totalInvestment, false),
            _buildBreakdownRow('Interest Earned', result.interestEarned, true),
            _buildBreakdownRow('Total Return', result.totalReturn, true),
            const Divider(),
            _buildBreakdownRow('Legal Fees', result.legalFees, false),
            _buildBreakdownRow('Holding Costs', result.holdingCosts, false),
            if (_selectedScenario == CalculatorConstants.scenarioForeclosure) ...[
              _buildBreakdownRow('Repair Costs', result.repairCosts, false),
              _buildBreakdownRow('Selling Costs', result.sellingCosts, false),
            ],
            const Divider(),
            _buildBreakdownRow('Net Profit', result.netProfit, true,
                isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, double amount, bool isPositive,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart() {
    final scenarios = [
      _calculateScenario(CalculatorConstants.scenarioRedemption),
      _calculateScenario(CalculatorConstants.scenarioForeclosure),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scenario Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: scenarios
                      .map((s) => s.roiPercent)
                      .reduce((a, b) => a > b ? a : b),
                  barGroups: scenarios.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.roiPercent,
                          color: entry.value.isProfitable
                              ? Colors.green
                              : Colors.red,
                          width: 40,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final labels = ['Redemption', 'Foreclosure'];
                          return Text(
                            labels[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}%');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CalculationResult _calculate() {
    return _calculateScenario(_selectedScenario);
  }

  CalculationResult _calculateScenario(String scenario) {
    final propertyValue = _taxAmount * _valueMultiplier;

    // Calculate interest
    final monthlyRate = _interestRate / 100 / 12;
    final interestEarned = _taxAmount * monthlyRate * _holdingMonths;

    // Calculate costs
    final legalFees = _taxAmount * CalculatorConstants.legalFeesPercent;
    final holdingCosts =
        CalculatorConstants.holdingCostsPerMonth * _holdingMonths;

    double totalReturn;
    double sellingCosts = 0;
    double repairCosts = 0;

    if (scenario == CalculatorConstants.scenarioRedemption) {
      // Owner pays back with interest
      totalReturn = _taxAmount + interestEarned;
    } else {
      // Foreclosure - sell property
      repairCosts = propertyValue * CalculatorConstants.repairCostsPercent;
      sellingCosts = propertyValue * CalculatorConstants.sellingCostsPercent;
      totalReturn = propertyValue;
    }

    final totalInvestment =
        _taxAmount + legalFees + holdingCosts + repairCosts + sellingCosts;
    final netProfit = totalReturn - totalInvestment;
    final roiPercent = (netProfit / _taxAmount) * 100;
    final annualizedROI = (roiPercent / _holdingMonths) * 12;

    return CalculationResult(
      scenario: scenario,
      taxAmount: _taxAmount,
      interestRate: _interestRate,
      holdingMonths: _holdingMonths,
      propertyValue: propertyValue,
      totalInvestment: totalInvestment,
      totalReturn: totalReturn,
      netProfit: netProfit,
      roiPercent: roiPercent,
      annualizedROI: annualizedROI,
      interestEarned: interestEarned,
      legalFees: legalFees,
      holdingCosts: holdingCosts,
      sellingCosts: sellingCosts,
      repairCosts: repairCosts,
    );
  }

  void _saveCalculation(CalculationResult result) {
    // TODO: Save to local storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calculation saved!')),
    );
  }

  void _shareCalculation(CalculationResult result) {
    // TODO: Share via share_plus
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing calculation...')),
    );
  }
}
