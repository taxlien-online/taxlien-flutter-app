import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for secure storage
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  /// Initialize secure storage service
  static Future<void> initialize() async {
    // Initialize secure storage
    debugPrint('SecureStorageService: Initialized');
  }
  
  /// Save string securely
  static Future<void> saveString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  /// Get string securely
  static Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }
  
  /// Save boolean securely
  static Future<void> saveBool(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }
  
  /// Get boolean securely
  static Future<bool?> getBool(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }
  
  /// Save integer securely
  static Future<void> saveInt(String key, int value) async {
    await _storage.write(key: key, value: value.toString());
  }
  
  /// Get integer securely
  static Future<int?> getInt(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return int.tryParse(value);
  }
  
  /// Delete value
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
  
  /// Delete all values
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
  
  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
  
  /// Get all keys
  static Future<List<String>> getAllKeys() async {
    return await _storage.readAll().then((map) => map.keys.toList());
  }
}
