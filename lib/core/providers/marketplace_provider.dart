import 'package:flutter/foundation.dart';
import '../models/tax_lien_nft.dart';
import '../../services/nft_service.dart';

class MarketplaceProvider extends ChangeNotifier {
  final NFTService _nftService = NFTService.instance;

  List<TaxLienNFT> _marketplaceNFTs = [];
  List<TaxLienNFT> _userNFTs = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _sortBy = 'newest';

  List<TaxLienNFT> get marketplaceNFTs => _marketplaceNFTs;
  List<TaxLienNFT> get userNFTs => _userNFTs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  // Load marketplace NFTs
  Future<void> loadMarketplaceNFTs() async {
    _setLoading(true);
    _clearError();

    try {
      final allNFTs = await _nftService.getAllNFTs();
      _marketplaceNFTs = allNFTs
          .where((nft) => nft.status == 'for_sale' || nft.status == 'minted')
          .toList();

      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load marketplace NFTs: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load user NFTs
  Future<void> loadUserNFTs(String userAddress) async {
    _setLoading(true);
    _clearError();

    try {
      _userNFTs = await _nftService.getNFTsByOwner(userAddress);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user NFTs: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search NFTs
  void searchNFTs(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Sort NFTs
  void sortNFTs(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
    notifyListeners();
  }

  // Apply filters and sorting
  void _applyFilters() {
    List<TaxLienNFT> filtered = List.from(_marketplaceNFTs);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((nft) =>
              nft.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              nft.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              nft.originalLien.propertyAddress
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered
          .where((nft) =>
              nft.originalLien.propertyType.toLowerCase() ==
              _selectedCategory.toLowerCase())
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'newest':
        filtered.sort((a, b) => b.mintedAt.compareTo(a.mintedAt));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.mintedAt.compareTo(b.mintedAt));
        break;
      case 'price_low':
        filtered.sort((a, b) => (a.salePrice ?? 0).compareTo(b.salePrice ?? 0));
        break;
      case 'price_high':
        filtered.sort((a, b) => (b.salePrice ?? 0).compareTo(a.salePrice ?? 0));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    _marketplaceNFTs = filtered;
  }

  // Buy NFT
  Future<bool> buyNFT(String nftId, String buyerAddress) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _nftService.completeSale(nftId, buyerAddress);

      if (success) {
        // Reload marketplace NFTs
        await loadMarketplaceNFTs();
        return true;
      } else {
        _setError('Failed to buy NFT');
        return false;
      }
    } catch (e) {
      _setError('Failed to buy NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // List NFT for sale
  Future<bool> listNFTForSale(String nftId, double price) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _nftService.sellNFT(nftId, price);

      if (success) {
        // Reload user NFTs and marketplace
        await loadMarketplaceNFTs();
        return true;
      } else {
        _setError('Failed to list NFT for sale');
        return false;
      }
    } catch (e) {
      _setError('Failed to list NFT for sale: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove NFT from sale
  Future<bool> removeNFTFromSale(String nftId) async {
    _setLoading(true);
    _clearError();

    try {
      final nft = await _nftService.getNFTById(nftId);
      if (nft == null) {
        _setError('NFT not found');
        return false;
      }

      final updatedNFT = nft.copyWith(
        status: 'minted',
        salePrice: null,
      );

      final success = await _nftService.updateNFT(updatedNFT);

      if (success) {
        // Reload user NFTs and marketplace
        await loadMarketplaceNFTs();
        return true;
      } else {
        _setError('Failed to remove NFT from sale');
        return false;
      }
    } catch (e) {
      _setError('Failed to remove NFT from sale: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get NFT by ID
  TaxLienNFT? getNFTById(String id) {
    try {
      return _marketplaceNFTs.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get featured NFTs
  List<TaxLienNFT> getFeaturedNFTs() {
    return _marketplaceNFTs.take(6).toList();
  }

  // Get NFTs by price range
  List<TaxLienNFT> getNFTsByPriceRange(double minPrice, double maxPrice) {
    return _marketplaceNFTs.where((nft) {
      final price = nft.salePrice ?? 0;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  // Get NFTs by property type
  List<TaxLienNFT> getNFTsByPropertyType(String propertyType) {
    return _marketplaceNFTs
        .where((nft) =>
            nft.originalLien.propertyType.toLowerCase() ==
            propertyType.toLowerCase())
        .toList();
  }

  // Get NFTs by location
  List<TaxLienNFT> getNFTsByLocation(String state, String? county) {
    return _marketplaceNFTs.where((nft) {
      if (county != null) {
        return nft.originalLien.state.toLowerCase() == state.toLowerCase() &&
            nft.originalLien.county.toLowerCase() == county.toLowerCase();
      }
      return nft.originalLien.state.toLowerCase() == state.toLowerCase();
    }).toList();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'all';
    _sortBy = 'newest';
    _applyFilters();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _clearError();
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
