import 'package:flutter/material.dart';
import '../models/user_progress.dart';
import '../services/progress_service.dart';
import '../widgets/level_progress_bar.dart';
import '../widgets/milestone_node.dart';

/// Journey Map Screen
///
/// Gamified progress tracking with milestones and levels
class JourneyMapScreen extends StatefulWidget {
  final String userId;

  const JourneyMapScreen({
    super.key,
    required this.userId,
  });

  @override
  State<JourneyMapScreen> createState() => _JourneyMapScreenState();
}

class _JourneyMapScreenState extends State<JourneyMapScreen> {
  late Future<UserProgress> _progressFuture;

  @override
  void initState() {
    super.initState();
    _progressFuture = ProgressService.instance.getUserProgress(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Journey'),
      ),
      body: FutureBuilder<UserProgress>(
        future: _progressFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final progress = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Level Card
              _buildLevelCard(progress),

              const SizedBox(height: 24),

              // XP Progress
              LevelProgressBar(progress: progress),

              const SizedBox(height: 32),

              // Milestones
              const Text(
                'Your Progress',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildMilestones(progress),

              const SizedBox(height: 32),

              // Badges
              _buildBadgesSection(progress),

              const SizedBox(height: 32),

              // Stats
              _buildStatsSection(progress),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(UserProgress progress) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade700, Colors.purple.shade900],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Level ${progress.currentLevel}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progress.stageDisplay,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars, color: Colors.yellow, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${progress.totalXP} XP',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestones(UserProgress progress) {
    final milestones = [
      {'id': 'onboarding', 'title': 'Complete Onboarding', 'icon': Icons.flag},
      {'id': 'first_view', 'title': 'View First Property', 'icon': Icons.visibility},
      {'id': 'first_alert', 'title': 'Create First Alert', 'icon': Icons.notifications},
      {'id': 'first_sim', 'title': 'Complete Simulation', 'icon': Icons.play_circle},
      {'id': '10_swipes', 'title': 'Swipe 10 Properties', 'icon': Icons.swipe},
      {'id': 'first_investment', 'title': 'Make First Investment', 'icon': Icons.attach_money},
    ];

    return Column(
      children: milestones.map((milestone) {
        final isCompleted = progress.hasMilestone(milestone['id'] as String);
        return MilestoneNode(
          title: milestone['title'] as String,
          icon: milestone['icon'] as IconData,
          isCompleted: isCompleted,
        );
      }).toList(),
    );
  }

  Widget _buildBadgesSection(UserProgress progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Badges Earned',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            progress.earnedBadges.isEmpty
                ? const Text('No badges earned yet. Keep going!')
                : Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: progress.earnedBadges.map((badge) {
                      return _buildBadge(badge);
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String badge) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: _getBadgeColor(badge),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getBadgeIcon(badge),
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            badge.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(UserProgress progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Properties Viewed', progress.getActivityCount('views')),
            _buildStatRow('Simulations Run', progress.getActivityCount('simulations')),
            _buildStatRow('Properties Swiped', progress.getActivityCount('swipes')),
            _buildStatRow('Alerts Created', progress.getActivityCount('alerts')),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'platinum':
        return const Color(0xFFE5E4E2);
      default:
        return Colors.blue;
    }
  }

  IconData _getBadgeIcon(String badge) {
    return Icons.emoji_events;
  }
}
