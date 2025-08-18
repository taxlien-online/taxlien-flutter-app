import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/tax_lien_service.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../widgets/tax_lien_card.dart';

class SearchScreen extends StatefulWidget {
  final TaxLienService taxLienService;
  final DatabaseService databaseService;

  const SearchScreen({
    super.key,
    required this.taxLienService,
    required this.databaseService,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<TaxLien> _searchResults = [];
  List<Map<String, dynamic>> _searchHistory = [];
  bool _isLoading = false;
  String? _error;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    try {
      final history = await widget.databaseService.getSearchHistory();
      setState(() {
        _searchHistory = history;
      });
    } catch (e) {
      // Ignore history loading errors
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _isLoading = true;
      _error = null;
    });

    try {
      // Save search query to history
      await widget.databaseService.saveSearchHistory(query: query);
      await _loadSearchHistory();

      // Perform search
      final results = await widget.taxLienService.searchLiens();
      
      // Filter results by search query
      final filteredResults = results.where((lien) {
        final searchTerm = query.toLowerCase();
        return lien.address.toLowerCase().contains(searchTerm) ||
               lien.owner.toLowerCase().contains(searchTerm) ||
               lien.parcelId.toLowerCase().contains(searchTerm) ||
               lien.county.toLowerCase().contains(searchTerm) ||
               lien.state.toLowerCase().contains(searchTerm);
      }).toList();

      setState(() {
        _searchResults = filteredResults;
        _isSearching = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Search error: $e';
        _isSearching = false;
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
      _isSearching = false;
    });
  }

  void _onHistoryItemTap(Map<String, dynamic> historyItem) {
    final query = historyItem['query'] as String;
    _searchController.text = query;
    _performSearch();
  }

  void _clearSearchHistory() async {
    await widget.databaseService.clearSearchHistory();
    setState(() {
      _searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.lienSearch),
        actions: [
          if (_searchResults.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
              tooltip: 'Clear results',
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
                hintText: 'Search by address, owner, parcel ID...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) => _performSearch(),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _searchResults.clear();
                    _isSearching = false;
                  });
                }
              },
            ),
          ),

          // Search results or history
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
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
              onPressed: _performSearch,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.searching),
          ],
        ),
      );
    }

    if (_searchResults.isNotEmpty) {
      return _buildSearchResults();
    }

    if (_searchController.text.isNotEmpty) {
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
              l10n.nothingFound,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tryChangingSearchQuery,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return _buildSearchHistory();
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Results count header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                l10n.foundLiensCount.replaceAll('{count}', _searchResults.length.toString()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearSearch,
                child: const Text('Clear'),
              ),
            ],
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final lien = _searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TaxLienCard(
                  lien: lien,
                  onTap: () => _showLienDetails(lien),
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
        ),
      ],
    );
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.searchHistoryEmpty,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.searchQueriesWillAppearHere,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // History header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.history),
              const SizedBox(width: 8),
              Text(
                l10n.searchHistory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearSearchHistory,
                child: const Text('Clear'),
              ),
            ],
          ),
        ),

        // History list
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final historyItem = _searchHistory[index];
              final query = historyItem['query'] as String;
              final timestamp = DateTime.parse(historyItem['timestamp'] as String);
              
              return ListTile(
                leading: const Icon(Icons.search),
                title: Text(query),
                subtitle: Text(_formatTimestamp(timestamp)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _onHistoryItemTap(historyItem),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return l10n.daysAgo.replaceAll('{days}', difference.inDays.toString());
    } else if (difference.inHours > 0) {
      return l10n.hoursAgo.replaceAll('{hours}', difference.inHours.toString());
    } else if (difference.inMinutes > 0) {
      return l10n.minutesAgo.replaceAll('{minutes}', difference.inMinutes.toString());
    } else {
      return l10n.justNow;
    }
  }

  void _showLienDetails(TaxLien lien) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaxLienDetailScreen(
          lien: lien,
          taxLienService: widget.taxLienService,
          authService: null, // Not needed for search
          databaseService: widget.databaseService,
        ),
      ),
    );
  }
}

class TaxLienDetailScreen extends StatefulWidget {
  final TaxLien lien;
  final TaxLienService taxLienService;
  final AuthService? authService;
  final DatabaseService databaseService;

  const TaxLienDetailScreen({
    super.key,
    required this.lien,
    required this.taxLienService,
    this.authService,
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
              // Share lien information
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main information
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

            // Additional information
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

            // Purchase button (if user is authenticated)
            if (widget.lien.status == 'available' && widget.authService?.isAuthenticated == true)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showPurchaseDialog(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Purchase Lien',
                    style: TextStyle(fontSize: 18),
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
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'available':
        return l10n.availableForPurchase;
      case 'sold':
        return l10n.sold;
      case 'redeemed':
        return l10n.redeemed;
      case 'foreclosed':
        return l10n.foreclosed;
      default:
        return status;
    }
  }

  void _showPurchaseDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bidController = TextEditingController(text: widget.lien.taxAmount.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.purchaseLien),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.enterBidAmount.replaceAll('{amount}', '\$${widget.lien.taxAmount.toStringAsFixed(2)}')),
            const SizedBox(height: 16),
            TextField(
              controller: bidController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bid Amount',
                prefixText: '\$',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final bidAmount = double.tryParse(bidController.text);
              if (bidAmount != null && bidAmount >= widget.lien.taxAmount) {
                Navigator.pop(context);
                final success = await widget.taxLienService.purchaseLien(widget.lien.id, bidAmount);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.lienPurchasedSuccessfully)),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.taxLienService.error ?? l10n.purchaseError),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.invalidBidAmount)),
                );
              }
            },
            child: Text(l10n.purchase),
          ),
        ],
      ),
    );
  }
}
