import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offline_data_loader_service.dart';
import 'scheduled_data_sync_service.dart';
import '../core/services/hybrid_magento_service.dart';

/// Service for managing initial app preload data
/// Handles offline data loading from .rada files, caching, and synchronization with flutter_magento
class PreloadService {
  static const String _preloadKey = 'app_preload_data';
  static const String _preloadVersionKey = 'preload_version';
  static const String _lastSyncKey = 'last_sync_date';
  static const String _radaDataLoadedKey = 'rada_data_loaded';

  static const String _currentVersion =
      '3.0.0'; // Updated version for exclusive .rada support

  static OfflineDataLoaderService? _offlineLoader;
  static ScheduledDataSyncService? _syncService;
  static HybridMagentoService? _magentoService;

  /// Initialize offline data loader and sync service
  static Future<void> _initializeServices() async {
    if (_offlineLoader == null) {
      _offlineLoader = OfflineDataLoaderService();
      await _offlineLoader!.initialize();
    }

    if (_syncService == null && _offlineLoader != null) {
      _syncService = ScheduledDataSyncService(
        offlineLoader: _offlineLoader!,
        magentoService: _magentoService,
      );
      await _syncService!.initialize();
    }
  }

  /// Set Magento service for online/offline sync
  static void setMagentoService(HybridMagentoService service) {
    _magentoService = service;
  }

  /// Initialize preload data on first app launch
  static Future<bool> initializePreloadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Initialize services
      await _initializeServices();

      // Check if .rada file data is already loaded
      final radaDataLoaded = prefs.getBool(_radaDataLoadedKey) ?? false;
      final existingVersion = prefs.getString(_preloadVersionKey);

      // Load data from .rada file if not already loaded or version changed
      if (!radaDataLoaded || existingVersion != _currentVersion) {
        if (kDebugMode) {
          print('Loading data from taxlien_data.rada...');
        }

        final success = await _offlineLoader!.loadFromRadaFile();

        if (success) {
          // Mark as loaded
          await prefs.setBool(_radaDataLoadedKey, true);
          await prefs.setString(_preloadVersionKey, _currentVersion);
          await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

          if (kDebugMode) {
            print('Data from .rada file loaded successfully');
          }

          // Also save initial demo data for fallback
          await _saveInitialDemoData();

          return true;
        } else {
          if (kDebugMode) {
            print('Failed to load .rada file, using demo data');
          }
          // Fallback to demo data
          return await _initializeDemoData();
        }
      }

