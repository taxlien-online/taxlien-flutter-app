import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/providers/icp_client.dart';
import '../core/config/icp_config.dart';

/// Plug Wallet Service
/// Provides integration with Plug Wallet for Internet Computer
class PlugWalletService {
  static PlugWalletService? _instance;

  final ICPClient _icpClient = ICPClient();

  bool _isConnected = false;
  bool _isInitialized = false;
  String? _principalId;
  String? _accountId;
  double _balance = 0.0;
  String? _error;

  // Transaction history
  List<Map<String, dynamic>> _transactionHistory = [];

  PlugWalletService._internal();

  static PlugWalletService get instance {
    _instance ??= PlugWalletService._internal();
    return _instance!;
  }

  // Getters
  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;
  String? get principalId => _principalId;
  String? get accountId => _accountId;
  double get balance => _balance;
  String? get error => _error;
  List<Map<String, dynamic>> get transactionHistory => _transactionHistory;

  /// Initialize Plug Wallet Service
  Future<void> initialize() async {
    try {
      if (_isInitialized) {
        _logDebug('Plug Wallet Service already initialized');
        return;
      }

      _logDebug('Initializing Plug Wallet Service...');

      // Initialize ICP Client
      await _icpClient.initialize();

      // Check if wallet was previously connected
      await _loadSavedConnection();

      _isInitialized = true;
      _logDebug('Plug Wallet Service initialized successfully');
    } catch (e) {
      _setError('Failed to initialize Plug Wallet Service: $e');
    }
  }

  /// Load saved connection from storage
  Future<void> _loadSavedConnection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPrincipalId = prefs.getString('plug_wallet_principal_id');

