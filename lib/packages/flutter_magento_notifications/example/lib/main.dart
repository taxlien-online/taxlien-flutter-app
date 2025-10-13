import 'package:flutter/material.dart';
import 'package:flutter_magento_notifications/flutter_magento_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Magento Notifications Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotificationExamplePage(),
    );
  }
}

class NotificationExamplePage extends StatefulWidget {
  const NotificationExamplePage({super.key});

  @override
  State<NotificationExamplePage> createState() =>
      _NotificationExamplePageState();
}

class _NotificationExamplePageState extends State<NotificationExamplePage> {
  late MagentoNotificationService _notificationService;
  late NotificationManager _notificationManager;
  late NotificationApi _api;

  List<MagentoNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    _notificationService = MagentoNotificationService();
    _api = NotificationApi(baseUrl: 'https://your-magento-store.com');
    _notificationManager = NotificationManager(
      localService: _notificationService,
      api: _api,
      enableSync: true,
    );

    await _notificationManager.initialize();
    await _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await _notificationManager.getNotifications(
        userId: 1, // Replace with actual user ID
        limit: 50,
      );

      final unreadCount = await _notificationManager.getUnreadCount(
        userId: 1, // Replace with actual user ID
      );

      setState(() {
        _notifications = notifications;
        _unreadCount = unreadCount;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notifications: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendTestNotification() async {
    try {
      await _notificationManager.sendNotification(
        userId: 1,
        type: MagentoNotificationType.info,
        title: 'Test Notification',
        message: 'This is a test notification sent at ${DateTime.now()}',
        priority: MagentoNotificationPriority.normal,
      );

      await _loadNotifications();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test notification sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending notification: $e')),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationManager.markAllAsRead(userId: 1);
      await _loadNotifications();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error marking as read: $e')));
      }
    }
  }

  Future<void> _clearAllNotifications() async {
    try {
      _notificationService.clearHistory();
      await _loadNotifications();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications cleared!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing notifications: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Magento Notifications Example'),
        actions: [
          NotificationIconBadge(
            count: _unreadCount,
            icon: Icons.notifications,
            onTap: () {
              // Handle notification tap
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sendTestNotification,
                    child: const Text('Send Test'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _markAllAsRead,
                    child: const Text('Mark All Read'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearAllNotifications,
                    child: const Text('Clear All'),
                  ),
                ),
              ],
            ),
          ),

          // Notification list
          Expanded(
            child: NotificationList(
              notifications: _notifications,
              isLoading: _isLoading,
              onNotificationTap: (notification) {
                // Handle notification tap
                print('Tapped notification: ${notification.id}');
              },
              onMarkAsRead: (notification) async {
                try {
                  await _notificationManager.markAsRead(
                    notificationId: notification.id,
                    userId: 1,
                  );
                  await _loadNotifications();
                } catch (e) {
                  print('Error marking as read: $e');
                }
              },
              onMarkAllAsRead: _markAllAsRead,
              onClearAll: _clearAllNotifications,
            ),
          ),
        ],
      ),

      // Notification listener for real-time notifications
      bottomSheet: NotificationListenerWidget(
        notificationService: _notificationService,
        minPriority: MagentoNotificationPriority.normal,
        showAllTypes: true,
      ),
    );
  }

  @override
  void dispose() {
    _notificationManager.dispose();
    super.dispose();
  }
}
