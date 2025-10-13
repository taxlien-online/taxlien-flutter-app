/// Exception thrown by NFT operations
class NFTException implements Exception {
  final String message;
  final dynamic data;

  NFTException(this.message, [this.data]);

  @override
  String toString() {
    if (data != null) {
      return 'NFTException: $message (Data: $data)';
    }
    return 'NFTException: $message';
  }
}
