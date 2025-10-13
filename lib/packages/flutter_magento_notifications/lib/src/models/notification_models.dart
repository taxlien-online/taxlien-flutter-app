import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// Universal notification model for Magento events
@freezed
class MagentoNotification with _$MagentoNotification {
  const factory MagentoNotification({
    required String id,
    required MagentoNotificationType type,
    required String message,
    String? title,
    @Default(MagentoNotificationPriority.normal) MagentoNotificationPriority priority,
    Map<String, dynamic>? data,
    required DateTime timestamp,
    DateTime? expiresAt,
    @Default(false) bool isRead,
    String? actionUrl,
    String? imageUrl,
  }) = _MagentoNotification;

  factory MagentoNotification.fromJson(Map<String, dynamic> json) =>
      _$MagentoNotificationFromJson(json);
}

/// Notification subscription for managing listeners
@freezed
class MagentoNotificationSubscription with _$MagentoNotificationSubscription {
  const factory MagentoNotificationSubscription({
    required String id,
    MagentoNotificationType? type,
    required void Function(MagentoNotification) callback,
    MagentoNotificationPriority? minPriority,
    bool Function(MagentoNotification)? filter,
  }) = _MagentoNotificationSubscription;

  factory MagentoNotificationSubscription.fromJson(Map<String, dynamic> json) =>
      _$MagentoNotificationSubscriptionFromJson(json);
}

/// Notification configuration
@freezed
class NotificationConfig with _$NotificationConfig {
  const factory NotificationConfig({
    @Default(true) bool enablePersistence,
    @Default(1000) int maxHistorySize,
    @Default(true) bool enableSound,
    @Default(true) bool enableVibration,
    @Default(true) bool enableBadge,
    @Default(Duration(minutes: 5)) Duration defaultTtl,
    @Default(true) bool autoMarkAsRead,
    @Default(50) int maxNotificationsPerType,
  }) = _NotificationConfig;

  factory NotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$NotificationConfigFromJson(json);
}

/// Notification statistics
@freezed
class NotificationStats with _$NotificationStats {
  const factory NotificationStats({
    @Default(0) int totalNotifications,
    @Default(0) int unreadNotifications,
    @Default(0) int notificationsByType,
    @Default(0) int notificationsToday,
    @Default(0) int notificationsThisWeek,
    @Default(0) int notificationsThisMonth,
  }) = _NotificationStats;

  factory NotificationStats.fromJson(Map<String, dynamic> json) =>
      _$NotificationStatsFromJson(json);
}

/// Extension methods for MagentoNotification
extension MagentoNotificationExtensions on MagentoNotification {
  /// Check if notification is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if notification is high priority
  bool get isHighPriority => priority == MagentoNotificationPriority.high;

  /// Check if notification is critical
  bool get isCritical => priority == MagentoNotificationPriority.critical;

  /// Get formatted timestamp
  String get formattedTimestamp {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get notification color based on type and priority
  int get colorValue {
    switch (type) {
      case MagentoNotificationType.error:
        return 0xFFE53E3E; // Red
      case MagentoNotificationType.warning:
        return 0xFFED8936; // Orange
      case MagentoNotificationType.success:
        return 0xFF38A169; // Green
      case MagentoNotificationType.info:
        return 0xFF3182CE; // Blue
      default:
        return 0xFF4A5568; // Gray
    }
  }

  /// Get notification icon based on type
  String get iconName {
    switch (type) {
      case MagentoNotificationType.error:
        return 'error';
      case MagentoNotificationType.warning:
        return 'warning';
      case MagentoNotificationType.success:
        return 'check_circle';
      case MagentoNotificationType.info:
        return 'info';
      case MagentoNotificationType.sync:
        return 'sync';
      case MagentoNotificationType.cloudFeature:
        return 'cloud';
      case MagentoNotificationType.network:
        return 'wifi';
      case MagentoNotificationType.auth:
        return 'security';
      case MagentoNotificationType.cache:
        return 'storage';
    }
  }
}


