import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_models.dart';
import '../models/message_types.dart';

/// Universal messaging service for Magento
/// Provides centralized message management and real-time communication
class MagentoMessagingService extends ChangeNotifier {
  MagentoMessagingService({
    this.enablePersistence = true,
    this.maxHistorySize = 1000,
  });

  final bool enablePersistence;
  final int maxHistorySize;

  // Private fields
  SharedPreferences? _prefs;
  final List<MagentoMessage> _messageHistory = [];
  final List<MessageThread> _threads = [];
  final Map<String, StreamController<MagentoMessage>> _messageControllers = {};
  final Map<String, StreamController<TypingStatus>> _typingControllers = {};
  final Map<String, Timer> _typingTimers = {};
  int _messageIdCounter = 0;

  /// Get stream for specific thread messages
  Stream<MagentoMessage> getMessageStream(String threadId) {
    _messageControllers[threadId] ??= StreamController<MagentoMessage>.broadcast();
    return _messageControllers[threadId]!.stream;
  }

  /// Get stream for typing status
  Stream<TypingStatus> getTypingStream(String threadId) {
    _typingControllers[threadId] ??= StreamController<TypingStatus>.broadcast();
    return _typingControllers[threadId]!.stream;
  }

  /// Initialize the messaging service
  Future<void> initialize() async {
    if (enablePersistence) {
      _prefs ??= await SharedPreferences.getInstance();
      await _loadMessageHistory();
      await _loadThreads();
    }
  }

