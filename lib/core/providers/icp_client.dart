import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/icp_config.dart';

/// Internet Computer Protocol (ICP) Client
/// Provides integration with Internet Computer blockchain
class ICPClient {
  static ICPClient? _instance;

  // Connection state
  bool _isConnected = false;
  bool _isInitialized = false;
  String? _principalId;
  String? _error;

  // HTTP client
  final http.Client _httpClient = http.Client();

  // Cache for query results
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  // Singleton pattern
  ICPClient._internal();

  factory ICPClient() {
    _instance ??= ICPClient._internal();
    return _instance!;
  }

  // Getters
  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;
  String? get principalId => _principalId;
  String? get error => _error;

  /// Initialize ICP client
  Future<bool> initialize({String? customHost}) async {
    try {
      if (_isInitialized) {
        if (kDebugMode) {
          print('ICP Client already initialized');
        }
        return true;
      }

      _logDebug('Initializing ICP Client...');

      // Test connection to IC network
      final isReachable = await _testConnection(customHost);

      if (!isReachable) {
        _setError('Unable to connect to Internet Computer network');
        return false;
      }

      _isInitialized = true;
      _isConnected = true;
      _error = null;

      _logDebug('ICP Client initialized successfully');
      return true;
    } catch (e) {
      _setError('Failed to initialize ICP Client: $e');
      return false;
    }
  }

  /// Test connection to IC network
  Future<bool> _testConnection(String? customHost) async {
    try {
      final host = customHost ?? ICPConfig.host;
      final url = Uri.parse('$host/api/v2/status');

      final response =
          await _httpClient.get(url).timeout(ICPConfig.connectionTimeout);

      return response.statusCode == 200;
    } catch (e) {
      _logDebug('Connection test failed: $e');
      return false;
    }
  }

  /// Connect wallet with principal ID
  Future<bool> connectWallet(String principalId) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Validate principal ID format
      if (!_isValidPrincipalId(principalId)) {
        _setError('Invalid principal ID format');
        return false;
      }

      _principalId = principalId;
      _isConnected = true;
      _error = null;

