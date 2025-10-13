import '../yuku_client.dart';
import '../models/models.dart';

/// Yuku Marketplace Service
class YukuMarketplaceService {
  final YukuClient _client;

  YukuMarketplaceService(this._client);

  /// Get all active listings
  Future<List<YukuListing>> getActiveListings({
    String? collectionId,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'status': 'active',
    };

    if (collectionId != null) {
      queryParams['collection_id'] = collectionId;
    }
    if (minPrice != null) {
      queryParams['min_price'] = minPrice.toString();
    }
    if (maxPrice != null) {
      queryParams['max_price'] = maxPrice.toString();
    }

    try {
      final response = await _client.request(
        'GET',
        '/listings',
        queryParameters: queryParams,
      );

      final items = response['items'] as List? ?? [];
      return items.map((json) => YukuListing.fromJson(json)).toList();
    } catch (e) {
      // Return empty list for demo purposes
      return [];
    }
  }

  /// Get listing details
  Future<YukuListing?> getListing(String listingId) async {
    try {
      final response = await _client.request('GET', '/listings/$listingId');
      return YukuListing.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Create listing
  Future<YukuListing> createListing({
    required String tokenId,
    required String collectionId,
    required double price,
    String currency = 'ICP',
    int? durationDays,
  }) async {
    final response = await _client.request(
      'POST',
      '/listings',
      body: {
        'token_id': tokenId,
        'collection_id': collectionId,
        'price': price,
        'currency': currency,
        if (durationDays != null)
          'expires_at': DateTime.now()
              .add(Duration(days: durationDays))
              .toIso8601String(),
      },
    );

    return YukuListing.fromJson(response);
  }

  /// Cancel listing
  Future<bool> cancelListing(String listingId) async {
    await _client.request('DELETE', '/listings/$listingId');
    return true;
  }

  /// Buy NFT
  Future<bool> buyNFT({
    required String listingId,
    required String buyerPrincipal,
  }) async {
    await _client.request(
      'POST',
      '/listings/$listingId/buy',
      body: {
        'buyer_principal': buyerPrincipal,
      },
    );

    return true;
  }

  /// Make offer
  Future<YukuOffer> makeOffer({
    required String tokenId,
    required String collectionId,
    required double price,
    String currency = 'ICP',
    int? durationDays,
  }) async {
    final response = await _client.request(
      'POST',
      '/offers',
      body: {
        'token_id': tokenId,
        'collection_id': collectionId,
        'price': price,
        'currency': currency,
        if (durationDays != null)
          'expires_at': DateTime.now()
              .add(Duration(days: durationDays))
              .toIso8601String(),
      },
    );

    return YukuOffer.fromJson(response);
  }

  /// Accept offer
  Future<bool> acceptOffer(String offerId) async {
    await _client.request('POST', '/offers/$offerId/accept');
    return true;
  }

  /// Reject offer
  Future<bool> rejectOffer(String offerId) async {
    await _client.request('POST', '/offers/$offerId/reject');
    return true;
  }

  /// Get offers for token
  Future<List<YukuOffer>> getOffers(String tokenId) async {
    try {
      final response = await _client.request(
        'GET',
        '/offers',
        queryParameters: {'token_id': tokenId},
      );

      final items = response['items'] as List? ?? [];
      return items.map((json) => YukuOffer.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