  /// Send a message
  Future<MagentoMessage> sendMessage({
    required int senderId,
    required int recipientId,
    required String message,
    String? subject,
    int? orderId,
    Map<String, dynamic>? data,
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    final magentoMessage = MagentoMessage(
      id: _generateMessageId(),
      senderId: senderId,
      recipientId: recipientId,
      message: message,
      subject: subject,
      orderId: orderId,
      isRead: false,
      isFromSender: true,
      timestamp: DateTime.now(),
      data: data,
      attachmentUrl: attachmentUrl,
      attachmentType: attachmentType,
    );

    await _addMessage(magentoMessage);
    return magentoMessage;
  }

  /// Reply to a message
  Future<MagentoMessage> replyToMessage({
    required String originalMessageId,
    required String message,
    String? subject,
    Map<String, dynamic>? data,
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    final originalMessage = _messageHistory.firstWhere(
      (m) => m.id == originalMessageId,
      orElse: () => throw Exception('Original message not found'),
    );

    return sendMessage(
      senderId: originalMessage.recipientId,
      recipientId: originalMessage.senderId,
      message: message,
      subject: subject ?? 'Re: ${originalMessage.subject ?? 'Message'}',
      orderId: originalMessage.orderId,
      data: data,
      attachmentUrl: attachmentUrl,
      attachmentType: attachmentType,
    );
  }

  /// Mark message as read
  Future<void> markAsRead(String messageId) async {
    final index = _messageHistory.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messageHistory[index] = _messageHistory[index].copyWith(
        isRead: true,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
      await _saveMessageHistory();
    }
  }

  /// Mark all messages in thread as read
  Future<void> markThreadAsRead(String threadId) async {
    final thread = _threads.firstWhere(
      (t) => t.id == threadId,
      orElse: () => throw Exception('Thread not found'),
    );

    for (int i = 0; i < _messageHistory.length; i++) {
      final message = _messageHistory[i];
      if ((message.senderId == thread.participant1Id && message.recipientId == thread.participant2Id) ||
          (message.senderId == thread.participant2Id && message.recipientId == thread.participant1Id)) {
        _messageHistory[i] = message.copyWith(
          isRead: true,
          updatedAt: DateTime.now(),
        );
      }
    }

    // Update thread unread count
    final threadIndex = _threads.indexWhere((t) => t.id == threadId);
    if (threadIndex != -1) {
      _threads[threadIndex] = _threads[threadIndex].copyWith(unreadCount: 0);
    }

    notifyListeners();
    await _saveMessageHistory();
    await _saveThreads();
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    _messageHistory.removeWhere((m) => m.id == messageId);
    notifyListeners();
    await _saveMessageHistory();
  }

  /// Get messages for a thread
  List<MagentoMessage> getThreadMessages(String threadId, {int? limit, int? offset}) {
    final thread = _threads.firstWhere(
      (t) => t.id == threadId,
      orElse: () => throw Exception('Thread not found'),
    );

    var messages = _messageHistory.where((message) {
      return (message.senderId == thread.participant1Id && message.recipientId == thread.participant2Id) ||
             (message.senderId == thread.participant2Id && message.recipientId == thread.participant1Id);
    }).toList();

    // Sort by timestamp (oldest first)
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (offset != null && offset > 0) {
      messages = messages.skip(offset).toList();
    }

    if (limit != null && limit > 0) {
      messages = messages.take(limit).toList();
    }

    return messages;
  }

  /// Get all threads
  List<MessageThread> getThreads({int? limit, int? offset}) {
    var threads = List<MessageThread>.from(_threads);

    // Sort by last message time (newest first)
    threads.sort((a, b) {
      if (a.lastMessage == null && b.lastMessage == null) return 0;
      if (a.lastMessage == null) return 1;
      if (b.lastMessage == null) return -1;
      return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
    });

    if (offset != null && offset > 0) {
      threads = threads.skip(offset).toList();
    }

    if (limit != null && limit > 0) {
      threads = threads.take(limit).toList();
    }

    return threads;
  }

  /// Get unread message count
  int getUnreadCount({int? userId}) {
    if (userId != null) {
      return _messageHistory.where((message) {
        return message.recipientId == userId && !message.isRead;
      }).length;
    }
    return _messageHistory.where((message) => !message.isRead).length;
  }

  /// Get unread count for specific thread
  int getThreadUnreadCount(String threadId, int userId) {
    final thread = _threads.firstWhere(
      (t) => t.id == threadId,
      orElse: () => throw Exception('Thread not found'),
    );

    return _messageHistory.where((message) {
      return ((message.senderId == thread.participant1Id && message.recipientId == thread.participant2Id) ||
              (message.senderId == thread.participant2Id && message.recipientId == thread.participant1Id)) &&
             message.recipientId == userId &&
             !message.isRead;
    }).length;
  }

  /// Search messages
  List<MagentoMessage> searchMessages(String query, {int? limit, int? offset}) {
    var results = _messageHistory.where((message) {
      return message.message.toLowerCase().contains(query.toLowerCase()) ||
             (message.subject?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();

    // Sort by timestamp (newest first)
    results.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (offset != null && offset > 0) {
      results = results.skip(offset).toList();
    }

    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }

    return results;
  }

  /// Start typing indicator
  void startTyping(String threadId, int userId) {
    _typingControllers[threadId]?.add(TypingStatus.typing);
    
    // Clear existing timer
    _typingTimers[threadId]?.cancel();
    
    // Set timer to stop typing after timeout
    _typingTimers[threadId] = Timer(const Duration(seconds: 3), () {
      stopTyping(threadId);
    });
  }

  /// Stop typing indicator
  void stopTyping(String threadId) {
    _typingControllers[threadId]?.add(TypingStatus.stopped);
    _typingTimers[threadId]?.cancel();
  }

  /// Archive thread
  Future<void> archiveThread(String threadId) async {
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index != -1) {
      _threads[index] = _threads[index].copyWith(
        isArchived: true,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
      await _saveThreads();
    }
  }

  /// Unarchive thread
  Future<void> unarchiveThread(String threadId) async {
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index != -1) {
      _threads[index] = _threads[index].copyWith(
        isArchived: false,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
      await _saveThreads();
    }
  }

  /// Get archived threads
  List<MessageThread> getArchivedThreads({int? limit, int? offset}) {
    var threads = _threads.where((t) => t.isArchived).toList();

    // Sort by last message time (newest first)
    threads.sort((a, b) {
      if (a.lastMessage == null && b.lastMessage == null) return 0;
      if (a.lastMessage == null) return 1;
      if (b.lastMessage == null) return -1;
      return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
    });

    if (offset != null && offset > 0) {
      threads = threads.skip(offset).toList();
    }

    if (limit != null && limit > 0) {
      threads = threads.take(limit).toList();
    }

    return threads;
  }

  /// Get message statistics
  MessageStats getStats({int? userId}) {
    final messages = userId != null
        ? _messageHistory.where((m) => m.senderId == userId || m.recipientId == userId)
        : _messageHistory;

    return MessageStats(
      totalMessages: messages.length,
      unreadMessages: getUnreadCount(userId: userId),
      sentMessages: userId != null
          ? messages.where((m) => m.senderId == userId).length
          : _messageHistory.length,
      receivedMessages: userId != null
          ? messages.where((m) => m.recipientId == userId).length
          : _messageHistory.length,
      activeThreads: _threads.where((t) => !t.isArchived).length,
      archivedThreads: _threads.where((t) => t.isArchived).length,
    );
  }

  /// Clear message history
  Future<void> clearHistory({String? threadId}) async {
    if (threadId != null) {
      final thread = _threads.firstWhere(
        (t) => t.id == threadId,
        orElse: () => throw Exception('Thread not found'),
      );
      
      _messageHistory.removeWhere((message) {
        return (message.senderId == thread.participant1Id && message.recipientId == thread.participant2Id) ||
               (message.senderId == thread.participant2Id && message.recipientId == thread.participant1Id);
      });
    } else {
      _messageHistory.clear();
    }
    
    notifyListeners();
    await _saveMessageHistory();
  }

  // Private methods

  Future<void> _addMessage(MagentoMessage message) async {
    // Add to history
    _messageHistory.add(message);

    // Limit history size
    if (_messageHistory.length > maxHistorySize) {
      _messageHistory.removeRange(0, _messageHistory.length - maxHistorySize);
    }

    // Update or create thread
    await _updateThread(message);

    // Broadcast to subscribers
    final threadId = _getThreadId(message.senderId, message.recipientId);
    final controller = _messageControllers[threadId];
    if (controller != null && !controller.isClosed) {
      controller.add(message);
    }

    // Notify listeners
    notifyListeners();

    // Save to persistence
    if (enablePersistence) {
      await _saveMessageHistory();
      await _saveThreads();
    }
  }

  Future<void> _updateThread(MagentoMessage message) async {
    final threadId = _getThreadId(message.senderId, message.recipientId);
    
    final existingThreadIndex = _threads.indexWhere((t) => t.id == threadId);
    
    if (existingThreadIndex != -1) {
      // Update existing thread
      final thread = _threads[existingThreadIndex];
      final unreadCount = message.recipientId == thread.participant1Id || message.recipientId == thread.participant2Id
          ? thread.unreadCount + (message.isRead ? 0 : 1)
          : thread.unreadCount;
      
      _threads[existingThreadIndex] = thread.copyWith(
        lastMessage: message,
        unreadCount: unreadCount,
        updatedAt: DateTime.now(),
      );
    } else {
      // Create new thread
      final thread = MessageThread(
        id: threadId,
        participant1Id: message.senderId,
        participant2Id: message.recipientId,
        participant1Name: 'User ${message.senderId}', // TODO: Get actual names
        participant2Name: 'User ${message.recipientId}',
        lastMessage: message,
        unreadCount: message.isRead ? 0 : 1,
        createdAt: DateTime.now(),
      );
      
      _threads.add(thread);
    }
  }

  String _getThreadId(int participant1Id, int participant2Id) {
    // Create consistent thread ID regardless of order
    final sortedIds = [participant1Id, participant2Id]..sort();
    return 'thread_${sortedIds[0]}_${sortedIds[1]}';
  }

  String _generateMessageId() {
    return 'message_${_messageIdCounter++}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _loadMessageHistory() async {
    // In a real implementation, this would load from persistent storage
    // For now, we'll skip the actual persistence logic
  }

  Future<void> _saveMessageHistory() async {
    // In a real implementation, this would save to persistent storage
    // For now, we'll skip the actual persistence logic
  }

  Future<void> _loadThreads() async {
    // In a real implementation, this would load from persistent storage
    // For now, we'll skip the actual persistence logic
  }

  Future<void> _saveThreads() async {
    // In a real implementation, this would save to persistent storage
    // For now, we'll skip the actual persistence logic
  }

  @override
  void dispose() {
    // Close all stream controllers
    for (final controller in _messageControllers.values) {
      controller.close();
    }
    _messageControllers.clear();

    for (final controller in _typingControllers.values) {
      controller.close();
    }
    _typingControllers.clear();

    // Cancel all timers
    for (final timer in _typingTimers.values) {
      timer.cancel();
    }
    _typingTimers.clear();

    super.dispose();
  }
}


