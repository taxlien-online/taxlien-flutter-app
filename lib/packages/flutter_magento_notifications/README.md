# Flutter Magento Notifications

[![Latest Stable Version](https://pub.dev/packages/flutter_magento_notifications/badge)](https://pub.dev/packages/flutter_magento_notifications)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Total Downloads](https://img.shields.io/pub/total_downloads/flutter_magento_notifications.svg)](https://pub.dev/packages/flutter_magento_notifications)

A comprehensive Flutter library for Magento 2 notifications with universal notification system. This library provides a complete solution for handling notifications in Flutter applications integrated with Magento e-commerce platforms.

## 🚀 Features

### 📢 **Universal Notification System**
- **Multi-Type Notifications** - Support for error, warning, info, success, sync, cloud, network, auth, and cache notifications
- **Priority Levels** - Low, normal, high, and critical priority levels
- **Real-time Updates** - Live notification streaming
- **Persistence** - Optional notification history storage
- **Expiration** - Automatic notification expiration

### 🎯 **Notification Management**
- **Send Notifications** - Programmatic notification sending
- **Subscribe/Unsubscribe** - Event-driven notification handling
- **Mark as Read** - Individual and bulk read status management
- **Notification History** - Complete notification tracking
- **Statistics** - Comprehensive notification analytics

### 🎨 **UI Components**
- **Notification Listener** - Automatic snackbar display
- **Notification Badge** - Unread count display
- **Notification List** - Customizable notification list
- **Notification Widgets** - Ready-to-use UI components

### 🔧 **Integration Ready**
- **Magento Integration** - Built for Magento 2 compatibility
- **Event System** - Flutter event integration
- **Customizable** - Highly customizable appearance and behavior
- **Performance** - Optimized for mobile performance

## 📋 Requirements

- **Flutter**: >=3.24.0
- **Dart**: >=3.8.0
- **Magento**: 2.4.x (for backend integration)

## 🛠️ Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_magento_notifications: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🔧 Setup

### 1. Initialize the Notification Service

```dart
import 'package:flutter_magento_notifications/flutter_magento_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationApp(),
    );
  }
}

class NotificationApp extends StatefulWidget {
  @override
  _NotificationAppState createState() => _NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {
  late MagentoNotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    _notificationService = MagentoNotificationService(
      enablePersistence: true,
      maxHistorySize: 1000,
    );
    
    await _notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MagentoNotificationListener(
      notificationService: _notificationService,
      child: Scaffold(
        appBar: AppBar(title: Text('Notifications')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _sendTestNotification(),
                child: Text('Send Test Notification'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showNotificationHistory(),
                child: Text('Show History'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendTestNotification() {
    _notificationService.notifySuccess(
      'Test notification sent successfully!',
      title: 'Success',
    );
  }

  void _showNotificationHistory() {
    final history = _notificationService.getHistory(limit: 10);
    // Show history in a dialog or navigate to history page
  }
}
```

### 2. Configure Providers (Optional)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider for the notification service
final notificationServiceProvider = Provider<MagentoNotificationService>((ref) {
  return MagentoNotificationService(
    enablePersistence: true,
    maxHistorySize: 1000,
  );
});

// Use in your widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = ref.watch(notificationServiceProvider);
    
    return MagentoNotificationListener(
      notificationService: notificationService,
      child: YourContent(),
    );
  }
}
```

## 📚 Usage

### Sending Notifications

```dart
// Basic notification
notificationService.notify(
  type: MagentoNotificationType.info,
  message: 'This is an info notification',
  title: 'Information',
);

// Success notification
notificationService.notifySuccess(
  'Operation completed successfully!',
  title: 'Success',
);

// Error notification
notificationService.notifyError(
  'Something went wrong!',
  title: 'Error',
  exception: Exception('Detailed error message'),
);

// Warning notification
notificationService.notifyWarning(
  'Please check your input',
  title: 'Warning',
);

// Sync notification with progress
notificationService.notifySync(
  message: 'Synchronizing data...',
  state: MagentoSyncNotificationState.progress,
  progress: 0.75,
);
```

### Subscribing to Notifications

```dart
// Subscribe to specific notification type
final subscription = notificationService.subscribe(
  MagentoNotificationType.error,
  callback: (notification) {
    print('Error notification: ${notification.message}');
    // Handle error notification
  },
  minPriority: MagentoNotificationPriority.high,
);

