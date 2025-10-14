import 'dart:convert';

/// Demo data for TaxLien.online mobile app
/// NOW LOADS FROM .rada FILES - This class is kept for backward compatibility only
/// All actual data is loaded from /assets/*.rada files via OfflineDataLoaderService
class TaxLienDemoData {
  // DEPRECATED: Use OfflineDataLoaderService to load data from .rada files
  static const String _deprecationMessage =
      'TaxLienDemoData is deprecated. Use OfflineDataLoaderService to load data from .rada files.';

  // Empty JSON structure for backward compatibility
  static const String _demoDataJson = '''
{
  "store": {
    "id": 1,
    "code": "default",
    "name": "TaxLien.online",
    "website_id": 1,
    "store_group_id": 1,
    "is_active": true
  },
  "categories": [],
  "products": [],
  "customers": [],
  "orders": [],
  "cart": {
    "id": 1,
    "items": [],
    "is_active": false
  }
}
''';

  static Map<String, dynamic> get demoData => json.decode(_demoDataJson);

  /// Get demo products (DEPRECATED - returns empty list)
  /// Use OfflineDataLoaderService.getProducts() instead
  static List<Map<String, dynamic>> get demoProducts {
    print(_deprecationMessage);
    return [];
  }

  /// Get demo categories (DEPRECATED - returns empty list)
  /// Use OfflineDataLoaderService.getCategories() instead
  static List<Map<String, dynamic>> get demoCategories {
    print(_deprecationMessage);
    return [];
  }

  /// Get demo customers (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> get demoCustomers {
    print(_deprecationMessage);
    return [];
  }

  /// Get demo orders (DEPRECATED - returns empty list)
  static List<Map<String, dynamic>> get demoOrders {
    print(_deprecationMessage);
    return [];
  }

  /// Get demo cart (DEPRECATED - returns minimal cart)
  static Map<String, dynamic> get demoCart {
    print(_deprecationMessage);
    return Map<String, dynamic>.from(demoData['cart']);
  }

  /// Get demo store configuration
  static Map<String, dynamic> get demoStore {
    return Map<String, dynamic>.from(demoData['store']);
  }

  // All filter methods now deprecated - use OfflineDataLoaderService

  static List<Map<String, dynamic>> getTaxLienProductsByCounty(String county) {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(county: "$county")',
    );
    return [];
  }

  static List<Map<String, dynamic>> getTaxLienProductsByState(String state) {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(state: "$state")',
    );
    return [];
  }

  static List<Map<String, dynamic>> getAvailableTaxLiens() {
    print(_deprecationMessage);
    return [];
  }

  static List<Map<String, dynamic>> getSoldTaxLiens() {
    print(_deprecationMessage);
    return [];
  }

  static List<Map<String, dynamic>> getTaxLiensByPriceRange(
    double minPrice,
    double maxPrice,
  ) {
    print(_deprecationMessage);
    return [];
  }

  static List<Map<String, dynamic>> getTaxLiensByInterestRateRange(
    double minRate,
    double maxRate,
  ) {
    print(_deprecationMessage);
    return [];
  }

  static List<Map<String, dynamic>> getTaxLiensByAssessedValueRange(
    double minValue,
    double maxValue,
  ) {
    print(_deprecationMessage);
    return [];
  }

  static List<Map<String, dynamic>> getTaxLiensFrom2024Collection() {
    print(_deprecationMessage);
    return [];
  }

  static List<Map<String, dynamic>> getTaxLiensByCollectionYear(String year) {
    print(_deprecationMessage);
    return [];
  }

  static List<Map<String, dynamic>> getPolkCountyTaxLiens() {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(state: "FL", county: "Polk")',
    );
    return [];
  }

  static List<Map<String, dynamic>> getDixieCountyTaxLiens() {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(state: "FL", county: "Dixie")',
    );
    return [];
  }

  static List<Map<String, dynamic>> getPutnamCountyTaxLiens() {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(state: "FL", county: "Putnam")',
    );
    return [];
  }

  static List<Map<String, dynamic>> getFlorida2024TaxLiens() {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(state: "FL")',
    );
    return [];
  }

  static List<Map<String, dynamic>> getTaxLiensByCountyCode(String countyCode) {
    print(
      '$_deprecationMessage\nUse: OfflineDataLoaderService.getProducts(county: "$countyCode")',
    );
    return [];
  }
}
