// Mock classes for flutter_nft and flutter_icp packages
// These are temporary until the actual packages are available

class NFTClient {
  NFTProvider? getNFTProvider(dynamic network) => NFTProvider();
  WalletProvider? getWalletProvider(dynamic network) => WalletProvider();
  MarketplaceProvider? getMarketplaceProvider(dynamic network) =>
      MarketplaceProvider();
}

class NFTProvider {
  Future<void> mintNFT({
    required String toAddress,
    required NFTMetadata metadata,
    required String contractAddress,
  }) async {}

  Future<List<NFT>> getNFTs(String address) async => [];

  Future<List<NFT>> getNFTsByOwner(String address) async => [];
}

class WalletProvider {
  bool get isConnected => false;
  String? get connectedAddress => null;

  Future<bool> connect() async => false;
  Future<void> disconnect() async {}

  Future<Map<String, double>> getBalances(List<String> tokens) async => {};
  Future<List<WalletTransaction>> getTransactionHistory() async => [];
}

class MarketplaceProvider {
  Future<List<NFTListing>> getActiveListings() async => [];
  Future<List<NFTListing>> getUserListings(String address) async => [];
  Future<List<NFTOffer>> getUserOffers(String address) async => [];
  Future<List<NFTOffer>> getActiveOffers() async => [];

  Future<String> buyNFT({
    required String listingId,
    required String buyerAddress,
  }) async =>
      '';

  Future<bool> cancelListing(String listingId) async => false;
  Future<bool> cancelOffer(String offerId) async => false;
  Future<bool> acceptOffer(String offerId) async => false;
  Future<bool> rejectOffer(String offerId) async => false;
}

class NFT {
  final String id;
  final String name;
  final String description;
  final String image;
  final NFTMetadata? metadata;

  NFT({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.metadata,
  });
}

class NFTMetadata {
  final String name;
  final String description;
  final String image;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> properties;

  NFTMetadata({
    required this.name,
    required this.description,
    required this.image,
    required this.attributes,
    required this.properties,
  });
}

class NFTListing {
  final String id;
  final String nftId;
  final double price;
  final String status;
  final DateTime? createdAt;

  NFTListing({
    required this.id,
    required this.nftId,
    required this.price,
    required this.status,
    this.createdAt,
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}

class NFTOffer {
  final String id;
  final String nftId;
  final double amount;
  final String status;
  final String? buyerAddress;
  final DateTime? createdAt;

  NFTOffer({
    required this.id,
    required this.nftId,
    required this.amount,
    required this.status,
    this.buyerAddress,
    this.createdAt,
  });

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
}

class WalletTransaction {
  final String id;
  final String type;
  final double amount;
  final String status;
  final DateTime timestamp;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.timestamp,
  });
}

class BlockchainNetwork {
  static const icp = 'icp';
  static const ethereum = 'ethereum';
  static const polygon = 'polygon';
}

class ListingStatus {
  static const active = 'active';
  static const sold = 'sold';
  static const cancelled = 'cancelled';
}

class OfferStatus {
  static const pending = 'pending';
  static const accepted = 'accepted';
  static const rejected = 'rejected';
  static const expired = 'expired';
}
