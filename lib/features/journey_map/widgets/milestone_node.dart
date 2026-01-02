import 'package:flutter/material.dart';

/// Milestone Node Widget
class MilestoneNode extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isCompleted;

  const MilestoneNode({
    super.key,
    required this.title,
    required this.icon,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCompleted ? Colors.green.shade50 : Colors.grey.shade50,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            decoration: isCompleted ? null : TextDecoration.none,
          ),
        ),
        trailing: isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }
}
