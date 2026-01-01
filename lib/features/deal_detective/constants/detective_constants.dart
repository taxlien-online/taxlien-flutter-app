/// Constants for Deal Detective feature
///
/// Swipe-based property discovery (Tinder for tax liens)
library;

class DetectiveConstants {
  DetectiveConstants._();

  // === SWIPE MECHANICS ===

  /// Minimum drag distance to trigger a swipe (in pixels)
  static const double swipeThreshold = 100.0;

  /// Rotation angle multiplier for card tilt
  static const double rotationFactor = 0.1;

  /// Maximum rotation angle (in radians)
  static const double maxRotation = 0.3;

  /// Animation duration for card snap back (milliseconds)
  static const int snapBackDuration = 300;

  /// Animation duration for card swipe out (milliseconds)
  static const int swipeOutDuration = 200;

  // === CARD STACK ===

  /// Number of cards to prefetch ahead
  static const int prefetchCount = 10;

  /// Maximum cards visible in stack at once
  static const int visibleCardCount = 3;

  /// Scale factor for cards in background
  static const double cardScaleDecrement = 0.05;

  /// Vertical offset for stacked cards (pixels)
  static const double cardVerticalOffset = 10.0;

  // === FREE vs PAID LIMITS ===

  /// Daily swipe limit for free users
  static const int freeDailySwipeLimit = 50;

  /// Daily swipe limit for paid users (unlimited)
  static const int paidDailySwipeLimit = 999999;

  /// Undo limit for free users
  static const int freeUndoLimit = 3;

  /// Undo limit for paid users (unlimited)
  static const int paidUndoLimit = 999999;

  // === SWIPE DIRECTIONS ===

  /// Swipe right (like/interested)
  static const String swipeRight = 'right';

  /// Swipe left (pass/not interested)
  static const String swipeLeft = 'left';

  /// Swipe up (super like/save to watchlist)
  static const String swipeUp = 'up';

  /// Swipe down (not now/maybe later)
  static const String swipeDown = 'down';

  // === MATCH CRITERIA ===

  /// Minimum ROI to be considered a match
  static const double matchRoiThreshold = 30.0;

  /// Maximum risk score to be considered a match
  static const double matchRiskThreshold = 0.5;

  // === UI CONSTANTS ===

  /// Card border radius
  static const double cardBorderRadius = 20.0;

  /// Overlay gradient height percentage
  static const double overlayGradientHeight = 0.4;

  /// Info panel height (pixels)
  static const double infoPanelHeight = 200.0;

  /// Action button size
  static const double actionButtonSize = 60.0;

  /// Small action button size
  static const double smallActionButtonSize = 50.0;

  // === COLORS ===

  /// Color for like/right swipe
  static const int likeColor = 0xFF4CAF50; // Green

  /// Color for pass/left swipe
  static const int passColor = 0xFFF44336; // Red

  /// Color for super like/up swipe
  static const int superLikeColor = 0xFF2196F3; // Blue

  /// Color for maybe/down swipe
  static const int maybeColor = 0xFFFF9800; // Orange

  // === NOTIFICATIONS ===

  /// Show match notification when criteria met
  static const bool showMatchNotifications = true;

  /// Match notification title
  static const String matchNotificationTitle = 'It\'s a Match!';

  /// Match notification body template
  static const String matchNotificationBody = 'You matched with a property!';

  // === API ENDPOINTS ===

  /// API base URL
  static const String apiBaseUrl = 'https://api.taxlien.online';

  /// Swipe action endpoint
  static const String swipeActionEndpoint = '/detective/swipe';

  /// Get cards endpoint
  static const String getCardsEndpoint = '/detective/cards';

  /// Match history endpoint
  static const String matchHistoryEndpoint = '/detective/matches';

  // === ANALYTICS ===

  /// Track swipe events
  static const bool trackSwipeEvents = true;

  /// Track match events
  static const bool trackMatchEvents = true;

  // === ERROR MESSAGES ===

  /// Daily limit reached message
  static const String errorDailyLimitReached =
      'You\'ve reached your daily swipe limit. Upgrade to Premium for unlimited swipes!';

  /// No more cards message
  static const String errorNoMoreCards =
      'No more properties right now. Check back later!';

  /// Network error message
  static const String errorNetworkFailure =
      'Failed to load properties. Please check your connection.';

  // === SUCCESS MESSAGES ===

  /// Added to watchlist message
  static const String successAddedToWatchlist = 'Added to your watchlist!';

  /// Undo successful message
  static const String successUndo = 'Last swipe undone';
}
