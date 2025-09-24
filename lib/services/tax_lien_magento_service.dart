import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/tax_lien_models.dart';
import '../core/models/magento_models.dart';
import '../core/services/hybrid_magento_service.dart';

/// Service for managing Tax Liens through Magento API
/// Replaces DatabaseService functionality with Magento integration
class TaxLienMagentoService extends ChangeNotifier {
  final HybridMagentoService _magentoService;

  // Cache keys for offline support
  static const String _cacheKeyTaxLiens = 'cached_tax_liens';
  static const String _cacheKeyFavorites = 'cached_favorites';
  static const String _cacheKeySearchHistory = 'cached_search_history';
  static const String _cacheKeyUserProfile = 'cached_user_profile';
  static const String _cacheKeyTransactions = 'cached_transactions';

  bool _isLoading = false;
  String? _error;
  List<TaxLien> _taxLiens = [];
  List<String> _favoriteLienIds = [];
  List<Map<String, dynamic>> _searchHistory = [];
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _transactions = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TaxLien> get taxLiens => _taxLiens;
  List<String> get favoriteLienIds => _favoriteLienIds;
  List<Map<String, dynamic>> get searchHistory => _searchHistory;
  Map<String, dynamic>? get userProfile => _userProfile;
  List<Map<String, dynamic>> get transactions => _transactions;

  TaxLienMagentoService(this._magentoService) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadCachedData();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Tax Liens Management

  /// Get all tax liens from Magento
  Future<List<TaxLien>> getTaxLiens({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
    String? state,
    String? county,
    String? status,
    double? minAssessedValue,
    double? maxAssessedValue,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Build search filters
      final filters = <String, dynamic>{};
      if (state != null) filters['state'] = state;
      if (county != null) filters['county'] = county;
      if (status != null) filters['status'] = status;
      if (minAssessedValue != null)
        filters['min_assessed_value'] = minAssessedValue.toString();
      if (maxAssessedValue != null)
        filters['max_assessed_value'] = maxAssessedValue.toString();

      // Get products from Magento with tax lien custom attributes
      final productList = await _magentoService.getProducts(
        page: page,
        pageSize: pageSize,
        searchQuery: searchQuery,
        filters: filters,
        sortBy: 'created_at',
        sortOrder: 'DESC',
      );

      if (productList != null) {
        // Convert Magento products to TaxLiens
        final taxLiens = productList.items
            .where((product) =>
                product.typeId == 'tax_lien' || product.taxLienId != null)
            .map((product) =>
                TaxLienMagentoConverter.magentoProductToTaxLien(product))
            .toList();

        _taxLiens = taxLiens;
        await _cacheTaxLiens(taxLiens);
        _setLoading(false);
        return taxLiens;
      } else {
        // Fallback to cached data
        final cachedTaxLiens = await _getCachedTaxLiens();
        _taxLiens = cachedTaxLiens;
        _setLoading(false);
        return cachedTaxLiens;
      }
    } catch (e) {
      _setError('Failed to load tax liens: $e');
      _setLoading(false);

      // Return cached data as fallback
      final cachedTaxLiens = await _getCachedTaxLiens();
      _taxLiens = cachedTaxLiens;
      return cachedTaxLiens;
    }
  }

  /// Get tax lien by ID
  Future<TaxLien?> getTaxLien(String id) async {
    try {
      // First check in current list
      final existingLien = _taxLiens.firstWhere(
        (lien) => lien.id == id,
        orElse: () => TaxLien(
          id: '',
          address: '',
          city: '',
          state: '',
          zipCode: '',
          county: '',
          assessedValue: 0,
          taxAmount: 0,
          interestRate: 0,
          taxYear: DateTime.now(),
          saleDate: DateTime.now(),
          status: 'available',
        ),
      );

      if (existingLien.id.isNotEmpty) {
        return existingLien;
      }

      // Try to get from Magento
      final product = await _magentoService.getProduct(id);
      if (product != null &&
          (product.typeId == 'tax_lien' || product.taxLienId != null)) {
        return TaxLienMagentoConverter.magentoProductToTaxLien(product);
      }

      return null;
    } catch (e) {
      _setError('Failed to get tax lien: $e');
      return null;
    }
  }

