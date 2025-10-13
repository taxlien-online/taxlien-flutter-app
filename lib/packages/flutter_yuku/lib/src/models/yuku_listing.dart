/// Yuku Marketplace Listing model
class YukuListing {
  final String id;
  final String tokenId;
  final String collectionId;
  final double price;
  final String currency;
  final String sellerPrincipal;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status;
  final Map<String, dynamic>? metadata;

  YukuListing({
    required this.id,
    required this.tokenId,
    required this.collectionId,
    required this.price,
    required this.currency,
    required this.sellerPrincipal,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    this.metadata,
  });

  factory YukuListing.fromJson(Map<String, dynamic> json) {
    return YukuListing(
      id: json['id'] ?? '',
      tokenId: json['token_id'] ?? json['tokenId'] ?? '',
      collectionId: json['collection_id'] ?? json['collectionId'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'ICP',
      sellerPrincipal:
          json['seller_principal'] ?? json['sellerPrincipal'] ?? '',
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse(json['created_at'] ?? json['createdAt'])
          : DateTime.now(),
      expiresAt: json['expires_at'] != null || json['expiresAt'] != null
          ? DateTime.parse(json['expires_at'] ?? json['expiresAt'])
          : null,
      status: json['status'] ?? 'active',
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token_id': tokenId,
      'collection_id': collectionId,
      'price': price,
      'currency': currency,
      'seller_principal': sellerPrincipal,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'status': status,
      'metadata': metadata,
    };
  }

  bool get isActive => status == 'active';
  bool get isSold => status == 'sold';
  bool get isCancelled => status == 'cancelled';
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
