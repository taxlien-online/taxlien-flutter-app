// Simple stub for flutter_nft package
// This is a temporary implementation to avoid build errors

class NFTClient {
  static final NFTClient _instance = NFTClient._internal();
  factory NFTClient() => _instance;
  NFTClient._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    _isInitialized = true;
  }

  bool get isInitialized => _isInitialized;

  void registerNFTProvider(NFTProvider provider) {}
  void registerWalletProvider(WalletProvider provider) {}
  void registerMarketplaceProvider(MarketplaceProvider provider) {}

  NFTProvider? getNFTProvider(dynamic network) => null;
  WalletProvider? getWalletProvider(dynamic network) => null;
  MarketplaceProvider? getMarketplaceProvider(dynamic network) => null;
}

class NFT {
  final String tokenId;
  final String contractAddress;
  final String ownerAddress;
  final String metadataUrl;
  final String? collectionId;
  final DateTime createdAt;
  final Map<String, dynamic>? properties;

  NFT({
    required this.tokenId,
    required this.contractAddress,
    required this.ownerAddress,
    required this.metadataUrl,
    this.collectionId,
    required this.createdAt,
    this.properties,
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
  final String tokenId;
  final double price;
  final String currency;
  final String sellerAddress;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status;
  final String marketplaceId;

  NFTListing({
    required this.id,
    required this.tokenId,
    required this.price,
    required this.currency,
    required this.sellerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    required this.marketplaceId,
  });
}

class NFTOffer {
  final String id;
  final String tokenId;
  final double price;
  final String currency;
  final String buyerAddress;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status;

  NFTOffer({
    required this.id,
    required this.tokenId,
    required this.price,
    required this.currency,
    required this.buyerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
  });
}

class NFTProvider {
  Future<NFT> mintNFT({
    required String metadataUrl,
    required String recipientAddress,
    String? collectionId,
  }) async {
    throw UnimplementedError('NFTProvider.mintNFT not implemented');
  }

  Future<bool> transferNFT({
    required String tokenId,
    required String toAddress,
    String? fromAddress,
  }) async {
    throw UnimplementedError('NFTProvider.transferNFT not implemented');
  }

  Future<NFT?> getNFT(String tokenId) async {
    throw UnimplementedError('NFTProvider.getNFT not implemented');
  }

  Future<List<NFT>> getOwnedNFTs(String address) async {
    throw UnimplementedError('NFTProvider.getOwnedNFTs not implemented');
  }
}

class WalletProvider {
  Future<String> connect() async {
    throw UnimplementedError('WalletProvider.connect not implemented');
  }

  Future<void> disconnect() async {
    throw UnimplementedError('WalletProvider.disconnect not implemented');
  }

  Future<String> signMessage(String message) async {
    throw UnimplementedError('WalletProvider.signMessage not implemented');
  }

  Future<String> signTransaction(Map<String, dynamic> transaction) async {
    throw UnimplementedError('WalletProvider.signTransaction not implemented');
  }

  bool get isConnected => false;
  String? get address => null;
}

class MarketplaceProvider {
  Future<NFTListing> createListing({
    required String tokenId,
    required double price,
    required String currency,
    required String sellerAddress,
    int? durationDays,
  }) async {
    throw UnimplementedError(
        'MarketplaceProvider.createListing not implemented');
  }

  Future<bool> buyNFT({
    required String listingId,
    required String buyerAddress,
    double? price,
  }) async {
    throw UnimplementedError('MarketplaceProvider.buyNFT not implemented');
  }

  Future<List<NFTListing>> getActiveListings({
    String? collectionId,
    double? minPrice,
    double? maxPrice,
    String? currency,
  }) async {
    throw UnimplementedError(
        'MarketplaceProvider.getActiveListings not implemented');
  }
}

class NFTException implements Exception {
  final String message;
  NFTException(this.message);

  @override
  String toString() => 'NFTException: $message';
}
