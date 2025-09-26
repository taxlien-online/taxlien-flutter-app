import 'package:flutter/foundation.dart';
import '../../services/plug_wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final PlugWalletService _walletService = PlugWalletService.instance;

  bool _isConnected = false;
  String? _walletAddress;
  double _balance = 0.0;
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _transactionHistory = [];

  bool get isConnected => _isConnected;
  String? get walletAddress => _walletAddress;
  double get balance => _balance;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get transactionHistory => _transactionHistory;

  // Initialize wallet
  Future<void> initializeWallet() async {
    _setLoading(true);
    _clearError();

    try {
      _isConnected = await _walletService.isWalletConnected();
      if (_isConnected) {
        _walletAddress = await _walletService.getWalletAddress();
        _balance = await _walletService.getWalletBalance();
        _transactionHistory = await _walletService.getTransactionHistory();
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize wallet: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Connect wallet
  Future<bool> connectWallet() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _walletService.connectWallet();

      if (success) {
        _isConnected = true;
        _walletAddress = await _walletService.getWalletAddress();
        _balance = await _walletService.getWalletBalance();
        _transactionHistory = await _walletService.getTransactionHistory();
        notifyListeners();
        return true;
      } else {
        _setError('Failed to connect wallet');
        return false;
      }
    } catch (e) {
      _setError('Failed to connect wallet: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Disconnect wallet
  Future<bool> disconnectWallet() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _walletService.disconnectWallet();

      if (success) {
        _isConnected = false;
        _walletAddress = null;
        _balance = 0.0;
        _transactionHistory.clear();
        notifyListeners();
        return true;
      } else {
        _setError('Failed to disconnect wallet');
        return false;
      }
    } catch (e) {
      _setError('Failed to disconnect wallet: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh wallet data
  Future<void> refreshWallet() async {
    if (!_isConnected) return;

    _setLoading(true);
    _clearError();

    try {
      _walletAddress = await _walletService.getWalletAddress();
      _balance = await _walletService.getWalletBalance();
      _transactionHistory = await _walletService.getTransactionHistory();
      notifyListeners();
    } catch (e) {
      _setError('Failed to refresh wallet: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Send transaction
  Future<bool> sendTransaction({
    required String toAddress,
    required double amount,
    String? memo,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _walletService.sendTransaction(
        toAddress: toAddress,
        amount: amount,
        memo: memo,
      );

      if (success) {
        // Refresh wallet data after successful transaction
        await refreshWallet();
        return true;
      } else {
        _setError('Failed to send transaction');
        return false;
      }
    } catch (e) {
      _setError('Failed to send transaction: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign message
  Future<String?> signMessage(String message) async {
    _setLoading(true);
    _clearError();

    try {
      final signature = await _walletService.signMessage(message);
      return signature;
    } catch (e) {
      _setError('Failed to sign message: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Verify signature
  Future<bool> verifySignature({
    required String message,
    required String signature,
    required String publicKey,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _walletService.verifySignature(
        message: message,
        signature: signature,
        publicKey: publicKey,
      );

      if (!success) {
        _setError('Signature verification failed');
      }

      return success;
    } catch (e) {
      _setError('Failed to verify signature: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get wallet info
  Future<Map<String, dynamic>> getWalletInfo() async {
    try {
      return await _walletService.getWalletInfo();
    } catch (e) {
      _setError('Failed to get wallet info: $e');
      return {};
    }
  }

  // Check if wallet has sufficient balance
  bool hasSufficientBalance(double amount) {
    return _balance >= amount;
  }

  // Get formatted balance
  String getFormattedBalance() {
    return '${_balance.toStringAsFixed(2)} ICP';
  }

  // Get recent transactions
  List<Map<String, dynamic>> getRecentTransactions({int limit = 5}) {
    final sortedTransactions =
        List<Map<String, dynamic>>.from(_transactionHistory);
    sortedTransactions.sort((a, b) {
      final aTime = DateTime.parse(a['timestamp']);
      final bTime = DateTime.parse(b['timestamp']);
      return bTime.compareTo(aTime);
    });

    return sortedTransactions.take(limit).toList();
  }

  // Get transactions by type
  List<Map<String, dynamic>> getTransactionsByType(String type) {
    return _transactionHistory.where((tx) => tx['type'] == type).toList();
  }

  // Get pending transactions
  List<Map<String, dynamic>> getPendingTransactions() {
    return _transactionHistory
        .where((tx) => tx['status'] == 'pending')
        .toList();
  }

  // Clear error
  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
