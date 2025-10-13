/// NFT model
class NFT {
  final String tokenId;
  final String contractAddress;
  final String ownerAddress;
  final String metadataUrl;
  final String? collectionId;
  final String? network;
  final DateTime createdAt;
  final Map<String, dynamic>? properties;

  NFT({
    required this.tokenId,
    required this.contractAddress,
    required this.ownerAddress,
    required this.metadataUrl,
    this.collectionId,
    this.network,
    required this.createdAt,
    this.properties,
  });

  factory NFT.fromJson(Map<String, dynamic> json) {
    return NFT(
      tokenId: json['token_id'] ?? json['tokenId'] ?? '',
      contractAddress:
          json['contract_address'] ?? json['contractAddress'] ?? '',
      ownerAddress: json['owner_address'] ?? json['ownerAddress'] ?? '',
      metadataUrl: json['metadata_url'] ?? json['metadataUrl'] ?? '',
      collectionId: json['collection_id'] ?? json['collectionId'],
      network: json['network'],
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse(json['created_at'] ?? json['createdAt'])
          : DateTime.now(),
      properties: json['properties'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token_id': tokenId,
      'contract_address': contractAddress,
      'owner_address': ownerAddress,
      'metadata_url': metadataUrl,
      'collection_id': collectionId,
      'network': network,
      'created_at': createdAt.toIso8601String(),
      'properties': properties,
    };
  }
}
