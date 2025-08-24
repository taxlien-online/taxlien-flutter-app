import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing application localization
class LocalizationService {
  static const String _localeKey = 'app_locale';
  
  /// Get saved locale
  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey) ?? 'en_US';
    return _localeFromString(localeString);
  }
  
  /// Save locale
  static Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, _localeToString(locale));
  }
  
  /// Convert locale to string
  static String _localeToString(Locale locale) {
    return '${locale.languageCode}_${locale.countryCode}';
  }
  
  /// Convert string to locale
  static Locale _localeFromString(String localeString) {
    final parts = localeString.split('_');
    if (parts.length >= 2) {
      return Locale(parts[0], parts[1]);
    }
    return const Locale('en', 'US');
  }
  
  /// Get supported locales
  static List<Locale> getSupportedLocales() {
    return const [
      Locale('en', 'US'),
      Locale('es', 'ES'),
      Locale('fr', 'FR'),
      Locale('de', 'DE'),
      Locale('ru', 'RU'),
    ];
  }
  
  /// Get locale name
  static String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'ru':
        return 'Русский';
      default:
        return 'English';
    }
  }
}
