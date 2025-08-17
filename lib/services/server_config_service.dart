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
  
  // Getters
  List<ServerConfig> get savedServers => List.unmodifiable(_savedServers);
  ServerConfig? get currentServer => _currentServer;
  
  // Initialization
  Future<void> initialize() async {
    await _loadSavedServers();
    await _loadCurrentServer();
  }
  
  // Load saved servers
  Future<void> _loadSavedServers() async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = prefs.getStringList(_serversKey) ?? [];
    
    _savedServers = serversJson
        .map((json) => ServerConfig.fromJson(jsonDecode(json)))
        .toList();
    
    // Sort by last used time
    _savedServers.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  }
  
  // Load current server
  Future<void> _loadCurrentServer() async {
    final prefs = await SharedPreferences.getInstance();
    final currentServerJson = prefs.getString(_currentServerKey);
    
    if (currentServerJson != null) {
      _currentServer = ServerConfig.fromJson(jsonDecode(currentServerJson));
    }
  }
  
  // Save servers
  Future<void> _saveServers() async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = _savedServers
        .map((server) => jsonEncode(server.toJson()))
        .toList();
    
    await prefs.setStringList(_serversKey, serversJson);
  }
  
  // Save current server
  Future<void> _saveCurrentServer() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_currentServer != null) {
      await prefs.setString(_currentServerKey, jsonEncode(_currentServer!.toJson()));
    } else {
      await prefs.remove(_currentServerKey);
    }
  }
  
  // Add new server
  Future<void> addServer(String host, int port, {String? name}) async {
    final server = ServerConfig(
      host: host,
      port: port,
      name: name ?? '$host:$port',
      lastUsed: DateTime.now(),
    );
    
    // Remove existing server with same address
    _savedServers.removeWhere((s) => s.host == host && s.port == port);
    
    // Add new server to the beginning of the list
    _savedServers.insert(0, server);
    
    // Limit number of saved servers
    if (_savedServers.length > 10) {
      _savedServers = _savedServers.take(10).toList();
    }
    
    await _saveServers();
  }
  
  // Set current server
  Future<void> setCurrentServer(ServerConfig server) async {
    _currentServer = server;
    
    // Update last used time
    final updatedServer = ServerConfig(
      host: server.host,
      port: server.port,
      name: server.name,
      lastUsed: DateTime.now(),
    );
    
    // Update in saved servers list
    final index = _savedServers.indexWhere((s) => s.host == server.host && s.port == server.port);
    if (index != -1) {
      _savedServers[index] = updatedServer;
    } else {
      _savedServers.insert(0, updatedServer);
    }
    
    // Sort by usage time
    _savedServers.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    
    await _saveServers();
    await _saveCurrentServer();
  }
  
  // Remove server
  Future<void> removeServer(ServerConfig server) async {
    _savedServers.removeWhere((s) => s.host == server.host && s.port == server.port);
    
    // If removing current server, clear it
    if (_currentServer?.host == server.host && _currentServer?.port == server.port) {
      _currentServer = null;
      await _saveCurrentServer();
    }
    
    await _saveServers();
  }
  
  // Clear current server
  Future<void> clearCurrentServer() async {
    _currentServer = null;
    await _saveCurrentServer();
  }
  
  // Test server availability
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
  
  // Auto-discovery of servers in local network
  Future<List<ServerConfig>> discoverServers() async {
    final discoveredServers = <ServerConfig>[];
    final commonPorts = [3000, 8080, 8000, 5000];
    
    // Generate IP addresses for local network (192.168.x.x)
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
          // Ignore errors during scanning
        }
      }
    }
    
    return discoveredServers;
  }
  
  // Get server information
  Future<Map<String, dynamic>?> getServerInfo(String host, int port) async {
    try {
      final response = await http
          .get(Uri.parse('http://$host:$port/'))
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Ignore errors
    }
    
    return null;
  }
} 