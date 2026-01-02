/// ROI Calculation Result Model
class CalculationResult {
  final String scenario;
  final double taxAmount;
  final double interestRate;
  final int holdingMonths;
  final double propertyValue;

  // Calculated values
  final double totalInvestment;
  final double totalReturn;
  final double netProfit;
  final double roiPercent;
  final double annualizedROI;

  // Breakdown
  final double interestEarned;
  final double legalFees;
  final double holdingCosts;
  final double sellingCosts;
  final double repairCosts;

  const CalculationResult({
    required this.scenario,
    required this.taxAmount,
    required this.interestRate,
    required this.holdingMonths,
    required this.propertyValue,
    required this.totalInvestment,
    required this.totalReturn,
    required this.netProfit,
    required this.roiPercent,
    required this.annualizedROI,
    required this.interestEarned,
    required this.legalFees,
    required this.holdingCosts,
    required this.sellingCosts,
    required this.repairCosts,
  });

  /// Check if profitable
  bool get isProfitable => netProfit > 0;

  /// Get profit/loss display text
  String get profitLossText {
    final sign = netProfit >= 0 ? '+' : '';
    return '$sign\$${netProfit.toStringAsFixed(2)}';
  }

  /// Get ROI display text
  String get roiDisplayText {
    final sign = roiPercent >= 0 ? '+' : '';
    return '$sign${roiPercent.toStringAsFixed(1)}%';
  }

  /// Get annualized ROI display text
  String get annualizedROIText {
    final sign = annualizedROI >= 0 ? '+' : '';
    return '$sign${annualizedROI.toStringAsFixed(1)}%';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'scenario': scenario,
      'taxAmount': taxAmount,
      'interestRate': interestRate,
      'holdingMonths': holdingMonths,
      'propertyValue': propertyValue,
      'totalInvestment': totalInvestment,
      'totalReturn': totalReturn,
      'netProfit': netProfit,
      'roiPercent': roiPercent,
      'annualizedROI': annualizedROI,
      'interestEarned': interestEarned,
      'legalFees': legalFees,
      'holdingCosts': holdingCosts,
      'sellingCosts': sellingCosts,
      'repairCosts': repairCosts,
    };
  }
}
