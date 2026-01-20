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
    });

    tearDown(() {
      trialService.dispose();
    });

    test('Initial state should be free tier with no trial', () async {
      await trialService.initialize();
      expect(trialService.trialStatus.tier, SubscriptionTier.free);
      expect(trialService.trialStatus.isActive, false);
      expect(trialService.trialStatus.isExpired, false);
      expect(trialService.trialStatus.daysRemaining, 0);
    });

    test('Should start 14-day trial successfully', () async {
      await trialService.initialize();
      final success = await trialService.startTrial();

      expect(success, true);
      expect(trialService.trialStatus.tier, SubscriptionTier.trial);
      expect(trialService.trialStatus.isActive, true);
      expect(trialService.trialStatus.isExpired, false);
      expect(trialService.trialStatus.daysRemaining,
          greaterThanOrEqualTo(13)); // Allow for timing
      expect(trialService.trialStatus.daysRemaining,
          lessThanOrEqualTo(14));
    });

    test('Trial should grant access', () async {
      await trialService.initialize();
      await trialService.startTrial();

      expect(trialService.hasAccess, true);
      expect(trialService.trialStatus.hasAccess, true);
    });

    test('Should not allow trial restart', () async {
      await trialService.initialize();
      // Start trial first time
      final firstStart = await trialService.startTrial();
      expect(firstStart, true);

      // Try to start again
      final secondStart = await trialService.startTrial();
      expect(secondStart, false);
    });

    test('Trial dates should be correct', () async {
      await trialService.initialize();
      final now = DateTime.now();
      await trialService.startTrial();

      final status = trialService.trialStatus;

      expect(status.startDate, isNotNull);
      expect(status.endDate, isNotNull);

      final startDate = status.startDate!;
      final endDate = status.endDate!;

      // Start date should be within last minute
      expect(startDate.difference(now).inMinutes.abs(), lessThan(1));

      // End date should be ~14 days from start
      final duration = endDate.difference(startDate).inDays;
      expect(duration, equals(TrialConfig.trialDurationDays));
    });

    test('Premium tier should grant access', () async {
      // Simulate premium purchase
      SharedPreferences.setMockInitialValues({'subscription_tier': 'premium'});

      await trialService.initialize();

      expect(trialService.trialStatus.tier, SubscriptionTier.premium);
      expect(trialService.hasAccess, true);
    });

    test('Enterprise tier should grant access', () async {
      // Simulate enterprise purchase
      SharedPreferences.setMockInitialValues(
          {'subscription_tier': 'enterprise'});

      await trialService.initialize();

      expect(trialService.trialStatus.tier, SubscriptionTier.enterprise);
      expect(trialService.hasAccess, true);
    });

    test('Free tier should not grant access', () async {
      await trialService.initialize();
      expect(trialService.hasAccess, false);
      expect(trialService.trialStatus.tier, SubscriptionTier.free);
    });

    test('Expired trial should not grant access', () async {
      // Simulate expired trial
      final now = DateTime.now();
      SharedPreferences.setMockInitialValues({
        'trial_start_date': now.subtract(Duration(days: 20)).toIso8601String(),
        'trial_end_date': now.subtract(Duration(days: 6)).toIso8601String(),
        'subscription_tier': 'trial',
      });

      await trialService.initialize();

      // The service should have marked it as expired and reverted to free
      expect(trialService.trialStatus.isExpired, true);
      expect(trialService.trialStatus.isActive, false);
      expect(trialService.hasAccess, false);
      expect(trialService.trialStatus.tier, SubscriptionTier.free);
    });

    test('Trial config should have correct duration', () {
      expect(TrialConfig.trialDurationDays, 14);
    });

    test('Subscription products should be defined', () {
      expect(SubscriptionProducts.allProducts.length, greaterThan(0));
      expect(SubscriptionProducts.allProducts,
          contains('taxlien_starter_monthly'));
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
      expect(SubscriptionFeatures.starter.length, greaterThan(0));
      expect(SubscriptionFeatures.premium.length, greaterThan(0));
      expect(SubscriptionFeatures.enterprise.length, greaterThan(0));
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
