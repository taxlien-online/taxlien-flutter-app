import '../../../core/models/tax_lien_models.dart';

/// Alert match model
///
/// Represents a property that matched an alert's criteria
class AlertMatch {
  final String id;
  final String alertId;
  final String propertyId;
  final TaxLien property;
  final int matchScore; // 0-100
  final List<String> matchedCriteria;
  final DateTime matchedAt;
  final bool isViewed;
  final bool isNotified;
  final String priority; // high, medium, low

  const AlertMatch({
    required this.id,
    required this.alertId,
    required this.propertyId,
    required this.property,
    required this.matchScore,
    required this.matchedCriteria,
    required this.matchedAt,
    this.isViewed = false,
    this.isNotified = false,
    required this.priority,
  });

  /// Create from JSON
  factory AlertMatch.fromJson(Map<String, dynamic> json) {
    return AlertMatch(
      id: json['id'] as String,
      alertId: json['alertId'] as String,
      propertyId: json['propertyId'] as String,
      property: TaxLien.fromJson(json['property'] as Map<String, dynamic>),
      matchScore: (json['matchScore'] as num).toInt(),
      matchedCriteria:
          (json['matchedCriteria'] as List<dynamic>).cast<String>(),
      matchedAt: DateTime.parse(json['matchedAt'] as String),
      isViewed: json['isViewed'] as bool? ?? false,
      isNotified: json['isNotified'] as bool? ?? false,
      priority: json['priority'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alertId': alertId,
      'propertyId': propertyId,
      'property': property.toJson(),
      'matchScore': matchScore,
      'matchedCriteria': matchedCriteria,
      'matchedAt': matchedAt.toIso8601String(),
      'isViewed': isViewed,
      'isNotified': isNotified,
      'priority': priority,
    };
  }

  /// Copy with modifications
  AlertMatch copyWith({
    String? id,
    String? alertId,
    String? propertyId,
    TaxLien? property,
    int? matchScore,
    List<String>? matchedCriteria,
    DateTime? matchedAt,
    bool? isViewed,
    bool? isNotified,
    String? priority,
  }) {
    return AlertMatch(
      id: id ?? this.id,
      alertId: alertId ?? this.alertId,
      propertyId: propertyId ?? this.propertyId,
      property: property ?? this.property,
      matchScore: matchScore ?? this.matchScore,
      matchedCriteria: matchedCriteria ?? this.matchedCriteria,
      matchedAt: matchedAt ?? this.matchedAt,
      isViewed: isViewed ?? this.isViewed,
      isNotified: isNotified ?? this.isNotified,
      priority: priority ?? this.priority,
    );
  }

  /// Get priority display text
  String get priorityDisplay {
    switch (priority) {
      case 'high':
        return 'High Priority';
      case 'medium':
        return 'Medium Priority';
      case 'low':
        return 'Low Priority';
      default:
        return priority;
    }
  }

  /// Get match quality text
  String get matchQuality {
    if (matchScore >= 90) return 'Excellent Match';
    if (matchScore >= 75) return 'Great Match';
    if (matchScore >= 60) return 'Good Match';
    return 'Fair Match';
  }

  /// Get time since matched
  String get timeSinceMatched {
    final diff = DateTime.now().difference(matchedAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }

  /// Create a new match
  factory AlertMatch.create({
    required String alertId,
    required TaxLien property,
    required int matchScore,
    required List<String> matchedCriteria,
  }) {
    // Determine priority based on match score
    String priority;
    if (matchScore >= 85) {
      priority = 'high';
    } else if (matchScore >= 70) {
      priority = 'medium';
    } else {
      priority = 'low';
    }

    return AlertMatch(
      id: '${alertId}_${property.id}_${DateTime.now().millisecondsSinceEpoch}',
      alertId: alertId,
      propertyId: property.id,
      property: property,
      matchScore: matchScore,
      matchedCriteria: matchedCriteria,
      matchedAt: DateTime.now(),
      priority: priority,
    );
  }
}
