import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for loading offline data from .rada files
/// Handles reading, parsing, and caching of preload data
class OfflineDataLoaderService extends ChangeNotifier {
  // Маппинг штатов к .rada файлам
  static const Map<String, String> stateRadaFiles = {
    'FL': 'assets/taxlien_florida.rada',
    'AZ': 'assets/taxlien_arizona.rada',
    'ALL': 'assets/taxlien_data.rada',
    'DEMO': 'assets/taxlien_demo.rada',
    'DEFAULT': 'assets/taxlien.rada',
  };

  static const String _cacheKeyPrefix = 'offline_data_';
  static const String _lastLoadKey = 'offline_data_last_load';
  static const String _dataVersionKey = 'offline_data_version';
  static const String _selectedStatesKey = 'selected_rada_states';

  bool _isLoading = false;
  bool _isLoaded = false;
  String? _error;
  Map<String, dynamic>? _cachedData;
  DateTime? _lastLoadTime;
  Set<String> _selectedStates = {'ALL'}; // По умолчанию все данные

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  String? get error => _error;
  DateTime? get lastLoadTime => _lastLoadTime;
  Map<String, dynamic>? get cachedData => _cachedData;
  Set<String> get selectedStates => Set.from(_selectedStates);
  bool get isMultipleStates => _selectedStates.length > 1;
  String get selectedState =>
      _selectedStates.first; // Для обратной совместимости

  /// Initialize and load offline data
  Future<bool> initialize() async {
    try {
      _setLoading(true);
      _error = null;

      // Загрузить сохраненные предпочтения штатов
      await _loadStatePreferences();

      // Try to load from cache first
      final cachedSuccess = await _loadFromCache();
      if (cachedSuccess) {
        _isLoaded = true;
        _setLoading(false);
        return true;
      }

      // Load from .rada files based on selection
      final fileSuccess = await loadSelectedStates();

      _setLoading(false);
      return fileSuccess;
    } catch (e) {
      _error = 'Failed to initialize offline data: $e';
      _setLoading(false);
      return false;
    }
  }

  /// Load saved state preferences
  Future<void> _loadStatePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedStates = prefs.getStringList(_selectedStatesKey);

