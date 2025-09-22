import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icp/flutter_icp.dart';

class PlugWalletService extends ChangeNotifier {
  static const String _plugWalletUrl = 'https://plugwallet.ooo';
  static const String _icpNetwork = 'https://ic0.app';
  static const String _icpTestNetwork = 'https://ic0.testnet.app';

  bool _isConnected = false;
  String? _principalId;
  String? _accountId;
  Map<String, dynamic>? _walletInfo;
  bool _isLoading = false;
  String? _error;
  bool _isTestnet = false;

  // Flutter ICP client
  late ICPClient _icpClient;
  late PlugWalletProvider _plugWalletProvider;
  bool _isInitialized = false;

  // SharedPreferences keys
  static const String _keyIsConnected = 'plug_wallet_connected';
  static const String _keyPrincipalId = 'plug_wallet_principal_id';
  static const String _keyAccountId = 'plug_wallet_account_id';
  static const String _keyIsTestnet = 'plug_wallet_testnet';

  // Mock data for development
  final Map<String, dynamic> _mockWalletInfo = {
    'principal': '2vxsx-fae',
    'accountId': 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6',
    'balance': {
      'ICP': 100.5,
      'WICP': 50.25,
      'USD': 2500.0,
      'BTC': 0.05,
      'ETH': 2.5,
    },
    'transactions': [
      {
        'id': 'tx_001',
        'type': 'send',
        'amount': 10.0,
        'currency': 'ICP',
        'to': 'user456',
        'timestamp':
            DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        'status': 'completed',
        'fee': 0.0001,
        'blockHeight': 12345678,
      },
      {
        'id': 'tx_002',
        'type': 'receive',
        'amount': 5.5,
        'currency': 'ICP',
        'from': 'user789',
        'timestamp':
            DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'status': 'completed',
        'fee': 0.0,
        'blockHeight': 12345670,
      },
    ],
    'nfts': [
      {
        'id': 'nft_001',
        'name': 'Tax Lien Certificate #123',
        'description': 'Certificate for property tax lien',
        'image': 'https://example.com/nft1.jpg',
        'canisterId': 'abc123-def456',
        'tokenId': '123',
        'metadata': {
          'propertyAddress': '123 Main St, City, State',
          'lienAmount': 5000.0,
          'interestRate': 18.0,
          'redemptionPeriod': '2 years',
        },
      },
    ],
  };

  bool get isConnected => _isConnected;
  String? get principalId => _principalId;
  String? get accountId => _accountId;
  Map<String, dynamic>? get walletInfo => _walletInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTestnet => _isTestnet;

  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Initialize Flutter ICP client
      _icpClient = ICPClient();
      _plugWalletProvider = PlugWalletProvider();

      // Register Plug Wallet provider
      _icpClient.registerWalletProvider(_plugWalletProvider);

      // Initialize ICP client
      await _icpClient.initialize();

      _isInitialized = true;

      // Load saved state
      await _loadSavedState();

      // Check if Plug Wallet is available
      final isAvailable = await _checkPlugWalletAvailability();

