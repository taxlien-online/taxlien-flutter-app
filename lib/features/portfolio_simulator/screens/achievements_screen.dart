import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../services/achievements_service.dart';

/// Achievements Screen
///
/// Displays all available achievements and user progress
class AchievementsScreen extends StatefulWidget {
  final String userId;

  const AchievementsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final _achievementsService = AchievementsService.instance;

  @override
  void initState() {
    super.initState();
    _achievementsService.initialize(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAchievementInfo,
            tooltip: 'About Achievements',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _achievementsService,
        builder: (context, _) {
          final achievements = _achievementsService.achievements;
          final unlockedCount = _achievementsService.unlockedCount;
          final totalCount = _achievementsService.totalAchievements;
          final completionPercentage =
              _achievementsService.completionPercentage;

          return Column(
            children: [
              // Progress header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[700]!, Colors.purple[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overall Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$unlockedCount / $totalCount',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: completionPercentage / 100,
                        minHeight: 10,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${completionPercentage.toStringAsFixed(0)}% Complete',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Achievements list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    return _buildAchievementCard(achievement);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    final progress = achievement.progressPercentage;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isUnlocked
          ? achievement.color.withOpacity(0.1)
          : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon/Badge
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? achievement.color.withOpacity(0.2)
                    : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.icon,
                size: 32,
                color: isUnlocked ? achievement.color : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? Colors.black : Colors.grey[600],
                          ),
                        ),
                      ),
                      if (isUnlocked)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUnlocked ? Colors.grey[700] : Colors.grey[500],
                    ),
                  ),

                  // Progress bar (if not unlocked)
                  if (!isUnlocked && achievement.isInProgress) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            achievement.color),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${achievement.currentProgress} / ${achievement.targetValue}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  // Unlocked date
                  if (isUnlocked && achievement.unlockedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Unlocked ${_formatDate(achievement.unlockedAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: achievement.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Achievements'),
        content: const Text(
          'Unlock achievements by completing specific tasks in the Portfolio Simulator. '
          'Each achievement comes with a unique badge and tracks your progress. '
          'Keep simulating to unlock them all!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
