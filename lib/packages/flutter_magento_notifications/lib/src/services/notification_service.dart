import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_models.dart';
import '../models/notification_types.dart';

/// Universal notification service for Magento events
/// Provides centralized event broadcasting and subscription management
class MagentoNotificationService extends ChangeNotifier {
  MagentoNotificationService({
    this.enablePersistence = true,
    this.maxHistorySize = 1000,
  });

  final bool enablePersistence;
  final int maxHistorySize;

  // Private fields
  SharedPreferences? _prefs;
  final Map<MagentoNotificationType, StreamController<MagentoNotification>>
      _controllers = {};
  final List<MagentoNotification> _notificationHistory = [];
  final Map<String, MagentoNotificationSubscription> _subscriptions = {};
  int _notificationIdCounter = 0;

  /// Get stream for specific notification type
  Stream<MagentoNotification> getStream(MagentoNotificationType type) {
    _controllers[type] ??= StreamController<MagentoNotification>.broadcast();
    return _controllers[type]!.stream;
  }

  /// Get stream for all notifications
  Stream<MagentoNotification> get allNotifications {
    final controller = StreamController<MagentoNotification>.broadcast();

    for (final type in MagentoNotificationType.values) {
      getStream(type).listen((notification) {
        controller.add(notification);
      });
    }

    return controller.stream;
  }

  /// Initialize the notification service
  Future<void> initialize() async {
    if (enablePersistence) {
      _prefs ??= await SharedPreferences.getInstance();
      await _loadNotificationHistory();
    }
  }

  /// Send a notification
  void notify({
    required MagentoNotificationType type,
    required String message,
    String? title,
    MagentoNotificationPriority priority = MagentoNotificationPriority.normal,
    Map<String, dynamic>? data,
    Duration? ttl,
  }) {
    final notification = MagentoNotification(
      id: _generateNotificationId(),
      type: type,
      title: title,
      message: message,
      priority: priority,
      data: data,
      timestamp: DateTime.now(),
      expiresAt: ttl != null ? DateTime.now().add(ttl) : null,
    );

    _sendNotification(notification);
  }

  /// Send an error notification
  void notifyError(
    String message, {
    String? title,
    Map<String, dynamic>? context,
    Exception? exception,
  }) {
    final data = <String, dynamic>{
      if (context != null) ...context,
      if (exception != null) 'exception': exception.toString(),
    };

    notify(
      type: MagentoNotificationType.error,
      title: title ?? 'Error',
      message: message,
      priority: MagentoNotificationPriority.high,
      data: data.isNotEmpty ? data : null,
    );
  }

  /// Send a warning notification
  void notifyWarning(
    String message, {
    String? title,
    Map<String, dynamic>? context,
  }) {
    notify(
      type: MagentoNotificationType.warning,
      title: title ?? 'Warning',
      message: message,
      priority: MagentoNotificationPriority.normal,
      data: context,
    );
  }

  /// Send an info notification
  void notifyInfo(
    String message, {
    String? title,
    Map<String, dynamic>? context,
  }) {
    notify(
      type: MagentoNotificationType.info,
      title: title ?? 'Information',
      message: message,
      priority: MagentoNotificationPriority.low,
      data: context,
    );
  }

  /// Send a success notification
  void notifySuccess(
    String message, {
    String? title,
    Map<String, dynamic>? context,
  }) {
    notify(
      type: MagentoNotificationType.success,
      title: title ?? 'Success',
      message: message,
      priority: MagentoNotificationPriority.normal,
      data: context,
    );
  }

  /// Send a sync notification
  void notifySync({
    required String message,
    String? title,
    MagentoSyncNotificationState? state,
    double? progress,
    Map<String, dynamic>? context,
  }) {
    final data = <String, dynamic>{
      if (state != null) 'state': state.name,
      if (progress != null) 'progress': progress,
      if (context != null) ...context,
    };

    notify(
      type: MagentoNotificationType.sync,
      title: title ?? 'Synchronization',
      message: message,
      priority: MagentoNotificationPriority.normal,
      data: data.isNotEmpty ? data : null,
    );
  }

