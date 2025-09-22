import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/tax_lien_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../core/services/magento_api_service.dart';
import '../core/models/magento_models.dart';
import '../widgets/enhanced_product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_filter_bar.dart';
import 'product_detail_screen.dart';
import 'advanced_search_screen.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;

  const MarketplaceScreen({
    super.key,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
  });

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Magento products
  List<MagentoProduct> _products = [];
  List<MagentoCategory> _categories = [];
  MagentoProductList? _productList;
  
  // Legacy tax liens
  List<TaxLien> _filteredLiens = [];
  List<TaxLien> _allLiens = [];
  
  // State management
  bool _isLoading = false;
  String? _error;
  bool _useModernView = true;
  bool _sortAscending = true;
  Set<String> _favoriteProductIds = {};
  
  // Filters
  MagentoCategory? _selectedCategory;
  String? _selectedState;
  String? _selectedCounty;
  double? _minAmount;
  double? _maxAmount;
  double? _minInterestRate;
  String _sortBy = 'price';
  String _sortOrder = 'ASC';
  
  // Pagination
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _isLoadingMore = false;
  bool _hasMoreItems = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
    widget.taxLienService.addListener(_onTaxLienServiceChanged);
    _loadFavoriteProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    widget.taxLienService.removeListener(_onTaxLienServiceChanged);
    super.dispose();
  }

  void _onTaxLienServiceChanged() {
    if (mounted) {
      _allLiens = widget.taxLienService.availableLiens;
      if (!_useModernView) {
        _applyFilters();
      }
    }
  }

  Future<void> _loadFavoriteProducts() async {
    try {
      final favoriteIds = await widget.databaseService.getFavoriteLienIds();
      if (mounted) {
        setState(() {
          _favoriteProductIds = favoriteIds.toSet();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load favorite products: $e');
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoadingMore && _hasMoreItems && _useModernView) {
        _loadMoreProducts();
      }
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Future.wait([
        _loadCategories(),
        _useModernView ? _loadProducts() : _loadLiens(),
      ]);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load data: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadCategories() async {
    final magentoState = ref.read(magentoProvider);
    final magentoNotifier = ref.read(magentoProvider.notifier);
    
    try {
      final apiService = MagentoApiService();
      final categories = await apiService.getCategories();
      if (categories != null && mounted) {
        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load categories: $e');
      }
    }
  }

  Future<void> _loadProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _currentPage = 1;
        _hasMoreItems = true;
        _isLoading = true;
        _error = null;
      });
    }

    final magentoNotifier = ref.read(magentoProvider.notifier);
    
    await magentoNotifier.loadProducts(
      page: _currentPage,
      pageSize: _pageSize,
      searchQuery: _searchController.text.isNotEmpty ? _searchController.text : null,
      categoryId: _selectedCategory?.id.toString(),
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );

    final magentoState = ref.read(magentoProvider);
    if (magentoState.products != null && mounted) {
      setState(() {
        if (isRefresh || _currentPage == 1) {
          _products = magentoState.products!.items;
        } else {
          _products.addAll(magentoState.products!.items);
        }
        _productList = magentoState.products;
        _hasMoreItems = magentoState.products!.items.length >= _pageSize;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreItems) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    await _loadProducts();

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _loadLiens() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.taxLienService.loadAvailableLiens();
      if (mounted) {
        _allLiens = widget.taxLienService.availableLiens;
        _applyFilters();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Data loading error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    List<TaxLien> filtered = List.from(_allLiens);

    // Фильтр по поиску
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((lien) {
        return lien.address.toLowerCase().contains(searchTerm) ||
               lien.owner.toLowerCase().contains(searchTerm) ||
               lien.parcelId.toLowerCase().contains(searchTerm) ||
               lien.county.toLowerCase().contains(searchTerm);
      }).toList();
    }

    // Фильтр по штату
    if (_selectedState != null) {
      filtered = filtered.where((lien) => lien.state == _selectedState).toList();
    }

    // Фильтр по округу
    if (_selectedCounty != null) {
      filtered = filtered.where((lien) => lien.county == _selectedCounty).toList();
    }

    // Фильтр по сумме
    if (_minAmount != null) {
      filtered = filtered.where((lien) => lien.taxAmount >= _minAmount!).toList();
    }
    if (_maxAmount != null) {
      filtered = filtered.where((lien) => lien.taxAmount <= _maxAmount!).toList();
    }

    // Фильтр по процентной ставке
    if (_minInterestRate != null) {
      filtered = filtered.where((lien) => lien.interestRate >= _minInterestRate!).toList();
    }

    // Сортировка
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'auctionDate':
          comparison = a.auctionDate.compareTo(b.auctionDate);
          break;
        case 'taxAmount':
          comparison = a.taxAmount.compareTo(b.taxAmount);
          break;
        case 'interestRate':
          comparison = a.interestRate.compareTo(b.interestRate);
          break;
        case 'assessedValue':
          comparison = a.assessedValue.compareTo(b.assessedValue);
          break;
        case 'redemptionDeadline':
          comparison = a.redemptionDeadline.compareTo(b.redemptionDeadline);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    setState(() {
      _filteredLiens = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        selectedState: _selectedState,
        selectedCounty: _selectedCounty,
        minAmount: _minAmount,
        maxAmount: _maxAmount,
        minInterestRate: _minInterestRate,
        sortBy: _sortBy,
        sortAscending: _sortAscending,
        onApplyFilters: (filters) {
          setState(() {
            _selectedState = filters['state'];
            _selectedCounty = filters['county'];
            _minAmount = filters['minAmount'];
            _maxAmount = filters['maxAmount'];
            _minInterestRate = filters['minInterestRate'];
            _sortBy = filters['sortBy'];
            _sortAscending = filters['sortAscending'];
          });
          _applyFilters();
        },
      ),
    );
  }

  void _onLienTap(TaxLien lien) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaxLienDetailScreen(
          lien: lien,
          taxLienService: widget.taxLienService,
          authService: widget.authService,
          databaseService: widget.databaseService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final magentoState = ref.watch(magentoProvider);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Tax Lien Marketplace'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          // View toggle
          IconButton(
            icon: Icon(_useModernView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _useModernView = !_useModernView;
              });
              _initializeData();
            },
            tooltip: _useModernView ? 'List View' : 'Grid View',
          ),
          
          // Advanced Search
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdvancedSearchScreen(
                    taxLienService: widget.taxLienService,
                    useModernView: _useModernView,
                  ),
                ),
              );
            },
            tooltip: 'Advanced Search',
          ),
          
          // Refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _useModernView ? _loadProducts(isRefresh: true) : _loadLiens(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Enhanced search bar
          SearchFilterBar(
            searchController: _searchController,
            hintText: _useModernView 
                ? 'Search tax lien products...'
                : 'Search by address, owner or parcel ID...',
            onFilterTap: _showFilterBottomSheet,
            onSortTap: _showSortBottomSheet,
            onSearchChanged: () {
              if (_useModernView) {
                _loadProducts(isRefresh: true);
              } else {
                _applyFilters();
              }
            },
            hasActiveFilters: _hasActiveFilters(),
            activeFiltersText: _buildActiveFiltersText(),
            onClearFilters: _clearAllFilters,
          ),

          // Categories (only for modern view)
          if (_useModernView && _categories.isNotEmpty)
            CategoryChipList(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
                _loadProducts(isRefresh: true);
              },
            ),

          // Quick filters
          if (_useModernView)
            _buildQuickFilters(),

          // Results count and view options
          _buildResultsHeader(),

          // Main content
          Expanded(
            child: _useModernView ? _buildModernProductsList() : _buildLegacyLiensList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    final quickFilters = [
      QuickFilter(
        id: 'available',
        label: 'Available',
        icon: Icons.check_circle,
        count: _products.where((p) => p.status == 1).length,
      ),
      QuickFilter(
        id: 'high_interest',
        label: 'High Interest',
        icon: Icons.trending_up,
        count: _products.where((p) {
          final interestRate = p.customAttributes
              ?.firstWhere((attr) => attr.attributeCode == 'interest_rate', 
                         orElse: () => MagentoProductAttribute(attributeCode: 'interest_rate', value: '0'))
              .value;
          return double.tryParse(interestRate.toString()) != null && 
                 double.parse(interestRate.toString()) > 10.0;
        }).length,
      ),
      QuickFilter(
        id: 'under_10k',
        label: 'Under \$10k',
        icon: Icons.attach_money,
        count: _products.where((p) => (p.price ?? 0) < 10000).length,
      ),
    ];

    return QuickFilterChips(
      filters: quickFilters,
      onFilterSelected: (filter) {
        // Handle quick filter selection
        // Implementation depends on your filtering logic
      },
    );
  }

  Widget _buildResultsHeader() {
    final theme = Theme.of(context);
    final count = _useModernView ? _products.length : _filteredLiens.length;
    final totalCount = _useModernView ? (_productList?.totalCount ?? 0) : _allLiens.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            _useModernView 
                ? 'Showing $count of $totalCount products'
                : 'Found: $count liens',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          if (count > 0)
            Text(
              'Sort by: ${_getSortLabel()}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernProductsList() {
    if (_isLoading && _products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null && _products.isEmpty) {
      return _buildErrorWidget();
    }

    if (_products.isEmpty) {
      return _buildEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: () => _loadProducts(isRefresh: true),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _products.length + (_isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= _products.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final product = _products[index];
          return EnhancedProductCard(
            product: product,
            onTap: () => _showProductDetail(product),
            onFavoriteToggle: () => _toggleFavorite(product),
            onAddToCart: () => _addToCart(product),
                isFavorite: _favoriteProductIds.contains(product.sku)
          );
        },
      ),
    );
  }

  Widget _buildLegacyLiensList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLiens,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredLiens.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No tax liens found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing search parameters or filters',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLiens,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _filteredLiens.length,
        itemBuilder: (context, index) {
          final lien = _filteredLiens[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TaxLienCard(
              lien: lien,
              onTap: () => _onLienTap(lien),
              onFavoriteToggle: () async {
                final isFavorite = await widget.databaseService.isFavorite(lien.id);
                if (isFavorite) {
                  await widget.databaseService.removeFromFavorites(lien.id);
                } else {
                  await widget.databaseService.addToFavorites(lien.id);
                }
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }

  String _buildFilterSummary() {
    final filters = <String>[];
    if (_selectedState != null) filters.add('State: $_selectedState');
    if (_selectedCounty != null) filters.add('County: $_selectedCounty');
    if (_minAmount != null) filters.add('From: \$${_minAmount!.toStringAsFixed(2)}');
    if (_maxAmount != null) filters.add('To: \$${_maxAmount!.toStringAsFixed(2)}');
    if (_minInterestRate != null) filters.add('Rate from: ${_minInterestRate!.toStringAsFixed(1)}%');
    return filters.join(', ');
  }

  // Helper methods for modern view
  void _showProductDetail(MagentoProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          authService: widget.authService,
          databaseService: widget.databaseService,
        ),
      ),
    );
  }

  void _toggleFavorite(MagentoProduct product) async {
    try {
          final productId = product.sku;
      final isCurrentlyFavorite = _favoriteProductIds.contains(productId);
      
      if (isCurrentlyFavorite) {
        await widget.databaseService.removeFromFavorites(productId, type: 'product');
        setState(() {
          _favoriteProductIds.remove(productId);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} removed from favorites')),
          );
        }
      } else {
        await widget.databaseService.addToFavorites(productId, type: 'product');
        setState(() {
          _favoriteProductIds.add(productId);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} added to favorites')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update favorites: $e')),
        );
      }
    }
  }

  void _addToCart(MagentoProduct product) async {
    try {
      final magentoNotifier = ref.read(magentoProvider.notifier);
      
      // Get or create cart
      String? cartId = await widget.databaseService.getCartId();
      if (cartId == null) {
        cartId = await magentoNotifier.createCart();
        if (cartId != null) {
          await widget.databaseService.saveCartId(cartId);
        }
      }
      
      if (cartId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create cart')),
          );
        }
        return;
      }
      
      // Add product to cart
      final success = await magentoNotifier.addToCart(
        cartId: cartId,
        sku: product.sku,
        quantity: 1,
      );
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} added to cart!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add product to cart')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    }
  }

  Widget _buildErrorWidget() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _useModernView ? _loadProducts(isRefresh: true) : _loadLiens(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            _useModernView ? 'No products found' : 'No tax liens found',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing search parameters or filters',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Filter and sort helper methods
  bool _hasActiveFilters() {
    return _selectedCategory != null ||
           _selectedState != null ||
           _selectedCounty != null ||
           _minAmount != null ||
           _maxAmount != null ||
           _minInterestRate != null;
  }

  String? _buildActiveFiltersText() {
    if (!_hasActiveFilters()) return null;
    
    final filters = <String>[];
    if (_selectedCategory != null) filters.add('Category: ${_selectedCategory!.name}');
    if (_selectedState != null) filters.add('State: $_selectedState');
    if (_selectedCounty != null) filters.add('County: $_selectedCounty');
    if (_minAmount != null) filters.add('Min: \$${_minAmount!.toStringAsFixed(2)}');
    if (_maxAmount != null) filters.add('Max: \$${_maxAmount!.toStringAsFixed(2)}');
    if (_minInterestRate != null) filters.add('Rate: ${_minInterestRate!.toStringAsFixed(1)}%');
    
    return filters.join(', ');
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedState = null;
      _selectedCounty = null;
      _minAmount = null;
      _maxAmount = null;
      _minInterestRate = null;
      _sortBy = _useModernView ? 'price' : 'auctionDate';
      _sortOrder = 'ASC';
    });
    
    if (_useModernView) {
      _loadProducts(isRefresh: true);
    } else {
      _applyFilters();
    }
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ..._useModernView ? [
              _buildSortOption('price', 'Price'),
              _buildSortOption('name', 'Name'),
              _buildSortOption('created_at', 'Date Added'),
            ] : [
              _buildSortOption('auctionDate', 'Auction Date'),
              _buildSortOption('taxAmount', 'Tax Amount'),
              _buildSortOption('interestRate', 'Interest Rate'),
              _buildSortOption('assessedValue', 'Assessed Value'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String sortKey, String label) {
    final isSelected = _sortBy == sortKey;
    
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _sortOrder = _sortOrder == 'ASC' ? 'DESC' : 'ASC';
                    });
                    Navigator.pop(context);
                    if (_useModernView) {
                      _loadProducts(isRefresh: true);
                    } else {
                      _applyFilters();
                    }
                  },
                  icon: Icon(_sortOrder == 'ASC' ? Icons.arrow_upward : Icons.arrow_downward),
                ),
                const Icon(Icons.check),
              ],
            )
          : null,
      onTap: () {
        setState(() {
          _sortBy = sortKey;
        });
        Navigator.pop(context);
        if (_useModernView) {
          _loadProducts(isRefresh: true);
        } else {
          _applyFilters();
        }
      },
    );
  }

  String _getSortLabel() {
    final direction = _sortOrder == 'ASC' ? '↑' : '↓';
    switch (_sortBy) {
      case 'price':
        return 'Price $direction';
      case 'name':
        return 'Name $direction';
      case 'created_at':
        return 'Date $direction';
      case 'auctionDate':
        return 'Auction Date $direction';
              case 'taxAmount':
          return 'Tax Amount $direction';
        case 'interestRate':
          return 'Interest Rate $direction';
        case 'assessedValue':
          return 'Assessed Value $direction';
        case 'redemptionDeadline':
          return 'Redemption Deadline $direction';
      default:
        return '';
    }
  }
}

