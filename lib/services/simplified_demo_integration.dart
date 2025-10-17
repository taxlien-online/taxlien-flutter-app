import 'package:flutter/foundation.dart';
import 'offline_data_loader_service.dart';

/// Simplified demo data integration service
/// NOW USES .rada FILES via OfflineDataLoaderService
///
/// This service provides a backward-compatible interface while using OfflineDataLoaderService
/// to load data from .rada files instead of hardcoded demo data
class SimplifiedDemoIntegration extends ChangeNotifier {
  final OfflineDataLoaderService _offlineLoader = OfflineDataLoaderService();
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;
  bool _useDemoData = true;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get useDemoData => _useDemoData;

  /// Initialize the demo integration service (now loads from .rada files)
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Initialize offline loader with .rada files
      final success = await _offlineLoader.initialize();

      if (success) {
        _isInitialized = true;
        _error = null;

        if (kDebugMode) {
          print(
            'SimplifiedDemoIntegration initialized successfully from .rada files',
          );
        }
      } else {
        throw Exception('Failed to load .rada files');
      }
    } catch (e) {
      _error = 'Failed to initialize demo integration: $e';
      if (kDebugMode) {
        print('Demo integration initialization error: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Get products from .rada files
  Future<List<Map<String, dynamic>>> getProducts({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
    Map<String, dynamic>? filters,
    double? minPrice,
    double? maxPrice,
  }) async {
    if (!_isInitialized) return [];

    var products = await _offlineLoader.getProducts();

    // Apply search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      products = _searchProducts(products, searchQuery);
    }

    // Apply category filter
    if (categoryId != null) {
      products = _filterByCategory(products, categoryId);
    }

    // Apply price filters
    if (minPrice != null || maxPrice != null) {
      products = _filterByPrice(products, minPrice, maxPrice);
    }

    // Apply custom filters
    if (filters != null) {
      products = _applyFilters(products, filters);
    }

    // Apply sorting
    if (sortBy != null) {
      products = _applySorting(products, sortBy, sortOrder);
    }

    // Apply pagination
    return _applyPagination(products, page, pageSize);
  }

  /// Get categories from .rada files
  Future<List<Map<String, dynamic>>> getCategories({
    int? parentId,
    int? level,
    String? searchQuery,
  }) async {
    if (!_isInitialized) return [];

    var categories = await _offlineLoader.getCategories();

    if (parentId != null) {
      categories =
          categories.where((cat) => cat['parent_id'] == parentId).toList();
    }

    if (level != null) {
      categories = categories.where((cat) => cat['level'] == level).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      categories = categories.where((cat) {
        final name = cat['name']?.toString().toLowerCase() ?? '';
        return name.contains(searchQuery.toLowerCase());
      }).toList();
    }

    return categories;
  }

  /// Get customers (not available in .rada files)
  List<Map<String, dynamic>> getCustomers({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
  }) {
    if (kDebugMode) {
      print('Customer data not available in .rada files');
    }
    return [];
  }

  /// Get orders (not available in .rada files)
  List<Map<String, dynamic>> getOrders({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) {
    if (kDebugMode) {
      print('Order data not available in .rada files');
    }
    return [];
  }

  /// Get cart (minimal cart structure)
  Map<String, dynamic>? getCart({String? cartId}) {
    if (!_isInitialized) return null;
    return {
      'id': cartId ?? '1',
      'items': [],
      'is_active': false,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  /// Get product by SKU
  Future<Map<String, dynamic>?> getProductBySku(String sku) async {
    if (!_isInitialized) return null;

    final products = await _offlineLoader.getProducts();
    try {
      return products.firstWhere((product) => product['sku'] == sku);
    } catch (e) {
      return null;
    }
  }

  /// Get category by ID
  Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
    if (!_isInitialized) return null;

    final categories = await _offlineLoader.getCategories();
    try {
      return categories.firstWhere((category) => category['id'] == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get customer by ID (not available in .rada files)
  Map<String, dynamic>? getCustomerById(int customerId) {
    if (kDebugMode) {
      print('Customer data not available in .rada files');
    }
    return null;
  }

  /// Get order by ID (not available in .rada files)
  Map<String, dynamic>? getOrderById(int orderId) {
    if (kDebugMode) {
      print('Order data not available in .rada files');
    }
    return null;
  }

  /// Search products
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    if (!_isInitialized) return [];
    final products = await _offlineLoader.getProducts();
    return _searchProducts(products, query);
  }

  /// Get tax lien specific data
  Future<List<Map<String, dynamic>>> getTaxLiensByState(String state) async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getProducts(state: state);
  }

  /// Get tax liens by county
  Future<List<Map<String, dynamic>>> getTaxLiensByCounty(String county) async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getProducts(county: county);
  }

  /// Get available tax liens
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

  /// Get counties by state
  Future<List<Map<String, dynamic>>> getCountiesByState(
    String stateCode,
  ) async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getCountiesForState(stateCode);
  }

  /// Get county by name and state
  Future<Map<String, dynamic>?> getCountyByName(
    String stateCode,
    String countyName,
  ) async {
    if (!_isInitialized) return null;
    return await _offlineLoader.getCountyByName(stateCode, countyName);
  }

  /// Get county by code and state
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

  /// Get all US states with tax lien programs
  Future<List<String>> getStatesWithTaxLiens() async {
    if (!_isInitialized) return [];
    return await _offlineLoader.getAvailableStates();
  }

  /// Get state name by code
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

  /// Get largest counties by population
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

  /// Get smallest counties by population
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

  /// Get counties by population range
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

  /// Get counties by area range
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

  /// Get total population for a state
  Future<int> getTotalPopulationForState(String stateCode) async {
    if (!_isInitialized) return 0;
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    return counties.fold<int>(
      0,
      (sum, county) => sum + (county['population'] as int? ?? 0),
    );
  }

  /// Get total area for a state
  Future<double> getTotalAreaForState(String stateCode) async {
    if (!_isInitialized) return 0.0;
    final counties = await _offlineLoader.getCountiesForState(stateCode);

    return counties.fold<double>(
      0.0,
      (sum, county) => sum + ((county['area'] as num?)?.toDouble() ?? 0.0),
    );
  }

  /// Get average population density for a state
  Future<double> getAveragePopulationDensityForState(String stateCode) async {
    if (!_isInitialized) return 0.0;
    final totalPopulation = await getTotalPopulationForState(stateCode);
    final totalArea = await getTotalAreaForState(stateCode);

    return totalArea > 0 ? totalPopulation / totalArea : 0.0;
  }

  /// Toggle between demo and real data
  void toggleDemoMode(bool useDemoData) {
    _useDemoData = useDemoData;
    notifyListeners();

    if (kDebugMode) {
      print('Demo mode toggled: $_useDemoData');
    }
  }

  /// Private helper methods

  List<Map<String, dynamic>> _searchProducts(
    List<Map<String, dynamic>> products,
    String query,
  ) {
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

  String _getProductDescription(Map<String, dynamic> product) {
    final attributes = product['custom_attributes'] as List<dynamic>?;
    if (attributes == null) return '';

    final descriptionAttr = attributes.firstWhere(
      (attr) => attr['attribute_code'] == 'description',
      orElse: () => null,
    );

    return descriptionAttr?['value']?.toString() ?? '';
  }

  List<Map<String, dynamic>> _filterByCategory(
    List<Map<String, dynamic>> products,
    String categoryId,
  ) {
    return products.where((product) {
      final categoryIds = product['category_ids'] as List<dynamic>?;
      return categoryIds?.contains(int.parse(categoryId)) ?? false;
    }).toList();
  }

  List<Map<String, dynamic>> _filterByPrice(
    List<Map<String, dynamic>> products,
    double? minPrice,
    double? maxPrice,
  ) {
    return products.where((product) {
      final price = (product['price'] as num?)?.toDouble() ?? 0.0;
      if (minPrice != null && price < minPrice) return false;
      if (maxPrice != null && price > maxPrice) return false;
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _applyFilters(
    List<Map<String, dynamic>> products,
    Map<String, dynamic> filters,
  ) {
    return products.where((product) {
      for (final entry in filters.entries) {
        final key = entry.key;
        final value = entry.value;

        // Check custom attributes
        final attributes = product['custom_attributes'] as List<dynamic>?;
        if (attributes != null) {
          final attr = attributes.firstWhere(
            (attr) => attr['attribute_code'] == key,
            orElse: () => null,
          );

          if (attr != null && attr['value'] != value) {
            return false;
          }
        }

        // Check direct product properties
        if (product.containsKey(key) && product[key] != value) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _applySorting(
    List<Map<String, dynamic>> products,
    String sortBy,
    String? sortOrder,
  ) {
    final ascending = sortOrder != 'desc';

    products.sort((a, b) {
      dynamic aValue = a[sortBy];
      dynamic bValue = b[sortBy];

      // Handle custom attributes
      if (aValue == null || bValue == null) {
        final attributesA = a['custom_attributes'] as List<dynamic>?;
        final attributesB = b['custom_attributes'] as List<dynamic>?;

        if (attributesA != null) {
          final attrA = attributesA.firstWhere(
            (attr) => attr['attribute_code'] == sortBy,
            orElse: () => null,
          );
          aValue = attrA?['value'];
        }

        if (attributesB != null) {
          final attrB = attributesB.firstWhere(
            (attr) => attr['attribute_code'] == sortBy,
            orElse: () => null,
          );
          bValue = attrB?['value'];
        }
      }

      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return ascending ? 1 : -1;
      if (bValue == null) return ascending ? -1 : 1;

      final comparison = aValue.toString().compareTo(bValue.toString());
      return ascending ? comparison : -comparison;
    });

    return products;
  }

  List<Map<String, dynamic>> _applyPagination(
    List<Map<String, dynamic>> items,
    int page,
    int pageSize,
  ) {
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= items.length) return [];

    return items.sublist(
      startIndex,
      endIndex > items.length ? items.length : endIndex,
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
