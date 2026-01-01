import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/achievement.dart';
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';

/// Service for managing achievements
///
/// Tracks progress and unlocks achievements based on user actions
class AchievementsService extends ChangeNotifier {
  static final AchievementsService _instance =
      AchievementsService._internal();
  factory AchievementsService() => _instance;
  AchievementsService._internal();

  static AchievementsService get instance => _instance;

  List<Achievement> _achievements = [];
  final List<String> _unlockedAchievementIds = [];

  // ===== GETTERS =====

  List<Achievement> get achievements => _achievements;
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();
  List<Achievement> get lockedAchievements =>
      _achievements.where((a) => !a.isUnlocked).toList();
  int get totalAchievements => _achievements.length;
  int get unlockedCount => unlockedAchievements.length;
  double get completionPercentage =>
      (unlockedCount / totalAchievements) * 100;

  // ===== INITIALIZATION =====

  /// Initialize achievements for a user
  Future<void> initialize(String userId) async {
    _achievements = Achievement.getAll();
    await _loadUnlockedAchievements(userId);
    notifyListeners();
  }

  /// Load unlocked achievements from storage
  Future<void> _loadUnlockedAchievements(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'achievements_$userId';
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final Map<String, dynamic> data = jsonDecode(jsonString);
        final List<dynamic> unlockedIds = data['unlocked'] ?? [];

        _unlockedAchievementIds.clear();
        _unlockedAchievementIds.addAll(unlockedIds.cast<String>());

        // Update achievement objects
        for (int i = 0; i < _achievements.length; i++) {
          if (_unlockedAchievementIds.contains(_achievements[i].id)) {
            final unlockedAt = data['timestamps']?[_achievements[i].id];
            _achievements[i] = _achievements[i].copyWith(
              isUnlocked: true,
              unlockedAt: unlockedAt != null
                  ? DateTime.parse(unlockedAt)
                  : DateTime.now(),
            );
          }
        }
      }

      debugPrint('✅ Loaded ${_unlockedAchievementIds.length} unlocked achievements');
    } catch (e) {
      debugPrint('❌ Failed to load achievements: $e');
    }
  }

  /// Save unlocked achievements to storage
  Future<void> _saveUnlockedAchievements(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'achievements_$userId';

      final timestamps = <String, String>{};
      for (final achievement in unlockedAchievements) {
        if (achievement.unlockedAt != null) {
          timestamps[achievement.id] = achievement.unlockedAt!.toIso8601String();
        }
      }

      final data = {
        'unlocked': _unlockedAchievementIds,
        'timestamps': timestamps,
      };

      await prefs.setString(key, jsonEncode(data));
    } catch (e) {
      debugPrint('❌ Failed to save achievements: $e');
    }
  }

  // ===== ACHIEVEMENT CHECKING =====

  /// Check and unlock achievements based on position completion
  Future<List<Achievement>> checkPositionCompletion({
    required String userId,
    required SimulatedPosition position,
    required SimulationOutcome outcome,
    required int totalPositions,
    required double portfolioValue,
    required Set<String> uniqueCounties,
  }) async {
    final newlyUnlocked = <Achievement>[];

    // First Purchase
    if (totalPositions == 1) {
      final achievement = await _tryUnlock(
        userId: userId,
        achievementId: 'first_purchase',
      );
      if (achievement != null) newlyUnlocked.add(achievement);
    }

    // 10x ROI
    if (outcome.roi >= 1000) {
      final achievement = await _tryUnlock(
        userId: userId,
        achievementId: '10x_roi',
      );
      if (achievement != null) newlyUnlocked.add(achievement);
    }

    // 100 Positions
    if (totalPositions >= 100) {
      final achievement = await _tryUnlock(
        userId: userId,
        achievementId: '100_positions',
      );
      if (achievement != null) newlyUnlocked.add(achievement);
    }

    // Millionaire
    if (portfolioValue >= 1000000) {
      final achievement = await _tryUnlock(
        userId: userId,
        achievementId: 'millionaire',
      );
      if (achievement != null) newlyUnlocked.add(achievement);
    }

    // Diversified (10 counties)
    if (uniqueCounties.length >= 10) {
      final achievement = await _tryUnlock(
        userId: userId,
        achievementId: 'diversified',
      );
      if (achievement != null) newlyUnlocked.add(achievement);
    }

    // Quick Flip (redeemed in < 4 weeks)
    final simulatedWeeks =
        DateTime.now().difference(position.purchasedAt).inHours / 24 / 7;
    if (outcome.type == OutcomeType.redeemed && simulatedWeeks < 4) {
      final achievement = await _tryUnlock(
        userId: userId,
        achievementId: 'quick_flip',
      );
      if (achievement != null) newlyUnlocked.add(achievement);
    }

    // Long Hold (24+ weeks)
    if (simulatedWeeks >= 24) {
      final achievement = await _tryUnlock(
        userId: userId,
        achievementId: 'long_hold',
      );
      if (achievement != null) newlyUnlocked.add(achievement);
    }

    return newlyUnlocked;
  }

  /// Try to unlock an achievement
  Future<Achievement?> _tryUnlock({
    required String userId,
    required String achievementId,
  }) async {
    // Check if already unlocked
    if (_unlockedAchievementIds.contains(achievementId)) {
      return null;
    }

    // Find achievement
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index == -1) {
      debugPrint('⚠️ Achievement not found: $achievementId');
      return null;
    }

    // Unlock achievement
    final now = DateTime.now();
    _achievements[index] = _achievements[index].copyWith(
      isUnlocked: true,
      unlockedAt: now,
      currentProgress: _achievements[index].targetValue,
    );

    _unlockedAchievementIds.add(achievementId);
    await _saveUnlockedAchievements(userId);
    notifyListeners();

    debugPrint('🏆 Achievement unlocked: ${_achievements[index].title}');
    return _achievements[index];
  }

  /// Update progress for an achievement
  Future<void> updateProgress({
    required String userId,
    required String achievementId,
    required int progress,
  }) async {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index == -1) return;

    if (!_achievements[index].isUnlocked) {
      _achievements[index] = _achievements[index].copyWith(
        currentProgress: progress,
      );

      // Auto-unlock if target reached
      if (progress >= _achievements[index].targetValue) {
        await _tryUnlock(userId: userId, achievementId: achievementId);
      }

      notifyListeners();
    }
  }

  /// Reset all achievements (for testing or user request)
  Future<void> resetAll(String userId) async {
    _achievements = Achievement.getAll();
    _unlockedAchievementIds.clear();
    await _saveUnlockedAchievements(userId);
    notifyListeners();

    debugPrint('🔄 All achievements reset');
  }
}
