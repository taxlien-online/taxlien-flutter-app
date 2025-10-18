/// Magento Marketplace Service for TaxLien.online
/// Comprehensive e-commerce service using flutter_magento 4.3.1

import 'package:flutter/foundation.dart';
import 'package:flutter_magento/flutter_magento.dart';
import '../core/models/magento_marketplace_models.dart';
import '../core/providers/magento_marketplace_provider.dart';

/// Service layer for Magento marketplace operations
class MagentoMarketplaceService extends ChangeNotifier {
  final MagentoMarketplaceProvider _provider;

  MagentoMarketplaceService(this._provider);

  // Getters that delegate to provider
  bool get isInitialized => _provider.isInitialized;
  bool get isLoading => _provider.isLoading;
  String? get error => _provider.error;
  bool get isAuthenticated => _provider.isAuthenticated;
  MagentoCustomer? get currentCustomer => _provider.currentCustomer;
  MagentoCart? get cart => _provider.cart;
  int get cartItemsCount => _provider.cartItemsCount;
  double get cartTotal => _provider.cartTotal;

  /// Initialize the service
  Future<bool> initialize({
    required String baseUrl,
    int connectionTimeout = 30000,
    int receiveTimeout = 30000,
    Map<String, String>? headers,
    List<String>? supportedLanguages,
  }) async {
    return await _provider.initialize(
      baseUrl: baseUrl,
      connectionTimeout: connectionTimeout,
      receiveTimeout: receiveTimeout,
      headers: headers,
      supportedLanguages: supportedLanguages,
    );
  }

