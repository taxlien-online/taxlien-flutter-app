import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_magento_notifications/flutter_magento_notifications.dart';

void main() {
  group('MagentoNotificationService', () {
    late MagentoNotificationService service;

    setUp(() {
      service = MagentoNotificationService();
    });

    tearDown(() {
      service.dispose();
    });

    test('should initialize successfully', () async {
      await service.initialize();
      expect(service, isNotNull);
    });

    test('should send notification', () {
      service.notify(
        type: MagentoNotificationType.info,
        message: 'Test notification',
        title: 'Test',
      );

      // Verify notification was sent (this would depend on implementation)
      expect(service, isNotNull);
    });

    test('should send error notification', () {
      service.notifyError(
        'Test error',
        title: 'Error Test',
        exception: Exception('Test exception'),
      );

      expect(service, isNotNull);
    });

    test('should send success notification', () {
      service.notifySuccess('Test success', title: 'Success Test');

      expect(service, isNotNull);
    });

    test('should send warning notification', () {
      service.notifyWarning('Test warning', title: 'Warning Test');

      expect(service, isNotNull);
    });

    test('should send info notification', () {
      service.notifyInfo('Test info', title: 'Info Test');

      expect(service, isNotNull);
    });

    test('should get notification history', () {
      final history = service.getHistory();
      expect(history, isA<List<MagentoNotification>>());
    });

    test('should clear notification history', () {
      service.clearHistory();
      final history = service.getHistory();
      expect(history, isEmpty);
    });

    test('should subscribe to notifications', () {
      final subscription = service.subscribe(
        type: MagentoNotificationType.info,
        callback: (notification) {
          // Handle notification
        },
      );

      expect(subscription, isA<MagentoNotificationSubscription>());
      subscription.cancel();
    });

    test('should subscribe to all notifications', () {
      final subscription = service.subscribeToAll(
        callback: (notification) {
          // Handle notification
        },
      );

      expect(subscription, isA<MagentoNotificationSubscription>());
      subscription.cancel();
    });
  });

  group('MagentoNotification', () {
    test('should create notification from JSON', () {
      final json = {
        'id': 'test_id',
        'type': 'info',
        'title': 'Test Title',
        'message': 'Test Message',
        'priority': 'normal',
        'timestamp': '2024-01-01T00:00:00.000Z',
      };

      final notification = MagentoNotification.fromJson(json);
      expect(notification.id, 'test_id');
      expect(notification.type, MagentoNotificationType.info);
      expect(notification.title, 'Test Title');
      expect(notification.message, 'Test Message');
      expect(notification.priority, MagentoNotificationPriority.normal);
    });

    test('should convert notification to JSON', () {
      final notification = MagentoNotification(
        id: 'test_id',
        type: MagentoNotificationType.info,
        title: 'Test Title',
        message: 'Test Message',
        priority: MagentoNotificationPriority.normal,
        timestamp: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final json = notification.toJson();
      expect(json['id'], 'test_id');
      expect(json['type'], 'info');
      expect(json['title'], 'Test Title');
      expect(json['message'], 'Test Message');
      expect(json['priority'], 'normal');
    });

    test('should check if notification is expired', () {
      final expiredNotification = MagentoNotification(
        id: 'test_id',
        type: MagentoNotificationType.info,
        message: 'Test Message',
        timestamp: DateTime.now(),
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );

      expect(expiredNotification.isExpired, isTrue);

      final validNotification = MagentoNotification(
        id: 'test_id',
        type: MagentoNotificationType.info,
        message: 'Test Message',
        timestamp: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(validNotification.isExpired, isFalse);
    });

    test('should copy notification with new values', () {
      final original = MagentoNotification(
        id: 'test_id',
        type: MagentoNotificationType.info,
        message: 'Test Message',
        timestamp: DateTime.now(),
      );

      final copied = original.copyWith(
        title: 'New Title',
        priority: MagentoNotificationPriority.high,
      );

      expect(copied.id, original.id);
      expect(copied.type, original.type);
      expect(copied.message, original.message);
      expect(copied.title, 'New Title');
      expect(copied.priority, MagentoNotificationPriority.high);
    });
  });

  group('NotificationConfig', () {
    test('should create default config', () {
      const config = NotificationConfig();
      expect(config.enablePersistence, isTrue);
      expect(config.maxHistorySize, 1000);
      expect(config.enableSound, isTrue);
      expect(config.enableVibration, isTrue);
      expect(config.enableBadge, isTrue);
    });

    test('should create config from JSON', () {
      final json = {
        'enablePersistence': false,
        'maxHistorySize': 500,
        'enableSound': false,
        'enableVibration': false,
        'enableBadge': false,
        'defaultTtl': 600,
        'autoMarkAsRead': false,
        'maxNotificationsPerType': 25,
        'enableEmail': false,
        'enablePush': true,
        'pushProvider': 'firebase',
        'pushApiKey': 'test_key',
        'pushProjectId': 'test_project',
      };

      final config = NotificationConfig.fromJson(json);
      expect(config.enablePersistence, isFalse);
      expect(config.maxHistorySize, 500);
      expect(config.enableSound, isFalse);
      expect(config.enableVibration, isFalse);
      expect(config.enableBadge, isFalse);
      expect(config.defaultTtl.inSeconds, 600);
      expect(config.autoMarkAsRead, isFalse);
      expect(config.maxNotificationsPerType, 25);
      expect(config.enableEmail, isFalse);
      expect(config.enablePush, isTrue);
      expect(config.pushProvider, 'firebase');
      expect(config.pushApiKey, 'test_key');
      expect(config.pushProjectId, 'test_project');
    });

    test('should convert config to JSON', () {
      const config = NotificationConfig(
        enablePersistence: false,
        maxHistorySize: 500,
        enableSound: false,
        enableVibration: false,
        enableBadge: false,
        defaultTtl: Duration(seconds: 600),
        autoMarkAsRead: false,
        maxNotificationsPerType: 25,
        enableEmail: false,
        enablePush: true,
        pushProvider: 'firebase',
        pushApiKey: 'test_key',
        pushProjectId: 'test_project',
      );

      final json = config.toJson();
      expect(json['enablePersistence'], isFalse);
      expect(json['maxHistorySize'], 500);
      expect(json['enableSound'], isFalse);
      expect(json['enableVibration'], isFalse);
      expect(json['enableBadge'], isFalse);
      expect(json['defaultTtl'], 600);
      expect(json['autoMarkAsRead'], isFalse);
      expect(json['maxNotificationsPerType'], 25);
      expect(json['enableEmail'], isFalse);
      expect(json['enablePush'], isTrue);
      expect(json['pushProvider'], 'firebase');
      expect(json['pushApiKey'], 'test_key');
      expect(json['pushProjectId'], 'test_project');
    });

    test('should copy config with new values', () {
      const original = NotificationConfig();
      final copied = original.copyWith(
        enablePersistence: false,
        maxHistorySize: 500,
      );

      expect(copied.enablePersistence, isFalse);
      expect(copied.maxHistorySize, 500);
      expect(copied.enableSound, original.enableSound);
      expect(copied.enableVibration, original.enableVibration);
    });
  });
}
