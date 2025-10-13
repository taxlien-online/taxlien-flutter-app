/// ICP Constants
class ICPConstants {
  // Network URLs
  static const String mainnetUrl = 'https://ic0.app';
  static const String testnetUrl = 'https://ic0.testnet.app';

  // Default canisters
  static const String ledgerCanisterId = 'ryjl3-tyaaa-aaaaa-aaaba-cai';
  static const String nnsCanisterId = 'qoctq-giaaa-aaaaa-aaaea-cai';
  static const String governanceCanisterId = 'rrkah-fqaaa-aaaaa-aaaaq-cai';

  // Token
  static const String icpSymbol = 'ICP';
  static const int icpDecimals = 8;

  // Transaction fees
  static const double defaultTransactionFee = 0.0001; // 10,000 e8s

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration callTimeout = Duration(seconds: 60);
}
