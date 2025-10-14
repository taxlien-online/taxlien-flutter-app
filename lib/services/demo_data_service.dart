import 'package:flutter/foundation.dart';
import 'offline_data_loader_service.dart';

/// Service for managing data integration - now uses .rada files via OfflineDataLoaderService
/// Provides backward-compatible interface while loading data from .rada files
class DemoDataService extends ChangeNotifier {
  static const bool _enableDemoMode = true; // Set to false for production

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  // Offline data loader instance
  final OfflineDataLoaderService _offlineLoader = OfflineDataLoaderService();

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isDemoModeEnabled => _enableDemoMode;

  /// Initialize demo data service - now loads from .rada files
  Future<void> initialize() async {
    if (!_enableDemoMode) {
      _error = 'Demo mode is disabled';
      return;
    }

    _setLoading(true);
    try {
      // Initialize offline loader with .rada files
      final success = await _offlineLoader.initialize();

      if (success) {
        _isInitialized = true;
        _error = null;

        if (kDebugMode) {
          print('DemoDataService initialized successfully from .rada files');
        }
      } else {
        throw Exception('Failed to load .rada files');
      }
    } catch (e) {
      _error = 'Failed to initialize demo data service: $e';
      if (kDebugMode) {
        print('DemoDataService initialization error: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Get demo products (from .rada files)
  Future<List<Map<String, dynamic>>> getDemoProducts() async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getProducts();
  }

  /// Get demo categories (from .rada files)
  Future<List<Map<String, dynamic>>> getDemoCategories() async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getCategories();
  }

  /// Get demo customers (not available in .rada files)
  List<Map<String, dynamic>> getDemoCustomers() {
    if (kDebugMode) {
      print('Customer data not available in .rada files');
    }
    return [];
  }

  /// Get demo orders (not available in .rada files)
  List<Map<String, dynamic>> getDemoOrders() {
    if (kDebugMode) {
      print('Order data not available in .rada files');
    }
    return [];
  }

  /// Get demo cart (minimal cart structure)
  Map<String, dynamic> getDemoCart() {
    return {
      'id': 1,
      'items': [],
      'is_active': false,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  /// Get demo store configuration
  Map<String, dynamic> getDemoStore() {
    return {
      'id': 1,
      'code': 'default',
      'name': 'TaxLien.online',
      'website_id': 1,
      'store_group_id': 1,
      'is_active': true,
    };
  }

  /// Get tax lien products by county (from .rada files)
  Future<List<Map<String, dynamic>>> getTaxLienProductsByCounty(
    String county,
  ) async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getProducts(county: county);
  }

  /// Get tax lien products by state (from .rada files)
  Future<List<Map<String, dynamic>>> getTaxLienProductsByState(
    String state,
  ) async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getProducts(state: state);
  }

  /// Get available tax liens (from .rada files)
  Future<List<Map<String, dynamic>>> getAvailableTaxLiens() async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();

    // Filter by status if available in custom attributes
    return products.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return true;

      final statusAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'lien_status',
        orElse: () => null,
      );

      return statusAttr == null || statusAttr['value'] == 'available';
    }).toList();
  }

  /// Get sold tax liens (from .rada files)
  Future<List<Map<String, dynamic>>> getSoldTaxLiens() async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();

    return products.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final statusAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'lien_status',
        orElse: () => null,
      );

      return statusAttr != null && statusAttr['value'] == 'sold';
    }).toList();
  }

  /// Get tax liens by price range
  Future<List<Map<String, dynamic>>> getTaxLiensByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();

    return products.where((product) {
      final price = (product['price'] as num?)?.toDouble() ?? 0.0;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  /// Get tax liens by interest rate range
  Future<List<Map<String, dynamic>>> getTaxLiensByInterestRateRange(
    double minRate,
    double maxRate,
  ) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();

    return products.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final rateAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'interest_rate',
        orElse: () => null,
      );

      if (rateAttr == null) return false;
      final rate = double.tryParse(rateAttr['value'].toString()) ?? 0.0;
      return rate >= minRate && rate <= maxRate;
    }).toList();
  }

  /// Get tax liens by assessed value range
  Future<List<Map<String, dynamic>>> getTaxLiensByAssessedValueRange(
    double minValue,
    double maxValue,
  ) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();

    return products.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final valueAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'assessed_value',
        orElse: () => null,
      );

      if (valueAttr == null) return false;
      final value = double.tryParse(valueAttr['value'].toString()) ?? 0.0;
      return value >= minValue && value <= maxValue;
    }).toList();
  }

  /// Get categories by state code (from .rada files)
  Future<List<Map<String, dynamic>>> getCategoriesByStateCode(
    String stateCode,
  ) async {
    if (!_isInitialized) return [];
    final categories = await _offlineLoader.getCategories();

    return categories.where((category) {
      final attributes = category['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final stateAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'state_code',
        orElse: () => null,
      );

      return stateAttr != null && stateAttr['value'] == stateCode;
    }).toList();
  }

  /// Get counties by state (from .rada files)
  Future<List<Map<String, dynamic>>> getCountiesByState(
    String stateCode,
  ) async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getCountiesForState(stateCode);
  }

  /// Get county by name and state (from .rada files)
  Future<Map<String, dynamic>?> getCountyByName(
    String stateCode,
    String countyName,
  ) async {
    if (!_isInitialized) return null;
    return await _offlineLoader.getCountyByName(stateCode, countyName);
  }

  /// Get county by code and state (from .rada files)
  Future<Map<String, dynamic>?> getCountyByCode(
    String stateCode,
    String countyCode,
  ) async {
    if (!_isInitialized) return null;
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    try {
      return counties.firstWhere(
        (county) =>
            county['code']?.toString().toLowerCase() ==
            countyCode.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all US states with tax lien programs (from .rada files)
  Future<List<String>> getStatesWithTaxLiens() async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getAvailableStates();
  }

  /// Get state name by code (utility method)
  String getStateNameByCode(String stateCode) {
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
      'WY': 'Wyoming',
    };
    return stateNames[stateCode] ?? stateCode;
  }

  /// Get largest counties by population (from .rada files)
  Future<List<Map<String, dynamic>>> getLargestCountiesByPopulation(
    String stateCode,
    int limit,
  ) async {
    if (!_isInitialized) return [];
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    counties.sort(
      (a, b) => (b['population'] as int? ?? 0).compareTo(
        a['population'] as int? ?? 0,
      ),
    );

    return counties.take(limit).toList();
  }

  /// Get smallest counties by population (from .rada files)
  Future<List<Map<String, dynamic>>> getSmallestCountiesByPopulation(
    String stateCode,
    int limit,
  ) async {
    if (!_isInitialized) return [];
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    counties.sort(
      (a, b) => (a['population'] as int? ?? 0).compareTo(
        b['population'] as int? ?? 0,
      ),
    );

    return counties.take(limit).toList();
  }

  /// Get counties by population range (from .rada files)
  Future<List<Map<String, dynamic>>> getCountiesByPopulationRange(
    String stateCode,
    int minPopulation,
    int maxPopulation,
  ) async {
    if (!_isInitialized) return [];
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    return counties.where((county) {
      final population = county['population'] as int? ?? 0;
      return population >= minPopulation && population <= maxPopulation;
    }).toList();
  }

  /// Get counties by area range (from .rada files)
  Future<List<Map<String, dynamic>>> getCountiesByAreaRange(
    String stateCode,
    double minArea,
    double maxArea,
  ) async {
    if (!_isInitialized) return [];
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    return counties.where((county) {
      final area = (county['area'] as num?)?.toDouble() ?? 0.0;
      return area >= minArea && area <= maxArea;
    }).toList();
  }

  /// Get total population for a state (from .rada files)
  Future<int> getTotalPopulationForState(String stateCode) async {
    if (!_isInitialized) return 0;
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    return counties.fold<int>(
      0,
      (sum, county) => sum + (county['population'] as int? ?? 0),
    );
  }

  /// Get total area for a state (from .rada files)
  Future<double> getTotalAreaForState(String stateCode) async {
    if (!_isInitialized) return 0.0;
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    return counties.fold<double>(
      0.0,
      (sum, county) => sum + ((county['area'] as num?)?.toDouble() ?? 0.0),
    );
  }

  /// Get average population density for a state (from .rada files)
  Future<double> getAveragePopulationDensityForState(String stateCode) async {
    if (!_isInitialized) return 0.0;
    final totalPopulation = await getTotalPopulationForState(stateCode);
    final totalArea = await getTotalAreaForState(stateCode);

    return totalArea > 0 ? totalPopulation / totalArea : 0.0;
  }

  /// Search products by query (from .rada files)
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();

    if (query.isEmpty) return products;

    final lowercaseQuery = query.toLowerCase();
    return products.where((product) {
      final name = product['name']?.toString().toLowerCase() ?? '';
      final sku = product['sku']?.toString().toLowerCase() ?? '';
      final description = _getProductDescription(product).toLowerCase();

      return name.contains(lowercaseQuery) ||
          sku.contains(lowercaseQuery) ||
          description.contains(lowercaseQuery);
    }).toList();
  }

  /// Get product description from custom attributes
  String _getProductDescription(Map<String, dynamic> product) {
    final attributes = product['custom_attributes'] as List<dynamic>?;
    if (attributes == null) return '';

    final descriptionAttr = attributes.firstWhere(
      (attr) => attr['attribute_code'] == 'description',
      orElse: () => null,
    );

    return descriptionAttr?['value']?.toString() ?? '';
  }

  /// Get products by category (from .rada files)
  Future<List<Map<String, dynamic>>> getProductsByCategory(
    int categoryId,
  ) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();

    // Filter by category_ids if available
    return products.where((product) {
      final categoryIds = product['category_ids'] as List<dynamic>?;
      return categoryIds?.contains(categoryId) ?? false;
    }).toList();
  }

  /// Get featured products (from .rada files)
  Future<List<Map<String, dynamic>>> getFeaturedProducts({
    int limit = 10,
  }) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts(limit: limit);
    return products;
  }

  /// Get recent products (from .rada files)
  Future<List<Map<String, dynamic>>> getRecentProducts({int limit = 10}) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();

    products.sort((a, b) {
      final dateA =
          DateTime.tryParse(a['created_at']?.toString() ?? '') ??
          DateTime(1970);
      final dateB =
          DateTime.tryParse(b['created_at']?.toString() ?? '') ??
          DateTime(1970);
      return dateB.compareTo(dateA);
    });

    return products.take(limit).toList();
  }

  /// Get related products (from .rada files)
  Future<List<Map<String, dynamic>>> getRelatedProducts(
    String productSku, {
    int limit = 5,
  }) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts(limit: limit + 1);

    return products
        .where((product) => product['sku'] != productSku)
        .take(limit)
        .toList();
  }

  /// Get product reviews (demo data - not in .rada files)
  List<Map<String, dynamic>> getProductReviews(String productSku) {
    if (!_isInitialized) return [];

    // Demo review data
    return [
      {
        'id': 1,
        'product_sku': productSku,
        'customer_name': 'Investor',
        'rating': 5,
        'title': 'Excellent Investment',
        'detail': 'Great return on investment.',
        'created_at': DateTime.now().toIso8601String(),
        'status': 'approved',
      },
    ];
  }

  /// Get customer orders (not available in .rada files)
  List<Map<String, dynamic>> getCustomerOrders(int customerId) {
    if (kDebugMode) {
      print('Order data not available in .rada files');
    }
    return [];
  }

  /// Get order by ID (not available in .rada files)
  Map<String, dynamic>? getOrderById(int orderId) {
    if (kDebugMode) {
      print('Order data not available in .rada files');
    }
    return null;
  }

  /// Get customer by ID (not available in .rada files)
  Map<String, dynamic>? getCustomerById(int customerId) {
    if (kDebugMode) {
      print('Customer data not available in .rada files');
    }
    return null;
  }

  /// Get customer by email (not available in .rada files)
  Map<String, dynamic>? getCustomerByEmail(String email) {
    if (kDebugMode) {
      print('Customer data not available in .rada files');
    }
    return null;
  }

  /// Validate demo data integrity (from .rada files)
  Future<bool> validateDemoData() async {
    if (!_isInitialized) return false;

    try {
      final products = await _offlineLoader.getProducts();
      if (products.isEmpty) return false;

      final categories = await _offlineLoader.getCategories();
      if (categories.isEmpty) return false;

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Demo data validation error: $e');
      }
      return false;
    }
  }

  /// Reset demo data (reload from .rada files)
  Future<void> resetDemoData() async {
    _setLoading(true);
    try {
      await _offlineLoader.reload();
      await initialize();

      if (kDebugMode) {
        print('Demo data reset successfully from .rada files');
      }
    } catch (e) {
      _error = 'Failed to reset demo data: $e';
      if (kDebugMode) {
        print('Demo data reset error: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
