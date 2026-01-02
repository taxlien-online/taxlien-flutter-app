import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/detective_constants.dart';

/// Service for managing daily swipe limits
///
/// Timezone-aware reset at midnight for free users
class DailyLimitService {
  static final DailyLimitService _instance = DailyLimitService._internal();
  factory DailyLimitService() => _instance;
  DailyLimitService._internal();

  static DailyLimitService get instance => _instance;

  static const String _keySwipeCount = 'detective_daily_swipe_count';
  static const String _keyLastResetDate = 'detective_last_reset_date';
  static const String _keyUndoCount = 'detective_daily_undo_count';

  /// Get current swipe count for today
  Future<int> getSwipeCount() async {
    await _checkAndResetIfNeeded();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keySwipeCount) ?? 0;
  }

  /// Increment swipe count
  Future<void> incrementSwipeCount() async {
    await _checkAndResetIfNeeded();
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_keySwipeCount) ?? 0;
    await prefs.setInt(_keySwipeCount, currentCount + 1);
  }

  /// Decrement swipe count (for undo)
  Future<void> decrementSwipeCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_keySwipeCount) ?? 0;
    if (currentCount > 0) {
      await prefs.setInt(_keySwipeCount, currentCount - 1);
    }
  }

  /// Get current undo count for today
  Future<int> getUndoCount() async {
    await _checkAndResetIfNeeded();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUndoCount) ?? 0;
  }

  /// Increment undo count
  Future<void> incrementUndoCount() async {
    await _checkAndResetIfNeeded();
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_keyUndoCount) ?? 0;
    await prefs.setInt(_keyUndoCount, currentCount + 1);
  }

  /// Check if user can swipe (under daily limit)
  Future<bool> canSwipe({required bool isPremium}) async {
    if (isPremium) return true; // Premium users have unlimited swipes

    final count = await getSwipeCount();
    return count < DetectiveConstants.freeDailySwipeLimit;
  }

  /// Check if user can undo (under daily limit)
  Future<bool> canUndo({required bool isPremium}) async {
    if (isPremium) return true; // Premium users have unlimited undos

    final count = await getUndoCount();
    return count < DetectiveConstants.freeUndoLimit;
  }

  /// Get remaining swipes for free users
  Future<int> getRemainingSwipes({required bool isPremium}) async {
    if (isPremium) return -1; // -1 indicates unlimited

    final count = await getSwipeCount();
    final remaining = DetectiveConstants.freeDailySwipeLimit - count;
    return remaining < 0 ? 0 : remaining;
  }

  /// Get remaining undos for free users
  Future<int> getRemainingUndos({required bool isPremium}) async {
    if (isPremium) return -1; // -1 indicates unlimited

    final count = await getUndoCount();
    final remaining = DetectiveConstants.freeUndoLimit - count;
    return remaining < 0 ? 0 : remaining;
  }

  /// Get time until next reset
  Future<Duration> getTimeUntilReset() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  /// Get formatted time until reset
  Future<String> getTimeUntilResetFormatted() async {
    final duration = await getTimeUntilReset();
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Check if reset is needed and perform reset
  Future<void> _checkAndResetIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetDateStr = prefs.getString(_keyLastResetDate);

    // Get current date (midnight)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayStr = today.toIso8601String();

    // If no last reset date or it's a different day, reset
    if (lastResetDateStr == null || lastResetDateStr != todayStr) {
      await _performReset(todayStr);
    }
  }

  /// Perform daily reset
  Future<void> _performReset(String dateStr) async {
    final prefs = await SharedPreferences.getInstance();

    // Reset counters
    await prefs.setInt(_keySwipeCount, 0);
    await prefs.setInt(_keyUndoCount, 0);

    // Update last reset date
    await prefs.setString(_keyLastResetDate, dateStr);

    debugPrint('Daily limits reset for date: $dateStr');
  }

  /// Manually reset (for testing or admin)
  Future<void> manualReset() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    await _performReset(today.toIso8601String());
  }

  /// Get usage statistics
  Future<Map<String, dynamic>> getUsageStats({required bool isPremium}) async {
    final swipeCount = await getSwipeCount();
    final undoCount = await getUndoCount();
    final timeUntilReset = await getTimeUntilResetFormatted();

    return {
      'swipes_used': swipeCount,
      'swipes_limit': isPremium
          ? DetectiveConstants.paidDailySwipeLimit
          : DetectiveConstants.freeDailySwipeLimit,
      'swipes_remaining': await getRemainingSwipes(isPremium: isPremium),
      'undos_used': undoCount,
      'undos_limit': isPremium
          ? DetectiveConstants.paidUndoLimit
          : DetectiveConstants.freeUndoLimit,
      'undos_remaining': await getRemainingUndos(isPremium: isPremium),
      'time_until_reset': timeUntilReset,
      'is_premium': isPremium,
    };
  }

  /// Check if approaching limit (80% used)
  Future<bool> isApproachingLimit({required bool isPremium}) async {
    if (isPremium) return false;

    final count = await getSwipeCount();
    final limit = DetectiveConstants.freeDailySwipeLimit;
    return count >= (limit * 0.8);
  }

  /// Get warning message if approaching limit
  Future<String?> getLimitWarning({required bool isPremium}) async {
    if (isPremium) return null;

    final remaining = await getRemainingSwipes(isPremium: isPremium);

    if (remaining <= 0) {
      final timeUntilReset = await getTimeUntilResetFormatted();
      return 'Daily limit reached. Resets in $timeUntilReset';
    } else if (remaining <= 5) {
      return '$remaining swipes remaining today';
    } else if (remaining <= 10) {
      return '$remaining swipes left';
    }

    return null;
  }
}
