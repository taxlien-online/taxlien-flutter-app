/// Yuku NFT model
class YukuNFT {
  final String tokenId;
  final String collectionId;
  final String ownerPrincipal;
  final String? name;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;
  final DateTime? mintedAt;
  final List<YukuNFTAttribute>? attributes;

  YukuNFT({
    required this.tokenId,
    required this.collectionId,
    required this.ownerPrincipal,
    this.name,
    this.description,
    this.imageUrl,
    this.metadata,
    this.mintedAt,
    this.attributes,
  });

  factory YukuNFT.fromJson(Map<String, dynamic> json) {
    return YukuNFT(
      tokenId: json['token_id'] ?? json['tokenId'] ?? '',
      collectionId: json['collection_id'] ?? json['collectionId'] ?? '',
      ownerPrincipal: json['owner_principal'] ?? json['ownerPrincipal'] ?? '',
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'] ?? json['imageUrl'],
      metadata: json['metadata'],
      mintedAt: json['minted_at'] != null || json['mintedAt'] != null
          ? DateTime.parse(json['minted_at'] ?? json['mintedAt'])
          : null,
      attributes: json['attributes'] != null
          ? (json['attributes'] as List)
              .map((e) => YukuNFTAttribute.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token_id': tokenId,
      'collection_id': collectionId,
      'owner_principal': ownerPrincipal,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'metadata': metadata,
      'minted_at': mintedAt?.toIso8601String(),
      'attributes': attributes?.map((e) => e.toJson()).toList(),
    };
  }
}

/// Yuku NFT Attribute
class YukuNFTAttribute {
  final String traitType;
  final dynamic value;

  YukuNFTAttribute({
    required this.traitType,
    required this.value,
  });

  factory YukuNFTAttribute.fromJson(Map<String, dynamic> json) {
    return YukuNFTAttribute(
      traitType: json['trait_type'] ?? '',
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trait_type': traitType,
      'value': value,
    };
  }
}
