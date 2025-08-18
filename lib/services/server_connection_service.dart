import 'dart:async';
import 'server_config_service.dart';
import 'api_service.dart';
import 'websocket_service.dart';
import 'tax_lien_content_service.dart';

class ServerConnectionService {
  final ServerConfigService _configService = ServerConfigService();
  final ApiService _apiService = ApiService();
  final WebSocketService _websocketService = WebSocketService();
  late TaxLienContentService _contentService;
  
  // Streams for state updates
  final StreamController<Map<String, dynamic>> _stateController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<bool> _connectionController = 
      StreamController<bool>.broadcast();
  final StreamController<String> _logController = 
      StreamController<String>.broadcast();
  
  // Getters
  Stream<Map<String, dynamic>> get stateStream => _stateController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<String> get logStream => _logController.stream;
  ServerConfigService get configService => _configService;
  ApiService get apiService => _apiService;
  WebSocketService get websocketService => _websocketService;
  
  // Connection status
  bool get isConnected => _websocketService.isConnected;
  ServerConfig? get currentServer => _configService.currentServer;
  String? get serverAddress => _configService.currentServer?.url;
  
  // Subscriptions
  StreamSubscription? _websocketStateSubscription;
  StreamSubscription? _websocketConnectionSubscription;
  StreamSubscription? _websocketLogSubscription;
  
  // Initialization
  Future<void> initialize() async {
    await _configService.initialize();
    
    // Initialize TaxLienContentService
    _contentService = TaxLienContentService(
      apiService: _apiService,
      configService: _configService,
    );
    
    // Setup WebSocket event subscriptions
    _websocketStateSubscription = _websocketService.stateStream.listen(
      (state) => _stateController.add(state),
    );
    
    _websocketConnectionSubscription = _websocketService.connectionStream.listen(
      (connected) => _connectionController.add(connected),
    );
    
    _websocketLogSubscription = _websocketService.logStream.listen(
      (log) => _logController.add(log),
    );
    
    // Auto-connect to saved server
    if (_configService.currentServer != null) {
      await connectToServer(_configService.currentServer!);
    }
  }
  
  // Connect to server
  Future<bool> connectToServer(ServerConfig server) async {
    try {
      // Check server availability
      final isAvailable = await _configService.testServerConnection(
        server.host, 
        server.port,
      );
      
      if (!isAvailable) {
        _logController.add('Server ${server.url} is not available');
        return false;
      }
      
      // Set server in configuration
      await _configService.setCurrentServer(server);
      
      // Setup API service
      _apiService.setServer(server);
      
      // Connect via WebSocket
      await _websocketService.connect(server);
      
      _logController.add('Successfully connected to ${server.url}');
      return true;
      
    } catch (e) {
      _logController.add('Failed to connect to server: $e');
      return false;
    }
  }
  
  // Disconnect from server
  Future<void> disconnect() async {
    await _websocketService.disconnect();
    await _configService.clearCurrentServer();
    _logController.add('Disconnected from server');
  }
  
  // Reconnect to current server
  Future<bool> reconnect() async {
    if (_configService.currentServer == null) {
      _logController.add('No server configured for reconnection');
      return false;
    }
    
    return await connectToServer(_configService.currentServer!);
  }
  
  // Auto-discovery and connection
  Future<ServerConfig?> autoConnect() async {
    _logController.add('Starting server discovery...');
    
    // First try saved servers
    for (final server in _configService.savedServers) {
      final isAvailable = await _configService.testServerConnection(
        server.host, 
        server.port,
      );
      
      if (isAvailable) {
        _logController.add('Found available saved server: ${server.url}');
        await connectToServer(server);
        return server;
      }
    }
    
    // If saved servers are unavailable, search for new ones
    final discoveredServers = await _configService.discoverServers();
    
    if (discoveredServers.isNotEmpty) {
      final server = discoveredServers.first;
      _logController.add('Found discovered server: ${server.url}');
      
      // Save found server
      await _configService.addServer(server.host, server.port, name: server.name);
      
      await connectToServer(server);
      return server;
    }
    
    _logController.add('No servers found during discovery');
    return null;
  }
  
  // Get system status
  Future<Map<String, dynamic>?> getSystemStatus() async {
    try {
      return await _apiService.getStatus();
    } catch (e) {
      _logController.add('Failed to get system status: $e');
      return null;
    }
  }
  
  // Connection health check
  Future<bool> healthCheck() async {
    try {
      return await _apiService.healthCheck();
    } catch (e) {
      return false;
    }
  }
  
  // Playback control
  Future<void> play() async {
    try {
      await _apiService.play();
      _logController.add('Play command sent');
    } catch (e) {
      _logController.add('Failed to send play command: $e');
      rethrow;
    }
  }
  
  Future<void> pause() async {
    try {
      await _apiService.pause();
      _logController.add('Pause command sent');
    } catch (e) {
      _logController.add('Failed to send pause command: $e');
      rethrow;
    }
  }
  
  Future<void> stop() async {
    try {
      await _apiService.stop();
      _logController.add('Stop command sent');
    } catch (e) {
      _logController.add('Failed to send stop command: $e');
      rethrow;
    }
  }
  
  // Parameter control
  Future<void> setBrightness(int brightness) async {
    try {
      await _apiService.setBrightness(brightness);
      _logController.add('Brightness set to $brightness%');
    } catch (e) {
      _logController.add('Failed to set brightness: $e');
      rethrow;
    }
  }
  
  Future<void> setVolume(int volume) async {
    try {
      await _apiService.setVolume(volume);
      _logController.add('Volume set to $volume%');
    } catch (e) {
      _logController.add('Failed to set volume: $e');
      rethrow;
    }
  }
  
  Future<void> setRotation(double rotation) async {
    try {
      await _apiService.setRotation(rotation);
      _logController.add('Rotation set to $rotation°');
    } catch (e) {
      _logController.add('Failed to set rotation: $e');
      rethrow;
    }
  }
  
  // Calibration control
  Future<void> setCalibration({
    double? x,
    double? y,
    double? scale,
    double? rotation,
  }) async {
    try {
      await _apiService.setCalibration(
        x: x,
        y: y,
        scale: scale,
        rotation: rotation,
      );
      _logController.add('Calibration updated');
    } catch (e) {
      _logController.add('Failed to update calibration: $e');
      rethrow;
    }
  }
  

  
  // Cleanup resources
  void dispose() {
    _websocketStateSubscription?.cancel();
    _websocketConnectionSubscription?.cancel();
    _websocketLogSubscription?.cancel();
    
    _websocketService.dispose();
    _stateController.close();
    _connectionController.close();
    _logController.close();
  }
} 