import 'package:equatable/equatable.dart';

/// Types of notifications
enum MagentoNotificationType {
  error,
  warning,
  info,
  success,
  sync,
  cloudFeature,
  network,
  auth,
  cache,
}

/// Notification priority levels
enum MagentoNotificationPriority { 
  low, 
  normal, 
  high, 
  critical 
}

/// Sync notification states
enum MagentoSyncNotificationState {
  started,
  progress,
  completed,
  error,
  conflict,
}

/// Cloud feature notification states
enum MagentoCloudNotificationState { 
  executing, 
  completed, 
  error, 
  fallback 
}

/// Notification delivery methods
enum NotificationDeliveryMethod {
  inApp,
  push,
  email,
  sms,
}

/// Notification categories
enum NotificationCategory {
  system,
  user,
  order,
  product,
  marketing,
  security,
  maintenance,
}

/// Extension methods for enums
extension MagentoNotificationTypeExtensions on MagentoNotificationType {
  /// Get display name for notification type
  String get displayName {
    switch (this) {
      case MagentoNotificationType.error:
        return 'Error';
      case MagentoNotificationType.warning:
        return 'Warning';
      case MagentoNotificationType.info:
        return 'Information';
      case MagentoNotificationType.success:
        return 'Success';
      case MagentoNotificationType.sync:
        return 'Synchronization';
      case MagentoNotificationType.cloudFeature:
        return 'Cloud Feature';
      case MagentoNotificationType.network:
        return 'Network';
      case MagentoNotificationType.auth:
        return 'Authentication';
      case MagentoNotificationType.cache:
        return 'Cache';
    }
  }

  /// Get icon name for notification type
  String get iconName {
    switch (this) {
      case MagentoNotificationType.error:
        return 'error_outline';
      case MagentoNotificationType.warning:
        return 'warning_amber';
      case MagentoNotificationType.info:
        return 'info_outline';
      case MagentoNotificationType.success:
        return 'check_circle_outline';
      case MagentoNotificationType.sync:
        return 'sync';
      case MagentoNotificationType.cloudFeature:
        return 'cloud_outline';
      case MagentoNotificationType.network:
        return 'wifi';
      case MagentoNotificationType.auth:
        return 'security';
      case MagentoNotificationType.cache:
        return 'storage';
    }
  }

  /// Get color value for notification type
  int get colorValue {
    switch (this) {
      case MagentoNotificationType.error:
        return 0xFFE53E3E; // Red
      case MagentoNotificationType.warning:
        return 0xFFED8936; // Orange
      case MagentoNotificationType.info:
        return 0xFF3182CE; // Blue
      case MagentoNotificationType.success:
        return 0xFF38A169; // Green
      case MagentoNotificationType.sync:
        return 0xFF805AD5; // Purple
      case MagentoNotificationType.cloudFeature:
        return 0xFF00B5D8; // Cyan
      case MagentoNotificationType.network:
        return 0xFFD69E2E; // Yellow
      case MagentoNotificationType.auth:
        return 0xFF9F7AEA; // Violet
      case MagentoNotificationType.cache:
        return 0xFF4A5568; // Gray
    }
  }
}

extension MagentoNotificationPriorityExtensions on MagentoNotificationPriority {
  /// Get display name for priority
  String get displayName {
    switch (this) {
      case MagentoNotificationPriority.low:
        return 'Low';
      case MagentoNotificationPriority.normal:
        return 'Normal';
      case MagentoNotificationPriority.high:
        return 'High';
      case MagentoNotificationPriority.critical:
        return 'Critical';
    }
  }

  /// Get numeric value for priority
  int get value {
    switch (this) {
      case MagentoNotificationPriority.low:
        return 1;
      case MagentoNotificationPriority.normal:
        return 2;
      case MagentoNotificationPriority.high:
        return 3;
      case MagentoNotificationPriority.critical:
        return 4;
    }
  }

  /// Check if priority is higher than another
  bool isHigherThan(MagentoNotificationPriority other) {
    return value > other.value;
  }

  /// Check if priority is lower than another
  bool isLowerThan(MagentoNotificationPriority other) {
    return value < other.value;
  }
}

extension NotificationDeliveryMethodExtensions on NotificationDeliveryMethod {
  /// Get display name for delivery method
  String get displayName {
    switch (this) {
      case NotificationDeliveryMethod.inApp:
        return 'In-App';
      case NotificationDeliveryMethod.push:
        return 'Push';
      case NotificationDeliveryMethod.email:
        return 'Email';
      case NotificationDeliveryMethod.sms:
        return 'SMS';
    }
  }

  /// Get icon name for delivery method
  String get iconName {
    switch (this) {
      case NotificationDeliveryMethod.inApp:
        return 'notifications';
      case NotificationDeliveryMethod.push:
        return 'phone_android';
      case NotificationDeliveryMethod.email:
        return 'email';
      case NotificationDeliveryMethod.sms:
        return 'sms';
    }
  }
}

extension NotificationCategoryExtensions on NotificationCategory {
  /// Get display name for category
  String get displayName {
    switch (this) {
      case NotificationCategory.system:
        return 'System';
      case NotificationCategory.user:
        return 'User';
      case NotificationCategory.order:
        return 'Order';
      case NotificationCategory.product:
        return 'Product';
      case NotificationCategory.marketing:
        return 'Marketing';
      case NotificationCategory.security:
        return 'Security';
      case NotificationCategory.maintenance:
        return 'Maintenance';
    }
  }

  /// Get icon name for category
  String get iconName {
    switch (this) {
      case NotificationCategory.system:
        return 'settings';
      case NotificationCategory.user:
        return 'person';
      case NotificationCategory.order:
        return 'shopping_cart';
      case NotificationCategory.product:
        return 'inventory';
      case NotificationCategory.marketing:
        return 'campaign';
      case NotificationCategory.security:
        return 'security';
      case NotificationCategory.maintenance:
        return 'build';
    }
  }
}


