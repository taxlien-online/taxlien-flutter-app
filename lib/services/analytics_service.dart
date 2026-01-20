import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import '../core/config/api_config.dart';
import 'trial_service.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Singleton pattern
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  /// Log custom event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!ApiConfig.enableAnalytics) return;

    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
    if (kDebugMode) {
      print('📊 Analytics Log: $name - $parameters');
    }
  }

  /// Set user properties (tier, cohort, etc.)
  Future<void> setUserProperties({
    required String tier,
    String? cohort,
  }) async {
    if (!ApiConfig.enableAnalytics) return;

    await _analytics.setUserProperty(name: 'subscription_tier', value: tier);
    if (cohort != null) {
      await _analytics.setUserProperty(name: 'user_cohort', value: cohort);
    }
  }

  /// Log Screen View
  Future<void> logScreenView(String screenName) async {
    if (!ApiConfig.enableAnalytics) return;
    await _analytics.logScreenView(screenName: screenName);
  }

  // Helper methods for specific conversion events
  
  Future<void> logPaywallView(String reason) async {
    await logEvent(name: 'paywall_view', parameters: {'reason': reason});
  }

  Future<void> logSubscriptionConvert(String tier, String source) async {
    await logEvent(name: 'subscription_convert', parameters: {
      'new_tier': tier,
      'source': source,
    });
  }

  Future<void> logQuizPass(String lessonId, int score) async {
    await logEvent(name: 'edu_quiz_pass', parameters: {
      'lesson_id': lessonId,
      'score': score,
    });
  }

  Future<void> logReferralShare(String platform) async {
    await logEvent(name: 'referral_share', parameters: {'platform': platform});
  }

  Future<void> logFeeCollected(String type, double amount) async {
    await logEvent(name: 'fee_collected', parameters: {
      'fee_type': type,
      'amount': amount,
    });
  }
}
