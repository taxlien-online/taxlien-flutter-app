import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Data provider for onboarding management
/// Implements CRUD operations for onboarding pages
class OnboardingDataProvider {
  static const String _storageKey = 'onboarding_pages';
  static const String _configKey = 'onboarding_config';

  /// Get list of onboarding pages
  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? sortField,
    String? sortOrder,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? pagesJson = prefs.getString(_storageKey);

      if (pagesJson == null) {
        // Return default onboarding pages
        final defaultPages = _getDefaultPages();
        return {
          'data': defaultPages,
          'total': defaultPages.length,
        };
      }

      final List<dynamic> pages = json.decode(pagesJson);
      final List<Map<String, dynamic>> pagesList =
          pages.cast<Map<String, dynamic>>();

      // Sort if needed
      if (sortField != null) {
        pagesList.sort((a, b) {
          final aValue = a[sortField];
          final bValue = b[sortField];
          final comparison = aValue.toString().compareTo(bValue.toString());
          return sortOrder == 'DESC' ? -comparison : comparison;
        });
      }

      return {
        'data': pagesList,
        'total': pagesList.length,
      };
    } catch (e) {
      return {
        'data': _getDefaultPages(),
        'total': 4,
      };
    }
  }

  /// Get single onboarding page by ID
  Future<Map<String, dynamic>> getOne(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? pagesJson = prefs.getString(_storageKey);

      if (pagesJson == null) {
        throw Exception('Page not found');
      }

      final List<dynamic> pages = json.decode(pagesJson);
      final page = pages.firstWhere((p) => p['id'] == id);
      return page as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Page not found: $e');
    }
  }

  /// Create new onboarding page
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? pagesJson = prefs.getString(_storageKey);

      List<Map<String, dynamic>> pages;
      if (pagesJson == null) {
        pages = _getDefaultPages();
      } else {
        final List<dynamic> pagesList = json.decode(pagesJson);
        pages = pagesList.cast<Map<String, dynamic>>();
      }

      // Add new page
      final newPage = Map<String, dynamic>.from(data);
      newPage['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      newPage['createdAt'] = DateTime.now().toIso8601String();
      pages.add(newPage);

      // Save
      await prefs.setString(_storageKey, json.encode(pages));

      return newPage;
    } catch (e) {
      throw Exception('Failed to create page: $e');
    }
  }

  /// Update onboarding page
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? pagesJson = prefs.getString(_storageKey);

      if (pagesJson == null) {
        throw Exception('Page not found');
      }

      final List<dynamic> pagesList = json.decode(pagesJson);
      final pages = pagesList.cast<Map<String, dynamic>>();

      final index = pages.indexWhere((p) => p['id'] == id);
      if (index == -1) {
        throw Exception('Page not found');
      }

      // Update page
      pages[index] = {
        ...pages[index],
        ...data,
        'id': id,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Save
      await prefs.setString(_storageKey, json.encode(pages));

      return pages[index];
    } catch (e) {
      throw Exception('Failed to update page: $e');
    }
  }

  /// Delete onboarding page
  Future<void> delete(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? pagesJson = prefs.getString(_storageKey);

      if (pagesJson == null) {
        throw Exception('Page not found');
      }

      final List<dynamic> pagesList = json.decode(pagesJson);
      final pages = pagesList.cast<Map<String, dynamic>>();

      pages.removeWhere((p) => p['id'] == id);

      // Save
      await prefs.setString(_storageKey, json.encode(pages));
    } catch (e) {
      throw Exception('Failed to delete page: $e');
    }
  }

  /// Get onboarding configuration
  Future<Map<String, dynamic>> getConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? configJson = prefs.getString(_configKey);

      if (configJson == null) {
        return _getDefaultConfig();
      }

      return json.decode(configJson) as Map<String, dynamic>;
    } catch (e) {
      return _getDefaultConfig();
    }
  }

  /// Update onboarding configuration
  Future<Map<String, dynamic>> updateConfig(Map<String, dynamic> config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_configKey, json.encode(config));
      return config;
    } catch (e) {
      throw Exception('Failed to update config: $e');
    }
  }

  /// Reset to default onboarding pages
  Future<void> resetToDefault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaultPages = _getDefaultPages();
      await prefs.setString(_storageKey, json.encode(defaultPages));

      final defaultConfig = _getDefaultConfig();
      await prefs.setString(_configKey, json.encode(defaultConfig));
    } catch (e) {
      throw Exception('Failed to reset: $e');
    }
  }

  /// Get default onboarding pages
  List<Map<String, dynamic>> _getDefaultPages() {
    return [
      {
        'id': '1',
        'order': 0,
        'title': 'Добро пожаловать в TaxLien Marketplace',
        'subtitle': 'Платформа для инвестирования в налоговые закладные',
        'description':
            'Откройте для себя мир прибыльных инвестиций в налоговые закладные. Получайте высокие проценты и диверсифицируйте свой портфель.',
        'iconName': 'trending_up',
        'colorHex': '#2196F3',
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'order': 1,
        'title': 'Как это работает',
        'subtitle': 'Простой процесс инвестирования',
        'description':
            '1. Выберите налоговую закладную\n2. Разместите ставку\n3. Получайте проценты\n4. Дождитесь погашения или выкупа',
        'iconName': 'how_to_reg',
        'colorHex': '#4CAF50',
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '3',
        'order': 2,
        'title': 'Безопасность и надежность',
        'subtitle': 'Ваши инвестиции под защитой',
        'description':
            'Все сделки защищены законодательством. Налоговые закладные - это обеспеченные инвестиции с государственной гарантией.',
        'iconName': 'security',
        'colorHex': '#FF9800',
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '4',
        'order': 3,
        'title': 'Начните инвестировать',
        'subtitle': 'Присоединяйтесь к тысячам инвесторов',
        'description':
            'Создайте аккаунт и начните инвестировать уже сегодня. Минимальная сумма инвестиций от \$100.',
        'iconName': 'rocket_launch',
        'colorHex': '#9C27B0',
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];
  }

  /// Get default configuration
  Map<String, dynamic> _getDefaultConfig() {
    return {
      'id': 'default',
      'version': '1.0.0',
      'enabled': true,
      'canSkip': true,
      'pageIds': ['1', '2', '3', '4'],
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

