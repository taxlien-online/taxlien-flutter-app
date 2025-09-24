// Simple stub for flutter_icp package
// This is a temporary implementation to avoid build errors

class ICPClient {
  static final ICPClient _instance = ICPClient._internal();
  factory ICPClient() => _instance;
  ICPClient._internal();

  bool _isInitialized = false;

  Future<void> initialize({
    String networkUrl = 'https://ic0.app',
    String testnetUrl = 'https://ic0.testnet.app',
    bool isTestnet = false,
  }) async {
    _isInitialized = true;
  }

  bool get isInitialized => _isInitialized;
  String get currentNetworkUrl => 'https://ic0.app';
  bool get isTestnet => false;
}

class Transaction {
  final String id;
  final String from;
  final String to;
  final double amount;
  final double fee;
  final DateTime timestamp;
  final String status;
  final String? memo;

  Transaction({
    required this.id,
    required this.from,
    required this.to,
    required this.amount,
    required this.fee,
    required this.timestamp,
    required this.status,
    this.memo,
  });
}

class NetworkStatus {
  final String version;
  final String replicaId;
  final DateTime timestamp;
  final Map<String, dynamic> metrics;

  NetworkStatus({
    required this.version,
    required this.replicaId,
    required this.timestamp,
    required this.metrics,
  });
}

class CanisterInfo {
  final String id;
  final String status;
  final String? controller;
  final Map<String, dynamic> moduleHash;
  final DateTime createdAt;

  CanisterInfo({
    required this.id,
    required this.status,
    this.controller,
    required this.moduleHash,
    required this.createdAt,
  });
}

class ICPNFTProvider {
  Future<void> initialize() async {}
}

class PlugWalletProvider {
  Future<void> initialize() async {}
}

class YukuMarketplaceProvider {
  Future<void> initialize() async {}
}

class BlockchainNetwork {
  static const icp = 'icp';
}

class ListingStatus {
  static const active = 'active';
  static const inactive = 'inactive';
  static const sold = 'sold';
}

class OfferStatus {
  static const pending = 'pending';
  static const accepted = 'accepted';
  static const rejected = 'rejected';
}

class ICPException implements Exception {
  final String message;
  final int? statusCode;

  ICPException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ICPException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}
