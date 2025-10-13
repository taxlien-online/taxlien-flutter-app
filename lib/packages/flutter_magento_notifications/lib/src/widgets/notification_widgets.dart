import 'package:flutter/material.dart';
import '../models/notification_models.dart';
import '../models/notification_types.dart';
import '../services/notification_service.dart';

/// Widget that automatically shows notifications as snackbars
class MagentoNotificationListener extends StatefulWidget {
  const MagentoNotificationListener({
    super.key,
    required this.child,
    this.notificationService,
    this.minPriority,
    this.showAllTypes = true,
    this.customBuilder,
  });

  final Widget child;
  final MagentoNotificationService? notificationService;
  final MagentoNotificationPriority? minPriority;
  final bool showAllTypes;
  final Widget Function(BuildContext, MagentoNotification)? customBuilder;

  @override
  State<MagentoNotificationListener> createState() =>
      _MagentoNotificationListenerState();
}

class _MagentoNotificationListenerState
    extends State<MagentoNotificationListener> {
  MagentoNotificationSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _setupNotificationListener();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _setupNotificationListener() {
    final service = widget.notificationService ?? MagentoNotificationService();

    _subscription = service.subscribeToAll(
      callback: _showNotification,
      minPriority: widget.minPriority,
      filter: widget.showAllTypes
          ? null
          : (notification) {
              // Filter out certain types if needed
              return notification.type != MagentoNotificationType.info;
            },
    );
  }

  void _showNotification(MagentoNotification notification) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    // Clear any existing snackbar
    messenger.clearSnackBars();

    final snackBar = SnackBar(
      content: _buildNotificationContent(notification),
      backgroundColor: _getNotificationColor(notification),
      duration: _getNotificationDuration(notification),
      behavior: SnackBarBehavior.floating,
      action: notification.priority == MagentoNotificationPriority.critical
          ? SnackBarAction(
              label: 'DETAILS',
              textColor: Colors.white,
              onPressed: () => _showNotificationDetails(notification),
            )
          : null,
    );

    messenger.showSnackBar(snackBar);
  }

  Widget _buildNotificationContent(MagentoNotification notification) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, notification);
    }

    return Row(
      children: [
        Icon(
          _getNotificationIcon(notification),
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.title != null) ...[
                Text(
                  notification.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                notification.message,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getNotificationColor(MagentoNotification notification) {
    return Color(notification.colorValue);
  }

  IconData _getNotificationIcon(MagentoNotification notification) {
    switch (notification.type) {
      case MagentoNotificationType.error:
        return Icons.error_outline;
      case MagentoNotificationType.warning:
        return Icons.warning_amber;
      case MagentoNotificationType.info:
        return Icons.info_outline;
      case MagentoNotificationType.success:
        return Icons.check_circle_outline;
      case MagentoNotificationType.sync:
        return Icons.sync;
      case MagentoNotificationType.cloudFeature:
        return Icons.cloud_outline;
      case MagentoNotificationType.network:
        return Icons.wifi;
      case MagentoNotificationType.auth:
        return Icons.security;
      case MagentoNotificationType.cache:
        return Icons.storage;
    }
  }

  Duration _getNotificationDuration(MagentoNotification notification) {
    switch (notification.priority) {
      case MagentoNotificationPriority.low:
        return const Duration(seconds: 2);
      case MagentoNotificationPriority.normal:
        return const Duration(seconds: 3);
      case MagentoNotificationPriority.high:
        return const Duration(seconds: 5);
      case MagentoNotificationPriority.critical:
        return const Duration(seconds: 8);
    }
  }

  void _showNotificationDetails(MagentoNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title ?? notification.type.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            if (notification.data != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Additional Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                notification.data.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Notification badge widget
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
    required this.count,
    this.child,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.minValue = 1,
  });

  final int count;
  final Widget? child;
  final Color color;
  final Color textColor;
  final int minValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (child != null) child!,
        if (count >= minValue)
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Notification list tile widget
class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.showTimestamp = true,
  });

  final MagentoNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(notification.colorValue),
          child: Icon(
            _getNotificationIcon(notification),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title ?? notification.type.displayName,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (showTimestamp) ...[
              const SizedBox(height: 4),
              Text(
                notification.formattedTimestamp,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(notification.colorValue),
                  shape: BoxShape.circle,
                ),
              ),
        onTap: onTap,
      ),
    );
  }

  IconData _getNotificationIcon(MagentoNotification notification) {
    switch (notification.type) {
      case MagentoNotificationType.error:
        return Icons.error_outline;
      case MagentoNotificationType.warning:
        return Icons.warning_amber;
      case MagentoNotificationType.info:
        return Icons.info_outline;
      case MagentoNotificationType.success:
        return Icons.check_circle_outline;
      case MagentoNotificationType.sync:
        return Icons.sync;
      case MagentoNotificationType.cloudFeature:
        return Icons.cloud_outline;
      case MagentoNotificationType.network:
        return Icons.wifi;
      case MagentoNotificationType.auth:
        return Icons.security;
      case MagentoNotificationType.cache:
        return Icons.storage;
    }
  }
}