  /// Send a cloud feature notification
  void notifyCloudFeature({
    required String message,
    String? title,
    MagentoCloudNotificationState? state,
    Map<String, dynamic>? context,
  }) {
    final data = <String, dynamic>{
      if (state != null) 'state': state.name,
      if (context != null) ...context,
    };

    notify(
      type: MagentoNotificationType.cloudFeature,
      title: title ?? 'Cloud Feature',
      message: message,
      priority: MagentoNotificationPriority.normal,
      data: data.isNotEmpty ? data : null,
    );
  }

  /// Send a network notification
  void notifyNetwork(
    String message, {
    String? title,
    Map<String, dynamic>? context,
  }) {
    notify(
      type: MagentoNotificationType.network,
      title: title ?? 'Network',
      message: message,
      priority: MagentoNotificationPriority.high,
      data: context,
    );
  }

  /// Send an authentication notification
  void notifyAuth(
    String message, {
    String? title,
    Map<String, dynamic>? context,
  }) {
    notify(
      type: MagentoNotificationType.auth,
      title: title ?? 'Authentication',
      message: message,
      priority: MagentoNotificationPriority.high,
      data: context,
    );
  }

  /// Send a cache notification
  void notifyCache(
    String message, {
    String? title,
    Map<String, dynamic>? context,
  }) {
    notify(
      type: MagentoNotificationType.cache,
      title: title ?? 'Cache',
      message: message,
      priority: MagentoNotificationPriority.low,
      data: context,
    );
  }

  /// Subscribe to notifications of a specific type
  MagentoNotificationSubscription subscribe(
    MagentoNotificationType type, {
    required void Function(MagentoNotification) callback,
    MagentoNotificationPriority? minPriority,
    bool Function(MagentoNotification)? filter,
  }) {
    final subscriptionId = _generateSubscriptionId();

    final subscription = MagentoNotificationSubscription(
      id: subscriptionId,
      type: type,
      callback: callback,
      minPriority: minPriority,
      filter: filter,
    );

    _subscriptions[subscriptionId] = subscription;

    // Set up stream listener
    final streamSubscription = getStream(type).listen((notification) {
      if (_shouldDeliverNotification(notification, subscription)) {
        try {
          callback(notification);
        } catch (e) {
          if (kDebugMode) {
            print('Error in notification callback: $e');
          }
        }
      }
    });

    subscription._streamSubscription = streamSubscription;
    return subscription;
  }

  /// Subscribe to all notifications
  MagentoNotificationSubscription subscribeToAll({
    required void Function(MagentoNotification) callback,
    MagentoNotificationPriority? minPriority,
    bool Function(MagentoNotification)? filter,
  }) {
    final subscriptionId = _generateSubscriptionId();

    final subscription = MagentoNotificationSubscription(
      id: subscriptionId,
      type: null, // null means all types
      callback: callback,
      minPriority: minPriority,
      filter: filter,
    );

    _subscriptions[subscriptionId] = subscription;

    // Set up stream listener for all notifications
    final streamSubscription = allNotifications.listen((notification) {
      if (_shouldDeliverNotification(notification, subscription)) {
        try {
          callback(notification);
        } catch (e) {
          if (kDebugMode) {
            print('Error in notification callback: $e');
          }
        }
      }
    });

    subscription._streamSubscription = streamSubscription;
    return subscription;
  }

  /// Unsubscribe from notifications
  void unsubscribe(MagentoNotificationSubscription subscription) {
    subscription._streamSubscription?.cancel();
    _subscriptions.remove(subscription.id);
  }

  /// Get notification history
  List<MagentoNotification> getHistory({
    MagentoNotificationType? type,
    MagentoNotificationPriority? minPriority,
    int? limit,
    bool includeExpired = false,
  }) {
    var filtered = _notificationHistory.where((notification) {
      if (type != null && notification.type != type) return false;
      if (minPriority != null &&
          notification.priority.value < minPriority.value) return false;
      if (!includeExpired && notification.isExpired) return false;
      return true;
    }).toList();

    // Sort by timestamp (newest first)
    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (limit != null && limit > 0) {
      filtered = filtered.take(limit).toList();
    }

    return filtered;
  }

