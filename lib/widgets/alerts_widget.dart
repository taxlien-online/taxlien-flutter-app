import 'package:flutter/material.dart';
import '../services/portfolio_service.dart';

class AlertsWidget extends StatelessWidget {
  final List<PortfolioAlert> alerts;
  final Function(PortfolioAlert) onAlertTap;
  final Function(String) onMarkAsRead;

  const AlertsWidget({
    Key? key,
    required this.alerts,
    required this.onAlertTap,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unreadAlerts = alerts.where((alert) => !alert.isRead).toList();
    final readAlerts = alerts.where((alert) => alert.isRead).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Portfolio Alerts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (unreadAlerts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${unreadAlerts.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (alerts.isEmpty)
              _buildEmptyState(context)
            else ...[
              if (unreadAlerts.isNotEmpty) ...[
                Text(
                  'Unread',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ...unreadAlerts.map((alert) => _buildAlertItem(context, alert, true)),
                if (readAlerts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Read',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
              if (readAlerts.isNotEmpty)
                ...readAlerts.map((alert) => _buildAlertItem(context, alert, false)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.notifications_none,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Alerts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(BuildContext context, PortfolioAlert alert, bool isUnread) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isUnread
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onAlertTap(alert),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Alert icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getAlertTypeColor(alert.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getAlertTypeIcon(alert.type),
                    color: _getAlertTypeColor(alert.type),
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Alert content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.message,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatAlertDate(alert.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action button
                if (isUnread)
                  IconButton(
                    onPressed: () => onMarkAsRead(alert.id),
                    icon: const Icon(Icons.mark_email_read),
                    tooltip: 'Mark as read',
                    iconSize: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAlertTypeColor(AlertType type) {
    switch (type) {
      case AlertType.opportunity:
        return Colors.green;
      case AlertType.performance:
        return Colors.blue;
      case AlertType.risk:
        return Colors.red;
      case AlertType.reminder:
        return Colors.orange;
      case AlertType.system:
        return Colors.purple;
    }
  }

  IconData _getAlertTypeIcon(AlertType type) {
    switch (type) {
      case AlertType.opportunity:
        return Icons.trending_up;
      case AlertType.performance:
        return Icons.analytics;
      case AlertType.risk:
        return Icons.warning;
      case AlertType.reminder:
        return Icons.schedule;
      case AlertType.system:
        return Icons.settings;
    }
  }

  String _formatAlertDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class AlertSummaryCard extends StatelessWidget {
  final List<PortfolioAlert> alerts;

  const AlertSummaryCard({
    Key? key,
    required this.alerts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unreadCount = alerts.where((alert) => !alert.isRead).length;
    final opportunityCount = alerts.where((alert) => alert.type == AlertType.opportunity).length;
    final riskCount = alerts.where((alert) => alert.type == AlertType.risk).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alert Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Unread',
                    '$unreadCount',
                    Icons.notifications,
                    unreadCount > 0 ? Colors.red : Colors.grey,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Opportunities',
                    '$opportunityCount',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Risks',
                    '$riskCount',
                    Icons.warning,
                    riskCount > 0 ? Colors.orange : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