      if (savedStates != null && savedStates.isNotEmpty) {
        _selectedStates = savedStates.toSet();
        if (kDebugMode) {
          print('Loaded saved state selection: ${_selectedStates.join(", ")}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading state preferences: $e');
      }
    }
  }

  /// Load data from selected .rada files
  Future<bool> loadSelectedStates() async {
    try {
      _setLoading(true);

      if (kDebugMode) {
        print('Loading offline data for states: ${_selectedStates.join(", ")}');
      }

      Map<String, dynamic> combinedData = {'products': [], 'categories': []};

      if (_selectedStates.contains('ALL')) {
        // Загружаем основной файл со всеми данными
        final success = await _loadSingleFile(
          stateRadaFiles['ALL']!,
          combinedData,
        );

        if (!success) {
          throw Exception('Failed to load ALL states file');
        }
      } else {
        // Загружаем и комбинируем несколько файлов
        for (var state in _selectedStates) {
          if (stateRadaFiles.containsKey(state)) {
            await _loadAndMergeFile(
              stateRadaFiles[state]!,
              state,
              combinedData,
            );
          }
        }
      }

      _cachedData = combinedData;
      _lastLoadTime = DateTime.now();
      _isLoaded = true;
      _error = null;

      // Cache the loaded data
      await _saveToCache(combinedData);

      if (kDebugMode) {
        print('Successfully loaded offline data');
        print('States: ${_selectedStates.join(", ")}');
        print('Total products: ${(combinedData['products'] as List).length}');
        print(
          'Total categories: ${(combinedData['categories'] as List).length}',
        );
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to load from .rada files: $e';
      if (kDebugMode) {
        print('Error loading .rada files: $e');
      }
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Load data from .rada file (legacy method)
  Future<bool> loadFromRadaFile() async {
    return await loadSelectedStates();
  }

  /// Load single file
  Future<bool> _loadSingleFile(
    String filePath,
    Map<String, dynamic> targetData,
  ) async {
    try {
      if (kDebugMode) {
        print('Loading: $filePath');
      }

      // Load the .rada file as bytes
      final ByteData data = await rootBundle.load(filePath);
      final bytes = data.buffer.asUint8List();

      // Parse .rada file format
      final jsonString = utf8.decode(bytes);
      final parsedData = json.decode(jsonString) as Map<String, dynamic>;

      // Copy all data
      targetData.addAll(parsedData);

      if (kDebugMode) {
        print('✓ Successfully loaded: $filePath');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('✗ Failed to load $filePath: $e');
      }
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

  /// Get all counties data from .rada files
  Future<Map<String, List<Map<String, dynamic>>>> getCountiesData() async {
    if (_cachedData == null) {
      await initialize();
    }

    if (_cachedData == null) return {};

    try {
      final countiesData = _cachedData!['counties'] as Map<String, dynamic>?;
      if (countiesData == null) return {};

      final result = <String, List<Map<String, dynamic>>>{};
      countiesData.forEach((state, counties) {
        if (counties is List) {
          result[state] = counties.cast<Map<String, dynamic>>();
        }
      });

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting counties data: $e');
      }
      return {};
    }
  }

  /// Get counties for a specific state
  Future<List<Map<String, dynamic>>> getCountiesForState(
    String stateCode,
  ) async {
    final allCounties = await getCountiesData();
    return allCounties[stateCode] ?? [];
  }

  /// Get county by name and state
  Future<Map<String, dynamic>?> getCountyByName(
    String stateCode,
    String countyName,
  ) async {
    final counties = await getCountiesForState(stateCode);
    try {
      return counties.firstWhere(
        (county) =>
            county['name']?.toString().toLowerCase() ==
            countyName.toLowerCase(),
      );
    } catch (e) {
      return null;
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

  /// Get list of county names for a state from products or counties data
  Future<List<String>> getCountyNamesForState(String state) async {
    if (_cachedData == null) {
      await initialize();
    }

    if (_cachedData == null) return [];

    try {
      // First try to get from counties data structure
      final countiesData = await getCountiesForState(state);
      if (countiesData.isNotEmpty) {
        return countiesData
            .map((c) => c['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList()
          ..sort();
      }

      // Fallback: extract from products
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
      return {'error': e.toString()};
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

  /// Set selected states and reload data
  Future<bool> setSelectedStates(Set<String> states) async {
    if (states.isEmpty) {
      _error = 'At least one state must be selected';
      return false;
    }

    _selectedStates = states;

    // Сохранить выбор
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_selectedStatesKey, states.toList());

      if (kDebugMode) {
        print('Saved state selection: ${states.join(", ")}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving state selection: $e');
      }
    }

    // Очистить кеш и загрузить новые данные
    await clearCache();
    return await loadSelectedStates();
  }

  /// Get list of available RADA states
  List<String> getAvailableRadaStates() {
    return stateRadaFiles.keys.toList();
  }

  /// Get data size estimate for a state
  Future<Map<String, int>> getStateDataSize(String state) async {
    if (!stateRadaFiles.containsKey(state)) {
      return {'products': 0, 'categories': 0, 'file_size_kb': 0};
    }

    try {
      final filePath = stateRadaFiles[state]!;
      final ByteData data = await rootBundle.load(filePath);
      final bytes = data.buffer.asUint8List();
      final jsonString = utf8.decode(bytes);
      final parsedData = json.decode(jsonString) as Map<String, dynamic>;

      return {
        'products': (parsedData['products'] as List?)?.length ?? 0,
        'categories': (parsedData['categories'] as List?)?.length ?? 0,
        'file_size_kb': (bytes.length / 1024).round(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting size for $state: $e');
      }
      return {'products': 0, 'categories': 0, 'file_size_kb': 0};
    }
  }

  /// Load and merge data from a specific file
  Future<void> _loadAndMergeFile(
    String filePath,
    String state,
    Map<String, dynamic> targetData,
  ) async {
    try {
      final ByteData data = await rootBundle.load(filePath);
      final bytes = data.buffer.asUint8List();
      final jsonString = utf8.decode(bytes);
      final parsedData = json.decode(jsonString) as Map<String, dynamic>;

      // Merge products
      if (parsedData.containsKey('products')) {
        final products = parsedData['products'] as List;
        (targetData['products'] as List).addAll(products);
      }

      // Merge categories (avoid duplicates)
      if (parsedData.containsKey('categories')) {
        final categories = parsedData['categories'] as List;
        final existingIds = (targetData['categories'] as List)
            .map((c) => c['id'])
            .toSet();

        for (var category in categories) {
          if (!existingIds.contains(category['id'])) {
            (targetData['categories'] as List).add(category);
          }
        }
      }

      if (kDebugMode) {
        print('Merged data from $filePath for state $state');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading $filePath: $e');
      }
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
