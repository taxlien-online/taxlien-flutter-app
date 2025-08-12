import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'server_config_service.dart';

class WebSocketService {
  WebSocket? _socket;
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
      _socket = await WebSocket.connect(server.url);
      
      // Настройка обработчиков событий
      _setupEventHandlers();
      
      _isConnected = true;
      _connectionController.add(true);
      _logController.add('WebSocket connected');
      
    } catch (e) {
      _logController.add('WebSocket connection error: $e');
      _isConnected = false;
      _connectionController.add(false);
    }
  }
  
  // Настройка обработчиков событий
  void _setupEventHandlers() {
    if (_socket == null) return;
    
    _socket!.listen(
      (data) {
        try {
          if (data is String) {
            final jsonData = Map<String, dynamic>.from(
              jsonDecode(data) as Map
            );
            _stateController.add(jsonData);
          }
        } catch (e) {
          _logController.add('Error parsing WebSocket data: $e');
        }
      },
      onError: (error) {
        _logController.add('WebSocket error: $error');
        _isConnected = false;
        _connectionController.add(false);
      },
      onDone: () {
        _logController.add('WebSocket disconnected');
        _isConnected = false;
        _connectionController.add(false);
      },
    );
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
      
      _socket!.add(jsonEncode(payload));
      _logController.add('Sent command: $command');
    } catch (e) {
      _logController.add('Failed to send command: $e');
    }
  }
  
  // Отключение
  Future<void> disconnect() async {
    if (_socket != null) {
      await _socket!.close();
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