import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'services/cart_service.dart';
import 'services/customer_service.dart';
import 'services/order_service.dart';
import 'services/category_service.dart';
import 'exceptions/magento_exception.dart';

/// Main FlutterMagento client class
/// Provides access to all Magento 2 REST API functionality
class FlutterMagento extends ChangeNotifier {
  static FlutterMagento? _instance;

  late final String _baseUrl;
  late final http.Client _httpClient;
  late final Map<String, String> _defaultHeaders;

  bool _isInitialized = false;
  bool _isOnline = true;
  String? _storeCode;

  // Services
  late final MagentoAuthService _authService;
  late final MagentoProductService _productService;
  late final MagentoCartService _cartService;
  late final MagentoCustomerService _customerService;
  late final MagentoOrderService _orderService;
  late final MagentoCategoryService _categoryService;

  FlutterMagento._internal();

  /// Get singleton instance
  factory FlutterMagento() {
    _instance ??= FlutterMagento._internal();
    return _instance!;
  }

  /// Initialize the Magento client
  Future<void> initialize({
    required String baseUrl,
    String? storeCode,
    int connectionTimeout = 30000,
    int receiveTimeout = 30000,
    Map<String, String>? headers,
    bool enableCaching = true,
    bool enableRateLimiting = true,
    http.Client? httpClient,
  }) async {
    try {
      _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;
      _storeCode = storeCode;
      _httpClient = httpClient ?? http.Client();

      _defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

      // Initialize services
      _authService = MagentoAuthService(this);
      _productService = MagentoProductService(this);
      _cartService = MagentoCartService(this);
      _customerService = MagentoCustomerService(this);
      _orderService = MagentoOrderService(this);
      _categoryService = MagentoCategoryService(this);

      _isInitialized = true;
      notifyListeners();

      if (kDebugMode) {
        print('FlutterMagento initialized with base URL: $_baseUrl');
      }
    } catch (e) {
      throw MagentoException('Failed to initialize FlutterMagento: $e', 0);
    }
  }

  /// Make HTTP request to Magento API
  Future<dynamic> request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    if (!_isInitialized) {
      throw MagentoException('FlutterMagento not initialized', 0);
    }

    final uri = _buildUri(endpoint, queryParameters);
    final requestHeaders = {..._defaultHeaders, ...?headers};

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
          throw MagentoException('Unsupported HTTP method: $method', 0);
      }

      return _handleResponse(response);
    } catch (e) {
      if (e is MagentoException) rethrow;
      throw MagentoException('Network error: $e', 0);
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final path = _storeCode != null
        ? '/rest/$_storeCode/V1$endpoint'
        : '/rest/V1$endpoint';

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

      throw MagentoException(message, response.statusCode);
    }
  }

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isOnline => _isOnline;
  String get baseUrl => _baseUrl;
  String? get storeCode => _storeCode;
  http.Client get httpClient => _httpClient;

  // Service getters
  MagentoAuthService get auth => _authService;
  MagentoProductService get products => _productService;
  MagentoCartService get cart => _cartService;
  MagentoCustomerService get customers => _customerService;
  MagentoOrderService get orders => _orderService;
  MagentoCategoryService get categories => _categoryService;

  /// Set online/offline status
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}
