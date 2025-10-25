/**
 * @file Trial Service Tests
 * @author NativeMind Team
 * 
 * Unit tests for trial and subscription functionality
 */

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TaxLien.online/services/trial_service.dart';
import 'package:TaxLien.online/core/constants/subscription_constants.dart';

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TrialService Tests', () {
    late TrialService trialService;

    setUp(() async {
      // Initialize shared preferences for testing
      SharedPreferences.setMockInitialValues({});
      trialService = TrialService();

      // Mock in_app_purchase channel to avoid platform errors
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/in_app_purchase'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'isAvailable') {
            return false; // Mock that IAP is not available in tests
          }
          return null;
        },
      );

      await trialService.initialize();
    });

    tearDown(() {
      trialService.dispose();
    });

    test('Initial state should be free tier with no trial', () async {
      expect(trialService.trialStatus.tier, SubscriptionTier.free);
      expect(trialService.trialStatus.isActive, false);
      expect(trialService.trialStatus.isExpired, false);
      expect(trialService.trialStatus.daysRemaining, 0);
    });

    test('Should start 365-day trial successfully', () async {
      final success = await trialService.startTrial();

      expect(success, true);
      expect(trialService.trialStatus.tier, SubscriptionTier.trial);
      expect(trialService.trialStatus.isActive, true);
      expect(trialService.trialStatus.isExpired, false);
      expect(trialService.trialStatus.daysRemaining,
          greaterThanOrEqualTo(364)); // Allow for timing
      expect(trialService.trialStatus.daysRemaining, lessThanOrEqualTo(365));
    });

    test('Trial should grant access', () async {
      await trialService.startTrial();

      expect(trialService.hasAccess, true);
      expect(trialService.trialStatus.hasAccess, true);
    });

    test('Should not allow trial restart', () async {
      // Start trial first time
      final firstStart = await trialService.startTrial();
      expect(firstStart, true);

      // Try to start again
      final secondStart = await trialService.startTrial();
      expect(secondStart, false);
    });

    test('Trial dates should be correct', () async {
      final now = DateTime.now();
      await trialService.startTrial();

      final status = trialService.trialStatus;

      expect(status.startDate, isNotNull);
      expect(status.endDate, isNotNull);

      final startDate = status.startDate!;
      final endDate = status.endDate!;

      // Start date should be within last minute
      expect(startDate.difference(now).inMinutes.abs(), lessThan(1));

      // End date should be ~365 days from start
      final duration = endDate.difference(startDate).inDays;
      expect(duration, equals(TrialConfig.trialDurationDays));
    });

    test('Premium tier should grant access', () async {
      // Simulate premium purchase
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('subscription_tier', SubscriptionTier.premium.name);

      // Reload service
      await trialService.initialize();

      expect(trialService.hasAccess, true);
      expect(trialService.trialStatus.tier, SubscriptionTier.premium);
    });

    test('Enterprise tier should grant access', () async {
      // Simulate enterprise purchase
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'subscription_tier', SubscriptionTier.enterprise.name);

      // Reload service
      await trialService.initialize();

      expect(trialService.hasAccess, true);
      expect(trialService.trialStatus.tier, SubscriptionTier.enterprise);
    });

    test('Free tier should not grant access', () async {
      expect(trialService.hasAccess, false);
      expect(trialService.trialStatus.tier, SubscriptionTier.free);
    });

    test('Expired trial should not grant access', () async {
      // Simulate expired trial
      final now = DateTime.now();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('trial_start_date',
          now.subtract(Duration(days: 400)).toIso8601String());
      await prefs.setString(
          'trial_end_date', now.subtract(Duration(days: 35)).toIso8601String());
      await prefs.setString('subscription_tier', SubscriptionTier.trial.name);

      // Reload service
      await trialService.initialize();

      expect(trialService.trialStatus.isExpired, true);
      expect(trialService.trialStatus.isActive, false);
      expect(trialService.hasAccess, false);
      expect(trialService.trialStatus.tier, SubscriptionTier.free);
    });

    test('Trial config should have correct duration', () {
      expect(TrialConfig.trialDurationDays, 365);
    });

    test('Subscription products should be defined', () {
      expect(SubscriptionProducts.allProducts.length, greaterThan(0));
      expect(SubscriptionProducts.allProducts,
          contains('taxlien_premium_monthly'));
      expect(
          SubscriptionProducts.allProducts, contains('taxlien_premium_yearly'));
      expect(SubscriptionProducts.allProducts,
          contains('taxlien_enterprise_monthly'));
      expect(SubscriptionProducts.allProducts,
          contains('taxlien_enterprise_yearly'));
    });

    test('Subscription features should be defined for all tiers', () {
      expect(SubscriptionFeatures.free.length, greaterThan(0));
      expect(SubscriptionFeatures.trial.length, greaterThan(0));
      expect(SubscriptionFeatures.premium.length, greaterThan(0));
      expect(SubscriptionFeatures.enterprise.length, greaterThan(0));

      // Trial should have more features than free
      expect(SubscriptionFeatures.trial.length,
          greaterThan(SubscriptionFeatures.free.length));

      // Premium should have more features than trial
      expect(SubscriptionFeatures.premium.length,
          greaterThan(SubscriptionFeatures.trial.length));

      // Enterprise should have most features
      expect(SubscriptionFeatures.enterprise.length,
          greaterThan(SubscriptionFeatures.premium.length));
    });
  });

  group('TrialStatus Tests', () {
    test('Should calculate hasAccess correctly', () {
      // Active trial
      final activeTrial = TrialStatus(
        isActive: true,
        isExpired: false,
        daysRemaining: 100,
        tier: SubscriptionTier.trial,
      );
      expect(activeTrial.hasAccess, true);

      // Premium subscription
      final premium = TrialStatus(
        isActive: false,
        isExpired: false,
        daysRemaining: 0,
        tier: SubscriptionTier.premium,
      );
      expect(premium.hasAccess, true);

      // Enterprise subscription
      final enterprise = TrialStatus(
        isActive: false,
        isExpired: false,
        daysRemaining: 0,
        tier: SubscriptionTier.enterprise,
      );
      expect(enterprise.hasAccess, true);

      // Free tier
      final free = TrialStatus(
        isActive: false,
        isExpired: false,
        daysRemaining: 0,
        tier: SubscriptionTier.free,
      );
      expect(free.hasAccess, false);

      // Expired trial
      final expired = TrialStatus(
        isActive: false,
        isExpired: true,
        daysRemaining: 0,
        tier: SubscriptionTier.free,
      );
      expect(expired.hasAccess, false);
    });
  });
}
