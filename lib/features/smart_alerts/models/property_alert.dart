import 'alert_criteria.dart';

/// Property alert model
///
/// Represents a user-created alert with multiple criteria
class PropertyAlert {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final List<AlertCriteria> criteria;
  final String status; // active, paused, triggered, expired
  final String frequency; // immediate, hourly, daily, weekly
  final List<String> notificationChannels; // push, email, sms
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastTriggeredAt;
  final DateTime? expiresAt;
  final int matchCount;
  final int notificationCount;
  final bool isPriority;

  const PropertyAlert({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.criteria,
    required this.status,
    required this.frequency,
    required this.notificationChannels,
    required this.createdAt,
    this.updatedAt,
    this.lastTriggeredAt,
    this.expiresAt,
    this.matchCount = 0,
    this.notificationCount = 0,
    this.isPriority = false,
  });

  /// Create from JSON
  factory PropertyAlert.fromJson(Map<String, dynamic> json) {
    return PropertyAlert(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      criteria: (json['criteria'] as List<dynamic>)
          .map((c) => AlertCriteria.fromJson(c as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      frequency: json['frequency'] as String,
      notificationChannels:
          (json['notificationChannels'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastTriggeredAt: json['lastTriggeredAt'] != null
          ? DateTime.parse(json['lastTriggeredAt'] as String)
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      matchCount: (json['matchCount'] as num?)?.toInt() ?? 0,
      notificationCount: (json['notificationCount'] as num?)?.toInt() ?? 0,
      isPriority: json['isPriority'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'criteria': criteria.map((c) => c.toJson()).toList(),
      'status': status,
      'frequency': frequency,
      'notificationChannels': notificationChannels,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastTriggeredAt': lastTriggeredAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'matchCount': matchCount,
      'notificationCount': notificationCount,
      'isPriority': isPriority,
    };
  }

  /// Copy with modifications
  PropertyAlert copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    List<AlertCriteria>? criteria,
    String? status,
    String? frequency,
    List<String>? notificationChannels,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastTriggeredAt,
    DateTime? expiresAt,
    int? matchCount,
    int? notificationCount,
    bool? isPriority,
  }) {
    return PropertyAlert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      criteria: criteria ?? this.criteria,
      status: status ?? this.status,
      frequency: frequency ?? this.frequency,
      notificationChannels: notificationChannels ?? this.notificationChannels,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
      expiresAt: expiresAt ?? this.expiresAt,
      matchCount: matchCount ?? this.matchCount,
      notificationCount: notificationCount ?? this.notificationCount,
      isPriority: isPriority ?? this.isPriority,
    );
  }

  /// Check if alert is active
  bool get isActive => status == 'active';

  /// Check if alert is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Get status display text
  String get statusDisplay {
    switch (status) {
      case 'active':
        return 'Active';
      case 'paused':
        return 'Paused';
      case 'triggered':
        return 'Triggered';
      case 'expired':
        return 'Expired';
      default:
        return status;
    }
  }

  /// Get frequency display text
  String get frequencyDisplay {
    switch (frequency) {
      case 'immediate':
        return 'Instant';
      case 'hourly':
        return 'Hourly';
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      default:
        return frequency;
    }
  }

  /// Get criteria summary
  String get criteriaSummary {
    if (criteria.isEmpty) return 'No criteria';
    if (criteria.length == 1) return criteria.first.description;
    return '${criteria.length} criteria';
  }

  /// Get days until expiration
  int? get daysUntilExpiration {
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now()).inDays;
  }

  /// Create a new alert
  factory PropertyAlert.create({
    required String userId,
    required String name,
    String? description,
    required List<AlertCriteria> criteria,
    String frequency = 'immediate',
    List<String> notificationChannels = const ['push'],
    bool isPriority = false,
    DateTime? expiresAt,
  }) {
    return PropertyAlert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: name,
      description: description,
      criteria: criteria,
      status: 'active',
      frequency: frequency,
      notificationChannels: notificationChannels,
      createdAt: DateTime.now(),
      expiresAt: expiresAt,
      isPriority: isPriority,
    );
  }
}
