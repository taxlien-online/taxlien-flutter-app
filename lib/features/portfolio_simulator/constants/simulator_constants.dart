/// Constants for Portfolio Simulator feature
///
/// This file contains all constants used in the Portfolio Simulator,
/// including limits, defaults, simulation parameters, and UI constants.
library;

class SimulatorConstants {
  SimulatorConstants._();

  // === API ENDPOINTS ===

  /// Base URL for simulator API
  static const String apiBaseUrl = 'https://api.taxlien.online'; // TODO: Replace with actual API URL

  // === CAPITAL & LIMITS ===

  /// Starting capital for new simulated portfolios
  static const double defaultStartingCapital = 100000.0;

  /// Minimum capital required to purchase a property
  static const double minimumPurchaseAmount = 100.0;

  /// Maximum capital for a simulated portfolio
  static const double maximumCapital = 1000000.0;

  // === FREE vs PAID TIER LIMITS ===

  /// Maximum number of portfolios for free users
  static const int freeMaxPortfolios = 1;

  /// Maximum number of portfolios for paid users
  static const int paidMaxPortfolios = 999;

  /// Maximum number of positions per portfolio (free tier)
  static const int freeMaxPositions = 5;

  /// Maximum number of positions per portfolio (paid tier)
  static const int paidMaxPositions = 999;

  // === TIME ACCELERATION ===

  /// Real hours to simulated weeks conversion (1 real hour = 1 simulated week)
  static const int realHoursPerSimulatedWeek = 1;

  /// Simulation speed multipliers available to users
  static const List<double> simulationSpeedOptions = [1.0, 2.0, 4.0];

  /// Default simulation speed (1x = normal)
  static const double defaultSimulationSpeed = 1.0;

  /// Average time in simulated weeks until outcome is determined
  static const int averageWeeksToOutcome = 12; // ~12 weeks (3 months)

  /// Minimum time in simulated weeks until outcome
  static const int minimumWeeksToOutcome = 4;

  /// Maximum time in simulated weeks until outcome
  static const int maximumWeeksToOutcome = 52; // 1 year

  // === SIMULATION OUTCOMES ===

  /// Probability variance for randomness (+/- 10%)
  static const double outcomeVariance = 0.10;

  /// Default redemption probability if no ML data available
  static const double defaultRedemptionProbability = 0.65;

  /// Default foreclosure probability
  static const double defaultForeclosureProbability = 0.25;

  /// Default partial payment probability
  static const double defaultPartialPaymentProbability = 0.10;

  /// Minimum ROI percentage (loss)
  static const double minimumROI = -100.0;

  /// Maximum ROI percentage (10x gain)
  static const double maximumROI = 1000.0;

  /// Average ROI for successful outcomes
  static const double averageSuccessROI = 15.0; // 15% return

  // === PURCHASE SIMULATION ===

  /// Price variance for simulated properties (+/- 10% from real price)
  static const double priceVariance = 0.10;

  /// Transaction fee percentage (simulated closing costs)
  static const double transactionFeePercentage = 0.02; // 2%

  // === LEADERBOARD ===

  /// Number of top users to display in leaderboard
  static const int leaderboardTopCount = 10;

  /// Leaderboard refresh interval in seconds
  static const int leaderboardRefreshSeconds = 300; // 5 minutes

  /// Minimum portfolio value to appear on leaderboard
  static const double leaderboardMinimumValue = 10000.0;

  // === ACHIEVEMENTS ===

  /// Achievement IDs
  static const String achievementFirstPurchase = 'first_purchase';
  static const String achievement10xROI = '10x_roi';
  static const String achievement100Positions = '100_positions';
  static const String achievementMillionaire = 'millionaire';
  static const String achievementPerfectWeek = 'perfect_week';
  static const String achievementDiversified = 'diversified';
  static const String achievementRiskTaker = 'risk_taker';
  static const String achievementSafePlayer = 'safe_player';
  static const String achievementQuickFlip = 'quick_flip';
  static const String achievementLongHold = 'long_hold';

  // === UI CONSTANTS ===

  /// Grid column count for portfolio list
  static const int portfolioGridColumns = 2;

  /// Animation duration for card transitions (milliseconds)
  static const int cardAnimationDurationMs = 300;

  /// Animation duration for confetti (milliseconds)
  static const int confettiDurationMs = 2000;

  /// Chart data points for performance graph
  static const int chartMaxDataPoints = 30;

  /// Refresh interval for portfolio updates (seconds)
  static const int portfolioRefreshSeconds = 60;

  // === NOTIFICATIONS ===

  /// Enable outcome ready notifications
  static const bool defaultNotificationsEnabled = true;

  /// Notification channel ID for simulator
  static const String notificationChannelId = 'simulator_outcomes';

  /// Notification channel name
  static const String notificationChannelName = 'Simulator Outcomes';

  // === TUTORIAL ===

  /// Number of tutorial steps for first-time users
  static const int tutorialStepCount = 3;

  /// Show tutorial on first launch
  static const bool showTutorialByDefault = true;

  /// Sample portfolio name for demo
  static const String samplePortfolioName = 'Practice Portfolio';

  // === API ENDPOINTS ===

  /// Endpoint for ML-based outcome simulation
  static const String apiOutcomeEndpoint = '/simulate/outcome';

  /// Endpoint for leaderboard data
  static const String apiLeaderboardEndpoint = '/simulator/leaderboard';

  /// Endpoint for submitting score
  static const String apiScoreEndpoint = '/simulator/score';

  /// API timeout duration (seconds)
  static const int apiTimeoutSeconds = 10;

  // === CACHE & STORAGE ===

  /// Hive box name for portfolios
  static const String hiveBoxPortfolios = 'simulator_portfolios';

  /// Hive box name for positions
  static const String hiveBoxPositions = 'simulator_positions';

  /// Hive box name for achievements
  static const String hiveBoxAchievements = 'simulator_achievements';

  /// Hive box name for settings
  static const String hiveBoxSettings = 'simulator_settings';

  /// Cache duration for leaderboard (minutes)
  static const int leaderboardCacheMinutes = 5;

  // === VALIDATION ===

  /// Minimum portfolio name length
  static const int minPortfolioNameLength = 1;

  /// Maximum portfolio name length
  static const int maxPortfolioNameLength = 50;

  /// Allowed characters in portfolio name (regex)
  static const String portfolioNameRegex = r'^[a-zA-Z0-9\s\-_]+$';

  // === ERROR MESSAGES ===

  static const String errorInsufficientFunds = 'Insufficient funds in portfolio';
  static const String errorMaxPortfolios = 'Maximum portfolios reached. Upgrade to Premium for unlimited portfolios.';
  static const String errorMaxPositions = 'Maximum positions reached. Upgrade to Premium for unlimited positions.';
  static const String errorInvalidName = 'Portfolio name must be 1-50 characters and contain only letters, numbers, spaces, hyphens, and underscores';
  static const String errorNetworkFailure = 'Unable to connect. Using offline mode.';
  static const String errorSimulationFailed = 'Simulation failed. Please try again.';

  // === SUCCESS MESSAGES ===

  static const String successPortfolioCreated = 'Portfolio created successfully!';
  static const String successPurchaseComplete = 'Property purchased successfully!';
  static const String successOutcomeRevealed = 'Outcome revealed!';
}
