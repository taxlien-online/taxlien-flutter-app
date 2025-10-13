import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/magento_models.dart';
import 'magento_api_service.dart';
import 'secure_storage_service.dart';
import '../../services/flutter_magento_cloud_service.dart';
import '../../services/preload_service.dart';

/// Hybrid Magento service that combines REST API, Flutter Magento, and offline capabilities
/// Automatically switches between cloud and offline mode based on connectivity
class HybridMagentoService extends ChangeNotifier {
  final MagentoApiService _restService;
  FlutterMagentoCloudService? _flutterMagentoService;

  bool _isOnline = false;
  bool _preferFlutterMagento = true; // Приоритет для Flutter Magento
  bool _enableOfflineMode = AppConstants.enableOfflineMode;

  // Cache keys
  static const String _cacheKeyProducts = 'cached_products';
  static const String _cacheKeyCategories = 'cached_categories';
  static const String _cacheKeyCustomer = 'cached_customer';
  static const String _cacheKeyCart = 'cached_cart';

  // Getters
  bool get isOnline => _isOnline;
  bool get preferFlutterMagento => _preferFlutterMagento;
  bool get enableOfflineMode => _enableOfflineMode;
  bool get isAuthenticated => _isOnline
      ? (_preferFlutterMagento && _flutterMagentoService != null
          ? _flutterMagentoService!.isAuthenticated
          : _restService.isAuthenticated)
      : false;

  String get connectionStatus => _isOnline
      ? (_preferFlutterMagento && _flutterMagentoService != null
          ? 'Cloud (Flutter Magento)'
          : 'Cloud (REST)')
      : 'Offline Mode';

  HybridMagentoService({
    MagentoApiService? restService,
    FlutterMagentoCloudService? flutterMagentoService,
  })  : _restService = restService ?? MagentoApiService(),
        _flutterMagentoService = flutterMagentoService {
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkConnectivity();
    await _loadPreferences();
    await _initializeServices();

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOnline = connectivityResult != ConnectivityResult.none;
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _preferFlutterMagento = prefs.getBool('prefer_flutter_magento') ?? true;
    _enableOfflineMode =
        prefs.getBool('enable_offline_mode') ?? AppConstants.enableOfflineMode;
  }

  Future<void> _initializeServices() async {
    // Initialize Flutter Magento service if available
    if (_isOnline && _flutterMagentoService != null) {
      // Flutter Magento service initialization is handled internally
    }

    // Set this service as Magento service for PreloadService
    PreloadService.setMagentoService(this);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.isNotEmpty &&
        !results.every((result) => result == ConnectivityResult.none);

    if (wasOnline != _isOnline) {
      if (kDebugMode) {
        print('Connectivity changed: ${_isOnline ? "Online" : "Offline"}');
      }
      notifyListeners();

      if (_isOnline) {
        _syncOfflineData();
      }
    }
  }

  /// Sync offline data when coming back online
  Future<void> _syncOfflineData() async {
    if (!_isOnline) return;

    try {
      // Sync cached data with server
      if (kDebugMode) {
        print('Syncing offline data...');
      }

      // Here you could implement sync logic for:
      // - Pending cart updates
      // - Wishlist changes
      // - Customer profile updates
      // - etc.
    } catch (e) {
      if (kDebugMode) {
        print('Sync error: $e');
      }
    }
  }

  // Configuration Methods

  /// Set preference for Flutter Magento vs REST API
  Future<void> setPreferFlutterMagento(bool prefer) async {
    _preferFlutterMagento = prefer;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prefer_flutter_magento', prefer);
    notifyListeners();
  }

  /// Set Flutter Magento service instance
  void setFlutterMagentoService(FlutterMagentoCloudService service) {
    _flutterMagentoService = service;
    notifyListeners();
  }

  /// Enable or disable offline mode
  Future<void> setEnableOfflineMode(bool enable) async {
    _enableOfflineMode = enable;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_offline_mode', enable);
    notifyListeners();
  }

  // Authentication Methods

