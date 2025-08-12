import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServerConfig {
  final String host;
  final int port;
  final String? name;
  final DateTime lastUsed;

  ServerConfig({
    required this.host,
    required this.port,
    this.name,
    required this.lastUsed,
  });

  String get url => 'http://$host:$port';
  String get wsUrl => 'ws://$host:$port';

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'port': port,
      'name': name,
      'lastUsed': lastUsed.toIso8601String(),
    };
  }

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
      host: json['host'],
      port: json['port'],
      name: json['name'],
      lastUsed: DateTime.parse(json['lastUsed']),
    );
  }
}

class ServerConfigService {
  static const String _serversKey = 'saved_servers';
  static const String _currentServerKey = 'current_server';
  
  List<ServerConfig> _savedServers = [];
  ServerConfig? _currentServer;
  
  // Геттеры
  List<ServerConfig> get savedServers => List.unmodifiable(_savedServers);
  ServerConfig? get currentServer => _currentServer;
  
  // Инициализация
  Future<void> initialize() async {
    await _loadSavedServers();
    await _loadCurrentServer();
  }
  
  // Загрузка сохраненных серверов
  Future<void> _loadSavedServers() async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = prefs.getStringList(_serversKey) ?? [];
    
    _savedServers = serversJson
        .map((json) => ServerConfig.fromJson(jsonDecode(json)))
        .toList();
    
    // Сортировка по времени последнего использования
    _savedServers.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  }
  
  // Загрузка текущего сервера
  Future<void> _loadCurrentServer() async {
    final prefs = await SharedPreferences.getInstance();
    final currentServerJson = prefs.getString(_currentServerKey);
    
    if (currentServerJson != null) {
      _currentServer = ServerConfig.fromJson(jsonDecode(currentServerJson));
    }
  }
  
  // Сохранение серверов
  Future<void> _saveServers() async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = _savedServers
        .map((server) => jsonEncode(server.toJson()))
        .toList();
    
    await prefs.setStringList(_serversKey, serversJson);
  }
  
  // Сохранение текущего сервера
  Future<void> _saveCurrentServer() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_currentServer != null) {
      await prefs.setString(_currentServerKey, jsonEncode(_currentServer!.toJson()));
    } else {
      await prefs.remove(_currentServerKey);
    }
  }
  
  // Добавление нового сервера
  Future<void> addServer(String host, int port, {String? name}) async {
    final server = ServerConfig(
      host: host,
      port: port,
      name: name ?? '$host:$port',
      lastUsed: DateTime.now(),
    );
    
    // Удаляем существующий сервер с таким же адресом
    _savedServers.removeWhere((s) => s.host == host && s.port == port);
    
    // Добавляем новый сервер в начало списка
    _savedServers.insert(0, server);
    
    // Ограничиваем количество сохраненных серверов
    if (_savedServers.length > 10) {
      _savedServers = _savedServers.take(10).toList();
    }
    
    await _saveServers();
  }
  
  // Установка текущего сервера
  Future<void> setCurrentServer(ServerConfig server) async {
    _currentServer = server;
    
    // Обновляем время последнего использования
    final updatedServer = ServerConfig(
      host: server.host,
      port: server.port,
      name: server.name,
      lastUsed: DateTime.now(),
    );
    
    // Обновляем в списке сохраненных серверов
    final index = _savedServers.indexWhere((s) => s.host == server.host && s.port == server.port);
    if (index != -1) {
      _savedServers[index] = updatedServer;
    } else {
      _savedServers.insert(0, updatedServer);
    }
    
    // Сортируем по времени использования
    _savedServers.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    
    await _saveServers();
    await _saveCurrentServer();
  }
  
  // Удаление сервера
  Future<void> removeServer(ServerConfig server) async {
    _savedServers.removeWhere((s) => s.host == server.host && s.port == server.port);
    
    // Если удаляем текущий сервер, очищаем его
    if (_currentServer?.host == server.host && _currentServer?.port == server.port) {
      _currentServer = null;
      await _saveCurrentServer();
    }
    
    await _saveServers();
  }
  
  // Очистка текущего сервера
  Future<void> clearCurrentServer() async {
    _currentServer = null;
    await _saveCurrentServer();
  }
  
  // Проверка доступности сервера
  Future<bool> testServerConnection(String host, int port) async {
    try {
      final response = await http
          .get(Uri.parse('http://$host:$port/api/status'))
          .timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // Автоматическое обнаружение серверов в локальной сети
  Future<List<ServerConfig>> discoverServers() async {
    final discoveredServers = <ServerConfig>[];
    final commonPorts = [3000, 8080, 8000, 5000];
    
    // Генерируем IP адреса для локальной сети (192.168.x.x)
    for (int i = 1; i <= 254; i++) {
      final host = '192.168.1.$i';
      
      for (final port in commonPorts) {
        try {
          final isAvailable = await testServerConnection(host, port);
          if (isAvailable) {
            discoveredServers.add(ServerConfig(
              host: host,
              port: port,
              name: 'Discovered Server ($host:$port)',
              lastUsed: DateTime.now(),
            ));
          }
        } catch (e) {
          // Игнорируем ошибки при сканировании
        }
      }
    }
    
    return discoveredServers;
  }
  
  // Получение информации о сервере
  Future<Map<String, dynamic>?> getServerInfo(String host, int port) async {
    try {
      final response = await http
          .get(Uri.parse('http://$host:$port/'))
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Игнорируем ошибки
    }
    
    return null;
  }
} 