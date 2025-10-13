import '../models/models.dart';

/// Abstract Marketplace Provider interface
/// Implement this for each NFT marketplace (Yuku, Entrepot, etc.)
abstract class MarketplaceProvider {
  /// Create a listing for an NFT
  Future<NFTListing> createListing({
    required String tokenId,
    required double price,
    required String currency,
    required String sellerAddress,
    int? durationDays,
  });

  /// Cancel a listing
  Future<bool> cancelListing(String listingId) async {
    throw UnimplementedError('cancelListing not implemented');
  }

  /// Buy an NFT from a listing
  Future<bool> buyNFT({
    required String listingId,
    required String buyerAddress,
    double? price,
  });

  /// Get active listings
  Future<List<NFTListing>> getActiveListings({
    String? collectionId,
    double? minPrice,
    double? maxPrice,
    String? currency,
  });

  /// Get listing details
  Future<NFTListing?> getListing(String listingId) async {
    throw UnimplementedError('getListing not implemented');
  }

  /// Create an offer for an NFT
  Future<NFTOffer> createOffer({
    required String tokenId,
    required double price,
    required String currency,
    required String buyerAddress,
    int? durationDays,
  }) async {
    throw UnimplementedError('createOffer not implemented');
  }

  /// Accept an offer
  Future<bool> acceptOffer(String offerId) async {
    throw UnimplementedError('acceptOffer not implemented');
  }

  /// Reject an offer
  Future<bool> rejectOffer(String offerId) async {
    throw UnimplementedError('rejectOffer not implemented');
  }

  /// Get offers for a token
  Future<List<NFTOffer>> getOffers(String tokenId) async {
    throw UnimplementedError('getOffers not implemented');
  }
}
