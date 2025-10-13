import 'package:equatable/equatable.dart';

/// Message status types
enum MessageStatus {
  sent,
  delivered,
  read,
  failed,
}

/// Message types
enum MessageType {
  text,
  image,
  document,
  audio,
  video,
  location,
  contact,
  system,
}

/// Message priority levels
enum MessagePriority {
  low,
  normal,
  high,
  urgent,
}

/// Typing status
enum TypingStatus {
  typing,
  stopped,
}

/// Message delivery status
enum MessageDeliveryStatus {
  pending,
  sent,
  delivered,
  read,
  failed,
}

/// Attachment types
enum AttachmentType {
  image,
  document,
  audio,
  video,
  archive,
  other,
}

/// Message search scope
enum MessageSearchScope {
  all,
  sent,
  received,
  unread,
  withAttachments,
}

/// Extension methods for enums
extension MessageStatusExtensions on MessageStatus {
  /// Get display name for message status
  String get displayName {
    switch (this) {
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.read:
        return 'Read';
      case MessageStatus.failed:
        return 'Failed';
    }
  }

  /// Get icon name for message status
  String get iconName {
    switch (this) {
      case MessageStatus.sent:
        return 'send';
      case MessageStatus.delivered:
        return 'done_all';
      case MessageStatus.read:
        return 'done_all';
      case MessageStatus.failed:
        return 'error';
    }
  }

  /// Get color value for message status
  int get colorValue {
    switch (this) {
      case MessageStatus.sent:
        return 0xFF9E9E9E; // Gray
      case MessageStatus.delivered:
        return 0xFF2196F3; // Blue
      case MessageStatus.read:
        return 0xFF4CAF50; // Green
      case MessageStatus.failed:
        return 0xFFF44336; // Red
    }
  }
}

extension MessageTypeExtensions on MessageType {
  /// Get display name for message type
  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Text';
      case MessageType.image:
        return 'Image';
      case MessageType.document:
        return 'Document';
      case MessageType.audio:
        return 'Audio';
      case MessageType.video:
        return 'Video';
      case MessageType.location:
        return 'Location';
      case MessageType.contact:
        return 'Contact';
      case MessageType.system:
        return 'System';
    }
  }

  /// Get icon name for message type
  String get iconName {
    switch (this) {
      case MessageType.text:
        return 'text_fields';
      case MessageType.image:
        return 'image';
      case MessageType.document:
        return 'description';
      case MessageType.audio:
        return 'audiotrack';
      case MessageType.video:
        return 'videocam';
      case MessageType.location:
        return 'location_on';
      case MessageType.contact:
        return 'contact_phone';
      case MessageType.system:
        return 'settings';
    }
  }

  /// Get color value for message type
  int get colorValue {
    switch (this) {
      case MessageType.text:
        return 0xFF2196F3; // Blue
      case MessageType.image:
        return 0xFF4CAF50; // Green
      case MessageType.document:
        return 0xFFFF9800; // Orange
      case MessageType.audio:
        return 0xFF9C27B0; // Purple
      case MessageType.video:
        return 0xFFE91E63; // Pink
      case MessageType.location:
        return 0xFF795548; // Brown
      case MessageType.contact:
        return 0xFF607D8B; // Blue Grey
      case MessageType.system:
        return 0xFF9E9E9E; // Grey
    }
  }
}

extension MessagePriorityExtensions on MessagePriority {
  /// Get display name for priority
  String get displayName {
    switch (this) {
      case MessagePriority.low:
        return 'Low';
      case MessagePriority.normal:
        return 'Normal';
      case MessagePriority.high:
        return 'High';
      case MessagePriority.urgent:
        return 'Urgent';
    }
  }

  /// Get numeric value for priority
  int get value {
    switch (this) {
      case MessagePriority.low:
        return 1;
      case MessagePriority.normal:
        return 2;
      case MessagePriority.high:
        return 3;
      case MessagePriority.urgent:
        return 4;
    }
  }

  /// Check if priority is higher than another
  bool isHigherThan(MessagePriority other) {
    return value > other.value;
  }

  /// Check if priority is lower than another
  bool isLowerThan(MessagePriority other) {
    return value < other.value;
  }

  /// Get icon name for priority
  String get iconName {
    switch (this) {
      case MessagePriority.low:
        return 'keyboard_arrow_down';
      case MessagePriority.normal:
        return 'remove';
      case MessagePriority.high:
        return 'keyboard_arrow_up';
      case MessagePriority.urgent:
        return 'priority_high';
    }
  }
}

