// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_lien_nft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxLienNFT _$TaxLienNFTFromJson(Map<String, dynamic> json) => TaxLienNFT(
      id: json['id'] as String,
      tokenId: json['tokenId'] as String,
      contractAddress: json['contractAddress'] as String,
      ownerAddress: json['ownerAddress'] as String,
      originalLien:
          TaxLien.fromJson(json['originalLien'] as Map<String, dynamic>),
      nftMetadata: json['nftMetadata'] as String,
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      attributes: (json['attributes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mintedAt: DateTime.parse(json['mintedAt'] as String),
      soldAt: json['soldAt'] == null
          ? null
          : DateTime.parse(json['soldAt'] as String),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TaxLienNFTToJson(TaxLienNFT instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tokenId': instance.tokenId,
      'contractAddress': instance.contractAddress,
      'ownerAddress': instance.ownerAddress,
      'originalLien': instance.originalLien,
      'nftMetadata': instance.nftMetadata,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'description': instance.description,
      'attributes': instance.attributes,
      'mintedAt': instance.mintedAt.toIso8601String(),
      'soldAt': instance.soldAt?.toIso8601String(),
      'salePrice': instance.salePrice,
      'status': instance.status,
      'metadata': instance.metadata,
    };
