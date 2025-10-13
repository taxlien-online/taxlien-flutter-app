import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/models.dart';
import 'services/services.dart';
import 'exceptions/yuku_exception.dart';

/// Main Yuku Marketplace Client
class YukuClient extends ChangeNotifier {
  static YukuClient? _instance;

  late final String _baseUrl;
  late final http.Client _httpClient;
  String? _authToken;

  bool _isInitialized = false;

  // Services
  late final YukuMarketplaceService _marketplaceService;
  late final YukuCollectionService _collectionService;
  late final YukuNFTService _nftService;

  YukuClient._internal();

  /// Get singleton instance
  factory YukuClient() {
    _instance ??= YukuClient._internal();
    return _instance!;
  }

  /// Initialize the Yuku client
  Future<void> initialize({
    String baseUrl = 'https://yuku.app',
    String? authToken,
    http.Client? httpClient,
  }) async {
    try {
      _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;
      _authToken = authToken;
      _httpClient = httpClient ?? http.Client();

      // Initialize services
      _marketplaceService = YukuMarketplaceService(this);
      _collectionService = YukuCollectionService(this);
      _nftService = YukuNFTService(this);

      _isInitialized = true;
      notifyListeners();

      if (kDebugMode) {
        print('YukuClient initialized');
      }
    } catch (e) {
      throw YukuException('Failed to initialize YukuClient: $e');
    }
  }

  /// Make HTTP request to Yuku API
  Future<dynamic> request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    if (!_isInitialized) {
      throw YukuException('YukuClient not initialized');
    }

    final uri = _buildUri(endpoint, queryParameters);
    final requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      ...?headers,
    };

    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _httpClient.get(uri, headers: requestHeaders);
          break;
        case 'POST':
          response = await _httpClient.post(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await _httpClient.put(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _httpClient.delete(uri, headers: requestHeaders);
          break;
        default:
          throw YukuException('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } catch (e) {
      if (e is YukuException) rethrow;
      throw YukuException('Network error: $e');
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final path = '/api/v1$endpoint';
    final uri = Uri.parse('$_baseUrl$path');

    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }

    return uri;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;

      try {
        return json.decode(response.body);
      } catch (e) {
        return response.body;
      }
    } else {
      String message = 'HTTP ${response.statusCode}';

      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map && errorBody.containsKey('message')) {
          message = errorBody['message'];
        }
      } catch (_) {
        message = response.body.isNotEmpty ? response.body : message;
      }

      throw YukuException(message, response.statusCode);
    }
  }

  // Getters
  bool get isInitialized => _isInitialized;
  String get baseUrl => _baseUrl;
  http.Client get httpClient => _httpClient;
  bool get isAuthenticated => _authToken != null;

  // Service getters
  YukuMarketplaceService get marketplace => _marketplaceService;
  YukuCollectionService get collections => _collectionService;
  YukuNFTService get nfts => _nftService;

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
    notifyListeners();
  }

  /// Clear authentication
  void clearAuth() {
    _authToken = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}
