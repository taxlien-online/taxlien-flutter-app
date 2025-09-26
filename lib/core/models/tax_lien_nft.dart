import 'package:json_annotation/json_annotation.dart';
import 'tax_lien.dart';

part 'tax_lien_nft.g.dart';

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaxLienNFT && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TaxLienNFT(id: $id, tokenId: $tokenId, name: $name, status: $status)';
  }
}
