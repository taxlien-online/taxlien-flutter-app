import '../yuku_client.dart';
import '../models/models.dart';

/// Yuku Collection Service
class YukuCollectionService {
  final YukuClient _client;

  YukuCollectionService(this._client);

  /// Get all collections
  Future<List<YukuCollection>> getAllCollections({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.request(
        'GET',
        '/collections',
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final items = response['items'] as List? ?? [];
      return items.map((json) => YukuCollection.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get collection details
  Future<YukuCollection?> getCollection(String collectionId) async {
    try {
      final response =
          await _client.request('GET', '/collections/$collectionId');
      return YukuCollection.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Search collections
  Future<List<YukuCollection>> searchCollections(String query) async {
    try {
      final response = await _client.request(
        'GET',
        '/collections/search',
        queryParameters: {'q': query},
      );

      final items = response['items'] as List? ?? [];
      return items.map((json) => YukuCollection.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get trending collections
  Future<List<YukuCollection>> getTrendingCollections({int limit = 10}) async {
    try {
      final response = await _client.request(
        'GET',
        '/collections/trending',
        queryParameters: {'limit': limit.toString()},
      );

      final items = response['items'] as List? ?? [];
      return items.map((json) => YukuCollection.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get collection stats
  Future<Map<String, dynamic>> getCollectionStats(String collectionId) async {
    try {
      final response = await _client.request(
        'GET',
        '/collections/$collectionId/stats',
      );

      return response;
    } catch (e) {
      return {};
    }
  }
}