      _logDebug('Wallet connected: $principalId');
      return true;
    } catch (e) {
      _setError('Failed to connect wallet: $e');
      return false;
    }
  }

  /// Disconnect wallet
  Future<void> disconnectWallet() async {
    _principalId = null;
    _isConnected = false;
    _clearCache();
    _logDebug('Wallet disconnected');
  }

  /// Query canister (read-only operation)
  Future<Map<String, dynamic>?> query({
    required String canisterId,
    required String method,
    Map<String, dynamic>? args,
    bool useCache = true,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Check cache first
      if (useCache && ICPConfig.enableCaching) {
        final cached = _getFromCache(canisterId, method, args);
        if (cached != null) {
          _logDebug('Cache hit for $method');
          return cached;
        }
      }

      _logDebug('Querying canister: $canisterId, method: $method');

      final url =
          Uri.parse('${ICPConfig.host}/api/v2/canister/$canisterId/query');

      final requestBody = {
        'method_name': method,
        'arg': args != null ? base64Encode(utf8.encode(jsonEncode(args))) : '',
        'sender': _principalId ?? 'anonymous',
      };

      final response = await _httpClient
          .post(
            url,
            headers: ICPConfig.headers,
            body: jsonEncode(requestBody),
          )
          .timeout(ICPConfig.requestTimeout);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;

        // Cache the result
        if (useCache && ICPConfig.enableCaching) {
          _addToCache(canisterId, method, args, result);
        }

        return result;
      } else {
        _setError('Query failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      _setError('Query error: $e');
      return null;
    }
  }

  /// Call canister (write operation, requires authentication)
  Future<Map<String, dynamic>?> call({
    required String canisterId,
    required String method,
    Map<String, dynamic>? args,
  }) async {
    try {
      if (!_isConnected || _principalId == null) {
        _setError('Wallet not connected. Please connect wallet first.');
        return null;
      }

      _logDebug('Calling canister: $canisterId, method: $method');

      final url =
          Uri.parse('${ICPConfig.host}/api/v2/canister/$canisterId/call');

      final requestBody = {
        'method_name': method,
        'arg': args != null ? base64Encode(utf8.encode(jsonEncode(args))) : '',
        'sender': _principalId!,
        'ingress_expiry': DateTime.now()
                .add(const Duration(minutes: 5))
                .millisecondsSinceEpoch *
            1000000, // Nanoseconds
      };

      final response = await _httpClient
          .post(
            url,
            headers: ICPConfig.headers,
            body: jsonEncode(requestBody),
          )
          .timeout(ICPConfig.requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 202) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;

        // Clear related cache entries
        _clearCacheForCanister(canisterId);

        return result;
      } else {
        _setError('Call failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      _setError('Call error: $e');
      return null;
    }
  }

  /// Get account balance
  Future<double> getBalance() async {
    try {
      if (_principalId == null) {
        return 0.0;
      }

      final result = await query(
        canisterId: 'ryjl3-tyaaa-aaaaa-aaaba-cai', // Ledger canister
        method: 'account_balance',
        args: {
          'account': _principalId,
        },
      );

      if (result != null && result.containsKey('e8s')) {
        // Convert e8s (10^-8 ICP) to ICP
        return (result['e8s'] as int) / 100000000;
      }

      return 0.0;
    } catch (e) {
      _logDebug('Error getting balance: $e');
      return 0.0;
    }
  }

  /// Transfer ICP
  Future<bool> transfer({
    required String toAddress,
    required double amount,
    String? memo,
  }) async {
    try {
      if (_principalId == null) {
        _setError('Wallet not connected');
        return false;
      }

      // Convert ICP to e8s
      final e8s = (amount * 100000000).toInt();

      final result = await call(
        canisterId: 'ryjl3-tyaaa-aaaaa-aaaba-cai', // Ledger canister
        method: 'transfer',
        args: {
          'to': toAddress,
          'amount': {'e8s': e8s},
          'memo': memo != null ? int.parse(memo) : 0,
          'fee': {'e8s': 10000}, // 0.0001 ICP fee
          'from_subaccount': null,
          'created_at_time': {
            'timestamp_nanos': DateTime.now().millisecondsSinceEpoch * 1000000,
          },
        },
      );

      return result != null && result.containsKey('Ok');
    } catch (e) {
      _setError('Transfer failed: $e');
      return false;
    }
  }

  /// Retry logic for failed requests
  Future<T?> _retryRequest<T>(
    Future<T?> Function() request, {
    int maxAttempts = ICPConfig.maxRetries,
  }) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        final result = await request();
        if (result != null) {
          return result;
        }
      } catch (e) {
        _logDebug('Request failed (attempt ${attempts + 1}): $e');
      }

      attempts++;

      if (attempts < maxAttempts) {
        await Future.delayed(ICPConfig.retryDelay);
      }
    }

    return null;
  }

  /// Cache management
  String _getCacheKey(
      String canisterId, String method, Map<String, dynamic>? args) {
    final argsString = args != null ? jsonEncode(args) : '';
    return '$canisterId:$method:$argsString';
  }

  Map<String, dynamic>? _getFromCache(
    String canisterId,
    String method,
    Map<String, dynamic>? args,
  ) {
    final key = _getCacheKey(canisterId, method, args);

    if (_cache.containsKey(key) && _cacheTimestamps.containsKey(key)) {
      final timestamp = _cacheTimestamps[key]!;
      final age = DateTime.now().difference(timestamp);

      if (age < ICPConfig.cacheDuration) {
        return _cache[key] as Map<String, dynamic>?;
      } else {
        // Cache expired
        _cache.remove(key);
        _cacheTimestamps.remove(key);
      }
    }

    return null;
  }

  void _addToCache(
    String canisterId,
    String method,
    Map<String, dynamic>? args,
    Map<String, dynamic> result,
  ) {
    final key = _getCacheKey(canisterId, method, args);

    _cache[key] = result;
    _cacheTimestamps[key] = DateTime.now();

    // Limit cache size
    if (_cache.length > ICPConfig.maxCacheSize) {
      final oldestKey = _cacheTimestamps.entries
          .reduce((a, b) => a.value.isBefore(b.value) ? a : b)
          .key;

      _cache.remove(oldestKey);
      _cacheTimestamps.remove(oldestKey);
    }
  }

  void _clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  void _clearCacheForCanister(String canisterId) {
    final keysToRemove =
        _cache.keys.where((key) => key.startsWith('$canisterId:')).toList();

    for (final key in keysToRemove) {
      _cache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  /// Validation
  bool _isValidPrincipalId(String principalId) {
    // Basic validation - principal ID should be base32 encoded
    // More sophisticated validation can be added
    return principalId.isNotEmpty && principalId.length >= 27;
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
      print('[ICP Client] $message');
    }
  }

  /// Cleanup
  void dispose() {
    _httpClient.close();
    _clearCache();
    _isConnected = false;
    _isInitialized = false;
    _principalId = null;
  }
}
