import 'package:flutter/foundation.dart';
import 'package:flutter_magento/flutter_magento.dart';
import 'package:flutter_icp/flutter_icp.dart' as icp_lib;
import 'package:flutter_nft/flutter_nft.dart' as nft_lib;
import 'package:flutter_yuku/flutter_yuku.dart' as yuku_lib;
import 'package:flutter_magento_marketplace/flutter_magento_marketplace.dart';
import 'package:flutter_magento_notifications/flutter_magento_notifications.dart';
import 'package:flutter_magento_messenger/flutter_magento_messenger.dart';
import 'database_service.dart';
import 'nft_service.dart';
import 'plug_wallet_service.dart';
import 'flutter_magento_cloud_service.dart';

class IntegratedServices {
  static IntegratedServices? _instance;

  // Services
  FlutterMagento? _magento;
  late DatabaseService _databaseService;
  late NFTService _nftService;
  late PlugWalletService _walletService;
  late FlutterMagentoCloudService _magentoService;
  icp_lib.ICPClient? _icpClient;
  nft_lib.NFTClient? _nftClient;
  yuku_lib.YukuClient? _yukuClient;
  MarketplaceProductService? _marketplaceService;
  NotificationManager? _notificationManager;
  MessageManager? _messageManager;

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
      debugPrint('Magento cloud service initialized');

      // Initialize ICP client
      try {
        _icpClient = icp_lib.ICPClient();
        debugPrint('ICP client initialized');
      } catch (e) {
        debugPrint('ICP client initialization failed: $e');
      }

      // Initialize NFT client
      try {
        _nftClient = nft_lib.NFTClient();
        debugPrint('NFT client initialized');
      } catch (e) {
        debugPrint('NFT client initialization failed: $e');
      }

      // Initialize Yuku client
      try {
        _yukuClient = yuku_lib.YukuClient();
        debugPrint('Yuku client initialized');
      } catch (e) {
        debugPrint('Yuku client initialization failed: $e');
      }

      // Update service status
      _serviceStatus = {
        'magento': _magento != null,
        'database': true,
        'nft': _nftService.isInitialized,
        'wallet': _walletService.isConnected,
        'icp': _icpClient != null,
        'yuku': _yukuClient != null,
        'marketplace': _marketplaceService != null,
        'notifications': _notificationManager != null,
        'messenger': _messageManager != null,
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
  FlutterMagento? get magento => _magento;
  DatabaseService get database => _databaseService;
  NFTService get nft => _nftService;
  PlugWalletService get wallet => _walletService;
  FlutterMagentoCloudService get magentoCloud => _magentoService;
  icp_lib.ICPClient? get icp => _icpClient;
  nft_lib.NFTClient? get nftClient => _nftClient;
  yuku_lib.YukuClient? get yuku => _yukuClient;
  MarketplaceProductService? get marketplace => _marketplaceService;
  NotificationManager? get notifications => _notificationManager;
  MessageManager? get messenger => _messageManager;

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
