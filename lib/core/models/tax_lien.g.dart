// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_lien.dart';

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
      description: json['description'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'description': instance.description,
      'images': instance.images,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
