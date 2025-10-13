import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/models.dart';
import 'services/services.dart';
import 'exceptions/icp_exception.dart';
import 'constants/constants.dart';

/// Main ICP Client for Internet Computer Protocol
class ICPClient extends ChangeNotifier {
  static ICPClient? _instance;

  late final String _networkUrl;
  late final http.Client _httpClient;
  bool _isInitialized = false;
  bool _isTestnet = false;

  // Services
  late final ICPLedgerService _ledgerService;
  late final ICPIdentityService _identityService;
  late final ICPCanisterService _canisterService;

  ICPClient._internal();

  /// Get singleton instance
  factory ICPClient() {
    _instance ??= ICPClient._internal();
    return _instance!;
  }

  /// Initialize the ICP client
  Future<void> initialize({
    String? networkUrl,
    String? testnetUrl,
    bool isTestnet = false,
    http.Client? httpClient,
  }) async {
    try {
      _isTestnet = isTestnet;
      _networkUrl = isTestnet
          ? (testnetUrl ?? ICPConstants.testnetUrl)
          : (networkUrl ?? ICPConstants.mainnetUrl);
      _httpClient = httpClient ?? http.Client();

      // Initialize services
      _ledgerService = ICPLedgerService(this);
      _identityService = ICPIdentityService(this);
      _canisterService = ICPCanisterService(this);

      _isInitialized = true;
      notifyListeners();

      if (kDebugMode) {
        print('ICPClient initialized on ${_isTestnet ? "testnet" : "mainnet"}');
      }
    } catch (e) {
      throw ICPException('Failed to initialize ICPClient: $e');
    }
  }

  /// Make HTTP request to ICP network
  Future<dynamic> request(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    if (!_isInitialized) {
      throw ICPException('ICPClient not initialized');
    }

    final uri = Uri.parse('$_networkUrl$endpoint');
    final requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };

    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _httpClient.get(uri, headers: requestHeaders);
          break;
        case 'POST':
          response = await _httpClient.post(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        default:
          throw ICPException('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } catch (e) {
      if (e is ICPException) rethrow;
      throw ICPException('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;

      try {
        return json.decode(response.body);
      } catch (e) {
        return response.body;
      }
    } else {
      String message = 'HTTP ${response.statusCode}';

      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map && errorBody.containsKey('message')) {
          message = errorBody['message'];
        }
      } catch (_) {
        message = response.body.isNotEmpty ? response.body : message;
      }

      throw ICPException(message, response.statusCode);
    }
  }

  // Getters
  bool get isInitialized => _isInitialized;
  String get currentNetworkUrl => _networkUrl;
  bool get isTestnet => _isTestnet;
  http.Client get httpClient => _httpClient;

  // Service getters
  ICPLedgerService get ledger => _ledgerService;
  ICPIdentityService get identity => _identityService;
  ICPCanisterService get canisters => _canisterService;

  /// Switch network
  Future<void> switchNetwork({required bool toTestnet}) async {
    _isTestnet = toTestnet;
    _networkUrl = toTestnet ? ICPConstants.testnetUrl : ICPConstants.mainnetUrl;
    notifyListeners();

    if (kDebugMode) {
      print('Switched to ${toTestnet ? "testnet" : "mainnet"}');
    }
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}
