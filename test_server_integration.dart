import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerIntegrationTest {
  static const String baseUrl = 'http://localhost:3000';
  
  static Future<void> runTests() async {
    print('🧪 Starting FreeDome Server Integration Tests\n');
    
    try {
      // Тест 1: Проверка доступности сервера
      await _testServerAvailability();
      
      // Тест 2: Получение статуса системы
      await _testGetStatus();
      
      // Тест 3: Управление воспроизведением
      await _testPlaybackControls();
      
      // Тест 4: Управление параметрами
      await _testParameterControls();
      
      // Тест 5: Работа с медиафайлами
      await _testMediaFiles();
      
      // Тест 6: Работа с плейлистами
      await _testPlaylists();
      
      print('\n✅ All tests completed successfully!');
      
    } catch (e) {
      print('\n❌ Test failed: $e');
    }
  }
  
  static Future<void> _testServerAvailability() async {
    print('📡 Testing server availability...');
    
    try {
      final response = await http.get(Uri.parse('$baseUrl/'))
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        print('✅ Server is available');
        print('   Response: HTML page (expected)');
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Server is not available: $e');
    }
  }
  
  static Future<void> _testGetStatus() async {
    print('\n📊 Testing system status...');
    
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/status'))
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['data'];
        print('✅ System status retrieved');
        print('   Running: ${status['isRunning']}');
        print('   Brightness: ${status['brightness']}%');
        print('   Volume: ${status['volume']}%');
        print('   Rotation: ${status['rotation']}°');
      } else {
        throw Exception('Failed to get status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Status test failed: $e');
    }
  }
  
  static Future<void> _testPlaybackControls() async {
    print('\n▶️ Testing playback controls...');
    
    try {
      // Тест воспроизведения
      var response = await http.post(Uri.parse('$baseUrl/api/play'))
          .timeout(const Duration(seconds: 5));
      print('✅ Play command sent (${response.statusCode})');
      
      // Тест паузы
      response = await http.post(Uri.parse('$baseUrl/api/pause'))
          .timeout(const Duration(seconds: 5));
      print('✅ Pause command sent (${response.statusCode})');
      
      // Тест остановки
      response = await http.post(Uri.parse('$baseUrl/api/stop'))
          .timeout(const Duration(seconds: 5));
      print('✅ Stop command sent (${response.statusCode})');
      
    } catch (e) {
      throw Exception('Playback controls test failed: $e');
    }
  }
  
  static Future<void> _testParameterControls() async {
    print('\n🎛️ Testing parameter controls...');
    
    try {
      // Тест яркости
      var response = await http.post(
        Uri.parse('$baseUrl/api/brightness'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': 80}),
      ).timeout(const Duration(seconds: 5));
      print('✅ Brightness set to 80% (${response.statusCode})');
      
      // Тест громкости
      response = await http.post(
        Uri.parse('$baseUrl/api/volume'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': 60}),
      ).timeout(const Duration(seconds: 5));
      print('✅ Volume set to 60% (${response.statusCode})');
      
      // Тест поворота
      response = await http.post(
        Uri.parse('$baseUrl/api/rotation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': 45.0}),
      ).timeout(const Duration(seconds: 5));
      print('✅ Rotation set to 45° (${response.statusCode})');
      
    } catch (e) {
      throw Exception('Parameter controls test failed: $e');
    }
  }
  
  static Future<void> _testMediaFiles() async {
    print('\n📁 Testing media files...');
    
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/media'))
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['files'] ?? [];
        print('✅ Media files retrieved (${files.length} files)');
        
        for (final file in files.take(3)) {
          print('   - ${file['name']} (${file['type']})');
        }
      } else {
        throw Exception('Failed to get media files: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Media files test failed: $e');
    }
  }
  
  static Future<void> _testPlaylists() async {
    print('\n📋 Testing playlists...');
    
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/playlists'))
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final playlists = data['playlists'] ?? [];
        print('✅ Playlists retrieved (${playlists.length} playlists)');
        
        for (final playlist in playlists.take(3)) {
          print('   - ${playlist['name']} (${playlist['items']?.length ?? 0} items)');
        }
      } else {
        throw Exception('Failed to get playlists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Playlists test failed: $e');
    }
  }
}

void main() async {
  print('FreeDome Server Integration Test');
  print('================================');
  print('Make sure the server is running at http://localhost:3000\n');
  
  await ServerIntegrationTest.runTests();
} 