import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'message_models.dart';

/// Search result for messages
@immutable
class MessageSearchResult extends Equatable {
  /// The message that matched the search
  final MagentoMessage message;

  /// The thread this message belongs to
  final String threadId;

  /// Relevance score (0.0 to 1.0)
  final double relevanceScore;

  /// Highlighted message content with search terms
  final String? highlightedContent;

  /// Highlighted subject with search terms
  final String? highlightedSubject;

  /// Context around the match (previous and next messages)
  final List<MagentoMessage>? context;

  /// Search query that produced this result
  final String searchQuery;

  /// Timestamp when the search was performed
  final DateTime searchTimestamp;

  const MessageSearchResult({
    required this.message,
    required this.threadId,
    required this.relevanceScore,
    this.highlightedContent,
    this.highlightedSubject,
    this.context,
    required this.searchQuery,
    required this.searchTimestamp,
  });

  /// Create from JSON
  factory MessageSearchResult.fromJson(Map<String, dynamic> json) {
    return MessageSearchResult(
      message: MagentoMessage.fromJson(json['message']),
      threadId: json['threadId'] as String,
      relevanceScore: (json['relevanceScore'] ?? 0.0).toDouble(),
      highlightedContent: json['highlightedContent'] as String?,
      highlightedSubject: json['highlightedSubject'] as String?,
      context: json['context'] != null
          ? (json['context'] as List<dynamic>)
                .map((e) => MagentoMessage.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      searchQuery: json['searchQuery'] as String,
      searchTimestamp: DateTime.parse(json['searchTimestamp'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message.toJson(),
      'threadId': threadId,
      'relevanceScore': relevanceScore,
      'highlightedContent': highlightedContent,
      'highlightedSubject': highlightedSubject,
      'context': context?.map((e) => e.toJson()).toList(),
      'searchQuery': searchQuery,
      'searchTimestamp': searchTimestamp.toIso8601String(),
    };
  }

  /// Copy with new values
  MessageSearchResult copyWith({
    MagentoMessage? message,
    String? threadId,
    double? relevanceScore,
    String? highlightedContent,
    String? highlightedSubject,
    List<MagentoMessage>? context,
    String? searchQuery,
    DateTime? searchTimestamp,
  }) {
    return MessageSearchResult(
      message: message ?? this.message,
      threadId: threadId ?? this.threadId,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      highlightedContent: highlightedContent ?? this.highlightedContent,
      highlightedSubject: highlightedSubject ?? this.highlightedSubject,
      context: context ?? this.context,
      searchQuery: searchQuery ?? this.searchQuery,
      searchTimestamp: searchTimestamp ?? this.searchTimestamp,
    );
  }

  /// Get display content (highlighted if available, otherwise original)
  String get displayContent => highlightedContent ?? message.message;

  /// Get display subject (highlighted if available, otherwise original)
  String? get displaySubject => highlightedSubject ?? message.subject;

  /// Check if this result has context
  bool get hasContext => context != null && context!.isNotEmpty;

  /// Get context before the match
  List<MagentoMessage> get contextBefore {
    if (context == null) return [];
    final messageIndex = context!.indexWhere((m) => m.id == message.id);
    if (messageIndex <= 0) return [];
    return context!.sublist(0, messageIndex);
  }

  /// Get context after the match
  List<MagentoMessage> get contextAfter {
    if (context == null) return [];
    final messageIndex = context!.indexWhere((m) => m.id == message.id);
    if (messageIndex < 0 || messageIndex >= context!.length - 1) return [];
    return context!.sublist(messageIndex + 1);
  }

  /// Get relevance percentage
  double get relevancePercentage => relevanceScore * 100;

  /// Get relevance level
  SearchRelevanceLevel get relevanceLevel {
    if (relevanceScore >= 0.8) return SearchRelevanceLevel.high;
    if (relevanceScore >= 0.5) return SearchRelevanceLevel.medium;
    return SearchRelevanceLevel.low;
  }

  /// Get relevance color
  int get relevanceColor {
    switch (relevanceLevel) {
      case SearchRelevanceLevel.high:
        return 0xFF4CAF50; // Green
      case SearchRelevanceLevel.medium:
        return 0xFFFF9800; // Orange
      case SearchRelevanceLevel.low:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Get summary text
  String get summary {
    final buffer = StringBuffer();
    buffer.write('${relevancePercentage.toStringAsFixed(0)}% match');
    if (message.subject != null) {
      buffer.write(' in "${message.subject}"');
    }
    buffer.write(' (${message.timestamp.toLocal().toString().split('.')[0]})');
    return buffer.toString();
  }

  /// Get detailed summary
  String get detailedSummary {
    final buffer = StringBuffer();
    buffer.writeln('Message ID: ${message.id}');
    buffer.writeln('Thread ID: $threadId');
    buffer.writeln('Relevance: ${relevancePercentage.toStringAsFixed(1)}%');
    buffer.writeln('Type: ${message.type.displayName}');
    buffer.writeln('Status: ${message.status.displayName}');
    buffer.writeln('Timestamp: ${message.timestamp.toLocal()}');
    if (message.subject != null) {
      buffer.writeln('Subject: ${message.subject}');
    }
    buffer.writeln('Content: ${message.message}');
    if (hasContext) {
      buffer.writeln('Context: ${context!.length} messages');
    }
    return buffer.toString().trim();
  }

  @override
  List<Object?> get props => [
    message,
    threadId,
    relevanceScore,
    highlightedContent,
    highlightedSubject,
    context,
    searchQuery,
    searchTimestamp,
  ];

  @override
  String toString() {
    return 'MessageSearchResult('
        'message: $message, '
        'threadId: $threadId, '
        'relevanceScore: $relevanceScore, '
        'highlightedContent: $highlightedContent, '
        'highlightedSubject: $highlightedSubject, '
        'context: $context, '
        'searchQuery: $searchQuery, '
        'searchTimestamp: $searchTimestamp'
        ')';
  }
}

/// Relevance levels for search results
enum SearchRelevanceLevel { low, medium, high }

/// Extension for SearchRelevanceLevel
extension SearchRelevanceLevelExtension on SearchRelevanceLevel {
  /// Get display name
  String get displayName {
    switch (this) {
      case SearchRelevanceLevel.low:
        return 'Low';
      case SearchRelevanceLevel.medium:
        return 'Medium';
      case SearchRelevanceLevel.high:
        return 'High';
    }
  }

  /// Get description
  String get description {
    switch (this) {
      case SearchRelevanceLevel.low:
        return 'Weak match';
      case SearchRelevanceLevel.medium:
        return 'Good match';
      case SearchRelevanceLevel.high:
        return 'Strong match';
    }
  }
}
