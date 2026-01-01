// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_lien.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxLien _$TaxLienFromJson(Map<String, dynamic> json) => TaxLien(
      id: json['id'] as String,
      propertyAddress: json['propertyAddress'] as String,
      county: json['county'] as String,
      state: json['state'] as String,
      taxAmount: (json['taxAmount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      auctionDate: DateTime.parse(json['auctionDate'] as String),
      status: json['status'] as String,
      propertyType: json['propertyType'] as String,
      estimatedValue: (json['estimatedValue'] as num).toDouble(),
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isLocked: json['isLocked'] as bool? ?? false,
      lockedForNFT: json['lockedForNFT'] as String?,
      saleDate: json['saleDate'] == null
          ? null
          : DateTime.parse(json['saleDate'] as String),
    );

Map<String, dynamic> _$TaxLienToJson(TaxLien instance) => <String, dynamic>{
      'id': instance.id,
      'propertyAddress': instance.propertyAddress,
      'county': instance.county,
      'state': instance.state,
      'taxAmount': instance.taxAmount,
      'interestRate': instance.interestRate,
      'auctionDate': instance.auctionDate.toIso8601String(),
      'status': instance.status,
      'propertyType': instance.propertyType,
      'estimatedValue': instance.estimatedValue,
      'description': instance.description,
      'images': instance.images,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isLocked': instance.isLocked,
      'lockedForNFT': instance.lockedForNFT,
      'saleDate': instance.saleDate?.toIso8601String(),
    };
