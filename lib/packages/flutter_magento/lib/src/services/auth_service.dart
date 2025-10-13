import '../flutter_magento_base.dart';
import '../exceptions/magento_exception.dart';

/// Magento Authentication Service
class MagentoAuthService {
  final FlutterMagento _client;
  String? _customerToken;
  String? _adminToken;

  MagentoAuthService(this._client);

  /// Login customer and get authentication token
  Future<String> loginCustomer(String username, String password) async {
    try {
      final response = await _client.request(
        'POST',
        '/integration/customer/token',
        body: {
          'username': username,
          'password': password,
        },
      );

      _customerToken = response.toString();
      return _customerToken!;
    } catch (e) {
      throw MagentoException('Login failed: $e', 401);
    }
  }

  /// Login admin user and get authentication token
  Future<String> loginAdmin(String username, String password) async {
    try {
      final response = await _client.request(
        'POST',
        '/integration/admin/token',
        body: {
          'username': username,
          'password': password,
        },
      );

      _adminToken = response.toString();
      return _adminToken!;
    } catch (e) {
      throw MagentoException('Admin login failed: $e', 401);
    }
  }

  /// Logout customer
  Future<void> logoutCustomer() async {
    _customerToken = null;
  }

  /// Logout admin
  Future<void> logoutAdmin() async {
    _adminToken = null;
  }

  /// Check if customer is authenticated
  bool get isCustomerAuthenticated => _customerToken != null;

  /// Check if admin is authenticated
  bool get isAdminAuthenticated => _adminToken != null;

  /// Get customer token
  String? get customerToken => _customerToken;

  /// Get admin token
  String? get adminToken => _adminToken;

  /// Get authorization headers
  Map<String, String> getAuthHeaders({bool useAdmin = false}) {
    final token = useAdmin ? _adminToken : _customerToken;
    if (token == null) {
      throw MagentoException('Not authenticated', 401);
    }

    return {
      'Authorization': 'Bearer $token',
    };
  }
}