  /// Save tax lien to Magento
  Future<bool> saveTaxLien(TaxLien taxLien) async {
    try {
      // For now, we'll cache the data since we don't have direct product creation API
      // In a real implementation, you would call Magento API to create/update product
      // Convert TaxLien to MagentoProduct for future API integration
      // final magentoProduct = TaxLienMagentoConverter.taxLienToMagentoProduct(taxLien);

      await _cacheTaxLien(taxLien);

      // Update local list
      final existingIndex =
          _taxLiens.indexWhere((lien) => lien.id == taxLien.id);
      if (existingIndex >= 0) {
        _taxLiens[existingIndex] = taxLien;
      } else {
        _taxLiens.add(taxLien);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to save tax lien: $e');
      return false;
    }
  }

  /// Delete tax lien
  Future<bool> deleteTaxLien(String id) async {
    try {
      // Remove from local list
      _taxLiens.removeWhere((lien) => lien.id == id);

      // Remove from cache
      await _removeCachedTaxLien(id);

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete tax lien: $e');
      return false;
    }
  }

  // User Profile Management

  /// Save user profile
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    try {
      _userProfile = profile;
      await _cacheUserProfile(profile);
      notifyListeners();
    } catch (e) {
      _setError('Failed to save user profile: $e');
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_userProfile != null) return _userProfile;

    try {
      _userProfile = await _getCachedUserProfile();
      return _userProfile;
    } catch (e) {
      _setError('Failed to get user profile: $e');
      return null;
    }
  }

  // Transactions Management

  /// Save transaction
  Future<void> saveTransaction({
    required String id,
    required String lienId,
    required String type,
    required double amount,
    required String status,
    String? description,
  }) async {
    try {
      final transaction = {
        'id': id,
        'lienId': lienId,
        'type': type,
        'amount': amount,
        'timestamp': DateTime.now().toIso8601String(),
        'status': status,
        'description': description,
      };

      _transactions.add(transaction);
      await _cacheTransactions(_transactions);
      notifyListeners();
    } catch (e) {
      _setError('Failed to save transaction: $e');
    }
  }

  /// Get transactions
  Future<List<Map<String, dynamic>>> getTransactions({String? lienId}) async {
    if (_transactions.isEmpty) {
      _transactions = await _getCachedTransactions();
    }

    if (lienId != null) {
      return _transactions.where((tx) => tx['lienId'] == lienId).toList();
    }

    return _transactions;
  }

  // Favorites Management

