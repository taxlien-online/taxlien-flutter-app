import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/message_models.dart';
import '../models/message_types.dart';

/// API client for messaging operations
class MessagingApi {
  final Dio _dio;
  final String baseUrl;

  MessagingApi({required this.baseUrl, Dio? dio}) : _dio = dio ?? Dio();

  /// Send message
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
    try {
      final response = await _dio.post(
        '$baseUrl/rest/V1/messenger/messages',
        data: {
          'sender_id': senderId,
          'recipient_id': recipientId,
          'message': message,
          'subject': subject,
          'order_id': orderId,
          'data': data,
          'attachment_url': attachmentUrl,
          'attachment_type': attachmentType,
        },
      );

      return MagentoMessage.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Reply to message
  Future<MagentoMessage> replyToMessage({
    required int messageId,
    required String message,
    String? subject,
    Map<String, dynamic>? data,
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/rest/V1/messenger/messages/$messageId/reply',
        data: {
          'message': message,
          'subject': subject,
          'data': data,
          'attachment_url': attachmentUrl,
          'attachment_type': attachmentType,
        },
      );

      return MagentoMessage.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to reply to message: $e');
    }
  }

  /// Get thread messages
  Future<List<MagentoMessage>> getThreadMessages({
    required String threadId,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      final response = await _dio.get(
        '$baseUrl/rest/V1/messenger/threads/$threadId/messages',
        queryParameters: queryParams,
      );

      final List<dynamic> messagesJson = response.data['items'] ?? [];
      return messagesJson.map((json) => MagentoMessage.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get thread messages: $e');
    }
  }

  /// Get message threads
  Future<List<MessageThread>> getThreads({
    required int userId,
    int? limit,
    int? offset,
    bool? isArchived,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'user_id': userId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (isArchived != null) 'is_archived': isArchived,
      };

      final response = await _dio.get(
        '$baseUrl/rest/V1/messenger/threads',
        queryParameters: queryParams,
      );

      final List<dynamic> threadsJson = response.data['items'] ?? [];
      return threadsJson.map((json) => MessageThread.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get threads: $e');
    }
  }

  /// Mark message as read
  Future<bool> markAsRead(int messageId) async {
    try {
      await _dio.put('$baseUrl/rest/V1/messenger/messages/$messageId/read');
      return true;
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }

  /// Mark thread as read
  Future<bool> markThreadAsRead(String threadId) async {
    try {
      await _dio.put('$baseUrl/rest/V1/messenger/threads/$threadId/read');
      return true;
    } catch (e) {
      throw Exception('Failed to mark thread as read: $e');
    }
  }

  /// Delete message
  Future<bool> deleteMessage(int messageId) async {
    try {
      await _dio.delete('$baseUrl/rest/V1/messenger/messages/$messageId');
      return true;
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  /// Get unread count
  Future<int> getUnreadCount(int userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/rest/V1/messenger/unread-count',
        queryParameters: {'user_id': userId},
      );

      return response.data['count'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  /// Get thread unread count
  Future<int> getThreadUnreadCount(String threadId, int userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/rest/V1/messenger/threads/$threadId/unread-count',
        queryParameters: {'user_id': userId},
      );

      return response.data['count'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get thread unread count: $e');
    }
  }

  /// Search messages
  Future<List<MessageSearchResult>> searchMessages({
    required int userId,
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'user_id': userId,
        'query': query,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      final response = await _dio.get(
        '$baseUrl/rest/V1/messenger/search',
        queryParameters: queryParams,
      );

      final List<dynamic> resultsJson = response.data['items'] ?? [];
      return resultsJson
          .map((json) => MessageSearchResult.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search messages: $e');
    }
  }

  /// Archive thread
  Future<bool> archiveThread(String threadId) async {
    try {
      await _dio.put('$baseUrl/rest/V1/messenger/threads/$threadId/archive');
      return true;
    } catch (e) {
      throw Exception('Failed to archive thread: $e');
    }
  }

  /// Unarchive thread
  Future<bool> unarchiveThread(String threadId) async {
    try {
      await _dio.put('$baseUrl/rest/V1/messenger/threads/$threadId/unarchive');
      return true;
    } catch (e) {
      throw Exception('Failed to unarchive thread: $e');
    }
  }

  /// Get archived threads
  Future<List<MessageThread>> getArchivedThreads({
    required int userId,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'user_id': userId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      final response = await _dio.get(
        '$baseUrl/rest/V1/messenger/threads/archived',
        queryParameters: queryParams,
      );

      final List<dynamic> threadsJson = response.data['items'] ?? [];
      return threadsJson.map((json) => MessageThread.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get archived threads: $e');
    }
  }

  /// Get message statistics
  Future<MessageStats> getStats(int userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/rest/V1/messenger/stats',
        queryParameters: {'user_id': userId},
      );

      return MessageStats.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get message stats: $e');
    }
  }

  /// Clear thread history
  Future<bool> clearThreadHistory(String threadId) async {
    try {
      await _dio.delete(
        '$baseUrl/rest/V1/messenger/threads/$threadId/messages',
      );
      return true;
    } catch (e) {
      throw Exception('Failed to clear thread history: $e');
    }
  }

  /// Start typing indicator
  Future<bool> startTyping(String threadId, int userId) async {
    try {
      await _dio.post(
        '$baseUrl/rest/V1/messenger/threads/$threadId/typing',
        data: {'user_id': userId, 'status': 'typing'},
      );
      return true;
    } catch (e) {
      throw Exception('Failed to start typing indicator: $e');
    }
  }

  /// Stop typing indicator
  Future<bool> stopTyping(String threadId, int userId) async {
    try {
      await _dio.post(
        '$baseUrl/rest/V1/messenger/threads/$threadId/typing',
        data: {'user_id': userId, 'status': 'stopped'},
      );
      return true;
    } catch (e) {
      throw Exception('Failed to stop typing indicator: $e');
    }
  }

  /// Upload attachment
  Future<String> uploadAttachment({
    required String filePath,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        '$baseUrl/rest/V1/messenger/attachments',
        data: formData,
      );

      return response.data['url'] ?? '';
    } catch (e) {
      throw Exception('Failed to upload attachment: $e');
    }
  }

  /// Get attachment info
  Future<Map<String, dynamic>> getAttachmentInfo(String attachmentUrl) async {
    try {
      final response = await _dio.get(
        '$baseUrl/rest/V1/messenger/attachments/info',
        queryParameters: {'url': attachmentUrl},
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to get attachment info: $e');
    }
  }

  /// Set authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authentication token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Set base URL
  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  /// Set timeout
  void setTimeout(Duration timeout) {
    _dio.options.connectTimeout = timeout;
    _dio.options.receiveTimeout = timeout;
    _dio.options.sendTimeout = timeout;
  }
}
