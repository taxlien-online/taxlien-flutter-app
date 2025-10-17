import 'package:flutter_nft/flutter_nft.dart';
import '../../services/integrated_services.dart';

/// Application constants for TaxLien.online
class AppConstants {
  // Private constructor
  AppConstants._();

  // App Information
  static const String appName = 'TaxLien.online';
  static const String appVersion = '2.0.0';
  static const String appDescription = 'Invest in tax liens with confidence';

  // API Configuration
  static const String magentoBaseUrl = 'https://taxlien.online';
  static const String magentoRestEndpoint = '$magentoBaseUrl/rest/V1';
  static const String magentoMediaUrl =
      '$magentoBaseUrl/pub/media/catalog/product';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 1);
  static const int maxCacheSize = 100;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String validationErrorMessage =
      'Please check your input and try again.';

  // Success Messages
  static const String loginSuccessMessage = 'Successfully logged in!';
  static const String registrationSuccessMessage =
      'Account created successfully!';
  static const String profileUpdateSuccessMessage =
      'Profile updated successfully!';
  static const String passwordChangeSuccessMessage =
      'Password changed successfully!';

  // Feature Flags
  static const bool enableBiometrics = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const bool enableInAppPurchases = true;
  static const bool enableAds = false;

  // Cloud Integration Flags
  static const bool enableCloudSync = true;
  static const bool enableOfflineMode = true;
  static const bool preferCloudWhenAvailable = true;
  static const bool enableCloudBackup = true;
  static const bool enableCloudAnalytics = true;

  // Deep Links
  static const String deepLinkScheme = 'taxlien';
  static const String deepLinkHost = 'taxlien.online';

  // Social Media
  static const String twitterUrl = 'https://twitter.com/taxlienonline';
  static const String facebookUrl = 'https://facebook.com/taxlienonline';
  static const String linkedinUrl =
      'https://linkedin.com/company/taxlienonline';
  static const String instagramUrl = 'https://instagram.com/taxlienonline';

  // Support
  static const String supportEmail = 'support@taxlien.online';
  static const String supportPhone = '+1-800-TAXLIEN';
  static const String supportWebsite = 'https://taxlien.online/support';

  // Legal
  static const String privacyPolicyUrl = 'https://taxlien.online/privacy';

  // Donation
  static const String donationAddress =
      '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a';
  static const String termsOfServiceUrl = 'https://taxlien.online/terms';
  static const String cookiePolicyUrl = 'https://taxlien.online/cookies';

  // App Store Links
  static const String appStoreUrl =
      'https://apps.apple.com/app/taxlien-online/id123456789';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.taxlien.online';

  // NFT Client - Global instance for the app
  static NFTClient? nftClient;

  // Integrated Services - Global instance for the app
  static IntegratedServices? integratedServices;
}
