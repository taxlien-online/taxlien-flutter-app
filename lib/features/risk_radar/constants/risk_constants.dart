/// Constants for Risk Radar feature
///
/// Visual risk assessment with radar charts
library;

class RiskConstants {
  RiskConstants._();

  // === RISK FACTORS ===

  /// Legal/Title risk
  static const String factorLegal = 'legal';

  /// Market risk
  static const String factorMarket = 'market';

  /// Location risk
  static const String factorLocation = 'location';

  /// Property condition risk
  static const String factorCondition = 'condition';

  /// Financial risk
  static const String factorFinancial = 'financial';

  /// Competition risk
  static const String factorCompetition = 'competition';

  // === RISK LEVELS ===

  /// Low risk threshold (0-30)
  static const int lowRiskThreshold = 30;

  /// Medium risk threshold (31-60)
  static const int mediumRiskThreshold = 60;

  /// High risk threshold (61-100)
  static const int highRiskThreshold = 100;

  // === RISK WEIGHTS ===

  /// Legal risk weight
  static const double legalWeight = 0.25;

  /// Market risk weight
  static const double marketWeight = 0.20;

  /// Location risk weight
  static const double locationWeight = 0.15;

  /// Condition risk weight
  static const double conditionWeight = 0.20;

  /// Financial risk weight
  static const double financialWeight = 0.15;

  /// Competition risk weight
  static const double competitionWeight = 0.05;

  // === UI CONSTANTS ===

  /// Radar chart size
  static const double radarChartSize = 300.0;

  /// Risk card height
  static const double riskCardHeight = 100.0;

  /// Max properties to compare
  static const int maxCompareProperties = 3;

  // === COLORS ===

  /// Low risk color
  static const int lowRiskColor = 0xFF4CAF50; // Green

  /// Medium risk color
  static const int mediumRiskColor = 0xFFFF9800; // Orange

  /// High risk color
  static const int highRiskColor = 0xFFF44336; // Red

  /// Radar chart colors (for comparison)
  static const List<int> radarColors = [
    0xFF2196F3, // Blue
    0xFFF44336, // Red
    0xFF4CAF50, // Green
  ];

  // === LABELS ===

  static const Map<String, String> factorLabels = {
    'legal': 'Legal/Title',
    'market': 'Market',
    'location': 'Location',
    'condition': 'Condition',
    'financial': 'Financial',
    'competition': 'Competition',
  };

  static const Map<String, String> factorDescriptions = {
    'legal': 'Title clarity, liens, legal issues',
    'market': 'Property value trends, demand',
    'location': 'Neighborhood quality, crime, schools',
    'condition': 'Property state, repairs needed',
    'financial': 'ROI potential, costs, expenses',
    'competition': 'Bidder count, auction competition',
  };
}
