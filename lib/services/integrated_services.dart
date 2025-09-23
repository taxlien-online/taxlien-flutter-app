import 'package:flutter/foundation.dart';
import 'package:flutter_magento/flutter_magento.dart';
import 'package:flutter_nft/flutter_nft.dart';
import 'package:flutter_icp/flutter_icp.dart' as icp;
import 'flutter_magento_cloud_service.dart';
import 'nft_service.dart';
import 'plug_wallet_service.dart' as local;
import 'yuku_service.dart' as local_yuku;

/// Интегрированный сервис для управления всеми внешними интеграциями
class IntegratedServices extends ChangeNotifier {
  // Основные сервисы
  late FlutterMagentoCloudService _magentoService;
  late NFTService _nftService;
  late local.PlugWalletService _walletService;
  late local_yuku.YukuService _yukuService;

  // Flutter пакеты
  late FlutterMagento _magento;
  late NFTClient _nftClient;
  late icp.ICPClient _icpClient;

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FlutterMagentoCloudService get magentoService => _magentoService;
  NFTService get nftService => _nftService;
  local.PlugWalletService get walletService => _walletService;
  local_yuku.YukuService get yukuService => _yukuService;

  // Getters для Flutter пакетов
  FlutterMagento get magento => _magento;
  NFTClient get nftClient => _nftClient;
  icp.ICPClient get icpClient => _icpClient;

  /// Инициализация всех сервисов
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Инициализация Flutter Magento
      await _initializeMagento();

      // Инициализация Flutter NFT и ICP
      await _initializeNFTAndICP();

      // Инициализация сервисов
      await _initializeServices();

      _isInitialized = true;
      _error = null;

      if (kDebugMode) {
        print('All integrated services initialized successfully');
      }
    } catch (e) {
      _error = 'Failed to initialize integrated services: $e';
      if (kDebugMode) {
        print('Integrated services initialization error: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Инициализация Flutter Magento
  Future<void> _initializeMagento() async {
    try {
      _magento = FlutterMagento();
      await _magento.initialize(
        baseUrl: 'https://your-magento-store.com',
        connectionTimeout: 30000,
        receiveTimeout: 30000,
        headers: {
          'X-Store-Code': 'default',
          'Accept-Language': 'en-US',
        },
      );

      _magentoService = FlutterMagentoCloudService();
      await _magentoService._initialize();

      if (kDebugMode) {
        print('Flutter Magento initialized successfully');
      }
    } catch (e) {
      throw Exception('Failed to initialize Flutter Magento: $e');
    }
  }

  /// Инициализация Flutter NFT и ICP
  Future<void> _initializeNFTAndICP() async {
    try {
      _icpClient = icp.ICPClient();
      await _icpClient.initialize();

      _nftClient = NFTClient();
      await _nftClient.initialize();

      if (kDebugMode) {
        print('Flutter NFT and ICP initialized successfully');
      }
    } catch (e) {
      throw Exception('Failed to initialize Flutter NFT and ICP: $e');
    }
  }

  /// Инициализация сервисов
  Future<void> _initializeServices() async {
    try {
      // Инициализация NFT сервиса
      _nftService = NFTService();
      await _nftService.initialize();

      // Инициализация кошелька
      _walletService = local.PlugWalletService();
      await _walletService.initialize();

      // Инициализация Yuku маркетплейса
      _yukuService = local_yuku.YukuService();
      await _yukuService.initialize();

      if (kDebugMode) {
        print('All services initialized successfully');
      }
    } catch (e) {
      throw Exception('Failed to initialize services: $e');
    }
  }

  /// Получение статуса всех сервисов
  Map<String, bool> getServicesStatus() {
    return {
      'magento': _magentoService.isInitialized,
      'nft': _nftService.isInitialized,
      'wallet': _walletService.isConnected,
      'yuku': _yukuService.isLoading == false,
    };
  }

  /// Получение статистики интеграций
  Map<String, dynamic> getIntegrationStats() {
    return {
      'magento': {
        'isOnline': _magentoService.isOnline,
        'isAuthenticated': _magentoService.isAuthenticated,
        'cloudFunctions': _magentoService.cloudFunctionsStatus,
      },
      'nft': {
        'myNFTs': _nftService.myNFTs.length,
        'marketplaceNFTs': _nftService.marketplaceNFTs.length,
        'isInitialized': _nftService.isInitialized,
      },
      'wallet': {
        'isConnected': _walletService.isConnected,
        'principalId': _walletService.principalId,
        'accountId': _walletService.accountId,
      },
      'yuku': {
        'activeListings': _yukuService.activeListings.length,
        'myListings': _yukuService.myListings.length,
        'myOffers': _yukuService.myOffers.length,
        'receivedOffers': _yukuService.receivedOffers.length,
      },
    };
  }

  /// Переподключение всех сервисов
  Future<void> reconnectAll() async {
    _setLoading(true);
    try {
      // Переподключение кошелька
      if (!_walletService.isConnected) {
        await _walletService.connect();
      }

      // Переподключение Magento
      if (!_magentoService.isOnline) {
        await _magentoService._initialize();
      }

      // Обновление NFT данных
      await _nftService.loadMyNFTs();
      await _nftService.loadMarketplaceNFTs();

      // Обновление Yuku данных
      await _yukuService.loadActiveListings();
      await _yukuService.loadMyListings();

      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to reconnect services: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Очистка всех сервисов
  Future<void> cleanup() async {
    try {
      await _walletService.disconnect();
      await _magentoService.logout();

      _isInitialized = false;
      _error = null;
      notifyListeners();

      if (kDebugMode) {
        print('All services cleaned up successfully');
      }
    } catch (e) {
      _error = 'Failed to cleanup services: $e';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
