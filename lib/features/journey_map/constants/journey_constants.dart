/// Constants for Journey Map feature
///
/// Gamified learning and progress tracking
library;

class JourneyConstants {
  JourneyConstants._();

  // === JOURNEY STAGES ===

  /// Beginner stage
  static const String stageNovice = 'novice';

  /// Learner stage
  static const String stageLearner = 'learner';

  /// Intermediate stage
  static const String stageIntermediate = 'intermediate';

  /// Advanced stage
  static const String stageAdvanced = 'advanced';

  /// Expert stage
  static const String stageExpert = 'expert';

  // === MILESTONES ===

  /// Complete onboarding
  static const String milestoneOnboarding = 'onboarding';

  /// First property viewed
  static const String milestoneFirstView = 'first_view';

  /// First alert created
  static const String milestoneFirstAlert = 'first_alert';

  /// First simulation completed
  static const String milestoneFirstSim = 'first_sim';

  /// 10 properties swiped
  static const String milestone10Swipes = '10_swipes';

  /// First investment (real)
  static const String milestoneFirstInvestment = 'first_investment';

  /// 5 successful investments
  static const String milestone5Investments = '5_investments';

  /// Reach leaderboard top 100
  static const String milestoneLeaderboard = 'leaderboard_top100';

  // === EXPERIENCE POINTS ===

  /// XP for completing onboarding
  static const int xpOnboarding = 100;

  /// XP for viewing first property
  static const int xpFirstView = 50;

  /// XP for creating alert
  static const int xpCreateAlert = 75;

  /// XP for completing simulation
  static const int xpCompleteSim = 150;

  /// XP for property swipe
  static const int xpSwipe = 10;

  /// XP for real investment
  static const int xpInvestment = 500;

  // === LEVEL REQUIREMENTS ===

  /// XP needed for each level
  static const List<int> levelRequirements = [
    0, // Level 1
    100, // Level 2
    250, // Level 3
    500, // Level 4
    1000, // Level 5
    2000, // Level 6
    3500, // Level 7
    5500, // Level 8
    8000, // Level 9
    12000, // Level 10
  ];

  // === BADGE TYPES ===

  /// Bronze badge
  static const String badgeBronze = 'bronze';

  /// Silver badge
  static const String badgeSilver = 'silver';

  /// Gold badge
  static const String badgeGold = 'gold';

  /// Platinum badge
  static const String badgePlatinum = 'platinum';

  // === UI CONSTANTS ===

  /// Journey map height
  static const double journeyMapHeight = 400.0;

  /// Milestone node size
  static const double milestoneNodeSize = 60.0;

  /// Progress bar height
  static const double progressBarHeight = 8.0;

  // === COLORS ===

  /// Completed color
  static const int completedColor = 0xFF4CAF50; // Green

  /// In progress color
  static const int inProgressColor = 0xFF2196F3; // Blue

  /// Locked color
  static const int lockedColor = 0xFF9E9E9E; // Gray

  /// Bronze color
  static const int bronzeColor = 0xFFCD7F32;

  /// Silver color
  static const int silverColor = 0xFFC0C0C0;

  /// Gold color
  static const int goldColor = 0xFFFFD700;

  /// Platinum color
  static const int platinumColor = 0xFFE5E4E2;

  // === MESSAGES ===

  /// Level up message
  static const String msgLevelUp = 'Level Up! 🎉';

  /// Badge earned message
  static const String msgBadgeEarned = 'New Badge Earned! 🏆';

  /// Milestone completed message
  static const String msgMilestoneComplete = 'Milestone Completed! ✨';
}
