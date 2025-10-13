/// NFT Offer model
class NFTOffer {
  final String id;
  final String tokenId;
  final double price;
  final String currency;
  final String buyerAddress;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status;
  final Map<String, dynamic>? metadata;

  NFTOffer({
    required this.id,
    required this.tokenId,
    required this.price,
    required this.currency,
    required this.buyerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    this.metadata,
  });

  factory NFTOffer.fromJson(Map<String, dynamic> json) {
    return NFTOffer(
      id: json['id'] ?? '',
      tokenId: json['token_id'] ?? json['tokenId'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'ICP',
      buyerAddress: json['buyer_address'] ?? json['buyerAddress'] ?? '',
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse(json['created_at'] ?? json['createdAt'])
          : DateTime.now(),
      expiresAt: json['expires_at'] != null || json['expiresAt'] != null
          ? DateTime.parse(json['expires_at'] ?? json['expiresAt'])
          : null,
      status: json['status'] ?? 'pending',
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token_id': tokenId,
      'price': price,
      'currency': currency,
      'buyer_address': buyerAddress,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'status': status,
      'metadata': metadata,
    };
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
