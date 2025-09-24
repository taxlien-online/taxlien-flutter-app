// Simple stub for flutter_magento package
// This is a temporary implementation to avoid build errors

class FlutterMagento {
  static final FlutterMagento _instance = FlutterMagento._internal();
  factory FlutterMagento() => _instance;
  FlutterMagento._internal();

  bool _isInitialized = false;

  Future<void> initialize({
    required String baseUrl,
    int connectionTimeout = 30000,
    int receiveTimeout = 30000,
    Map<String, String>? headers,
    bool enableCaching = true,
    bool enableRateLimiting = true,
  }) async {
    _isInitialized = true;
  }

  bool get isInitialized => _isInitialized;
  bool get isOnline => true;
}

class MagentoAuthService {
  Future<Map<String, dynamic>> authenticate(
      String username, String password) async {
    throw UnimplementedError('MagentoAuthService.authenticate not implemented');
  }
}

class MagentoProvider {
  MagentoAuthService get auth => MagentoAuthService();
}

class MagentoException implements Exception {
  final String message;
  final int statusCode;

  MagentoException(this.message, this.statusCode);

  @override
  String toString() => 'MagentoException: $message (Status: $statusCode)';
}