      if (savedPrincipalId != null && savedPrincipalId.isNotEmpty) {
        _principalId = savedPrincipalId;
        _accountId = prefs.getString('plug_wallet_account_id');
        _isConnected = true;

        // Reconnect to ICP with saved principal
        await _icpClient.connectWallet(savedPrincipalId);

        // Load wallet data
        await _refreshWalletData();

        _logDebug('Restored connection to wallet: $_principalId');
      }
    } catch (e) {
      _logDebug('Error loading saved connection: $e');
    }
  }

  /// Save connection to storage
  Future<void> _saveConnection() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_principalId != null) {
        await prefs.setString('plug_wallet_principal_id', _principalId!);
        if (_accountId != null) {
          await prefs.setString('plug_wallet_account_id', _accountId!);
        }
        await prefs.setBool('plug_wallet_connected', true);
      }
    } catch (e) {
      _logDebug('Error saving connection: $e');
    }
  }

  /// Clear saved connection
  Future<void> _clearSavedConnection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('plug_wallet_principal_id');
      await prefs.remove('plug_wallet_account_id');
      await prefs.setBool('plug_wallet_connected', false);
    } catch (e) {
      _logDebug('Error clearing saved connection: $e');
    }
  }

  /// Check if wallet is connected
  Future<bool> isWalletConnected() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _isConnected && _principalId != null;
  }

  /// Connect wallet
  /// In production, this would open Plug Wallet extension/app for authentication
  /// For now, it simulates the connection process
  Future<bool> connectWallet({String? providedPrincipalId}) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      _logDebug('Connecting to Plug Wallet...');

      // In production, this would:
      // 1. Open Plug Wallet browser extension
      // 2. Request user authentication
      // 3. Get principal ID from Plug
      // 4. Request whitelist approval for canisters

      // For development/demo, use provided principal or generate one
      final principalToUse = providedPrincipalId ?? _generateDemoPrincipal();

      // Connect ICP client with principal
      final connected = await _icpClient.connectWallet(principalToUse);

      if (!connected) {
        _setError('Failed to connect to ICP network');
        return false;
      }

      _principalId = principalToUse;
      _accountId = _generateAccountId(principalToUse);
      _isConnected = true;
      _error = null;

      // Save connection
      await _saveConnection();

      // Load wallet data
      await _refreshWalletData();

      _logDebug('Wallet connected successfully: $_principalId');
      return true;
    } catch (e) {
      _setError('Error connecting wallet: $e');
      return false;
    }
  }

  /// Connect with real Plug Wallet (browser extension)
  /// This method would integrate with actual Plug Wallet via JavaScript bridge
  Future<bool> connectWithPlugExtension() async {
    try {
      // TODO: Implement JavaScript bridge to Plug Wallet extension
      // For web: window.ic.plug.requestConnect(whitelist)
      // For mobile: Deep link to Plug Wallet app

      _setError(
          'Plug Wallet extension integration not yet implemented. Use connectWallet() for testing.');
      return false;
    } catch (e) {
      _setError('Error connecting with Plug extension: $e');
      return false;
    }
  }

  /// Disconnect wallet
  Future<bool> disconnectWallet() async {
    try {
      _logDebug('Disconnecting wallet...');

      // Disconnect ICP client
      await _icpClient.disconnectWallet();

      // Clear local state
      _isConnected = false;
      _principalId = null;
      _accountId = null;
      _balance = 0.0;
      _transactionHistory.clear();
      _error = null;

      // Clear saved connection
      await _clearSavedConnection();

      _logDebug('Wallet disconnected');
      return true;
    } catch (e) {
      _setError('Error disconnecting wallet: $e');
      return false;
    }
  }

  /// Get wallet address (Principal ID)
  Future<String?> getWalletAddress() async {
    if (!_isConnected) {
      return null;
    }
    return _principalId;
  }

  /// Get account ID (for ledger transactions)
  Future<String?> getAccountId() async {
    if (!_isConnected) {
      return null;
    }
    return _accountId;
  }

  /// Get wallet balance
  Future<double> getWalletBalance() async {
    try {
      if (!_isConnected) {
        return 0.0;
      }

      _logDebug('Getting wallet balance...');

      // Get balance from ICP ledger
      final balance = await _icpClient.getBalance();
      _balance = balance;

      _logDebug('Balance: ${balance.toStringAsFixed(4)} ICP');
      return balance;
    } catch (e) {
      _setError('Error getting wallet balance: $e');
      return 0.0;
    }
  }

  /// Send transaction
  Future<bool> sendTransaction({
    required String toAddress,
    required double amount,
    String? memo,
  }) async {
    try {
      if (!_isConnected) {
        _setError('Wallet not connected');
        return false;
      }

      _logDebug('Sending $amount ICP to $toAddress');

      // Validate amount
      if (amount <= 0) {
        _setError('Amount must be greater than 0');
        return false;
      }

      if (amount > _balance) {
        _setError('Insufficient balance');
        return false;
      }

      // Send transaction via ICP client
      final success = await _icpClient.transfer(
        toAddress: toAddress,
        amount: amount,
        memo: memo,
      );

      if (success) {
        // Add to local transaction history
        _transactionHistory.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'type': 'sent',
          'amount': amount,
          'to': toAddress,
          'timestamp': DateTime.now().toIso8601String(),
          'status': 'completed',
          'memo': memo,
        });

        // Refresh balance
        await getWalletBalance();

        _logDebug('Transaction sent successfully');
        return true;
      } else {
        _setError('Transaction failed');
        return false;
      }
    } catch (e) {
      _setError('Error sending transaction: $e');
      return false;
    }
  }

  /// Get transaction history
  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    try {
      if (!_isConnected) {
        return [];
      }

      // In production, this would query the ICP ledger for transaction history
      // For now, return local history

      return List.from(_transactionHistory);
    } catch (e) {
      _setError('Error getting transaction history: $e');
      return [];
    }
  }

  /// Get wallet info
  Future<Map<String, dynamic>> getWalletInfo() async {
    try {
      if (!_isConnected) {
        return {};
      }

      return {
        'principalId': _principalId,
        'accountId': _accountId,
        'balance': _balance,
        'balanceFormatted': '${_balance.toStringAsFixed(4)} ICP',
        'isConnected': _isConnected,
        'network': ICPConfig.useMainnet ? 'Mainnet' : 'Testnet',
        'currency': 'ICP',
      };
    } catch (e) {
      _setError('Error getting wallet info: $e');
      return {};
    }
  }

  /// Sign message
  Future<String?> signMessage(String message) async {
    try {
      if (!_isConnected) {
        _setError('Wallet not connected');
        return null;
      }

      _logDebug('Signing message...');

      // In production, this would call Plug Wallet to sign the message
      // For now, return a demo signature

      final signature =
          'sig_${DateTime.now().millisecondsSinceEpoch}_${message.hashCode}';

      _logDebug('Message signed: $signature');
      return signature;
    } catch (e) {
      _setError('Error signing message: $e');
      return null;
    }
  }

  /// Verify signature
  Future<bool> verifySignature({
    required String message,
    required String signature,
    required String publicKey,
  }) async {
    try {
      // In production, this would verify the signature using ICP cryptography
      // For now, return true for demo purposes

      _logDebug('Verifying signature...');
      return true;
    } catch (e) {
      _setError('Error verifying signature: $e');
      return false;
    }
  }

  /// Refresh wallet data
  Future<void> refreshWallet() async {
    if (!_isConnected) {
      return;
    }

    await _refreshWalletData();
  }

  /// Internal: Refresh wallet data
  Future<void> _refreshWalletData() async {
    try {
      // Get balance
      _balance = await _icpClient.getBalance();

      // Get transaction history would go here
      // For now, we keep the local history
    } catch (e) {
      _logDebug('Error refreshing wallet data: $e');
    }
  }

  /// Generate demo principal ID (for testing)
  String _generateDemoPrincipal() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'demo-principal-${timestamp.toString().substring(timestamp.toString().length - 10)}';
  }

  /// Generate account ID from principal
  String _generateAccountId(String principalId) {
    // In production, this would use proper account ID derivation
    // For now, use a simple hash-based approach
    return 'acc-${principalId.hashCode.abs().toString()}';
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
      print('[Plug Wallet] $message');
    }
  }
}