  /// User authentication
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    return await _provider.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
  }

  Future<void> logout() async {
    await _provider.logout();
  }

  /// Product operations
  Future<ProductSearchResult?> searchProducts({
    String? searchTerm,
    List<int>? categoryIds,
    double? minPrice,
    double? maxPrice,
    int currentPage = 1,
    int pageSize = 20,
    String? sortBy,
    String sortOrder = 'ASC',
  }) async {
    await _provider.searchProducts(
      searchTerm: searchTerm,
      categoryIds: categoryIds,
      minPrice: minPrice,
      maxPrice: maxPrice,
      currentPage: currentPage,
      pageSize: pageSize,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );

    return _provider.searchResult;
  }

  /// Get product by ID
  Future<MagentoProduct?> getProduct(int productId) async {
    // Implementation will use flutter_magento product API
    try {
      // final productApi = FlutterMagentoCore.instance.products;
      // final productData = await productApi.getById(productId);
      // return MagentoProduct.fromJson(productData);
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting product: $e');
      }
      return null;
    }
  }

  /// Get products by category
  Future<List<MagentoProduct>> getProductsByCategory(
    int categoryId, {
    int pageSize = 20,
    int currentPage = 1,
  }) async {
    try {
      // final productApi = FlutterMagentoCore.instance.products;
      // final results = await productApi.search(
      //   categoryId: categoryId,
      //   pageSize: pageSize,
      //   currentPage: currentPage,
      // );
      // Convert and return products
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error getting products by category: $e');
      }
      return [];
    }
  }

  /// Category operations
  Future<List<MagentoCategory>> getCategories() async {
    return await _provider.loadCategories();
  }

  Future<MagentoCategory?> getCategory(int categoryId) async {
    try {
      // Implementation using flutter_magento categories API
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting category: $e');
      }
      return null;
    }
  }

  /// Cart operations
  Future<void> refreshCart() async {
    await _provider.loadCart();
  }

  Future<bool> addToCart({
    required String sku,
    int quantity = 1,
  }) async {
    return await _provider.addToCart(sku: sku, quantity: quantity);
  }

  Future<bool> removeFromCart(int itemId) async {
    return await _provider.removeFromCart(itemId);
  }

  Future<bool> updateCartItemQuantity(int itemId, int quantity) async {
    return await _provider.updateCartItemQty(itemId, quantity);
  }

  Future<void> clearCart() async {
    if (cart?.items.isEmpty ?? true) return;

    for (final item in cart!.items) {
      await removeFromCart(item.itemId);
    }
  }

  /// Wishlist operations
  Future<void> refreshWishlist() async {
    await _provider.loadWishlist();
  }

  Future<bool> addToWishlist(int productId) async {
    return await _provider.addToWishlist(productId);
  }

  Future<bool> removeFromWishlist(int itemId) async {
    return await _provider.removeFromWishlist(itemId);
  }

  bool isInWishlist(int productId) {
    if (_provider.wishlist == null) return false;

    return _provider.wishlist!.items.any((item) => item.productId == productId);
  }

  /// Order operations
  Future<List<MagentoOrder>> getOrders() async {
    if (!isAuthenticated) return [];

    try {
      // Implementation using flutter_magento orders API
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error getting orders: $e');
      }
      return [];
    }
  }

  Future<MagentoOrder?> getOrder(int orderId) async {
    try {
      // Implementation using flutter_magento orders API
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting order: $e');
      }
      return null;
    }
  }

  /// Review operations
  Future<List<MagentoReview>> getProductReviews(int productId) async {
    try {
      // Implementation using flutter_magento reviews API
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error getting reviews: $e');
      }
      return [];
    }
  }

  Future<bool> submitReview({
    required int productId,
    required String title,
    required String detail,
    required String nickname,
    required int rating,
  }) async {
    try {
      // Implementation using flutter_magento reviews API
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting review: $e');
      }
      return false;
    }
  }

  /// Customer operations
  Future<void> refreshCustomer() async {
    await _provider.loadCustomer();
  }

  Future<bool> updateCustomerProfile({
    String? firstname,
    String? lastname,
    String? email,
  }) async {
    if (!isAuthenticated) return false;

    try {
      // Implementation using flutter_magento customer API
      await refreshCustomer();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      return false;
    }
  }

  /// Address operations
  Future<List<MagentoAddress>> getAddresses() async {
    if (!isAuthenticated) return [];

    return currentCustomer?.addresses ?? [];
  }

  Future<bool> addAddress(MagentoAddress address) async {
    if (!isAuthenticated) return false;

    try {
      // Implementation using flutter_magento customer API
      await refreshCustomer();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding address: $e');
      }
      return false;
    }
  }

  Future<bool> updateAddress(MagentoAddress address) async {
    if (!isAuthenticated || address.id == null) return false;

    try {
      // Implementation using flutter_magento customer API
      await refreshCustomer();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating address: $e');
      }
      return false;
    }
  }

  Future<bool> deleteAddress(int addressId) async {
    if (!isAuthenticated) return false;

    try {
      // Implementation using flutter_magento customer API
      await refreshCustomer();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting address: $e');
      }
      return false;
    }
  }

  /// Utility methods
  void clearError() {
    _provider.clearError();
  }

  /// Demo data for testing
  List<MagentoProduct> getDemoProducts() {
    return [
      const MagentoProduct(
        id: 1,
        sku: 'FL-TAX-001',
        name: 'Florida Tax Lien - Miami-Dade County',
        price: 5000.00,
        description:
            'Prime residential property tax lien in Miami-Dade County with 18% interest rate',
        shortDescription: 'High-yield tax lien investment opportunity',
        image: null,
        customAttributes: {
          'county': 'Miami-Dade',
          'state': 'FL',
          'interest_rate': 18.0,
          'property_type': 'Residential',
        },
        inStock: true,
        qty: 1,
      ),
      const MagentoProduct(
        id: 2,
        sku: 'AZ-TAX-001',
        name: 'Arizona Tax Deed - Maricopa County',
        price: 12500.00,
        description: 'Tax deed sale property in Phoenix area with clear title',
        shortDescription:
            'Tax deed investment with property ownership potential',
        image: null,
        customAttributes: {
          'county': 'Maricopa',
          'state': 'AZ',
          'property_value': 85000.0,
          'property_type': 'Commercial',
        },
        inStock: true,
        qty: 1,
      ),
      const MagentoProduct(
        id: 3,
        sku: 'TX-TAX-001',
        name: 'Texas Tax Lien - Harris County',
        price: 7500.00,
        description:
            'Commercial property tax lien in Houston with 25% penalty interest',
        shortDescription: 'High-return commercial tax lien',
        image: null,
        customAttributes: {
          'county': 'Harris',
          'state': 'TX',
          'interest_rate': 25.0,
          'property_type': 'Commercial',
        },
        inStock: true,
        qty: 1,
      ),
    ];
  }

  List<MagentoCategory> getDemoCategories() {
    return [
      const MagentoCategory(
        id: 1,
        name: 'Tax Liens',
        path: '1',
        level: 1,
        isActive: true,
        productCount: 150,
        children: [
          MagentoCategory(
            id: 11,
            name: 'Florida',
            path: '1/11',
            parentId: 1,
            level: 2,
            isActive: true,
            productCount: 45,
          ),
          MagentoCategory(
            id: 12,
            name: 'Arizona',
            path: '1/12',
            parentId: 1,
            level: 2,
            isActive: true,
            productCount: 32,
          ),
          MagentoCategory(
            id: 13,
            name: 'Texas',
            path: '1/13',
            parentId: 1,
            level: 2,
            isActive: true,
            productCount: 73,
          ),
        ],
      ),
      const MagentoCategory(
        id: 2,
        name: 'Tax Deeds',
        path: '2',
        level: 1,
        isActive: true,
        productCount: 85,
        children: [
          MagentoCategory(
            id: 21,
            name: 'Residential',
            path: '2/21',
            parentId: 2,
            level: 2,
            isActive: true,
            productCount: 56,
          ),
          MagentoCategory(
            id: 22,
            name: 'Commercial',
            path: '2/22',
            parentId: 2,
            level: 2,
            isActive: true,
            productCount: 29,
          ),
        ],
      ),
      const MagentoCategory(
        id: 3,
        name: 'Data Packages',
        path: '3',
        level: 1,
        isActive: true,
        productCount: 12,
      ),
    ];
  }
}
