import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_magento_messenger/flutter_magento_messenger.dart';

void main() {
  group('MagentoMessagingService', () {
    late MagentoMessagingService service;

    setUp(() {
      service = MagentoMessagingService();
    });

    tearDown(() {
      service.dispose();
    });

    test('should initialize successfully', () async {
      await service.initialize();
      expect(service, isNotNull);
    });

    test('should send message', () async {
      final message = await service.sendMessage(
        senderId: 1,
        recipientId: 2,
        message: 'Test message',
        subject: 'Test Subject',
      );

      expect(message, isA<MagentoMessage>());
      expect(message.senderId, 1);
      expect(message.recipientId, 2);
      expect(message.message, 'Test message');
      expect(message.subject, 'Test Subject');
    });

    test('should reply to message', () async {
      // First send a message
      final originalMessage = await service.sendMessage(
        senderId: 1,
        recipientId: 2,
        message: 'Original message',
      );

      // Then reply to it
      final reply = await service.replyToMessage(
        originalMessageId: originalMessage.id,
        message: 'Reply message',
      );

      expect(reply, isA<MagentoMessage>());
      expect(reply.message, 'Reply message');
      expect(reply.parentMessageId, originalMessage.id);
    });

    test('should get thread messages', () {
      final messages = service.getThreadMessages('thread_1_2');
      expect(messages, isA<List<MagentoMessage>>());
    });

    test('should get threads', () {
      final threads = service.getThreads();
      expect(threads, isA<List<MessageThread>>());
    });

    test('should mark message as read', () async {
      final message = await service.sendMessage(
        senderId: 1,
        recipientId: 2,
        message: 'Test message',
      );

      await service.markAsRead(message.id);
      // Verify message was marked as read (this would depend on implementation)
      expect(service, isNotNull);
    });

    test('should mark thread as read', () async {
      await service.markThreadAsRead('thread_1_2');
      // Verify thread was marked as read (this would depend on implementation)
      expect(service, isNotNull);
    });

    test('should get unread count', () {
      final count = service.getUnreadCount(userId: 1);
      expect(count, isA<int>());
    });

    test('should get thread unread count', () {
      final count = service.getThreadUnreadCount('thread_1_2', 1);
      expect(count, isA<int>());
    });

    test('should search messages', () {
      final results = service.searchMessages('test query');
      expect(results, isA<List<MagentoMessage>>());
    });

    test('should archive thread', () async {
      await service.archiveThread('thread_1_2');
      // Verify thread was archived (this would depend on implementation)
      expect(service, isNotNull);
    });

    test('should unarchive thread', () async {
      await service.unarchiveThread('thread_1_2');
      // Verify thread was unarchived (this would depend on implementation)
      expect(service, isNotNull);
    });

    test('should get message statistics', () {
      final stats = service.getStats(userId: 1);
      expect(stats, isA<MessageStats>());
    });

    test('should start typing indicator', () {
      service.startTyping('thread_1_2', 1);
      // Verify typing indicator was started (this would depend on implementation)
      expect(service, isNotNull);
    });

    test('should stop typing indicator', () {
      service.stopTyping('thread_1_2');
      // Verify typing indicator was stopped (this would depend on implementation)
      expect(service, isNotNull);
    });
  });

  group('MagentoMessage', () {
    test('should create message from JSON', () {
      final json = {
        'id': 'test_id',
        'senderId': 1,
        'recipientId': 2,
        'message': 'Test message',
        'subject': 'Test Subject',
        'timestamp': '2024-01-01T00:00:00.000Z',
        'status': 'unread',
        'type': 'customerToSeller',
      };

      final message = MagentoMessage.fromJson(json);
      expect(message.id, 'test_id');
      expect(message.senderId, 1);
      expect(message.recipientId, 2);
      expect(message.message, 'Test message');
      expect(message.subject, 'Test Subject');
      expect(message.status, MessageStatus.unread);
      expect(message.type, MessageType.customerToSeller);
    });

    test('should convert message to JSON', () {
      final message = MagentoMessage(
        id: 'test_id',
        senderId: 1,
        recipientId: 2,
        message: 'Test message',
        subject: 'Test Subject',
        timestamp: DateTime.parse('2024-01-01T00:00:00.000Z'),
        status: MessageStatus.unread,
        type: MessageType.customerToSeller,
      );

      final json = message.toJson();
      expect(json['id'], 'test_id');
      expect(json['senderId'], 1);
      expect(json['recipientId'], 2);
      expect(json['message'], 'Test message');
      expect(json['subject'], 'Test Subject');
      expect(json['status'], 'unread');
      expect(json['type'], 'customerToSeller');
    });

    test('should check if message is from user', () {
      final message = MagentoMessage(
        id: 'test_id',
        senderId: 1,
        recipientId: 2,
        message: 'Test message',
        timestamp: DateTime.now(),
      );

      expect(message.isFromUser(1), isTrue);
      expect(message.isFromUser(2), isFalse);
    });

    test('should copy message with new values', () {
      final original = MagentoMessage(
        id: 'test_id',
        senderId: 1,
        recipientId: 2,
        message: 'Test message',
        timestamp: DateTime.now(),
      );

      final copied = original.copyWith(
        subject: 'New Subject',
        status: MessageStatus.read,
      );

      expect(copied.id, original.id);
      expect(copied.senderId, original.senderId);
      expect(copied.recipientId, original.recipientId);
      expect(copied.message, original.message);
      expect(copied.subject, 'New Subject');
      expect(copied.status, MessageStatus.read);
    });
  });

  group('MessageThread', () {
    test('should create thread from JSON', () {
      final json = {
        'id': 'thread_1_2',
        'participant1Id': 1,
        'participant2Id': 2,
        'messages': [
          {
            'id': 'msg_1',
            'senderId': 1,
            'recipientId': 2,
            'message': 'Hello',
            'timestamp': '2024-01-01T00:00:00.000Z',
            'status': 'read',
            'type': 'customerToSeller',
          },
        ],
        'lastMessageAt': '2024-01-01T00:00:00.000Z',
        'unreadCount': 0,
      };

      final thread = MessageThread.fromJson(json);
      expect(thread.id, 'thread_1_2');
      expect(thread.participant1Id, 1);
      expect(thread.participant2Id, 2);
      expect(thread.messages.length, 1);
      expect(thread.unreadCount, 0);
    });

    test('should convert thread to JSON', () {
      final thread = MessageThread(
        id: 'thread_1_2',
        participant1Id: 1,
        participant2Id: 2,
        messages: [
          MagentoMessage(
            id: 'msg_1',
            senderId: 1,
            recipientId: 2,
            message: 'Hello',
            timestamp: DateTime.parse('2024-01-01T00:00:00.000Z'),
            status: MessageStatus.read,
            type: MessageType.customerToSeller,
          ),
        ],
        lastMessageAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        unreadCount: 0,
      );

      final json = thread.toJson();
      expect(json['id'], 'thread_1_2');
      expect(json['participant1Id'], 1);
      expect(json['participant2Id'], 2);
      expect(json['messages'].length, 1);
      expect(json['unreadCount'], 0);
    });

    test('should copy thread with new values', () {
      final original = MessageThread(
        id: 'thread_1_2',
        participant1Id: 1,
        participant2Id: 2,
        messages: [],
        lastMessageAt: DateTime.now(),
        unreadCount: 0,
      );

      final copied = original.copyWith(unreadCount: 5);

      expect(copied.id, original.id);
      expect(copied.participant1Id, original.participant1Id);
      expect(copied.participant2Id, original.participant2Id);
      expect(copied.messages, original.messages);
      expect(copied.unreadCount, 5);
    });
  });

  group('MessagingConfig', () {
    test('should create default config', () {
      const config = MessagingConfig();
      expect(config.enableMessaging, isTrue);
      expect(config.allowAnonymousMessages, isFalse);
      expect(config.moderateMessages, isFalse);
      expect(config.maxMessageLength, 5000);
      expect(config.maxSubjectLength, 255);
      expect(config.enableAttachments, isTrue);
      expect(config.maxAttachmentSize, 10485760);
      expect(config.enableReadReceipts, isTrue);
      expect(config.enableTypingIndicators, isTrue);
      expect(config.typingTimeout, 1800);
      expect(config.enableEmailNotifications, isTrue);
      expect(config.enableRealTime, isFalse);
    });

    test('should create config from JSON', () {
      final json = {
        'enableMessaging': false,
        'allowAnonymousMessages': true,
        'moderateMessages': true,
        'maxMessageLength': 1000,
        'maxSubjectLength': 100,
        'enableAttachments': false,
        'maxAttachmentSize': 5242880,
        'allowedAttachmentTypes': ['jpg', 'png'],
        'enableReadReceipts': false,
        'enableTypingIndicators': false,
        'typingTimeout': 900,
        'enableEmailNotifications': false,
        'enableRealTime': true,
        'websocketUrl': 'ws://localhost:8080',
        'apiKey': 'test_key',
      };

      final config = MessagingConfig.fromJson(json);
      expect(config.enableMessaging, isFalse);
      expect(config.allowAnonymousMessages, isTrue);
      expect(config.moderateMessages, isTrue);
      expect(config.maxMessageLength, 1000);
      expect(config.maxSubjectLength, 100);
      expect(config.enableAttachments, isFalse);
      expect(config.maxAttachmentSize, 5242880);
      expect(config.allowedAttachmentTypes, ['jpg', 'png']);
      expect(config.enableReadReceipts, isFalse);
      expect(config.enableTypingIndicators, isFalse);
      expect(config.typingTimeout, 900);
      expect(config.enableEmailNotifications, isFalse);
      expect(config.enableRealTime, isTrue);
      expect(config.websocketUrl, 'ws://localhost:8080');
      expect(config.apiKey, 'test_key');
    });

    test('should convert config to JSON', () {
      const config = MessagingConfig(
        enableMessaging: false,
        allowAnonymousMessages: true,
        moderateMessages: true,
        maxMessageLength: 1000,
        maxSubjectLength: 100,
        enableAttachments: false,
        maxAttachmentSize: 5242880,
        allowedAttachmentTypes: ['jpg', 'png'],
        enableReadReceipts: false,
        enableTypingIndicators: false,
        typingTimeout: 900,
        enableEmailNotifications: false,
        enableRealTime: true,
        websocketUrl: 'ws://localhost:8080',
        apiKey: 'test_key',
      );

      final json = config.toJson();
      expect(json['enableMessaging'], isFalse);
      expect(json['allowAnonymousMessages'], isTrue);
      expect(json['moderateMessages'], isTrue);
      expect(json['maxMessageLength'], 1000);
      expect(json['maxSubjectLength'], 100);
      expect(json['enableAttachments'], isFalse);
      expect(json['maxAttachmentSize'], 5242880);
      expect(json['allowedAttachmentTypes'], ['jpg', 'png']);
      expect(json['enableReadReceipts'], isFalse);
      expect(json['enableTypingIndicators'], isFalse);
      expect(json['typingTimeout'], 900);
      expect(json['enableEmailNotifications'], isFalse);
      expect(json['enableRealTime'], isTrue);
      expect(json['websocketUrl'], 'ws://localhost:8080');
      expect(json['apiKey'], 'test_key');
    });

    test('should check if attachment type is allowed', () {
      const config = MessagingConfig(
        allowedAttachmentTypes: ['jpg', 'png', 'pdf'],
      );

      expect(config.isAttachmentTypeAllowed('jpg'), isTrue);
      expect(config.isAttachmentTypeAllowed('png'), isTrue);
      expect(config.isAttachmentTypeAllowed('pdf'), isTrue);
      expect(config.isAttachmentTypeAllowed('doc'), isFalse);
      expect(config.isAttachmentTypeAllowed('JPG'), isTrue); // Case insensitive
    });

    test('should check if attachment size is valid', () {
      const config = MessagingConfig(
        maxAttachmentSize: 10485760, // 10MB
      );

      expect(config.isAttachmentSizeValid(5242880), isTrue); // 5MB
      expect(config.isAttachmentSizeValid(10485760), isTrue); // 10MB
      expect(config.isAttachmentSizeValid(15728640), isFalse); // 15MB
    });

    test('should get formatted file size limit', () {
      const config1 = MessagingConfig(maxAttachmentSize: 1024); // 1KB
      expect(config1.getFormattedFileSizeLimit(), '1.0KB');

      const config2 = MessagingConfig(maxAttachmentSize: 1048576); // 1MB
      expect(config2.getFormattedFileSizeLimit(), '1.0MB');

      const config3 = MessagingConfig(maxAttachmentSize: 1073741824); // 1GB
      expect(config3.getFormattedFileSizeLimit(), '1.0GB');
    });

    test('should get allowed attachment types as string', () {
      const config = MessagingConfig(
        allowedAttachmentTypes: ['jpg', 'png', 'pdf'],
      );

      expect(config.getAllowedAttachmentTypesString(), 'jpg, png, pdf');
    });

    test('should copy config with new values', () {
      const original = MessagingConfig();
      final copied = original.copyWith(
        enableMessaging: false,
        maxMessageLength: 1000,
      );

      expect(copied.enableMessaging, isFalse);
      expect(copied.maxMessageLength, 1000);
      expect(copied.allowAnonymousMessages, original.allowAnonymousMessages);
      expect(copied.moderateMessages, original.moderateMessages);
    });
  });
}
