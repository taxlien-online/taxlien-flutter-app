import 'package:flutter/foundation.dart';
import '../../../core/models/tax_lien_models.dart';
import '../models/user_preferences.dart';
import '../models/match.dart';
import '../constants/detective_constants.dart';

/// Service for matching properties with user preferences
///
/// Calculates match scores and determines if properties are a match
class MatchService {
  static final MatchService _instance = MatchService._internal();
  factory MatchService() => _instance;
  MatchService._internal();

  static MatchService get instance => _instance;

  /// Calculate match score for a property based on user preferences
  double calculateMatchScore({
    required TaxLien property,
    required UserPreferences preferences,
  }) {
    double score = 0.0;
    int factors = 0;

    // Factor 1: ROI (40% weight)
    final roi = ((property.estimatedValue - property.taxAmount) /
            property.taxAmount *
            100);
    if (roi >= preferences.minROI) {
      final roiScore = (roi / 100).clamp(0.0, 1.0);
      score += roiScore * 0.4;
    }
    factors++;

    // Factor 2: Price Range (25% weight)
    if (property.taxAmount >= preferences.minPrice &&
        property.taxAmount <= preferences.maxPrice) {
      score += 0.25;
    }
    factors++;

    // Factor 3: Location Preference (20% weight)
    if (preferences.preferredCounties.isEmpty ||
        preferences.preferredCounties.contains(property.county)) {
      score += 0.2;
    }
    factors++;

    // Factor 4: Property Type (10% weight)
    if (preferences.preferredPropertyTypes.isEmpty ||
        preferences.preferredPropertyTypes.contains(property.propertyType)) {
      score += 0.1;
    }
    factors++;

    // Factor 5: Risk Score (5% weight)
    // Lower interest rate = lower risk = better score
    if (property.interestRate <= 15) {
      final riskScore = (15 - property.interestRate) / 15;
      score += riskScore * 0.05;
    }
    factors++;

    return score.clamp(0.0, 1.0);
  }

  /// Determine if a property is a match based on criteria
  bool isMatch({
    required TaxLien property,
    required UserPreferences preferences,
  }) {
    final matchScore = calculateMatchScore(
      property: property,
      preferences: preferences,
    );

    // Match if score is above threshold (60%)
    return matchScore >= 0.6;
  }

  /// Calculate match probability badge (before swipe)
  String getMatchProbability({
    required TaxLien property,
    required UserPreferences preferences,
  }) {
    final score = calculateMatchScore(
      property: property,
      preferences: preferences,
    );

    if (score >= 0.8) return 'High Match';
    if (score >= 0.6) return 'Good Match';
    if (score >= 0.4) return 'Fair Match';
    return 'Low Match';
  }

  /// Get match probability color
  Color getMatchColor(double score) {
    if (score >= 0.8) return const Color(0xFF4CAF50); // Green
    if (score >= 0.6) return const Color(0xFF2196F3); // Blue
    if (score >= 0.4) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  /// Generate match reasoning (why this is a match)
  List<String> getMatchReasons({
    required TaxLien property,
    required UserPreferences preferences,
  }) {
    final reasons = <String>[];

    // ROI check
    final roi = ((property.estimatedValue - property.taxAmount) /
            property.taxAmount *
            100);
    if (roi >= preferences.minROI) {
      reasons.add('${roi.toStringAsFixed(1)}% ROI exceeds your minimum');
    }

    // Price check
    if (property.taxAmount >= preferences.minPrice &&
        property.taxAmount <= preferences.maxPrice) {
      reasons.add('Price fits your budget range');
    }

    // Location check
    if (preferences.preferredCounties.contains(property.county)) {
      reasons.add('In your preferred county: ${property.county}');
    }

    // Property type check
    if (preferences.preferredPropertyTypes.contains(property.propertyType)) {
      reasons.add('Matches your preferred type: ${property.propertyType}');
    }

    // Risk assessment
    if (property.interestRate <= 12) {
      reasons.add('Low-risk investment (${property.interestRate}% interest)');
    }

    // Value assessment
    final valueRatio = property.estimatedValue / property.taxAmount;
    if (valueRatio >= 3) {
      reasons.add('Excellent value ratio (${valueRatio.toStringAsFixed(1)}x)');
    }

    return reasons;
  }

  /// Create match object when user swipes right
  Match createMatch({
    required String userId,
    required TaxLien property,
    required UserPreferences preferences,
  }) {
    final matchScore = calculateMatchScore(
      property: property,
      preferences: preferences,
    );

    final reasons = getMatchReasons(
      property: property,
      preferences: preferences,
    );

    return Match(
      id: '${userId}_${property.id}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      propertyId: property.id,
      property: property,
      matchScore: matchScore,
      matchReasons: reasons,
      matchedAt: DateTime.now(),
    );
  }

  /// Get personalized recommendations based on swipe history
  Future<List<TaxLien>> getRecommendations({
    required String userId,
    required List<String> likedPropertyIds,
    required List<TaxLien> availableProperties,
  }) async {
    // TODO: Implement ML-based recommendations
    // For now, return properties sorted by basic criteria

    availableProperties.sort((a, b) {
      final roiA = (a.estimatedValue - a.taxAmount) / a.taxAmount;
      final roiB = (b.estimatedValue - b.taxAmount) / b.taxAmount;
      return roiB.compareTo(roiA);
    });

    return availableProperties.take(20).toList();
  }
}
