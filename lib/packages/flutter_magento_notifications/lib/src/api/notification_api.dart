import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/notification_models.dart';
import '../models/notification_types.dart';

/// API client for notification operations
class NotificationApi {
  final Dio _dio;
  final String baseUrl;

  NotificationApi({required this.baseUrl, Dio? dio}) : _dio = dio ?? Dio();

  /// Send notification
  Future<MagentoNotification> sendNotification({
    required int userId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    String? priority,
    int? ttl,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/rest/V1/notifications',
        data: {
          'user_id': userId,
          'type': type,
          'title': title,
          'message': message,
          'data': data,
          'priority': priority ?? 'normal',
          'ttl': ttl,
        },
      );

      return MagentoNotification.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  /// Get user notifications
  Future<List<MagentoNotification>> getUserNotifications({
    required int userId,
    int? limit,
    int? offset,
    String? type,
    bool? isRead,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'user_id': userId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (type != null) 'type': type,
        if (isRead != null) 'is_read': isRead,
      };

      final response = await _dio.get(
        '$baseUrl/rest/V1/notifications',
        queryParameters: queryParams,
      );

      final List<dynamic> notificationsJson = response.data['items'] ?? [];
      return notificationsJson
          .map((json) => MagentoNotification.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      await _dio.put('$baseUrl/rest/V1/notifications/$notificationId/read');
      return true;
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead(int userId, {String? type}) async {
    try {
      final data = <String, dynamic>{
        'user_id': userId,
        if (type != null) 'type': type,
      };

      await _dio.put(
        '$baseUrl/rest/V1/notifications/mark-all-read',
        data: data,
      );
      return true;
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Delete notification
  Future<bool> deleteNotification(int notificationId) async {
    try {
      await _dio.delete('$baseUrl/rest/V1/notifications/$notificationId');
      return true;
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Clear all notifications
  Future<bool> clearAllNotifications(int userId, {String? type}) async {
    try {
      final data = <String, dynamic>{
        'user_id': userId,
        if (type != null) 'type': type,
      };

      await _dio.delete('$baseUrl/rest/V1/notifications/clear-all', data: data);
      return true;
    } catch (e) {
      throw Exception('Failed to clear all notifications: $e');
    }
  }

  /// Get unread count
  Future<int> getUnreadCount(int userId, {String? type}) async {
    try {
      final queryParams = <String, dynamic>{
        'user_id': userId,
        if (type != null) 'type': type,
      };

      final response = await _dio.get(
        '$baseUrl/rest/V1/notifications/unread-count',
        queryParameters: queryParams,
      );

      return response.data['count'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  /// Get notification statistics
  Future<NotificationStats> getStats(int userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/rest/V1/notifications/stats',
        queryParameters: {'user_id': userId},
      );

      return NotificationStats.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get notification stats: $e');
    }
  }

  /// Search notifications
  Future<List<MagentoNotification>> searchNotifications({
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
        '$baseUrl/rest/V1/notifications/search',
        queryParameters: queryParams,
      );

      final List<dynamic> notificationsJson = response.data['items'] ?? [];
      return notificationsJson
          .map((json) => MagentoNotification.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search notifications: $e');
    }
  }

  /// Send email notification
  Future<bool> sendEmailNotification({
    required String email,
    required String template,
    Map<String, dynamic>? templateVars,
  }) async {
    try {
      await _dio.post(
        '$baseUrl/rest/V1/notifications/email',
        data: {
          'email': email,
          'template': template,
          'template_vars': templateVars,
        },
      );
      return true;
    } catch (e) {
      throw Exception('Failed to send email notification: $e');
    }
  }

  /// Send push notification
  Future<bool> sendPushNotification({
    required int userId,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _dio.post(
        '$baseUrl/rest/V1/notifications/push',
        data: {
          'user_id': userId,
          'title': title,
          'message': message,
          'data': data,
        },
      );
      return true;
    } catch (e) {
      throw Exception('Failed to send push notification: $e');
    }
  }

  /// Get notification history
  Future<List<MagentoNotification>> getHistory({
    required int userId,
    String? type,
    int? limit,
    int? offset,
    bool? includeExpired,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'user_id': userId,
        if (type != null) 'type': type,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (includeExpired != null) 'include_expired': includeExpired,
      };

      final response = await _dio.get(
        '$baseUrl/rest/V1/notifications/history',
        queryParameters: queryParams,
      );

      final List<dynamic> notificationsJson = response.data['items'] ?? [];
      return notificationsJson
          .map((json) => MagentoNotification.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notification history: $e');
    }
  }

  /// Clear expired notifications
  Future<bool> clearExpired(int userId) async {
    try {
      await _dio.delete(
        '$baseUrl/rest/V1/notifications/clear-expired',
        queryParameters: {'user_id': userId},
      );
      return true;
    } catch (e) {
      throw Exception('Failed to clear expired notifications: $e');
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
