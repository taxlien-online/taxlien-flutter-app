import 'package:equatable/equatable.dart';

/// Configuration class for messaging service
class MessagingConfig extends Equatable {
  /// Enable messaging system
  final bool enableMessaging;

  /// Allow anonymous messages
  final bool allowAnonymousMessages;

  /// Moderate messages
  final bool moderateMessages;

  /// Maximum message length
  final int maxMessageLength;

  /// Maximum subject length
  final int maxSubjectLength;

  /// Enable attachments
  final bool enableAttachments;

  /// Maximum attachment size in bytes
  final int maxAttachmentSize;

  /// Allowed attachment types
  final List<String> allowedAttachmentTypes;

  /// Enable read receipts
  final bool enableReadReceipts;

  /// Enable typing indicators
  final bool enableTypingIndicators;

  /// Typing timeout in seconds
  final int typingTimeout;

  /// Enable email notifications for new messages
  final bool enableEmailNotifications;

  /// Enable real-time updates
  final bool enableRealTime;

  /// WebSocket URL for real-time updates
  final String? websocketUrl;

  /// API key for real-time service
  final String? apiKey;

  const MessagingConfig({
    this.enableMessaging = true,
    this.allowAnonymousMessages = false,
    this.moderateMessages = false,
    this.maxMessageLength = 5000,
    this.maxSubjectLength = 255,
    this.enableAttachments = true,
    this.maxAttachmentSize = 10485760, // 10MB
    this.allowedAttachmentTypes = const [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'pdf',
      'doc',
      'docx',
      'txt',
    ],
    this.enableReadReceipts = true,
    this.enableTypingIndicators = true,
    this.typingTimeout = 1800, // 30 minutes
    this.enableEmailNotifications = true,
    this.enableRealTime = false,
    this.websocketUrl,
    this.apiKey,
  });

  /// Create configuration from environment variables
  factory MessagingConfig.fromEnvironment() {
    return MessagingConfig(
      enableMessaging: bool.fromEnvironment(
        'MESSAGING_ENABLED',
        defaultValue: true,
      ),
      allowAnonymousMessages: bool.fromEnvironment(
        'MESSAGING_ANONYMOUS',
        defaultValue: false,
      ),
      moderateMessages: bool.fromEnvironment(
        'MESSAGING_MODERATE',
        defaultValue: false,
      ),
      maxMessageLength: int.fromEnvironment(
        'MESSAGING_MAX_LENGTH',
        defaultValue: 5000,
      ),
      maxSubjectLength: int.fromEnvironment(
        'MESSAGING_MAX_SUBJECT',
        defaultValue: 255,
      ),
      enableAttachments: bool.fromEnvironment(
        'MESSAGING_ATTACHMENTS',
        defaultValue: true,
      ),
      maxAttachmentSize: int.fromEnvironment(
        'MESSAGING_MAX_ATTACHMENT',
        defaultValue: 10485760,
      ),
      allowedAttachmentTypes: const String.fromEnvironment(
        'MESSAGING_ALLOWED_TYPES',
        defaultValue: 'jpg,jpeg,png,gif,pdf,doc,docx,txt',
      ).split(','),
      enableReadReceipts: bool.fromEnvironment(
        'MESSAGING_READ_RECEIPTS',
        defaultValue: true,
      ),
      enableTypingIndicators: bool.fromEnvironment(
        'MESSAGING_TYPING',
        defaultValue: true,
      ),
      typingTimeout: int.fromEnvironment(
        'MESSAGING_TYPING_TIMEOUT',
        defaultValue: 1800,
      ),
      enableEmailNotifications: bool.fromEnvironment(
        'MESSAGING_EMAIL',
        defaultValue: true,
      ),
      enableRealTime: bool.fromEnvironment(
        'MESSAGING_REALTIME',
        defaultValue: false,
      ),
      websocketUrl: const String.fromEnvironment('MESSAGING_WEBSOCKET_URL'),
      apiKey: const String.fromEnvironment('MESSAGING_API_KEY'),
    );
  }

  /// Create configuration from JSON
  factory MessagingConfig.fromJson(Map<String, dynamic> json) {
    return MessagingConfig(
      enableMessaging: json['enableMessaging'] ?? true,
      allowAnonymousMessages: json['allowAnonymousMessages'] ?? false,
      moderateMessages: json['moderateMessages'] ?? false,
      maxMessageLength: json['maxMessageLength'] ?? 5000,
      maxSubjectLength: json['maxSubjectLength'] ?? 255,
      enableAttachments: json['enableAttachments'] ?? true,
      maxAttachmentSize: json['maxAttachmentSize'] ?? 10485760,
      allowedAttachmentTypes: List<String>.from(
        json['allowedAttachmentTypes'] ??
            ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'txt'],
      ),
      enableReadReceipts: json['enableReadReceipts'] ?? true,
      enableTypingIndicators: json['enableTypingIndicators'] ?? true,
      typingTimeout: json['typingTimeout'] ?? 1800,
      enableEmailNotifications: json['enableEmailNotifications'] ?? true,
      enableRealTime: json['enableRealTime'] ?? false,
      websocketUrl: json['websocketUrl'],
      apiKey: json['apiKey'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'enableMessaging': enableMessaging,
      'allowAnonymousMessages': allowAnonymousMessages,
      'moderateMessages': moderateMessages,
      'maxMessageLength': maxMessageLength,
      'maxSubjectLength': maxSubjectLength,
      'enableAttachments': enableAttachments,
      'maxAttachmentSize': maxAttachmentSize,
      'allowedAttachmentTypes': allowedAttachmentTypes,
      'enableReadReceipts': enableReadReceipts,
      'enableTypingIndicators': enableTypingIndicators,
      'typingTimeout': typingTimeout,
      'enableEmailNotifications': enableEmailNotifications,
      'enableRealTime': enableRealTime,
      'websocketUrl': websocketUrl,
      'apiKey': apiKey,
    };
  }

