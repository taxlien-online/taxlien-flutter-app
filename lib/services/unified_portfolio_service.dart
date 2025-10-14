import 'package:flutter/foundation.dart';
import '../core/models/unified_asset.dart';
import '../core/models/tax_lien.dart' as core_lien;
import '../core/models/tax_lien_nft.dart';
import 'tax_lien_service.dart';
import 'nft_service.dart';
import 'database_service.dart';

/// Unified Portfolio Service
/// Manages both traditional tax liens and NFT assets in a unified way
class UnifiedPortfolioService extends ChangeNotifier {
  final TaxLienService _taxLienService;
  final NFTService _nftService;
  final DatabaseService _databaseService;

  // State
  List<AssetItem> _allAssets = [];
  List<LockedAsset> _lockedAssets = [];
  UnifiedPortfolioStats? _stats;
  bool _isLoading = false;
  String? _error;

  UnifiedPortfolioService({
    required TaxLienService taxLienService,
    required NFTService nftService,
    required DatabaseService databaseService,
  })  : _taxLienService = taxLienService,
        _nftService = nftService,
        _databaseService = databaseService;

  // Getters
  List<AssetItem> get allAssets => _allAssets;
  List<LockedAsset> get lockedAssets => _lockedAssets;
  UnifiedPortfolioStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<AssetItem> get traditionalAssets =>
      _allAssets.where((a) => a.isTraditional).toList();
  List<AssetItem> get nftAssets => _allAssets.where((a) => a.isNFT).toList();
  List<AssetItem> get lockedAssetsItems =>
      _allAssets.where((a) => a.isLocked).toList();
  List<AssetItem> get forSaleAssets =>
      _allAssets.where((a) => a.isForSale).toList();

  /// Initialize and load all data
  Future<void> initialize() async {
    await loadAllAssets();
    await loadLockedAssets();
  }

