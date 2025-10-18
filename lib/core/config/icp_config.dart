/// Configuration for Internet Computer Protocol (ICP) integration
class ICPConfig {
  // Private constructor
  ICPConfig._();

  // ICP Network endpoints
  static const String mainnetHost = 'https://ic0.app';
  static const String mainnetCanisterId = 'rrkah-fqaaa-aaaaa-aaaaq-cai';

  // Testnet endpoints (for development)
  static const String testnetHost = 'https://ic0.app';
  static const String testnetCanisterId = 'rrkah-fqaaa-aaaaa-aaaaq-cai';

  // Yuku Marketplace endpoints
  static const String yukuApiUrl = 'https://yuku.app/api/v1';
  static const String yukuMarketplaceUrl = 'https://yuku.app';
  static const String yukuWebSocketUrl = 'wss://yuku.app/ws';

  // Yuku Canister IDs
  static const String yukuMarketplaceCanisterId = 'yuku-m4aaaa-aaaaa-aaaar-cai';
  static const String yukuNFTCanisterId = 'yuku-n3aaaa-aaaaa-aaaas-cai';

  // Plug Wallet configuration
  static const String plugWalletUrl = 'https://plugwallet.ooo';
  static const List<String> plugWhitelist = [
    mainnetCanisterId,
    yukuMarketplaceCanisterId,
    yukuNFTCanisterId,
  ];

  // Network selection (switch to testnet for development)
  static const bool useMainnet = true;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration requestTimeout = Duration(seconds: 60);
  static const Duration retryDelay = Duration(seconds: 3);
  static const int maxRetries = 3;

  // Environment getters
  static String get host => useMainnet ? mainnetHost : testnetHost;
  static String get canisterId =>
      useMainnet ? mainnetCanisterId : testnetCanisterId;

  // API Keys (should be stored securely in production)
  static const String yukuApiKey = 'YOUR_YUKU_API_KEY';

  // Features
  static const bool enableWebSocket = true;
  static const bool enableCaching = true;
  static const bool enableOfflineMode = true;

  // Cache settings
  static const Duration cacheDuration = Duration(minutes: 5);
  static const int maxCacheSize = 100;

  // Logging
  static const bool enableDebugLogging = true;

  // Headers for API requests
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (yukuApiKey.isNotEmpty) 'X-API-Key': yukuApiKey,
      };
}
