/// Initial preload data for TaxLien.online mobile app
/// NOW LOADS FROM .rada FILES - This class is kept for backward compatibility only
/// All actual data is loaded from /assets/*.rada files via OfflineDataLoaderService
///
/// DEPRECATED: This class no longer provides actual data.
/// Use OfflineDataLoaderService and PreloadService instead.
class InitialPreloadData {
  static const String _deprecationMessage =
      'InitialPreloadData is deprecated. Use OfflineDataLoaderService and PreloadService to load data from .rada files.';

  /// Get combined initial data for app preload (DEPRECATED - returns minimal data)
  /// Use PreloadService.initializePreloadData() and OfflineDataLoaderService instead
  static Map<String, dynamic> getInitialPreloadData() {
    print(_deprecationMessage);
    return {
      'app_info': {
        'version': '3.0.0',
        'preload_date': DateTime.now().toIso8601String(),
        'data_source': '.rada files via OfflineDataLoaderService',
        'description': 'Data now loaded from .rada files in /assets/',
        'features': [
          'Multi-state .rada file support',
          'Dynamic data loading',
          'Improved offline capabilities',
          'Real-time data from .rada files',
        ],
      },
      'note':
          'Use OfflineDataLoaderService.getProducts(), getCategories(), getCountiesData()',
      'historical_data': {},
      'demo_data': {},
      'combined_products': [],
      'combined_categories': [],
      'investment_opportunities': {},
      'market_insights': {},
      'county_overview': {},
    };
  }

  /// Get preload data summary (DEPRECATED)
  /// Use PreloadService.getPreloadSummary() instead
  static Map<String, dynamic> getPreloadSummary() {
    print('$_deprecationMessage\nUse: PreloadService.getPreloadSummary()');
    return {
      'total_products': 0,
      'total_categories': 0,
      'historical_counties': 0,
      'investment_opportunities': {},
      'data_size_estimate': 'Variable based on selected .rada files',
      'last_updated': DateTime.now().toIso8601String(),
      'features_available': [
        'Use OfflineDataLoaderService for all data access',
      ],
    };
  }

  /// Get quick access data for app startup (DEPRECATED)
  /// Use PreloadService.getQuickAccessData() instead
  static Map<String, dynamic> getQuickAccessData() {
    print('$_deprecationMessage\nUse: PreloadService.getQuickAccessData()');
    return {
      'featured_products': [],
      'county_highlights': [],
      'investment_summary': {},
      'recent_activity': [],
    };
  }

  /// Check if preload data is available (DEPRECATED)
  /// Use PreloadService.isPreloadDataAvailable() instead
  static bool isPreloadDataAvailable() {
    print('$_deprecationMessage\nUse: PreloadService.isPreloadDataAvailable()');
    return false;
  }

  /// Get data freshness info (DEPRECATED)
  static Map<String, dynamic> getDataFreshness() {
    print(_deprecationMessage);
    return {
      'data_source': '.rada files in /assets/',
      'update_frequency': 'Dynamic - loaded from .rada files',
      'offline_capable': true,
      'note':
          'Use OfflineDataLoaderService.getDataStats() for current data info',
    };
  }
}
