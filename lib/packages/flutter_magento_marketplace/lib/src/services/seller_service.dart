import '../flutter_magento_marketplace_base.dart';
import '../models/seller.dart';

/// Marketplace Seller Service
class MarketplaceSellerService {
  final FlutterMagentoMarketplace _client;

  MarketplaceSellerService(this._client);

  /// Get seller by ID
  Future<MarketplaceSeller> getSeller(int sellerId) async {
    final response = await _client.request('GET', '/sellers/$sellerId');
    return MarketplaceSeller.fromJson(response);
  }

  /// Get sellers by vendor
  Future<List<MarketplaceSeller>> getVendorSellers(int vendorId) async {
    final queryParams = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'vendor_id',
      'searchCriteria[filter_groups][0][filters][0][value]':
          vendorId.toString(),
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
    };

    final response = await _client.request(
      'GET',
      '/sellers',
      queryParameters: queryParams,
    );

    final items = response['items'] as List;
    return items.map((json) => MarketplaceSeller.fromJson(json)).toList();
  }

  /// Create seller
  Future<MarketplaceSeller> createSeller(MarketplaceSeller seller) async {
    final response = await _client.request(
      'POST',
      '/sellers',
      body: {'seller': seller.toJson()},
    );

    return MarketplaceSeller.fromJson(response);
  }

  /// Update seller
  Future<MarketplaceSeller> updateSeller(
      int sellerId, MarketplaceSeller seller) async {
    final response = await _client.request(
      'PUT',
      '/sellers/$sellerId',
      body: {'seller': seller.toJson()},
    );

    return MarketplaceSeller.fromJson(response);
  }

  /// Delete seller
  Future<bool> deleteSeller(int sellerId) async {
    await _client.request('DELETE', '/sellers/$sellerId');
    return true;
  }

  /// Update seller permissions
  Future<bool> updateSellerPermissions(
      int sellerId, List<String> permissions) async {
    await _client.request(
      'PUT',
      '/sellers/$sellerId/permissions',
      body: {'permissions': permissions},
    );

    return true;
  }
}
