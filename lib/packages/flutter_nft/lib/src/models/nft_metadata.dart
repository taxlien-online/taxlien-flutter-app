/// NFT Metadata model (ERC-721 / ERC-1155 standard)
class NFTMetadata {
  final String name;
  final String description;
  final String image;
  final String? externalUrl;
  final String? animationUrl;
  final List<NFTAttribute> attributes;
  final Map<String, dynamic>? properties;

  NFTMetadata({
    required this.name,
    required this.description,
    required this.image,
    this.externalUrl,
    this.animationUrl,
    this.attributes = const [],
    this.properties,
  });

  factory NFTMetadata.fromJson(Map<String, dynamic> json) {
    return NFTMetadata(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      externalUrl: json['external_url'],
      animationUrl: json['animation_url'],
      attributes: json['attributes'] != null
          ? (json['attributes'] as List)
              .map((e) => NFTAttribute.fromJson(e))
              .toList()
          : [],
      properties: json['properties'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      if (externalUrl != null) 'external_url': externalUrl,
      if (animationUrl != null) 'animation_url': animationUrl,
      'attributes': attributes.map((e) => e.toJson()).toList(),
      if (properties != null) 'properties': properties,
    };
  }
}

/// NFT Attribute model
class NFTAttribute {
  final String traitType;
  final dynamic value;
  final String? displayType;

  NFTAttribute({
    required this.traitType,
    required this.value,
    this.displayType,
  });

  factory NFTAttribute.fromJson(Map<String, dynamic> json) {
    return NFTAttribute(
      traitType: json['trait_type'] ?? '',
      value: json['value'],
      displayType: json['display_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trait_type': traitType,
      'value': value,
      if (displayType != null) 'display_type': displayType,
    };
  }
}
