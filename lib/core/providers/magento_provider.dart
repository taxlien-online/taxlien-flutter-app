import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/magento_api_service.dart';
import '../models/magento_models.dart';

/// State для Magento
class MagentoState {
  final bool isLoading;
  final String? error;
  final MagentoProductList? products;
  final List<MagentoCategory>? categories;
  final MagentoProduct? currentProduct;

  const MagentoState({
    this.isLoading = false,
    this.error,
    this.products,
    this.categories,
    this.currentProduct,
  });

  MagentoState copyWith({
    bool? isLoading,
    String? error,
    MagentoProductList? products,
    List<MagentoCategory>? categories,
    MagentoProduct? currentProduct,
  }) {
    return MagentoState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      currentProduct: currentProduct ?? this.currentProduct,
    );
  }
}

/// Notifier для управления состоянием Magento
class MagentoNotifier extends StateNotifier<MagentoState> {
  final MagentoApiService _apiService;

  MagentoNotifier(this._apiService) : super(const MagentoState());

  /// Загрузка категорий
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final categories = await _apiService.getCategories();
      state = state.copyWith(
        isLoading: false,
        categories: categories,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load categories: $e',
      );
    }
  }

  /// Загрузка продуктов
  Future<void> loadProducts({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await _apiService.getProducts(
        page: page,
        pageSize: pageSize,
        searchQuery: searchQuery,
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      state = state.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load products: $e',
      );
    }
  }

  /// Загрузка одного продукта
  Future<void> loadProduct(String sku) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final product = await _apiService.getProduct(sku);
      state = state.copyWith(
        isLoading: false,
        currentProduct: product,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load product: $e',
      );
    }
  }

  /// Создание корзины
  Future<String?> createCart() async {
    try {
      return await _apiService.createCart();
    } catch (e) {
      state = state.copyWith(error: 'Failed to create cart: $e');
      return null;
    }
  }

  /// Добавление товара в корзину
  Future<bool> addToCart({
    required String cartId,
    required String sku,
    required int quantity,
  }) async {
    try {
      final item = MagentoCartItem(
        sku: sku,
        qty: quantity,
        quoteId: cartId,
      );

      final success = await _apiService.addToCart(cartId, item);
      return success != null;
    } catch (e) {
      state = state.copyWith(error: 'Failed to add to cart: $e');
      return false;
    }
  }
}

/// Provider для Magento
final magentoProvider =
    StateNotifierProvider<MagentoNotifier, MagentoState>((ref) {
  return MagentoNotifier(MagentoApiService());
});
