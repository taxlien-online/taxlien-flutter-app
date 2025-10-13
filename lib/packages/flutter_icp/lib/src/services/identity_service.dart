import '../icp_client.dart';
import '../models/models.dart';

/// ICP Identity Service - handles principal and identity management
class ICPIdentityService {
  final ICPClient _client;

  ICPIdentityService(this._client);

  /// Create principal from text
  ICPPrincipal fromText(String text) {
    return ICPPrincipal.fromText(text);
  }

  /// Validate principal format
  bool validatePrincipal(String principal) {
    // Simplified validation - check for basic format
    if (principal.isEmpty) return false;
    if (principal.length < 5) return false;

    // ICP principals are usually base32 encoded with dashes
    final validChars = RegExp(r'^[a-z0-9-]+$');
    return validChars.hasMatch(principal);
  }

  /// Get account identifier from principal
  String getAccountIdentifier(ICPPrincipal principal, {int? subaccount}) {
    // Simplified implementation - in real SDK this would do proper encoding
    final base = principal.id;
    return subaccount != null ? '$base-$subaccount' : base;
  }

  /// Get principal from account identifier
  ICPPrincipal? getPrincipalFromAccount(String accountId) {
    try {
      final principal = accountId.split('-').first;
      return ICPPrincipal.fromText(principal);
    } catch (e) {
      return null;
    }
  }
}
