import '../flutter_magento_marketplace_base.dart';
import '../models/marketplace_product.dart';

/// Marketplace Product Service
class MarketplaceProductService {
  final FlutterMagentoMarketplace _client;

  MarketplaceProductService(this._client);

  /// Get products by vendor
  Future<List<MarketplaceProduct>> getVendorProducts(
    int vendorId, {
    int pageSize = 20,
    int currentPage = 1,
  }) async {
    final queryParams = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'vendor_id',
      'searchCriteria[filter_groups][0][filters][0][value]':
          vendorId.toString(),
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
      'searchCriteria[pageSize]': pageSize.toString(),
      'searchCriteria[currentPage]': currentPage.toString(),
    };

    final response = await _client.request(
      'GET',
      '/products',
      queryParameters: queryParams,
    );

    final items = response['items'] as List;
    return items.map((json) => MarketplaceProduct.fromJson(json)).toList();
  }

  /// Get marketplace product by ID
  Future<MarketplaceProduct> getProduct(int productId) async {
    final response = await _client.request('GET', '/products/$productId');
    return MarketplaceProduct.fromJson(response);
  }

  /// Create vendor product
  Future<MarketplaceProduct> createProduct(MarketplaceProduct product) async {
    final response = await _client.request(
      'POST',
      '/products',
      body: {'product': product.toJson()},
    );

    return MarketplaceProduct.fromJson(response);
  }

  /// Update vendor product
  Future<MarketplaceProduct> updateProduct(
      int productId, MarketplaceProduct product) async {
    final response = await _client.request(
      'PUT',
      '/products/$productId',
      body: {'product': product.toJson()},
    );

    return MarketplaceProduct.fromJson(response);
  }

  /// Delete vendor product
  Future<bool> deleteProduct(int productId) async {
    await _client.request('DELETE', '/products/$productId');
    return true;
  }

  /// Approve product (admin only)
  Future<bool> approveProduct(int productId) async {
    await _client.request(
      'PUT',
      '/products/$productId/approve',
    );

    return true;
  }

  /// Reject product (admin only)
  Future<bool> rejectProduct(int productId, String reason) async {
    await _client.request(
      'PUT',
      '/products/$productId/reject',
      body: {'reason': reason},
    );

    return true;
  }

  /// Get pending products (admin only)
  Future<List<MarketplaceProduct>> getPendingProducts({
    int pageSize = 20,
    int currentPage = 1,
  }) async {
    final queryParams = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'is_approved',
      'searchCriteria[filter_groups][0][filters][0][value]': '0',
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
      'searchCriteria[pageSize]': pageSize.toString(),
      'searchCriteria[currentPage]': currentPage.toString(),
    };

    final response = await _client.request(
      'GET',
      '/products',
      queryParameters: queryParams,
    );

    final items = response['items'] as List;
    return items.map((json) => MarketplaceProduct.fromJson(json)).toList();
  }
}
