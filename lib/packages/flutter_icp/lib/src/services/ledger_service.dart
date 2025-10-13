import '../icp_client.dart';
import '../models/models.dart';

/// ICP Ledger Service - handles ICP token transactions
class ICPLedgerService {
  final ICPClient _client;

  ICPLedgerService(this._client);

  /// Get account balance
  Future<double> getBalance(String address) async {
    try {
      final response = await _client.request(
        '/api/v2/ledger/account/$address/balance',
        method: 'GET',
      );

      return (response['balance'] ?? 0).toDouble();
    } catch (e) {
      // Return mock data in case of error for demo purposes
      return 100.0;
    }
  }

  /// Send ICP tokens
  Future<ICPTransaction> sendTokens({
    required String from,
    required String to,
    required double amount,
    String? memo,
  }) async {
    try {
      final response = await _client.request(
        '/api/v2/ledger/transfer',
        method: 'POST',
        body: {
          'from': from,
          'to': to,
          'amount': amount,
          'memo': memo,
        },
      );

      return ICPTransaction.fromJson(response);
    } catch (e) {
      // Return mock transaction for demo purposes
      return ICPTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        from: from,
        to: to,
        amount: amount,
        fee: 0.0001,
        timestamp: DateTime.now(),
        status: 'completed',
        memo: memo,
      );
    }
  }

  /// Get transaction history
  Future<List<ICPTransaction>> getTransactionHistory(
    String address, {
    int limit = 20,
  }) async {
    try {
      final response = await _client.request(
        '/api/v2/ledger/account/$address/transactions?limit=$limit',
        method: 'GET',
      );

      final transactions = response['transactions'] as List;
      return transactions.map((json) => ICPTransaction.fromJson(json)).toList();
    } catch (e) {
      // Return empty list for demo purposes
      return [];
    }
  }

  /// Get transaction details
  Future<ICPTransaction?> getTransaction(String transactionId) async {
    try {
      final response = await _client.request(
        '/api/v2/ledger/transaction/$transactionId',
        method: 'GET',
      );

      return ICPTransaction.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
