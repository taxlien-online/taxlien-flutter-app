/// Exception thrown by Yuku operations
class YukuException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  YukuException(this.message, [this.statusCode, this.data]);

  @override
  String toString() {
    final parts = ['YukuException: $message'];
    if (statusCode != null) parts.add('Status: $statusCode');
    if (data != null) parts.add('Data: $data');
    return parts.join(' (') + (parts.length > 1 ? ')' : '');
  }

  bool get isNetworkError => statusCode == null || statusCode == 0;
  bool get isAuthError => statusCode == 401 || statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
}
