import '../icp_client.dart';
import '../models/models.dart';

/// ICP Canister Service - handles canister operations
class ICPCanisterService {
  final ICPClient _client;

  ICPCanisterService(this._client);

  /// Get canister information
  Future<ICPCanisterInfo> getCanisterInfo(String canisterId) async {
    try {
      final response = await _client.request(
        '/api/v2/canister/$canisterId/info',
        method: 'GET',
      );

      return ICPCanisterInfo.fromJson(response);
    } catch (e) {
      // Return mock data for demo purposes
      return ICPCanisterInfo(
        id: canisterId,
        status: 'running',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        memorySize: 1024000,
        cycles: 1000000000.0,
      );
    }
  }

  /// Call canister method (query)
  Future<dynamic> query({
    required String canisterId,
    required String method,
    List<dynamic>? args,
  }) async {
    try {
      final response = await _client.request(
        '/api/v2/canister/$canisterId/query',
        method: 'POST',
        body: {
          'method_name': method,
          'arg': args ?? [],
        },
      );

      return response;
    } catch (e) {
      throw Exception('Query failed: $e');
    }
  }

  /// Call canister method (update)
  Future<dynamic> call({
    required String canisterId,
    required String method,
    List<dynamic>? args,
  }) async {
    try {
      final response = await _client.request(
        '/api/v2/canister/$canisterId/call',
        method: 'POST',
        body: {
          'method_name': method,
          'arg': args ?? [],
        },
      );

      return response;
    } catch (e) {
      throw Exception('Call failed: $e');
    }
  }

  /// Get canister status
  Future<String> getCanisterStatus(String canisterId) async {
    try {
      final info = await getCanisterInfo(canisterId);
      return info.status;
    } catch (e) {
      return 'unknown';
    }
  }
}
