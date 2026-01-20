/**
 * @file Subscription and Trial Constants
 * @author NativeMind Team
 * 
 * Configuration for in-app purchases and trial periods
 */

/// Product IDs for in-app purchases (iOS App Store and Google Play)
class SubscriptionProducts {
  // Starter tier (NEW)
  static const String starterMonthlyIOS = 'taxlien_starter_monthly';
  static const String starterYearlyIOS = 'taxlien_starter_yearly';
  static const String starterMonthlyAndroid = 'taxlien_starter_monthly';
  static const String starterYearlyAndroid = 'taxlien_starter_yearly';

  // Premium tier
  static const String premiumMonthlyIOS = 'taxlien_premium_monthly';
  static const String premiumYearlyIOS = 'taxlien_premium_yearly';
  static const String premiumMonthlyAndroid = 'taxlien_premium_monthly';
  static const String premiumYearlyAndroid = 'taxlien_premium_yearly';

  // Enterprise tier
  static const String enterpriseMonthlyIOS = 'taxlien_enterprise_monthly';
  static const String enterpriseYearlyIOS = 'taxlien_enterprise_yearly';
  static const String enterpriseMonthlyAndroid = 'taxlien_enterprise_monthly';
  static const String enterpriseYearlyAndroid = 'taxlien_enterprise_yearly';

  // All product IDs
  static const Set<String> allProducts = {
    starterMonthlyIOS,
    starterYearlyIOS,
    premiumMonthlyIOS,
    premiumYearlyIOS,
    enterpriseMonthlyIOS,
    enterpriseYearlyIOS,
  };
}

/// Trial configuration
class TrialConfig {
  /// Trial period - 14 days (industry standard)
  /// CHANGED FROM 365 DAYS - Critical revenue optimization
  static const int trialDurationDays = 14;

  /// Trial periods by tier
  static const int starterTrialDays = 7;      // Starter tier
  static const int premiumTrialDays = 14;     // Premium tier
  static const int enterpriseTrialDays = 30;  // Enterprise tier

  /// Show paywall after trial expires
  static const bool showPaywallAfterExpiry = true;

  /// Allow trial restart (for testing only, should be false in production)
  static const bool allowTrialRestart = false;

  /// Grace period after trial expiry (days)
  static const int gracePeriodDays = 3;
}

/// Subscription tier features
class SubscriptionFeatures {
  // Trial tier (NEW)
  static const List<String> trial = premium;

  // Free tier
  static const List<String> free = [
    'Browse tax liens',
    'View basic property information',
    'Access to educational content (Module 1)',
    'Limited search results (10 per day)',
    'Top 10 counties only',
    'Save up to 5 favorites',
  ];

  // Starter tier (NEW)
  static const List<String> starter = [
    'All Free features',
    'Unlimited daily searches',
    'Access to 50 top counties',
    'Save up to 25 favorites',
    '10 AI property analyses per month',
    'Basic property analytics',
    'Investment calculator',
    'Email alerts (daily digest)',
    'Export data (CSV)',
  ];

  // Premium tier
  static const List<String> premium = [
    'All Starter features',
    'Access to ALL 3,000+ counties',
    'Unlimited AI property analyses',
    'Advanced analytics & insights',
    'Real-time bidding',
    'Portfolio management (unlimited)',
    'NFT integration',
    'Priority support',
    'Mobile app access',
    'Export data (CSV, PDF)',
    'Custom alerts (instant push)',
  ];

  // Enterprise tier
  static const List<String> enterprise = [
    'All Premium features',
    'Bulk operations',
    'API access (10,000 requests/month)',
    'Custom reports',
    'Dedicated account manager',
    'White-label options',
    'Multi-user support (up to 10 users)',
    'Advanced integrations',
    'Priority feature requests',
    'SLA guarantee (99.9% uptime)',
  ];
}

/// Pricing information (for display only, actual prices from stores)
class SubscriptionPricing {
  // Starter pricing (NEW)
  static const String starterMonthlyPrice = r'$19.99';
  static const String starterYearlyPrice = r'$199.99';
  static const String starterYearlySavings = r'Save 17% ($39.89)';

  // Premium pricing (UPDATED - was $29.99)
  static const String premiumMonthlyPrice = r'$49.99';
  static const String premiumYearlyPrice = r'$499.99';
  static const String premiumYearlySavings = r'Save 17% ($99.89)';

  // Enterprise pricing (UPDATED - was $99.99)
  static const String enterpriseMonthlyPrice = r'$199.99';
  static const String enterpriseYearlyPrice = r'$1,999.99';
  static const String enterpriseYearlySavings = r'Save 17% ($399.89)';
}

/// Subscription entitlement IDs (for RevenueCat or similar services)
class SubscriptionEntitlements {
  static const String starter = 'starter';
  static const String premium = 'premium';
  static const String enterprise = 'enterprise';
}

/// Feature usage limits by tier
class FeatureLimits {
  // Free tier limits
  static const int freeSearchesPerDay = 10;
  static const int freeAIAnalysesPerMonth = 3;
  static const int freePortfolioSize = 5;
  static const int freeCountiesAccess = 10;

  // Starter tier limits
  static const int starterSearchesPerDay = -1; // Unlimited
  static const int starterAIAnalysesPerMonth = 10;
  static const int starterPortfolioSize = 25;
  static const int starterCountiesAccess = 50;

  // Premium tier limits (all unlimited)
  static const int premiumSearchesPerDay = -1;
  static const int premiumAIAnalysesPerMonth = -1;
  static const int premiumPortfolioSize = -1;
  static const int premiumCountiesAccess = -1;

  // Enterprise tier limits (all unlimited)
  static const int enterpriseSearchesPerDay = -1;
  static const int enterpriseAIAnalysesPerMonth = -1;
  static const int enterprisePortfolioSize = -1;
  static const int enterpriseCountiesAccess = -1;
  static const int enterpriseAPIRequestsPerMonth = 10000;
}
