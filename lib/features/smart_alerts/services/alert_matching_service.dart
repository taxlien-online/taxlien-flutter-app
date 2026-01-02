import 'package:flutter/foundation.dart';
import '../../../core/models/tax_lien_models.dart';
import '../models/property_alert.dart';
import '../models/alert_criteria.dart';
import '../models/alert_match.dart';
import '../constants/alert_constants.dart';

/// Alert Matching Service
///
/// Matches properties against alert criteria and generates matches
class AlertMatchingService {
  static final AlertMatchingService _instance =
      AlertMatchingService._internal();
  factory AlertMatchingService() => _instance;
  AlertMatchingService._internal();

  static AlertMatchingService get instance => _instance;

  /// Check if a property matches an alert
  Future<AlertMatch?> checkPropertyMatch({
    required TaxLien property,
    required PropertyAlert alert,
  }) async {
    // Only check active alerts
    if (!alert.isActive || alert.isExpired) {
      return null;
    }

    final matchedCriteria = <String>[];
    int totalScore = 0;
    int criteriaCount = alert.criteria.length;

    // Check each criteria
    for (final criteria in alert.criteria) {
      final match = _checkCriteria(property, criteria);
      if (match) {
        matchedCriteria.add(criteria.description);
        totalScore += 100; // Each criteria contributes equally
      }
    }

    // Calculate match score (0-100)
    final matchScore =
        criteriaCount > 0 ? (totalScore / criteriaCount).round() : 0;

    // Only create match if score meets minimum threshold
    if (matchScore < AlertConstants.minMatchScore) {
      return null;
    }

    return AlertMatch.create(
      alertId: alert.id,
      property: property,
      matchScore: matchScore,
      matchedCriteria: matchedCriteria,
    );
  }

  /// Check multiple properties against all alerts
  Future<List<AlertMatch>> checkPropertiesAgainstAlerts({
    required List<TaxLien> properties,
    required List<PropertyAlert> alerts,
  }) async {
    final matches = <AlertMatch>[];

    for (final alert in alerts) {
      for (final property in properties) {
        final match = await checkPropertyMatch(
          property: property,
          alert: alert,
        );
        if (match != null) {
          matches.add(match);
        }
      }
    }

    // Sort by match score (descending)
    matches.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return matches;
  }

  /// Check a single criteria against a property
  bool _checkCriteria(TaxLien property, AlertCriteria criteria) {
    try {
      switch (criteria.type) {
        case 'location':
          return _checkLocationCriteria(property, criteria);

        case 'roi':
          return _checkROICriteria(property, criteria);

        case 'price':
          return _checkPriceCriteria(property, criteria);

        case 'property_type':
          return _checkPropertyTypeCriteria(property, criteria);

        case 'interest_rate':
          return _checkInterestRateCriteria(property, criteria);

        default:
          debugPrint('Unknown criteria type: ${criteria.type}');
          return false;
      }
    } catch (e) {
      debugPrint('Error checking criteria: $e');
      return false;
    }
  }

  /// Check location criteria
  bool _checkLocationCriteria(TaxLien property, AlertCriteria criteria) {
    final location = '${property.county}, ${property.state}'.toLowerCase();
    final value = (criteria.value as String).toLowerCase();

    switch (criteria.operator) {
      case 'equals':
        return location == value ||
            property.county.toLowerCase() == value ||
            property.state.toLowerCase() == value;

      case 'contains':
        return location.contains(value) ||
            property.county.toLowerCase().contains(value) ||
            property.state.toLowerCase().contains(value);

      default:
        return false;
    }
  }

  /// Check ROI criteria
  bool _checkROICriteria(TaxLien property, AlertCriteria criteria) {
    final roi = ((property.estimatedValue - property.taxAmount) /
            property.taxAmount *
            100);
    final value = (criteria.value as num).toDouble();

    switch (criteria.operator) {
      case 'greater_than':
        return roi > value;

      case 'less_than':
        return roi < value;

      case 'between':
        final secondValue = (criteria.secondaryValue as num).toDouble();
        return roi >= value && roi <= secondValue;

      case 'equals':
        return (roi - value).abs() < 0.01;

      default:
        return false;
    }
  }

  /// Check price criteria
  bool _checkPriceCriteria(TaxLien property, AlertCriteria criteria) {
    final price = property.taxAmount;
    final value = (criteria.value as num).toDouble();

    switch (criteria.operator) {
      case 'greater_than':
        return price > value;

      case 'less_than':
        return price < value;

      case 'between':
        final secondValue = (criteria.secondaryValue as num).toDouble();
        return price >= value && price <= secondValue;

      case 'equals':
        return (price - value).abs() < 0.01;

      default:
        return false;
    }
  }

  /// Check property type criteria
  bool _checkPropertyTypeCriteria(TaxLien property, AlertCriteria criteria) {
    final propertyType = property.propertyType.toLowerCase();
    final value = (criteria.value as String).toLowerCase();

    switch (criteria.operator) {
      case 'equals':
        return propertyType == value;

      case 'contains':
        return propertyType.contains(value);

      default:
        return false;
    }
  }

  /// Check interest rate criteria
  bool _checkInterestRateCriteria(TaxLien property, AlertCriteria criteria) {
    final interestRate = property.interestRate;
    final value = (criteria.value as num).toDouble();

    switch (criteria.operator) {
      case 'greater_than':
        return interestRate > value;

      case 'less_than':
        return interestRate < value;

      case 'between':
        final secondValue = (criteria.secondaryValue as num).toDouble();
        return interestRate >= value && interestRate <= secondValue;

      case 'equals':
        return (interestRate - value).abs() < 0.01;

      default:
        return false;
    }
  }

  /// Get match explanation (why it matched)
  String getMatchExplanation(TaxLien property, PropertyAlert alert) {
    final explanations = <String>[];

    for (final criteria in alert.criteria) {
      if (_checkCriteria(property, criteria)) {
        explanations.add(criteria.description);
      }
    }

    if (explanations.isEmpty) {
      return 'No matching criteria';
    }

    return explanations.join(', ');
  }

  /// Calculate detailed match score breakdown
  Map<String, dynamic> getMatchScoreBreakdown({
    required TaxLien property,
    required PropertyAlert alert,
  }) {
    final breakdown = <String, dynamic>{
      'criteriaMatched': 0,
      'criteriaTotal': alert.criteria.length,
      'matchedCriteria': <String>[],
      'unmatchedCriteria': <String>[],
      'score': 0,
    };

    for (final criteria in alert.criteria) {
      if (_checkCriteria(property, criteria)) {
        breakdown['criteriaMatched']++;
        (breakdown['matchedCriteria'] as List).add(criteria.description);
      } else {
        (breakdown['unmatchedCriteria'] as List).add(criteria.description);
      }
    }

    breakdown['score'] = alert.criteria.isEmpty
        ? 0
        : ((breakdown['criteriaMatched'] as int) /
                    (breakdown['criteriaTotal'] as int) *
                    100)
                .round();

    return breakdown;
  }
}
