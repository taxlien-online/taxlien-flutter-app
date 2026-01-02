import 'package:flutter/material.dart';
import '../models/property_alert.dart';
import '../constants/alert_constants.dart';

/// Alert Card Widget
///
/// Displays an alert with its criteria and actions
class AlertCard extends StatelessWidget {
  final PropertyAlert alert;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Status indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Alert name
                  Expanded(
                    child: Text(
                      alert.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Status toggle
                  IconButton(
                    icon: Icon(
                      alert.isActive ? Icons.pause : Icons.play_arrow,
                      color: alert.isActive ? Colors.orange : Colors.green,
                    ),
                    onPressed: onToggleStatus,
                  ),

                  // Menu
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Description
              if (alert.description != null && alert.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  alert.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Criteria chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: alert.criteria.map((criteria) {
                  return Chip(
                    label: Text(
                      criteria.description,
                      style: const TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // Stats row
              Row(
                children: [
                  // Match count
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${alert.matchCount} matches',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Frequency
                  Icon(
                    Icons.notifications,
                    size: 16,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    alert.frequencyDisplay,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const Spacer(),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      alert.statusDisplay,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (alert.status) {
      case 'active':
        return const Color(AlertConstants.activeAlertColor);
      case 'paused':
        return const Color(AlertConstants.pausedAlertColor);
      case 'triggered':
        return const Color(AlertConstants.triggeredAlertColor);
      case 'expired':
        return const Color(AlertConstants.expiredAlertColor);
      default:
        return Colors.grey;
    }
  }
}
