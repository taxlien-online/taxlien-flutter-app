// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_lien_nft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxLienNFT _$TaxLienNFTFromJson(Map<String, dynamic> json) => TaxLienNFT(
      id: json['id'] as String,
      tokenId: json['token_id'] as String,
      contractAddress: json['contract_address'] as String,
      ownerAddress: json['owner_address'] as String,
      originalLien: TaxLien.fromJson(json['original_lien'] as Map<String, dynamic>),
      nftMetadata: json['nft_metadata'] as String,
      imageUrl: json['image_url'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      attributes: (json['attributes'] as List<dynamic>).map((e) => e as String).toList(),
      mintedAt: DateTime.parse(json['minted_at'] as String),
      soldAt: json['sold_at'] == null ? null : DateTime.parse(json['sold_at'] as String),
      salePrice: (json['sale_price'] as num?)?.toDouble(),
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TaxLienNFTToJson(TaxLienNFT instance) => <String, dynamic>{
      'id': instance.id,
      'token_id': instance.tokenId,
      'contract_address': instance.contractAddress,
      'owner_address': instance.ownerAddress,
      'original_lien': instance.originalLien,
      'nft_metadata': instance.nftMetadata,
      'image_url': instance.imageUrl,
      'name': instance.name,
      'description': instance.description,
      'attributes': instance.attributes,
      'minted_at': instance.mintedAt.toIso8601String(),
      'sold_at': instance.soldAt?.toIso8601String(),
      'sale_price': instance.salePrice,
      'status': instance.status,
      'metadata': instance.metadata,
    };
