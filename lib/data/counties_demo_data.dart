import 'dart:convert';

/// Demo counties data for TaxLien.online mobile app
/// NOW LOADS FROM .rada FILES - This class is kept for backward compatibility only
/// All actual county data is loaded from /assets/*.rada files via OfflineDataLoaderService
class TaxLienCountiesDemoData {
  // DEPRECATED: Use OfflineDataLoaderService to load county data from .rada files
  static const String _deprecationMessage = 
      'TaxLienCountiesDemoData is deprecated. Use OfflineDataLoaderService.getCountiesData() to load county data from .rada files.';

  // Empty JSON structure for backward compatibility
  static const String _countiesJson = '''
{
  "counties": {}
}
''';

  static Map<String, dynamic> get countiesData => json.decode(_countiesJson);

  /// Get all counties for a specific state (DEPRECATED - returns empty list)
  /// Use OfflineDataLoaderService.getCountiesForState(stateCode) instead
  static List<Map<String, dynamic>> getCountiesByState(String stateCode) {
    print('$_deprecationMessage\nUse: OfflineDataLoaderService.getCountiesForState("$stateCode")');
    return [];
  }

  /// Get all states with county data (DEPRECATED - returns empty list)
  /// Use OfflineDataLoaderService.getAvailableStates() instead
  static List<String> get statesWithCountyData {
    print('$_deprecationMessage\nUse: OfflineDataLoaderService.getAvailableStates()');
    return [];
  }

  /// Get county by name and state (DEPRECATED - returns null)
  /// Use OfflineDataLoaderService.getCountyByName(stateCode, countyName) instead
  static Map<String, dynamic>? getCountyByName(
      String stateCode, String countyName) {
    print('$_deprecationMessage\nUse: OfflineDataLoaderService.getCountyByName("$stateCode", "$countyName")');
    return null;
  }

  /// Get county by code and state (DEPRECATED - returns null)
  static Map<String, dynamic>? getCountyByCode(
      String stateCode, String countyCode) {
    print(_deprecationMessage);
    return null;
  }

  /// Get counties by population range (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getCountiesByPopulationRange(
      String stateCode, int minPopulation, int maxPopulation) {
    print(_deprecationMessage);
    return [];
  }

  /// Get counties by area range (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getCountiesByAreaRange(
      String stateCode, double minArea, double maxArea) {
    print(_deprecationMessage);
    return [];
  }

  /// Get largest counties by population (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getLargestCountiesByPopulation(
      String stateCode, int limit) {
    print(_deprecationMessage);
    return [];
  }

  /// Get smallest counties by population (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getSmallestCountiesByPopulation(
      String stateCode, int limit) {
    print(_deprecationMessage);
    return [];
  }

  /// Get total population for a state (DEPRECATED - returns 0)
  static int getTotalPopulationForState(String stateCode) {
    print(_deprecationMessage);
    return 0;
  }

  /// Get total area for a state (DEPRECATED - returns 0.0)
  static double getTotalAreaForState(String stateCode) {
    print(_deprecationMessage);
    return 0.0;
  }

  /// Get average population density for a state (DEPRECATED - returns 0.0)
  static double getAveragePopulationDensityForState(String stateCode) {
    print(_deprecationMessage);
    return 0.0;
  }
}
