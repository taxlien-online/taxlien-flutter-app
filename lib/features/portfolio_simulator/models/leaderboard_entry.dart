import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_entry.g.dart';

/// Leaderboard entry model
///
/// Represents a single entry on the leaderboard
@JsonSerializable()
class LeaderboardEntry {
  final int rank;
  final String userId;
  final String username;
  final double portfolioValue;
  final double roi;
  final int positionCount;
  final String? avatarUrl;
  final DateTime? lastUpdated;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.username,
    required this.portfolioValue,
    required this.roi,
    required this.positionCount,
    this.avatarUrl,
    this.lastUpdated,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);

  /// Check if this entry is for the current user
  bool isCurrentUser(String currentUserId) => userId == currentUserId;

  /// Get display rank (with suffix)
  String get displayRank {
    if (rank == 1) return '1st';
    if (rank == 2) return '2nd';
    if (rank == 3) return '3rd';
    return '${rank}th';
  }

  /// Get medal emoji for top 3
  String? get medal {
    if (rank == 1) return '🥇';
    if (rank == 2) return '🥈';
    if (rank == 3) return '🥉';
    return null;
  }

  LeaderboardEntry copyWith({
    int? rank,
    String? userId,
    String? username,
    double? portfolioValue,
    double? roi,
    int? positionCount,
    String? avatarUrl,
    DateTime? lastUpdated,
  }) {
    return LeaderboardEntry(
      rank: rank ?? this.rank,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      roi: roi ?? this.roi,
      positionCount: positionCount ?? this.positionCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
