import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';
import '../services/leaderboard_service.dart';
import '../widgets/leaderboard_entry_card.dart';

/// Leaderboard Screen
///
/// Shows global rankings for the Portfolio Simulator
class LeaderboardScreen extends StatefulWidget {
  final String? userId;

  const LeaderboardScreen({
    super.key,
    this.userId,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _leaderboardService = LeaderboardService.instance;

  List<LeaderboardEntry> _weeklyLeaderboard = [];
  List<LeaderboardEntry> _allTimeLeaderboard = [];
  int? _userRank;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLeaderboards();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaderboards() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load both leaderboards in parallel
      final results = await Future.wait([
        _leaderboardService.getWeeklyLeaderboard(forceRefresh: true),
        _leaderboardService.getAllTimeLeaderboard(forceRefresh: true),
      ]);

      // Get user rank if userId provided
      int? userRank;
      if (widget.userId != null) {
        userRank = await _leaderboardService.getUserRank(
          userId: widget.userId!,
          period: 'weekly',
        );
      }

      setState(() {
        _weeklyLeaderboard = results[0];
        _allTimeLeaderboard = results[1];
        _userRank = userRank;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load leaderboard: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'This Week', icon: Icon(Icons.calendar_today, size: 20)),
            Tab(text: 'All Time', icon: Icon(Icons.emoji_events, size: 20)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : Column(
                  children: [
                    // User rank card (if available)
                    if (widget.userId != null && _userRank != null)
                      _buildUserRankCard(),

                    // Leaderboard tabs
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLeaderboardList(_weeklyLeaderboard),
                          _buildLeaderboardList(_allTimeLeaderboard),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildUserRankCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Rank',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getRankDisplayText(_userRank!),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (_userRank! <= 3)
            Text(
              _getMedal(_userRank!),
              style: const TextStyle(fontSize: 40),
            ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No leaderboard data yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete simulations to appear on the leaderboard',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLeaderboards,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final isCurrentUser = widget.userId != null &&
              entry.isCurrentUser(widget.userId!);

          return LeaderboardEntryCard(
            entry: entry,
            isCurrentUser: isCurrentUser,
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadLeaderboards,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getRankDisplayText(int rank) {
    if (rank == 1) return '1st Place';
    if (rank == 2) return '2nd Place';
    if (rank == 3) return '3rd Place';
    if (rank <= 10) return 'Top 10 (#$rank)';
    if (rank <= 100) return 'Top 100 (#$rank)';
    return '#$rank';
  }

  String _getMedal(int rank) {
    if (rank == 1) return '🥇';
    if (rank == 2) return '🥈';
    if (rank == 3) return '🥉';
    return '';
  }
}