// Subscribe to all notifications
final allSubscription = notificationService.subscribeToAll(
  callback: (notification) {
    print('Notification: ${notification.title} - ${notification.message}');
  },
  filter: (notification) => !notification.isExpired,
);

// Don't forget to unsubscribe
@override
void dispose() {
  subscription.cancel();
  allSubscription.cancel();
  super.dispose();
}
```

### Notification History

```dart
// Get notification history
final history = notificationService.getHistory(
  type: MagentoNotificationType.error,
  limit: 20,
  includeExpired: false,
);

// Get unread count
final unreadCount = notificationService.getUnreadCount(
  type: MagentoNotificationType.info,
);

// Mark notification as read
notificationService.markAsRead(notificationId);

// Mark all notifications as read
notificationService.markAllAsRead(type: MagentoNotificationType.info);

// Clear history
notificationService.clearHistory(type: MagentoNotificationType.info);
```

### Statistics

```dart
// Get notification statistics
final stats = notificationService.getStats();

print('Total notifications: ${stats.totalNotifications}');
print('Unread notifications: ${stats.unreadNotifications}');
print('Notifications today: ${stats.notificationsToday}');
print('Notifications this week: ${stats.notificationsThisWeek}');
print('Notifications this month: ${stats.notificationsThisMonth}');
```

## 🎨 UI Components

### Notification Badge

```dart
NotificationBadge(
  count: unreadCount,
  child: IconButton(
    icon: Icon(Icons.notifications),
    onPressed: () => _showNotifications(),
  ),
)
```

### Notification List

```dart
ListView.builder(
  itemCount: notifications.length,
  itemBuilder: (context, index) {
    final notification = notifications[index];
    return NotificationListTile(
      notification: notification,
      onTap: () => _handleNotificationTap(notification),
      onDismiss: () => _dismissNotification(notification),
    );
  },
)
```

### Custom Notification Listener

```dart
MagentoNotificationListener(
  notificationService: notificationService,
  minPriority: MagentoNotificationPriority.normal,
  showAllTypes: false,
  customBuilder: (context, notification) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        notification.message,
        style: TextStyle(color: Colors.white),
      ),
    );
  },
  child: YourApp(),
)
```

## 🔧 Configuration

### NotificationConfig

```dart
final config = NotificationConfig(
  enablePersistence: true,
  maxHistorySize: 1000,
  enableSound: true,
  enableVibration: true,
  enableBadge: true,
  defaultTtl: Duration(minutes: 5),
  autoMarkAsRead: true,
  maxNotificationsPerType: 50,
);
```

## 🧪 Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_magento_notifications/flutter_magento_notifications.dart';

void main() {
  group('MagentoNotificationService', () {
    late MagentoNotificationService service;

    setUp(() {
      service = MagentoNotificationService(
        enablePersistence: false, // Disable for testing
      );
    });

    test('should send notification', () {
      service.notify(
        type: MagentoNotificationType.info,
        message: 'Test message',
      );

      final history = service.getHistory();
      expect(history.length, 1);
      expect(history.first.message, 'Test message');
    });

    test('should handle subscriptions', () {
      bool callbackCalled = false;
      
      final subscription = service.subscribe(
        MagentoNotificationType.error,
        callback: (notification) {
          callbackCalled = true;
        },
      );

      service.notifyError('Test error');
      expect(callbackCalled, true);

      subscription.cancel();
    });
  });
}
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

- **Documentation**: [https://docs.nativemind.net](https://docs.nativemind.net)
- **Issues**: [GitHub Issues](https://github.com/nativemind/flutter_magento_notifications/issues)
- **Email**: support@nativemind.net

## 🔗 Related Packages

- [flutter_magento](https://pub.dev/packages/flutter_magento) - Core Magento integration
- [flutter_magento_messenger](https://pub.dev/packages/flutter_magento_messenger) - Messaging functionality
- [flutter_magento_marketplace](https://pub.dev/packages/flutter_magento_marketplace) - Marketplace features


