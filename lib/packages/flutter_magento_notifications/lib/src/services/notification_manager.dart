import 'dart:async';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';
import '../api/notification_api.dart';
import '../models/notification_models.dart';
import '../models/notification_types.dart';

/// High-level notification manager that combines local service with API
class NotificationManager extends ChangeNotifier {
  final MagentoNotificationService _localService;
  final NotificationApi _api;
  final bool _enableSync;

  NotificationManager({
    required MagentoNotificationService localService,
    required NotificationApi api,
    bool enableSync = true,
  }) : _localService = localService,
       _api = api,
       _enableSync = enableSync;

  /// Initialize the notification manager
  Future<void> initialize() async {
    await _localService.initialize();

    if (_enableSync) {
      await _syncWithServer();
    }
  }

  /// Send notification (local + server)
  Future<void> sendNotification({
    required int userId,
    required MagentoNotificationType type,
    required String title,
    required String message,
    MagentoNotificationPriority priority = MagentoNotificationPriority.normal,
    Map<String, dynamic>? data,
    Duration? ttl,
    bool syncToServer = true,
  }) async {
    // Send locally first
    _localService.notify(
      type: type,
      title: title,
      message: message,
      priority: priority,
      data: data,
      ttl: ttl,
    );

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        await _api.sendNotification(
          userId: userId,
          type: type.name,
          title: title,
          message: message,
          data: data,
          priority: priority.name,
          ttl: ttl?.inSeconds,
        );
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync notification to server: $e');
        }
      }
    }
  }

  /// Send error notification
  Future<void> sendErrorNotification({
    required int userId,
    required String message,
    String? title,
    Map<String, dynamic>? context,
    Exception? exception,
    bool syncToServer = true,
  }) async {
    final data = <String, dynamic>{
      if (context != null) ...context,
      if (exception != null) 'exception': exception.toString(),
    };

    await sendNotification(
      userId: userId,
      type: MagentoNotificationType.error,
      title: title ?? 'Error',
      message: message,
      priority: MagentoNotificationPriority.high,
      data: data.isNotEmpty ? data : null,
      syncToServer: syncToServer,
    );
  }

  /// Send success notification
  Future<void> sendSuccessNotification({
    required int userId,
    required String message,
    String? title,
    Map<String, dynamic>? context,
    bool syncToServer = true,
  }) async {
    await sendNotification(
      userId: userId,
      type: MagentoNotificationType.success,
      title: title ?? 'Success',
      message: message,
      priority: MagentoNotificationPriority.normal,
      data: context,
      syncToServer: syncToServer,
    );
  }

  /// Send warning notification
  Future<void> sendWarningNotification({
    required int userId,
    required String message,
    String? title,
    Map<String, dynamic>? context,
    bool syncToServer = true,
  }) async {
    await sendNotification(
      userId: userId,
      type: MagentoNotificationType.warning,
      title: title ?? 'Warning',
      message: message,
      priority: MagentoNotificationPriority.normal,
      data: context,
      syncToServer: syncToServer,
    );
  }

  /// Send info notification
  Future<void> sendInfoNotification({
    required int userId,
    required String message,
    String? title,
    Map<String, dynamic>? context,
    bool syncToServer = true,
  }) async {
    await sendNotification(
      userId: userId,
      type: MagentoNotificationType.info,
      title: title ?? 'Information',
      message: message,
      priority: MagentoNotificationPriority.low,
      data: context,
      syncToServer: syncToServer,
    );
  }

  /// Get notifications (local + server)
  Future<List<MagentoNotification>> getNotifications({
    required int userId,
    MagentoNotificationType? type,
    int? limit,
    int? offset,
    bool includeExpired = false,
    bool syncFromServer = true,
  }) async {
    // Get local notifications
    final localNotifications = _localService.getHistory(
      type: type,
      limit: limit,
      includeExpired: includeExpired,
    );

    // Sync from server if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverNotifications = await _api.getUserNotifications(
          userId: userId,
          limit: limit,
          offset: offset,
          type: type?.name,
          isRead: null,
        );

        // Merge and deduplicate notifications
        final allNotifications = <MagentoNotification>[];
        final seenIds = <String>{};

        // Add server notifications first (they are more up-to-date)
        for (final notification in serverNotifications) {
          if (!seenIds.contains(notification.id)) {
            allNotifications.add(notification);
            seenIds.add(notification.id);
          }
        }

        // Add local notifications that aren't already included
        for (final notification in localNotifications) {
          if (!seenIds.contains(notification.id)) {
            allNotifications.add(notification);
            seenIds.add(notification.id);
          }
        }

        // Sort by timestamp (newest first)
        allNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return allNotifications;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync notifications from server: $e');
        }
      }
    }

    return localNotifications;
  }

  /// Mark notification as read (local + server)
  Future<void> markAsRead({
    required String notificationId,
    required int userId,
    bool syncToServer = true,
  }) async {
    // Mark locally
    _localService.markAsRead(notificationId);

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        // Extract numeric ID from notification ID if needed
        final numericId = int.tryParse(notificationId.split('_').last) ?? 0;
        if (numericId > 0) {
          await _api.markAsRead(numericId);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync mark as read to server: $e');
        }
      }
    }
  }

  /// Mark all notifications as read (local + server)
  Future<void> markAllAsRead({
    required int userId,
    MagentoNotificationType? type,
    bool syncToServer = true,
  }) async {
    // Mark locally
    _localService.markAllAsRead(type: type);

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        await _api.markAllAsRead(userId, type: type?.name);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync mark all as read to server: $e');
        }
      }
    }
  }

  /// Get unread count (local + server)
  Future<int> getUnreadCount({
    required int userId,
    MagentoNotificationType? type,
    bool syncFromServer = true,
  }) async {
    // Get local count
    final localCount = _localService.getUnreadCount(type: type);

    // Get server count if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverCount = await _api.getUnreadCount(userId, type: type?.name);
        return serverCount;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to get unread count from server: $e');
        }
      }
    }

    return localCount;
  }

  /// Get notification statistics (local + server)
  Future<NotificationStats> getStats({
    required int userId,
    bool syncFromServer = true,
  }) async {
    // Get local stats
    final localStats = _localService.getStats();

    // Get server stats if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverStats = await _api.getStats(userId);
        return serverStats;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to get stats from server: $e');
        }
      }
    }

    return localStats;
  }

  /// Search notifications (local + server)
  Future<List<MagentoNotification>> searchNotifications({
    required int userId,
    required String query,
    int? limit,
    int? offset,
    bool syncFromServer = true,
  }) async {
    // Search locally
    final localResults = _localService
        .getHistory(limit: limit, includeExpired: false)
        .where(
          (notification) =>
              notification.message.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              (notification.title?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();

    // Search server if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverResults = await _api.searchNotifications(
          userId: userId,
          query: query,
          limit: limit,
          offset: offset,
        );

        // Merge results
        final allResults = <MagentoNotification>[];
        final seenIds = <String>{};

        // Add server results first
        for (final notification in serverResults) {
          if (!seenIds.contains(notification.id)) {
            allResults.add(notification);
            seenIds.add(notification.id);
          }
        }

        // Add local results that aren't already included
        for (final notification in localResults) {
          if (!seenIds.contains(notification.id)) {
            allResults.add(notification);
            seenIds.add(notification.id);
          }
        }

        // Sort by timestamp (newest first)
        allResults.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return allResults;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to search notifications on server: $e');
        }
      }
    }

    return localResults;
  }

  /// Clear expired notifications (local + server)
  Future<void> clearExpired({
    required int userId,
    bool syncToServer = true,
  }) async {
    // Clear locally
    _localService.clearExpired();

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        await _api.clearExpired(userId);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to clear expired notifications on server: $e');
        }
      }
    }
  }

  /// Sync with server
  Future<void> _syncWithServer() async {
    // This would typically sync local notifications with server
    // Implementation depends on specific requirements
  }

  /// Get local service for direct access
  MagentoNotificationService get localService => _localService;

  /// Get API for direct access
  NotificationApi get api => _api;

  @override
  void dispose() {
    _localService.dispose();
    super.dispose();
  }
}
