import 'dart:async';
import 'package:flutter/foundation.dart';
import 'messaging_service.dart';
import '../api/messaging_api.dart';
import '../models/message_models.dart';
import '../models/message_types.dart';

/// High-level message manager that combines local service with API
class MessageManager extends ChangeNotifier {
  final MagentoMessagingService _localService;
  final MessagingApi _api;
  final bool _enableSync;

  MessageManager({
    required MagentoMessagingService localService,
    required MessagingApi api,
    bool enableSync = true,
  }) : _localService = localService,
       _api = api,
       _enableSync = enableSync;

  /// Initialize the message manager
  Future<void> initialize() async {
    await _localService.initialize();

    if (_enableSync) {
      await _syncWithServer();
    }
  }

  /// Send message (local + server)
  Future<MagentoMessage> sendMessage({
    required int senderId,
    required int recipientId,
    required String message,
    String? subject,
    int? orderId,
    Map<String, dynamic>? data,
    String? attachmentUrl,
    String? attachmentType,
    bool syncToServer = true,
  }) async {
    // Send locally first
    final localMessage = await _localService.sendMessage(
      senderId: senderId,
      recipientId: recipientId,
      message: message,
      subject: subject,
      orderId: orderId,
      data: data,
      attachmentUrl: attachmentUrl,
      attachmentType: attachmentType,
    );

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        final serverMessage = await _api.sendMessage(
          senderId: senderId,
          recipientId: recipientId,
          message: message,
          subject: subject,
          orderId: orderId,
          data: data,
          attachmentUrl: attachmentUrl,
          attachmentType: attachmentType,
        );
        return serverMessage;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync message to server: $e');
        }
      }
    }

    return localMessage;
  }

  /// Reply to message (local + server)
  Future<MagentoMessage> replyToMessage({
    required String originalMessageId,
    required String message,
    String? subject,
    Map<String, dynamic>? data,
    String? attachmentUrl,
    String? attachmentType,
    bool syncToServer = true,
  }) async {
    // Reply locally first
    final localReply = await _localService.replyToMessage(
      originalMessageId: originalMessageId,
      message: message,
      subject: subject,
      data: data,
      attachmentUrl: attachmentUrl,
      attachmentType: attachmentType,
    );

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        // Extract numeric ID from message ID if needed
        final numericId = int.tryParse(originalMessageId.split('_').last) ?? 0;
        if (numericId > 0) {
          final serverReply = await _api.replyToMessage(
            messageId: numericId,
            message: message,
            subject: subject,
            data: data,
            attachmentUrl: attachmentUrl,
            attachmentType: attachmentType,
          );
          return serverReply;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync reply to server: $e');
        }
      }
    }

    return localReply;
  }

  /// Get thread messages (local + server)
  Future<List<MagentoMessage>> getThreadMessages({
    required String threadId,
    int? limit,
    int? offset,
    bool syncFromServer = true,
  }) async {
    // Get local messages
    final localMessages = _localService.getThreadMessages(
      threadId,
      limit: limit,
      offset: offset,
    );

    // Sync from server if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverMessages = await _api.getThreadMessages(
          threadId: threadId,
          limit: limit,
          offset: offset,
        );

        // Merge and deduplicate messages
        final allMessages = <MagentoMessage>[];
        final seenIds = <String>{};

        // Add server messages first (they are more up-to-date)
        for (final message in serverMessages) {
          if (!seenIds.contains(message.id)) {
            allMessages.add(message);
            seenIds.add(message.id);
          }
        }

        // Add local messages that aren't already included
        for (final message in localMessages) {
          if (!seenIds.contains(message.id)) {
            allMessages.add(message);
            seenIds.add(message.id);
          }
        }

        // Sort by timestamp (oldest first for chat)
        allMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        return allMessages;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync thread messages from server: $e');
        }
      }
    }

    return localMessages;
  }

  /// Get message threads (local + server)
  Future<List<MessageThread>> getThreads({
    required int userId,
    int? limit,
    int? offset,
    bool isArchived = false,
    bool syncFromServer = true,
  }) async {
    // Get local threads
    final localThreads = _localService.getThreads(limit: limit, offset: offset);

    // Sync from server if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverThreads = await _api.getThreads(
          userId: userId,
          limit: limit,
          offset: offset,
          isArchived: isArchived,
        );

        // Merge and deduplicate threads
        final allThreads = <MessageThread>[];
        final seenIds = <String>{};

        // Add server threads first (they are more up-to-date)
        for (final thread in serverThreads) {
          if (!seenIds.contains(thread.id)) {
            allThreads.add(thread);
            seenIds.add(thread.id);
          }
        }

        // Add local threads that aren't already included
        for (final thread in localThreads) {
          if (!seenIds.contains(thread.id)) {
            allThreads.add(thread);
            seenIds.add(thread.id);
          }
        }

        // Sort by last message time (newest first)
        allThreads.sort((a, b) {
          if (a.lastMessage == null && b.lastMessage == null) return 0;
          if (a.lastMessage == null) return 1;
          if (b.lastMessage == null) return -1;
          return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
        });

        return allThreads;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync threads from server: $e');
        }
      }
    }

    return localThreads;
  }

  /// Mark message as read (local + server)
  Future<void> markAsRead({
    required String messageId,
    required int userId,
    bool syncToServer = true,
  }) async {
    // Mark locally
    await _localService.markAsRead(messageId);

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        // Extract numeric ID from message ID if needed
        final numericId = int.tryParse(messageId.split('_').last) ?? 0;
        if (numericId > 0) {
          await _api.markAsRead(numericId);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync mark as read to server: $e');
        }
      }
    }
  }

  /// Mark thread as read (local + server)
  Future<void> markThreadAsRead({
    required String threadId,
    required int userId,
    bool syncToServer = true,
  }) async {
    // Mark locally
    await _localService.markThreadAsRead(threadId);

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        await _api.markThreadAsRead(threadId);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync mark thread as read to server: $e');
        }
      }
    }
  }

  /// Get unread count (local + server)
  Future<int> getUnreadCount({
    required int userId,
    bool syncFromServer = true,
  }) async {
    // Get local count
    final localCount = _localService.getUnreadCount(userId: userId);

    // Get server count if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverCount = await _api.getUnreadCount(userId);
        return serverCount;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to get unread count from server: $e');
        }
      }
    }

    return localCount;
  }

  /// Get thread unread count (local + server)
  Future<int> getThreadUnreadCount({
    required String threadId,
    required int userId,
    bool syncFromServer = true,
  }) async {
    // Get local count
    final localCount = _localService.getThreadUnreadCount(threadId, userId);

    // Get server count if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverCount = await _api.getThreadUnreadCount(threadId, userId);
        return serverCount;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to get thread unread count from server: $e');
        }
      }
    }

    return localCount;
  }

  /// Search messages (local + server)
  Future<List<MagentoMessage>> searchMessages({
    required int userId,
    required String query,
    int? limit,
    int? offset,
    bool syncFromServer = true,
  }) async {
    // Search locally
    final localResults = _localService.searchMessages(
      query,
      limit: limit,
      offset: offset,
    );

    // Search server if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverResults = await _api.searchMessages(
          userId: userId,
          query: query,
          limit: limit,
          offset: offset,
        );

        // Merge results
        final allResults = <MagentoMessage>[];
        final seenIds = <String>{};

        // Add server results first
        for (final result in serverResults) {
          if (!seenIds.contains(result.message.id)) {
            allResults.add(result.message);
            seenIds.add(result.message.id);
          }
        }

        // Add local results that aren't already included
        for (final message in localResults) {
          if (!seenIds.contains(message.id)) {
            allResults.add(message);
            seenIds.add(message.id);
          }
        }

        // Sort by timestamp (newest first)
        allResults.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return allResults;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to search messages on server: $e');
        }
      }
    }

    return localResults;
  }

  /// Archive thread (local + server)
  Future<void> archiveThread({
    required String threadId,
    bool syncToServer = true,
  }) async {
    // Archive locally
    await _localService.archiveThread(threadId);

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        await _api.archiveThread(threadId);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync archive thread to server: $e');
        }
      }
    }
  }

  /// Unarchive thread (local + server)
  Future<void> unarchiveThread({
    required String threadId,
    bool syncToServer = true,
  }) async {
    // Unarchive locally
    await _localService.unarchiveThread(threadId);

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        await _api.unarchiveThread(threadId);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync unarchive thread to server: $e');
        }
      }
    }
  }

  /// Get message statistics (local + server)
  Future<MessageStats> getStats({
    required int userId,
    bool syncFromServer = true,
  }) async {
    // Get local stats
    final localStats = _localService.getStats(userId: userId);

    // Get server stats if enabled
    if (syncFromServer && _enableSync) {
      try {
        final serverStats = await _api.getStats(userId);
        return serverStats;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to get stats from server: $e');
        }
      }
    }

    return localStats;
  }

  /// Start typing indicator (local + server)
  Future<void> startTyping({
    required String threadId,
    required int userId,
    bool syncToServer = true,
  }) async {
    // Start locally
    _localService.startTyping(threadId, userId);

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        await _api.startTyping(threadId, userId);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync start typing to server: $e');
        }
      }
    }
  }

  /// Stop typing indicator (local + server)
  Future<void> stopTyping({
    required String threadId,
    required int userId,
    bool syncToServer = true,
  }) async {
    // Stop locally
    _localService.stopTyping(threadId);

    // Sync to server if enabled
    if (syncToServer && _enableSync) {
      try {
        await _api.stopTyping(threadId, userId);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync stop typing to server: $e');
        }
      }
    }
  }

  /// Upload attachment
  Future<String> uploadAttachment({
    required String filePath,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      return await _api.uploadAttachment(
        filePath: filePath,
        fileName: fileName,
        mimeType: mimeType,
      );
    } catch (e) {
      throw Exception('Failed to upload attachment: $e');
    }
  }

  /// Sync with server
  Future<void> _syncWithServer() async {
    // This would typically sync local messages with server
    // Implementation depends on specific requirements
  }

  /// Get local service for direct access
  MagentoMessagingService get localService => _localService;

  /// Get API for direct access
  MessagingApi get api => _api;

  @override
  void dispose() {
    _localService.dispose();
    super.dispose();
  }
}
