import 'dart:convert';

/// Demo categories data for TaxLien.online mobile app
/// NOW LOADS FROM .rada FILES - This class is kept for backward compatibility only
/// All actual category data is loaded from /assets/*.rada files via OfflineDataLoaderService
class TaxLienCategoriesDemoData {
  // DEPRECATED: Use OfflineDataLoaderService to load category data from .rada files
  static const String _deprecationMessage = 
      'TaxLienCategoriesDemoData is deprecated. Use OfflineDataLoaderService.getCategories() to load category data from .rada files.';

  // Empty JSON structure for backward compatibility
  static const String _categoriesJson = '''
{
  "categories": []
}
''';

  static Map<String, dynamic> get categoriesData =>
      json.decode(_categoriesJson);

  /// Get all categories (DEPRECATED - returns empty list)
  /// Use OfflineDataLoaderService.getCategories() instead
  static List<Map<String, dynamic>> get allCategories {
    print(_deprecationMessage);
    return [];
  }

  /// Get root categories (level 1) (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> get rootCategories {
    print(_deprecationMessage);
    return [];
  }

  /// Get state categories (level 2) (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> get stateCategories {
    print(_deprecationMessage);
    return [];
  }

  /// Get categories by state code (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getCategoriesByStateCode(String stateCode) {
    print('$_deprecationMessage\nNote: Filter categories by state_code attribute from OfflineDataLoaderService.getCategories()');
    return [];
  }

  /// Get category by ID (DEPRECATED - returns null)
  static Map<String, dynamic>? getCategoryById(int id) {
    print(_deprecationMessage);
    return null;
  }

  /// Get child categories by parent ID (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> getChildCategories(int parentId) {
    print(_deprecationMessage);
    return [];
  }

  /// Get all US states with tax lien programs (DEPRECATED - returns empty list)
  /// Use OfflineDataLoaderService.getAvailableStates() instead
  static List<String> get statesWithTaxLiens {
    print('$_deprecationMessage\nUse: OfflineDataLoaderService.getAvailableStates()');
    return [];
  }

  /// Get state name by code (still functional for basic mapping)
  static String getStateNameByCode(String stateCode) {
    const stateNames = {
      'FL': 'Florida',
      'TX': 'Texas',
      'CA': 'California',
      'NY': 'New York',
      'AZ': 'Arizona',
      'GA': 'Georgia',
      'CO': 'Colorado',
      'NV': 'Nevada',
      'UT': 'Utah',
      'IA': 'Iowa',
      'IL': 'Illinois',
      'IN': 'Indiana',
      'KY': 'Kentucky',
      'MD': 'Maryland',
      'MI': 'Michigan',
      'MN': 'Minnesota',
      'MO': 'Missouri',
      'MT': 'Montana',
      'NE': 'Nebraska',
      'NJ': 'New Jersey',
      'NC': 'North Carolina',
      'OH': 'Ohio',
      'OR': 'Oregon',
      'PA': 'Pennsylvania',
      'SC': 'South Carolina',
      'TN': 'Tennessee',
      'VA': 'Virginia',
      'WA': 'Washington',
      'WI': 'Wisconsin',
      'WY': 'Wyoming'
    };
    return stateNames[stateCode] ?? stateCode;
  }
}
