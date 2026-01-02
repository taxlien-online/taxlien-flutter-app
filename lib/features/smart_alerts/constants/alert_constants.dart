/// Constants for Smart Alerts feature
///
/// AI-powered property alert matching and notifications
library;

class AlertConstants {
  AlertConstants._();

  // === ALERT LIMITS ===

  /// Maximum alerts for free users
  static const int freeAlertLimit = 3;

  /// Maximum alerts for premium users
  static const int premiumAlertLimit = 50;

  /// Maximum criteria per alert for free users
  static const int freeCriteriaLimit = 3;

  /// Maximum criteria per alert for premium users
  static const int premiumCriteriaLimit = 10;

  // === NOTIFICATION SETTINGS ===

  /// Check for new matches every N minutes
  static const int matchCheckInterval = 15;

  /// Maximum notifications per day for free users
  static const int freeNotificationLimit = 10;

  /// Maximum notifications per day for premium users
  static const int premiumNotificationLimit = 100;

  /// Cool down period between notifications (minutes)
  static const int notificationCooldown = 30;

  // === MATCHING CRITERIA ===

  /// Minimum match score to trigger notification (0-100)
  static const int minMatchScore = 70;

  /// High priority match score threshold
  static const int highPriorityMatchScore = 85;

  /// Critical match score threshold (urgent notification)
  static const int criticalMatchScore = 95;

  // === ALERT TYPES ===

  /// Location-based alert
  static const String alertTypeLocation = 'location';

  /// ROI-based alert
  static const String alertTypeROI = 'roi';

  /// Price-based alert
  static const String alertTypePrice = 'price';

  /// Property type alert
  static const String alertTypePropertyType = 'property_type';

  /// Interest rate alert
  static const String alertTypeInterestRate = 'interest_rate';

  /// Custom multi-criteria alert
  static const String alertTypeCustom = 'custom';

  // === NOTIFICATION CHANNELS ===

  /// Push notification channel ID (high priority)
  static const String channelHighPriority = 'smart_alerts_high';

  /// Push notification channel ID (medium priority)
  static const String channelMediumPriority = 'smart_alerts_medium';

  /// Push notification channel ID (low priority)
  static const String channelLowPriority = 'smart_alerts_low';

  /// Email notification channel
  static const String channelEmail = 'email';

  /// SMS notification channel
  static const String channelSMS = 'sms';

  // === ALERT STATUS ===

  /// Alert is active and monitoring
  static const String statusActive = 'active';

  /// Alert is paused by user
  static const String statusPaused = 'paused';

  /// Alert has triggered (for one-time alerts)
  static const String statusTriggered = 'triggered';

  /// Alert expired
  static const String statusExpired = 'expired';

  // === MATCH FREQUENCY ===

  /// Send notification immediately when match found
  static const String frequencyImmediate = 'immediate';

  /// Digest once per hour
  static const String frequencyHourly = 'hourly';

  /// Digest once per day
  static const String frequencyDaily = 'daily';

  /// Digest once per week
  static const String frequencyWeekly = 'weekly';

  // === UI CONSTANTS ===

  /// Alert card height
  static const double alertCardHeight = 140.0;

  /// Match card height
  static const double matchCardHeight = 120.0;

  /// Criteria chip height
  static const double criteriaChipHeight = 36.0;

  // === COLORS ===

  /// Active alert color
  static const int activeAlertColor = 0xFF4CAF50; // Green

  /// Paused alert color
  static const int pausedAlertColor = 0xFFFF9800; // Orange

  /// Triggered alert color
  static const int triggeredAlertColor = 0xFF2196F3; // Blue

  /// Expired alert color
  static const int expiredAlertColor = 0xFF9E9E9E; // Gray

  /// High priority match color
  static const int highPriorityColor = 0xFFF44336; // Red

  /// Medium priority match color
  static const int mediumPriorityColor = 0xFFFF9800; // Orange

  /// Low priority match color
  static const int lowPriorityColor = 0xFF4CAF50; // Green

