/// User preferences for property matching
class UserPreferences {
  final double minPrice;
  final double maxPrice;
  final double minROI;
  final List<String> preferredCounties;
  final List<String> preferredStates;
  final List<String> preferredPropertyTypes;

  const UserPreferences({
    this.minPrice = 0,
    this.maxPrice = 500000,
    this.minROI = 30.0,
    this.preferredCounties = const [],
    this.preferredStates = const [],
    this.preferredPropertyTypes = const [],
  });

  UserPreferences copyWith({
    double? minPrice,
    double? maxPrice,
    double? minROI,
    List<String>? preferredCounties,
    List<String>? preferredStates,
    List<String>? preferredPropertyTypes,
  }) {
    return UserPreferences(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minROI: minROI ?? this.minROI,
      preferredCounties: preferredCounties ?? this.preferredCounties,
      preferredStates: preferredStates ?? this.preferredStates,
      preferredPropertyTypes:
          preferredPropertyTypes ?? this.preferredPropertyTypes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'minROI': minROI,
      'preferredCounties': preferredCounties,
      'preferredStates': preferredStates,
      'preferredPropertyTypes': preferredPropertyTypes,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 500000,
      minROI: (json['minROI'] as num?)?.toDouble() ?? 30.0,
      preferredCounties: (json['preferredCounties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preferredStates: (json['preferredStates'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preferredPropertyTypes: (json['preferredPropertyTypes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  /// Get default preferences
  static UserPreferences get defaults => const UserPreferences();
}
