import '../models/models.dart';

/// Abstract NFT Provider interface
/// Implement this for each blockchain network
abstract class NFTProvider {
  /// Mint a new NFT
  Future<NFT> mintNFT({
    required String metadataUrl,
    required String recipientAddress,
    String? collectionId,
  });

  /// Transfer NFT to another address
  Future<bool> transferNFT({
    required String tokenId,
    required String toAddress,
    String? fromAddress,
  });

  /// Get NFT details
  Future<NFT?> getNFT(String tokenId);

  /// Get all NFTs owned by an address
  Future<List<NFT>> getOwnedNFTs(String address);

  /// Burn/destroy NFT
  Future<bool> burnNFT(String tokenId) async {
    throw UnimplementedError('burnNFT not implemented');
  }

  /// Get NFT metadata
  Future<NFTMetadata?> getNFTMetadata(String metadataUrl) async {
    throw UnimplementedError('getNFTMetadata not implemented');
  }

  /// Create NFT collection
  Future<NFTCollection> createCollection({
    required String name,
    required String description,
    String? symbol,
  }) async {
    throw UnimplementedError('createCollection not implemented');
  }

  /// Get collection details
  Future<NFTCollection?> getCollection(String collectionId) async {
    throw UnimplementedError('getCollection not implemented');
  }
}
