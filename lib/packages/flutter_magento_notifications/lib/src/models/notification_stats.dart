import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'notification_types.dart';

/// Statistics for notifications
@immutable
class NotificationStats extends Equatable {
  /// Total number of notifications
  final int total;

  /// Number of unread notifications
  final int unread;

  /// Number of read notifications
  final int read;

  /// Number of expired notifications
  final int expired;

  /// Statistics by type
  final Map<MagentoNotificationType, int> byType;

  /// Statistics by priority
  final Map<MagentoNotificationPriority, int> byPriority;

  /// Most recent notification timestamp
  final DateTime? lastNotificationAt;

  /// Average notifications per day
  final double averagePerDay;

  /// Most active notification type
  final MagentoNotificationType? mostActiveType;

  /// Most common priority
  final MagentoNotificationPriority? mostCommonPriority;

  const NotificationStats({
    required this.total,
    required this.unread,
    required this.read,
    required this.expired,
    required this.byType,
    required this.byPriority,
    this.lastNotificationAt,
    this.averagePerDay = 0.0,
    this.mostActiveType,
    this.mostCommonPriority,
  });

  /// Create from JSON
  factory NotificationStats.fromJson(Map<String, dynamic> json) {
    return NotificationStats(
      total: json['total'] ?? 0,
      unread: json['unread'] ?? 0,
      read: json['read'] ?? 0,
      expired: json['expired'] ?? 0,
      byType: _parseTypeStats(json['byType']),
      byPriority: _parsePriorityStats(json['byPriority']),
      lastNotificationAt: json['lastNotificationAt'] != null
          ? DateTime.parse(json['lastNotificationAt'])
          : null,
      averagePerDay: (json['averagePerDay'] ?? 0.0).toDouble(),
      mostActiveType: json['mostActiveType'] != null
          ? MagentoNotificationType.values.firstWhere(
              (e) => e.name == json['mostActiveType'],
            )
          : null,
      mostCommonPriority: json['mostCommonPriority'] != null
          ? MagentoNotificationPriority.values.firstWhere(
              (e) => e.name == json['mostCommonPriority'],
            )
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'unread': unread,
      'read': read,
      'expired': expired,
      'byType': byType.map((key, value) => MapEntry(key.name, value)),
      'byPriority': byPriority.map((key, value) => MapEntry(key.name, value)),
      'lastNotificationAt': lastNotificationAt?.toIso8601String(),
      'averagePerDay': averagePerDay,
      'mostActiveType': mostActiveType?.name,
      'mostCommonPriority': mostCommonPriority?.name,
    };
  }

  /// Copy with new values
  NotificationStats copyWith({
    int? total,
    int? unread,
    int? read,
    int? expired,
    Map<MagentoNotificationType, int>? byType,
    Map<MagentoNotificationPriority, int>? byPriority,
    DateTime? lastNotificationAt,
    double? averagePerDay,
    MagentoNotificationType? mostActiveType,
    MagentoNotificationPriority? mostCommonPriority,
  }) {
    return NotificationStats(
      total: total ?? this.total,
      unread: unread ?? this.unread,
      read: read ?? this.read,
      expired: expired ?? this.expired,
      byType: byType ?? this.byType,
      byPriority: byPriority ?? this.byPriority,
      lastNotificationAt: lastNotificationAt ?? this.lastNotificationAt,
      averagePerDay: averagePerDay ?? this.averagePerDay,
      mostActiveType: mostActiveType ?? this.mostActiveType,
      mostCommonPriority: mostCommonPriority ?? this.mostCommonPriority,
    );
  }

  /// Get read percentage
  double get readPercentage => total > 0 ? (read / total) * 100 : 0.0;

  /// Get unread percentage
  double get unreadPercentage => total > 0 ? (unread / total) * 100 : 0.0;

  /// Get expired percentage
  double get expiredPercentage => total > 0 ? (expired / total) * 100 : 0.0;

  /// Get count for specific type
  int getCountForType(MagentoNotificationType type) {
    return byType[type] ?? 0;
  }

  /// Get count for specific priority
  int getCountForPriority(MagentoNotificationPriority priority) {
    return byPriority[priority] ?? 0;
  }

  /// Get percentage for specific type
  double getPercentageForType(MagentoNotificationType type) {
    final count = getCountForType(type);
    return total > 0 ? (count / total) * 100 : 0.0;
  }

  /// Get percentage for specific priority
  double getPercentageForPriority(MagentoNotificationPriority priority) {
    final count = getCountForPriority(priority);
    return total > 0 ? (count / total) * 100 : 0.0;
  }

  /// Check if there are any notifications
  bool get hasNotifications => total > 0;

  /// Check if there are unread notifications
  bool get hasUnread => unread > 0;

  /// Check if there are expired notifications
  bool get hasExpired => expired > 0;

  /// Get top notification types (sorted by count)
  List<MapEntry<MagentoNotificationType, int>> get topTypes {
    final entries = byType.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  /// Get top priorities (sorted by count)
  List<MapEntry<MagentoNotificationPriority, int>> get topPriorities {
    final entries = byPriority.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  /// Get summary text
  String get summary {
    if (total == 0) return 'No notifications';
    if (unread == 0) return '$total notifications, all read';
    return '$total notifications, $unread unread';
  }

  /// Get detailed summary
  String get detailedSummary {
    final buffer = StringBuffer();
    buffer.writeln('Total: $total');
    buffer.writeln('Unread: $unread (${unreadPercentage.toStringAsFixed(1)}%)');
    buffer.writeln('Read: $read (${readPercentage.toStringAsFixed(1)}%)');
    if (expired > 0) {
      buffer.writeln(
        'Expired: $expired (${expiredPercentage.toStringAsFixed(1)}%)',
      );
    }
    if (averagePerDay > 0) {
      buffer.writeln('Average per day: ${averagePerDay.toStringAsFixed(1)}');
    }
    if (mostActiveType != null) {
      buffer.writeln('Most active type: ${mostActiveType!.displayName}');
    }
    if (mostCommonPriority != null) {
      buffer.writeln(
        'Most common priority: ${mostCommonPriority!.displayName}',
      );
    }
    return buffer.toString().trim();
  }

  static Map<MagentoNotificationType, int> _parseTypeStats(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return {};

    final Map<MagentoNotificationType, int> result = {};
    for (final entry in json.entries) {
      final type = MagentoNotificationType.values.firstWhere(
        (e) => e.name == entry.key,
        orElse: () => MagentoNotificationType.general,
      );
      result[type] = entry.value as int;
    }
    return result;
  }

  static Map<MagentoNotificationPriority, int> _parsePriorityStats(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return {};

    final Map<MagentoNotificationPriority, int> result = {};
    for (final entry in json.entries) {
      final priority = MagentoNotificationPriority.values.firstWhere(
        (e) => e.name == entry.key,
        orElse: () => MagentoNotificationPriority.normal,
      );
      result[priority] = entry.value as int;
    }
    return result;
  }

  @override
  List<Object?> get props => [
    total,
    unread,
    read,
    expired,
    byType,
    byPriority,
    lastNotificationAt,
    averagePerDay,
    mostActiveType,
    mostCommonPriority,
  ];

  @override
  String toString() {
    return 'NotificationStats('
        'total: $total, '
        'unread: $unread, '
        'read: $read, '
        'expired: $expired, '
        'byType: $byType, '
        'byPriority: $byPriority, '
        'lastNotificationAt: $lastNotificationAt, '
        'averagePerDay: $averagePerDay, '
        'mostActiveType: $mostActiveType, '
        'mostCommonPriority: $mostCommonPriority'
        ')';
  }
}