  /// Authenticate customer using preferred method
  Future<bool> authenticateCustomer({
    required String email,
    required String password,
  }) async {
    if (!_isOnline) {
      // In offline mode, check cached credentials
      return await _authenticateOffline(email, password);
    }

    bool success = false;

    // Try Flutter Magento first if available and preferred
    if (_preferFlutterMagento &&
        _flutterMagentoService != null &&
        AppConstants.preferCloudWhenAvailable) {
      success =
          await _flutterMagentoService!.authenticateCustomer(email, password);
    }

    // Fallback to REST API if Flutter Magento fails or is not preferred
    if (!success) {
      success = await _restService.authenticateCustomer(
        email: email,
        password: password,
      );
    }

    if (success && _enableOfflineMode) {
      // Cache credentials for offline use
      await _cacheCredentials(email, password);
    }

    return success;
  }

  Future<bool> _authenticateOffline(String email, String password) async {
    if (!_enableOfflineMode) return false;

    final cachedEmail = await SecureStorageService.getString('cached_email');
    final cachedPasswordHash =
        await SecureStorageService.getString('cached_password_hash');

    if (cachedEmail == email && cachedPasswordHash != null) {
      // Simple hash comparison (in production, use proper password hashing)
      final inputHash =
          email.hashCode.toString() + password.hashCode.toString();
      return cachedPasswordHash == inputHash;
    }

    return false;
  }

  Future<void> _cacheCredentials(String email, String password) async {
    await SecureStorageService.saveString('cached_email', email);
    // Simple hash (in production, use proper password hashing)
    final passwordHash =
        email.hashCode.toString() + password.hashCode.toString();
    await SecureStorageService.saveString('cached_password_hash', passwordHash);
  }

  /// Create customer account
  Future<MagentoCustomer?> createCustomer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    if (!_isOnline) return null;

    MagentoCustomer? customer;

