import 'package:flutter/foundation.dart';
import 'tax_lien.dart';
import 'tax_lien_nft.dart';

/// Unified representation of assets (both traditional liens and NFTs)
class AssetItem {
  final String id;
  final AssetType type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final double value;
  final double roi;
  final AssetStatus status;
  final DateTime createdAt;

  // Original asset references
  final TaxLien? lien;
  final TaxLienNFT? nft;

  AssetItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.value,
    required this.roi,
    required this.status,
    required this.createdAt,
    this.lien,
    this.nft,
  });

  bool get isNFT => type == AssetType.nft;
  bool get isTraditional => type == AssetType.traditional;
  bool get isLocked => status == AssetStatus.locked;
  bool get isForSale => status == AssetStatus.forSale;

  /// Create AssetItem from TaxLien
  factory AssetItem.fromLien(TaxLien lien) {
    return AssetItem(
      id: lien.id.toString(),
      type: AssetType.traditional,
      title: lien.propertyAddress,
      subtitle: '${lien.county}, ${lien.state}',
      imageUrl: lien.images.isNotEmpty ? lien.images.first : '',
      value: lien.lienAmount,
      roi: lien.interestRate,
      status: lien.isLocked ? AssetStatus.locked : AssetStatus.active,
      createdAt: lien.saleDate ?? lien.createdAt,
      lien: lien,
      nft: null,
    );
  }

  /// Create AssetItem from TaxLienNFT
  factory AssetItem.fromNFT(TaxLienNFT nft) {
    return AssetItem(
      id: nft.id,
      type: AssetType.nft,
      title: nft.name,
      subtitle: '${nft.originalLien.county}, ${nft.originalLien.state}',
      imageUrl: nft.imageUrl,
      value: nft.originalLien.lienAmount,
      roi: nft.originalLien.interestRate,
      status: _getNFTStatus(nft.status),
      createdAt: nft.mintedAt,
      lien: null,
      nft: nft,
    );
  }

  static AssetStatus _getNFTStatus(String nftStatus) {
    switch (nftStatus) {
      case 'for_sale':
        return AssetStatus.forSale;
      case 'locked':
        return AssetStatus.locked;
      case 'minted':
      default:
        return AssetStatus.active;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum AssetType { traditional, nft }

enum AssetStatus { active, locked, forSale, sold }

/// Portfolio view modes
enum PortfolioViewMode {
  unified, // Show all assets together
  traditional, // Show only traditional liens
  nft, // Show only NFTs
}

/// Tokenization options
class TokenizationOptions {
  String nftName = '';
  String description = '';
  TokenizationType type = TokenizationType.full;
  int? fractionalShares;
  bool listOnYuku = false;
  double? price;

  TokenizationOptions();

  bool get isValid {
    if (nftName.isEmpty) return false;
    if (type == TokenizationType.fractional &&
        (fractionalShares == null || fractionalShares! < 2)) {
      return false;
    }
    if (listOnYuku && (price == null || price! <= 0)) {
      return false;
    }
    return true;
  }
}

enum TokenizationType { full, fractional }

/// Lock options for collateral
class LockOptions {
  final double collateralValue;
  final int lockDurationDays;
  final LockPurpose purpose;
  final double interestRate;

  LockOptions({
    required this.collateralValue,
    required this.lockDurationDays,
    required this.purpose,
    this.interestRate = 0.05, // 5% default
  });

  double get loanAmount => collateralValue * 0.7; // 70% LTV
  double get repaymentAmount => loanAmount * (1 + interestRate);
}

enum LockPurpose {
  collateral, // Get a loan
  staking, // Stake for rewards
  escrow, // Hold in escrow for trade
  voluntary, // User choice
}

/// Locked NFT/Lien model
class LockedAsset {
  final String id;
  final String assetId;
  final AssetType assetType;
  final DateTime lockedAt;
  final DateTime unlockAt;
  final double collateralValue;
  final double loanAmount;
  final double repaymentAmount;
  final String status; // 'locked', 'unlocked', 'defaulted'
  final LockPurpose purpose;
  final String? contractId;

  // Reference to original asset
  final TaxLien? lien;
  final TaxLienNFT? nft;

  LockedAsset({
    required this.id,
    required this.assetId,
    required this.assetType,
    required this.lockedAt,
    required this.unlockAt,
    required this.collateralValue,
    required this.loanAmount,
    required this.repaymentAmount,
    required this.status,
    required this.purpose,
    this.contractId,
    this.lien,
    this.nft,
  });

  bool get canUnlock {
    if (status != 'locked') return false;
    if (purpose == LockPurpose.voluntary) return true;
    return DateTime.now().isAfter(unlockAt);
  }

  int get daysRemaining {
    return unlockAt.difference(DateTime.now()).inDays;
  }

  String get assetName {
    if (assetType == AssetType.nft && nft != null) {
      return nft!.name;
    }
    if (assetType == AssetType.traditional && lien != null) {
      return lien!.propertyAddress;
    }
    return 'Asset #$assetId';
  }

  String get imageUrl {
    if (assetType == AssetType.nft && nft != null) {
      return nft!.imageUrl;
    }
    if (assetType == AssetType.traditional && lien != null) {
      return lien!.images.isNotEmpty ? lien!.images.first : '';
    }
    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetId': assetId,
      'assetType': assetType.toString(),
      'lockedAt': lockedAt.toIso8601String(),
      'unlockAt': unlockAt.toIso8601String(),
      'collateralValue': collateralValue,
      'loanAmount': loanAmount,
      'repaymentAmount': repaymentAmount,
      'status': status,
      'purpose': purpose.toString(),
      'contractId': contractId,
    };
  }

  factory LockedAsset.fromJson(Map<String, dynamic> json) {
    return LockedAsset(
      id: json['id'],
      assetId: json['assetId'],
      assetType: json['assetType'] == 'AssetType.nft'
          ? AssetType.nft
          : AssetType.traditional,
      lockedAt: DateTime.parse(json['lockedAt']),
      unlockAt: DateTime.parse(json['unlockAt']),
      collateralValue: json['collateralValue'].toDouble(),
      loanAmount: json['loanAmount'].toDouble(),
      repaymentAmount: json['repaymentAmount'].toDouble(),
      status: json['status'],
      purpose: _parseLockPurpose(json['purpose']),
      contractId: json['contractId'],
    );
  }

  static LockPurpose _parseLockPurpose(String purpose) {
    if (purpose.contains('collateral')) return LockPurpose.collateral;
    if (purpose.contains('staking')) return LockPurpose.staking;
    if (purpose.contains('escrow')) return LockPurpose.escrow;
    return LockPurpose.voluntary;
  }
}

/// Price suggestion from AI
class PriceSuggestion {
  final double recommended;
  final double minimum;
  final double maximum;
  final String confidence; // 'high', 'medium', 'low'
  final List<String> factors;

  PriceSuggestion({
    required this.recommended,
    required this.minimum,
    required this.maximum,
    required this.confidence,
    required this.factors,
  });

  factory PriceSuggestion.defaultSuggestion() {
    return PriceSuggestion(
      recommended: 0,
      minimum: 0,
      maximum: 0,
      confidence: 'low',
      factors: ['Недостаточно данных для анализа'],
    );
  }
}

/// Portfolio statistics
class UnifiedPortfolioStats {
  final double totalValue;
  final double traditionalValue;
  final double nftValue;
  final int totalCount;
  final int traditionalCount;
  final int nftCount;
  final double weightedROI;
  final double traditionalROI;
  final double nftROI;
  final int lockedCount;
  final double lockedValue;

  UnifiedPortfolioStats({
    required this.totalValue,
    required this.traditionalValue,
    required this.nftValue,
    required this.totalCount,
    required this.traditionalCount,
    required this.nftCount,
    required this.weightedROI,
    required this.traditionalROI,
    required this.nftROI,
    required this.lockedCount,
    required this.lockedValue,
  });

  double get nftPercentage =>
      totalValue > 0 ? (nftValue / totalValue) * 100 : 0;
  double get traditionalPercentage =>
      totalValue > 0 ? (traditionalValue / totalValue) * 100 : 0;
  double get lockedPercentage =>
      totalValue > 0 ? (lockedValue / totalValue) * 100 : 0;
}
