import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for loading offline data from .rada files
/// Handles reading, parsing, and caching of preload data
class OfflineDataLoaderService extends ChangeNotifier {
  static const String _radaFilePath = 'assets/taxlien_data.rada';
  static const String _cacheKeyPrefix = 'offline_data_';
  static const String _lastLoadKey = 'offline_data_last_load';
  static const String _dataVersionKey = 'offline_data_version';

  bool _isLoading = false;
  bool _isLoaded = false;
  String? _error;
  Map<String, dynamic>? _cachedData;
  DateTime? _lastLoadTime;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  String? get error => _error;
  DateTime? get lastLoadTime => _lastLoadTime;
  Map<String, dynamic>? get cachedData => _cachedData;

  /// Initialize and load offline data
  Future<bool> initialize() async {
    try {
      _setLoading(true);
      _error = null;

      // Try to load from cache first
      final cachedSuccess = await _loadFromCache();
      if (cachedSuccess) {
        _isLoaded = true;
        _setLoading(false);
        return true;
      }

      // Load from .rada file
      final fileSuccess = await loadFromRadaFile();

      _setLoading(false);
      return fileSuccess;
    } catch (e) {
      _error = 'Failed to initialize offline data: $e';
      _setLoading(false);
      return false;
    }
  }

  /// Load data from .rada file
  Future<bool> loadFromRadaFile() async {
    try {
      if (kDebugMode) {
        print('Loading offline data from: $_radaFilePath');
      }

      // Load the .rada file as bytes
      final ByteData data = await rootBundle.load(_radaFilePath);
      final bytes = data.buffer.asUint8List();

      // Parse .rada file format
      // .rada files are expected to be JSON format (you can modify this based on actual format)
      final jsonString = utf8.decode(bytes);
      final parsedData = json.decode(jsonString) as Map<String, dynamic>;

      _cachedData = parsedData;
      _lastLoadTime = DateTime.now();
      _isLoaded = true;
      _error = null;

      // Cache the loaded data
      await _saveToCache(parsedData);

      if (kDebugMode) {
        print('Successfully loaded offline data from .rada file');
        print('Data keys: ${parsedData.keys.join(", ")}');
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to load from .rada file: $e';
      if (kDebugMode) {
        print('Error loading .rada file: $e');
      }
      notifyListeners();
      return false;
    }
  }

  /// Load data from cache
  Future<bool> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('${_cacheKeyPrefix}main');
      final lastLoad = prefs.getString(_lastLoadKey);

      if (cachedJson != null) {
        _cachedData = json.decode(cachedJson) as Map<String, dynamic>;
        _lastLoadTime = lastLoad != null ? DateTime.parse(lastLoad) : null;
        _isLoaded = true;

        if (kDebugMode) {
          print('Loaded offline data from cache');
        }

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading from cache: $e');
      }
      return false;
    }
  }

  /// Save data to cache
  Future<void> _saveToCache(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_cacheKeyPrefix}main', json.encode(data));
      await prefs.setString(_lastLoadKey, DateTime.now().toIso8601String());

      if (kDebugMode) {
        print('Saved offline data to cache');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving to cache: $e');
      }
    }
  }

  /// Get all products from offline data
  Future<List<Map<String, dynamic>>> getProducts({
    String? state,
    String? county,
    int? limit,
    int? offset,
  }) async {
    if (_cachedData == null) {
      await initialize();
    }

    if (_cachedData == null) return [];

    try {
      List<dynamic> products = _cachedData!['products'] ?? [];
      List<Map<String, dynamic>> result = products.cast<Map<String, dynamic>>();

      // Filter by state
      if (state != null && state.isNotEmpty) {
        result = result.where((p) {
          final customAttrs = p['custom_attributes'] as List<dynamic>?;
          if (customAttrs == null) return false;

          final stateAttr = customAttrs.firstWhere(
            (attr) => attr['attribute_code'] == 'state',
            orElse: () => null,
          );

          return stateAttr != null && stateAttr['value'] == state;
        }).toList();
      }

      // Filter by county
      if (county != null && county.isNotEmpty) {
        result = result.where((p) {
          final customAttrs = p['custom_attributes'] as List<dynamic>?;
          if (customAttrs == null) return false;

          final countyAttr = customAttrs.firstWhere(
            (attr) => attr['attribute_code'] == 'county',
            orElse: () => null,
          );

          return countyAttr != null && countyAttr['value'] == county;
        }).toList();
      }

      // Apply pagination
      if (offset != null && offset > 0) {
        result = result.skip(offset).toList();
      }

      if (limit != null && limit > 0) {
        result = result.take(limit).toList();
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting products: $e');
      }
      return [];
    }
  }

  /// Get all categories from offline data
  Future<List<Map<String, dynamic>>> getCategories() async {
    if (_cachedData == null) {
      await initialize();
    }

    if (_cachedData == null) return [];

    try {
      List<dynamic> categories = _cachedData!['categories'] ?? [];
      return categories.cast<Map<String, dynamic>>();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting categories: $e');
      }
      return [];
    }
  }

  /// Get list of available states
  Future<List<String>> getAvailableStates() async {
    if (_cachedData == null) {
      await initialize();
    }

    if (_cachedData == null) return [];

    try {
      final categories = await getCategories();
      final states = <String>{};

      for (var category in categories) {
        final customAttrs = category['custom_attributes'] as List<dynamic>?;
        if (customAttrs != null) {
          final stateAttr = customAttrs.firstWhere(
            (attr) => attr['attribute_code'] == 'state_code',
            orElse: () => null,
          );

          if (stateAttr != null) {
            states.add(stateAttr['value'] as String);
          }
        }
      }

      return states.toList()..sort();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting available states: $e');
      }
      return [];
    }
  }

  /// Get list of counties for a state
  Future<List<String>> getCountiesForState(String state) async {
    if (_cachedData == null) {
      await initialize();
    }

    if (_cachedData == null) return [];

    try {
      final products = await getProducts(state: state);
      final counties = <String>{};

      for (var product in products) {
        final customAttrs = product['custom_attributes'] as List<dynamic>?;
        if (customAttrs != null) {
          final countyAttr = customAttrs.firstWhere(
            (attr) => attr['attribute_code'] == 'county',
            orElse: () => null,
          );

          if (countyAttr != null) {
            counties.add(countyAttr['value'] as String);
          }
        }
      }

      return counties.toList()..sort();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting counties for state: $e');
      }
      return [];
    }
  }

  /// Get data statistics
  Future<Map<String, dynamic>> getDataStats() async {
    if (_cachedData == null) {
      await initialize();
    }

    if (_cachedData == null) {
      return {
        'total_products': 0,
        'total_categories': 0,
        'states': 0,
        'last_loaded': null,
      };
    }

    try {
      final products = await getProducts();
      final categories = await getCategories();
      final states = await getAvailableStates();

      return {
        'total_products': products.length,
        'total_categories': categories.length,
        'states': states.length,
        'state_list': states,
        'last_loaded': _lastLoadTime?.toIso8601String(),
        'is_cached': true,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting data stats: $e');
      }
      return {
        'error': e.toString(),
      };
    }
  }

  /// Clear cached data
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_cacheKeyPrefix}main');
      await prefs.remove(_lastLoadKey);
      await prefs.remove(_dataVersionKey);

      _cachedData = null;
      _isLoaded = false;
      _lastLoadTime = null;

      if (kDebugMode) {
        print('Cleared offline data cache');
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cache: $e');
      }
    }
  }

  /// Force reload from .rada file
  Future<bool> reload() async {
    await clearCache();
    return await loadFromRadaFile();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
