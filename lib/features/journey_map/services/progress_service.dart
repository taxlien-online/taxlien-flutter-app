import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_progress.dart';

/// Progress Service
class ProgressService {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  static ProgressService get instance => _instance;

  /// Get user progress
  Future<UserProgress> getUserProgress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('progress_$userId');

    if (json == null) {
      return UserProgress.initial(userId);
    }

    return UserProgress.fromJson(jsonDecode(json));
  }

  /// Save user progress
  Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'progress_${progress.userId}',
      jsonEncode(progress.toJson()),
    );
  }

  /// Add XP
  Future<UserProgress> addXP(String userId, int xp) async {
    final progress = await getUserProgress(userId);
    final newTotalXP = progress.totalXP + xp;

    // Check for level up
    int newLevel = progress.currentLevel;
    while (newTotalXP >= (1000 * (newLevel + 1))) {
      newLevel++;
    }

    final updated = progress.copyWith(
      totalXP: newTotalXP,
      currentLevel: newLevel,
      lastActivityAt: DateTime.now(),
    );

    await saveProgress(updated);
    return updated;
  }

  /// Complete milestone
  Future<UserProgress> completeMilestone(String userId, String milestone) async {
    final progress = await getUserProgress(userId);

    if (progress.hasMilestone(milestone)) {
      return progress;
    }

    final milestones = List<String>.from(progress.completedMilestones)..add(milestone);
    final updated = progress.copyWith(
      completedMilestones: milestones,
      lastActivityAt: DateTime.now(),
    );

    await saveProgress(updated);
    return updated;
  }

  /// Record activity
  Future<UserProgress> recordActivity(String userId, String activity) async {
    final progress = await getUserProgress(userId);
    final counts = Map<String, int>.from(progress.activityCounts);
    counts[activity] = (counts[activity] ?? 0) + 1;

    final updated = progress.copyWith(
      activityCounts: counts,
      lastActivityAt: DateTime.now(),
    );

    await saveProgress(updated);
    return updated;
  }
}
