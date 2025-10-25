/**
 * @file Subscription Provider
 * @author NativeMind Team
 * 
 * Riverpod provider for subscription and trial state management
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/trial_service.dart';

/// Trial Service Provider (ChangeNotifier based)
final trialServiceProvider = ChangeNotifierProvider<TrialService>((ref) {
  final service = TrialService();

  // Initialize on first access
  service.initialize();

  return service;
});

/// Trial Status Provider
final trialStatusProvider = Provider<TrialStatus>((ref) {
  final service = ref.watch(trialServiceProvider);
  return service.trialStatus;
});

/// Has Access Provider (computed)
final hasAccessProvider = Provider<bool>((ref) {
  final trialStatus = ref.watch(trialStatusProvider);
  return trialStatus.hasAccess;
});

/// Is Premium Provider (computed)
final isPremiumProvider = Provider<bool>((ref) {
  final trialStatus = ref.watch(trialStatusProvider);
  return trialStatus.tier == SubscriptionTier.premium ||
      trialStatus.tier == SubscriptionTier.enterprise;
});

/// Is Trial Active Provider (computed)
final isTrialActiveProvider = Provider<bool>((ref) {
  final trialStatus = ref.watch(trialStatusProvider);
  return trialStatus.isActive;
});

/// Subscription Tier Provider (computed)
final subscriptionTierProvider = Provider<SubscriptionTier>((ref) {
  final trialStatus = ref.watch(trialStatusProvider);
  return trialStatus.tier;
});
