import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/icp_config.dart';
import 'icp_client.dart';

/// Yuku Marketplace Provider
/// Provides integration with Yuku NFT Marketplace on Internet Computer
class YukuMarketplaceProvider {
  final ICPClient _icpClient;
  final http.Client _httpClient = http.Client();

  bool _isInitialized = false;
  String? _error;

  // Cache
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  YukuMarketplaceProvider({ICPClient? icpClient})
      : _icpClient = icpClient ?? ICPClient();

  // Getters
  bool get isInitialized => _isInitialized;
  String? get error => _error;

  /// Initialize Yuku marketplace provider
  Future<bool> initialize() async {
    try {
      if (_isInitialized) {
        _logDebug('Yuku Marketplace Provider already initialized');
        return true;
      }

      _logDebug('Initializing Yuku Marketplace Provider...');

      // Ensure ICP client is initialized
      if (!_icpClient.isInitialized) {
        await _icpClient.initialize();
      }

      // Test Yuku API connection
      final isReachable = await _testYukuAPI();

      if (!isReachable) {
        _setError('Unable to connect to Yuku Marketplace API');
        return false;
      }

      _isInitialized = true;
      _error = null;

      _logDebug('Yuku Marketplace Provider initialized successfully');
      return true;
    } catch (e) {
      _setError('Failed to initialize Yuku Marketplace Provider: $e');
      return false;
    }
  }

  /// Test Yuku API connection
  Future<bool> _testYukuAPI() async {
    try {
      final url = Uri.parse('${ICPConfig.yukuApiUrl}/health');

      final response = await _httpClient
          .get(url, headers: ICPConfig.headers)
          .timeout(ICPConfig.connectionTimeout);

      return response.statusCode == 200;
    } catch (e) {
      _logDebug('Yuku API test failed: $e');
      // If health endpoint doesn't exist, try listings endpoint
      return await _testListingsEndpoint();
    }
  }

  Future<bool> _testListingsEndpoint() async {
    try {
      final url = Uri.parse('${ICPConfig.yukuApiUrl}/listings?limit=1');

      final response = await _httpClient
          .get(url, headers: ICPConfig.headers)
          .timeout(ICPConfig.connectionTimeout);

      return response.statusCode == 200 || response.statusCode == 404;
    } catch (e) {
      return false;
    }
  }

  /// Get all active listings
  Future<List<Map<String, dynamic>>> getListings({
    int? limit,
    int? offset,
    String? collection,
    String? sortBy,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Build query parameters
      final queryParams = <String, String>{
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (collection != null) 'collection': collection,
        if (sortBy != null) 'sort_by': sortBy,
        'status': 'active',
      };

      final url = Uri.parse('${ICPConfig.yukuApiUrl}/listings')
          .replace(queryParameters: queryParams);

      final response = await _httpClient
          .get(url, headers: ICPConfig.headers)
          .timeout(ICPConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey('listings')) {
          return List<Map<String, dynamic>>.from(data['listings']);
        } else if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }

        return [];
      } else {
        _setError('Failed to get listings: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _setError('Error getting listings: $e');
      return [];
    }
  }

  /// Get listing by ID
  Future<Map<String, dynamic>?> getListingById(String listingId) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final url = Uri.parse('${ICPConfig.yukuApiUrl}/listings/$listingId');

      final response = await _httpClient
          .get(url, headers: ICPConfig.headers)
          .timeout(ICPConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        _setError('Failed to get listing: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _setError('Error getting listing: $e');
      return null;
    }
  }

  /// Get user's listings
  Future<List<Map<String, dynamic>>> getUserListings(
      String userPrincipal) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final url =
          Uri.parse('${ICPConfig.yukuApiUrl}/listings/user/$userPrincipal');

