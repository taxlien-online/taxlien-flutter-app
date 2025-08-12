import 'dart:async';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'server_config_service.dart';

class WebSocketService {
  IO.Socket? _socket;
  bool _isConnected = false;
  
  // Стримы для обновлений
  final StreamController<Map<String, dynamic>> _stateController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<bool> _connectionController = 
      StreamController<bool>.broadcast();
  final StreamController<String> _logController = 
      StreamController<String>.broadcast();
  
  // Геттеры
  Stream<Map<String, dynamic>> get stateStream => _stateController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<String> get logStream => _logController.stream;
  bool get isConnected => _isConnected;
  
  // Подключение к серверу
  Future<void> connect(ServerConfig server) async {
    try {
      _logController.add('Connecting to WebSocket at ${server.url}');
      
      // Создаем WebSocket соединение
      _socket = IO.io(server.url, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'timeout': 5000,
      });
      
      // Настройка обработчиков событий
      _setupEventHandlers();
      
      // Подключаемся
      _socket!.connect();
      
    } catch (e) {
      _logController.add('WebSocket connection error: $e');
      _isConnected = false;
      _connectionController.add(false);
    }
  }
  
  // Настройка обработчиков событий
  void _setupEventHandlers() {
    if (_socket == null) return;
    
    _socket!.onConnect((_) {
      _isConnected = true;
      _connectionController.add(true);
      _logController.add('WebSocket connected');
    });
    
    _socket!.onDisconnect((_) {
      _isConnected = false;
      _connectionController.add(false);
      _logController.add('WebSocket disconnected');
    });
    
    _socket!.onConnectError((error) {
      _isConnected = false;
      _connectionController.add(false);
      _logController.add('WebSocket connection error: $error');
    });
    
    _socket!.onError((error) {
      _logController.add('WebSocket error: $error');
    });
    
    // Обработка событий состояния
    _socket!.on('state_update', (data) {
      if (data is Map<String, dynamic>) {
        _stateController.add(data);
      }
    });
    
    _socket!.on('system_status', (data) {
      if (data is Map<String, dynamic>) {
        _stateController.add(data);
      }
    });
  }
  
  // Отправка команды
  Future<void> sendCommand(String command, [Map<String, dynamic>? data]) async {
    if (!_isConnected || _socket == null) {
      _logController.add('Cannot send command: not connected');
      return;
    }
    
    try {
      final payload = {
        'command': command,
        'data': data ?? {},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      _socket!.emit('command', payload);
      _logController.add('Sent command: $command');
    } catch (e) {
      _logController.add('Failed to send command: $e');
    }
  }
  
  // Отключение
  Future<void> disconnect() async {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    
    _isConnected = false;
    _connectionController.add(false);
    _logController.add('WebSocket disconnected');
  }
  
  // Очистка ресурсов
  void dispose() {
    disconnect();
    _stateController.close();
    _connectionController.close();
    _logController.close();
  }
} 