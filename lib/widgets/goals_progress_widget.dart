import 'package:flutter/material.dart';
import '../services/portfolio_service.dart';

class GoalsProgressWidget extends StatelessWidget {
  final PortfolioGoals? goals;
  final Function(PortfolioGoal) onGoalTap;
  final VoidCallback onAddGoal;
  final Function(String) onEditGoal;

  const GoalsProgressWidget({
    Key? key,
    required this.goals,
    required this.onGoalTap,
    required this.onAddGoal,
    required this.onEditGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (goals == null || goals!.goals.isEmpty) {
      return _buildEmptyState(context);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Portfolio Goals',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onAddGoal,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Goal',
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...goals!.goals.map((goal) => _buildGoalItem(context, goal)),
            const SizedBox(height: 16),
            _buildGoalsSummary(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Goals Set',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set financial goals to track your progress',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAddGoal,
              icon: const Icon(Icons.add),
              label: const Text('Set Your First Goal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(BuildContext context, PortfolioGoal goal) {
    final progress = goal.progressPercentage / 100;
    final isOverdue = goal.timeRemaining.isNegative && goal.status == GoalStatus.active;
    final priorityColor = _getPriorityColor(goal.priority);
    final statusColor = _getStatusColor(goal.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal header
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildPriorityBadge(context, goal.priority),
              const SizedBox(width: 8),
              _buildStatusBadge(context, goal.status),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${goal.progressPercentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? Colors.green : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Goal details
          Row(
            children: [
              Expanded(
                child: _buildGoalDetail(
                  context,
                  'Current',
                  '\$${goal.currentAmount.toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                ),
              ),
              Expanded(
                child: _buildGoalDetail(
                  context,
                  'Target',
                  '\$${goal.targetAmount.toStringAsFixed(2)}',
                  Icons.flag,
                ),
              ),
              Expanded(
                child: _buildGoalDetail(
                  context,
                  'Remaining',
                  _formatTimeRemaining(goal.timeRemaining),
                  Icons.schedule,
                  isOverdue: isOverdue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onGoalTap(goal),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onEditGoal(goal.id),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context, GoalPriority priority) {
    final color = _getPriorityColor(priority);
    final label = _getPriorityLabel(priority);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, GoalStatus status) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildGoalDetail(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isOverdue = false,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: isOverdue ? Colors.red : Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isOverdue ? Colors.red : Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGoalsSummary(BuildContext context) {
    final totalGoals = goals!.goals.length;
    final completedGoals = goals!.goals.where((g) => g.status == GoalStatus.completed).length;
    final activeGoals = goals!.goals.where((g) => g.status == GoalStatus.active).length;
    final totalTargetValue = goals!.totalValue;
    final achievedValue = goals!.achievedValue;
    final overallProgress = totalTargetValue > 0 ? (achievedValue / totalTargetValue) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goals Summary',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Total Goals',
                  '$totalGoals',
                  Icons.flag,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Completed',
                  '$completedGoals',
                  Icons.check_circle,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Active',
                  '$activeGoals',
                  Icons.trending_up,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Target Value',
                  '\$${totalTargetValue.toStringAsFixed(0)}',
                  Icons.account_balance,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Achieved',
                  '\$${achievedValue.toStringAsFixed(0)}',
                  Icons.check,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Progress',
                  '${overallProgress.toStringAsFixed(1)}%',
                  Icons.pie_chart,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper methods
  Color _getPriorityColor(GoalPriority priority) {
    switch (priority) {
      case GoalPriority.high:
        return Colors.red;
      case GoalPriority.medium:
        return Colors.orange;
      case GoalPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityLabel(GoalPriority priority) {
    switch (priority) {
      case GoalPriority.high:
        return 'HIGH';
      case GoalPriority.medium:
        return 'MED';
      case GoalPriority.low:
        return 'LOW';
    }
  }

  Color _getStatusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.active:
        return Colors.blue;
      case GoalStatus.paused:
        return Colors.orange;
      case GoalStatus.completed:
        return Colors.green;
      case GoalStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusLabel(GoalStatus status) {
    switch (status) {
      case GoalStatus.active:
        return 'ACTIVE';
      case GoalStatus.paused:
        return 'PAUSED';
      case GoalStatus.completed:
        return 'DONE';
      case GoalStatus.cancelled:
        return 'CANCELLED';
    }
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration.isNegative) {
      return 'Overdue';
    }
    
    if (duration.inDays > 365) {
      final years = duration.inDays ~/ 365;
      return '${years}y ${(duration.inDays % 365) ~/ 30}m';
    } else if (duration.inDays > 30) {
      final months = duration.inDays ~/ 30;
      return '${months}m ${duration.inDays % 30}d';
    } else if (duration.inDays > 0) {
      return '${duration.inDays}d';
    } else {
      return 'Today';
    }
  }
}