      if (isAvailable) {
        // Check if already connected
        final connectionStatus = await _checkConnectionStatus();
        if (connectionStatus) {
          await _loadWalletInfo();
        }
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to initialize Plug Wallet: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isConnected = prefs.getBool(_keyIsConnected) ?? false;
      _principalId = prefs.getString(_keyPrincipalId);
      _accountId = prefs.getString(_keyAccountId);
      _isTestnet = prefs.getBool(_keyIsTestnet) ?? false;
    } catch (e) {
      // Ignore errors loading saved state
    }
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsConnected, _isConnected);
      if (_principalId != null) {
        await prefs.setString(_keyPrincipalId, _principalId!);
      }
      if (_accountId != null) {
        await prefs.setString(_keyAccountId, _accountId!);
      }
      await prefs.setBool(_keyIsTestnet, _isTestnet);
    } catch (e) {
      // Ignore errors saving state
    }
  }

  Future<bool> _checkPlugWalletAvailability() async {
    try {
      // In a real implementation, this would check if Plug Wallet extension is installed
      // For now, we'll simulate availability
      await Future.delayed(Duration(milliseconds: 500));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _checkConnectionStatus() async {
    try {
      // In a real implementation, this would check the actual connection status
      // For now, we'll use saved state
      await Future.delayed(Duration(milliseconds: 300));
      return _isConnected;
    } catch (e) {
      return false;
    }
  }

  Future<bool> connect() async {
    if (!_isInitialized) {
      _error = 'Plug Wallet service not initialized';
      return false;
    }

    _setLoading(true);
    try {
      // Use Flutter ICP client to connect
      final result = await _icpClient.connect();

      if (result.success) {
        _principalId = result.principalId;
        _accountId = result.accountId;
        _walletInfo = result.walletInfo;
        _isConnected = true;

        await _saveState();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to connect: ${result.error}';
        return false;
      }
    } catch (e) {
      _error = 'Failed to connect to Plug Wallet: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> disconnect() async {
    _setLoading(true);
    try {
      // Simulate disconnection
      await Future.delayed(Duration(milliseconds: 500));

      _isConnected = false;
      _principalId = null;
      _accountId = null;
      _walletInfo = null;

      await _saveState();
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to disconnect from Plug Wallet: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadWalletInfo() async {
    try {
      // In a real implementation, this would fetch actual wallet data
      // For now, we'll use mock data
      await Future.delayed(Duration(milliseconds: 800));

      _walletInfo = _mockWalletInfo;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load wallet info: $e';
    }
  }

  Future<Map<String, double>> getBalance() async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    try {
      // In a real implementation, this would fetch actual balances
      await Future.delayed(Duration(milliseconds: 500));

      return Map<String, double>.from(_mockWalletInfo['balance']);
    } catch (e) {
      throw Exception('Failed to get balance: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    try {
      // In a real implementation, this would fetch actual transaction history
      await Future.delayed(Duration(milliseconds: 600));

      return List<Map<String, dynamic>>.from(_mockWalletInfo['transactions']);
    } catch (e) {
      throw Exception('Failed to get transaction history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getNFTBalances() async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    try {
      // In a real implementation, this would fetch actual NFT balances
      await Future.delayed(Duration(milliseconds: 700));

      return List<Map<String, dynamic>>.from(_mockWalletInfo['nfts']);
    } catch (e) {
      throw Exception('Failed to get NFT balances: $e');
    }
  }

  Future<bool> sendTransaction({
    required String to,
    required double amount,
    required String currency,
    String? memo,
  }) async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    _setLoading(true);
    try {
      // Simulate transaction process
      await Future.delayed(Duration(seconds: 3));

      // In a real implementation, this would:
      // 1. Create transaction
      // 2. Sign with Plug Wallet
      // 3. Submit to Internet Computer
      // 4. Wait for confirmation

      // Add transaction to history
      final transaction = {
        'id': 'tx_${DateTime.now().millisecondsSinceEpoch}',
        'type': 'send',
        'amount': amount,
        'currency': currency,
        'to': to,
        'memo': memo,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'completed',
        'fee': 0.0001,
        'blockHeight': 12345679,
      };

      _mockWalletInfo['transactions'].insert(0, transaction);

      // Update balance
      final currentBalance = _mockWalletInfo['balance'][currency] ?? 0.0;
      _mockWalletInfo['balance'][currency] = currentBalance - amount;

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to send transaction: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signMessage(String message) async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    _setLoading(true);
    try {
      // Simulate message signing
      await Future.delayed(Duration(seconds: 2));

      // In a real implementation, this would:
      // 1. Request signature from Plug Wallet
      // 2. Return signed message

      _error = null;
      return true;
    } catch (e) {
      _error = 'Failed to sign message: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> approveTransaction({
    required String canisterId,
    required String method,
    required Map<String, dynamic> args,
  }) async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    _setLoading(true);
    try {
      // Simulate transaction approval
      await Future.delayed(Duration(seconds: 2));

      // In a real implementation, this would:
      // 1. Request approval from Plug Wallet
      // 2. Execute the transaction
      // 3. Return result

      _error = null;
      return true;
    } catch (e) {
      _error = 'Failed to approve transaction: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String> getPlugWalletUrl() async {
    return _plugWalletUrl;
  }

  Future<String> getNetworkUrl() async {
    return _isTestnet ? _icpTestNetwork : _icpNetwork;
  }

  Future<void> switchNetwork(bool isTestnet) async {
    _isTestnet = isTestnet;
    await _saveState();
    notifyListeners();
  }

  // Helper methods for Yuku integration
  Future<bool> approveNFTTransaction({
    required String nftCanisterId,
    required String nftId,
    required double price,
    required String currency,
  }) async {
    return await approveTransaction(
      canisterId: nftCanisterId,
      method: 'transfer',
      args: {
        'token_id': nftId,
        'amount': price,
        'currency': currency,
      },
    );
  }

  Future<bool> approveListingTransaction({
    required String marketplaceCanisterId,
    required String nftId,
    required double price,
    required String currency,
  }) async {
    return await approveTransaction(
      canisterId: marketplaceCanisterId,
      method: 'create_listing',
      args: {
        'nft_id': nftId,
        'price': price,
        'currency': currency,
      },
    );
  }

  Future<bool> approveOfferTransaction({
    required String marketplaceCanisterId,
    required String nftId,
    required double amount,
    required String currency,
  }) async {
    return await approveTransaction(
      canisterId: marketplaceCanisterId,
      method: 'make_offer',
      args: {
        'nft_id': nftId,
        'amount': amount,
        'currency': currency,
      },
    );
  }

  // Utility methods for formatting
  String formatPrincipal(String principal) {
    if (principal.length <= 10) return principal;
    return '${principal.substring(0, 5)}...${principal.substring(principal.length - 5)}';
  }

  String formatAccountId(String accountId) {
    if (accountId.length <= 12) return accountId;
    return '${accountId.substring(0, 6)}...${accountId.substring(accountId.length - 6)}';
  }

  String formatBalance(double amount, String currency) {
    switch (currency) {
      case 'ICP':
      case 'WICP':
        return '${amount.toStringAsFixed(4)} $currency';
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'BTC':
        return '${amount.toStringAsFixed(8)} BTC';
      case 'ETH':
        return '${amount.toStringAsFixed(6)} ETH';
      default:
        return '${amount.toStringAsFixed(2)} $currency';
    }
  }

  // New methods for enhanced functionality
  Future<Map<String, dynamic>> getWalletStats() async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    try {
      final balances = await getBalance();
      final transactions = await getTransactionHistory();
      final nfts = await getNFTBalances();

      double totalValue = 0.0;
      balances.forEach((currency, amount) {
        // Mock conversion rates
        switch (currency) {
          case 'ICP':
            totalValue += amount * 12.5; // Mock ICP price
            break;
          case 'WICP':
            totalValue += amount * 12.5; // Mock WICP price
            break;
          case 'USD':
            totalValue += amount;
            break;
          case 'BTC':
            totalValue += amount * 45000; // Mock BTC price
            break;
          case 'ETH':
            totalValue += amount * 2500; // Mock ETH price
            break;
        }
      });

      return {
        'totalValue': totalValue,
        'totalTransactions': transactions.length,
        'totalNFTs': nfts.length,
        'lastTransaction':
            transactions.isNotEmpty ? transactions.first['timestamp'] : null,
        'network': _isTestnet ? 'Testnet' : 'Mainnet',
      };
    } catch (e) {
      throw Exception('Failed to get wallet stats: $e');
    }
  }

  Future<bool> importNFT({
    required String canisterId,
    required String tokenId,
  }) async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    _setLoading(true);
    try {
      // Simulate NFT import
      await Future.delayed(Duration(seconds: 2));

      // In a real implementation, this would:
      // 1. Verify NFT ownership
      // 2. Add to wallet
      // 3. Update local state

      _error = null;
      return true;
    } catch (e) {
      _error = 'Failed to import NFT: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> getTransactionDetails(
      String transactionId) async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    try {
      final transactions = await getTransactionHistory();
      final transaction = transactions.firstWhere(
        (tx) => tx['id'] == transactionId,
        orElse: () => throw Exception('Transaction not found'),
      );

      return transaction;
    } catch (e) {
      throw Exception('Failed to get transaction details: $e');
    }
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
