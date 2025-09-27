import 'package:json_annotation/json_annotation.dart';

part 'tax_lien_models.g.dart';

@JsonSerializable()
class TaxLien {
  final String id;
  final String propertyAddress;
  final String county;
  final String state;
  final double taxAmount;
  final double interestRate;
  final DateTime auctionDate;
  final String status;
  final String propertyType;
  final double estimatedValue;
  final double assessedValue;
  final String description;
  final List<String> images;
  final String? owner;
  final String? parcelId;
  final DateTime? redemptionDeadline;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for compatibility
  final String? ownerName;
  final String? city;
  final String? zipCode;
  final DateTime? taxYear;
  final DateTime? saleDate;
  final DateTime? issueDate;
  final bool? isSold;
  final double? salePrice;
  final String? additionalInfo;
  final bool? isAvailable;

  const TaxLien({
    required this.id,
    required this.propertyAddress,
    required this.county,
    required this.state,
    required this.taxAmount,
    required this.interestRate,
    required this.auctionDate,
    required this.status,
    required this.propertyType,
    required this.estimatedValue,
    required this.assessedValue,
    required this.description,
    required this.images,
    this.owner,
    this.parcelId,
    this.redemptionDeadline,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.ownerName,
    this.city,
    this.zipCode,
    this.taxYear,
    this.saleDate,
    this.issueDate,
    this.isSold,
    this.salePrice,
    this.additionalInfo,
    this.isAvailable,
  });

  factory TaxLien.fromJson(Map<String, dynamic> json) =>
      _$TaxLienFromJson(json);
  Map<String, dynamic> toJson() => _$TaxLienToJson(this);

  TaxLien copyWith({
    String? id,
    String? propertyAddress,
    String? county,
    String? state,
    double? taxAmount,
    double? interestRate,
    DateTime? auctionDate,
    String? status,
    String? propertyType,
    double? estimatedValue,
    double? assessedValue,
    String? description,
    List<String>? images,
    String? owner,
    String? parcelId,
    DateTime? redemptionDeadline,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerName,
    String? city,
    String? zipCode,
    DateTime? taxYear,
    DateTime? saleDate,
    DateTime? issueDate,
    bool? isSold,
    double? salePrice,
    String? additionalInfo,
    bool? isAvailable,
  }) {
    return TaxLien(
      id: id ?? this.id,
      propertyAddress: propertyAddress ?? this.propertyAddress,
      county: county ?? this.county,
      state: state ?? this.state,
      taxAmount: taxAmount ?? this.taxAmount,
      interestRate: interestRate ?? this.interestRate,
      auctionDate: auctionDate ?? this.auctionDate,
      status: status ?? this.status,
      propertyType: propertyType ?? this.propertyType,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      assessedValue: assessedValue ?? this.assessedValue,
      description: description ?? this.description,
      images: images ?? this.images,
      owner: owner ?? this.owner,
      parcelId: parcelId ?? this.parcelId,
      redemptionDeadline: redemptionDeadline ?? this.redemptionDeadline,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerName: ownerName ?? this.ownerName,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      taxYear: taxYear ?? this.taxYear,
      saleDate: saleDate ?? this.saleDate,
      issueDate: issueDate ?? this.issueDate,
      isSold: isSold ?? this.isSold,
      salePrice: salePrice ?? this.salePrice,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  // Computed properties for compatibility
  String get address => propertyAddress;
  String get fullAddress => '$propertyAddress, $city, $state $zipCode';
}

@JsonSerializable()
class TaxLienNFT {
  final String id;
  final String tokenId;
  final String contractAddress;
  final String ownerAddress;
  final TaxLien originalLien;
  final String nftMetadata;
  final String imageUrl;
  final String name;
  final String description;
  final List<String> attributes;
  final DateTime mintedAt;
  final DateTime? soldAt;
  final double? salePrice;
  final String status;
  final Map<String, dynamic>? metadata;

  const TaxLienNFT({
    required this.id,
    required this.tokenId,
    required this.contractAddress,
    required this.ownerAddress,
    required this.originalLien,
    required this.nftMetadata,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.attributes,
    required this.mintedAt,
    this.soldAt,
    this.salePrice,
    required this.status,
    this.metadata,
  });

  factory TaxLienNFT.fromJson(Map<String, dynamic> json) =>
      _$TaxLienNFTFromJson(json);
  Map<String, dynamic> toJson() => _$TaxLienNFTToJson(this);

  TaxLienNFT copyWith({
    String? id,
    String? tokenId,
    String? contractAddress,
    String? ownerAddress,
    TaxLien? originalLien,
    String? nftMetadata,
    String? imageUrl,
    String? name,
    String? description,
    List<String>? attributes,
    DateTime? mintedAt,
    DateTime? soldAt,
    double? salePrice,
    String? status,
    Map<String, dynamic>? metadata,
  }) {
    return TaxLienNFT(
      id: id ?? this.id,
      tokenId: tokenId ?? this.tokenId,
      contractAddress: contractAddress ?? this.contractAddress,
      ownerAddress: ownerAddress ?? this.ownerAddress,
      originalLien: originalLien ?? this.originalLien,
      nftMetadata: nftMetadata ?? this.nftMetadata,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      description: description ?? this.description,
      attributes: attributes ?? this.attributes,
      mintedAt: mintedAt ?? this.mintedAt,
      soldAt: soldAt ?? this.soldAt,
      salePrice: salePrice ?? this.salePrice,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }
}
