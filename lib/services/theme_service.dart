import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing the FreeDome Manager application theme
/// Allows switching between light and dark themes
class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'freedome_theme';
  
  ThemeMode _themeMode = ThemeMode.system;
  
  /// Current theme mode
  ThemeMode get themeMode => _themeMode;
  
  /// Whether the theme is dark
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
  
  /// Whether the theme is light
  bool get isLightMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.light;
    }
    return _themeMode == ThemeMode.light;
  }
  
  /// Initialize the service
  Future<void> initialize() async {
    await _loadThemeMode();
  }
  
  /// Load saved theme mode
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      // In case of error, use system theme
      _themeMode = ThemeMode.system;
    }
  }
  
  /// Save theme mode
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
    } catch (e) {
      // Ignore save errors
    }
  }
  
  /// Set light theme
  Future<void> setLightTheme() async {
    if (_themeMode != ThemeMode.light) {
      _themeMode = ThemeMode.light;
      await _saveThemeMode();
      notifyListeners();
    }
  }
  
  /// Set dark theme
  Future<void> setDarkTheme() async {
    if (_themeMode != ThemeMode.dark) {
      _themeMode = ThemeMode.dark;
      await _saveThemeMode();
      notifyListeners();
    }
  }
  
  /// Set system theme
  Future<void> setSystemTheme() async {
    if (_themeMode != ThemeMode.system) {
      _themeMode = ThemeMode.system;
      await _saveThemeMode();
      notifyListeners();
    }
  }
  
  /// Toggle theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setDarkTheme();
    } else if (_themeMode == ThemeMode.dark) {
      await setSystemTheme();
    } else {
      await setLightTheme();
    }
  }
  
  /// Get current theme name
  String getThemeName() {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
  
  /// Get current theme description
  String getThemeDescription() {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light theme for daytime use';
      case ThemeMode.dark:
        return 'Dark theme for nighttime use';
      case ThemeMode.system:
        return 'Automatic switching based on system settings';
    }
  }
  
  /// Get current theme icon
  IconData getThemeIcon() {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.wb_sunny;
      case ThemeMode.dark:
        return Icons.nightlight_round;
      case ThemeMode.system:
        return Icons.settings_system_daydream;
    }
  }
  
  /// Get list of available themes
  List<ThemeOption> getAvailableThemes() {
    return [
      ThemeOption(
        mode: ThemeMode.light,
        name: 'Light',
        description: 'Light theme for daytime use',
        icon: Icons.wb_sunny,
      ),
      ThemeOption(
        mode: ThemeMode.dark,
        name: 'Dark',
        description: 'Dark theme for nighttime use',
        icon: Icons.nightlight_round,
      ),
      ThemeOption(
        mode: ThemeMode.system,
        name: 'System',
        description: 'Automatic switching based on system settings',
        icon: Icons.settings_system_daydream,
      ),
    ];
  }
}

/// Theme option for selection
class ThemeOption {
  final ThemeMode mode;
  final String name;
  final String description;
  final IconData icon;
  
  const ThemeOption({
    required this.mode,
    required this.name,
    required this.description,
    required this.icon,
  });
} 