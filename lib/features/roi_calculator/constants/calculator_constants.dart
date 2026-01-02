/// Constants for ROI Calculator feature
///
/// Interactive ROI calculation with multiple scenarios
library;

class CalculatorConstants {
  CalculatorConstants._();

  // === CALCULATION PARAMETERS ===

  /// Default redemption probability
  static const double defaultRedemptionRate = 0.65;

  /// Default foreclosure probability
  static const double defaultForeclosureRate = 0.15;

  /// Default partial payment probability
  static const double defaultPartialRate = 0.10;

  /// Default loss probability
  static const double defaultLossRate = 0.10;

  // === SCENARIO TYPES ===

  /// Redemption scenario
  static const String scenarioRedemption = 'redemption';

  /// Foreclosure scenario
  static const String scenarioForeclosure = 'foreclosure';

  /// Partial payment scenario
  static const String scenarioPartial = 'partial';

  /// Loss scenario
  static const String scenarioLoss = 'loss';

  // === COST ASSUMPTIONS ===

  /// Legal fees percentage (of tax amount)
  static const double legalFeesPercent = 0.05;

  /// Selling costs percentage (of property value)
  static const double sellingCostsPercent = 0.06;

  /// Holding costs per month
  static const double holdingCostsPerMonth = 200.0;

  /// Repair costs percentage (for foreclosure)
  static const double repairCostsPercent = 0.10;

  // === TIME ASSUMPTIONS ===

  /// Average redemption period (months)
  static const int avgRedemptionMonths = 12;

  /// Average foreclosure period (months)
  static const int avgForeclosureMonths = 18;

  /// Average partial payment period (months)
  static const int avgPartialMonths = 9;

  // === SLIDER RANGES ===

  /// Min tax amount for slider
  static const double minTaxAmount = 1000;

  /// Max tax amount for slider
  static const double maxTaxAmount = 100000;

  /// Min interest rate for slider
  static const double minInterestRate = 0;

  /// Max interest rate for slider
  static const double maxInterestRate = 25;

  /// Min holding period (months)
  static const int minHoldingMonths = 1;

  /// Max holding period (months)
  static const int maxHoldingMonths = 36;

  /// Min property value multiplier
  static const double minValueMultiplier = 1.0;

  /// Max property value multiplier
  static const double maxValueMultiplier = 10.0;

  // === UI CONSTANTS ===

  /// Chart height
  static const double chartHeight = 200.0;

  /// Scenario card height
  static const double scenarioCardHeight = 120.0;

  // === COLORS ===

  /// Positive ROI color
  static const int positiveColor = 0xFF4CAF50; // Green

  /// Negative ROI color
  static const int negativeColor = 0xFFF44336; // Red

  /// Neutral color
  static const int neutralColor = 0xFFFF9800; // Orange

  /// Chart colors for scenarios
  static const List<int> chartColors = [
    0xFF4CAF50, // Redemption - Green
    0xFF2196F3, // Foreclosure - Blue
    0xFFFF9800, // Partial - Orange
    0xFFF44336, // Loss - Red
  ];
}
