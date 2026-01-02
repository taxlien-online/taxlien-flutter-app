import '../../../core/models/tax_lien_models.dart';
import '../models/risk_assessment.dart';
import 'dart:math' as math;

/// Risk Assessment Service
class RiskAssessmentService {
  static final RiskAssessmentService _instance = RiskAssessmentService._internal();
  factory RiskAssessmentService() => _instance;
  RiskAssessmentService._internal();

  static RiskAssessmentService get instance => _instance;

  /// Assess property risk
  Future<RiskAssessment> assessProperty(TaxLien property) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Calculate risk scores for each factor
    final riskScores = {
      'legal': _calculateLegalRisk(property),
      'market': _calculateMarketRisk(property),
      'location': _calculateLocationRisk(property),
      'condition': _calculateConditionRisk(property),
      'financial': _calculateFinancialRisk(property),
      'competition': _calculateCompetitionRisk(property),
    };

    // Calculate weighted overall score
    final overallScore = _calculateOverallRisk(riskScores);

    // Determine risk level
    String riskLevel;
    if (overallScore < 30) {
      riskLevel = 'low';
    } else if (overallScore < 60) {
      riskLevel = 'medium';
    } else {
      riskLevel = 'high';
    }

    // Generate warnings and strengths
    final warnings = _generateWarnings(riskScores);
    final strengths = _generateStrengths(riskScores);

    return RiskAssessment(
      propertyId: property.id,
      riskScores: riskScores,
      overallRiskScore: overallScore,
      riskLevel: riskLevel,
      warnings: warnings,
      strengths: strengths,
      assessedAt: DateTime.now(),
    );
  }

  int _calculateLegalRisk(TaxLien property) {
    // Simplified: higher tax amount = potentially more liens
    return ((property.taxAmount / 50000) * 40).round().clamp(0, 100);
  }

  int _calculateMarketRisk(TaxLien property) {
    // Simplified: based on property value
    final valueRatio = property.estimatedValue / property.taxAmount;
    return (100 - (valueRatio * 10)).round().clamp(0, 100);
  }

  int _calculateLocationRisk(TaxLien property) {
    // Simplified: random for demo
    return math.Random(property.id.hashCode).nextInt(60) + 20;
  }

  int _calculateConditionRisk(TaxLien property) {
    // Simplified: assume older properties higher risk
    return math.Random(property.id.hashCode + 1).nextInt(50) + 10;
  }

  int _calculateFinancialRisk(TaxLien property) {
    // Based on ROI potential
    final roi = ((property.estimatedValue - property.taxAmount) / property.taxAmount * 100);
    return (100 - roi).round().clamp(0, 100);
  }

  int _calculateCompetitionRisk(TaxLien property) {
    // Simplified: random for demo
    return math.Random(property.id.hashCode + 2).nextInt(40) + 10;
  }

  int _calculateOverallRisk(Map<String, int> scores) {
    const weights = {
      'legal': 0.25,
      'market': 0.20,
      'location': 0.15,
      'condition': 0.20,
      'financial': 0.15,
      'competition': 0.05,
    };

    double total = 0;
    scores.forEach((key, value) {
      total += value * (weights[key] ?? 0);
    });

    return total.round();
  }

  List<String> _generateWarnings(Map<String, int> scores) {
    final warnings = <String>[];
    scores.forEach((factor, score) {
      if (score > 60) {
        warnings.add('High ${_getFactorName(factor)} detected');
      }
    });
    return warnings;
  }

  List<String> _generateStrengths(Map<String, int> scores) {
    final strengths = <String>[];
    scores.forEach((factor, score) {
      if (score < 30) {
        strengths.add('Low ${_getFactorName(factor)}');
      }
    });
    return strengths;
  }

  String _getFactorName(String factor) {
    const names = {
      'legal': 'legal risk',
      'market': 'market risk',
      'location': 'location risk',
      'condition': 'condition risk',
      'financial': 'financial risk',
      'competition': 'competition',
    };
    return names[factor] ?? factor;
  }
}
