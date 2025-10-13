import 'package:flutter/material.dart';
import '../models/notification_models.dart';
import '../models/notification_types.dart';
import 'notification_widgets.dart';

/// Widget for displaying a list of notifications
class NotificationList extends StatefulWidget {
  const NotificationList({
    super.key,
    required this.notifications,
    this.onNotificationTap,
    this.onNotificationDismiss,
    this.onMarkAsRead,
    this.onMarkAllAsRead,
    this.onClearAll,
    this.showActions = true,
    this.showTimestamps = true,
    this.showTypes = true,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  final List<MagentoNotification> notifications;
  final Function(MagentoNotification)? onNotificationTap;
  final Function(MagentoNotification)? onNotificationDismiss;
  final Function(MagentoNotification)? onMarkAsRead;
  final VoidCallback? onMarkAllAsRead;
  final VoidCallback? onClearAll;
  final bool showActions;
  final bool showTimestamps;
  final bool showTypes;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return widget.loadingWidget ?? _buildLoadingWidget();
    }

    if (widget.hasError) {
      return widget.errorWidget ?? _buildErrorWidget();
    }

    if (widget.notifications.isEmpty) {
      return widget.emptyWidget ?? _buildEmptyWidget();
    }

    return Column(
      children: [
        if (widget.showActions) _buildActionBar(),
        Expanded(child: _buildNotificationList()),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            widget.errorMessage ?? 'Failed to load notifications',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Retry logic would be handled by parent
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Notifications',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (widget.onMarkAllAsRead != null)
            TextButton(
              onPressed: widget.onMarkAllAsRead,
              child: const Text('Mark All Read'),
            ),
          if (widget.onClearAll != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: widget.onClearAll,
              child: const Text('Clear All'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      itemCount: widget.notifications.length,
      itemBuilder: (context, index) {
        final notification = widget.notifications[index];
        return NotificationListTile(
          notification: notification,
          onTap: () => widget.onNotificationTap?.call(notification),
          onDismiss: () => widget.onNotificationDismiss?.call(notification),
          showTimestamp: widget.showTimestamps,
        );
      },
    );
  }
}

/// Widget for displaying notification list with filtering
class FilterableNotificationList extends StatefulWidget {
  const FilterableNotificationList({
    super.key,
    required this.notifications,
    this.onNotificationTap,
    this.onNotificationDismiss,
    this.onMarkAsRead,
    this.onMarkAllAsRead,
    this.onClearAll,
    this.showActions = true,
    this.showTimestamps = true,
    this.showTypes = true,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  final List<MagentoNotification> notifications;
  final Function(MagentoNotification)? onNotificationTap;
  final Function(MagentoNotification)? onNotificationDismiss;
  final Function(MagentoNotification)? onMarkAsRead;
  final VoidCallback? onMarkAllAsRead;
  final VoidCallback? onClearAll;
  final bool showActions;
  final bool showTimestamps;
  final bool showTypes;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  @override
  State<FilterableNotificationList> createState() =>
      _FilterableNotificationListState();
}

class _FilterableNotificationListState
    extends State<FilterableNotificationList> {
  MagentoNotificationType? _selectedType;
  MagentoNotificationPriority? _selectedPriority;
  bool _showUnreadOnly = false;
  String _searchQuery = '';

  List<MagentoNotification> get _filteredNotifications {
    return widget.notifications.where((notification) {
      // Filter by type
      if (_selectedType != null && notification.type != _selectedType) {
        return false;
      }

      // Filter by priority
      if (_selectedPriority != null &&
          notification.priority != _selectedPriority) {
        return false;
      }

      // Filter by read status
      if (_showUnreadOnly && notification.isRead) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!notification.message.toLowerCase().contains(query) &&
            !(notification.title?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: NotificationList(
            notifications: _filteredNotifications,
            onNotificationTap: widget.onNotificationTap,
            onNotificationDismiss: widget.onNotificationDismiss,
            onMarkAsRead: widget.onMarkAsRead,
            onMarkAllAsRead: widget.onMarkAllAsRead,
            onClearAll: widget.onClearAll,
            showActions: widget.showActions,
            showTimestamps: widget.showTimestamps,
            showTypes: widget.showTypes,
            emptyWidget: widget.emptyWidget,
            loadingWidget: widget.loadingWidget,
            errorWidget: widget.errorWidget,
            isLoading: widget.isLoading,
            hasError: widget.hasError,
            errorMessage: widget.errorMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search notifications...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          // Filters
          Row(
            children: [
              // Type filter
              Expanded(
                child: DropdownButtonFormField<MagentoNotificationType?>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<MagentoNotificationType?>(
                      value: null,
                      child: Text('All Types'),
                    ),
                    ...MagentoNotificationType.values.map((type) {
                      return DropdownMenuItem<MagentoNotificationType>(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Priority filter
              Expanded(
                child: DropdownButtonFormField<MagentoNotificationPriority?>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<MagentoNotificationPriority?>(
                      value: null,
                      child: Text('All Priorities'),
                    ),
                    ...MagentoNotificationPriority.values.map((priority) {
                      return DropdownMenuItem<MagentoNotificationPriority>(
                        value: priority,
                        child: Text(priority.displayName),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Unread only toggle
          Row(
            children: [
              Checkbox(
                value: _showUnreadOnly,
                onChanged: (value) {
                  setState(() {
                    _showUnreadOnly = value ?? false;
                  });
                },
              ),
              const Text('Show unread only'),
              const Spacer(),
              // Clear filters
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedType = null;
                    _selectedPriority = null;
                    _showUnreadOnly = false;
                    _searchQuery = '';
                  });
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
