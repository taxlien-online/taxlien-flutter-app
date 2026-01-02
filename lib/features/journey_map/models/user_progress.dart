/// User Progress Model
class UserProgress {
  final String userId;
  final int currentLevel;
  final int totalXP;
  final String currentStage;
  final List<String> completedMilestones;
  final List<String> earnedBadges;
  final Map<String, int> activityCounts; // Activity -> Count
  final DateTime lastActivityAt;

  const UserProgress({
    required this.userId,
    required this.currentLevel,
    required this.totalXP,
    required this.currentStage,
    required this.completedMilestones,
    required this.earnedBadges,
    required this.activityCounts,
    required this.lastActivityAt,
  });

  /// Get XP progress to next level
  int get xpToNextLevel {
    // Simplified: 1000 * level
    return (1000 * (currentLevel + 1)) - totalXP;
  }

  /// Get progress percentage to next level
  double get progressToNextLevel {
    final currentLevelXP = 1000 * currentLevel;
    final nextLevelXP = 1000 * (currentLevel + 1);
    final progressXP = totalXP - currentLevelXP;
    final requiredXP = nextLevelXP - currentLevelXP;
    return (progressXP / requiredXP * 100).clamp(0, 100);
  }

  /// Check if milestone is completed
  bool hasMilestone(String milestone) {
    return completedMilestones.contains(milestone);
  }

  /// Check if badge is earned
  bool hasBadge(String badge) {
    return earnedBadges.contains(badge);
  }

  /// Get activity count
  int getActivityCount(String activity) {
    return activityCounts[activity] ?? 0;
  }

  /// Get stage display text
  String get stageDisplay {
    switch (currentStage) {
      case 'novice':
        return 'Novice Investor';
      case 'learner':
        return 'Learning Investor';
      case 'intermediate':
        return 'Intermediate Investor';
      case 'advanced':
        return 'Advanced Investor';
      case 'expert':
        return 'Expert Investor';
      default:
        return currentStage;
    }
  }

  /// Copy with modifications
  UserProgress copyWith({
    String? userId,
    int? currentLevel,
    int? totalXP,
    String? currentStage,
    List<String>? completedMilestones,
    List<String>? earnedBadges,
    Map<String, int>? activityCounts,
    DateTime? lastActivityAt,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      currentLevel: currentLevel ?? this.currentLevel,
      totalXP: totalXP ?? this.totalXP,
      currentStage: currentStage ?? this.currentStage,
      completedMilestones: completedMilestones ?? this.completedMilestones,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      activityCounts: activityCounts ?? this.activityCounts,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentLevel': currentLevel,
      'totalXP': totalXP,
      'currentStage': currentStage,
      'completedMilestones': completedMilestones,
      'earnedBadges': earnedBadges,
      'activityCounts': activityCounts,
      'lastActivityAt': lastActivityAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'] as String,
      currentLevel: json['currentLevel'] as int,
      totalXP: json['totalXP'] as int,
      currentStage: json['currentStage'] as String,
      completedMilestones:
          List<String>.from(json['completedMilestones'] as List),
      earnedBadges: List<String>.from(json['earnedBadges'] as List),
      activityCounts: Map<String, int>.from(json['activityCounts'] as Map),
      lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
    );
  }

  /// Create initial progress
  factory UserProgress.initial(String userId) {
    return UserProgress(
      userId: userId,
      currentLevel: 1,
      totalXP: 0,
      currentStage: 'novice',
      completedMilestones: [],
      earnedBadges: [],
      activityCounts: {},
      lastActivityAt: DateTime.now(),
    );
  }
}
