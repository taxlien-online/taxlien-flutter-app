/// Risk Assessment Model
class RiskAssessment {
  final String propertyId;
  final Map<String, int> riskScores; // Factor -> Score (0-100)
  final int overallRiskScore;
  final String riskLevel; // low, medium, high
  final List<String> warnings;
  final List<String> strengths;
  final DateTime assessedAt;

  const RiskAssessment({
    required this.propertyId,
    required this.riskScores,
    required this.overallRiskScore,
    required this.riskLevel,
    required this.warnings,
    required this.strengths,
    required this.assessedAt,
  });

  /// Get risk level display text
  String get riskLevelDisplay {
    switch (riskLevel) {
      case 'low':
        return 'Low Risk';
      case 'medium':
        return 'Medium Risk';
      case 'high':
        return 'High Risk';
      default:
        return riskLevel;
    }
  }

  /// Get risk score for a specific factor
  int getFactorScore(String factor) {
    return riskScores[factor] ?? 0;
  }

  /// Check if factor is high risk
  bool isFactorHighRisk(String factor) {
    return getFactorScore(factor) > 60;
  }

  /// Get color based on risk level
  int get riskColor {
    switch (riskLevel) {
      case 'low':
        return 0xFF4CAF50; // Green
      case 'medium':
        return 0xFFFF9800; // Orange
      case 'high':
        return 0xFFF44336; // Red
      default:
        return 0xFF9E9E9E; // Gray
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'riskScores': riskScores,
      'overallRiskScore': overallRiskScore,
      'riskLevel': riskLevel,
      'warnings': warnings,
      'strengths': strengths,
      'assessedAt': assessedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    return RiskAssessment(
      propertyId: json['propertyId'] as String,
      riskScores: Map<String, int>.from(json['riskScores'] as Map),
      overallRiskScore: json['overallRiskScore'] as int,
      riskLevel: json['riskLevel'] as String,
      warnings: List<String>.from(json['warnings'] as List),
      strengths: List<String>.from(json['strengths'] as List),
      assessedAt: DateTime.parse(json['assessedAt'] as String),
    );
  }
}
