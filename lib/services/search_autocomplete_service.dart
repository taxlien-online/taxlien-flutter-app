import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/services/magento_api_service.dart';
import '../services/database_service.dart';

/// Service for providing search autocomplete suggestions
class SearchAutocompleteService extends ChangeNotifier {
  final MagentoApiService _magentoApiService = MagentoApiService();
  final DatabaseService _databaseService = DatabaseService();
  
  List<String> _suggestions = [];
  bool _isLoading = false;
  String? _error;
  
  List<String> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Timer? _debounceTimer;
  
  /// Get autocomplete suggestions for a query
  Future<void> getSuggestions(String query) async {
    if (query.trim().isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }
    
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Debounce the search
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await _performSearch(query);
    });
  }
  
  Future<void> _performSearch(String query) async {
    _setLoading(true);
    _error = null;
    
    try {
      await _databaseService.initialize();
      
      // Get suggestions from multiple sources
      final List<String> allSuggestions = [];
      
      // 1. Search history
      final searchHistory = await _databaseService.getSearchHistory(limit: 5);
      final historySuggestions = searchHistory
          .where((item) => item['query'].toString().toLowerCase().contains(query.toLowerCase()))
          .map((item) => item['query'].toString())
          .toList();
      allSuggestions.addAll(historySuggestions);
      
      // 2. Product names from Magento
      try {
        final products = await _magentoApiService.searchProducts(
          query: query,
          page: 1,
          pageSize: 5,
        );
        final productSuggestions = products.items
            .map((product) => product.name)
            .toList();
        allSuggestions.addAll(productSuggestions);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to get product suggestions: $e');
        }
      }
      
      // 3. Common tax lien terms
      final commonTerms = _getCommonTaxLienTerms(query);
      allSuggestions.addAll(commonTerms);
      
      // Remove duplicates and limit results
      _suggestions = allSuggestions
          .toSet()
          .toList()
          .take(10)
          .toList();
      
    } catch (e) {
      _error = e.toString();
      _suggestions = [];
    } finally {
      _setLoading(false);
    }
  }
  
  List<String> _getCommonTaxLienTerms(String query) {
    final commonTerms = [
      'Florida tax liens',
      'California tax liens',
      'Texas tax liens',
      'New York tax liens',
      'Miami-Dade County',
      'Los Angeles County',
      'Harris County',
      'Kings County',
      'residential property',
      'commercial property',
      'vacant land',
      'high interest rate',
      'low interest rate',
      'foreclosure',
      'redemption period',
    ];
    
    return commonTerms
        .where((term) => term.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  /// Save search query to history
  Future<void> saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    
    try {
      await _databaseService.initialize();
      await _databaseService.saveSearchHistory(query: query);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save search query: $e');
      }
    }
  }
  
  /// Clear search suggestions
  void clearSuggestions() {
    _suggestions = [];
    notifyListeners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
