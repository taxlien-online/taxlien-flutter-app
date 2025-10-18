import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
import 'nft_service.dart';
import '../core/providers/icp_client.dart';
import '../core/providers/yuku_marketplace_provider.dart';

class YukuListing {
  final String id;
  final String nftId;
  final double price;
  final String currency; // 'ICP', 'WICP', 'USD'
  final String sellerAddress;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status; // 'active', 'sold', 'cancelled'
  final String? buyerAddress;
  final DateTime? soldAt;

  YukuListing({
    required this.id,
    required this.nftId,
    required this.price,
    required this.currency,
    required this.sellerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    this.buyerAddress,
    this.soldAt,
  });

  factory YukuListing.fromJson(Map<String, dynamic> json) {
    return YukuListing(
      id: json['id'],
      nftId: json['nftId'],
      price: json['price'].toDouble(),
      currency: json['currency'],
      sellerAddress: json['sellerAddress'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt:
          json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      status: json['status'],
      buyerAddress: json['buyerAddress'],
      soldAt: json['soldAt'] != null ? DateTime.parse(json['soldAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nftId': nftId,
      'price': price,
      'currency': currency,
      'sellerAddress': sellerAddress,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'status': status,
      'buyerAddress': buyerAddress,
      'soldAt': soldAt?.toIso8601String(),
    };
  }
}

class YukuOffer {
  final String id;
  final String nftId;
  final double amount;
  final String currency;
  final String buyerAddress;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status; // 'pending', 'accepted', 'rejected', 'expired'

  YukuOffer({
    required this.id,
    required this.nftId,
    required this.amount,
    required this.currency,
    required this.buyerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
  });

  factory YukuOffer.fromJson(Map<String, dynamic> json) {
    return YukuOffer(
      id: json['id'],
      nftId: json['nftId'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      buyerAddress: json['buyerAddress'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt:
          json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nftId': nftId,
      'amount': amount,
      'currency': currency,
      'buyerAddress': buyerAddress,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'status': status,
    };
  }
}

class YukuService extends ChangeNotifier {
  static const String _yukuApiUrl = 'https://yuku.app/api';
  static const String _yukuMarketplaceUrl = 'https://yuku.app/marketplace';

  List<YukuListing> _activeListings = [];
  List<YukuListing> _myListings = [];
  List<YukuOffer> _myOffers = [];
  List<YukuOffer> _receivedOffers = [];
  bool _isLoading = false;
  String? _error;

  // Flutter ICP client and Yuku provider
  late ICPClient _icpClient;
  late YukuMarketplaceProvider _yukuProvider;
  bool _isInitialized = false;

  // Current user principal ID
  String? _currentUserPrincipal;

  List<YukuListing> get activeListings => _activeListings;
  List<YukuListing> get myListings => _myListings;
  List<YukuOffer> get myOffers => _myOffers;
  List<YukuOffer> get receivedOffers => _receivedOffers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  /// Initialize Yuku Service with real ICP and Marketplace providers
  Future<void> initialize() async {
    try {
      if (_isInitialized) {
        if (kDebugMode) {
          print('Yuku Service already initialized');
        }
        return;
      }

      if (kDebugMode) {
        print('Initializing Yuku Service with real providers...');
      }

      // Initialize ICP Client
      _icpClient = ICPClient();
      await _icpClient.initialize();

      // Initialize Yuku Marketplace Provider
      _yukuProvider = YukuMarketplaceProvider(icpClient: _icpClient);
      await _yukuProvider.initialize();

      _isInitialized = true;
      _error = null;

      if (kDebugMode) {
        print('Yuku Service initialized successfully');
      }

      // Load marketplace data
      await loadActiveListings();
    } catch (e) {
      _error = 'Failed to initialize Yuku service: $e';
      if (kDebugMode) {
        print('Yuku Service initialization error: $e');
      }
    }
  }

  /// Set current user principal (after wallet connection)
  void setCurrentUser(String principalId) {
    _currentUserPrincipal = principalId;
    if (kDebugMode) {
      print('Current user set: $principalId');
    }
  }

  /// Load active listings from Yuku Marketplace
  Future<void> loadActiveListings() async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (kDebugMode) {
        print('Loading active listings from Yuku Marketplace...');
      }

      // Get listings from Yuku provider
      final listings = await _yukuProvider.getListings(limit: 100);

      if (listings.isNotEmpty) {
        _activeListings = listings
            .map((listing) => YukuListing.fromJson(listing))
            .where((listing) => listing.status == 'active')
            .toList();
        _error = null;

        if (kDebugMode) {
          print('Loaded ${_activeListings.length} active listings');
        }
      } else {
        _activeListings = [];
        if (kDebugMode) {
          print('No active listings found');
        }
      }
    } catch (e) {
      _error = 'Failed to load active listings: $e';
      if (kDebugMode) {
        print('Error loading active listings: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Load user's listings from Yuku Marketplace
  Future<void> loadMyListings() async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_currentUserPrincipal == null) {
        if (kDebugMode) {
          print('No user principal set, cannot load user listings');
        }
        _myListings = [];
        return;
      }

      if (kDebugMode) {
        print('Loading user listings for: $_currentUserPrincipal');
      }

      // Get user's listings from Yuku provider
      final listings =
          await _yukuProvider.getUserListings(_currentUserPrincipal!);

      _myListings =
          listings.map((listing) => YukuListing.fromJson(listing)).toList();
      _error = null;

      if (kDebugMode) {
        print('Loaded ${_myListings.length} user listings');
      }
    } catch (e) {
      _error = 'Failed to load my listings: $e';
      if (kDebugMode) {
        print('Error loading user listings: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Load user's offers
  Future<void> loadMyOffers() async {
    _setLoading(true);
    try {
      // TODO: Implement offers loading from blockchain
      // For now, keep empty until offers API is available
      _myOffers = [];
      _error = null;
    } catch (e) {
      _error = 'Failed to load my offers: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Load received offers
  Future<void> loadReceivedOffers() async {
    _setLoading(true);
    try {
      // TODO: Implement received offers loading from blockchain
      // For now, keep empty until offers API is available
      _receivedOffers = [];
      _error = null;
    } catch (e) {
      _error = 'Failed to load received offers: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new listing on Yuku Marketplace
  Future<bool> createListing({
    required String nftId,
    required double price,
    required String currency,
    int? expirationDays,
  }) async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_icpClient.isConnected) {
        _error = 'Wallet not connected. Please connect your wallet first.';
        return false;
      }

      if (kDebugMode) {
        print('Creating listing: NFT=$nftId, Price=$price $currency');
      }

      // Create listing via Yuku provider
      final listingId = await _yukuProvider.createListing(
        nftId: nftId,
        price: price,
        currency: currency,
        expirationDays: expirationDays,
      );

      if (listingId != null) {
        // Reload listings to get the new one
        await loadMyListings();
        await loadActiveListings();

        _error = null;
        notifyListeners();

        if (kDebugMode) {
          print('Listing created successfully: $listingId');
        }

        return true;
      } else {
        _error = _yukuProvider.error ?? 'Failed to create listing';
        return false;
      }
    } catch (e) {
      _error = 'Failed to create listing: $e';
      if (kDebugMode) {
        print('Error creating listing: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cancel a listing on Yuku Marketplace
  Future<bool> cancelListing(String listingId) async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_icpClient.isConnected) {
        _error = 'Wallet not connected';
        return false;
      }

      if (kDebugMode) {
        print('Cancelling listing: $listingId');
      }

      // Cancel listing via Yuku provider
      final success = await _yukuProvider.cancelListing(listingId);

      if (success) {
        // Reload listings
        await loadMyListings();
        await loadActiveListings();

        _error = null;
        notifyListeners();

        if (kDebugMode) {
          print('Listing cancelled successfully');
        }

        return true;
      } else {
        _error = _yukuProvider.error ?? 'Failed to cancel listing';
        return false;
      }
    } catch (e) {
      _error = 'Failed to cancel listing: $e';
      if (kDebugMode) {
        print('Error cancelling listing: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Buy an NFT from Yuku Marketplace
  Future<bool> buyNFT(String listingId) async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_icpClient.isConnected) {
        _error = 'Wallet not connected';
        return false;
      }

      // Find the listing to get price
      final listing = _activeListings.firstWhere(
        (l) => l.id == listingId,
        orElse: () => throw Exception('Listing not found'),
      );

      if (kDebugMode) {
        print('Buying NFT: Listing=$listingId, Price=${listing.price}');
      }

      // Buy NFT via Yuku provider
      final success = await _yukuProvider.buyNFT(listingId, listing.price);

      if (success) {
        // Reload listings
        await loadActiveListings();

        _error = null;
        notifyListeners();

        if (kDebugMode) {
          print('NFT purchased successfully');
        }

        return true;
      } else {
        _error = _yukuProvider.error ?? 'Failed to buy NFT';
        return false;
      }
    } catch (e) {
      _error = 'Failed to buy NFT: $e';
      if (kDebugMode) {
        print('Error buying NFT: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Make an offer on an NFT
  Future<bool> makeOffer({
    required String nftId,
    required double amount,
    required String currency,
    int? expirationDays,
  }) async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_icpClient.isConnected) {
        _error = 'Wallet not connected';
        return false;
      }

      if (kDebugMode) {
        print('Making offer: NFT=$nftId, Amount=$amount $currency');
      }

      // Make offer via Yuku provider
      final offerId = await _yukuProvider.makeOffer(
        nftId: nftId,
        amount: amount,
        currency: currency,
        expirationDays: expirationDays,
      );

      if (offerId != null) {
        // Reload offers
        await loadMyOffers();

        _error = null;
        notifyListeners();

        if (kDebugMode) {
          print('Offer created successfully: $offerId');
        }

        return true;
      } else {
        _error = _yukuProvider.error ?? 'Failed to make offer';
        return false;
      }
    } catch (e) {
      _error = 'Failed to make offer: $e';
      if (kDebugMode) {
        print('Error making offer: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Accept an offer
  Future<bool> acceptOffer(String offerId) async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_icpClient.isConnected) {
        _error = 'Wallet not connected';
        return false;
      }

      final success = await _yukuProvider.acceptOffer(offerId);

      if (success) {
        await loadReceivedOffers();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = _yukuProvider.error ?? 'Failed to accept offer';
        return false;
      }
    } catch (e) {
      _error = 'Failed to accept offer: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Reject an offer
  Future<bool> rejectOffer(String offerId) async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_icpClient.isConnected) {
        _error = 'Wallet not connected';
        return false;
      }

      final success = await _yukuProvider.rejectOffer(offerId);

      if (success) {
        await loadReceivedOffers();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = _yukuProvider.error ?? 'Failed to reject offer';
        return false;
      }
    } catch (e) {
      _error = 'Failed to reject offer: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cancel an offer
  Future<bool> cancelOffer(String offerId) async {
    _setLoading(true);
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_icpClient.isConnected) {
        _error = 'Wallet not connected';
        return false;
      }

      // Note: Cancel offer method needs to be implemented in YukuMarketplaceProvider
      // For now, treat it similar to reject
      final success = await _yukuProvider.rejectOffer(offerId);

      if (success) {
        await loadMyOffers();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = _yukuProvider.error ?? 'Failed to cancel offer';
        return false;
      }
    } catch (e) {
      _error = 'Failed to cancel offer: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Search listings
  Future<List<YukuListing>> searchListings({
    String? query,
    double? minPrice,
    double? maxPrice,
    String? collection,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (kDebugMode) {
        print(
            'Searching listings: query=$query, minPrice=$minPrice, maxPrice=$maxPrice');
      }

      // Search via Yuku provider
      final results = await _yukuProvider.searchListings(
        query: query,
        minPrice: minPrice,
        maxPrice: maxPrice,
        collection: collection,
      );

      return results.map((listing) => YukuListing.fromJson(listing)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Search error: $e');
      }
      throw Exception('Search error: $e');
    }
  }

  String getYukuMarketplaceUrl() {
    return _yukuMarketplaceUrl;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
