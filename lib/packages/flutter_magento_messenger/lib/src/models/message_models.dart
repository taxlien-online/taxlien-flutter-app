import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_models.freezed.dart';
part 'message_models.g.dart';

/// Universal message model for Magento messaging
@freezed
class MagentoMessage with _$MagentoMessage {
  const factory MagentoMessage({
    required String id,
    required int senderId,
    required int recipientId,
    required String message,
    String? subject,
    int? orderId,
    @Default(false) bool isRead,
    @Default(false) bool isFromSender,
    required DateTime timestamp,
    DateTime? updatedAt,
    Map<String, dynamic>? data,
    String? attachmentUrl,
    String? attachmentType,
  }) = _MagentoMessage;

  factory MagentoMessage.fromJson(Map<String, dynamic> json) =>
      _$MagentoMessageFromJson(json);
}

/// Message thread/conversation model
@freezed
class MessageThread with _$MessageThread {
  const factory MessageThread({
    required String id,
    required int participant1Id,
    required int participant2Id,
    required String participant1Name,
    required String participant2Name,
    String? participant1Avatar,
    String? participant2Avatar,
    MagentoMessage? lastMessage,
    @Default(0) int unreadCount,
    @Default(false) bool isArchived,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _MessageThread;

  factory MessageThread.fromJson(Map<String, dynamic> json) =>
      _$MessageThreadFromJson(json);
}

/// Message search result
@freezed
class MessageSearchResult with _$MessageSearchResult {
  const factory MessageSearchResult({
    required MagentoMessage message,
    required String threadId,
    required String participantName,
    String? highlightedText,
  }) = _MessageSearchResult;

  factory MessageSearchResult.fromJson(Map<String, dynamic> json) =>
      _$MessageSearchResultFromJson(json);
}

/// Messaging configuration
@freezed
class MessagingConfig with _$MessagingConfig {
  const factory MessagingConfig({
    @Default(true) bool enableMessaging,
    @Default(false) bool allowAnonymousMessages,
    @Default(false) bool moderateMessages,
    @Default(5000) int maxMessageLength,
    @Default(255) int maxSubjectLength,
    @Default(true) bool enableAttachments,
    @Default(10485760) int maxAttachmentSize, // 10MB
    @Default(['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx']) List<String> allowedAttachmentTypes,
    @Default(true) bool enableReadReceipts,
    @Default(true) bool enableTypingIndicators,
    @Default(Duration(minutes: 30)) Duration typingTimeout,
  }) = _MessagingConfig;

  factory MessagingConfig.fromJson(Map<String, dynamic> json) =>
      _$MessagingConfigFromJson(json);
}

/// Message statistics
@freezed
class MessageStats with _$MessageStats {
  const factory MessageStats({
    @Default(0) int totalMessages,
    @Default(0) int unreadMessages,
    @Default(0) int sentMessages,
    @Default(0) int receivedMessages,
    @Default(0) int activeThreads,
    @Default(0) int archivedThreads,
  }) = _MessageStats;

  factory MessageStats.fromJson(Map<String, dynamic> json) =>
      _$MessageStatsFromJson(json);
}

/// Extension methods for MagentoMessage
extension MagentoMessageExtensions on MagentoMessage {
  /// Check if message is from current user
  bool isFromUser(int currentUserId) {
    return senderId == currentUserId;
  }

  /// Check if message is to current user
  bool isToUser(int currentUserId) {
    return recipientId == currentUserId;
  }

  /// Get formatted timestamp
  String get formattedTimestamp {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get detailed timestamp
  String get detailedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  /// Check if message has attachment
  bool get hasAttachment {
    return attachmentUrl != null && attachmentUrl!.isNotEmpty;
  }

  /// Get attachment file name
  String? get attachmentFileName {
    if (!hasAttachment) return null;
    return attachmentUrl!.split('/').last;
  }

  /// Get attachment file extension
  String? get attachmentFileExtension {
    if (!hasAttachment) return null;
    final fileName = attachmentFileName;
    if (fileName == null) return null;
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : null;
  }

  /// Check if attachment is image
  bool get isImageAttachment {
    if (!hasAttachment) return false;
    final extension = attachmentFileExtension;
    if (extension == null) return false;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  /// Check if attachment is document
  bool get isDocumentAttachment {
    if (!hasAttachment) return false;
    final extension = attachmentFileExtension;
    if (extension == null) return false;
    return ['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(extension);
  }

  /// Get attachment icon
  String get attachmentIcon {
    if (!hasAttachment) return 'attach_file';
    
    if (isImageAttachment) return 'image';
    if (isDocumentAttachment) return 'description';
    
    final extension = attachmentFileExtension;
    switch (extension) {
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'video_file';
      case 'mp3':
      case 'wav':
      case 'aac':
        return 'audio_file';
      case 'zip':
      case 'rar':
      case '7z':
        return 'archive';
      default:
        return 'attach_file';
    }
  }
}

/// Extension methods for MessageThread
extension MessageThreadExtensions on MessageThread {
  /// Get other participant ID
  int getOtherParticipantId(int currentUserId) {
    return participant1Id == currentUserId ? participant2Id : participant1Id;
  }

  /// Get other participant name
  String getOtherParticipantName(int currentUserId) {
    return participant1Id == currentUserId ? participant2Name : participant1Name;
  }

  /// Get other participant avatar
  String? getOtherParticipantAvatar(int currentUserId) {
    return participant1Id == currentUserId ? participant2Avatar : participant1Avatar;
  }

  /// Check if thread has unread messages
  bool get hasUnreadMessages => unreadCount > 0;

  /// Get formatted last message time
  String get formattedLastMessageTime {
    if (lastMessage == null) return '';
    return lastMessage!.formattedTimestamp;
  }

  /// Get thread preview text
  String get previewText {
    if (lastMessage == null) return 'No messages yet';
    
    final message = lastMessage!;
    if (message.hasAttachment) {
      return '📎 ${message.attachmentFileName ?? 'Attachment'}';
    }
    
    return message.message;
  }
}


