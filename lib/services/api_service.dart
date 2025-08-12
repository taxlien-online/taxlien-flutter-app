import 'dart:convert';
import 'package:http/http.dart' as http;
import 'server_config_service.dart';

class ApiService {
  ServerConfig? _currentServer;
  
  // Установка текущего сервера
  void setServer(ServerConfig server) {
    _currentServer = server;
  }
  
  // Проверка подключения к серверу
  bool get isConnected => _currentServer != null;
  
  // Базовый URL для запросов
  String? get _baseUrl => _currentServer?.url;
  
  // Выполнение HTTP запроса (приватный метод)
  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    if (_baseUrl == null) {
      throw Exception('Server not configured');
    }
    
    final uri = Uri.parse('$_baseUrl$endpoint');
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    final requestHeaders = {...defaultHeaders, ...?headers};
    
    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(uri, headers: requestHeaders);
      case 'POST':
        return await http.post(
          uri,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          uri,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(uri, headers: requestHeaders);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }
  
  // Получение статуса системы
  Future<Map<String, dynamic>> getStatus() async {
    final response = await _makeRequest('GET', '/api/status');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? data; // Поддержка старого и нового формата
    } else {
      throw Exception('Failed to get status: ${response.statusCode}');
    }
  }
  
  // Управление воспроизведением
  Future<void> play() async {
    await _makeRequest('POST', '/api/play');
  }
  
  Future<void> pause() async {
    await _makeRequest('POST', '/api/pause');
  }
  
  Future<void> stop() async {
    await _makeRequest('POST', '/api/stop');
  }
  
  // Управление яркостью
  Future<void> setBrightness(int brightness) async {
    if (brightness < 0 || brightness > 100) {
      throw Exception('Brightness must be between 0 and 100');
    }
    
    await _makeRequest('POST', '/api/brightness', body: {'value': brightness});
  }
  
  // Управление громкостью
  Future<void> setVolume(int volume) async {
    if (volume < 0 || volume > 100) {
      throw Exception('Volume must be between 0 and 100');
    }
    
    await _makeRequest('POST', '/api/volume', body: {'value': volume});
  }
  
  // Управление поворотом
  Future<void> setRotation(double rotation) async {
    await _makeRequest('POST', '/api/rotation', body: {'value': rotation});
  }
  
  // Управление калибровкой
  Future<void> setCalibration({
    double? x,
    double? y,
    double? scale,
    double? rotation,
  }) async {
    final calibration = <String, dynamic>{};
    if (x != null) calibration['x'] = x;
    if (y != null) calibration['y'] = y;
    if (scale != null) calibration['scale'] = scale;
    if (rotation != null) calibration['rotation'] = rotation;
    
    await _makeRequest('POST', '/api/calibration', body: calibration);
  }
  
  // Управление режимом проекции
  Future<void> setProjectionMode(String mode) async {
    await _makeRequest('POST', '/api/projection-mode', body: {'mode': mode});
  }
  
  // Получение медиафайлов
  Future<List<Map<String, dynamic>>> getMediaFiles() async {
    final response = await _makeRequest('GET', '/api/media');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final files = data['data']?['files'] ?? data['files'] ?? [];
      return List<Map<String, dynamic>>.from(files);
    } else {
      throw Exception('Failed to get media files: ${response.statusCode}');
    }
  }
  
  // Воспроизведение медиафайла
  Future<void> playMediaFile(int fileId) async {
    await _makeRequest('POST', '/api/media/$fileId/play');
  }
  
  // Получение плейлистов
  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final response = await _makeRequest('GET', '/api/playlists');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final playlists = data['data']?['playlists'] ?? data['playlists'] ?? [];
      return List<Map<String, dynamic>>.from(playlists);
    } else {
      throw Exception('Failed to get playlists: ${response.statusCode}');
    }
  }
  
  // Воспроизведение плейлиста
  Future<void> playPlaylist(int playlistId) async {
    await _makeRequest('POST', '/api/playlists/$playlistId/play');
  }
  
  // Получение элементов плейлиста
  Future<List<Map<String, dynamic>>> getPlaylistItems(int playlistId) async {
    final response = await _makeRequest('GET', '/api/playlists/$playlistId/items');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['items'] ?? []);
    } else {
      throw Exception('Failed to get playlist items: ${response.statusCode}');
    }
  }
  
  // Управление стримингом
  Future<List<Map<String, dynamic>>> getStreamingSources() async {
    final response = await _makeRequest('GET', '/api/streaming');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['sources'] ?? []);
    } else {
      throw Exception('Failed to get streaming sources: ${response.statusCode}');
    }
  }
  
  // Воспроизведение стриминга
  Future<void> playStreamingSource(int sourceId) async {
    await _makeRequest('POST', '/api/streaming/$sourceId/play');
  }
  
  // Получение информации о медиа
  Future<Map<String, dynamic>?> getMediaInfo() async {
    final response = await _makeRequest('GET', '/api/media/info');
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
  
  // Управление позицией воспроизведения
  Future<void> seekToPosition(int position) async {
    await _makeRequest('PUT', '/api/media/seek', body: {'position': position});
  }
  
  // Получение логов сервера
  Future<List<String>> getServerLogs() async {
    final response = await _makeRequest('GET', '/api/logs');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['logs'] ?? []);
    } else {
      throw Exception('Failed to get server logs: ${response.statusCode}');
    }
  }
  
  // Проверка здоровья сервера
  Future<bool> healthCheck() async {
    try {
      final response = await _makeRequest('GET', '/api/status');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // Публичный метод для выполнения HTTP запросов
  Future<http.Response> makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return await _makeRequest(method, endpoint, body: body, headers: headers);
  }
} 