class TaxLienDetailScreen extends StatefulWidget {
  final TaxLien lien;
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;

  const TaxLienDetailScreen({
    super.key,
    required this.lien,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
  });

  @override
  State<TaxLienDetailScreen> createState() => _TaxLienDetailScreenState();
}

class _TaxLienDetailScreenState extends State<TaxLienDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lien #${widget.lien.parcelId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Поделиться информацией о закладной
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Основная информация
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lien.address,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Owner: ${widget.lien.owner}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Tax Amount',
                            '\$${widget.lien.taxAmount.toStringAsFixed(2)}',
                            Icons.attach_money,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Interest Rate',
                            '${widget.lien.interestRate.toStringAsFixed(1)}%',
                            Icons.percent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Assessed Value',
                            '\$${widget.lien.assessedValue.toStringAsFixed(2)}',
                            Icons.assessment,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Auction Date',
                            _formatDate(widget.lien.auctionDate),
                            Icons.event,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Дополнительная информация
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Parcel ID', widget.lien.parcelId),
                    _buildDetailRow('County', widget.lien.county),
                    _buildDetailRow('State', widget.lien.state),
                    _buildDetailRow('Redemption Deadline', _formatDate(widget.lien.redemptionDeadline)),
                    _buildDetailRow('Status', _getStatusLabel(widget.lien.status)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Кнопка покупки
            if (widget.lien.status == 'available' && widget.authService.isAuthenticated)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showPurchaseDialog(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Buy Lien',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'available':
        return 'Available for purchase';
      case 'sold':
        return 'Sold';
      case 'redeemed':
        return 'Redeemed';
      case 'foreclosed':
        return 'Foreclosed';
      default:
        return status;
    }
  }

  void _showPurchaseDialog(BuildContext context) {
    final bidController = TextEditingController(text: widget.lien.taxAmount.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Lien'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter bid amount (minimum \$${widget.lien.taxAmount.toStringAsFixed(2)}):'),
            const SizedBox(height: 16),
            TextField(
              controller: bidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Bid Amount',
                prefixText: '\$',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final bidAmount = double.tryParse(bidController.text);
              if (bidAmount != null && bidAmount >= widget.lien.taxAmount) {
                Navigator.pop(context);
                final success = await widget.taxLienService.purchaseLien(widget.lien.id, bidAmount);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Lien purchased successfully!')),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.taxLienService.error ?? 'Purchase error'),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text('Invalid bid amount')),
                );
              }
            },
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }
}
