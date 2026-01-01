import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';

/// Widget displaying a single leaderboard entry
class LeaderboardEntryCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const LeaderboardEntryCard({
    super.key,
    required this.entry,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTopThree = entry.rank <= 3;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCurrentUser
          ? theme.primaryColor.withOpacity(0.1)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCurrentUser
            ? BorderSide(color: theme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank badge
            _buildRankBadge(theme),
            const SizedBox(width: 16),

            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: _getRankColor().withOpacity(0.2),
              backgroundImage: entry.avatarUrl != null
                  ? NetworkImage(entry.avatarUrl!)
                  : null,
              child: entry.avatarUrl == null
                  ? Icon(
                      Icons.person,
                      color: _getRankColor(),
                      size: 28,
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          entry.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCurrentUser ? theme.primaryColor : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'YOU',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.positionCount} positions',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${_formatNumber(entry.portfolioValue)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: entry.roi >= 0
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${entry.roi >= 0 ? '+' : ''}${entry.roi.toStringAsFixed(1)}% ROI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: entry.roi >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(ThemeData theme) {
    final isTopThree = entry.rank <= 3;
    final medal = entry.medal;

    if (medal != null) {
      // Show medal for top 3
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _getRankColor().withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            medal,
            style: const TextStyle(fontSize: 28),
          ),
        ),
      );
    }

    // Show rank number for others
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '#${entry.rank}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Color _getRankColor() {
    if (entry.rank == 1) return Colors.amber;
    if (entry.rank == 2) return Colors.grey;
    if (entry.rank == 3) return Colors.brown;
    return Colors.blue;
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