  /// Add to favorites
  Future<void> addToFavorites(String itemId, {String type = 'lien'}) async {
    try {
      if (!_favoriteLienIds.contains(itemId)) {
        _favoriteLienIds.add(itemId);
        await _cacheFavorites(_favoriteLienIds);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to add to favorites: $e');
    }
  }

  /// Remove from favorites
  Future<void> removeFromFavorites(String itemId,
      {String type = 'lien'}) async {
    try {
      _favoriteLienIds.remove(itemId);
      await _cacheFavorites(_favoriteLienIds);
      notifyListeners();
    } catch (e) {
      _setError('Failed to remove from favorites: $e');
    }
  }

  /// Check if item is favorite
  Future<bool> isFavorite(String itemId, {String type = 'lien'}) async {
    if (_favoriteLienIds.isEmpty) {
      _favoriteLienIds = await _getCachedFavorites();
    }
    return _favoriteLienIds.contains(itemId);
  }

  // Search History Management

  /// Save search history
  Future<void> saveSearchHistory({
    required String query,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final searchEntry = {
        'query': query,
        'filters': filters,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _searchHistory.insert(0, searchEntry);

      // Keep only last 50 searches
      if (_searchHistory.length > 50) {
        _searchHistory = _searchHistory.take(50).toList();
      }

      await _cacheSearchHistory(_searchHistory);
      notifyListeners();
    } catch (e) {
      _setError('Failed to save search history: $e');
    }
  }

  /// Get search history
  Future<List<Map<String, dynamic>>> getSearchHistory({int limit = 10}) async {
    if (_searchHistory.isEmpty) {
      _searchHistory = await _getCachedSearchHistory();
    }

    return _searchHistory.take(limit).toList();
  }

  /// Clear search history
  Future<void> clearSearchHistory() async {
    try {
      _searchHistory.clear();
      await _cacheSearchHistory(_searchHistory);
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear search history: $e');
    }
  }

  // Cache Methods

  Future<void> _loadCachedData() async {
    try {
      _favoriteLienIds = await _getCachedFavorites();
      _searchHistory = await _getCachedSearchHistory();
      _userProfile = await _getCachedUserProfile();
      _transactions = await _getCachedTransactions();
      _taxLiens = await _getCachedTaxLiens();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cached data: $e');
      }
    }
  }

  Future<void> _cacheTaxLiens(List<TaxLien> taxLiens) async {
    final prefs = await SharedPreferences.getInstance();
    final taxLiensJson = taxLiens.map((lien) => lien.toJson()).toList();
    await prefs.setString(_cacheKeyTaxLiens, jsonEncode(taxLiensJson));
  }

  Future<List<TaxLien>> _getCachedTaxLiens() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKeyTaxLiens);
    if (cached != null) {
      try {
        final List<dynamic> taxLiensJson = jsonDecode(cached);
        return taxLiensJson.map((json) => TaxLien.fromJson(json)).toList();
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached tax liens: $e');
        }
      }
    }
    return [];
  }

  Future<void> _cacheTaxLien(TaxLien taxLien) async {
    final taxLiens = await _getCachedTaxLiens();
    final existingIndex = taxLiens.indexWhere((lien) => lien.id == taxLien.id);

    if (existingIndex >= 0) {
      taxLiens[existingIndex] = taxLien;
    } else {
      taxLiens.add(taxLien);
    }

    await _cacheTaxLiens(taxLiens);
  }

  Future<void> _removeCachedTaxLien(String id) async {
    final taxLiens = await _getCachedTaxLiens();
    taxLiens.removeWhere((lien) => lien.id == id);
    await _cacheTaxLiens(taxLiens);
  }

  Future<void> _cacheFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKeyFavorites, jsonEncode(favorites));
  }

  Future<List<String>> _getCachedFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKeyFavorites);
    if (cached != null) {
      try {
        final List<dynamic> favoritesJson = jsonDecode(cached);
        return favoritesJson.map((item) => item.toString()).toList();
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached favorites: $e');
        }
      }
    }
    return [];
  }

  Future<void> _cacheSearchHistory(List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKeySearchHistory, jsonEncode(history));
  }

  Future<List<Map<String, dynamic>>> _getCachedSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKeySearchHistory);
    if (cached != null) {
      try {
        final List<dynamic> historyJson = jsonDecode(cached);
        return historyJson
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached search history: $e');
        }
      }
    }
    return [];
  }

  Future<void> _cacheUserProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKeyUserProfile, jsonEncode(profile));
  }

  Future<Map<String, dynamic>?> _getCachedUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKeyUserProfile);
    if (cached != null) {
      try {
        return Map<String, dynamic>.from(jsonDecode(cached));
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached user profile: $e');
        }
      }
    }
    return null;
  }

  Future<void> _cacheTransactions(
      List<Map<String, dynamic>> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKeyTransactions, jsonEncode(transactions));
  }

  Future<List<Map<String, dynamic>>> _getCachedTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKeyTransactions);
    if (cached != null) {
      try {
        final List<dynamic> transactionsJson = jsonDecode(cached);
        return transactionsJson
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing cached transactions: $e');
        }
      }
    }
    return [];
  }

  /// Clear all data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKeyTaxLiens);
      await prefs.remove(_cacheKeyFavorites);
      await prefs.remove(_cacheKeySearchHistory);
      await prefs.remove(_cacheKeyUserProfile);
      await prefs.remove(_cacheKeyTransactions);

      _taxLiens.clear();
      _favoriteLienIds.clear();
      _searchHistory.clear();
      _userProfile = null;
      _transactions.clear();

      notifyListeners();
    } catch (e) {
      _setError('Failed to clear data: $e');
    }
  }

  /// Get service status
  Map<String, dynamic> getServiceStatus() {
    return {
      'isLoading': _isLoading,
      'error': _error,
      'taxLiensCount': _taxLiens.length,
      'favoritesCount': _favoriteLienIds.length,
      'searchHistoryCount': _searchHistory.length,
      'hasUserProfile': _userProfile != null,
      'transactionsCount': _transactions.length,
    };
  }
}
