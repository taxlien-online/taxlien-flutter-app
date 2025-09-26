import 'package:flutter/foundation.dart';
import '../data/demo_data.dart';
import '../data/categories_demo_data.dart';
import '../data/counties_demo_data.dart';

/// Service for managing demo data integration with flutter_magento
class DemoDataService extends ChangeNotifier {
  static const bool _enableDemoMode = true; // Set to false for production

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  // Demo data instances
  late TaxLienDemoData _demoData;
  late TaxLienCategoriesDemoData _categoriesData;
  late TaxLienCountiesDemoData _countiesData;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isDemoModeEnabled => _enableDemoMode;

  /// Initialize demo data service
  Future<void> initialize() async {
    if (!_enableDemoMode) {
      _error = 'Demo mode is disabled';
      return;
    }

    _setLoading(true);
    try {
      _demoData = TaxLienDemoData();
      _categoriesData = TaxLienCategoriesDemoData();
      _countiesData = TaxLienCountiesDemoData();

      _isInitialized = true;
      _error = null;

      if (kDebugMode) {
        print('DemoDataService initialized successfully');
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

  /// Get demo products
  List<Map<String, dynamic>> getDemoProducts() {
    if (!_isInitialized) return [];
    return TaxLienDemoData.demoProducts;
  }

  /// Get demo categories
  List<Map<String, dynamic>> getDemoCategories() {
    if (!_isInitialized) return [];
    return TaxLienCategoriesDemoData.allCategories;
  }

  /// Get demo customers
  List<Map<String, dynamic>> getDemoCustomers() {
    if (!_isInitialized) return [];
    return TaxLienDemoData.demoCustomers;
  }

  /// Get demo orders
  List<Map<String, dynamic>> getDemoOrders() {
    if (!_isInitialized) return [];
    return TaxLienDemoData.demoOrders;
  }

  /// Get demo cart
  Map<String, dynamic> getDemoCart() {
    if (!_isInitialized) return {};
    return TaxLienDemoData.demoCart;
  }

  /// Get demo store configuration
  Map<String, dynamic> getDemoStore() {
    if (!_isInitialized) return {};
    return TaxLienDemoData.demoStore;
  }

  /// Get tax lien products by county
  List<Map<String, dynamic>> getTaxLienProductsByCounty(String county) {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getTaxLienProductsByCounty(county);
  }

  /// Get tax lien products by state
  List<Map<String, dynamic>> getTaxLienProductsByState(String state) {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getTaxLienProductsByState(state);
  }

  /// Get available tax liens
  List<Map<String, dynamic>> getAvailableTaxLiens() {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getAvailableTaxLiens();
  }

  /// Get sold tax liens
  List<Map<String, dynamic>> getSoldTaxLiens() {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getSoldTaxLiens();
  }

  /// Get tax liens by price range
  List<Map<String, dynamic>> getTaxLiensByPriceRange(
      double minPrice, double maxPrice) {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getTaxLiensByPriceRange(minPrice, maxPrice);
  }

  /// Get tax liens by interest rate range
  List<Map<String, dynamic>> getTaxLiensByInterestRateRange(
      double minRate, double maxRate) {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getTaxLiensByInterestRateRange(minRate, maxRate);
  }

  /// Get tax liens by assessed value range
  List<Map<String, dynamic>> getTaxLiensByAssessedValueRange(
      double minValue, double maxValue) {
    if (!_isInitialized) return [];
    return TaxLienDemoData.getTaxLiensByAssessedValueRange(minValue, maxValue);
  }

  /// Get categories by state code
  List<Map<String, dynamic>> getCategoriesByStateCode(String stateCode) {
    if (!_isInitialized) return [];
    return TaxLienCategoriesDemoData.getCategoriesByStateCode(stateCode);
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

  /// Search products by query
  List<Map<String, dynamic>> searchProducts(String query) {
    if (!_isInitialized) return [];

    final products = getDemoProducts();
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

  /// Get products by category
  List<Map<String, dynamic>> getProductsByCategory(int categoryId) {
    if (!_isInitialized) return [];

    final products = getDemoProducts();
    return products.where((product) {
      // In a real implementation, this would check product categories
      // For demo purposes, we'll simulate category filtering
      return true; // Return all products for demo
    }).toList();
  }

  /// Get featured products
  List<Map<String, dynamic>> getFeaturedProducts({int limit = 10}) {
    if (!_isInitialized) return [];

    final products = getDemoProducts();
    return products.take(limit).toList();
  }

  /// Get recent products
  List<Map<String, dynamic>> getRecentProducts({int limit = 10}) {
    if (!_isInitialized) return [];

    final products = getDemoProducts();
    // Sort by creation date (newest first)
    products.sort((a, b) {
      final dateA = DateTime.tryParse(a['created_at']?.toString() ?? '') ??
          DateTime(1970);
      final dateB = DateTime.tryParse(b['created_at']?.toString() ?? '') ??
          DateTime(1970);
      return dateB.compareTo(dateA);
    });

    return products.take(limit).toList();
  }

  /// Get related products
  List<Map<String, dynamic>> getRelatedProducts(String productSku,
      {int limit = 5}) {
    if (!_isInitialized) return [];

    final products = getDemoProducts();
    // Filter out the current product and return others
    return products
        .where((product) => product['sku'] != productSku)
        .take(limit)
        .toList();
  }

  /// Get product reviews (demo data)
  List<Map<String, dynamic>> getProductReviews(String productSku) {
    if (!_isInitialized) return [];

    // Demo review data
    return [
      {
        'id': 1,
        'product_sku': productSku,
        'customer_name': 'John Investor',
        'rating': 5,
        'title': 'Excellent Investment',
        'detail': 'Great return on investment. Property is in a good location.',
        'created_at': '2024-01-15 10:00:00',
        'status': 'approved'
      },
      {
        'id': 2,
        'product_sku': productSku,
        'customer_name': 'Sarah Trader',
        'rating': 4,
        'title': 'Good Value',
        'detail': 'Solid investment opportunity with reasonable interest rate.',
        'created_at': '2024-01-10 14:30:00',
        'status': 'approved'
      }
    ];
  }

  /// Get customer orders
  List<Map<String, dynamic>> getCustomerOrders(int customerId) {
    if (!_isInitialized) return [];

    final orders = getDemoOrders();
    return orders.where((order) => order['customer_id'] == customerId).toList();
  }

  /// Get order by ID
  Map<String, dynamic>? getOrderById(int orderId) {
    if (!_isInitialized) return null;

    final orders = getDemoOrders();
    try {
      return orders.firstWhere((order) => order['entity_id'] == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Get customer by ID
  Map<String, dynamic>? getCustomerById(int customerId) {
    if (!_isInitialized) return null;

    final customers = getDemoCustomers();
    try {
      return customers.firstWhere((customer) => customer['id'] == customerId);
    } catch (e) {
      return null;
    }
  }

  /// Get customer by email
  Map<String, dynamic>? getCustomerByEmail(String email) {
    if (!_isInitialized) return null;

    final customers = getDemoCustomers();
    try {
      return customers.firstWhere((customer) => customer['email'] == email);
    } catch (e) {
      return null;
    }
  }

  /// Validate demo data integrity
  bool validateDemoData() {
    if (!_isInitialized) return false;

    try {
      // Check if we have products
      final products = getDemoProducts();
      if (products.isEmpty) return false;

      // Check if we have categories
      final categories = getDemoCategories();
      if (categories.isEmpty) return false;

      // Check if we have customers
      final customers = getDemoCustomers();
      if (customers.isEmpty) return false;

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Demo data validation error: $e');
      }
      return false;
    }
  }

  /// Reset demo data
  Future<void> resetDemoData() async {
    _setLoading(true);
    try {
      await initialize();
      if (kDebugMode) {
        print('Demo data reset successfully');
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
