import 'package:flutter/foundation.dart';
// import 'package:flutter_magento/flutter_magento.dart';  // Temporarily disabled
import 'package:flutter_icp/flutter_icp.dart' as icp;
import 'package:flutter_nft/flutter_nft.dart' as nft;
import 'package:flutter_yuku/flutter_yuku.dart' as yuku;
import 'database_service.dart';
import 'nft_service.dart';
import 'plug_wallet_service.dart';
import 'flutter_magento_cloud_service.dart';

class IntegratedServices {
  static IntegratedServices? _instance;

  // Services
  // late FlutterMagento _magento;  // Temporarily disabled
  late DatabaseService _databaseService;
  late NFTService _nftService;
  late PlugWalletService _walletService;
  late FlutterMagentoCloudService _magentoService;
  late dynamic _icpClient; // Using dynamic to avoid import issues

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

      // Initialize Magento (temporarily disabled)
      // _magento = FlutterMagento();
      // await _magento.initialize();

      // Initialize database
      _databaseService = DatabaseService.instance;
      await _databaseService.initialize();

      // Initialize NFT service
      _nftService = NFTService.instance;
      await _nftService.initialize();

      // Initialize wallet service
      _walletService = PlugWalletService.instance;
      await _walletService.initialize();

      // Initialize Magento cloud service
      _magentoService = FlutterMagentoCloudService();
      // await _magentoService._initialize();  // Temporarily disabled

      // Initialize ICP client (temporarily disabled)
      // _icpClient = icp.ICPClient();
      _icpClient = null;

      // Update service status
      _serviceStatus = {
        'magento': false, // Temporarily disabled
        'database': true,
        'nft': _nftService.isInitialized,
        'wallet': _walletService.isConnected,
        'icp': true,
      };

      _isInitialized = true;
      debugPrint('Integrated Services initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Integrated Services: $e');
      _isInitialized = false;
    }
  }

  // Getters
  // FlutterMagento get magento => _magento;  // Temporarily disabled
  DatabaseService get database => _databaseService;
  NFTService get nft => _nftService;
  PlugWalletService get wallet => _walletService;
  FlutterMagentoCloudService get magentoCloud => _magentoService;
  dynamic get icp => _icpClient;

  bool get isInitialized => _isInitialized;
  Map<String, bool> get serviceStatus => _serviceStatus;

  // Get service statistics
  Map<String, dynamic> getStatistics() {
    return {
      'services': _serviceStatus,
      'myNFTs': _nftService.myNFTs.length,
      'walletConnected': _walletService.isConnected,
      'databaseReady': _databaseService != null,
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
