import 'package:equatable/equatable.dart';

/// Configuration class for notification service
class NotificationConfig extends Equatable {
  /// Enable notification persistence
  final bool enablePersistence;

  /// Maximum history size
  final int maxHistorySize;

  /// Enable sound notifications
  final bool enableSound;

  /// Enable vibration notifications
  final bool enableVibration;

  /// Enable badge notifications
  final bool enableBadge;

  /// Default TTL for notifications
  final Duration defaultTtl;

  /// Auto mark notifications as read
  final bool autoMarkAsRead;

  /// Maximum notifications per type
  final int maxNotificationsPerType;

  /// Enable email notifications
  final bool enableEmail;

  /// Enable push notifications
  final bool enablePush;

  /// Push notification provider
  final String pushProvider;

  /// Push notification API key
  final String? pushApiKey;

  /// Push notification project ID
  final String? pushProjectId;

  const NotificationConfig({
    this.enablePersistence = true,
    this.maxHistorySize = 1000,
    this.enableSound = true,
    this.enableVibration = true,
    this.enableBadge = true,
    this.defaultTtl = const Duration(minutes: 5),
    this.autoMarkAsRead = true,
    this.maxNotificationsPerType = 50,
    this.enableEmail = true,
    this.enablePush = false,
    this.pushProvider = 'firebase',
    this.pushApiKey,
    this.pushProjectId,
  });

  /// Create configuration from environment variables
  factory NotificationConfig.fromEnvironment() {
    return NotificationConfig(
      enablePersistence: bool.fromEnvironment(
        'NOTIFICATION_PERSISTENCE',
        defaultValue: true,
      ),
      maxHistorySize: int.fromEnvironment(
        'NOTIFICATION_MAX_HISTORY',
        defaultValue: 1000,
      ),
      enableSound: bool.fromEnvironment(
        'NOTIFICATION_SOUND',
        defaultValue: true,
      ),
      enableVibration: bool.fromEnvironment(
        'NOTIFICATION_VIBRATION',
        defaultValue: true,
      ),
      enableBadge: bool.fromEnvironment(
        'NOTIFICATION_BADGE',
        defaultValue: true,
      ),
      defaultTtl: Duration(
        seconds: int.fromEnvironment('NOTIFICATION_TTL', defaultValue: 300),
      ),
      autoMarkAsRead: bool.fromEnvironment(
        'NOTIFICATION_AUTO_READ',
        defaultValue: true,
      ),
      maxNotificationsPerType: int.fromEnvironment(
        'NOTIFICATION_MAX_PER_TYPE',
        defaultValue: 50,
      ),
      enableEmail: bool.fromEnvironment(
        'NOTIFICATION_EMAIL',
        defaultValue: true,
      ),
      enablePush: bool.fromEnvironment(
        'NOTIFICATION_PUSH',
        defaultValue: false,
      ),
      pushProvider: const String.fromEnvironment(
        'NOTIFICATION_PUSH_PROVIDER',
        defaultValue: 'firebase',
      ),
      pushApiKey: const String.fromEnvironment('NOTIFICATION_PUSH_API_KEY'),
      pushProjectId: const String.fromEnvironment(
        'NOTIFICATION_PUSH_PROJECT_ID',
      ),
    );
  }

  /// Create configuration from JSON
  factory NotificationConfig.fromJson(Map<String, dynamic> json) {
    return NotificationConfig(
      enablePersistence: json['enablePersistence'] ?? true,
      maxHistorySize: json['maxHistorySize'] ?? 1000,
      enableSound: json['enableSound'] ?? true,
      enableVibration: json['enableVibration'] ?? true,
      enableBadge: json['enableBadge'] ?? true,
      defaultTtl: Duration(seconds: json['defaultTtl'] ?? 300),
      autoMarkAsRead: json['autoMarkAsRead'] ?? true,
      maxNotificationsPerType: json['maxNotificationsPerType'] ?? 50,
      enableEmail: json['enableEmail'] ?? true,
      enablePush: json['enablePush'] ?? false,
      pushProvider: json['pushProvider'] ?? 'firebase',
      pushApiKey: json['pushApiKey'],
      pushProjectId: json['pushProjectId'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'enablePersistence': enablePersistence,
      'maxHistorySize': maxHistorySize,
      'enableSound': enableSound,
      'enableVibration': enableVibration,
      'enableBadge': enableBadge,
      'defaultTtl': defaultTtl.inSeconds,
      'autoMarkAsRead': autoMarkAsRead,
      'maxNotificationsPerType': maxNotificationsPerType,
      'enableEmail': enableEmail,
      'enablePush': enablePush,
      'pushProvider': pushProvider,
      'pushApiKey': pushApiKey,
      'pushProjectId': pushProjectId,
    };
  }

  /// Copy with new values
  NotificationConfig copyWith({
    bool? enablePersistence,
    int? maxHistorySize,
    bool? enableSound,
    bool? enableVibration,
    bool? enableBadge,
    Duration? defaultTtl,
    bool? autoMarkAsRead,
    int? maxNotificationsPerType,
    bool? enableEmail,
    bool? enablePush,
    String? pushProvider,
    String? pushApiKey,
    String? pushProjectId,
  }) {
    return NotificationConfig(
      enablePersistence: enablePersistence ?? this.enablePersistence,
      maxHistorySize: maxHistorySize ?? this.maxHistorySize,
      enableSound: enableSound ?? this.enableSound,
      enableVibration: enableVibration ?? this.enableVibration,
      enableBadge: enableBadge ?? this.enableBadge,
      defaultTtl: defaultTtl ?? this.defaultTtl,
      autoMarkAsRead: autoMarkAsRead ?? this.autoMarkAsRead,
      maxNotificationsPerType:
          maxNotificationsPerType ?? this.maxNotificationsPerType,
      enableEmail: enableEmail ?? this.enableEmail,
      enablePush: enablePush ?? this.enablePush,
      pushProvider: pushProvider ?? this.pushProvider,
      pushApiKey: pushApiKey ?? this.pushApiKey,
      pushProjectId: pushProjectId ?? this.pushProjectId,
    );
  }

  @override
  List<Object?> get props => [
    enablePersistence,
    maxHistorySize,
    enableSound,
    enableVibration,
    enableBadge,
    defaultTtl,
    autoMarkAsRead,
    maxNotificationsPerType,
    enableEmail,
    enablePush,
    pushProvider,
    pushApiKey,
    pushProjectId,
  ];

  @override
  String toString() {
    return 'NotificationConfig('
        'enablePersistence: $enablePersistence, '
        'maxHistorySize: $maxHistorySize, '
        'enableSound: $enableSound, '
        'enableVibration: $enableVibration, '
        'enableBadge: $enableBadge, '
        'defaultTtl: $defaultTtl, '
        'autoMarkAsRead: $autoMarkAsRead, '
        'maxNotificationsPerType: $maxNotificationsPerType, '
        'enableEmail: $enableEmail, '
        'enablePush: $enablePush, '
        'pushProvider: $pushProvider, '
        'pushApiKey: $pushApiKey, '
        'pushProjectId: $pushProjectId'
        ')';
  }
}
