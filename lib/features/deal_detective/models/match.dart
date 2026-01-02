import '../../../core/models/tax_lien_models.dart';

/// Match model representing a property-user match
class Match {
  final String id;
  final String userId;
  final String propertyId;
  final TaxLien property;
  final double matchScore;
  final List<String> matchReasons;
  final DateTime matchedAt;
  final bool isViewed;

  const Match({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.property,
    required this.matchScore,
    required this.matchReasons,
    required this.matchedAt,
    this.isViewed = false,
  });

  Match copyWith({
    String? id,
    String? userId,
    String? propertyId,
    TaxLien? property,
    double? matchScore,
    List<String>? matchReasons,
    DateTime? matchedAt,
    bool? isViewed,
  }) {
    return Match(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      propertyId: propertyId ?? this.propertyId,
      property: property ?? this.property,
      matchScore: matchScore ?? this.matchScore,
      matchReasons: matchReasons ?? this.matchReasons,
      matchedAt: matchedAt ?? this.matchedAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }

  /// Get match quality description
  String get matchQuality {
    if (matchScore >= 0.8) return 'Excellent Match';
    if (matchScore >= 0.6) return 'Good Match';
    if (matchScore >= 0.4) return 'Fair Match';
    return 'Possible Match';
  }

  /// Get match score percentage
  int get matchPercentage => (matchScore * 100).round();
}
