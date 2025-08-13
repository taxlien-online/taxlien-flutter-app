import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const String _systemLanguage = 'system';
  
  Locale? _currentLocale;
  bool _isSystemLanguage = true;
  
  Locale? get currentLocale => _currentLocale;
  bool get isSystemLanguage => _isSystemLanguage;
  
  // Check if current language is English
  bool get isEnglish => getCurrentLanguageCode() == 'en';
  
  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('ru', 'RU'), // Russian
    Locale('uk', 'UA'), // Ukrainian
    Locale('en', 'US'), // English
    Locale('my', 'MM'), // Burmese
    Locale('zh', 'CN'), // Chinese
    Locale('th', 'TH'), // Thai
    Locale('hi', 'IN'), // Hindi
    Locale('ar', 'SA'), // Arabic
    Locale('de', 'DE'), // German
    Locale('km', 'KH'), // Khmer
    Locale('pl', 'PL'), // Polish
    Locale('ja', 'JP'), // Japanese
    Locale('lo', 'LA'), // Lao
    Locale('he', 'IL'), // Hebrew
    Locale('fi', 'FI'), // Finnish
    Locale('et', 'EE'), // Estonian
  ];
  
  // Get system locale
  static Locale getSystemLocale() {
    try {
      final String systemLocale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      return supportedLocales.firstWhere(
        (locale) => locale.languageCode == systemLocale,
        orElse: () => const Locale('en', 'US'),
      );
    } catch (e) {
      // Fallback in case of error
      print('Error getting system locale: $e');
      return const Locale('en', 'US');
    }
  }
  
  // Initialize service
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    
    if (savedLanguage == null || savedLanguage == _systemLanguage) {
      _isSystemLanguage = true;
      _currentLocale = getSystemLocale();
    } else {
      _isSystemLanguage = false;
      _currentLocale = Locale(savedLanguage);
    }
    
    notifyListeners();
  }
  
  // Set language
  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (languageCode == _systemLanguage) {
      _isSystemLanguage = true;
      _currentLocale = getSystemLocale();
      await prefs.setString(_languageKey, _systemLanguage);
    } else {
      _isSystemLanguage = false;
      _currentLocale = Locale(languageCode);
      await prefs.setString(_languageKey, languageCode);
    }
    
    notifyListeners();
  }
  
  // Get current language
  String getCurrentLanguageCode() {
    if (_currentLocale == null) {
      return 'en'; // Fallback value
    }
    return _currentLocale!.languageCode;
  }
  
  // Get language name
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'Русский';
      case 'uk':
        return 'Українська';
      case 'en':
        return 'English';
      case 'my':
        return 'မြန်မာ';
      case 'zh':
        return '中文';
      case 'th':
        return 'ไทย';
      case 'hi':
        return 'हिन्दी';
      case 'ar':
        return 'العربية';
      case 'de':
        return 'Deutsch';
      case 'km':
        return 'ខ្មែរ';
      case 'pl':
        return 'Polski';
      case 'ja':
        return '日本語';
      case 'lo':
        return 'ລາວ';
      case 'he':
        return 'עברית';
      case 'fi':
        return 'Suomi';
      case 'et':
        return 'Eesti';
      case _systemLanguage:
        return 'System';
      default:
        return 'English';
    }
  }
  
  // Get list of available languages
  List<Map<String, String>> getAvailableLanguages() {
    return [
      {'code': _systemLanguage, 'name': getLanguageName(_systemLanguage)},
      {'code': 'ru', 'name': getLanguageName('ru')},
      {'code': 'uk', 'name': getLanguageName('uk')},
      {'code': 'en', 'name': getLanguageName('en')},
      {'code': 'my', 'name': getLanguageName('my')},
      {'code': 'zh', 'name': getLanguageName('zh')},
      {'code': 'th', 'name': getLanguageName('th')},
      {'code': 'hi', 'name': getLanguageName('hi')},
      {'code': 'ar', 'name': getLanguageName('ar')},
      {'code': 'de', 'name': getLanguageName('de')},
      {'code': 'km', 'name': getLanguageName('km')},
      {'code': 'pl', 'name': getLanguageName('pl')},
      {'code': 'ja', 'name': getLanguageName('ja')},
      {'code': 'lo', 'name': getLanguageName('lo')},
      {'code': 'he', 'name': getLanguageName('he')},
      {'code': 'fi', 'name': getLanguageName('fi')},
      {'code': 'et', 'name': getLanguageName('et')},
    ];
  }
  
  // Quick language toggle between main languages
  Future<void> toggleLanguage() async {
    final currentCode = getCurrentLanguageCode();
    
    // Cyclical switching between main languages
    switch (currentCode) {
      case 'en':
        await setLanguage('ru');
        break;
      case 'ru':
        await setLanguage('zh');
        break;
      case 'zh':
        await setLanguage('en');
        break;
      default:
        await setLanguage('en');
        break;
    }
  }
} 