import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../models/magento_models.dart';

/// Service for integrating with Magento API
/// Handles customers, products, cart, and other Magento operations
class MagentoApiService extends ChangeNotifier {
  late final Dio _dio;
  String? _customerToken;
  String? _guestToken;
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _customerToken != null;
  String? get customerToken => _customerToken;

  MagentoApiService() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.magentoRestEndpoint,
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for logging and error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          print('Magento API Request: ${options.method} ${options.path}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('Magento API Response: ${response.statusCode}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          print('Magento API Error: ${error.message}');
        }
        _handleError(error);
        handler.next(error);
      },
    ));
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        _error = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        if (statusCode == 401) {
          _error = 'Authentication failed. Please login again.';
          _customerToken = null;
        } else if (statusCode == 403) {
          _error = 'Access denied. You don\'t have permission to perform this action.';
        } else if (statusCode == 404) {
          _error = 'Resource not found.';
        } else if (statusCode == 422) {
          final message = responseData is Map ? responseData['message'] : 'Validation error.';
          _error = message;
        } else if (statusCode == 500) {
          _error = 'Server error. Please try again later.';
        } else {
          _error = 'An error occurred. Please try again.';
        }
        break;
      case DioExceptionType.cancel:
        _error = 'Request was cancelled.';
        break;
      default:
        _error = 'Network error. Please check your connection.';
        break;
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Authentication Methods

  /// Create a new customer account
  Future<MagentoCustomer?> createCustomer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.post('/customers', data: {
        'customer': {
          'email': email,
          'firstname': firstName,
          'lastname': lastName,
          'password': password,
        },
      });

      if (response.statusCode == 200) {
        final customer = MagentoCustomer.fromJson(response.data);
        return customer;
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Authenticate customer and get token
  Future<bool> authenticateCustomer({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.post('/integration/customer/token', data: {
        'username': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        _customerToken = response.data;
        _updateAuthHeader();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get guest token for anonymous operations
  Future<bool> getGuestToken() async {
    try {
      final response = await _dio.post('/integration/guest-cart');
      
      if (response.statusCode == 200) {
        _guestToken = response.data;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Logout customer
  void logout() {
    _customerToken = null;
    _guestToken = null;
    _updateAuthHeader();
    notifyListeners();
  }

  void _updateAuthHeader() {
    final token = _customerToken ?? _guestToken;
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  // Customer Methods

  /// Get current customer information
  Future<MagentoCustomer?> getCurrentCustomer() async {
    if (!isAuthenticated) return null;

    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/customers/me');
      
      if (response.statusCode == 200) {
        return MagentoCustomer.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update customer information
  Future<bool> updateCustomer(MagentoCustomer customer) async {
    if (!isAuthenticated) return false;

    _setLoading(true);
    clearError();

    try {
      final response = await _dio.put('/customers/me', data: {
        'customer': customer.toJson(),
      });

      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Change customer password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!isAuthenticated) return false;

    _setLoading(true);
    clearError();

    try {
      final response = await _dio.put('/customers/me/password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Product Methods

  /// Get products with pagination and filters
  Future<MagentoProductList?> getProducts({
    int page = 1,
    int pageSize = AppConstants.defaultPageSize,
    String? searchQuery,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
    Map<String, dynamic>? filters,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final queryParams = <String, dynamic>{
        'searchCriteria[pageSize]': pageSize,
        'searchCriteria[currentPage]': page,
      };

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['searchCriteria[filterGroups][0][filters][0][field]'] = 'name';
        queryParams['searchCriteria[filterGroups][0][filters][0][value]'] = '%$searchQuery%';
        queryParams['searchCriteria[filterGroups][0][filters][0][conditionType]'] = 'like';
      }

      if (categoryId != null) {
        queryParams['searchCriteria[filterGroups][1][filters][0][field]'] = 'category_id';
        queryParams['searchCriteria[filterGroups][1][filters][0][value]'] = categoryId;
        queryParams['searchCriteria[filterGroups][1][filters][0][conditionType]'] = 'eq';
      }

      if (sortBy != null) {
        queryParams['searchCriteria[sortOrders][0][field]'] = sortBy;
        queryParams['searchCriteria[sortOrders][0][direction]'] = sortOrder ?? 'ASC';
      }

      final response = await _dio.get('/products', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return MagentoProductList.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get product by SKU
  Future<MagentoProduct?> getProduct(String sku) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/products/$sku');
      
      if (response.statusCode == 200) {
        return MagentoProduct.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get product categories
  Future<List<MagentoCategory>?> getCategories() async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/categories');
      
      if (response.statusCode == 200) {
        final List<dynamic> categoriesData = response.data['children_data'];
        return categoriesData.map((json) => MagentoCategory.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      // Log the error but don't crash the app
      if (kDebugMode) {
        print('Magento API Error in getCategories: $e');
      }
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Cart Methods

  /// Create a new cart
  Future<String?> createCart() async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.post('/guest-carts');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get cart information
  Future<MagentoCart?> getCart(String cartId) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/guest-carts/$cartId');
      
      if (response.statusCode == 200) {
        return MagentoCart.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Add item to cart
  Future<bool> addToCart({
    required String cartId,
    required String sku,
    required int quantity,
    Map<String, dynamic>? productOption,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final cartItem = {
        'cartItem': {
          'sku': sku,
          'qty': quantity,
          if (productOption != null) 'product_option': productOption,
        },
      };

      final response = await _dio.post('/guest-carts/$cartId/items', data: cartItem);
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update cart item quantity
  Future<bool> updateCartItem({
    required String cartId,
    required int itemId,
    required int quantity,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.put('/guest-carts/$cartId/items/$itemId', data: {
        'cartItem': {
          'qty': quantity,
        },
      });
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove item from cart
  Future<bool> removeFromCart({
    required String cartId,
    required int itemId,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.delete('/guest-carts/$cartId/items/$itemId');
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Apply coupon to cart
  Future<bool> applyCoupon({
    required String cartId,
    required String couponCode,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.put('/guest-carts/$cartId/coupons/$couponCode');
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove coupon from cart
  Future<bool> removeCoupon({
    required String cartId,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.delete('/guest-carts/$cartId/coupons');
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Order Methods

  /// Create order from cart
  Future<MagentoOrder?> createOrder({
    required String cartId,
    required MagentoOrderRequest orderRequest,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.post('/guest-carts/$cartId/order', data: orderRequest.toJson());
      
      if (response.statusCode == 200) {
        return MagentoOrder.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get customer orders
  Future<List<MagentoOrder>?> getCustomerOrders() async {
    if (!isAuthenticated) return null;

    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/customers/me/orders');
      
      if (response.statusCode == 200) {
        final List<dynamic> ordersData = response.data;
        return ordersData.map((json) => MagentoOrder.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get order by ID
  Future<MagentoOrder?> getOrder(String orderId) async {
    if (!isAuthenticated) return null;

    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/customers/me/orders/$orderId');
      
      if (response.statusCode == 200) {
        return MagentoOrder.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Wishlist Methods

  /// Get customer wishlist
  Future<MagentoWishlist?> getWishlist() async {
    if (!isAuthenticated) return null;

    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/customers/me/wishlist');
      
      if (response.statusCode == 200) {
        return MagentoWishlist.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Add product to wishlist
  Future<bool> addToWishlist(String sku) async {
    if (!isAuthenticated) return false;

    _setLoading(true);
    clearError();

    try {
      final response = await _dio.post('/customers/me/wishlist', data: {
        'wishlistItem': {
          'sku': sku,
        },
      });
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove product from wishlist
  Future<bool> removeFromWishlist(int itemId) async {
    if (!isAuthenticated) return false;

    _setLoading(true);
    clearError();

    try {
      final response = await _dio.delete('/customers/me/wishlist/$itemId');
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Store Methods

  /// Get store configuration
  Future<MagentoStoreConfig?> getStoreConfig() async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/store/storeConfigs');
      
      if (response.statusCode == 200) {
        final List<dynamic> configsData = response.data;
        if (configsData.isNotEmpty) {
          return MagentoStoreConfig.fromJson(configsData.first);
        }
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get available currencies
  Future<List<MagentoCurrency>?> getCurrencies() async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/directory/currency');
      
      if (response.statusCode == 200) {
        final List<dynamic> currenciesData = response.data;
        return currenciesData.map((json) => MagentoCurrency.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get available countries
  Future<List<MagentoCountry>?> getCountries() async {
    _setLoading(true);
    clearError();

    try {
      final response = await _dio.get('/directory/countries');
      
      if (response.statusCode == 200) {
        final List<dynamic> countriesData = response.data;
        return countriesData.map((json) => MagentoCountry.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Search products
  Future<MagentoProductList?> searchProducts({
    String? query,
    int page = 1,
    int pageSize = 20,
    String? sortField,
    String? sortDirection = 'asc',
  }) async {
    _setLoading(true);
    clearError();

    try {
      final Map<String, dynamic> params = {
        'searchCriteria[pageSize]': pageSize,
        'searchCriteria[currentPage]': page,
      };

      if (query != null && query.isNotEmpty) {
        params['searchCriteria[filterGroups][0][filters][0][field]'] = 'name';
        params['searchCriteria[filterGroups][0][filters][0][value]'] = query;
        params['searchCriteria[filterGroups][0][filters][0][conditionType]'] = 'like';
      }

      if (sortField != null) {
        params['searchCriteria[sortOrders][0][field]'] = sortField;
        params['searchCriteria[sortOrders][0][direction]'] = sortDirection;
      }

      final response = await _dio.get('/products', queryParameters: params);
      
      if (response.statusCode == 200) {
        return MagentoProductList.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _error = 'Failed to search products: $e';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
  }
}
