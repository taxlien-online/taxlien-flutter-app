import '../flutter_magento_base.dart';
import '../models/cart.dart';

/// Magento Cart Service
class MagentoCartService {
  final FlutterMagento _client;

  MagentoCartService(this._client);

  /// Create empty cart for customer
  Future<int> createCart() async {
    final response = await _client.request(
      'POST',
      '/carts/mine',
      headers: _client.auth.getAuthHeaders(),
    );

    return int.parse(response.toString());
  }

  /// Create guest cart
  Future<String> createGuestCart() async {
    final response = await _client.request('POST', '/guest-carts');
    return response.toString();
  }

  /// Get customer cart
  Future<MagentoCart> getCart() async {
    final response = await _client.request(
      'GET',
      '/carts/mine',
      headers: _client.auth.getAuthHeaders(),
    );

    return MagentoCart.fromJson(response);
  }

  /// Get guest cart
  Future<MagentoCart> getGuestCart(String cartId) async {
    final response = await _client.request('GET', '/guest-carts/$cartId');
    return MagentoCart.fromJson(response);
  }

  /// Add item to customer cart
  Future<MagentoCartItem> addItemToCart({
    required String sku,
    required int quantity,
    String? quoteId,
  }) async {
    final response = await _client.request(
      'POST',
      '/carts/mine/items',
      headers: _client.auth.getAuthHeaders(),
      body: {
        'cartItem': {
          'sku': sku,
          'qty': quantity,
          'quote_id': quoteId,
        }
      },
    );

    return MagentoCartItem.fromJson(response);
  }

  /// Add item to guest cart
  Future<MagentoCartItem> addItemToGuestCart({
    required String cartId,
    required String sku,
    required int quantity,
  }) async {
    final response = await _client.request(
      'POST',
      '/guest-carts/$cartId/items',
      body: {
        'cartItem': {
          'sku': sku,
          'qty': quantity,
          'quote_id': cartId,
        }
      },
    );

    return MagentoCartItem.fromJson(response);
  }

  /// Update cart item
  Future<MagentoCartItem> updateCartItem({
    required int itemId,
    required int quantity,
  }) async {
    final response = await _client.request(
      'PUT',
      '/carts/mine/items/$itemId',
      headers: _client.auth.getAuthHeaders(),
      body: {
        'cartItem': {
          'item_id': itemId,
          'qty': quantity,
        }
      },
    );

    return MagentoCartItem.fromJson(response);
  }

  /// Remove item from cart
  Future<bool> removeCartItem(int itemId) async {
    await _client.request(
      'DELETE',
      '/carts/mine/items/$itemId',
      headers: _client.auth.getAuthHeaders(),
    );

    return true;
  }

  /// Remove item from guest cart
  Future<bool> removeGuestCartItem(String cartId, int itemId) async {
    await _client.request('DELETE', '/guest-carts/$cartId/items/$itemId');
    return true;
  }

  /// Get cart totals
  Future<Map<String, dynamic>> getCartTotals() async {
    final response = await _client.request(
      'GET',
      '/carts/mine/totals',
      headers: _client.auth.getAuthHeaders(),
    );

    return response;
  }

  /// Clear cart
  Future<bool> clearCart() async {
    final cart = await getCart();

    for (var item in cart.items) {
      await removeCartItem(item.itemId);
    }

    return true;
  }
}
