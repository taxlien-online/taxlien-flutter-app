import 'package:flutter/material.dart';
import 'trial_service.dart';
import 'education_service.dart';
import '../core/constants/subscription_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PaywallReason {
  searchLockedByEdu,
  aiLockedByEdu,
  countyLockedByEdu,
  searchLimitReached,
  aiLimitReached,
  portfolioLimitReached,
  countyAccessDenied,
  premiumFeatureRequired,
}

class PaywallTriggerService extends ChangeNotifier {
  final TrialService _trialService;
  final EducationService? _educationService;
  static const String _searchesTodayKey = 'searches_today_count';
  static const String _lastSearchDateKey = 'last_search_date';
  static const String _aiAnalysesMonthKey = 'ai_analyses_month_count';
  static const String _lastAIAnalysisMonthKey = 'last_ai_analysis_month';

  PaywallTriggerService(this._trialService, [this._educationService]);

  SubscriptionTier get _currentTier => _trialService.trialStatus.tier;

  /// Check if user should be redirected to paywall for a specific action
  Future<PaywallReason?> checkTrigger(String action,
      {Map<String, dynamic>? context}) async {
    final tier = _currentTier;

    // First check education gates for non-premium users
    if (tier != SubscriptionTier.premium && tier != SubscriptionTier.enterprise) {
      if (action == 'search' && !(_educationService?.hasAchievement('feature_search') ?? true)) {
        return PaywallReason.searchLockedByEdu;
      }
      if (action == 'ai_analysis' && !(_educationService?.hasAchievement('feature_ai_predictions') ?? true)) {
        return PaywallReason.aiLockedByEdu;
      }
      if (action == 'access_county' && !(_educationService?.hasAchievement('feature_county_data') ?? true)) {
        return PaywallReason.countyLockedByEdu;
      }
    }

    // Premium and Enterprise have no limits
    if (tier == SubscriptionTier.premium ||
        tier == SubscriptionTier.enterprise) {
      return null;
    }

    if (action == 'search') {
      return await _checkSearchLimit(tier);
    } else if (action == 'ai_analysis') {
      return await _checkAILimit(tier);
    } else if (action == 'access_county') {
      return _checkCountyAccess(tier, context?['county']);
    } else if (action == 'premium_feature') {
      return PaywallReason.premiumFeatureRequired;
    }

    return null;
  }

  Future<PaywallReason?> _checkSearchLimit(SubscriptionTier tier) async {
    if (tier == SubscriptionTier.starter) return null; // Starter has unlimited search

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastDate = prefs.getString(_lastSearchDateKey) ?? '';

    int count = 0;
    if (lastDate == today) {
      count = prefs.getInt(_searchesTodayKey) ?? 0;
    } else {
      await prefs.setString(_lastSearchDateKey, today);
      await prefs.setInt(_searchesTodayKey, 0);
    }

    if (count >= FeatureLimits.freeSearchesPerDay) {
      return PaywallReason.searchLimitReached;
    }

    return null;
  }

  Future<void> recordSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastDate = prefs.getString(_lastSearchDateKey) ?? '';
    
    int count = 0;
    if (lastDate == today) {
      count = prefs.getInt(_searchesTodayKey) ?? 0;
    }
    
    await prefs.setInt(_searchesTodayKey, count + 1);
    await prefs.setString(_lastSearchDateKey, today);
  }

  Future<PaywallReason?> _checkAILimit(SubscriptionTier tier) async {
    final prefs = await SharedPreferences.getInstance();
    final thisMonth = "${DateTime.now().year}-${DateTime.now().month}";
    final lastMonth = prefs.getString(_lastAIAnalysisMonthKey) ?? '';

    int count = 0;
    if (lastMonth == thisMonth) {
      count = prefs.getInt(_aiAnalysesMonthKey) ?? 0;
    } else {
      await prefs.setString(_lastAIAnalysisMonthKey, thisMonth);
      await prefs.setInt(_aiAnalysesMonthKey, 0);
    }

    final limit = (tier == SubscriptionTier.free || tier == SubscriptionTier.trial)
        ? FeatureLimits.freeAIAnalysesPerMonth
        : (tier == SubscriptionTier.starter ? FeatureLimits.starterAIAnalysesPerMonth : -1);

    if (limit != -1 && count >= limit) {
      return PaywallReason.aiLimitReached;
    }

    return null;
  }

  Future<void> recordAIAnalysis() async {
    final prefs = await SharedPreferences.getInstance();
    final thisMonth = "${DateTime.now().year}-${DateTime.now().month}";
    final lastMonth = prefs.getString(_lastAIAnalysisMonthKey) ?? '';
    
    int count = 0;
    if (lastMonth == thisMonth) {
      count = prefs.getInt(_aiAnalysesMonthKey) ?? 0;
    }
    
    await prefs.setInt(_aiAnalysesMonthKey, count + 1);
    await prefs.setString(_lastAIAnalysisMonthKey, thisMonth);
  }

  PaywallReason? _checkCountyAccess(SubscriptionTier tier, String? county) {
    if (tier == SubscriptionTier.free || tier == SubscriptionTier.trial) {
      // Logic for Top 10 counties check
      // For now, assume some counties are restricted
      final restrictedCounties = ['Palm Beach', 'Miami-Dade', 'Orange']; 
      if (restrictedCounties.contains(county)) {
        return PaywallReason.countyAccessDenied;
      }
    }
    return null;
  }
}
