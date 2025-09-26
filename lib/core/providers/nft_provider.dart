import 'package:flutter/foundation.dart';
import '../models/tax_lien_nft.dart';
import '../../services/nft_service.dart';

class NFTProvider extends ChangeNotifier {
  final NFTService _nftService = NFTService.instance;

  List<TaxLienNFT> _nfts = [];
  bool _isLoading = false;
  String? _error;

  List<TaxLienNFT> get nfts => _nfts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all NFTs
  Future<void> loadNFTs() async {
    _setLoading(true);
    _clearError();

    try {
      _nfts = await _nftService.getAllNFTs();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load NFTs: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get NFTs by owner
  Future<void> loadNFTsByOwner(String ownerAddress) async {
    _setLoading(true);
    _clearError();

    try {
      _nfts = await _nftService.getNFTsByOwner(ownerAddress);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load NFTs by owner: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create NFT from TaxLien
  Future<bool> createNFTFromTaxLien({
    required dynamic taxLien,
    required String ownerAddress,
    required String contractAddress,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final nft = await _nftService.createNFTFromTaxLien(
        taxLien,
        ownerAddress: ownerAddress,
        contractAddress: contractAddress,
      );

      if (nft != null) {
        _nfts.add(nft);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to create NFT');
        return false;
      }
    } catch (e) {
      _setError('Failed to create NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update NFT
  Future<bool> updateNFT(TaxLienNFT nft) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _nftService.updateNFT(nft);

      if (success) {
        final index = _nfts.indexWhere((n) => n.id == nft.id);
        if (index != -1) {
          _nfts[index] = nft;
          notifyListeners();
        }
        return true;
      } else {
        _setError('Failed to update NFT');
        return false;
      }
    } catch (e) {
      _setError('Failed to update NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete NFT
  Future<bool> deleteNFT(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _nftService.deleteNFT(id);

      if (success) {
        _nfts.removeWhere((n) => n.id == id);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to delete NFT');
        return false;
      }
    } catch (e) {
      _setError('Failed to delete NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Transfer NFT
  Future<bool> transferNFT(String nftId, String newOwnerAddress) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _nftService.transferNFT(nftId, newOwnerAddress);

      if (success) {
        // Reload NFTs to get updated data
        await loadNFTs();
        return true;
      } else {
        _setError('Failed to transfer NFT');
        return false;
      }
    } catch (e) {
      _setError('Failed to transfer NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sell NFT
  Future<bool> sellNFT(String nftId, double price) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _nftService.sellNFT(nftId, price);

      if (success) {
        // Reload NFTs to get updated data
        await loadNFTs();
        return true;
      } else {
        _setError('Failed to sell NFT');
        return false;
      }
    } catch (e) {
      _setError('Failed to sell NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Complete sale
  Future<bool> completeSale(String nftId, String newOwnerAddress) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _nftService.completeSale(nftId, newOwnerAddress);

      if (success) {
        // Reload NFTs to get updated data
        await loadNFTs();
        return true;
      } else {
        _setError('Failed to complete sale');
        return false;
      }
    } catch (e) {
      _setError('Failed to complete sale: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get NFT by ID
  TaxLienNFT? getNFTById(String id) {
    try {
      return _nfts.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filter NFTs by status
  List<TaxLienNFT> getNFTsByStatus(String status) {
    return _nfts.where((n) => n.status == status).toList();
  }

  // Filter NFTs by owner
  List<TaxLienNFT> getNFTsByOwner(String ownerAddress) {
    return _nfts.where((n) => n.ownerAddress == ownerAddress).toList();
  }

  // Clear all NFTs
  void clearNFTs() {
    _nfts.clear();
    notifyListeners();
  }

  // Private helper methods
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
}