      if (kDebugMode) {
        print('Preload data already loaded and up to date');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing preload data: $e');
      }
      // Fallback to demo data
      return await _initializeDemoData();
    }
  }

  /// Initialize with .rada file data
  static Future<bool> _initializeDemoData() async {
    try {
      if (kDebugMode) {
        print('Loading data from .rada files...');
      }

      // Initialize offline loader if not already done
      await _initializeServices();

      // Load from .rada files
      final success = await _offlineLoader!.loadFromRadaFile();

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_preloadVersionKey, _currentVersion);
        await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
        await prefs.setBool(_radaDataLoadedKey, true);

        if (kDebugMode) {
          print('Data from .rada files loaded successfully');
        }
        return true;
      }

      if (kDebugMode) {
        print('Failed to load .rada files');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing data from .rada files: $e');
      }
      return false;
    }
  }

  /// Save metadata for .rada data load
  static Future<void> _saveInitialDemoData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_radaDataLoadedKey, true);
      await prefs.setString(_preloadVersionKey, _currentVersion);
      if (kDebugMode) {
        print('Saved .rada data load metadata');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving .rada data metadata: $e');
      }
    }
  }

  /// Get cached preload data
  static Future<Map<String, dynamic>?> getCachedPreloadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preloadJson = prefs.getString(_preloadKey);

      if (preloadJson == null) return null;

      return json.decode(preloadJson) as Map<String, dynamic>;
    } catch (e) {
      print('Error loading cached preload data: $e');
      return null;
    }
  }

  /// Check if preload data is available
  static Future<bool> isPreloadDataAvailable() async {
    final data = await getCachedPreloadData();
    return data != null;
  }

  /// Get preload data summary from .rada files
  static Future<Map<String, dynamic>?> getPreloadSummary() async {
    try {
      await _initializeServices();
      if (_offlineLoader == null || !_offlineLoader!.isLoaded) {
        return null;
      }

      final stats = await _offlineLoader!.getDataStats();
      return {
        'total_products': stats['total_products'] ?? 0,
        'total_categories': stats['total_categories'] ?? 0,
        'states': stats['states'] ?? 0,
        'state_list': stats['state_list'] ?? [],
        'last_updated': stats['last_loaded'] ?? DateTime.now().toIso8601String(),
        'data_source': '.rada files',
        'features_available': [
          'Browse tax liens offline',
          'View county statistics',
          'Analyze investment opportunities',
          'Filter by state and county',
          'Multi-state support'
        ]
      };
    } catch (e) {
      print('Error getting preload summary: $e');
      return null;
    }
  }

  /// Get quick access data for app startup from .rada files
  static Future<Map<String, dynamic>?> getQuickAccessData() async {
    try {
      await _initializeServices();
      if (_offlineLoader == null || !_offlineLoader!.isLoaded) {
        return null;
      }

      final products = await _offlineLoader!.getProducts(limit: 5);
      final categories = await _offlineLoader!.getCategories();

      return {
        'featured_products': products,
        'available_states': await _offlineLoader!.getAvailableStates(),
        'total_products': (await _offlineLoader!.getProducts()).length,
        'total_categories': categories.length,
        'data_source': '.rada files'
      };
    } catch (e) {
      print('Error getting quick access data: $e');
      return null;
    }
  }

  /// Get historical tax liens
  static Future<List<Map<String, dynamic>>> getHistoricalTaxLiens() async {
    try {
      final data = await getCachedPreloadData();
      if (data == null) return [];

      final historicalData = data['historical_data'] as Map<String, dynamic>?;
      if (historicalData == null) return [];

      final sampleLiens = historicalData['sample_tax_liens'] as List<dynamic>?;
      return sampleLiens?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      print('Error getting historical tax liens: $e');
      return [];
    }
  }

  /// Get products from .rada files
  static Future<List<Map<String, dynamic>>> getCombinedProducts({
    String? state,
    String? county,
  }) async {
    try {
      await _initializeServices();
      
      if (_offlineLoader == null || !_offlineLoader!.isLoaded) {
        if (kDebugMode) {
          print('Offline loader not initialized, loading now...');
        }
        await _offlineLoader?.initialize();
      }

      final products = await _offlineLoader!.getProducts(
        state: state,
        county: county,
      );

      return products;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting products from .rada files: $e');
      }
      return [];
    }
  }

  /// Get categories from .rada files
  static Future<List<Map<String, dynamic>>> getCombinedCategories() async {
    try {
      await _initializeServices();
      
      if (_offlineLoader == null || !_offlineLoader!.isLoaded) {
        await _offlineLoader?.initialize();
      }

      final categories = await _offlineLoader!.getCategories();
      return categories;
    } catch (e) {
      print('Error getting categories from .rada files: $e');
      return [];
    }
  }

  /// Get investment opportunities
  static Future<Map<String, dynamic>?> getInvestmentOpportunities() async {
    try {
      final data = await getCachedPreloadData();
      if (data == null) return null;

      return data['investment_opportunities'] as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting investment opportunities: $e');
      return null;
    }
  }

  /// Get market insights
  static Future<Map<String, dynamic>?> getMarketInsights() async {
    try {
      final data = await getCachedPreloadData();
      if (data == null) return null;

      return data['market_insights'] as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting market insights: $e');
      return null;
    }
  }

  /// Get county overview
  static Future<Map<String, dynamic>?> getCountyOverview() async {
    try {
      final data = await getCachedPreloadData();
      if (data == null) return null;

      return data['county_overview'] as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting county overview: $e');
      return null;
    }
  }

  /// Get tax liens by county
  static Future<List<Map<String, dynamic>>> getTaxLiensByCounty(
      String county) async {
    try {
      final liens = await getHistoricalTaxLiens();
      return liens.where((lien) {
        return lien['county']?.toString().toLowerCase() == county.toLowerCase();
      }).toList();
    } catch (e) {
      print('Error getting tax liens by county: $e');
      return [];
    }
  }

  /// Get tax liens by collection year
  static Future<List<Map<String, dynamic>>> getTaxLiensByCollectionYear(
      String year) async {
    try {
      final liens = await getHistoricalTaxLiens();
      return liens.where((lien) {
        return lien['collection_year']?.toString() == year;
      }).toList();
    } catch (e) {
      print('Error getting tax liens by collection year: $e');
      return [];
    }
  }

  /// Get available tax liens
  static Future<List<Map<String, dynamic>>> getAvailableTaxLiens() async {
    try {
      final liens = await getHistoricalTaxLiens();
      return liens.where((lien) {
        return lien['lien_status']?.toString() == 'available';
      }).toList();
    } catch (e) {
      print('Error getting available tax liens: $e');
      return [];
    }
  }

  /// Get tax liens by price range
  static Future<List<Map<String, dynamic>>> getTaxLiensByPriceRange(
      double minPrice, double maxPrice) async {
    try {
      final liens = await getHistoricalTaxLiens();
      return liens.where((lien) {
        final price = (lien['tax_amount'] as num?)?.toDouble() ?? 0.0;
        return price >= minPrice && price <= maxPrice;
      }).toList();
    } catch (e) {
      print('Error getting tax liens by price range: $e');
      return [];
    }
  }

  /// Get tax liens by interest rate range
  static Future<List<Map<String, dynamic>>> getTaxLiensByInterestRateRange(
      double minRate, double maxRate) async {
    try {
      final liens = await getHistoricalTaxLiens();
      return liens.where((lien) {
        final rate = (lien['interest_rate'] as num?)?.toDouble() ?? 0.0;
        return rate >= minRate && rate <= maxRate;
      }).toList();
    } catch (e) {
      print('Error getting tax liens by interest rate range: $e');
      return [];
    }
  }

  /// Get tax liens by assessed value range
  static Future<List<Map<String, dynamic>>> getTaxLiensByAssessedValueRange(
      double minValue, double maxValue) async {
    try {
      final liens = await getHistoricalTaxLiens();
      return liens.where((lien) {
        final value = (lien['assessed_value'] as num?)?.toDouble() ?? 0.0;
        return value >= minValue && value <= maxValue;
      }).toList();
    } catch (e) {
      print('Error getting tax liens by assessed value range: $e');
      return [];
    }
  }

  /// Clear preload data (for testing or reset)
  static Future<bool> clearPreloadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_preloadKey);
      await prefs.remove(_preloadVersionKey);
      await prefs.remove(_lastSyncKey);

      print('Preload data cleared successfully');
      return true;
    } catch (e) {
      print('Error clearing preload data: $e');
      return false;
    }
  }

  /// Force refresh preload data
  static Future<bool> refreshPreloadData() async {
    try {
      // Clear existing data
      await clearPreloadData();

      // Reinitialize with fresh data
      return await initializePreloadData();
    } catch (e) {
      print('Error refreshing preload data: $e');
      return false;
    }
  }

  /// Get data freshness information
  static Future<Map<String, dynamic>?> getDataFreshness() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSync = prefs.getString(_lastSyncKey);
      final version = prefs.getString(_preloadVersionKey);

      return {
        'version': version ?? 'Unknown',
        'last_sync': lastSync ?? 'Never',
        'data_source': 'tax24.sql + demo_data.dart',
        'offline_capable': true,
        'update_frequency': 'On app update'
      };
    } catch (e) {
      print('Error getting data freshness: $e');
      return null;
    }
  }

  /// Check if data needs update
  static Future<bool> needsDataUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentVersion = prefs.getString(_preloadVersionKey);

      return currentVersion != _currentVersion;
    } catch (e) {
      print('Error checking data update need: $e');
      return true;
    }
  }

  /// Get preload status for debugging
  static Future<Map<String, dynamic>> getPreloadStatus() async {
    try {
      final isAvailable = await isPreloadDataAvailable();
      final needsUpdate = await needsDataUpdate();
      final freshness = await getDataFreshness();
      final summary = await getPreloadSummary();

      // Add offline loader stats
      Map<String, dynamic>? offlineStats;
      if (_offlineLoader != null) {
        offlineStats = await _offlineLoader!.getDataStats();
      }

      // Add sync service stats
      Map<String, dynamic>? syncStats;
      if (_syncService != null) {
        syncStats = _syncService!.getSyncStatistics();
      }

      return {
        'is_available': isAvailable,
        'needs_update': needsUpdate,
        'freshness': freshness,
        'summary': summary,
        'current_version': _currentVersion,
        'data_source': 'taxlien_data.rada + tax24.sql + demo_data.dart',
        'offline_loader': offlineStats,
        'sync_service': syncStats,
        'rada_file_loaded': _offlineLoader?.isLoaded ?? false,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting preload status: $e');
      }
      return {
        'is_available': false,
        'needs_update': true,
        'error': e.toString()
      };
    }
  }

  // ===== Offline Data Loader Methods =====

  /// Get offline data loader instance
  static OfflineDataLoaderService? get offlineLoader => _offlineLoader;

  /// Get available states from offline data
  static Future<List<String>> getAvailableStates() async {
    await _initializeServices();
    if (_offlineLoader != null) {
      return await _offlineLoader!.getAvailableStates();
    }
    return [];
  }

  /// Get counties for a specific state
  static Future<List<String>> getCountiesForState(String state) async {
    await _initializeServices();
    if (_offlineLoader != null) {
      return await _offlineLoader!.getCountiesForState(state);
    }
    return [];
  }

  /// Reload data from .rada file
  static Future<bool> reloadRadaData() async {
    await _initializeServices();
    if (_offlineLoader != null) {
      return await _offlineLoader!.reload();
    }
    return false;
  }

  // ===== Scheduled Sync Methods =====

  /// Get scheduled sync service instance
  static ScheduledDataSyncService? get syncService => _syncService;

  /// Add a sync schedule for a state
  static Future<void> addSyncSchedule({
    required String state,
    List<String>? counties,
    required Duration interval,
    bool enabled = true,
  }) async {
    await _initializeServices();
    if (_syncService != null) {
      final schedule = SyncScheduleConfig(
        state: state,
        counties: counties,
        interval: interval,
        enabled: enabled,
      );
      await _syncService!.addSchedule(schedule);
    }
  }

  /// Remove sync schedule for a state
  static Future<void> removeSyncSchedule(String state) async {
    if (_syncService != null) {
      await _syncService!.removeSchedule(state);
    }
  }

  /// Toggle sync schedule enabled/disabled
  static Future<void> toggleSyncSchedule(String state, bool enabled) async {
    if (_syncService != null) {
      await _syncService!.toggleSchedule(state, enabled);
    }
  }

  /// Get all sync schedules
  static List<SyncScheduleConfig> getSyncSchedules() {
    return _syncService?.schedules ?? [];
  }

  /// Get sync status for a state
  static Map<String, dynamic>? getSyncStatus(String state) {
    return _syncService?.getSyncStatus(state);
  }

  /// Manually sync data for a state
  static Future<bool> syncStateNow(String state) async {
    if (_syncService == null) return false;

    final schedules = _syncService!.schedules;
    final schedule = schedules.firstWhere(
      (s) => s.state == state,
      orElse: () => SyncScheduleConfig(
        state: state,
        interval: const Duration(hours: 1),
      ),
    );

    return await _syncService!.syncStateData(schedule);
  }

  /// Sync all enabled schedules
  static Future<void> syncAllStates() async {
    if (_syncService != null) {
      await _syncService!.syncAllNow();
    }
  }

  /// Get sync history
  static List<Map<String, dynamic>> getSyncHistory() {
    return _syncService?.syncHistory ?? [];
  }

  /// Get sync statistics
  static Map<String, dynamic> getSyncStatistics() {
    return _syncService?.getSyncStatistics() ?? {};
  }

  /// Create default sync schedules for common states
  static Future<void> createDefaultSyncSchedules() async {
    await _initializeServices();
    if (_syncService != null) {
      await _syncService!.createDefaultSchedules();
    }
  }

  /// Clear sync history
  static Future<void> clearSyncHistory() async {
    if (_syncService != null) {
      await _syncService!.clearSyncHistory();
    }
  }

  // ===== Utility Methods =====

  /// Get products by state and county (convenience method)
  static Future<List<Map<String, dynamic>>> getProductsByLocation({
    String? state,
    String? county,
    int? limit,
    int? offset,
  }) async {
    await _initializeServices();

    if (_offlineLoader != null) {
      return await _offlineLoader!.getProducts(
        state: state,
        county: county,
        limit: limit,
        offset: offset,
      );
    }

    // Fallback to combined products
    return await getCombinedProducts(state: state, county: county);
  }

  /// Check if using .rada data
  static bool get isUsingRadaData {
    return _offlineLoader?.isLoaded ?? false;
  }

  /// Get data source info
  static Future<Map<String, dynamic>> getDataSourceInfo() async {
    final isRadaLoaded = _offlineLoader?.isLoaded ?? false;
    final radaStats =
        isRadaLoaded ? await _offlineLoader!.getDataStats() : null;
    final selectedStates = _offlineLoader?.selectedStates ?? {};

    return {
      'primary_source': isRadaLoaded ? 'taxlien_data.rada' : 'demo_data',
      'rada_loaded': isRadaLoaded,
      'rada_stats': radaStats,
      'selected_states': selectedStates.toList(),
      'is_multiple_states': selectedStates.length > 1,
      'fallback_available': true,
      'version': _currentVersion,
    };
  }

  // ===== State Selection Methods =====

  /// Set selected states for RADA loading
  static Future<bool> setSelectedStates(Set<String> states) async {
    await _initializeServices();
    if (_offlineLoader != null) {
      return await _offlineLoader!.setSelectedStates(states);
    }
    return false;
  }

  /// Get currently selected states
  static Set<String> getSelectedStates() {
    return _offlineLoader?.selectedStates ?? {'ALL'};
  }

  /// Get available RADA state keys
  static List<String> getAvailableRadaStates() {
    return _offlineLoader?.getAvailableRadaStates() ?? [];
  }

  /// Get size information for a state
  static Future<Map<String, int>> getStateDataSize(String state) async {
    await _initializeServices();
    if (_offlineLoader != null) {
      return await _offlineLoader!.getStateDataSize(state);
    }
    return {'products': 0, 'categories': 0, 'file_size_kb': 0};
  }

  /// Check if using multiple states
  static bool get isUsingMultipleStates {
    return _offlineLoader?.isMultipleStates ?? false;
  }
}
