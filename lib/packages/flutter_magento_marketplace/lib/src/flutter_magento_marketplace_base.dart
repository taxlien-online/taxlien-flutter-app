import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/vendor_service.dart';
import 'services/seller_service.dart';
import 'services/marketplace_product_service.dart';
import 'exceptions/marketplace_exception.dart';

/// Main FlutterMagentoMarketplace client class
/// Extends Magento functionality with marketplace/multi-vendor features
class FlutterMagentoMarketplace extends ChangeNotifier {
  static FlutterMagentoMarketplace? _instance;

  late final String _baseUrl;
  late final http.Client _httpClient;
  late final Map<String, String> _defaultHeaders;
  String? _authToken;

  bool _isInitialized = false;

  // Services
  late final MarketplaceVendorService _vendorService;
  late final MarketplaceSellerService _sellerService;
  late final MarketplaceProductService _productService;

  FlutterMagentoMarketplace._internal();

  /// Get singleton instance
  factory FlutterMagentoMarketplace() {
    _instance ??= FlutterMagentoMarketplace._internal();
    return _instance!;
  }

  /// Initialize the Marketplace client
  Future<void> initialize({
    required String baseUrl,
    String? authToken,
    Map<String, String>? headers,
    http.Client? httpClient,
  }) async {
    try {
      _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;
      _authToken = authToken;
      _httpClient = httpClient ?? http.Client();

      _defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        ...?headers,
      };

      // Initialize services
      _vendorService = MarketplaceVendorService(this);
      _sellerService = MarketplaceSellerService(this);
      _productService = MarketplaceProductService(this);

      _isInitialized = true;
      notifyListeners();

      if (kDebugMode) {
        print('FlutterMagentoMarketplace initialized');
      }
    } catch (e) {
      throw MarketplaceException('Failed to initialize marketplace: $e', 0);
    }
  }

  /// Make HTTP request to Marketplace API
  Future<dynamic> request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    if (!_isInitialized) {
      throw MarketplaceException('Marketplace not initialized', 0);
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
          throw MarketplaceException('Unsupported HTTP method: $method', 0);
      }

      return _handleResponse(response);
    } catch (e) {
      if (e is MarketplaceException) rethrow;
      throw MarketplaceException('Network error: $e', 0);
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final path = '/rest/V1/marketplace$endpoint';
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

      throw MarketplaceException(message, response.statusCode);
    }
  }

  // Getters
  bool get isInitialized => _isInitialized;
  String get baseUrl => _baseUrl;
  http.Client get httpClient => _httpClient;

  // Service getters
  MarketplaceVendorService get vendors => _vendorService;
  MarketplaceSellerService get sellers => _sellerService;
  MarketplaceProductService get products => _productService;

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
    _defaultHeaders['Authorization'] = 'Bearer $token';
    notifyListeners();
  }

  /// Clear authentication
  void clearAuth() {
    _authToken = null;
    _defaultHeaders.remove('Authorization');
    notifyListeners();
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}
