import 'dart:convert';
import '../core/admin_panel/data_provider.dart';
import 'api_service.dart';
import 'server_config_service.dart';

/// Custom data provider that adapts the existing API service to admin panel
class TaxLienDataProvider implements AdminDataProvider {
  final ApiService _apiService;

  TaxLienDataProvider({
    required ApiService apiService,
    required ServerConfigService configService,
  }) : _apiService = apiService;

  @override
  Future<ListResult> getList(
    String resource, {
    PaginationConfig? pagination,
    List<FilterConfig>? filters,
    SortConfig? sort,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};

      if (pagination != null) {
        queryParams['page'] = pagination.page.toString();
        queryParams['page_size'] = pagination.pageSize.toString();
      }

      if (sort != null) {
        queryParams['sort_field'] = sort.field;
        queryParams['sort_order'] = sort.ascending ? 'asc' : 'desc';
      }

      if (filters != null && filters.isNotEmpty) {
        for (var i = 0; i < filters.length; i++) {
          final filter = filters[i];
          queryParams['filter_${i}_field'] = filter.field;
          queryParams['filter_${i}_operator'] = filter.operator.toString();
          queryParams['filter_${i}_value'] = filter.value.toString();
        }
      }

      // Build endpoint
      String endpoint = '/api/admin/$resource';
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        endpoint += '?$queryString';
      }

      // Make request
      final response = await _apiService.makeRequest('GET', endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ListResult(
          data: List<Map<String, dynamic>>.from(data['data'] ?? []),
          total: data['total'] ?? 0,
        );
      } else {
        throw Exception('Failed to get list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting list for $resource: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getOne(String resource, String id) async {
    try {
      final response =
          await _apiService.makeRequest('GET', '/api/admin/$resource/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? data;
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Failed to get one: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting $resource with id $id: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> create(
      String resource, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.makeRequest(
        'POST',
        '/api/admin/$resource',
        body: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] ?? responseData;
      } else {
        throw Exception('Failed to create: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating $resource: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> update(
      String resource, String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.makeRequest(
        'PUT',
        '/api/admin/$resource/$id',
        body: data,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] ?? responseData;
      } else {
        throw Exception('Failed to update: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating $resource with id $id: $e');
    }
  }

  @override
  Future<void> delete(String resource, String id) async {
    try {
      final response =
          await _apiService.makeRequest('DELETE', '/api/admin/$resource/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting $resource with id $id: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMany(
      String resource, List<String> ids) async {
    try {
      final results = <Map<String, dynamic>>[];
      for (final id in ids) {
        try {
          final item = await getOne(resource, id);
          results.add(item);
        } catch (e) {
          // Skip failed items
        }
      }
      return results;
    } catch (e) {
      throw Exception('Error getting many from $resource: $e');
    }
  }

  @override
  Future<void> deleteMany(String resource, List<String> ids) async {
    try {
      for (final id in ids) {
        try {
          await delete(resource, id);
        } catch (e) {
          // Continue with other deletions even if one fails
        }
      }
    } catch (e) {
      throw Exception('Error deleting many from $resource: $e');
    }
  }

  @override
  Future<void> updateMany(
      String resource, List<String> ids, Map<String, dynamic> data) async {
    try {
      for (final id in ids) {
        try {
          await update(resource, id, data);
        } catch (e) {
          // Continue with other updates even if one fails
        }
      }
    } catch (e) {
      throw Exception('Error updating many in $resource: $e');
    }
  }
}
