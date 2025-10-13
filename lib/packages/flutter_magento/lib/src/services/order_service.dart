import '../flutter_magento_base.dart';
import '../models/order.dart';

/// Magento Order Service
class MagentoOrderService {
  final FlutterMagento _client;

  MagentoOrderService(this._client);

  /// Place order
  Future<MagentoOrder> placeOrder({
    Map<String, dynamic>? paymentMethod,
    Map<String, dynamic>? billingAddress,
    Map<String, dynamic>? shippingAddress,
  }) async {
    final response = await _client.request(
      'PUT',
      '/carts/mine/order',
      headers: _client.auth.getAuthHeaders(),
      body: {
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
        if (billingAddress != null) 'billingAddress': billingAddress,
      },
    );

    // Get the order by ID
    final orderId = int.parse(response.toString());
    return getOrder(orderId);
  }

  /// Get order by ID
  Future<MagentoOrder> getOrder(int orderId) async {
    final response = await _client.request(
      'GET',
      '/orders/$orderId',
      headers: _client.auth.getAuthHeaders(),
    );

    return MagentoOrder.fromJson(response);
  }

  /// Get customer orders
  Future<List<MagentoOrder>> getCustomerOrders({
    int pageSize = 20,
    int currentPage = 1,
  }) async {
    final queryParams = {
      'searchCriteria[pageSize]': pageSize.toString(),
      'searchCriteria[currentPage]': currentPage.toString(),
      'searchCriteria[sortOrders][0][field]': 'created_at',
      'searchCriteria[sortOrders][0][direction]': 'DESC',
    };

    final response = await _client.request(
      'GET',
      '/orders',
      headers: _client.auth.getAuthHeaders(),
      queryParameters: queryParams,
    );

    final items = response['items'] as List;
    return items.map((json) => MagentoOrder.fromJson(json)).toList();
  }

  /// Cancel order
  Future<bool> cancelOrder(int orderId) async {
    await _client.request(
      'POST',
      '/orders/$orderId/cancel',
      headers: _client.auth.getAuthHeaders(),
    );

    return true;
  }

  /// Add order comment
  Future<bool> addOrderComment(int orderId, String comment) async {
    await _client.request(
      'POST',
      '/orders/$orderId/comments',
      headers: _client.auth.getAuthHeaders(),
      body: {
        'statusHistory': {
          'comment': comment,
          'parent_id': orderId,
          'is_customer_notified': 0,
          'is_visible_on_front': 1,
        }
      },
    );

    return true;
  }

  /// Get order status history
  Future<List<Map<String, dynamic>>> getOrderStatusHistory(int orderId) async {
    final response = await _client.request(
      'GET',
      '/orders/$orderId',
      headers: _client.auth.getAuthHeaders(),
    );

    return List<Map<String, dynamic>>.from(
      response['status_histories'] ?? [],
    );
  }
}