  /// Copy with new values
  MessagingConfig copyWith({
    bool? enableMessaging,
    bool? allowAnonymousMessages,
    bool? moderateMessages,
    int? maxMessageLength,
    int? maxSubjectLength,
    bool? enableAttachments,
    int? maxAttachmentSize,
    List<String>? allowedAttachmentTypes,
    bool? enableReadReceipts,
    bool? enableTypingIndicators,
    int? typingTimeout,
    bool? enableEmailNotifications,
    bool? enableRealTime,
    String? websocketUrl,
    String? apiKey,
  }) {
    return MessagingConfig(
      enableMessaging: enableMessaging ?? this.enableMessaging,
      allowAnonymousMessages:
          allowAnonymousMessages ?? this.allowAnonymousMessages,
      moderateMessages: moderateMessages ?? this.moderateMessages,
      maxMessageLength: maxMessageLength ?? this.maxMessageLength,
      maxSubjectLength: maxSubjectLength ?? this.maxSubjectLength,
      enableAttachments: enableAttachments ?? this.enableAttachments,
      maxAttachmentSize: maxAttachmentSize ?? this.maxAttachmentSize,
      allowedAttachmentTypes:
          allowedAttachmentTypes ?? this.allowedAttachmentTypes,
      enableReadReceipts: enableReadReceipts ?? this.enableReadReceipts,
      enableTypingIndicators:
          enableTypingIndicators ?? this.enableTypingIndicators,
      typingTimeout: typingTimeout ?? this.typingTimeout,
      enableEmailNotifications:
          enableEmailNotifications ?? this.enableEmailNotifications,
      enableRealTime: enableRealTime ?? this.enableRealTime,
      websocketUrl: websocketUrl ?? this.websocketUrl,
      apiKey: apiKey ?? this.apiKey,
    );
  }

  /// Check if attachment type is allowed
  bool isAttachmentTypeAllowed(String fileExtension) {
    return allowedAttachmentTypes.contains(fileExtension.toLowerCase());
  }

  /// Check if attachment size is valid
  bool isAttachmentSizeValid(int fileSize) {
    return fileSize <= maxAttachmentSize;
  }

  /// Get formatted file size limit
  String getFormattedFileSizeLimit() {
    if (maxAttachmentSize < 1024) {
      return '${maxAttachmentSize}B';
    } else if (maxAttachmentSize < 1024 * 1024) {
      return '${(maxAttachmentSize / 1024).toStringAsFixed(1)}KB';
    } else if (maxAttachmentSize < 1024 * 1024 * 1024) {
      return '${(maxAttachmentSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(maxAttachmentSize / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  /// Get allowed attachment types as string
  String getAllowedAttachmentTypesString() {
    return allowedAttachmentTypes.join(', ');
  }

  @override
  List<Object?> get props => [
    enableMessaging,
    allowAnonymousMessages,
    moderateMessages,
    maxMessageLength,
    maxSubjectLength,
    enableAttachments,
    maxAttachmentSize,
    allowedAttachmentTypes,
    enableReadReceipts,
    enableTypingIndicators,
    typingTimeout,
    enableEmailNotifications,
    enableRealTime,
    websocketUrl,
    apiKey,
  ];

  @override
  String toString() {
    return 'MessagingConfig('
        'enableMessaging: $enableMessaging, '
        'allowAnonymousMessages: $allowAnonymousMessages, '
        'moderateMessages: $moderateMessages, '
        'maxMessageLength: $maxMessageLength, '
        'maxSubjectLength: $maxSubjectLength, '
        'enableAttachments: $enableAttachments, '
        'maxAttachmentSize: $maxAttachmentSize, '
        'allowedAttachmentTypes: $allowedAttachmentTypes, '
        'enableReadReceipts: $enableReadReceipts, '
        'enableTypingIndicators: $enableTypingIndicators, '
        'typingTimeout: $typingTimeout, '
        'enableEmailNotifications: $enableEmailNotifications, '
        'enableRealTime: $enableRealTime, '
        'websocketUrl: $websocketUrl, '
        'apiKey: $apiKey'
        ')';
  }
}
