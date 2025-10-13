import '../yuku_client.dart';
import '../models/models.dart';

/// Yuku NFT Service
class YukuNFTService {
  final YukuClient _client;

  YukuNFTService(this._client);

  /// Get NFT details
  Future<YukuNFT?> getNFT(String collectionId, String tokenId) async {
    try {
      final response = await _client.request(
        'GET',
        '/nfts/$collectionId/$tokenId',
      );

      return YukuNFT.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Get NFTs by collection
  Future<List<YukuNFT>> getNFTsByCollection(
    String collectionId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.request(
        'GET',
        '/nfts/$collectionId',
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final items = response['items'] as List? ?? [];
      return items.map((json) => YukuNFT.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get NFTs owned by principal
  Future<List<YukuNFT>> getOwnedNFTs(
    String principal, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.request(
        'GET',
        '/users/$principal/nfts',
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final items = response['items'] as List? ?? [];
      return items.map((json) => YukuNFT.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Transfer NFT
  Future<bool> transferNFT({
    required String collectionId,
    required String tokenId,
    required String toPrincipal,
  }) async {
    await _client.request(
      'POST',
      '/nfts/$collectionId/$tokenId/transfer',
      body: {
        'to_principal': toPrincipal,
      },
    );

    return true;
  }
}
