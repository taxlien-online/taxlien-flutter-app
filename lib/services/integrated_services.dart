import 'package:flutter/foundation.dart';
// import 'package:flutter_magento/flutter_magento.dart';
import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
// // import 'package:flutter_magento_marketplace/flutter_magento_marketplace.dart';
// // import 'package:flutter_magento_notifications/flutter_magento_notifications.dart';
// // import 'package:flutter_magento_messenger/flutter_magento_messenger.dart';
import 'database_service.dart';
import 'nft_service.dart';
import 'plug_wallet_service.dart';
// import 'flutter_magento_cloud_service.dart';

class IntegratedServices {
  static IntegratedServices? _instance;

  // Services
  // FlutterMagento? _magento; // Disabled
  late DatabaseService _databaseService;
  late NFTService _nftService;
  late PlugWalletService _walletService;
  FlutterMagentoCloudService? _magentoService;
  // NFT/Blockchain clients - temporarily disabled until API documentation is available
  // icp_lib.ICPClient? _icpClient;
  // nft_lib.NFTClient? _nftClient;
  // yuku_lib.YukuClient? _yukuClient;
  // MarketplaceProductService? _marketplaceService;  // Package not available
  // NotificationManager? _notificationManager;  // Package not available
  // MessageManager? _messageManager;  // Package not available

  // State
  bool _isInitialized = false;
  Map<String, bool> _serviceStatus = {};

  IntegratedServices._internal();

  static IntegratedServices get instance {
    _instance ??= IntegratedServices._internal();
    return _instance!;
  }

  // Initialize all services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('Initializing Integrated Services...');

      // Initialize database
      _databaseService = DatabaseService.instance;
      await _databaseService.initialize();
      debugPrint('Database service initialized');

      // Initialize NFT service
      _nftService = NFTService.instance;
      await _nftService.initialize();
      debugPrint('NFT service initialized');

      // Initialize wallet service
      _walletService = PlugWalletService.instance;
      await _walletService.initialize();
      debugPrint('Wallet service initialized');

      // Initialize Magento cloud service
      _magentoService = FlutterMagentoCloudService();
      await _magentoService?.initialize();
      debugPrint('Magento cloud service initialized');

      // NFT/Blockchain clients initialization - temporarily disabled
      // TODO: Implement proper initialization when API documentation is available
      // See: https://pub.dev/packages/flutter_nft
      // See: https://pub.dev/packages/flutter_icp
      // See: https://pub.dev/packages/flutter_yuku

      debugPrint(
          'NFT/Blockchain clients initialization skipped - awaiting API documentation');

      // Update service status
      _serviceStatus = {
        'magento': _magento != null,
        'database': true,
        'nft': _nftService.isInitialized,
        'wallet': _walletService.isConnected,
        // NFT/Blockchain status temporarily disabled
        // 'icp': _icpClient != null,
        // 'yuku': _yukuClient != null,
        // 'marketplace': _marketplaceService != null,
        // 'notifications': _notificationManager != null,
        // 'messenger': _messageManager != null,
      };

      _isInitialized = true;
      debugPrint('Integrated Services initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Integrated Services: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      _isInitialized = false;
    }
  }

  // Getters
  // FlutterMagento? get magento => _magento; // Disabled
  DatabaseService get database => _databaseService;
  NFTService get nft => _nftService;
  PlugWalletService get wallet => _walletService;
  FlutterMagentoCloudService? get magentoCloud => _magentoService;
  // NFT/Blockchain getters - temporarily disabled
  // icp_lib.ICPClient? get icp => _icpClient;
  // nft_lib.NFTClient? get nftClient => _nftClient;
  // yuku_lib.YukuClient? get yuku => _yukuClient;
  // MarketplaceProductService? get marketplace => _marketplaceService;  // Package not available
  // NotificationManager? get notifications => _notificationManager;  // Package not available
  // MessageManager? get messenger => _messageManager;  // Package not available

  bool get isInitialized => _isInitialized;
  Map<String, bool> get serviceStatus => _serviceStatus;

  // Get service statistics
  Map<String, dynamic> getStatistics() {
    return {
      'services': _serviceStatus,
      'myNFTs': _nftService.myNFTs.length,
      'walletConnected': _walletService.isConnected,
      'databaseReady': true,
    };
  }

  // Check if all services are ready
  bool get allServicesReady {
    return _serviceStatus.values.every((status) => status);
  }

  // Get service health
  Map<String, String> getServiceHealth() {
    return {
      'magento': _serviceStatus['magento'] == true ? 'Healthy' : 'Unhealthy',
      'database': _serviceStatus['database'] == true ? 'Healthy' : 'Unhealthy',
      'nft': _serviceStatus['nft'] == true ? 'Healthy' : 'Unhealthy',
      'wallet': _serviceStatus['wallet'] == true ? 'Connected' : 'Disconnected',
      'icp': _serviceStatus['icp'] == true ? 'Healthy' : 'Unhealthy',
    };
  }
}
