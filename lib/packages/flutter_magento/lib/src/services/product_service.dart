import '../flutter_magento_base.dart';
import '../models/product.dart';

/// Magento Product Service
class MagentoProductService {
  final FlutterMagento _client;

  MagentoProductService(this._client);

  /// Get product by SKU
  Future<MagentoProduct> getProductBySku(String sku) async {
    final response = await _client.request('GET', '/products/$sku');
    return MagentoProduct.fromJson(response);
  }

  /// Get product by ID
  Future<MagentoProduct> getProductById(int id) async {
    final response = await _client.request('GET', '/products/$id');
    return MagentoProduct.fromJson(response);
  }

  /// Search products
  Future<List<MagentoProduct>> searchProducts({
    String? searchTerm,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int pageSize = 20,
    int currentPage = 1,
    String sortBy = 'position',
    String sortDirection = 'asc',
  }) async {
    final queryParams = <String, String>{};

    // Build search criteria
    int filterIndex = 0;

    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][field]'] =
          'name';
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][value]'] =
          '%$searchTerm%';
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][condition_type]'] =
          'like';
      filterIndex++;
    }

    if (categoryId != null) {
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][field]'] =
          'category_id';
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][value]'] =
          categoryId.toString();
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][condition_type]'] =
          'eq';
      filterIndex++;
    }

    if (minPrice != null) {
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][field]'] =
          'price';
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][value]'] =
          minPrice.toString();
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][condition_type]'] =
          'gteq';
      filterIndex++;
    }

    if (maxPrice != null) {
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][field]'] =
          'price';
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][value]'] =
          maxPrice.toString();
      queryParams[
              'searchCriteria[filter_groups][$filterIndex][filters][0][condition_type]'] =
          'lteq';
      filterIndex++;
    }

    // Pagination
    queryParams['searchCriteria[pageSize]'] = pageSize.toString();
    queryParams['searchCriteria[currentPage]'] = currentPage.toString();

    // Sorting
    queryParams['searchCriteria[sortOrders][0][field]'] = sortBy;
    queryParams['searchCriteria[sortOrders][0][direction]'] = sortDirection;

    final response = await _client.request(
      'GET',
      '/products',
      queryParameters: queryParams,
    );

    final items = response['items'] as List;
    return items.map((json) => MagentoProduct.fromJson(json)).toList();
  }

  /// Get all products
  Future<List<MagentoProduct>> getAllProducts({
    int pageSize = 20,
    int currentPage = 1,
  }) async {
    return searchProducts(
      pageSize: pageSize,
      currentPage: currentPage,
    );
  }

  /// Create product (requires admin token)
  Future<MagentoProduct> createProduct(MagentoProduct product) async {
    final response = await _client.request(
      'POST',
      '/products',
      body: {'product': product.toJson()},
      headers: _client.auth.getAuthHeaders(useAdmin: true),
    );

    return MagentoProduct.fromJson(response);
  }

  /// Update product (requires admin token)
  Future<MagentoProduct> updateProduct(
      String sku, MagentoProduct product) async {
    final response = await _client.request(
      'PUT',
      '/products/$sku',
      body: {'product': product.toJson()},
      headers: _client.auth.getAuthHeaders(useAdmin: true),
    );

    return MagentoProduct.fromJson(response);
  }

  /// Delete product (requires admin token)
  Future<bool> deleteProduct(String sku) async {
    await _client.request(
      'DELETE',
      '/products/$sku',
      headers: _client.auth.getAuthHeaders(useAdmin: true),
    );

    return true;
  }
}
