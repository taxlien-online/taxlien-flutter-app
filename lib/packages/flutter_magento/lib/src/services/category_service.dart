import '../flutter_magento_base.dart';
import '../models/category.dart';

/// Magento Category Service
class MagentoCategoryService {
  final FlutterMagento _client;

  MagentoCategoryService(this._client);

  /// Get category by ID
  Future<MagentoCategory> getCategory(int categoryId) async {
    final response = await _client.request('GET', '/categories/$categoryId');
    return MagentoCategory.fromJson(response);
  }

  /// Get all categories
  Future<List<MagentoCategory>> getAllCategories() async {
    final response =
        await _client.request('GET', '/categories/list', queryParameters: {
      'searchCriteria[pageSize]': '100',
    });

    final items = response['items'] as List;
    return items.map((json) => MagentoCategory.fromJson(json)).toList();
  }

  /// Get root categories
  Future<List<MagentoCategory>> getRootCategories() async {
    final response =
        await _client.request('GET', '/categories/list', queryParameters: {
      'searchCriteria[filter_groups][0][filters][0][field]': 'level',
      'searchCriteria[filter_groups][0][filters][0][value]': '2',
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
    });

    final items = response['items'] as List;
    return items.map((json) => MagentoCategory.fromJson(json)).toList();
  }

  /// Get child categories
  Future<List<MagentoCategory>> getChildCategories(int parentId) async {
    final response =
        await _client.request('GET', '/categories/list', queryParameters: {
      'searchCriteria[filter_groups][0][filters][0][field]': 'parent_id',
      'searchCriteria[filter_groups][0][filters][0][value]':
          parentId.toString(),
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
    });

    final items = response['items'] as List;
    return items.map((json) => MagentoCategory.fromJson(json)).toList();
  }

  /// Create category (requires admin token)
  Future<MagentoCategory> createCategory(MagentoCategory category) async {
    final response = await _client.request(
      'POST',
      '/categories',
      body: {'category': category.toJson()},
      headers: _client.auth.getAuthHeaders(useAdmin: true),
    );

    return MagentoCategory.fromJson(response);
  }

  /// Update category (requires admin token)
  Future<MagentoCategory> updateCategory(
      int categoryId, MagentoCategory category) async {
    final response = await _client.request(
      'PUT',
      '/categories/$categoryId',
      body: {'category': category.toJson()},
      headers: _client.auth.getAuthHeaders(useAdmin: true),
    );

    return MagentoCategory.fromJson(response);
  }

  /// Delete category (requires admin token)
  Future<bool> deleteCategory(int categoryId) async {
    await _client.request(
      'DELETE',
      '/categories/$categoryId',
      headers: _client.auth.getAuthHeaders(useAdmin: true),
    );

    return true;
  }
}
