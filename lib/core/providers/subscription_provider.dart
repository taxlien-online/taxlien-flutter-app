/**
 * @file Subscription Provider
 * @author NativeMind Team
 * 
 * Riverpod provider for subscription and trial state management
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/trial_service.dart';

/// Trial Service Provider
final trialServiceProvider = Provider<TrialService>((ref) {
  final service = TrialService();

  // Initialize on first access
  service.initialize();

  // Dispose when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Trial Status Provider
final trialStatusProvider =
    StateNotifierProvider<TrialStatusNotifier, TrialStatus>((ref) {
  final service = ref.watch(trialServiceProvider);
  return TrialStatusNotifier(service);
});

/// Trial Status Notifier
class TrialStatusNotifier extends StateNotifier<TrialStatus> {
  final TrialService _trialService;

  TrialStatusNotifier(this._trialService) : super(_trialService.trialStatus) {
    // Listen to trial service changes
    _trialService.addListener(_onTrialServiceChanged);
  }

  void _onTrialServiceChanged() {
    state = _trialService.trialStatus;
  }

  /// Start trial
  Future<bool> startTrial() async {
    final success = await _trialService.startTrial();
    if (success) {
      state = _trialService.trialStatus;
    }
    return success;
  }

  /// Refresh trial status
  Future<void> refresh() async {
    await _trialService.initialize();
    state = _trialService.trialStatus;
  }

  @override
  void dispose() {
    _trialService.removeListener(_onTrialServiceChanged);
    super.dispose();
  }
}

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
