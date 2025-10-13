import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'message_types.dart';

/// Statistics for messages
@immutable
class MessageStats extends Equatable {
  /// Total number of messages
  final int total;

  /// Number of unread messages
  final int unread;

  /// Number of read messages
  final int read;

  /// Number of sent messages
  final int sent;

  /// Number of delivered messages
  final int delivered;

  /// Number of failed messages
  final int failed;

  /// Statistics by type
  final Map<MessageType, int> byType;

  /// Statistics by status
  final Map<MessageStatus, int> byStatus;

  /// Most recent message timestamp
  final DateTime? lastMessageAt;

  /// Average messages per day
  final double averagePerDay;

  /// Most active message type
  final MessageType? mostActiveType;

  /// Most common status
  final MessageStatus? mostCommonStatus;

  /// Total number of threads
  final int totalThreads;

  /// Number of active threads
  final int activeThreads;

  /// Number of archived threads
  final int archivedThreads;

  /// Average messages per thread
  final double averageMessagesPerThread;

  const MessageStats({
    required this.total,
    required this.unread,
    required this.read,
    required this.sent,
    required this.delivered,
    required this.failed,
    required this.byType,
    required this.byStatus,
    this.lastMessageAt,
    this.averagePerDay = 0.0,
    this.mostActiveType,
    this.mostCommonStatus,
    this.totalThreads = 0,
    this.activeThreads = 0,
    this.archivedThreads = 0,
    this.averageMessagesPerThread = 0.0,
  });

  /// Create from JSON
  factory MessageStats.fromJson(Map<String, dynamic> json) {
    return MessageStats(
      total: json['total'] ?? 0,
      unread: json['unread'] ?? 0,
      read: json['read'] ?? 0,
      sent: json['sent'] ?? 0,
      delivered: json['delivered'] ?? 0,
      failed: json['failed'] ?? 0,
      byType: _parseTypeStats(json['byType']),
      byStatus: _parseStatusStats(json['byStatus']),
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'])
          : null,
      averagePerDay: (json['averagePerDay'] ?? 0.0).toDouble(),
      mostActiveType: json['mostActiveType'] != null
          ? MessageType.values.firstWhere(
              (e) => e.name == json['mostActiveType'],
            )
          : null,
      mostCommonStatus: json['mostCommonStatus'] != null
          ? MessageStatus.values.firstWhere(
              (e) => e.name == json['mostCommonStatus'],
            )
          : null,
      totalThreads: json['totalThreads'] ?? 0,
      activeThreads: json['activeThreads'] ?? 0,
      archivedThreads: json['archivedThreads'] ?? 0,
      averageMessagesPerThread: (json['averageMessagesPerThread'] ?? 0.0)
          .toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'unread': unread,
      'read': read,
      'sent': sent,
      'delivered': delivered,
      'failed': failed,
      'byType': byType.map((key, value) => MapEntry(key.name, value)),
      'byStatus': byStatus.map((key, value) => MapEntry(key.name, value)),
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'averagePerDay': averagePerDay,
      'mostActiveType': mostActiveType?.name,
      'mostCommonStatus': mostCommonStatus?.name,
      'totalThreads': totalThreads,
      'activeThreads': activeThreads,
      'archivedThreads': archivedThreads,
      'averageMessagesPerThread': averageMessagesPerThread,
    };
  }

  /// Copy with new values
  MessageStats copyWith({
    int? total,
    int? unread,
    int? read,
    int? sent,
    int? delivered,
    int? failed,
    Map<MessageType, int>? byType,
    Map<MessageStatus, int>? byStatus,
    DateTime? lastMessageAt,
    double? averagePerDay,
    MessageType? mostActiveType,
    MessageStatus? mostCommonStatus,
    int? totalThreads,
    int? activeThreads,
    int? archivedThreads,
    double? averageMessagesPerThread,
  }) {
    return MessageStats(
      total: total ?? this.total,
      unread: unread ?? this.unread,
      read: read ?? this.read,
      sent: sent ?? this.sent,
      delivered: delivered ?? this.delivered,
      failed: failed ?? this.failed,
      byType: byType ?? this.byType,
      byStatus: byStatus ?? this.byStatus,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      averagePerDay: averagePerDay ?? this.averagePerDay,
      mostActiveType: mostActiveType ?? this.mostActiveType,
      mostCommonStatus: mostCommonStatus ?? this.mostCommonStatus,
      totalThreads: totalThreads ?? this.totalThreads,
      activeThreads: activeThreads ?? this.activeThreads,
      archivedThreads: archivedThreads ?? this.archivedThreads,
      averageMessagesPerThread:
          averageMessagesPerThread ?? this.averageMessagesPerThread,
    );
  }

  /// Get read percentage
  double get readPercentage => total > 0 ? (read / total) * 100 : 0.0;

  /// Get unread percentage
  double get unreadPercentage => total > 0 ? (unread / total) * 100 : 0.0;

  /// Get sent percentage
  double get sentPercentage => total > 0 ? (sent / total) * 100 : 0.0;

  /// Get delivered percentage
  double get deliveredPercentage => total > 0 ? (delivered / total) * 100 : 0.0;

  /// Get failed percentage
  double get failedPercentage => total > 0 ? (failed / total) * 100 : 0.0;

  /// Get active threads percentage
  double get activeThreadsPercentage =>
      totalThreads > 0 ? (activeThreads / totalThreads) * 100 : 0.0;

