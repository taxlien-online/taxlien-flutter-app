import 'package:flutter/foundation.dart';
import 'package:flutter_magento/flutter_magento.dart';
import 'demo_data_service.dart';

/// Integration service for flutter_magento with demo data
/// Provides seamless integration between flutter_magento and demo data
class FlutterMagentoDemoIntegration extends ChangeNotifier {
  late FlutterMagento _magento;
  late DemoDataService _demoDataService;

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;
  bool _useDemoData = true; // Toggle between demo and real data

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get useDemoData => _useDemoData;
  FlutterMagento get magento => _magento;

  /// Initialize the integration service
  Future<void> initialize({
    required String baseUrl,
    List<String>? supportedLanguages,
    int? connectionTimeout,
    int? receiveTimeout,
    Map<String, String>? headers,
    bool useDemoData = true,
  }) async {
    _setLoading(true);
    _useDemoData = useDemoData;

    try {
      // Initialize Flutter Magento
      _magento = FlutterMagento();

      // Initialize demo data service
      _demoDataService = DemoDataService();
      await _demoDataService.initialize();

      _isInitialized = true;
      _error = null;

      if (kDebugMode) {
        print('FlutterMagentoDemoIntegration initialized successfully');
        print('Using demo data: $_useDemoData');
      }
    } catch (e) {
      _error = 'Failed to initialize FlutterMagentoDemoIntegration: $e';
      if (kDebugMode) {
        print('FlutterMagentoDemoIntegration initialization error: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Get products with demo data integration
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

    if (_useDemoData) {
      return await _getDemoProducts(
        page: page,
        pageSize: pageSize,
        searchQuery: searchQuery,
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
        filters: filters,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get categories with demo data integration
  Future<List<Map<String, dynamic>>> getCategories({
    int? parentId,
    int? level,
    String? searchQuery,
  }) async {
    if (!_isInitialized) return [];

    if (_useDemoData) {
      return await _getDemoCategories(
        parentId: parentId,
        level: level,
        searchQuery: searchQuery,
      );
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get customers with demo data integration
  Future<List<Map<String, dynamic>>> getCustomers({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
  }) async {
    if (!_isInitialized) return [];

    if (_useDemoData) {
      return _getDemoCustomers(
        page: page,
        pageSize: pageSize,
        searchQuery: searchQuery,
      );
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get orders with demo data integration
  Future<List<Map<String, dynamic>>> getOrders({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    if (!_isInitialized) return [];

    if (_useDemoData) {
      return _getDemoOrders(
        page: page,
        pageSize: pageSize,
        status: status,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get cart with demo data integration
  Future<Map<String, dynamic>?> getCart({String? cartId}) async {
    if (!_isInitialized) return null;

    if (_useDemoData) {
      return _getDemoCart(cartId: cartId);
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Add product to cart with demo data integration
  Future<Map<String, dynamic>?> addToCart({
    required String cartId,
    required String sku,
    required int qty,
    Map<String, dynamic>? productOptions,
  }) async {
    if (!_isInitialized) return null;

    if (_useDemoData) {
      return _addToDemoCart(
        cartId: cartId,
        sku: sku,
        qty: qty,
        productOptions: productOptions,
      );
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get product by SKU with demo data integration
  Future<Map<String, dynamic>?> getProductBySku(String sku) async {
    if (!_isInitialized) return null;

    if (_useDemoData) {
      return await _getDemoProductBySku(sku);
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get category by ID with demo data integration
  Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
    if (!_isInitialized) return null;

    if (_useDemoData) {
      return await _getDemoCategoryById(categoryId);
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get customer by ID with demo data integration
  Future<Map<String, dynamic>?> getCustomerById(int customerId) async {
    if (!_isInitialized) return null;

    if (_useDemoData) {
      return _getDemoCustomerById(customerId);
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get order by ID with demo data integration
  Future<Map<String, dynamic>?> getOrderById(int orderId) async {
    if (!_isInitialized) return null;

    if (_useDemoData) {
      return _getDemoOrderById(orderId);
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Search products with demo data integration
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    if (!_isInitialized) return [];

    if (_useDemoData) {
      return await _demoDataService.searchProducts(query);
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get tax lien specific data
  Future<List<Map<String, dynamic>>> getTaxLiensByState(String state) async {
    if (!_isInitialized) return [];

    if (_useDemoData) {
      return await _demoDataService.getTaxLienProductsByState(state);
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get tax liens by county
  Future<List<Map<String, dynamic>>> getTaxLiensByCounty(String county) async {
    if (!_isInitialized) return [];

    if (_useDemoData) {
      return await _demoDataService.getTaxLienProductsByCounty(county);
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get available tax liens
  Future<List<Map<String, dynamic>>> getAvailableTaxLiens() async {
    if (!_isInitialized) return [];

    if (_useDemoData) {
      return await _demoDataService.getAvailableTaxLiens();
    } else {
      // Real Magento data - requires proper Magento API configuration
      throw UnimplementedError(
        'Real Magento data access not implemented. Please configure Magento API properly or use demo mode.',
      );
    }
  }

  /// Get counties by state
  Future<List<Map<String, dynamic>>> getCountiesByState(
      String stateCode) async {
    if (!_isInitialized) return [];

    if (_useDemoData) {
      return await _demoDataService.getCountiesByState(stateCode);
    } else {
      // In real implementation, this would query a counties API or database
      return [];
    }
  }

  /// Toggle between demo and real data
  void toggleDemoMode(bool useDemoData) {
    _useDemoData = useDemoData;
    notifyListeners();

    if (kDebugMode) {
      print('Demo mode toggled: $_useDemoData');
    }
  }

  /// Private methods for demo data handling

  Future<List<Map<String, dynamic>>> _getDemoProducts({
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
    var products = await _demoDataService.getDemoProducts();

    // Apply search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      products = await _demoDataService.searchProducts(searchQuery);
    }

    // Apply category filter
    if (categoryId != null) {
      products =
          await _demoDataService.getProductsByCategory(int.parse(categoryId));
    }

    // Apply price filters
    if (minPrice != null || maxPrice != null) {
      products = await _demoDataService.getTaxLiensByPriceRange(
        minPrice ?? 0.0,
        maxPrice ?? double.infinity,
      );
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
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= products.length) return [];

    return products.sublist(
      startIndex,
      endIndex > products.length ? products.length : endIndex,
    );
  }

  Future<List<Map<String, dynamic>>> _getDemoCategories({
    int? parentId,
    int? level,
    String? searchQuery,
  }) async {
    var categories = await _demoDataService.getDemoCategories();

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

  List<Map<String, dynamic>> _getDemoCustomers({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
  }) {
    var customers = _demoDataService.getDemoCustomers();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      customers = customers.where((customer) {
        final name =
            '${customer['firstname']} ${customer['lastname']}'.toLowerCase();
        final email = customer['email']?.toString().toLowerCase() ?? '';
        return name.contains(searchQuery.toLowerCase()) ||
            email.contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= customers.length) return [];

    return customers.sublist(
      startIndex,
      endIndex > customers.length ? customers.length : endIndex,
    );
  }

  List<Map<String, dynamic>> _getDemoOrders({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) {
    var orders = _demoDataService.getDemoOrders();

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

    // Apply pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= orders.length) return [];

    return orders.sublist(
      startIndex,
      endIndex > orders.length ? orders.length : endIndex,
    );
  }

  Map<String, dynamic>? _getDemoCart({String? cartId}) {
    return _demoDataService.getDemoCart();
  }

  Map<String, dynamic>? _addToDemoCart({
    required String cartId,
    required String sku,
    required int qty,
    Map<String, dynamic>? productOptions,
  }) {
    // In a real implementation, this would update the cart
    // For demo purposes, we'll return a success response
    return {
      'item_id': DateTime.now().millisecondsSinceEpoch,
      'sku': sku,
      'qty': qty,
      'name': 'Demo Product',
      'price': 100.0,
      'product_type': 'tax_lien',
      'quote_id': cartId,
    };
  }

  Future<Map<String, dynamic>?> _getDemoProductBySku(String sku) async {
    final products = await _demoDataService.getDemoProducts();
    try {
      return products.firstWhere((product) => product['sku'] == sku);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getDemoCategoryById(int categoryId) async {
    final categories = await _demoDataService.getDemoCategories();
    try {
      return categories.firstWhere((category) => category['id'] == categoryId);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? _getDemoCustomerById(int customerId) {
    return _demoDataService.getCustomerById(customerId);
  }

  Map<String, dynamic>? _getDemoOrderById(int orderId) {
    return _demoDataService.getOrderById(orderId);
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

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
