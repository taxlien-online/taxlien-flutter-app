/**
 * @file Trial and Subscription Service for TaxLien.online
 * @author NativeMind Team
 * 
 * Manages trial period, in-app purchases, and subscription state
 * Similar to legacy vedicgames-trials implementation
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../core/constants/subscription_constants.dart';

/// Subscription tier enum
enum SubscriptionTier {
  free,
  trial,
  starter,
  premium,
  enterprise,
}

/// Trial status
class TrialStatus {
  final bool isActive;
  final bool isExpired;
  final DateTime? startDate;
  final DateTime? endDate;
  final int daysRemaining;
  final SubscriptionTier tier;

  const TrialStatus({
    required this.isActive,
    required this.isExpired,
    this.startDate,
    this.endDate,
    required this.daysRemaining,
    required this.tier,
  });

  bool get hasAccess =>
      isActive ||
      tier == SubscriptionTier.starter ||
      tier == SubscriptionTier.premium ||
      tier == SubscriptionTier.enterprise;
}

/// Trial and Subscription Service
class TrialService extends ChangeNotifier {
  static const String _trialStartKey = 'trial_start_date';
  static const String _trialEndKey = 'trial_end_date';
  static const String _subscriptionTierKey = 'subscription_tier';
  static const String _hasCompletedTrialKey = 'has_completed_trial';

  // Industry standard trial period
  static const int trialDurationDays = TrialConfig.trialDurationDays;

  // In-App Purchase configuration
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // State
  TrialStatus _trialStatus = const TrialStatus(
    isActive: false,
    isExpired: false,
    daysRemaining: 0,
    tier: SubscriptionTier.free,
  );

  bool _isInitialized = false;
  List<ProductDetails> _products = [];

  // Getters
  TrialStatus get trialStatus => _trialStatus;
  bool get isInitialized => _isInitialized;
  List<ProductDetails> get products => _products;
  bool get hasAccess => _trialStatus.hasAccess;

  /// Initialize trial service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Check if IAP is available
      final bool available = await _iap.isAvailable();
      if (!available) {
        debugPrint('TrialService: In-App Purchase not available');
        // Still load trial status from local storage
      } else {
        // Setup purchase listener
        _subscription = _iap.purchaseStream.listen(
          _onPurchaseUpdate,
          onDone: _onPurchaseDone,
          onError: _onPurchaseError,
        );
      }

      // Load trial status
      await _loadTrialStatus();

      // Load products (non-blocking)
      _loadProducts();

      _isInitialized = true;
      debugPrint('TrialService: Initialized successfully');
      debugPrint(
          'TrialService: Trial days remaining: ${_trialStatus.daysRemaining}');
      debugPrint('TrialService: Has access: ${_trialStatus.hasAccess}');
    } catch (e) {
      debugPrint('TrialService: Error initializing: $e');
      // Initialize with default free tier
      _trialStatus = const TrialStatus(
        isActive: false,
        isExpired: false,
        daysRemaining: 0,
        tier: SubscriptionTier.free,
      );
    }

    notifyListeners();
  }

  /// Start trial period
  Future<bool> startTrial() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if trial was already completed
      final hasCompletedTrial = prefs.getBool(_hasCompletedTrialKey) ?? false;
      if (hasCompletedTrial) {
        debugPrint('TrialService: Trial already completed');
        return false;
      }

      // Check if trial is already active
      final currentTier = prefs.getString(_subscriptionTierKey);
      if (currentTier == SubscriptionTier.trial.name) {
        debugPrint('TrialService: Trial already active');
        return false;
      }

      // Start new trial
      final now = DateTime.now();
      final endDate = now.add(Duration(days: trialDurationDays));

      await prefs.setString(_trialStartKey, now.toIso8601String());
      await prefs.setString(_trialEndKey, endDate.toIso8601String());
      await prefs.setString(_subscriptionTierKey, SubscriptionTier.trial.name);

      // Reload status
      await _loadTrialStatus();

      debugPrint('TrialService: Trial started for $trialDurationDays days');
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('TrialService: Error starting trial: $e');
      return false;
    }
  }

  /// Load trial status from storage
  Future<void> _loadTrialStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final tierName = prefs.getString(_subscriptionTierKey);
      final tier = tierName != null
          ? SubscriptionTier.values.firstWhere(
              (t) => t.name == tierName || t.toString().split('.').last == tierName,
              orElse: () => SubscriptionTier.free,
            )
          : SubscriptionTier.free;

      if (tier == SubscriptionTier.trial) {
        final startDateStr = prefs.getString(_trialStartKey);
        final endDateStr = prefs.getString(_trialEndKey);

        if (startDateStr != null && endDateStr != null) {
          final startDate = DateTime.parse(startDateStr);
          final endDate = DateTime.parse(endDateStr);
          final now = DateTime.now();

          final isActive = now.isBefore(endDate);
          final isExpired = now.isAfter(endDate);
          final daysRemaining = isActive ? endDate.difference(now).inDays : 0;

          _trialStatus = TrialStatus(
            isActive: isActive,
            isExpired: isExpired,
            startDate: startDate,
            endDate: endDate,
            daysRemaining: daysRemaining,
            tier: tier,
          );

          // If trial expired, mark as completed
          if (isExpired) {
            await prefs.setBool(_hasCompletedTrialKey, true);
            await prefs.setString(
                _subscriptionTierKey, SubscriptionTier.free.name);

            _trialStatus = TrialStatus(
              isActive: false,
              isExpired: true,
              startDate: startDate,
              endDate: endDate,
              daysRemaining: 0,
              tier: SubscriptionTier.free,
            );
          }
        } else {
          // No valid trial dates, reset to free
          _trialStatus = const TrialStatus(
            isActive: false,
            isExpired: false,
            daysRemaining: 0,
            tier: SubscriptionTier.free,
          );
        }
      } else if (tier == SubscriptionTier.premium ||
          tier == SubscriptionTier.enterprise) {
        // User has active subscription
        _trialStatus = TrialStatus(
          isActive: false,
          isExpired: false,
          daysRemaining: 0,
          tier: tier,
        );
      } else {
        // Free tier
        _trialStatus = const TrialStatus(
          isActive: false,
          isExpired: false,
          daysRemaining: 0,
          tier: SubscriptionTier.free,
        );
      }
    } catch (e) {
      debugPrint('TrialService: Error loading trial status: $e');
      _trialStatus = const TrialStatus(
        isActive: false,
        isExpired: false,
        daysRemaining: 0,
        tier: SubscriptionTier.free,
      );
    }
  }

  /// Load available products
  Future<void> _loadProducts() async {
    try {
      final Set<String> productIds = SubscriptionProducts.allProducts;

      final ProductDetailsResponse response =
          await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('TrialService: Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      debugPrint('TrialService: Loaded ${_products.length} products');

      notifyListeners();
    } catch (e) {
      debugPrint('TrialService: Error loading products: $e');
    }
  }

  /// Purchase a product
  Future<bool> purchaseProduct(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);

      final bool success =
          await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      debugPrint('TrialService: Purchase initiated: $success');
      return success;
    } catch (e) {
      debugPrint('TrialService: Error purchasing product: $e');
      return false;
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      debugPrint('TrialService: Restore purchases initiated');
    } catch (e) {
      debugPrint('TrialService: Error restoring purchases: $e');
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint('TrialService: Purchase pending');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('TrialService: Purchase error: ${purchaseDetails.error}');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Verify and deliver product
        await _verifyAndDeliverProduct(purchaseDetails);
      }

      // Complete purchase
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  /// Verify and deliver purchased product
  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Determine tier based on product ID
      SubscriptionTier tier = SubscriptionTier.premium;
      if (purchaseDetails.productID.contains('enterprise')) {
        tier = SubscriptionTier.enterprise;
      } else if (purchaseDetails.productID.contains('starter')) {
        tier = SubscriptionTier.starter;
      }

      // Update subscription tier
      await prefs.setString(_subscriptionTierKey, tier.name);

      // Reload status
      await _loadTrialStatus();

      debugPrint(
          'TrialService: Purchase verified and delivered: ${purchaseDetails.productID}');
      notifyListeners();
    } catch (e) {
      debugPrint('TrialService: Error verifying purchase: $e');
    }
  }

  void _onPurchaseDone() {
    debugPrint('TrialService: Purchase stream done');
  }

  void _onPurchaseError(error) {
    debugPrint('TrialService: Purchase stream error: $error');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