  /// Get unread notification count
  int getUnreadCount({MagentoNotificationType? type}) {
    return _notificationHistory.where((notification) {
      if (!notification.isRead) return false;
      if (type != null && notification.type != type) return false;
      if (notification.isExpired) return false;
      return true;
    }).length;
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notificationHistory.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notificationHistory[index] = _notificationHistory[index].copyWith(
        isRead: true,
      );
      notifyListeners();
      _saveNotificationHistory();
    }
  }

  /// Mark all notifications as read
  void markAllAsRead({MagentoNotificationType? type}) {
    for (int i = 0; i < _notificationHistory.length; i++) {
      final notification = _notificationHistory[i];
      if (type == null || notification.type == type) {
        _notificationHistory[i] = notification.copyWith(isRead: true);
      }
    }
    notifyListeners();
    _saveNotificationHistory();
  }

  /// Clear notification history
  void clearHistory({MagentoNotificationType? type}) {
    if (type != null) {
      _notificationHistory.removeWhere((n) => n.type == type);
    } else {
      _notificationHistory.clear();
    }
    notifyListeners();
    _saveNotificationHistory();
  }

  /// Clear expired notifications
  void clearExpired() {
    _notificationHistory.removeWhere((n) => n.isExpired);
    notifyListeners();
    _saveNotificationHistory();
  }

  /// Get notification statistics
  NotificationStats getStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    return NotificationStats(
      totalNotifications: _notificationHistory.length,
      unreadNotifications: getUnreadCount(),
      notificationsToday: _notificationHistory
          .where((n) => n.timestamp.isAfter(today))
          .length,
      notificationsThisWeek: _notificationHistory
          .where((n) => n.timestamp.isAfter(weekStart))
          .length,
      notificationsThisMonth: _notificationHistory
          .where((n) => n.timestamp.isAfter(monthStart))
          .length,
    );
  }

  // Private methods

  void _sendNotification(MagentoNotification notification) {
    // Add to history
    _notificationHistory.insert(0, notification);

    // Limit history size
    if (_notificationHistory.length > maxHistorySize) {
      _notificationHistory.removeRange(
        maxHistorySize,
        _notificationHistory.length,
      );
    }

    // Broadcast to subscribers
    final controller = _controllers[notification.type];
    if (controller != null && !controller.isClosed) {
      controller.add(notification);
    }

    // Notify listeners
    notifyListeners();

    // Save to persistence
    if (enablePersistence) {
      _saveNotificationHistory();
    }
  }

  bool _shouldDeliverNotification(
    MagentoNotification notification,
    MagentoNotificationSubscription subscription,
  ) {
    // Check type (null means all types)
    if (subscription.type != null && notification.type != subscription.type) {
      return false;
    }

    // Check minimum priority
    if (subscription.minPriority != null &&
        notification.priority.value < subscription.minPriority!.value) {
      return false;
    }

    // Check custom filter
    if (subscription.filter != null && !subscription.filter!(notification)) {
      return false;
    }

    // Check if notification is expired
    if (notification.isExpired) {
      return false;
    }

    return true;
  }

  String _generateNotificationId() {
    return 'notification_${_notificationIdCounter++}_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateSubscriptionId() {
    return 'subscription_${DateTime.now().millisecondsSinceEpoch}_${_subscriptions.length}';
  }

  Future<void> _loadNotificationHistory() async {
    // In a real implementation, this would load from persistent storage
    // For now, we'll skip the actual persistence logic
  }

  Future<void> _saveNotificationHistory() async {
    // In a real implementation, this would save to persistent storage
    // For now, we'll skip the actual persistence logic
  }

  @override
  void dispose() {
    // Close all stream controllers
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();

    // Cancel all subscriptions
    for (final subscription in _subscriptions.values) {
      subscription._streamSubscription?.cancel();
    }
    _subscriptions.clear();

    super.dispose();
  }
}

/// Extension to add private stream subscription field
extension MagentoNotificationSubscriptionExtension on MagentoNotificationSubscription {
  static final Map<String, StreamSubscription?> _streamSubscriptions = {};

  StreamSubscription? get _streamSubscription => _streamSubscriptions[id];
  set _streamSubscription(StreamSubscription? subscription) {
    _streamSubscriptions[id] = subscription;
  }

  /// Cancel the subscription
  void cancel() {
    _streamSubscription?.cancel();
    _streamSubscriptions.remove(id);
  }
}


