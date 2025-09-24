import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

/// Magento service for handling e-commerce operations
class MagentoService extends ChangeNotifier {
  late Dio _dio;
  String? _cartId;
  bool _isInitialized = false;
  String? _error;
  final String _baseUrl = 'https://api.taxlien.online';

  MagentoService() {
    _initializeMagento();
  }

  void _initializeMagento() {
    try {
      _dio = Dio(BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));
      _isInitialized = true;
      _error = null;
    } catch (e) {
      _error = 'Failed to initialize Magento: $e';
      _isInitialized = false;
    }
  }

  bool get isInitialized => _isInitialized;
  String? get error => _error;
  String? get cartId => _cartId;

  /// Create a new cart
  Future<String?> createCart() async {
    if (!_isInitialized) {
      _error = 'Magento not initialized';
      return null;
    }

    try {
      final response = await _dio.post('/rest/V1/carts/mine');
      _cartId = response.data.toString();
      notifyListeners();
      return _cartId;
    } catch (e) {
      _error = 'Failed to create cart: $e';
      notifyListeners();
      return null;
    }
  }

  /// Add product to cart
  Future<bool> addToCart({
    required String sku,
    required int quantity,
    Map<String, dynamic>? options,
  }) async {
    if (!_isInitialized) {
      _error = 'Magento not initialized';
      return false;
    }

    if (_cartId == null) {
      await createCart();
      if (_cartId == null) {
        return false;
      }
    }

    try {
      final cartItem = {
        'cart_item': {
          'sku': sku,
          'qty': quantity,
          'quote_id': _cartId,
        }
      };
      
      await _dio.post('/rest/V1/carts/mine/items', data: cartItem);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add to cart: $e';
      notifyListeners();
      return false;
    }
  }

  /// Get cart items
  Future<List<Map<String, dynamic>>> getCartItems() async {
    if (!_isInitialized || _cartId == null) {
      return [];
    }

    try {
      final response = await _dio.get('/rest/V1/carts/mine/items');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      _error = 'Failed to get cart items: $e';
      notifyListeners();
      return [];
    }
  }

  /// Update cart item quantity
  Future<bool> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    if (!_isInitialized || _cartId == null) {
      return false;
    }

    try {
      final data = {
        'cart_item': {
          'item_id': int.parse(itemId),
          'qty': quantity,
        }
      };
      
      await _dio.put('/rest/V1/carts/mine/items/$itemId', data: data);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update cart item: $e';
      notifyListeners();
      return false;
    }
  }

  /// Remove item from cart
  Future<bool> removeFromCart(String itemId) async {
    if (!_isInitialized || _cartId == null) {
      return false;
    }

    try {
      await _dio.delete('/rest/V1/carts/mine/items/$itemId');
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to remove from cart: $e';
      notifyListeners();
      return false;
    }
  }

  /// Get cart totals
  Future<Map<String, dynamic>?> getCartTotals() async {
    if (!_isInitialized || _cartId == null) {
      return null;
    }

    try {
      final response = await _dio.get('/rest/V1/carts/mine/totals');
      return response.data;
    } catch (e) {
      _error = 'Failed to get cart totals: $e';
      notifyListeners();
      return null;
    }
  }

  /// Set shipping information
  Future<bool> setShippingInformation({
    required Map<String, dynamic> address,
    required String method,
  }) async {
    if (!_isInitialized || _cartId == null) {
      return false;
    }

    try {
      final data = {
        'addressInformation': {
          'shipping_address': address,
          'shipping_method_code': method,
          'shipping_carrier_code': method,
        }
      };
      
      await _dio.post('/rest/V1/carts/mine/shipping-information', data: data);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to set shipping information: $e';
      notifyListeners();
      return false;
    }
  }

  /// Set payment method
  Future<bool> setPaymentMethod({
    required String method,
    Map<String, dynamic>? additionalData,
  }) async {
    if (!_isInitialized || _cartId == null) {
      return false;
    }

    try {
      final data = {
        'paymentMethod': {
          'method': method,
          'additional_data': additionalData ?? {},
        }
      };
      
      await _dio.post('/rest/V1/carts/mine/payment-methods', data: data);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to set payment method: $e';
      notifyListeners();
      return false;
    }
  }

  /// Place order
  Future<String?> placeOrder() async {
    if (!_isInitialized || _cartId == null) {
      return null;
    }

    try {
      final response = await _dio.post('/rest/V1/carts/mine/checkout');
      final orderId = response.data.toString();
      
      // Clear cart after successful order
      _cartId = null;
      notifyListeners();
      return orderId;
    } catch (e) {
      _error = 'Failed to place order: $e';
      notifyListeners();
      return null;
    }
  }

  /// Get customer orders
  Future<List<Map<String, dynamic>>> getCustomerOrders() async {
    if (!_isInitialized) {
      return [];
    }

    try {
      final response = await _dio.get('/rest/V1/orders');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      _error = 'Failed to get customer orders: $e';
      notifyListeners();
      return [];
    }
  }

  /// Get order details
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    if (!_isInitialized) {
      return null;
    }

    try {
      final response = await _dio.get('/rest/V1/orders/$orderId');
      return response.data;
    } catch (e) {
      _error = 'Failed to get order details: $e';
      notifyListeners();
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set cart ID (for persistence)
  void setCartId(String cartId) {
    _cartId = cartId;
    notifyListeners();
  }
}
