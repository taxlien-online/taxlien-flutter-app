/// Yuku Collection model
class YukuCollection {
  final String id;
  final String name;
  final String description;
  final String? symbol;
  final String? imageUrl;
  final String? bannerUrl;
  final String canisterId;
  final String creatorPrincipal;
  final int totalSupply;
  final int? floorPrice;
  final int? volume24h;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata;

  YukuCollection({
    required this.id,
    required this.name,
    required this.description,
    this.symbol,
    this.imageUrl,
    this.bannerUrl,
    required this.canisterId,
    required this.creatorPrincipal,
    required this.totalSupply,
    this.floorPrice,
    this.volume24h,
    this.createdAt,
    this.metadata,
  });

  factory YukuCollection.fromJson(Map<String, dynamic> json) {
    return YukuCollection(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      symbol: json['symbol'],
      imageUrl: json['image_url'] ?? json['imageUrl'],
      bannerUrl: json['banner_url'] ?? json['bannerUrl'],
      canisterId: json['canister_id'] ?? json['canisterId'] ?? '',
      creatorPrincipal:
          json['creator_principal'] ?? json['creatorPrincipal'] ?? '',
      totalSupply: json['total_supply'] ?? json['totalSupply'] ?? 0,
      floorPrice: json['floor_price'] ?? json['floorPrice'],
      volume24h: json['volume_24h'] ?? json['volume24h'],
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse(json['created_at'] ?? json['createdAt'])
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'symbol': symbol,
      'image_url': imageUrl,
      'banner_url': bannerUrl,
      'canister_id': canisterId,
      'creator_principal': creatorPrincipal,
      'total_supply': totalSupply,
      'floor_price': floorPrice,
      'volume_24h': volume24h,
      'created_at': createdAt?.toIso8601String(),
      'metadata': metadata,
    };
  }
}
