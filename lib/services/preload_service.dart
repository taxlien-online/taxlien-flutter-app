import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/initial_preload_data.dart';
import '../data/demo_data.dart';

/// Service for managing initial app preload data
/// Handles offline data loading, caching, and synchronization
class PreloadService {
  static const String _preloadKey = 'app_preload_data';
  static const String _preloadVersionKey = 'preload_version';
  static const String _lastSyncKey = 'last_sync_date';

  static const String _currentVersion = '1.0.0';

  /// Initialize preload data on first app launch
  static Future<bool> initializePreloadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if preload data already exists
      final existingData = prefs.getString(_preloadKey);
      final existingVersion = prefs.getString(_preloadVersionKey);

      if (existingData != null && existingVersion == _currentVersion) {
        print('Preload data already exists and is up to date');
        return true;
      }

      // Generate initial preload data
      final preloadData = InitialPreloadData.getInitialPreloadData();
      final preloadJson = json.encode(preloadData);

      // Save to SharedPreferences
      await prefs.setString(_preloadKey, preloadJson);
      await prefs.setString(_preloadVersionKey, _currentVersion);
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

      print('Initial preload data saved successfully');
      return true;
    } catch (e) {
      print('Error initializing preload data: $e');
      return false;
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

  /// Get preload data summary
  static Future<Map<String, dynamic>?> getPreloadSummary() async {
    try {
      final data = await getCachedPreloadData();
      if (data == null) return null;

      return InitialPreloadData.getPreloadSummary();
    } catch (e) {
      print('Error getting preload summary: $e');
      return null;
    }
  }

  /// Get quick access data for app startup
  static Future<Map<String, dynamic>?> getQuickAccessData() async {
    try {
      final data = await getCachedPreloadData();
      if (data == null) return null;

      return InitialPreloadData.getQuickAccessData();
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

  /// Get combined products (demo + historical)
  static Future<List<Map<String, dynamic>>> getCombinedProducts() async {
    try {
      final data = await getCachedPreloadData();
      if (data == null) return TaxLienDemoData.demoProducts;

      final combinedProducts = data['combined_products'] as List<dynamic>?;
      return combinedProducts?.cast<Map<String, dynamic>>() ??
          TaxLienDemoData.demoProducts;
    } catch (e) {
      print('Error getting combined products: $e');
      return TaxLienDemoData.demoProducts;
    }
  }

  /// Get combined categories
  static Future<List<Map<String, dynamic>>> getCombinedCategories() async {
    try {
      final data = await getCachedPreloadData();
      if (data == null) return TaxLienDemoData.demoCategories;

      final combinedCategories = data['combined_categories'] as List<dynamic>?;
      return combinedCategories?.cast<Map<String, dynamic>>() ??
          TaxLienDemoData.demoCategories;
    } catch (e) {
      print('Error getting combined categories: $e');
      return TaxLienDemoData.demoCategories;
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

      return {
        'is_available': isAvailable,
        'needs_update': needsUpdate,
        'freshness': freshness,
        'summary': summary,
        'current_version': _currentVersion,
        'data_source': 'tax24.sql + demo_data.dart'
      };
    } catch (e) {
      print('Error getting preload status: $e');
      return {
        'is_available': false,
        'needs_update': true,
        'error': e.toString()
      };
    }
  }
}
