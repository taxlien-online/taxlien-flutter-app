import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/tax_lien_magento_service.dart';
import '../core/models/tax_lien_models.dart';
import '../widgets/tax_lien_card.dart';
import '../core/services/magento_api_service.dart';
import '../core/services/hybrid_magento_service.dart';
import '../core/models/magento_models.dart';
import '../core/providers/magento_provider.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  final TaxLienService taxLienService;
  final AuthService authService;
  final TaxLienMagentoService taxLienMagentoService;

  const MarketplaceScreen({
    super.key,
    required this.taxLienService,
    required this.authService,
    required this.taxLienMagentoService,
  });

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<TaxLien> _filteredLiens = [];
  List<TaxLien> _allLiens = [];

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeData();
    widget.taxLienService.addListener(_onTaxLienServiceChanged);
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
      _allLiens = widget.taxLienService.availableLiens.cast<TaxLien>();
      _applyFilters();
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.taxLienService.loadAvailableLiens();
      _allLiens = widget.taxLienService.availableLiens.cast<TaxLien>();
      _applyFilters();
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

  void _applyFilters() {
    List<TaxLien> filtered = List.from(_allLiens);

    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((lien) {
        return lien.propertyAddress.toLowerCase().contains(searchTerm) ||
            lien.owner?.toLowerCase().contains(searchTerm) == true ||
            lien.parcelId?.toLowerCase().contains(searchTerm) == true ||
            lien.county.toLowerCase().contains(searchTerm);
      }).toList();
    }

    setState(() {
      _filteredLiens = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Tax Lien Marketplace'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by address, owner or parcel ID...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _applyFilters(),
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Found: ${_filteredLiens.length} liens',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
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
              onPressed: _initializeData,
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
      onRefresh: _initializeData,
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
                // Toggle favorite functionality
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }

  void _onLienTap(TaxLien lien) {
    // Show lien details
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lien.propertyAddress),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('County: ${lien.county}'),
            Text('State: ${lien.state}'),
            Text('Tax Amount: \$${lien.taxAmount.toStringAsFixed(2)}'),
            Text('Interest Rate: ${lien.interestRate.toStringAsFixed(1)}%'),
            Text('Status: ${lien.status}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
