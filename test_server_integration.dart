import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerIntegrationTest {
  static const String baseUrl = 'http://localhost:3000';
  
  static Future<void> runTests() async {
    print('🧪 Starting FreeDome Server Integration Tests\n');
    
    try {
      // Test 1: Check server availability
      await _testServerAvailability();
      
      // Test 2: Get system status
      await _testGetStatus();
      
      // Test 3: Playback controls
      await _testPlaybackControls();
      
      // Test 4: Parameter controls
      await _testParameterControls();
      

      
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
      // Test play
      var response = await http.post(Uri.parse('$baseUrl/api/play'))
          .timeout(const Duration(seconds: 5));
      print('✅ Play command sent (${response.statusCode})');
      
      // Test pause
      response = await http.post(Uri.parse('$baseUrl/api/pause'))
          .timeout(const Duration(seconds: 5));
      print('✅ Pause command sent (${response.statusCode})');
      
      // Test stop
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
      // Test brightness
      var response = await http.post(
        Uri.parse('$baseUrl/api/brightness'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': 80}),
      ).timeout(const Duration(seconds: 5));
      print('✅ Brightness set to 80% (${response.statusCode})');
      
      // Test volume
      response = await http.post(
        Uri.parse('$baseUrl/api/volume'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': 60}),
      ).timeout(const Duration(seconds: 5));
      print('✅ Volume set to 60% (${response.statusCode})');
      
      // Test rotation
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
  

}

void main() async {
  print('FreeDome Server Integration Test');
  print('================================');
  print('Make sure the server is running at http://localhost:3000\n');
  
  await ServerIntegrationTest.runTests();
} 