  /// Get archived threads percentage
  double get archivedThreadsPercentage =>
      totalThreads > 0 ? (archivedThreads / totalThreads) * 100 : 0.0;

  /// Get count for specific type
  int getCountForType(MessageType type) {
    return byType[type] ?? 0;
  }

  /// Get count for specific status
  int getCountForStatus(MessageStatus status) {
    return byStatus[status] ?? 0;
  }

  /// Get percentage for specific type
  double getPercentageForType(MessageType type) {
    final count = getCountForType(type);
    return total > 0 ? (count / total) * 100 : 0.0;
  }

  /// Get percentage for specific status
  double getPercentageForStatus(MessageStatus status) {
    final count = getCountForStatus(status);
    return total > 0 ? (count / total) * 100 : 0.0;
  }

  /// Check if there are any messages
  bool get hasMessages => total > 0;

  /// Check if there are unread messages
  bool get hasUnread => unread > 0;

  /// Check if there are failed messages
  bool get hasFailed => failed > 0;

  /// Check if there are any threads
  bool get hasThreads => totalThreads > 0;

  /// Check if there are active threads
  bool get hasActiveThreads => activeThreads > 0;

  /// Check if there are archived threads
  bool get hasArchivedThreads => archivedThreads > 0;

  /// Get top message types (sorted by count)
  List<MapEntry<MessageType, int>> get topTypes {
    final entries = byType.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  /// Get top statuses (sorted by count)
  List<MapEntry<MessageStatus, int>> get topStatuses {
    final entries = byStatus.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  /// Get summary text
  String get summary {
    if (total == 0) return 'No messages';
    if (unread == 0) return '$total messages, all read';
    return '$total messages, $unread unread';
  }

  /// Get detailed summary
  String get detailedSummary {
    final buffer = StringBuffer();
    buffer.writeln('Total: $total');
    buffer.writeln('Unread: $unread (${unreadPercentage.toStringAsFixed(1)}%)');
    buffer.writeln('Read: $read (${readPercentage.toStringAsFixed(1)}%)');
    buffer.writeln('Sent: $sent (${sentPercentage.toStringAsFixed(1)}%)');
    buffer.writeln(
      'Delivered: $delivered (${deliveredPercentage.toStringAsFixed(1)}%)',
    );
    if (failed > 0) {
      buffer.writeln(
        'Failed: $failed (${failedPercentage.toStringAsFixed(1)}%)',
      );
    }
    buffer.writeln(
      'Threads: $totalThreads (Active: $activeThreads, Archived: $archivedThreads)',
    );
    if (averagePerDay > 0) {
      buffer.writeln('Average per day: ${averagePerDay.toStringAsFixed(1)}');
    }
    if (averageMessagesPerThread > 0) {
      buffer.writeln(
        'Average per thread: ${averageMessagesPerThread.toStringAsFixed(1)}',
      );
    }
    if (mostActiveType != null) {
      buffer.writeln('Most active type: ${mostActiveType!.displayName}');
    }
    if (mostCommonStatus != null) {
      buffer.writeln('Most common status: ${mostCommonStatus!.displayName}');
    }
    return buffer.toString().trim();
  }

  /// Get thread summary
  String get threadSummary {
    if (totalThreads == 0) return 'No threads';
    return '$totalThreads threads (Active: $activeThreads, Archived: $archivedThreads)';
  }

  /// Get delivery summary
  String get deliverySummary {
    if (total == 0) return 'No messages';
    final successRate = ((delivered / total) * 100).toStringAsFixed(1);
    return 'Delivery rate: $successRate% ($delivered/$total)';
  }

  static Map<MessageType, int> _parseTypeStats(Map<String, dynamic>? json) {
    if (json == null) return {};

    final Map<MessageType, int> result = {};
    for (final entry in json.entries) {
      final type = MessageType.values.firstWhere(
        (e) => e.name == entry.key,
        orElse: () => MessageType.customerToSeller,
      );
      result[type] = entry.value as int;
    }
    return result;
  }

  static Map<MessageStatus, int> _parseStatusStats(Map<String, dynamic>? json) {
    if (json == null) return {};

    final Map<MessageStatus, int> result = {};
    for (final entry in json.entries) {
      final status = MessageStatus.values.firstWhere(
        (e) => e.name == entry.key,
        orElse: () => MessageStatus.unread,
      );
      result[status] = entry.value as int;
    }
    return result;
  }

  @override
  List<Object?> get props => [
    total,
    unread,
    read,
    sent,
    delivered,
    failed,
    byType,
    byStatus,
    lastMessageAt,
    averagePerDay,
    mostActiveType,
    mostCommonStatus,
    totalThreads,
    activeThreads,
    archivedThreads,
    averageMessagesPerThread,
  ];

  @override
  String toString() {
    return 'MessageStats('
        'total: $total, '
        'unread: $unread, '
        'read: $read, '
        'sent: $sent, '
        'delivered: $delivered, '
        'failed: $failed, '
        'byType: $byType, '
        'byStatus: $byStatus, '
        'lastMessageAt: $lastMessageAt, '
        'averagePerDay: $averagePerDay, '
        'mostActiveType: $mostActiveType, '
        'mostCommonStatus: $mostCommonStatus, '
        'totalThreads: $totalThreads, '
        'activeThreads: $activeThreads, '
        'archivedThreads: $archivedThreads, '
        'averageMessagesPerThread: $averageMessagesPerThread'
        ')';
  }
}