      final response = await _httpClient
          .get(url, headers: ICPConfig.headers)
          .timeout(ICPConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey('listings')) {
          return List<Map<String, dynamic>>.from(data['listings']);
        } else if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }

        return [];
      } else {
        _setError('Failed to get user listings: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _setError('Error getting user listings: $e');
      return [];
    }
  }

  /// Create a new listing
  Future<String?> createListing({
    required String nftId,
    required double price,
    required String currency,
    int? expirationDays,
  }) async {
    try {
      if (!_icpClient.isConnected) {
        _setError('Wallet not connected');
        return null;
      }

      _logDebug('Creating listing: NFT=$nftId, Price=$price $currency');

      // Use IC P call to create listing on-chain
      final result = await _icpClient.call(
        canisterId: ICPConfig.yukuMarketplaceCanisterId,
        method: 'createListing',
        args: {
          'nftId': nftId,
          'price': (price * 100000000).toInt(), // Convert to e8s
          'currency': currency,
          'expirationTime': expirationDays != null
              ? DateTime.now()
                  .add(Duration(days: expirationDays))
                  .millisecondsSinceEpoch
              : null,
        },
      );

      if (result != null && result.containsKey('Ok')) {
        final listingId = result['Ok']['listingId'] as String;
        _logDebug('Listing created: $listingId');
        return listingId;
      } else {
        _setError(
            'Failed to create listing: ${result?['Err'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      _setError('Error creating listing: $e');
      return null;
    }
  }

  /// Cancel a listing
  Future<bool> cancelListing(String listingId) async {
    try {
      if (!_icpClient.isConnected) {
        _setError('Wallet not connected');
        return false;
      }

      _logDebug('Cancelling listing: $listingId');

      final result = await _icpClient.call(
        canisterId: ICPConfig.yukuMarketplaceCanisterId,
        method: 'cancelListing',
        args: {
          'listingId': listingId,
        },
      );

      if (result != null && result.containsKey('Ok')) {
        _logDebug('Listing cancelled: $listingId');
        return true;
      } else {
        _setError(
            'Failed to cancel listing: ${result?['Err'] ?? 'Unknown error'}');
        return false;
      }
    } catch (e) {
      _setError('Error cancelling listing: $e');
      return false;
    }
  }

  /// Buy an NFT
  Future<bool> buyNFT(String listingId, double price) async {
    try {
      if (!_icpClient.isConnected) {
        _setError('Wallet not connected');
        return false;
      }

      _logDebug('Buying NFT: Listing=$listingId, Price=$price');

      final result = await _icpClient.call(
        canisterId: ICPConfig.yukuMarketplaceCanisterId,
        method: 'buyNFT',
        args: {
          'listingId': listingId,
          'price': (price * 100000000).toInt(), // Convert to e8s
        },
      );

      if (result != null && result.containsKey('Ok')) {
        _logDebug('NFT purchased successfully');
        return true;
      } else {
        _setError('Failed to buy NFT: ${result?['Err'] ?? 'Unknown error'}');
        return false;
      }
    } catch (e) {
      _setError('Error buying NFT: $e');
      return false;
    }
  }

  /// Make an offer
  Future<String?> makeOffer({
    required String nftId,
    required double amount,
    required String currency,
    int? expirationDays,
  }) async {
    try {
      if (!_icpClient.isConnected) {
        _setError('Wallet not connected');
        return null;
      }

      _logDebug('Making offer: NFT=$nftId, Amount=$amount $currency');

      final result = await _icpClient.call(
        canisterId: ICPConfig.yukuMarketplaceCanisterId,
        method: 'makeOffer',
        args: {
          'nftId': nftId,
          'amount': (amount * 100000000).toInt(), // Convert to e8s
          'currency': currency,
          'expirationTime': expirationDays != null
              ? DateTime.now()
                  .add(Duration(days: expirationDays))
                  .millisecondsSinceEpoch
              : null,
        },
      );

      if (result != null && result.containsKey('Ok')) {
        final offerId = result['Ok']['offerId'] as String;
        _logDebug('Offer created: $offerId');
        return offerId;
      } else {
        _setError('Failed to make offer: ${result?['Err'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      _setError('Error making offer: $e');
      return null;
    }
  }

  /// Get offers for NFT
  Future<List<Map<String, dynamic>>> getOffersForNFT(String nftId) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final result = await _icpClient.query(
        canisterId: ICPConfig.yukuMarketplaceCanisterId,
        method: 'getOffersForNFT',
        args: {
          'nftId': nftId,
        },
      );

      if (result != null && result.containsKey('Ok')) {
        return List<Map<String, dynamic>>.from(result['Ok']);
      }

      return [];
    } catch (e) {
      _setError('Error getting offers: $e');
      return [];
    }
  }

  /// Accept an offer
  Future<bool> acceptOffer(String offerId) async {
    try {
      if (!_icpClient.isConnected) {
        _setError('Wallet not connected');
        return false;
      }

      final result = await _icpClient.call(
        canisterId: ICPConfig.yukuMarketplaceCanisterId,
        method: 'acceptOffer',
        args: {
          'offerId': offerId,
        },
      );

      return result != null && result.containsKey('Ok');
    } catch (e) {
      _setError('Error accepting offer: $e');
      return false;
    }
  }

  /// Reject an offer
  Future<bool> rejectOffer(String offerId) async {
    try {
      if (!_icpClient.isConnected) {
        _setError('Wallet not connected');
        return false;
      }

      final result = await _icpClient.call(
        canisterId: ICPConfig.yukuMarketplaceCanisterId,
        method: 'rejectOffer',
        args: {
          'offerId': offerId,
        },
      );

      return result != null && result.containsKey('Ok');
    } catch (e) {
      _setError('Error rejecting offer: $e');
      return false;
    }
  }

  /// Search listings
  Future<List<Map<String, dynamic>>> searchListings({
    String? query,
    double? minPrice,
    double? maxPrice,
    String? collection,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final queryParams = <String, String>{
        if (query != null && query.isNotEmpty) 'q': query,
        if (minPrice != null) 'min_price': minPrice.toString(),
        if (maxPrice != null) 'max_price': maxPrice.toString(),
        if (collection != null) 'collection': collection,
      };

      final url = Uri.parse('${ICPConfig.yukuApiUrl}/listings/search')
          .replace(queryParameters: queryParams);

      final response = await _httpClient
          .get(url, headers: ICPConfig.headers)
          .timeout(ICPConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey('results')) {
          return List<Map<String, dynamic>>.from(data['results']);
        } else if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }

        return [];
      }

      return [];
    } catch (e) {
      _setError('Error searching listings: $e');
      return [];
    }
  }

  /// Get marketplace statistics
  Future<Map<String, dynamic>> getMarketplaceStats() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final url = Uri.parse('${ICPConfig.yukuApiUrl}/stats');

      final response = await _httpClient
          .get(url, headers: ICPConfig.headers)
          .timeout(ICPConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      _logDebug('Error getting marketplace stats: $e');
      return {};
    }
  }

  /// Error handling
  void _setError(String error) {
    _error = error;
    _logDebug('Error: $error');
  }

  void clearError() {
    _error = null;
  }

  /// Logging
  void _logDebug(String message) {
    if (ICPConfig.enableDebugLogging && kDebugMode) {
      print('[Yuku Marketplace] $message');
    }
  }

  /// Cleanup
  void dispose() {
    _httpClient.close();
    _cache.clear();
    _cacheTimestamps.clear();
  }
}