  // === API ENDPOINTS ===

  /// API base URL
  static const String apiBaseUrl = 'https://api.taxlien.online';

  /// Create alert endpoint
  static const String createAlertEndpoint = '/alerts/create';

  /// Update alert endpoint
  static const String updateAlertEndpoint = '/alerts/update';

  /// Delete alert endpoint
  static const String deleteAlertEndpoint = '/alerts/delete';

  /// Get user alerts endpoint
  static const String getUserAlertsEndpoint = '/alerts/user';

  /// Check matches endpoint
  static const String checkMatchesEndpoint = '/alerts/check-matches';

  /// Get alert matches endpoint
  static const String getMatchesEndpoint = '/alerts/matches';

  /// Update notification settings endpoint
  static const String updateNotificationSettingsEndpoint =
      '/alerts/notification-settings';

  // === ANALYTICS ===

  /// Track alert creation
  static const bool trackAlertCreation = true;

  /// Track alert triggering
  static const bool trackAlertTriggers = true;

  /// Track notification clicks
  static const bool trackNotificationClicks = true;

  // === ERROR MESSAGES ===

  /// Alert limit reached
  static const String errorAlertLimitReached =
      'You\'ve reached your alert limit. Upgrade to Premium for more alerts!';

  /// Criteria limit reached
  static const String errorCriteriaLimitReached =
      'Maximum criteria reached for this alert.';

  /// Network error
  static const String errorNetworkFailure =
      'Failed to sync alerts. Please check your connection.';

  /// Invalid criteria
  static const String errorInvalidCriteria =
      'Please set at least one valid criteria.';

  /// Notification permission denied
  static const String errorNotificationPermission =
      'Notification permission required. Enable in Settings.';

  // === SUCCESS MESSAGES ===

  /// Alert created
  static const String successAlertCreated = 'Alert created successfully!';

  /// Alert updated
  static const String successAlertUpdated = 'Alert updated!';

  /// Alert deleted
  static const String successAlertDeleted = 'Alert deleted';

  /// Alert paused
  static const String successAlertPaused = 'Alert paused';

  /// Alert resumed
  static const String successAlertResumed = 'Alert resumed';

  // === NOTIFICATION TEMPLATES ===

  /// High priority match notification title
  static const String notificationTitleHighPriority = '🔥 Hot Deal Alert!';

  /// Medium priority match notification title
  static const String notificationTitleMediumPriority = '📍 New Match Found';

  /// Low priority match notification title
  static const String notificationTitleLowPriority = '💡 Potential Match';

  /// Notification body template
  static const String notificationBodyTemplate =
      '{propertyAddress} - {matchScore}% match';

  // === TUTORIAL STEPS ===

  /// Tutorial step count
  static const int tutorialSteps = 3;

  /// Tutorial titles
  static const List<String> tutorialTitles = [
    'Create Custom Alerts',
    'Get Instant Notifications',
    'Never Miss a Deal',
  ];

  /// Tutorial descriptions
  static const List<String> tutorialDescriptions = [
    'Set your criteria: location, price, ROI, and more. Get notified when matching properties appear.',
    'Receive push notifications instantly when properties match your criteria. Configure frequency and channels.',
    'Our AI monitors thousands of properties 24/7 so you can focus on making smart investments.',
  ];

  // === BADGE ICONS ===

  /// New match badge count
  static const int maxBadgeCount = 99;

  // === EXPIRATION ===

  /// Default alert expiration (days, 0 = never)
  static const int defaultExpirationDays = 0;

  /// Maximum expiration days
  static const int maxExpirationDays = 365;

  // === VALIDATION ===

  /// Minimum price value
  static const double minPrice = 0;

  /// Maximum price value
  static const double maxPrice = 10000000;

  /// Minimum ROI value
  static const double minROI = 0;

  /// Maximum ROI value
  static const double maxROI = 1000;

  /// Minimum interest rate
  static const double minInterestRate = 0;

  /// Maximum interest rate
  static const double maxInterestRate = 50;
}
