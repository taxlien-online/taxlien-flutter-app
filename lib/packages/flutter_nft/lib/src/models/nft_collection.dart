/// NFT Collection model
class NFTCollection {
  final String id;
  final String name;
  final String description;
  final String? symbol;
  final String? imageUrl;
  final String? bannerUrl;
  final String? externalUrl;
  final String creatorAddress;
  final int totalSupply;
  final String network;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  NFTCollection({
    required this.id,
    required this.name,
    required this.description,
    this.symbol,
    this.imageUrl,
    this.bannerUrl,
    this.externalUrl,
    required this.creatorAddress,
    required this.totalSupply,
    required this.network,
    required this.createdAt,
    this.metadata,
  });

  factory NFTCollection.fromJson(Map<String, dynamic> json) {
    return NFTCollection(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      symbol: json['symbol'],
      imageUrl: json['image_url'] ?? json['imageUrl'],
      bannerUrl: json['banner_url'] ?? json['bannerUrl'],
      externalUrl: json['external_url'] ?? json['externalUrl'],
      creatorAddress: json['creator_address'] ?? json['creatorAddress'] ?? '',
      totalSupply: json['total_supply'] ?? json['totalSupply'] ?? 0,
      network: json['network'] ?? '',
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse(json['created_at'] ?? json['createdAt'])
          : DateTime.now(),
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
      'external_url': externalUrl,
      'creator_address': creatorAddress,
      'total_supply': totalSupply,
      'network': network,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}
