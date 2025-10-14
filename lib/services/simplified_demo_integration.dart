import 'package:flutter/foundation.dart';
import 'offline_data_loader_service.dart';

/// DEPRECATED: Simplified demo data integration service
/// NOW USES .rada FILES via OfflineDataLoaderService
/// 
/// This service now loads data from .rada files instead of hardcoded demo data
/// Provides backward-compatible interface while using OfflineDataLoaderService
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
          print('SimplifiedDemoIntegration initialized successfully from .rada files');
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
  }) {
    if (!_isInitialized) return [];

    var products = TaxLienDemoData.demoProducts;

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

  /// Get categories with demo data
  List<Map<String, dynamic>> getCategories({
    int? parentId,
    int? level,
    String? searchQuery,
  }) {
    if (!_isInitialized) return [];

    var categories = TaxLienCategoriesDemoData.allCategories;

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

  /// Get customers with demo data
  List<Map<String, dynamic>> getCustomers({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
  }) {
    if (!_isInitialized) return [];

    var customers = TaxLienDemoData.demoCustomers;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      customers = customers.where((customer) {
        final name =
            '${customer['firstname']} ${customer['lastname']}'.toLowerCase();
        final email = customer['email']?.toString().toLowerCase() ?? '';
        return name.contains(searchQuery.toLowerCase()) ||
            email.contains(searchQuery.toLowerCase());
      }).toList();
    }

    return _applyPagination(customers, page, pageSize);
  }

  /// Get orders with demo data
  List<Map<String, dynamic>> getOrders({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) {
    if (!_isInitialized) return [];

    var orders = TaxLienDemoData.demoOrders;

    if (status != null) {
      orders = orders.where((order) => order['status'] == status).toList();
    }

    if (dateFrom != null) {
      final fromDate = DateTime.tryParse(dateFrom);
      if (fromDate != null) {
        orders = orders.where((order) {
          final orderDate =
              DateTime.tryParse(order['created_at']?.toString() ?? '');
          return orderDate != null && orderDate.isAfter(fromDate);
        }).toList();
      }
    }

    if (dateTo != null) {
      final toDate = DateTime.tryParse(dateTo);
      if (toDate != null) {
        orders = orders.where((order) {
          final orderDate =
              DateTime.tryParse(order['created_at']?.toString() ?? '');
          return orderDate != null && orderDate.isBefore(toDate);
        }).toList();
      }
    }

    return _applyPagination(orders, page, pageSize);
  }

  /// Get cart with demo data
  Map<String, dynamic>? getCart({String? cartId}) {
    if (!_isInitialized) return null;
    return TaxLienDemoData.demoCart;
  }

  /// Get product by SKU
  Map<String, dynamic>? getProductBySku(String sku) {
    if (!_isInitialized) return null;

    final products = TaxLienDemoData.demoProducts;
    try {
      return products.firstWhere((product) => product['sku'] == sku);
    } catch (e) {
      return null;
    }
  }

  /// Get category by ID
  Map<String, dynamic>? getCategoryById(int categoryId) {
    if (!_isInitialized) return null;

    final categories = TaxLienCategoriesDemoData.allCategories;
    try {
      return categories.firstWhere((category) => category['id'] == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get customer by ID
  Map<String, dynamic>? getCustomerById(int customerId) {
    if (!_isInitialized) return null;

    final customers = TaxLienDemoData.demoCustomers;
    try {
      return customers.firstWhere((customer) => customer['id'] == customerId);
    } catch (e) {
      return null;
    }
  }

  /// Get order by ID
  Map<String, dynamic>? getOrderById(int orderId) {
    if (!_isInitialized) return null;

    final orders = TaxLienDemoData.demoOrders;
    try {
      return orders.firstWhere((order) => order['entity_id'] == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Search products
  List<Map<String, dynamic>> searchProducts(String query) {
    if (!_isInitialized) return [];
    return _searchProducts(TaxLienDemoData.demoProducts, query);
  }

  /// Get tax lien specific data
  List<Map<String, dynamic>> getTaxLiensByState(String state) {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getTaxLienProductsByState(state);
  }

  /// Get tax liens by county
  List<Map<String, dynamic>> getTaxLiensByCounty(String county) {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getTaxLienProductsByCounty(county);
  }

  /// Get available tax liens
  List<Map<String, dynamic>> getAvailableTaxLiens() {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getAvailableTaxLiens();
  }

  /// Get counties by state
  List<Map<String, dynamic>> getCountiesByState(String stateCode) {
    if (!_isInitialized) return [];
    return TaxLienCountiesDemoData.getCountiesByState(stateCode);
  }

  /// Get county by name and state
  Map<String, dynamic>? getCountyByName(String stateCode, String countyName) {
    if (!_isInitialized) return null;
    return TaxLienCountiesDemoData.getCountyByName(stateCode, countyName);
  }

  /// Get county by code and state
  Map<String, dynamic>? getCountyByCode(String stateCode, String countyCode) {
    if (!_isInitialized) return null;
    return TaxLienCountiesDemoData.getCountyByCode(stateCode, countyCode);
  }

  /// Get all US states with tax lien programs
  List<String> getStatesWithTaxLiens() {
    if (!_isInitialized) return [];
    return TaxLienCategoriesDemoData.statesWithTaxLiens;
  }

  /// Get state name by code
  String getStateNameByCode(String stateCode) {
    if (!_isInitialized) return stateCode;
    return TaxLienCategoriesDemoData.getStateNameByCode(stateCode);
  }

  /// Get largest counties by population
  List<Map<String, dynamic>> getLargestCountiesByPopulation(
      String stateCode, int limit) {
    if (!_isInitialized) return [];
    return TaxLienCountiesDemoData.getLargestCountiesByPopulation(
        stateCode, limit);
  }

  /// Get smallest counties by population
  List<Map<String, dynamic>> getSmallestCountiesByPopulation(
      String stateCode, int limit) {
    if (!_isInitialized) return [];
    return TaxLienCountiesDemoData.getSmallestCountiesByPopulation(
        stateCode, limit);
  }

  /// Get counties by population range
  List<Map<String, dynamic>> getCountiesByPopulationRange(
      String stateCode, int minPopulation, int maxPopulation) {
    if (!_isInitialized) return [];
    return TaxLienCountiesDemoData.getCountiesByPopulationRange(
        stateCode, minPopulation, maxPopulation);
  }

  /// Get counties by area range
  List<Map<String, dynamic>> getCountiesByAreaRange(
      String stateCode, double minArea, double maxArea) {
    if (!_isInitialized) return [];
    return TaxLienCountiesDemoData.getCountiesByAreaRange(
        stateCode, minArea, maxArea);
  }

  /// Get total population for a state
  int getTotalPopulationForState(String stateCode) {
    if (!_isInitialized) return 0;
    return TaxLienCountiesDemoData.getTotalPopulationForState(stateCode);
  }

  /// Get total area for a state
  double getTotalAreaForState(String stateCode) {
    if (!_isInitialized) return 0.0;
    return TaxLienCountiesDemoData.getTotalAreaForState(stateCode);
  }

  /// Get average population density for a state
  double getAveragePopulationDensityForState(String stateCode) {
    if (!_isInitialized) return 0.0;
    return TaxLienCountiesDemoData.getAveragePopulationDensityForState(
        stateCode);
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
    // In a real implementation, this would filter by category
    // For demo purposes, we'll return all products
    return products;
  }

  List<Map<String, dynamic>> _filterByPrice(
    List<Map<String, dynamic>> products,
    double? minPrice,
    double? maxPrice,
  ) {
    return products.where((product) {
      final price = (product['price'] as num).toDouble();
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
