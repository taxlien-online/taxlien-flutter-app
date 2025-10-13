import '../flutter_magento_base.dart';
import '../models/customer.dart';

/// Magento Customer Service
class MagentoCustomerService {
  final FlutterMagento _client;

  MagentoCustomerService(this._client);

  /// Get current customer information
  Future<MagentoCustomer> getCustomer() async {
    final response = await _client.request(
      'GET',
      '/customers/me',
      headers: _client.auth.getAuthHeaders(),
    );

    return MagentoCustomer.fromJson(response);
  }

  /// Create new customer
  Future<MagentoCustomer> createCustomer({
    required String email,
    required String firstname,
    required String lastname,
    required String password,
    int websiteId = 1,
    int storeId = 1,
  }) async {
    final response = await _client.request(
      'POST',
      '/customers',
      body: {
        'customer': {
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
          'website_id': websiteId,
          'store_id': storeId,
        },
        'password': password,
      },
    );

    return MagentoCustomer.fromJson(response);
  }

  /// Update customer information
  Future<MagentoCustomer> updateCustomer(MagentoCustomer customer) async {
    final response = await _client.request(
      'PUT',
      '/customers/${customer.id}',
      headers: _client.auth.getAuthHeaders(),
      body: {
        'customer': customer.toJson(),
      },
    );

    return MagentoCustomer.fromJson(response);
  }

  /// Change customer password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.request(
      'PUT',
      '/customers/me/password',
      headers: _client.auth.getAuthHeaders(),
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    return true;
  }

  /// Get customer addresses
  Future<List<MagentoAddress>> getAddresses() async {
    final customer = await getCustomer();
    return customer.addresses ?? [];
  }

  /// Add customer address
  Future<MagentoAddress> addAddress(MagentoAddress address) async {
    final response = await _client.request(
      'POST',
      '/customers/me/addresses',
      headers: _client.auth.getAuthHeaders(),
      body: {
        'address': address.toJson(),
      },
    );

    return MagentoAddress.fromJson(response);
  }

  /// Update customer address
  Future<MagentoAddress> updateAddress(MagentoAddress address) async {
    final response = await _client.request(
      'PUT',
      '/customers/me/addresses/${address.id}',
      headers: _client.auth.getAuthHeaders(),
      body: {
        'address': address.toJson(),
      },
    );

    return MagentoAddress.fromJson(response);
  }

  /// Delete customer address
  Future<bool> deleteAddress(int addressId) async {
    await _client.request(
      'DELETE',
      '/customers/me/addresses/$addressId',
      headers: _client.auth.getAuthHeaders(),
    );

    return true;
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    await _client.request(
      'PUT',
      '/customers/password',
      body: {
        'email': email,
        'template': 'email_reset',
      },
    );

    return true;
  }
}
