import 'package:flutter/foundation.dart';
import '../core/models/unified_asset.dart';
import '../core/models/tax_lien_models.dart';
import '../core/models/tax_lien_nft.dart';
import 'database_service.dart';
import 'tax_lien_service.dart';
import 'nft_service.dart';

/// Asset Lock Service
/// Service for locking/unlocking assets as collateral (for Anna's use case)
class AssetLockService extends ChangeNotifier {
  final DatabaseService _databaseService;
  final TaxLienService _taxLienService;
  final NFTService _nftService;

  List<LockedAsset> _lockedAssets = [];
  bool _isLoading = false;
  String? _error;

  AssetLockService({
    required DatabaseService databaseService,
    required TaxLienService taxLienService,
    required NFTService nftService,
  })  : _databaseService = databaseService,
        _taxLienService = taxLienService,
        _nftService = nftService;

  // Getters
  List<LockedAsset> get lockedAssets => _lockedAssets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all locked assets
  Future<void> loadLockedAssets() async {
    _setLoading(true);

    try {
      final rawAssets = await _databaseService.getLockedAssetsRaw();

      _lockedAssets = [];
      for (final rawAsset in rawAssets) {
        final lockedAsset = LockedAsset.fromJson(rawAsset);

        // Load the actual asset data
        if (lockedAsset.assetType == AssetType.traditional) {
          final lien =
              await _taxLienService.getLienById(lockedAsset.assetId);
          if (lien != null) {
            _lockedAssets.add(LockedAsset(
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
              lien: lien,
            ));
          }
        } else if (lockedAsset.assetType == AssetType.nft) {
          final nft = await _nftService.getNFTById(lockedAsset.assetId);
          if (nft != null) {
            _lockedAssets.add(LockedAsset(
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
              nft: nft,
            ));
          }
        }
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load locked assets: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Lock an asset (tax lien or NFT) as collateral
  Future<LockedAsset?> lockAsset({
    required String assetId,
    required AssetType assetType,
    required LockOptions options,
  }) async {
    try {
      // Create locked asset record
      final lockedAsset = LockedAsset(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        assetId: assetId,
        assetType: assetType,
        lockedAt: DateTime.now(),
        unlockAt: DateTime.now().add(Duration(days: options.lockDurationDays)),
        collateralValue: options.collateralValue,
        loanAmount: options.loanAmount,
        repaymentAmount: options.repaymentAmount,
        status: 'locked',
        purpose: options.purpose,
        contractId: 'contract_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Save to database
      await _databaseService.insertLockedAsset(lockedAsset.toJson());

      // Lock the actual asset
      if (assetType == AssetType.traditional) {
        await _taxLienService.lockLien(assetId);
      }
      // NFT locking would be handled differently (update NFT status)

      // Reload locked assets
      await loadLockedAssets();

      return lockedAsset;
    } catch (e) {
      debugPrint('Error locking asset: $e');
      _setError('Failed to lock asset: $e');
      return null;
    }
  }

  /// Unlock an asset (repay loan and release collateral)
  Future<bool> unlockAsset(String lockedAssetId) async {
    try {
      final lockedAsset = _lockedAssets.firstWhere(
        (asset) => asset.id == lockedAssetId,
      );

      // Update status
      await _databaseService.updateLockedAssetStatus(
        lockedAssetId,
        'unlocked',
      );

      // Unlock the actual asset
      if (lockedAsset.assetType == AssetType.traditional) {
        await _taxLienService.unlockLien(lockedAsset.assetId);
      }

      // Reload locked assets
      await loadLockedAssets();

      return true;
    } catch (e) {
      debugPrint('Error unlocking asset: $e');
      _setError('Failed to unlock asset: $e');
      return false;
    }
  }

  /// Calculate total locked value
  double getTotalLockedValue() {
    return _lockedAssets.fold<double>(
      0,
      (sum, asset) => sum + asset.collateralValue,
    );
  }

  /// Calculate total loan amount
  double getTotalLoanAmount() {
    return _lockedAssets.fold<double>(
      0,
      (sum, asset) => sum + asset.loanAmount,
    );
  }

  /// Calculate total repayment amount
  double getTotalRepaymentAmount() {
    return _lockedAssets.fold<double>(
      0,
      (sum, asset) => sum + asset.repaymentAmount,
    );
  }

  /// Get assets that can be unlocked
  List<LockedAsset> getUnlockableAssets() {
    return _lockedAssets.where((asset) => asset.canUnlock).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}

