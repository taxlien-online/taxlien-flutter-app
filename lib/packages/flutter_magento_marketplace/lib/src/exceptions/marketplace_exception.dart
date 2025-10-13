/// Exception thrown by Marketplace API operations
class MarketplaceException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  MarketplaceException(this.message, this.statusCode, [this.data]);

  @override
  String toString() {
    if (data != null) {
      return 'MarketplaceException: $message (Status: $statusCode, Data: $data)';
    }
    return 'MarketplaceException: $message (Status: $statusCode)';
  }

  bool get isNetworkError => statusCode == 0;
  bool get isAuthError => statusCode == 401 || statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
}
