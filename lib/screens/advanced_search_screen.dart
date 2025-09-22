import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/magento_models.dart';
import '../core/models/tax_lien_models.dart';
import '../services/tax_lien_service.dart';
import '../core/services/magento_api_service.dart';
import '../widgets/advanced_search_filters.dart';
import '../widgets/search_results_list.dart';

class AdvancedSearchScreen extends ConsumerStatefulWidget {
  final TaxLienService taxLienService;
  final MagentoApiService magentoApiService;
  final bool useModernView;

  const AdvancedSearchScreen({
    Key? key,
    required this.taxLienService,
    required this.magentoApiService,
    this.useModernView = true,
  }) : super(key: key);

  @override
  ConsumerState<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends ConsumerState<AdvancedSearchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  // Search state
  bool _isSearching = false;
  String? _searchError;
  
  // Results
  List<MagentoProduct> _magentoResults = [];
  List<TaxLien> _taxLienResults = [];
  
  // Advanced filters
  AdvancedSearchFilters _filters = AdvancedSearchFilters();
  
  // Pagination
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreResults = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Modern', icon: Icon(Icons.store)),
            Tab(text: 'Legacy', icon: Icon(Icons.real_estate_agent)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _clearAllFilters,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear all filters',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          
          // Advanced filters
          _buildAdvancedFilters(),
          
          // Results
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildModernResults(),
                _buildLegacyResults(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by address, owner, parcel ID, or product name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _performSearch();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
                if (value.length >= 3) {
                  _debounceSearch();
                }
              },
              onSubmitted: (value) => _performSearch(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _isSearching ? null : _performSearch,
            icon: _isSearching
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
            label: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Advanced Filters',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _showFiltersDialog,
                child: const Text('Configure'),
              ),
            ],
          ),
          if (_filters.hasActiveFilters()) ...[
            const SizedBox(height: 8),
            _buildActiveFiltersChips(),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: _filters.getActiveFilters().map((filter) {
        return Chip(
          label: Text(filter.label),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () => _removeFilter(filter.key),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 12,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModernResults() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching modern marketplace...'),
          ],
        ),
      );
    }

    if (_searchError != null) {
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
              'Search Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _searchError!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_magentoResults.isEmpty && _searchController.text.isNotEmpty) {
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
              'No Results Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms or filters',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (_magentoResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Start Your Search',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter search terms and configure filters to find tax lien products',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return SearchResultsList(
      magentoProducts: _magentoResults,
      onLoadMore: _hasMoreResults ? _loadMoreResults : null,
      isLoadingMore: _isSearching,
    );
  }

  Widget _buildLegacyResults() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching legacy tax liens...'),
          ],
        ),
      );
    }

    if (_searchError != null) {
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
              'Search Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _searchError!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_taxLienResults.isEmpty && _searchController.text.isNotEmpty) {
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
              'No Results Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms or filters',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (_taxLienResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.real_estate_agent,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Legacy Tax Liens',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Find traditional tax lien properties with advanced filtering',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _taxLienResults.length,
      itemBuilder: (context, index) {
        final lien = _taxLienResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(lien.address),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${lien.county}, ${lien.state}'),
                Text('Parcel ID: ${lien.parcelId}'),
                Text('Tax Amount: \$${lien.taxAmount.toStringAsFixed(2)}'),
                Text('Interest Rate: ${lien.interestRate}%'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${lien.taxAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${lien.interestRate}% APR',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            onTap: () {
              // Navigate to tax lien details
              _showTaxLienDetails(lien);
            },
          ),
        );
      },
    );
  }

  void _debounceSearch() {
    // Debounce search to avoid too many API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text.length >= 3) {
        _performSearch();
      }
    });
  }

  Future<void> _performSearch() async {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _magentoResults.clear();
        _taxLienResults.clear();
        _searchError = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
      _currentPage = 1;
      _hasMoreResults = true;
    });

    try {
      if (_tabController.index == 0) {
        // Search modern marketplace
        await _searchMagentoProducts();
      } else {
        // Search legacy tax liens
        await _searchTaxLiens();
      }
    } catch (e) {
      setState(() {
        _searchError = e.toString();
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _searchMagentoProducts() async {
    try {
      final results = await widget.magentoApiService.searchProducts(
        query: _searchController.text,
        page: _currentPage,
        pageSize: _pageSize,
        filters: _filters.toMagentoFilters(),
      );

      setState(() {
        if (_currentPage == 1) {
          _magentoResults = results.items;
        } else {
          _magentoResults.addAll(results.items);
        }
        _hasMoreResults = results.items.length >= _pageSize;
      });
    } catch (e) {
      throw Exception('Failed to search Magento products: $e');
    }
  }

  Future<void> _searchTaxLiens() async {
    try {
      final results = await widget.taxLienService.searchTaxLiens(
        query: _searchController.text,
        filters: _filters.toTaxLienFilters(),
      );

      setState(() {
        _taxLienResults = results;
      });
    } catch (e) {
      throw Exception('Failed to search tax liens: $e');
    }
  }

  Future<void> _loadMoreResults() async {
    if (_isSearching || !_hasMoreResults) return;

    _currentPage++;
    await _performSearch();
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => AdvancedFiltersDialog(
        filters: _filters,
        onFiltersChanged: (newFilters) {
          setState(() {
            _filters = newFilters;
          });
          _performSearch();
        },
      ),
    );
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _filters = _filters.removeFilter(filterKey);
    });
    _performSearch();
  }

  void _clearAllFilters() {
    setState(() {
      _filters = AdvancedSearchFilters();
      _searchController.clear();
      _magentoResults.clear();
      _taxLienResults.clear();
      _searchError = null;
    });
  }

  void _showTaxLienDetails(TaxLien lien) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lien.address),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('County: ${lien.county}'),
            Text('State: ${lien.state}'),
            Text('Parcel ID: ${lien.parcelId}'),
            Text('Owner: ${lien.owner}'),
            Text('Tax Amount: \$${lien.taxAmount.toStringAsFixed(2)}'),
            Text('Interest Rate: ${lien.interestRate}%'),
            Text('Issue Date: ${lien.issueDate}'),
            Text('Status: ${lien.status}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add to favorites or show purchase options
            },
            child: const Text('Add to Favorites'),
          ),
        ],
      ),
    );
  }
}
