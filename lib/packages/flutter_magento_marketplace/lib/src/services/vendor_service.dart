import '../flutter_magento_marketplace_base.dart';
import '../models/vendor.dart';

/// Marketplace Vendor Service
class MarketplaceVendorService {
  final FlutterMagentoMarketplace _client;

  MarketplaceVendorService(this._client);

  /// Get vendor by ID
  Future<MarketplaceVendor> getVendor(int vendorId) async {
    final response = await _client.request('GET', '/vendors/$vendorId');
    return MarketplaceVendor.fromJson(response);
  }

  /// Get all vendors
  Future<List<MarketplaceVendor>> getAllVendors({
    int pageSize = 20,
    int currentPage = 1,
    bool? activeOnly,
  }) async {
    final queryParams = <String, String>{
      'searchCriteria[pageSize]': pageSize.toString(),
      'searchCriteria[currentPage]': currentPage.toString(),
    };

    if (activeOnly == true) {
      queryParams['searchCriteria[filter_groups][0][filters][0][field]'] =
          'is_active';
      queryParams['searchCriteria[filter_groups][0][filters][0][value]'] = '1';
      queryParams[
              'searchCriteria[filter_groups][0][filters][0][condition_type]'] =
          'eq';
    }

    final response = await _client.request(
      'GET',
      '/vendors',
      queryParameters: queryParams,
    );

    final items = response['items'] as List;
    return items.map((json) => MarketplaceVendor.fromJson(json)).toList();
  }

  /// Search vendors
  Future<List<MarketplaceVendor>> searchVendors(String searchTerm) async {
    final queryParams = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'name',
      'searchCriteria[filter_groups][0][filters][0][value]': '%$searchTerm%',
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'like',
    };

    final response = await _client.request(
      'GET',
      '/vendors',
      queryParameters: queryParams,
    );

    final items = response['items'] as List;
    return items.map((json) => MarketplaceVendor.fromJson(json)).toList();
  }

  /// Create vendor
  Future<MarketplaceVendor> createVendor(MarketplaceVendor vendor) async {
    final response = await _client.request(
      'POST',
      '/vendors',
      body: {'vendor': vendor.toJson()},
    );

    return MarketplaceVendor.fromJson(response);
  }

  /// Update vendor
  Future<MarketplaceVendor> updateVendor(
      int vendorId, MarketplaceVendor vendor) async {
    final response = await _client.request(
      'PUT',
      '/vendors/$vendorId',
      body: {'vendor': vendor.toJson()},
    );

    return MarketplaceVendor.fromJson(response);
  }

  /// Delete vendor
  Future<bool> deleteVendor(int vendorId) async {
    await _client.request('DELETE', '/vendors/$vendorId');
    return true;
  }

  /// Get vendor statistics
  Future<Map<String, dynamic>> getVendorStatistics(int vendorId) async {
    final response =
        await _client.request('GET', '/vendors/$vendorId/statistics');
    return response;
  }
}
