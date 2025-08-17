import 'dart:convert';
import 'package:http/http.dart' as http;
import 'server_config_service.dart';

class ApiService {
  ServerConfig? _currentServer;
  
  // Set current server
  void setServer(ServerConfig server) {
    _currentServer = server;
  }
  
  // Check server connection
  bool get isConnected => _currentServer != null;
  
  // Base URL for requests
  String? get _baseUrl => _currentServer?.url;
  
  // Execute HTTP request (private method)
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
  
  // Get system status
  Future<Map<String, dynamic>> getStatus() async {
    final response = await _makeRequest('GET', '/api/status');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? data; // Support for old and new format
    } else {
      throw Exception('Failed to get status: ${response.statusCode}');
    }
  }
  
  // Playback control
  Future<void> play() async {
    await _makeRequest('POST', '/api/play');
  }
  
  Future<void> pause() async {
    await _makeRequest('POST', '/api/pause');
  }
  
  Future<void> stop() async {
    await _makeRequest('POST', '/api/stop');
  }
  
  // Brightness control
  Future<void> setBrightness(int brightness) async {
    if (brightness < 0 || brightness > 100) {
      throw Exception('Brightness must be between 0 and 100');
    }
    
    await _makeRequest('POST', '/api/brightness', body: {'value': brightness});
  }
  
  // Volume control
  Future<void> setVolume(int volume) async {
    if (volume < 0 || volume > 100) {
      throw Exception('Volume must be between 0 and 100');
    }
    
    await _makeRequest('POST', '/api/volume', body: {'value': volume});
  }
  
  // Rotation control
  Future<void> setRotation(double rotation) async {
    await _makeRequest('POST', '/api/rotation', body: {'value': rotation});
  }
  
  // Calibration control
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
  
  // Projection mode control
  Future<void> setProjectionMode(String mode) async {
    await _makeRequest('POST', '/api/projection-mode', body: {'mode': mode});
  }
  

  
  // Get server logs
  Future<List<String>> getServerLogs() async {
    final response = await _makeRequest('GET', '/api/logs');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['logs'] ?? []);
    } else {
      throw Exception('Failed to get server logs: ${response.statusCode}');
    }
  }
  
  // Server health check
  Future<bool> healthCheck() async {
    try {
      final response = await _makeRequest('GET', '/api/status');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // Public method for executing HTTP requests
  Future<http.Response> makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return await _makeRequest(method, endpoint, body: body, headers: headers);
  }
} 