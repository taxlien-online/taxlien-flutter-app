import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/leaderboard_entry.dart';
import '../constants/simulator_constants.dart';

/// Service for leaderboard functionality
///
/// Handles fetching leaderboard data and submitting scores
class LeaderboardService {
  static final LeaderboardService _instance = LeaderboardService._internal();
  factory LeaderboardService() => _instance;
  LeaderboardService._internal();

  static LeaderboardService get instance => _instance;

  // Cache for leaderboard data
  List<LeaderboardEntry>? _cachedWeeklyLeaderboard;
  List<LeaderboardEntry>? _cachedAllTimeLeaderboard;
  DateTime? _lastFetchTime;
  static const _cacheDuration = Duration(minutes: 5);

  // ===== PUBLIC API =====

  /// Fetch weekly leaderboard
  Future<List<LeaderboardEntry>> getWeeklyLeaderboard({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _cachedWeeklyLeaderboard != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _cachedWeeklyLeaderboard!;
    }

    try {
      final entries = await _fetchLeaderboard(period: 'weekly');
      _cachedWeeklyLeaderboard = entries;
      _lastFetchTime = DateTime.now();
      return entries;
    } catch (e) {
      debugPrint('❌ Failed to fetch weekly leaderboard: $e');
      // Return cached data if available
      if (_cachedWeeklyLeaderboard != null) {
        return _cachedWeeklyLeaderboard!;
      }
      // Return mock data if no cache
      return _getMockLeaderboard();
    }
  }

  /// Fetch all-time leaderboard
  Future<List<LeaderboardEntry>> getAllTimeLeaderboard({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _cachedAllTimeLeaderboard != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _cachedAllTimeLeaderboard!;
    }

    try {
      final entries = await _fetchLeaderboard(period: 'all-time');
      _cachedAllTimeLeaderboard = entries;
      _lastFetchTime = DateTime.now();
      return entries;
    } catch (e) {
      debugPrint('❌ Failed to fetch all-time leaderboard: $e');
      // Return cached data if available
      if (_cachedAllTimeLeaderboard != null) {
        return _cachedAllTimeLeaderboard!;
      }
      // Return mock data if no cache
      return _getMockLeaderboard();
    }
  }

  /// Submit user score to leaderboard
  Future<bool> submitScore({
    required String userId,
    required String username,
    required double portfolioValue,
    required double roi,
    required int positionCount,
    String? avatarUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${SimulatorConstants.apiBaseUrl}/simulator/score'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Add authentication token
          // 'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode({
          'userId': userId,
          'username': username,
          'portfolioValue': portfolioValue,
          'roi': roi,
          'positionCount': positionCount,
          'avatarUrl': avatarUrl,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Score submitted successfully');
        // Invalidate cache to force refresh
        _cachedWeeklyLeaderboard = null;
        _cachedAllTimeLeaderboard = null;
        return true;
      } else {
        debugPrint('❌ Failed to submit score: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error submitting score: $e');
      return false;
    }
  }

  /// Get user's rank on leaderboard
  Future<int?> getUserRank({
    required String userId,
    String period = 'weekly',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${SimulatorConstants.apiBaseUrl}/simulator/rank?userId=$userId&period=$period'),
        headers: {
          // TODO: Add authentication token
          // 'Authorization': 'Bearer $firebaseToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['rank'] as int?;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching user rank: $e');
      return null;
    }
  }

  // ===== PRIVATE METHODS =====

  /// Fetch leaderboard from API
  Future<List<LeaderboardEntry>> _fetchLeaderboard({
    required String period,
    int limit = 100,
  }) async {
    final response = await http.get(
      Uri.parse(
          '${SimulatorConstants.apiBaseUrl}/simulator/leaderboard?period=$period&limit=$limit'),
      headers: {
        // TODO: Add authentication token
        // 'Authorization': 'Bearer $firebaseToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => LeaderboardEntry.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch leaderboard: ${response.statusCode}');
    }
  }

  /// Generate mock leaderboard data for development/testing
  List<LeaderboardEntry> _getMockLeaderboard() {
    return [
      LeaderboardEntry(
        rank: 1,
        userId: 'user1',
        username: 'TaxLienKing',
        portfolioValue: 250000,
        roi: 145.5,
        positionCount: 42,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 2,
        userId: 'user2',
        username: 'InvestorPro',
        portfolioValue: 210000,
        roi: 120.8,
        positionCount: 35,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 3,
        userId: 'user3',
        username: 'PropertyWizard',
        portfolioValue: 185000,
        roi: 98.3,
        positionCount: 28,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 4,
        userId: 'user4',
        username: 'FlipMaster',
        portfolioValue: 165000,
        roi: 85.2,
        positionCount: 31,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 5,
        userId: 'user5',
        username: 'LienHunter',
        portfolioValue: 155000,
        roi: 72.1,
        positionCount: 25,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 6,
        userId: 'user6',
        username: 'ROIChaser',
        portfolioValue: 145000,
        roi: 65.4,
        positionCount: 22,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 7,
        userId: 'user7',
        username: 'CountyExplorer',
        portfolioValue: 135000,
        roi: 58.9,
        positionCount: 20,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 8,
        userId: 'user8',
        username: 'TaxSavvy',
        portfolioValue: 125000,
        roi: 52.3,
        positionCount: 18,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 9,
        userId: 'user9',
        username: 'AuctionAce',
        portfolioValue: 118000,
        roi: 47.6,
        positionCount: 16,
        avatarUrl: null,
      ),
      LeaderboardEntry(
        rank: 10,
        userId: 'user10',
        username: 'DealFinder',
        portfolioValue: 112000,
        roi: 42.1,
        positionCount: 15,
        avatarUrl: null,
      ),
    ];
  }

  /// Clear cache (for testing or logout)
  void clearCache() {
    _cachedWeeklyLeaderboard = null;
    _cachedAllTimeLeaderboard = null;
    _lastFetchTime = null;
  }
}
