import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get gatewayBaseUrl =>
      dotenv.get('GATEWAY_URL', fallback: 'https://api.taxlien.online');
  static String get apiVersion => 'v1';

  static String get magentoBaseUrl =>
      dotenv.get('MAGENTO_BASE_URL', fallback: 'https://taxlien.online');
  static String get magentoApiKey => dotenv.get('MAGENTO_API_KEY', fallback: '');

  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // RevenueCat Keys
  static String get revenueCatApiKeyIOS =>
      dotenv.get('REVENUECAT_API_KEY_IOS', fallback: '');
  static String get revenueCatApiKeyAndroid =>
      dotenv.get('REVENUECAT_API_KEY_ANDROID', fallback: '');

  // Feature Flags
  static bool get enableAnalytics =>
      dotenv.get('ENABLE_ANALYTICS', fallback: 'true').toLowerCase() == 'true';
  static bool get enableNotifications =>
      dotenv.get('ENABLE_NOTIFICATIONS', fallback: 'true').toLowerCase() == 'true';

  // Blockchain Configuration
  static String get icpNetwork =>
      dotenv.get('ICP_NETWORK', fallback: 'mainnet'); // Default to mainnet for prod
  static String get nftNetwork =>
      dotenv.get('NFT_NETWORK', fallback: 'polygon');
  static String get yukuNetwork =>
      dotenv.get('YUKU_NETWORK', fallback: 'icp');
}
