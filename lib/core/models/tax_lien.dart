import 'package:json_annotation/json_annotation.dart';

part 'tax_lien.g.dart';

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
  final String description;
  final List<String> images;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Unified system fields
  final bool isLocked;
  final String? lockedForNFT;
  final DateTime? saleDate;

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
    required this.description,
    required this.images,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.isLocked = false,
    this.lockedForNFT,
    this.saleDate,
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
    String? description,
    List<String>? images,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLocked,
    String? lockedForNFT,
    DateTime? saleDate,
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
      description: description ?? this.description,
      images: images ?? this.images,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLocked: isLocked ?? this.isLocked,
      lockedForNFT: lockedForNFT ?? this.lockedForNFT,
      saleDate: saleDate ?? this.saleDate,
    );
  }

  // Helper getters for unified system
  double get lienAmount => taxAmount;
  bool get canBeTokenized => !isLocked && status == 'active';
  bool get isTokenized => lockedForNFT != null;
  String get address => propertyAddress;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaxLien && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TaxLien(id: $id, propertyAddress: $propertyAddress, county: $county, state: $state, taxAmount: $taxAmount, status: $status)';
  }
}
