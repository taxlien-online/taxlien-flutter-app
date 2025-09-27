// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_lien_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxLien _$TaxLienFromJson(Map<String, dynamic> json) => TaxLien(
      id: json['id'] as String,
      propertyAddress: json['property_address'] as String,
      county: json['county'] as String,
      state: json['state'] as String,
      taxAmount: (json['tax_amount'] as num).toDouble(),
      interestRate: (json['interest_rate'] as num).toDouble(),
      auctionDate: DateTime.parse(json['auction_date'] as String),
      status: json['status'] as String,
      propertyType: json['property_type'] as String,
      estimatedValue: (json['estimated_value'] as num).toDouble(),
      assessedValue: (json['assessed_value'] as num).toDouble(),
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      owner: json['owner'] as String?,
      parcelId: json['parcel_id'] as String?,
      redemptionDeadline: json['redemption_deadline'] == null
          ? null
          : DateTime.parse(json['redemption_deadline'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      ownerName: json['owner_name'] as String?,
      city: json['city'] as String?,
      zipCode: json['zip_code'] as String?,
      taxYear: json['tax_year'] == null
          ? null
          : DateTime.parse(json['tax_year'] as String),
      saleDate: json['sale_date'] == null
          ? null
          : DateTime.parse(json['sale_date'] as String),
      issueDate: json['issue_date'] == null
          ? null
          : DateTime.parse(json['issue_date'] as String),
      isSold: json['is_sold'] as bool?,
      salePrice: (json['sale_price'] as num?)?.toDouble(),
      additionalInfo: json['additional_info'] as String?,
      isAvailable: json['is_available'] as bool?,
    );

Map<String, dynamic> _$TaxLienToJson(TaxLien instance) => <String, dynamic>{
      'id': instance.id,
      'property_address': instance.propertyAddress,
      'county': instance.county,
      'state': instance.state,
      'tax_amount': instance.taxAmount,
      'interest_rate': instance.interestRate,
      'auction_date': instance.auctionDate.toIso8601String(),
      'status': instance.status,
      'property_type': instance.propertyType,
      'estimated_value': instance.estimatedValue,
      'assessed_value': instance.assessedValue,
      'description': instance.description,
      'images': instance.images,
      'owner': instance.owner,
      'parcel_id': instance.parcelId,
      'redemption_deadline': instance.redemptionDeadline?.toIso8601String(),
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'owner_name': instance.ownerName,
      'city': instance.city,
      'zip_code': instance.zipCode,
      'tax_year': instance.taxYear?.toIso8601String(),
      'sale_date': instance.saleDate?.toIso8601String(),
      'issue_date': instance.issueDate?.toIso8601String(),
      'is_sold': instance.isSold,
      'sale_price': instance.salePrice,
      'additional_info': instance.additionalInfo,
      'is_available': instance.isAvailable,
    };

TaxLienNFT _$TaxLienNFTFromJson(Map<String, dynamic> json) => TaxLienNFT(
      id: json['id'] as String,
      tokenId: json['token_id'] as String,
      contractAddress: json['contract_address'] as String,
      ownerAddress: json['owner_address'] as String,
      originalLien:
          TaxLien.fromJson(json['original_lien'] as Map<String, dynamic>),
      nftMetadata: json['nft_metadata'] as String,
      imageUrl: json['image_url'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      attributes: (json['attributes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mintedAt: DateTime.parse(json['minted_at'] as String),
      soldAt: json['sold_at'] == null
          ? null
          : DateTime.parse(json['sold_at'] as String),
      salePrice: (json['sale_price'] as num?)?.toDouble(),
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TaxLienNFTToJson(TaxLienNFT instance) =>
    <String, dynamic>{
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
