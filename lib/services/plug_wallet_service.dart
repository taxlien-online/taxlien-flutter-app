import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PlugWalletService extends ChangeNotifier {
  static const String _plugWalletUrl = 'https://plugwallet.ooo';
  static const String _icpNetwork = 'https://ic0.app';
  
  bool _isConnected = false;
  String? _principalId;
  String? _accountId;
  Map<String, dynamic>? _walletInfo;
  bool _isLoading = false;
  String? _error;

  // Mock data for development
  final Map<String, dynamic> _mockWalletInfo = {
    'principal': '2vxsx-fae',
    'accountId': 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6',
    'balance': {
      'ICP': 100.5,
      'WICP': 50.25,
      'USD': 2500.0,
    },
    'transactions': [
      {
        'id': 'tx_001',
        'type': 'send',
        'amount': 10.0,
        'currency': 'ICP',
        'to': 'user456',
        'timestamp': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        'status': 'completed',
      },
      {
        'id': 'tx_002',
        'type': 'receive',
        'amount': 5.5,
        'currency': 'ICP',
        'from': 'user789',
        'timestamp': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'status': 'completed',
      },
    ],
  };

  bool get isConnected => _isConnected;
  String? get principalId => _principalId;
  String? get accountId => _accountId;
  Map<String, dynamic>? get walletInfo => _walletInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _setLoading(true);
    try {
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
      // For now, we'll use mock data
      await Future.delayed(Duration(milliseconds: 300));
      return _isConnected;
    } catch (e) {
      return false;
    }
  }

  Future<bool> connect() async {
    _setLoading(true);
    try {
      // Simulate connection process
      await Future.delayed(Duration(seconds: 2));
      
      // In a real implementation, this would:
      // 1. Open Plug Wallet connection dialog
      // 2. Request user approval
      // 3. Get principal and account information
      
      _principalId = _mockWalletInfo['principal'];
      _accountId = _mockWalletInfo['accountId'];
      _walletInfo = _mockWalletInfo;
      _isConnected = true;
      
      _error = null;
      notifyListeners();
      return true;
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
    return _icpNetwork;
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

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Utility methods
  String formatPrincipal(String principal) {
    if (principal.length <= 10) return principal;
    return '${principal.substring(0, 6)}...${principal.substring(principal.length - 4)}';
  }

  String formatAccountId(String accountId) {
    if (accountId.length <= 12) return accountId;
    return '${accountId.substring(0, 8)}...${accountId.substring(accountId.length - 4)}';
  }

  String formatBalance(double balance, String currency) {
    switch (currency) {
      case 'ICP':
      case 'WICP':
        return '${balance.toStringAsFixed(4)} $currency';
      case 'USD':
        return '\$${balance.toStringAsFixed(2)}';
      default:
        return '${balance.toStringAsFixed(2)} $currency';
    }
  }
}
