/**
 * @file Subscription and Trial Constants
 * @author NativeMind Team
 * 
 * Configuration for in-app purchases and trial periods
 */

/// Product IDs for in-app purchases (iOS App Store and Google Play)
class SubscriptionProducts {
  // iOS Product IDs
  static const String premiumMonthlyIOS = 'taxlien_premium_monthly';
  static const String premiumYearlyIOS = 'taxlien_premium_yearly';
  static const String enterpriseMonthlyIOS = 'taxlien_enterprise_monthly';
  static const String enterpriseYearlyIOS = 'taxlien_enterprise_yearly';

  // Android Product IDs (same as iOS for consistency)
  static const String premiumMonthlyAndroid = 'taxlien_premium_monthly';
  static const String premiumYearlyAndroid = 'taxlien_premium_yearly';
  static const String enterpriseMonthlyAndroid = 'taxlien_enterprise_monthly';
  static const String enterpriseYearlyAndroid = 'taxlien_enterprise_yearly';

  // All product IDs
  static const Set<String> allProducts = {
    premiumMonthlyIOS,
    premiumYearlyIOS,
    enterpriseMonthlyIOS,
    enterpriseYearlyIOS,
  };
}

/// Trial configuration
class TrialConfig {
  /// МАКСИМАЛЬНО ДОЛГИЙ TRIAL ПЕРИОД - 365 дней (1 год)
  static const int trialDurationDays = 365;

  /// Show paywall after trial expires
  static const bool showPaywallAfterExpiry = true;

  /// Allow trial restart (for testing only, should be false in production)
  static const bool allowTrialRestart = false;
}

/// Subscription tier features
class SubscriptionFeatures {
  // Free tier
  static const List<String> free = [
    'Browse tax liens',
    'View basic property information',
    'Access to educational content',
    'Limited search results (10 per day)',
  ];

  // Trial tier (same as Premium for trial period)
  static const List<String> trial = [
    'All Free features',
    'Unlimited search results',
    'Advanced filters and sorting',
    'Property analytics',
    'Investment calculator',
    'Save favorites (unlimited)',
    'Email alerts',
    'Premium support',
    '365 days trial period',
  ];

  // Premium tier
  static const List<String> premium = [
    'All Trial features',
    'Real-time bidding',
    'Portfolio management',
    'NFT integration',
    'Advanced analytics',
    'Priority support',
    'Mobile app access',
    'Export data (CSV, PDF)',
  ];

  // Enterprise tier
  static const List<String> enterprise = [
    'All Premium features',
    'Bulk operations',
    'API access',
    'Custom reports',
    'Dedicated account manager',
    'White-label options',
    'Multi-user support',
    'Advanced integrations',
  ];
}

/// Pricing information (for display only, actual prices from stores)
class SubscriptionPricing {
  // Premium pricing
  static const String premiumMonthlyPrice = '\$29.99';
  static const String premiumYearlyPrice = '\$299.99';
  static const String premiumYearlySavings = 'Save 17%';

  // Enterprise pricing
  static const String enterpriseMonthlyPrice = '\$99.99';
  static const String enterpriseYearlyPrice = '\$999.99';
  static const String enterpriseYearlySavings = 'Save 17%';
}

/// Subscription entitlement IDs (for RevenueCat or similar services)
class SubscriptionEntitlements {
  static const String premium = 'premium';
  static const String enterprise = 'enterprise';
}
