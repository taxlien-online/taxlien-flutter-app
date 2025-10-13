/// Yuku Offer model
class YukuOffer {
  final String id;
  final String tokenId;
  final String collectionId;
  final double price;
  final String currency;
  final String buyerPrincipal;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status;

  YukuOffer({
    required this.id,
    required this.tokenId,
    required this.collectionId,
    required this.price,
    required this.currency,
    required this.buyerPrincipal,
    required this.createdAt,
    this.expiresAt,
    required this.status,
  });

  factory YukuOffer.fromJson(Map<String, dynamic> json) {
    return YukuOffer(
      id: json['id'] ?? '',
      tokenId: json['token_id'] ?? json['tokenId'] ?? '',
      collectionId: json['collection_id'] ?? json['collectionId'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'ICP',
      buyerPrincipal: json['buyer_principal'] ?? json['buyerPrincipal'] ?? '',
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse(json['created_at'] ?? json['createdAt'])
          : DateTime.now(),
      expiresAt: json['expires_at'] != null || json['expiresAt'] != null
          ? DateTime.parse(json['expires_at'] ?? json['expiresAt'])
          : null,
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token_id': tokenId,
      'collection_id': collectionId,
      'price': price,
      'currency': currency,
      'buyer_principal': buyerPrincipal,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'status': status,
    };
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
