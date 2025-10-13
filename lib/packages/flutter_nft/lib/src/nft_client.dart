import 'package:flutter/foundation.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'exceptions/nft_exception.dart';

/// Main NFT Client
/// Manages NFT operations across multiple blockchains
class NFTClient extends ChangeNotifier {
  static NFTClient? _instance;

  final Map<String, NFTProvider> _nftProviders = {};
  final Map<String, WalletProvider> _walletProviders = {};
  final Map<String, MarketplaceProvider> _marketplaceProviders = {};

  bool _isInitialized = false;

  NFTClient._internal();

  /// Get singleton instance
  factory NFTClient() {
    _instance ??= NFTClient._internal();
    return _instance!;
  }

  /// Initialize the NFT client
  Future<void> initialize() async {
    try {
      _isInitialized = true;
      notifyListeners();

      if (kDebugMode) {
        print('NFTClient initialized');
      }
    } catch (e) {
      throw NFTException('Failed to initialize NFTClient: $e');
    }
  }

  /// Register NFT provider for a specific blockchain
  void registerNFTProvider(String network, NFTProvider provider) {
    _nftProviders[network] = provider;
    notifyListeners();

    if (kDebugMode) {
      print('NFT Provider registered for network: $network');
    }
  }

  /// Register wallet provider for a specific blockchain
  void registerWalletProvider(String network, WalletProvider provider) {
    _walletProviders[network] = provider;
    notifyListeners();

    if (kDebugMode) {
      print('Wallet Provider registered for network: $network');
    }
  }

  /// Register marketplace provider for a specific marketplace
  void registerMarketplaceProvider(
      String marketplace, MarketplaceProvider provider) {
    _marketplaceProviders[marketplace] = provider;
    notifyListeners();

    if (kDebugMode) {
      print('Marketplace Provider registered: $marketplace');
    }
  }

  /// Get NFT provider for network
  NFTProvider? getNFTProvider(String network) {
    return _nftProviders[network];
  }

  /// Get wallet provider for network
  WalletProvider? getWalletProvider(String network) {
    return _walletProviders[network];
  }

  /// Get marketplace provider
  MarketplaceProvider? getMarketplaceProvider(String marketplace) {
    return _marketplaceProviders[marketplace];
  }

  /// Get all registered networks
  List<String> get registeredNetworks => _nftProviders.keys.toList();

  /// Get all registered marketplaces
  List<String> get registeredMarketplaces =>
      _marketplaceProviders.keys.toList();

  /// Check if initialized
  bool get isInitialized => _isInitialized;

  /// Mint NFT on specified network
  Future<NFT> mintNFT({
    required String network,
    required String metadataUrl,
    required String recipientAddress,
    String? collectionId,
  }) async {
    final provider = getNFTProvider(network);
    if (provider == null) {
      throw NFTException('No NFT provider registered for network: $network');
    }

    return await provider.mintNFT(
      metadataUrl: metadataUrl,
      recipientAddress: recipientAddress,
      collectionId: collectionId,
    );
  }

  /// Transfer NFT on specified network
  Future<bool> transferNFT({
    required String network,
    required String tokenId,
    required String toAddress,
    String? fromAddress,
  }) async {
    final provider = getNFTProvider(network);
    if (provider == null) {
      throw NFTException('No NFT provider registered for network: $network');
    }

    return await provider.transferNFT(
      tokenId: tokenId,
      toAddress: toAddress,
      fromAddress: fromAddress,
    );
  }

  /// Get NFT details
  Future<NFT?> getNFT({
    required String network,
    required String tokenId,
  }) async {
    final provider = getNFTProvider(network);
    if (provider == null) {
      throw NFTException('No NFT provider registered for network: $network');
    }

    return await provider.getNFT(tokenId);
  }

  /// Get owned NFTs for an address
  Future<List<NFT>> getOwnedNFTs({
    required String network,
    required String address,
  }) async {
    final provider = getNFTProvider(network);
    if (provider == null) {
      throw NFTException('No NFT provider registered for network: $network');
    }

    return await provider.getOwnedNFTs(address);
  }

  /// Connect wallet
  Future<String> connectWallet(String network) async {
    final provider = getWalletProvider(network);
    if (provider == null) {
      throw NFTException('No wallet provider registered for network: $network');
    }

    return await provider.connect();
  }

  /// Disconnect wallet
  Future<void> disconnectWallet(String network) async {
    final provider = getWalletProvider(network);
    if (provider == null) {
      throw NFTException('No wallet provider registered for network: $network');
    }

    await provider.disconnect();
  }

  /// Create marketplace listing
  Future<NFTListing> createListing({
    required String marketplace,
    required String tokenId,
    required double price,
    required String currency,
    required String sellerAddress,
    int? durationDays,
  }) async {
    final provider = getMarketplaceProvider(marketplace);
    if (provider == null) {
      throw NFTException('No marketplace provider registered: $marketplace');
    }

    return await provider.createListing(
      tokenId: tokenId,
      price: price,
      currency: currency,
      sellerAddress: sellerAddress,
      durationDays: durationDays,
    );
  }

  /// Buy NFT from marketplace
  Future<bool> buyNFT({
    required String marketplace,
    required String listingId,
    required String buyerAddress,
    double? price,
  }) async {
    final provider = getMarketplaceProvider(marketplace);
    if (provider == null) {
      throw NFTException('No marketplace provider registered: $marketplace');
    }

    return await provider.buyNFT(
      listingId: listingId,
      buyerAddress: buyerAddress,
      price: price,
    );
  }

  /// Get active marketplace listings
  Future<List<NFTListing>> getActiveListings({
    required String marketplace,
    String? collectionId,
    double? minPrice,
    double? maxPrice,
    String? currency,
  }) async {
    final provider = getMarketplaceProvider(marketplace);
    if (provider == null) {
      throw NFTException('No marketplace provider registered: $marketplace');
    }

    return await provider.getActiveListings(
      collectionId: collectionId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      currency: currency,
    );
  }
}
