import 'dart:convert';

/// Historical data for TaxLien.online mobile app
/// NOW LOADS FROM .rada FILES - This class is kept for backward compatibility only
/// All actual historical data is loaded from /assets/*.rada files via OfflineDataLoaderService
class TaxLienHistoricalData {
  // DEPRECATED: Use OfflineDataLoaderService to load historical data from .rada files
  static const String _deprecationMessage =
      'TaxLienHistoricalData is deprecated. Use OfflineDataLoaderService to load historical data from .rada files.';

  // Minimal JSON structure for backward compatibility
  static const String _historicalDataJson = '''
{
  "historical_collections": {},
  "sample_tax_liens": [],
  "county_statistics": {},
  "investment_analytics": {},
  "market_trends": {}
}
''';

  static Map<String, dynamic> get historicalData =>
      json.decode(_historicalDataJson);

  /// Get historical collections by year (DEPRECATED - returns null)
  static Map<String, dynamic>? getHistoricalCollection(String year) {
    print(_deprecationMessage);
    return null;
  }

  /// Get all counties for a specific year (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getCountiesForYear(String year) {
    print(_deprecationMessage);
    return [];
  }

  /// Get sample tax liens from historical data (DEPRECATED - returns empty list)
  /// Use OfflineDataLoaderService.getProducts() instead
  static List<Map<String, dynamic>> getSampleTaxLiens() {
    print('$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts()');
    return [];
  }

  /// Get county statistics (DEPRECATED - returns null)
  static Map<String, dynamic>? getCountyStatistics(String countyCode) {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getCountyByName()',
    );
    return null;
  }

  /// Get investment analytics for a specific year and state (DEPRECATED - returns null)
  static Map<String, dynamic>? getInvestmentAnalytics(
    String year,
    String state,
  ) {
    print(_deprecationMessage);
    return null;
  }

  /// Get market trends for a specific year and state (DEPRECATED - returns null)
  static Map<String, dynamic>? getMarketTrends(String year, String state) {
    print(_deprecationMessage);
    return null;
  }

  /// Get tax liens by county from historical data (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getTaxLiensByCounty(String county) {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(county: "$county")',
    );
    return [];
  }

  /// Get tax liens by collection year (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getTaxLiensByCollectionYear(String year) {
    print(_deprecationMessage);
    return [];
  }

  /// Get tax liens by state (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getTaxLiensByState(String state) {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(state: "$state")',
    );
    return [];
  }

  /// Get available tax liens (status = 'available') (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getAvailableHistoricalTaxLiens() {
    print(_deprecationMessage);
    return [];
  }

  /// Get tax liens by interest rate range (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getTaxLiensByInterestRateRange(
    double minRate,
    double maxRate,
  ) {
    print(_deprecationMessage);
    return [];
  }

  /// Get tax liens by assessed value range (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getTaxLiensByAssessedValueRange(
    double minValue,
    double maxValue,
  ) {
    print(_deprecationMessage);
    return [];
  }

  /// Get tax liens by tax amount range (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getTaxLiensByTaxAmountRange(
    double minAmount,
    double maxAmount,
  ) {
    print(_deprecationMessage);
    return [];
  }

  /// Get all Florida counties from 2024 collection (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getFlorida2024Counties() {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getCountiesForState("FL")',
    );
    return [];
  }

  /// Get total investment opportunity for a specific year and state (DEPRECATED - returns 0.0)
  static double getTotalInvestmentOpportunity(String year, String state) {
    print(_deprecationMessage);
    return 0.0;
  }

  /// Get average investment amount for a specific year and state (DEPRECATED - returns 0.0)
  static double getAverageInvestmentAmount(String year, String state) {
    print(_deprecationMessage);
    return 0.0;
  }

  /// Get county performance metrics (DEPRECATED - returns empty map)
  static Map<String, dynamic> getCountyPerformanceMetrics(String countyCode) {
    print(_deprecationMessage);
    return {};
  }

  /// Get market insights for investment decisions (DEPRECATED - returns empty map)
  static Map<String, dynamic> getMarketInsights(String year, String state) {
    print(_deprecationMessage);
    return {};
  }
}
