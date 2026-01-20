import 'package:flutter/foundation.dart';
import 'package:flutter_magento/flutter_magento.dart';
import 'database_service.dart';
import 'nft_service.dart';
import 'plug_wallet_service.dart';
import '../core/config/api_config.dart';
import '../core/services/flutter_magento_cloud_service.dart';

class IntegratedServices {
  static IntegratedServices? _instance;

  // Services
  late DatabaseService _databaseService;
  late NFTService _nftService;
  late PlugWalletService _walletService;
  FlutterMagentoCloudService? _magentoService;

  // Blockchain services from flutter_magento
  FlutterMagentoICPService? _icpService;
  FlutterMagentoNFTService? _nftBlockchainService;
  FlutterMagentoYukuService? _yukuService;

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

      // Initialize blockchain services from flutter_magento
      _icpService = FlutterMagentoICPService.instance;
      await _icpService?.initialize(
        enabled: true,
        network: ApiConfig.icpNetwork,
        enableDebug: kDebugMode,
      );
      debugPrint('ICP service initialized on ${ApiConfig.icpNetwork}');

      _nftBlockchainService = FlutterMagentoNFTService.instance;
      await _nftBlockchainService?.initialize(
        enabled: true,
        defaultNetwork: ApiConfig.nftNetwork,
        enableDebug: kDebugMode,
      );
      debugPrint('NFT blockchain service initialized on ${ApiConfig.nftNetwork}');

      _yukuService = FlutterMagentoYukuService.instance;
      await _yukuService?.initialize(
        enabled: true,
        defaultNetwork: ApiConfig.yukuNetwork,
        enableDebug: kDebugMode,
      );
      debugPrint('Yuku service initialized on ${ApiConfig.yukuNetwork}');

      // Update service status
      _serviceStatus = {
        'magento': _magentoService != null,
        'database': true,
        'nft': _nftService.isInitialized,
        'wallet': _walletService.isConnected,
        'icp': _icpService?.isInitialized ?? false,
        'nft_blockchain': _nftBlockchainService?.isInitialized ?? false,
        'yuku': _yukuService?.isInitialized ?? false,
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
  DatabaseService get database => _databaseService;
  NFTService get nft => _nftService;
  PlugWalletService get wallet => _walletService;
  FlutterMagentoCloudService? get magentoCloud => _magentoService;

  // Blockchain service getters from flutter_magento
  FlutterMagentoICPService? get icp => _icpService;
  FlutterMagentoNFTService? get nftBlockchain => _nftBlockchainService;
  FlutterMagentoYukuService? get yuku => _yukuService;

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