extension TypingStatusExtensions on TypingStatus {
  /// Get display name for typing status
  String get displayName {
    switch (this) {
      case TypingStatus.typing:
        return 'Typing...';
      case TypingStatus.stopped:
        return 'Stopped typing';
    }
  }

  /// Get icon name for typing status
  String get iconName {
    switch (this) {
      case TypingStatus.typing:
        return 'keyboard';
      case TypingStatus.stopped:
        return 'keyboard_hide';
    }
  }
}

extension MessageDeliveryStatusExtensions on MessageDeliveryStatus {
  /// Get display name for delivery status
  String get displayName {
    switch (this) {
      case MessageDeliveryStatus.pending:
        return 'Pending';
      case MessageDeliveryStatus.sent:
        return 'Sent';
      case MessageDeliveryStatus.delivered:
        return 'Delivered';
      case MessageDeliveryStatus.read:
        return 'Read';
      case MessageDeliveryStatus.failed:
        return 'Failed';
    }
  }

  /// Get icon name for delivery status
  String get iconName {
    switch (this) {
      case MessageDeliveryStatus.pending:
        return 'schedule';
      case MessageDeliveryStatus.sent:
        return 'send';
      case MessageDeliveryStatus.delivered:
        return 'done';
      case MessageDeliveryStatus.read:
        return 'done_all';
      case MessageDeliveryStatus.failed:
        return 'error';
    }
  }

  /// Get color value for delivery status
  int get colorValue {
    switch (this) {
      case MessageDeliveryStatus.pending:
        return 0xFFFF9800; // Orange
      case MessageDeliveryStatus.sent:
        return 0xFF2196F3; // Blue
      case MessageDeliveryStatus.delivered:
        return 0xFF4CAF50; // Green
      case MessageDeliveryStatus.read:
        return 0xFF4CAF50; // Green
      case MessageDeliveryStatus.failed:
        return 0xFFF44336; // Red
    }
  }
}

extension AttachmentTypeExtensions on AttachmentType {
  /// Get display name for attachment type
  String get displayName {
    switch (this) {
      case AttachmentType.image:
        return 'Image';
      case AttachmentType.document:
        return 'Document';
      case AttachmentType.audio:
        return 'Audio';
      case AttachmentType.video:
        return 'Video';
      case AttachmentType.archive:
        return 'Archive';
      case AttachmentType.other:
        return 'Other';
    }
  }

  /// Get icon name for attachment type
  String get iconName {
    switch (this) {
      case AttachmentType.image:
        return 'image';
      case AttachmentType.document:
        return 'description';
      case AttachmentType.audio:
        return 'audiotrack';
      case AttachmentType.video:
        return 'videocam';
      case AttachmentType.archive:
        return 'archive';
      case AttachmentType.other:
        return 'attach_file';
    }
  }

  /// Get color value for attachment type
  int get colorValue {
    switch (this) {
      case AttachmentType.image:
        return 0xFF4CAF50; // Green
      case AttachmentType.document:
        return 0xFFFF9800; // Orange
      case AttachmentType.audio:
        return 0xFF9C27B0; // Purple
      case AttachmentType.video:
        return 0xFFE91E63; // Pink
      case AttachmentType.archive:
        return 0xFF795548; // Brown
      case AttachmentType.other:
        return 0xFF9E9E9E; // Grey
    }
  }
}

extension MessageSearchScopeExtensions on MessageSearchScope {
  /// Get display name for search scope
  String get displayName {
    switch (this) {
      case MessageSearchScope.all:
        return 'All Messages';
      case MessageSearchScope.sent:
        return 'Sent Messages';
      case MessageSearchScope.received:
        return 'Received Messages';
      case MessageSearchScope.unread:
        return 'Unread Messages';
      case MessageSearchScope.withAttachments:
        return 'Messages with Attachments';
    }
  }

  /// Get icon name for search scope
  String get iconName {
    switch (this) {
      case MessageSearchScope.all:
        return 'search';
      case MessageSearchScope.sent:
        return 'send';
      case MessageSearchScope.received:
        return 'inbox';
      case MessageSearchScope.unread:
        return 'mark_email_unread';
      case MessageSearchScope.withAttachments:
        return 'attach_file';
    }
  }
}


