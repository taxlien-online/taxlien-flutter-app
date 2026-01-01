// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    LeaderboardEntry(
      rank: (json['rank'] as num).toInt(),
      userId: json['userId'] as String,
      username: json['username'] as String,
      portfolioValue: (json['portfolioValue'] as num).toDouble(),
      roi: (json['roi'] as num).toDouble(),
      positionCount: (json['positionCount'] as num).toInt(),
      avatarUrl: json['avatarUrl'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$LeaderboardEntryToJson(LeaderboardEntry instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'userId': instance.userId,
      'username': instance.username,
      'portfolioValue': instance.portfolioValue,
      'roi': instance.roi,
      'positionCount': instance.positionCount,
      'avatarUrl': instance.avatarUrl,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
