/// NFT Marketplace Listing model
class NFTListing {
  final String id;
  final String tokenId;
  final double price;
  final String currency;
  final String sellerAddress;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status;
  final String marketplaceId;
  final Map<String, dynamic>? metadata;

  NFTListing({
    required this.id,
    required this.tokenId,
    required this.price,
    required this.currency,
    required this.sellerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    required this.marketplaceId,
    this.metadata,
  });

  factory NFTListing.fromJson(Map<String, dynamic> json) {
    return NFTListing(
      id: json['id'] ?? '',
      tokenId: json['token_id'] ?? json['tokenId'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'ICP',
      sellerAddress: json['seller_address'] ?? json['sellerAddress'] ?? '',
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse(json['created_at'] ?? json['createdAt'])
          : DateTime.now(),
      expiresAt: json['expires_at'] != null || json['expiresAt'] != null
          ? DateTime.parse(json['expires_at'] ?? json['expiresAt'])
          : null,
      status: json['status'] ?? 'active',
      marketplaceId: json['marketplace_id'] ?? json['marketplaceId'] ?? '',
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token_id': tokenId,
      'price': price,
      'currency': currency,
      'seller_address': sellerAddress,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'status': status,
      'marketplace_id': marketplaceId,
      'metadata': metadata,
    };
  }

  bool get isActive => status == 'active';
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
