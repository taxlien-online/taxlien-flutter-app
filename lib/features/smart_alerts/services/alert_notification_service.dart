import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/alert_match.dart';
import '../models/property_alert.dart';
import '../constants/alert_constants.dart';

/// Alert Notification Service
///
/// Handles push notifications for alert matches
class AlertNotificationService {
  static final AlertNotificationService _instance =
      AlertNotificationService._internal();
  factory AlertNotificationService() => _instance;
  AlertNotificationService._internal();

  static AlertNotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    _isInitialized = true;
    debugPrint('Alert notification service initialized');
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    // Request Android permissions (API 33+)
    bool androidGranted = true;
    if (androidPlugin != null) {
      androidGranted = await androidPlugin.requestNotificationsPermission() ?? false;
    }

    // Request iOS permissions
    bool iosGranted = true;
    if (iosPlugin != null) {
      iosGranted = await iosPlugin.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return androidGranted && iosGranted;
  }

  /// Send notification for alert match
  Future<void> sendMatchNotification({
    required AlertMatch match,
    PropertyAlert? alert,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Determine notification priority based on match score
      final priority = _getNotificationPriority(match.matchScore);
      final channelId = _getChannelId(priority);

      // Build notification
      final title = _getNotificationTitle(match.matchScore);
      final body = _getNotificationBody(match);

      // Android notification details
      final androidDetails = AndroidNotificationDetails(
        channelId,
        _getChannelName(channelId),
        channelDescription: _getChannelDescription(channelId),
        importance: priority == 'high'
            ? Importance.high
            : priority == 'medium'
                ? Importance.defaultImportance
                : Importance.low,
        priority: priority == 'high'
            ? Priority.high
            : priority == 'medium'
                ? Priority.defaultPriority
                : Priority.low,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(
          body,
          contentTitle: title,
        ),
      );

      // iOS notification details
      final iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: priority == 'high'
            ? InterruptionLevel.timeSensitive
            : InterruptionLevel.active,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      // Show notification
      await _notifications.show(
        match.id.hashCode,
        title,
        body,
        details,
        payload: '${match.alertId}|${match.propertyId}',
      );

      debugPrint('Sent notification for match: ${match.id}');
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  /// Send batch notification (digest)
  Future<void> sendDigestNotification({
    required List<AlertMatch> matches,
    required String frequency,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (matches.isEmpty) return;

    try {
      final title = 'Alert Digest - ${matches.length} New Matches';
      final body = matches.length == 1
          ? 'You have 1 new property match'
          : 'You have ${matches.length} new property matches waiting for you';

      final androidDetails = AndroidNotificationDetails(
        AlertConstants.channelMediumPriority,
        'Alert Digest',
        channelDescription: 'Periodic digest of matching properties',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        styleInformation: InboxStyleInformation(
          matches.take(5).map((m) {
            return '${m.property.propertyAddress} - ${m.matchScore}%';
          }).toList(),
          contentTitle: title,
          summaryText: '+${matches.length} matches',
        ),
      );

      final iOSDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      await _notifications.show(
        'digest_${DateTime.now().millisecondsSinceEpoch}'.hashCode,
        title,
        body,
        details,
      );

      debugPrint('Sent digest notification for ${matches.length} matches');
    } catch (e) {
      debugPrint('Error sending digest notification: $e');
    }
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get notification priority based on match score
  String _getNotificationPriority(int matchScore) {
    if (matchScore >= AlertConstants.criticalMatchScore) {
      return 'high';
    } else if (matchScore >= AlertConstants.highPriorityMatchScore) {
      return 'medium';
    } else {
      return 'low';
    }
  }

  /// Get channel ID based on priority
  String _getChannelId(String priority) {
    switch (priority) {
      case 'high':
        return AlertConstants.channelHighPriority;
      case 'medium':
        return AlertConstants.channelMediumPriority;
      case 'low':
        return AlertConstants.channelLowPriority;
      default:
        return AlertConstants.channelMediumPriority;
    }
  }

  /// Get channel name
  String _getChannelName(String channelId) {
    switch (channelId) {
      case AlertConstants.channelHighPriority:
        return 'High Priority Alerts';
      case AlertConstants.channelMediumPriority:
        return 'Medium Priority Alerts';
      case AlertConstants.channelLowPriority:
        return 'Low Priority Alerts';
      default:
        return 'Alerts';
    }
  }

  /// Get channel description
  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case AlertConstants.channelHighPriority:
        return 'Critical property matches that require immediate attention';
      case AlertConstants.channelMediumPriority:
        return 'Important property matches';
      case AlertConstants.channelLowPriority:
        return 'Potential property matches';
      default:
        return 'Property alert notifications';
    }
  }

  /// Get notification title based on match score
  String _getNotificationTitle(int matchScore) {
    if (matchScore >= AlertConstants.criticalMatchScore) {
      return AlertConstants.notificationTitleHighPriority;
    } else if (matchScore >= AlertConstants.highPriorityMatchScore) {
      return AlertConstants.notificationTitleMediumPriority;
    } else {
      return AlertConstants.notificationTitleLowPriority;
    }
  }

  /// Get notification body
  String _getNotificationBody(AlertMatch match) {
    return AlertConstants.notificationBodyTemplate
        .replaceAll('{propertyAddress}', match.property.propertyAddress)
        .replaceAll('{matchScore}', match.matchScore.toString());
  }

  /// Handle notification tap
  void _handleNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      final parts = response.payload!.split('|');
      if (parts.length == 2) {
        final alertId = parts[0];
        final propertyId = parts[1];

        // TODO: Navigate to property detail
        debugPrint('Notification tapped: alert=$alertId, property=$propertyId');
      }
    }
  }

  /// Schedule notification for later
  Future<void> scheduleNotification({
    required AlertMatch match,
    required DateTime scheduledTime,
  }) async {
    // TODO: Implement scheduled notifications using timezone package
    debugPrint('Scheduled notification for ${scheduledTime.toIso8601String()}');
  }

  /// Get pending notifications count
  Future<int> getPendingNotificationsCount() async {
    final pending = await _notifications.pendingNotificationRequests();
    return pending.length;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.areNotificationsEnabled() ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final settings = await iosPlugin?.checkPermissions();
      return settings?.isEnabled ?? false;
    }
    return false;
  }
}