  /// Load all assets (traditional + NFT)
  Future<void> loadAllAssets() async {
    _setLoading(true);
    _clearError();

    try {
      // Load traditional liens
      await _taxLienService.loadMyLiens();
      final legacyLiens = _taxLienService.myLiens;

      // Load NFTs
      final nfts = await _nftService.getAllNFTs();

      // Convert legacy liens to core TaxLien objects
      final liens = await Future.wait(
        legacyLiens.map((legacy) => _taxLienService.getLienById(legacy.id)),
      );
      final validLiens = liens.whereType<core_lien.TaxLien>().toList();

      // Convert to unified AssetItems
      final traditionalAssets =
          validLiens.map((lien) => AssetItem.fromLien(lien)).toList();
      final nftAssets = nfts.map((nft) => AssetItem.fromNFT(nft)).toList();

      _allAssets = [...traditionalAssets, ...nftAssets];

      // Sort by value (highest first)
      _allAssets.sort((a, b) => b.value.compareTo(a.value));

      // Calculate statistics
      _calculateStats();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load assets: $e');
      debugPrint('Error loading assets: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load locked assets
  Future<void> loadLockedAssets() async {
    try {
      final rawAssets = await _databaseService.getLockedAssetsRaw();
      _lockedAssets =
          rawAssets.map((raw) => LockedAsset.fromJson(raw)).toList();

      // Populate with actual asset data
      for (var lockedAsset in _lockedAssets) {
        if (lockedAsset.assetType == AssetType.traditional) {
          final lien = await _taxLienService.getLienById(lockedAsset.assetId);
          if (lien != null) {
            // Update locked asset with lien data
            final index = _lockedAssets.indexOf(lockedAsset);
            _lockedAssets[index] = LockedAsset(
              id: lockedAsset.id,
              assetId: lockedAsset.assetId,
              assetType: lockedAsset.assetType,
              lockedAt: lockedAsset.lockedAt,
              unlockAt: lockedAsset.unlockAt,
              collateralValue: lockedAsset.collateralValue,
              loanAmount: lockedAsset.loanAmount,
              repaymentAmount: lockedAsset.repaymentAmount,
              status: lockedAsset.status,
              purpose: lockedAsset.purpose,
              contractId: lockedAsset.contractId,
              lien: lien as core_lien.TaxLien?,
              nft: null,
            );
          }
        } else if (lockedAsset.assetType == AssetType.nft) {
          final nft = await _nftService.getNFTById(lockedAsset.assetId);
          if (nft != null) {
            final index = _lockedAssets.indexOf(lockedAsset);
            _lockedAssets[index] = LockedAsset(
              id: lockedAsset.id,
              assetId: lockedAsset.assetId,
              assetType: lockedAsset.assetType,
              lockedAt: lockedAsset.lockedAt,
              unlockAt: lockedAsset.unlockAt,
              collateralValue: lockedAsset.collateralValue,
              loanAmount: lockedAsset.loanAmount,
              repaymentAmount: lockedAsset.repaymentAmount,
              status: lockedAsset.status,
              purpose: lockedAsset.purpose,
              contractId: lockedAsset.contractId,
              lien: null,
              nft: nft as TaxLienNFT?,
            );
          }
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading locked assets: $e');
    }
  }

  /// Get tokenizable liens (not locked, active)
  Future<List<core_lien.TaxLien>> getTokenizableLiens() async {
    final legacyLiens = _taxLienService.myLiens;
    final liens = await Future.wait(
      legacyLiens.map((legacy) => _taxLienService.getLienById(legacy.id)),
    );
    return liens
        .whereType<core_lien.TaxLien>()
        .where((lien) => lien.canBeTokenized)
        .toList();
  }

  /// Get detokenizable NFTs (owned by user, not locked)
  List<TaxLienNFT> getDetokenizableNFTs() {
    return nftAssets
        .where((asset) => !asset.isLocked && !asset.isForSale)
        .map((asset) => asset.nft!)
        .toList();
  }

  /// Tokenize a lien (convert to NFT)
  Future<TaxLienNFT?> tokenizeLien({
    required String lienId,
    required TokenizationOptions options,
    required String ownerAddress,
  }) async {
    try {
      // 1. Find the lien
      final lien = await _taxLienService.getLienById(lienId);
      if (lien == null) {
        throw Exception('Lien not found');
      }

      if (!lien.canBeTokenized) {
        throw Exception(
          'Lien cannot be tokenized (already locked or not active)',
        );
      }

      // 2. Create NFT - convert TaxLien to expected format
      final nft = await _nftService.createNFTFromTaxLien(
        lien as dynamic,
        ownerAddress: ownerAddress,
        contractAddress: 'tax-lien-nft-canister-id', // TODO: Get from config
      );

      if (nft == null) {
        throw Exception('Failed to create NFT');
      }

      // 3. Lock the original lien
      await _taxLienService.lockLien(lienId, nftId: nft.id);

      // 4. Reload assets
      await loadAllAssets();

      return nft;
    } catch (e) {
      debugPrint('Error tokenizing lien: $e');
      _setError('Failed to tokenize lien: $e');
      return null;
    }
  }

  /// Detokenize an NFT (convert back to traditional lien)
  Future<bool> detokenizeNFT(String nftId) async {
    try {
      // 1. Get the NFT
      final nft = await _nftService.getNFTById(nftId);
      if (nft == null) {
        throw Exception('NFT not found');
      }

      // 2. Get original lien
      final lienId = nft.originalLien.id.toString();

      // 3. Unlock the lien
      await _taxLienService.unlockLien(lienId);

      // 4. Burn/delete NFT
      await _nftService.deleteNFT(nftId);

      // 5. Reload assets
      await loadAllAssets();

      return true;
    } catch (e) {
      debugPrint('Error detokenizing NFT: $e');
      _setError('Failed to detokenize NFT: $e');
      return false;
    }
  }

  /// Get asset by ID (searches both types)
  AssetItem? getAssetById(String id) {
    try {
      return _allAssets.firstWhere((asset) => asset.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filter assets by view mode
  List<AssetItem> getAssetsByViewMode(PortfolioViewMode mode) {
    switch (mode) {
      case PortfolioViewMode.unified:
        return _allAssets;
      case PortfolioViewMode.traditional:
        return traditionalAssets;
      case PortfolioViewMode.nft:
        return nftAssets;
    }
  }

  /// Search assets
  List<AssetItem> searchAssets(String query) {
    if (query.isEmpty) return _allAssets;

    final lowerQuery = query.toLowerCase();
    return _allAssets.where((asset) {
      return asset.title.toLowerCase().contains(lowerQuery) ||
          asset.subtitle.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Sort assets
  void sortAssets(AssetSortBy sortBy, {bool ascending = false}) {
    switch (sortBy) {
      case AssetSortBy.value:
        _allAssets.sort(
          (a, b) => ascending
              ? a.value.compareTo(b.value)
              : b.value.compareTo(a.value),
        );
        break;
      case AssetSortBy.roi:
        _allAssets.sort(
          (a, b) => ascending ? a.roi.compareTo(b.roi) : b.roi.compareTo(a.roi),
        );
        break;
      case AssetSortBy.date:
        _allAssets.sort(
          (a, b) => ascending
              ? a.createdAt.compareTo(b.createdAt)
              : b.createdAt.compareTo(a.createdAt),
        );
        break;
      case AssetSortBy.type:
        _allAssets.sort((a, b) {
          if (a.type == b.type) return 0;
          return ascending ? (a.isNFT ? 1 : -1) : (a.isNFT ? -1 : 1);
        });
        break;
    }
    notifyListeners();
  }

  /// Calculate portfolio statistics
  void _calculateStats() {
    final traditionalValue = traditionalAssets.fold<double>(
      0,
      (sum, asset) => sum + asset.value,
    );

    final nftValue = nftAssets.fold<double>(
      0,
      (sum, asset) => sum + asset.value,
    );

    final totalValue = traditionalValue + nftValue;

    // Calculate ROI
    final traditionalROI = traditionalAssets.isEmpty
        ? 0.0
        : traditionalAssets.fold<double>(0, (sum, a) => sum + a.roi) /
            traditionalAssets.length;

    final nftROI = nftAssets.isEmpty
        ? 0.0
        : nftAssets.fold<double>(0, (sum, a) => sum + a.roi) / nftAssets.length;

    final weightedROI = totalValue > 0
        ? (traditionalROI * traditionalValue + nftROI * nftValue) / totalValue
        : 0.0;

    // Locked assets
    final lockedValue = lockedAssetsItems.fold<double>(
      0,
      (sum, asset) => sum + asset.value,
    );

    _stats = UnifiedPortfolioStats(
      totalValue: totalValue,
      traditionalValue: traditionalValue,
      nftValue: nftValue,
      totalCount: _allAssets.length,
      traditionalCount: traditionalAssets.length,
      nftCount: nftAssets.length,
      weightedROI: weightedROI,
      traditionalROI: traditionalROI,
      nftROI: nftROI,
      lockedCount: lockedAssetsItems.length,
      lockedValue: lockedValue,
    );
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadAllAssets();
    await loadLockedAssets();
  }

  // Private helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    // Clean up
    super.dispose();
  }
}

/// Sort options for assets
enum AssetSortBy { value, roi, date, type }