    if (_preferFlutterMagento &&
        _flutterMagentoService != null &&
        AppConstants.preferCloudWhenAvailable) {
      final success = await _flutterMagentoService!.createCustomer(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (success) {
        // Get the created customer
        final customerData = await _flutterMagentoService!.getCurrentCustomer();
        customer = customerData != null
            ? MagentoCustomer.fromJson(customerData)
            : null;
      }
    }

    // Fallback to REST API if Flutter Magento fails or is not preferred
    if (customer == null) {
      customer = await _restService.createCustomer(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
    }

    if (customer != null && _enableOfflineMode) {
      await _cacheCustomer(customer);
    }

    return customer;
  }

  /// Get current customer information
  Future<MagentoCustomer?> getCurrentCustomer() async {
    if (!_isOnline) {
      return await _getCachedCustomer();
    }

    MagentoCustomer? customer;

    if (_preferFlutterMagento &&
        _flutterMagentoService != null &&
        AppConstants.preferCloudWhenAvailable) {
      // final flutterCustomer = await _flutterMagentoService!.getCurrentCustomer();  // Temporarily disabled
      // if (flutterCustomer != null) {
      //   // Convert Flutter Magento customer to MagentoCustomer
      //   customer = _convertFlutterMagentoCustomer(flutterCustomer);
      // }
    }

    // Fallback to REST API if Flutter Magento fails or is not preferred
    if (customer == null) {
      customer = await _restService.getCurrentCustomer();
    }

    if (customer != null && _enableOfflineMode) {
      await _cacheCustomer(customer);
    }

    return customer;
  }

  // Product Methods

  /// Get products using preferred method with offline fallback
  Future<MagentoProductList?> getProducts({
    int page = 1,
    int pageSize = AppConstants.defaultPageSize,
    String? searchQuery,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
    Map<String, dynamic>? filters,
    double? minPrice,
    double? maxPrice,
  }) async {
    // If offline, try preload service first, then cached data
    if (!_isOnline) {
      // Try to get from PreloadService (includes .rada data)
      try {
        final String? state = filters?['state'] as String?;
        final String? county = filters?['county'] as String?;

        final preloadProducts = await PreloadService.getCombinedProducts(
          state: state,
          county: county,
        );

        if (preloadProducts.isNotEmpty) {
          // Convert to MagentoProductList
          return _convertPreloadProductsToMagentoList(
            preloadProducts,
            page: page,
            pageSize: pageSize,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting preload products: $e');
        }
      }

      // Fallback to cached products
      return await _getCachedProducts();
    }

    MagentoProductList? products;

    // Try Flutter Magento first if available and preferred
    if (_preferFlutterMagento &&
        _flutterMagentoService != null &&
        AppConstants.preferCloudWhenAvailable) {
      final flutterProducts = await _flutterMagentoService!.getProducts(
        page: page,
        // pageSize: pageSize,  // Temporarily disabled
        searchQuery: searchQuery,
        // categoryId: categoryId,  // Temporarily disabled
        // sortBy: sortBy,  // Temporarily disabled
        // sortOrder: sortOrder,  // Temporarily disabled
        filters: filters,
        // minPrice: minPrice,  // Temporarily disabled
        // maxPrice: maxPrice,  // Temporarily disabled
      );

      if (flutterProducts != null) {
        // Convert Flutter Magento response to MagentoProductList
        products = _convertFlutterMagentoProducts(flutterProducts);
      }
    }

    // Fallback to REST API if Flutter Magento fails or is not preferred
    if (products == null) {
      products = await _restService.getProducts(
        page: page,
        // pageSize: pageSize,  // Temporarily disabled
        searchQuery: searchQuery,
        // categoryId: categoryId,  // Temporarily disabled
        // sortBy: sortBy,  // Temporarily disabled
        // sortOrder: sortOrder,  // Temporarily disabled
        filters: filters,
      );
    }

    if (products != null && _enableOfflineMode) {
      await _cacheProducts(products);
    }

    return products;
  }

  /// Get product by SKU
  Future<MagentoProduct?> getProduct(String sku) async {
    if (!_isOnline) {
      return await _getCachedProduct(sku);
    }

    MagentoProduct? product;

    if (_preferFlutterMagento &&
        _flutterMagentoService != null &&
        AppConstants.preferCloudWhenAvailable) {
      final flutterProduct = await _flutterMagentoService!.getProduct(sku);
      if (flutterProduct != null) {
        // Convert Flutter Magento product to MagentoProduct
        product = _convertFlutterMagentoProduct(flutterProduct);
      }
    }

    // Fallback to REST API if Flutter Magento fails or is not preferred
    if (product == null) {
      product = await _restService.getProduct(sku);
    }

    return product;
  }

  /// Get categories
  Future<List<MagentoCategory>?> getCategories() async {
    // If offline, try preload service first, then cached data
    if (!_isOnline) {
      // Try to get from PreloadService
      try {
        final preloadCategories = await PreloadService.getCombinedCategories();
        if (preloadCategories.isNotEmpty) {
          return _convertPreloadCategoriesToMagentoList(preloadCategories);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting preload categories: $e');
        }
      }

      // Fallback to cached categories
      return await _getCachedCategories();
    }

    List<MagentoCategory>? categories;

    // For now, use REST API for categories
    // Flutter Magento categories support can be added later
    categories = await _restService.getCategories();

    if (categories != null && _enableOfflineMode) {
      await _cacheCategories(categories);
    }

    return categories;
  }

  // Cart Methods

  /// Create cart
  Future<String?> createCart() async {
    if (!_isOnline) {
      // Generate offline cart ID
      return 'offline_cart_${DateTime.now().millisecondsSinceEpoch}';
    }

    String? cartId;

    if (_preferFlutterMagento &&
        _flutterMagentoService != null &&
        AppConstants.preferCloudWhenAvailable) {
      final flutterCart = await _flutterMagentoService!.createCart();
      if (flutterCart != null) {
        cartId = flutterCart['id']?.toString();
      }
    }

    // Fallback to REST API if Flutter Magento fails or is not preferred
    if (cartId == null) {
      cartId = await _restService.createCart();
    }

    return cartId;
  }

  /// Add item to cart
  Future<bool> addToCart({
    required String cartId,
    required String sku,
    required int quantity,
    Map<String, dynamic>? productOption,
  }) async {
    if (!_isOnline) {
      return await _addToOfflineCart(cartId, sku, quantity, productOption);
    }

    bool success = false;

    if (_preferFlutterMagento &&
        _flutterMagentoService != null &&
        AppConstants.preferCloudWhenAvailable) {
      success = await _flutterMagentoService!.addToCart(
        productId: sku,
        quantity: quantity,
      );
    }

    // Fallback to REST API if Flutter Magento fails or is not preferred
    if (!success) {
      success = await _restService.addToCart(
        cartId: cartId,
        sku: sku,
        quantity: quantity,
        // productOption: productOption,  // Temporarily disabled
      );
    }

    return success;
  }

  /// Get cart
  Future<MagentoCart?> getCart(String cartId) async {
    if (!_isOnline) {
      return await _getCachedCart(cartId);
    }

    MagentoCart? cart;

    if (_preferFlutterMagento &&
        _flutterMagentoService != null &&
        AppConstants.preferCloudWhenAvailable) {
      final flutterCart = await _flutterMagentoService!
          .getCart(''); // Temporarily disabled cartId
      if (flutterCart != null) {
        // Convert Flutter Magento cart to MagentoCart
        cart = _convertFlutterMagentoCart(flutterCart);
      }
    }

    // Fallback to REST API if Flutter Magento fails or is not preferred
    if (cart == null) {
      cart = await _restService.getCart(cartId);
    }

    if (cart != null && _enableOfflineMode) {
      await _cacheCart(cart);
    }

    return cart;
  }

  /// Logout
  void logout() {
    _restService.logout();
    _flutterMagentoService?.logout();
    _clearOfflineData();
    notifyListeners();
  }

  // Cache Methods

  Future<void> _cacheCustomer(MagentoCustomer customer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKeyCustomer, jsonEncode(customer.toJson()));
  }

  Future<MagentoCustomer?> _getCachedCustomer() async {
    if (!_enableOfflineMode) return null;

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKeyCustomer);
    if (cached != null) {
      try {
        return MagentoCustomer.fromJson(jsonDecode(cached));
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached customer: $e');
        }
      }
    }
    return null;
  }

  Future<void> _cacheProducts(MagentoProductList products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKeyProducts, jsonEncode(products.toJson()));
  }

  Future<MagentoProductList?> _getCachedProducts() async {
    if (!_enableOfflineMode) return null;

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKeyProducts);
    if (cached != null) {
      try {
        return MagentoProductList.fromJson(jsonDecode(cached));
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached products: $e');
        }
      }
    }
    return null;
  }

  Future<MagentoProduct?> _getCachedProduct(String sku) async {
    final products = await _getCachedProducts();
    if (products != null) {
      try {
        return products.items.firstWhere((product) => product.sku == sku);
      } catch (e) {
        // Product not found in cache
      }
    }
    return null;
  }

  Future<void> _cacheCategories(List<MagentoCategory> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = categories.map((c) => c.toJson()).toList();
    await prefs.setString(_cacheKeyCategories, jsonEncode(categoriesJson));
  }

  Future<List<MagentoCategory>?> _getCachedCategories() async {
    if (!_enableOfflineMode) return null;

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKeyCategories);
    if (cached != null) {
      try {
        final List<dynamic> categoriesJson = jsonDecode(cached);
        return categoriesJson
            .map((json) => MagentoCategory.fromJson(json))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached categories: $e');
        }
      }
    }
    return null;
  }

  Future<void> _cacheCart(MagentoCart cart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${_cacheKeyCart}_${cart.id}', jsonEncode(cart.toJson()));
  }

  Future<MagentoCart?> _getCachedCart(String cartId) async {
    if (!_enableOfflineMode) return null;

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('${_cacheKeyCart}_$cartId');
    if (cached != null) {
      try {
        return MagentoCart.fromJson(jsonDecode(cached));
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached cart: $e');
        }
      }
    }
    return null;
  }

  Future<bool> _addToOfflineCart(
    String cartId,
    String sku,
    int quantity,
    Map<String, dynamic>? productOption,
  ) async {
    if (!_enableOfflineMode) return false;

    try {
      // Get or create offline cart
      MagentoCart? cart = await _getCachedCart(cartId);

      if (cart == null) {
        // Create new offline cart
        cart = MagentoCart(
          id: int.tryParse(cartId.replaceAll('offline_cart_', '')) ??
              DateTime.now().millisecondsSinceEpoch,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
          isVirtual: false,
          items: [],
          itemsCount: 0,
          itemsQty: 0,
        );
      }

      // Find product in cache
      final product = await _getCachedProduct(sku);
      if (product == null) return false;

      // Add or update item
      final existingItemIndex =
          cart.items.indexWhere((item) => item.sku == sku);

      if (existingItemIndex >= 0) {
        // Update existing item
        final existingItem = cart.items[existingItemIndex];
        final updatedItem = MagentoCartItem(
          sku: sku,
          itemId: existingItem.itemId,
          qty: existingItem.qty + quantity,
          name: product.name,
          price: product.finalPrice,
          rowTotal: (existingItem.qty + quantity) * product.finalPrice,
        );
        cart.items[existingItemIndex] = updatedItem;
      } else {
        // Add new item
        final newItem = MagentoCartItem(
          sku: sku,
          itemId: DateTime.now().millisecondsSinceEpoch,
          qty: quantity,
          name: product.name,
          price: product.finalPrice,
          rowTotal: quantity * product.finalPrice,
        );
        cart.items.add(newItem);
      }

      // Update cart totals
      final updatedCart = MagentoCart(
        id: cart.id,
        createdAt: cart.createdAt,
        updatedAt: DateTime.now(),
        isActive: cart.isActive,
        isVirtual: cart.isVirtual,
        items: cart.items,
        itemsCount: cart.items.length,
        itemsQty: cart.items.fold(0, (sum, item) => sum + item.qty),
      );

      await _cacheCart(updatedCart);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to offline cart: $e');
      }
      return false;
    }
  }

  Future<void> _clearOfflineData() async {
    await SecureStorageService.delete('cached_email');
    await SecureStorageService.delete('cached_password_hash');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKeyCustomer);
    await prefs.remove(_cacheKeyProducts);
    await prefs.remove(_cacheKeyCategories);

    // Clear all cached carts
    final keys = prefs.getKeys().where((key) => key.startsWith(_cacheKeyCart));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Convert Flutter Magento products to MagentoProductList
  MagentoProductList _convertFlutterMagentoProducts(dynamic flutterProducts) {
    // This is a placeholder implementation
    // In practice, you would need to map the Flutter Magento response
    // to your MagentoProductList structure based on the actual response format

    try {
      // Assuming flutterProducts has a structure similar to MagentoProductList
      // You may need to adjust this based on the actual Flutter Magento response format

      if (flutterProducts is Map<String, dynamic>) {
        final items = flutterProducts['items'] as List<dynamic>? ?? [];
        final totalCount = flutterProducts['total_count'] as int? ?? 0;

        final magentoProducts = items.map((item) {
          // Convert each item to MagentoProduct
          // This is a simplified conversion - adjust based on actual structure
          return MagentoProduct(
            sku: item['sku'] ?? '',
            name: item['name'] ?? '',
            description: item['description']?['html'],
            shortDescription: item['short_description']?['html'],
            price: (item['price_range']?['minimum_price']?['regular_price']
                    ?['value'])
                ?.toDouble(),
            specialPrice: (item['price_range']?['minimum_price']?['final_price']
                    ?['value'])
                ?.toDouble(),
            typeId: item['type_id'] ?? 'simple',
            urlKey: item['url_key'] ?? '',
            isActive: item['status'] == 1,
            isVisible: item['visibility'] != 1,
            isInStock: item['stock_status'] == 'IN_STOCK',
            qty: item['only_x_left_in_stock'],
            categoryIds: item['categories'] != null
                ? List<String>.from(
                    item['categories'].map((c) => c['id'].toString()))
                : null,
            mediaGalleryEntries: item['media_gallery_entries'] != null
                ? List<MagentoProductImage>.from(
                    item['media_gallery_entries']
                        .map((x) => MagentoProductImage.fromJson(x)),
                  )
                : null,
            createdAt: item['created_at'] != null
                ? DateTime.parse(item['created_at'])
                : null,
            updatedAt: item['updated_at'] != null
                ? DateTime.parse(item['updated_at'])
                : null,
          );
        }).toList();

        return MagentoProductList(
          items: magentoProducts,
          totalCount: totalCount,
          searchCriteria: MagentoSearchCriteria(
            filterGroups: [],
            sortOrders: [],
            pageSize: flutterProducts['page_info']?['page_size'] ?? 20,
            currentPage: flutterProducts['page_info']?['current_page'] ?? 1,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error converting Flutter Magento products: $e');
      }
    }

    // Return empty list if conversion fails
    return MagentoProductList(
      items: [],
      totalCount: 0,
      searchCriteria: MagentoSearchCriteria(
        filterGroups: [],
        sortOrders: [],
        pageSize: 20,
        currentPage: 1,
      ),
    );
  }

  /// Convert Flutter Magento customer to MagentoCustomer
  MagentoCustomer? _convertFlutterMagentoCustomer(dynamic flutterCustomer) {
    try {
      if (flutterCustomer is Map<String, dynamic>) {
        return MagentoCustomer(
          id: int.tryParse(flutterCustomer['id']?.toString() ?? '0') ?? 0,
          email: flutterCustomer['email'] ?? '',
          firstname: flutterCustomer['firstname'] ?? '',
          lastname: flutterCustomer['lastname'] ?? '',
          createdAt: flutterCustomer['created_at'] != null
              ? DateTime.parse(flutterCustomer['created_at'])
              : null,
          updatedAt: flutterCustomer['updated_at'] != null
              ? DateTime.parse(flutterCustomer['updated_at'])
              : null,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error converting Flutter Magento customer: $e');
      }
    }
    return null;
  }

  /// Convert Flutter Magento product to MagentoProduct
  MagentoProduct? _convertFlutterMagentoProduct(dynamic flutterProduct) {
    try {
      if (flutterProduct is Map<String, dynamic>) {
        return MagentoProduct(
          sku: flutterProduct['sku'] ?? '',
          name: flutterProduct['name'] ?? '',
          description: flutterProduct['description']?['html'],
          shortDescription: flutterProduct['short_description']?['html'],
          price: (flutterProduct['price_range']?['minimum_price']
                  ?['regular_price']?['value'])
              ?.toDouble(),
          specialPrice: (flutterProduct['price_range']?['minimum_price']
                  ?['final_price']?['value'])
              ?.toDouble(),
          typeId: flutterProduct['type_id'] ?? 'simple',
          urlKey: flutterProduct['url_key'] ?? '',
          isActive: flutterProduct['status'] == 1,
          isVisible: flutterProduct['visibility'] != 1,
          isInStock: flutterProduct['stock_status'] == 'IN_STOCK',
          qty: flutterProduct['only_x_left_in_stock'],
          categoryIds: flutterProduct['categories'] != null
              ? List<String>.from(
                  flutterProduct['categories'].map((c) => c['id'].toString()))
              : null,
          mediaGalleryEntries: flutterProduct['media_gallery_entries'] != null
              ? List<MagentoProductImage>.from(
                  flutterProduct['media_gallery_entries']
                      .map((x) => MagentoProductImage.fromJson(x)),
                )
              : null,
          createdAt: flutterProduct['created_at'] != null
              ? DateTime.parse(flutterProduct['created_at'])
              : null,
          updatedAt: flutterProduct['updated_at'] != null
              ? DateTime.parse(flutterProduct['updated_at'])
              : null,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error converting Flutter Magento product: $e');
      }
    }
    return null;
  }

  /// Convert Flutter Magento cart to MagentoCart
  MagentoCart? _convertFlutterMagentoCart(dynamic flutterCart) {
    try {
      if (flutterCart is Map<String, dynamic>) {
        return MagentoCart(
          id: int.tryParse(flutterCart['id']?.toString() ?? '0') ?? 0,
          createdAt: flutterCart['created_at'] != null
              ? DateTime.parse(flutterCart['created_at'])
              : DateTime.now(),
          updatedAt: flutterCart['updated_at'] != null
              ? DateTime.parse(flutterCart['updated_at'])
              : DateTime.now(),
          isActive: flutterCart['is_active'] ?? true,
          isVirtual: flutterCart['is_virtual'] ?? false,
          items: flutterCart['items'] != null
              ? List<MagentoCartItem>.from(flutterCart['items']
                  .map((item) => MagentoCartItem.fromJson(item)))
              : [],
          itemsCount: flutterCart['items_count'] ?? 0,
          itemsQty: flutterCart['items_qty'] ?? 0,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error converting Flutter Magento cart: $e');
      }
    }
    return null;
  }

  /// Convert preload products to MagentoProductList
  MagentoProductList _convertPreloadProductsToMagentoList(
    List<Map<String, dynamic>> preloadProducts, {
    int page = 1,
    int pageSize = 20,
  }) {
    try {
      // Apply pagination
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      final paginatedProducts = preloadProducts.length > startIndex
          ? preloadProducts.sublist(
              startIndex,
              endIndex > preloadProducts.length
                  ? preloadProducts.length
                  : endIndex,
            )
          : <Map<String, dynamic>>[];

      final magentoProducts = paginatedProducts.map((item) {
        // Convert category IDs to String list
        final categoryIds = (item['category_ids'] as List<dynamic>?)
                ?.map((id) => id.toString())
                .toList() ??
            [];

        // Create media gallery from image URLs if available
        final List<MagentoProductImage>? mediaGallery =
            item['image_url'] != null
                ? [
                    MagentoProductImage(
                      url: item['image_url'],
                      mediaType: 'image',
                      types: ['image', 'small_image', 'thumbnail'],
                    )
                  ]
                : null;

        return MagentoProduct(
          sku: item['sku'] ?? '',
          name: item['name'] ?? '',
          description: item['description'],
          shortDescription: item['short_description'],
          price: (item['price'] as num?)?.toDouble(),
          specialPrice: (item['special_price'] as num?)?.toDouble(),
          typeId: item['type_id'] ?? 'simple',
          urlKey: item['url_key'] ?? '',
          isActive: item['status'] == 1,
          isVisible: item['visibility'] != 1,
          isInStock: true,
          qty: 100,
          categoryIds: categoryIds,
          mediaGalleryEntries: mediaGallery,
        );
      }).toList();

      return MagentoProductList(
        items: magentoProducts,
        totalCount: preloadProducts.length,
        searchCriteria: MagentoSearchCriteria(
          filterGroups: [],
          sortOrders: [],
          pageSize: pageSize,
          currentPage: page,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error converting preload products: $e');
      }
      return MagentoProductList(
        items: [],
        totalCount: 0,
        searchCriteria: MagentoSearchCriteria(
          filterGroups: [],
          sortOrders: [],
          pageSize: pageSize,
          currentPage: page,
        ),
      );
    }
  }

  /// Convert preload categories to Magento categories list
  List<MagentoCategory> _convertPreloadCategoriesToMagentoList(
    List<Map<String, dynamic>> preloadCategories,
  ) {
    try {
      return preloadCategories.map((item) {
        return MagentoCategory(
          id: int.tryParse(item['id']?.toString() ?? '0') ?? 0,
          name: item['name'] ?? '',
          isActive: item['is_active'] == true,
          position: int.tryParse(item['position']?.toString() ?? '0') ?? 0,
          level: int.tryParse(item['level']?.toString() ?? '1') ?? 1,
          parentId: int.tryParse(item['parent_id']?.toString() ?? '0'),
          productCount: int.tryParse(item['product_count']?.toString() ?? '0'),
          description: item['description'],
          urlKey: item['url_key'],
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error converting preload categories: $e');
      }
      return [];
    }
  }

  /// Get service status information
  Map<String, dynamic> getServiceStatus() {
    return {
      'isOnline': _isOnline,
      'connectionStatus': connectionStatus,
      'preferFlutterMagento': _preferFlutterMagento,
      'enableOfflineMode': _enableOfflineMode,
      'isAuthenticated': isAuthenticated,
      'restServiceLoading': _restService.isLoading,
      'flutterMagentoAvailable': _flutterMagentoService != null,
      'preloadDataAvailable': PreloadService.isUsingRadaData,
    };
  }
}
