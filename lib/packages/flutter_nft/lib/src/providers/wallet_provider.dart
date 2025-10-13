/// Abstract Wallet Provider interface
/// Implement this for each wallet type (Plug, Stoic, etc.)
abstract class WalletProvider {
  /// Connect to wallet
  Future<String> connect();

  /// Disconnect from wallet
  Future<void> disconnect();

  /// Sign a message
  Future<String> signMessage(String message);

  /// Sign a transaction
  Future<String> signTransaction(Map<String, dynamic> transaction);

  /// Get wallet balance
  Future<double> getBalance() async {
    throw UnimplementedError('getBalance not implemented');
  }

  /// Send tokens
  Future<String> sendTokens({
    required String toAddress,
    required double amount,
    String? memo,
  }) async {
    throw UnimplementedError('sendTokens not implemented');
  }

  /// Check if wallet is connected
  bool get isConnected;

  /// Get wallet address
  String? get address;

  /// Get wallet network
  String? get network => null;
}
