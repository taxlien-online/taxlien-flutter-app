import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlugWalletService {
  static PlugWalletService? _instance;

  PlugWalletService._internal();

  static PlugWalletService get instance {
    _instance ??= PlugWalletService._internal();
    return _instance!;
  }

  // Check if wallet is connected
  Future<bool> isWalletConnected() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('plug_wallet_connected') ?? false;
    } catch (e) {
      debugPrint('Error checking wallet connection: $e');
      return false;
    }
  }

  // Connect wallet
  Future<bool> connectWallet() async {
    try {
      // Simulate wallet connection
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('plug_wallet_connected', true);
      await prefs.setString('wallet_address', 'demo_wallet_address_123');

      return true;
    } catch (e) {
      debugPrint('Error connecting wallet: $e');
      return false;
    }
  }

  // Disconnect wallet
  Future<bool> disconnectWallet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('plug_wallet_connected', false);
      await prefs.remove('wallet_address');

      return true;
    } catch (e) {
      debugPrint('Error disconnecting wallet: $e');
      return false;
    }
  }

  // Get wallet address
  Future<String?> getWalletAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('wallet_address');
    } catch (e) {
      debugPrint('Error getting wallet address: $e');
      return null;
    }
  }

  // Get wallet balance
  Future<double> getWalletBalance() async {
    try {
      // Simulate getting balance
      await Future.delayed(const Duration(milliseconds: 500));
      return 1000.0; // Demo balance
    } catch (e) {
      debugPrint('Error getting wallet balance: $e');
      return 0.0;
    }
  }

  // Send transaction
  Future<bool> sendTransaction({
    required String toAddress,
    required double amount,
    String? memo,
  }) async {
    try {
      // Simulate transaction
      await Future.delayed(const Duration(seconds: 3));

      debugPrint('Transaction sent: $amount ICP to $toAddress');
      if (memo != null) {
        debugPrint('Memo: $memo');
      }

      return true;
    } catch (e) {
      debugPrint('Error sending transaction: $e');
      return false;
    }
  }

  // Get transaction history
  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    try {
      // Simulate getting transaction history
      await Future.delayed(const Duration(milliseconds: 500));

      return [
        {
          'id': '1',
          'type': 'sent',
          'amount': 50.0,
          'to': 'recipient_address_1',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'status': 'completed',
        },
        {
          'id': '2',
          'type': 'received',
          'amount': 25.0,
          'from': 'sender_address_1',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'status': 'completed',
        },
        {
          'id': '3',
          'type': 'sent',
          'amount': 100.0,
          'to': 'recipient_address_2',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'status': 'pending',
        },
      ];
    } catch (e) {
      debugPrint('Error getting transaction history: $e');
      return [];
    }
  }

  // Get wallet info
  Future<Map<String, dynamic>> getWalletInfo() async {
    try {
      final address = await getWalletAddress();
      final balance = await getWalletBalance();
      final isConnected = await isWalletConnected();

      return {
        'address': address,
        'balance': balance,
        'isConnected': isConnected,
        'network': 'Internet Computer',
        'currency': 'ICP',
      };
    } catch (e) {
      debugPrint('Error getting wallet info: $e');
      return {};
    }
  }

  // Sign message
  Future<String?> signMessage(String message) async {
    try {
      // Simulate message signing
      await Future.delayed(const Duration(seconds: 1));

      final signature =
          'demo_signature_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('Message signed: $signature');

      return signature;
    } catch (e) {
      debugPrint('Error signing message: $e');
      return null;
    }
  }

  // Verify signature
  Future<bool> verifySignature({
    required String message,
    required String signature,
    required String publicKey,
  }) async {
    try {
      // Simulate signature verification
      await Future.delayed(const Duration(milliseconds: 500));

      // For demo purposes, always return true
      return true;
    } catch (e) {
      debugPrint('Error verifying signature: $e');
      return false;
    }
  }
}
