import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/tax_lien_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class MarketplaceScreen extends StatefulWidget {
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
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<TaxLien> _filteredLiens = [];
  List<TaxLien> _allLiens = [];
  bool _isLoading = false;
  String? _error;
  
  // Фильтры
  String? _selectedState;
  String? _selectedCounty;
  double? _minAmount;
  double? _maxAmount;
  double? _minInterestRate;
  String _sortBy = 'auctionDate';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadLiens();
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
      _allLiens = widget.taxLienService.availableLiens;
      _applyFilters();
    }
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
          _error = AppLocalizations.of(context)?.dataLoadError(e.toString()) ?? 'Data loading error: $e';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.taxLienMarketplace ?? 'Tax Lien Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
            tooltip: AppLocalizations.of(context)?.filters ?? 'Filters',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLiens,
            tooltip: AppLocalizations.of(context)?.refresh ?? 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Поисковая строка
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.searchHint ?? 'Search by address, owner or parcel ID...',
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
              onChanged: (value) => _applyFilters(),
            ),
          ),

          // Информация о фильтрах
          if (_selectedState != null || _selectedCounty != null || _minAmount != null || _maxAmount != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _buildFilterSummary(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedState = null;
                        _selectedCounty = null;
                        _minAmount = null;
                        _maxAmount = null;
                        _minInterestRate = null;
                        _sortBy = 'auctionDate';
                        _sortAscending = true;
                      });
                      _applyFilters();
                    },
                    child: Text(AppLocalizations.of(context)?.clear ?? 'Clear'),
                  ),
                ],
              ),
            ),

          // Счетчик результатов
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)?.foundLiens(_filteredLiens.length) ?? 'Found: ${_filteredLiens.length} liens',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                if (_filteredLiens.isNotEmpty)
                  Text(
                    AppLocalizations.of(context)?.sortBy(_getSortLabel()) ?? 'Sort by: ${_getSortLabel()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Список закладных
          Expanded(
            child: _buildLiensList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLiensList() {
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
              child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
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
              AppLocalizations.of(context)?.noLiensFound ?? 'No tax liens found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)?.tryChangingSearch ?? 'Try changing search parameters or filters',
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
    if (_selectedState != null) filters.add(AppLocalizations.of(context)?.stateFilter(_selectedState!) ?? 'State: $_selectedState');
    if (_selectedCounty != null) filters.add(AppLocalizations.of(context)?.countyFilter(_selectedCounty!) ?? 'County: $_selectedCounty');
    if (_minAmount != null) filters.add(AppLocalizations.of(context)?.amountFrom(_minAmount!.toStringAsFixed(2)) ?? 'From: \$${_minAmount!.toStringAsFixed(2)}');
    if (_maxAmount != null) filters.add(AppLocalizations.of(context)?.amountTo(_maxAmount!.toStringAsFixed(2)) ?? 'To: \$${_maxAmount!.toStringAsFixed(2)}');
    if (_minInterestRate != null) filters.add(AppLocalizations.of(context)?.interestRateFrom(_minInterestRate!.toStringAsFixed(1)) ?? 'Rate from: ${_minInterestRate!.toStringAsFixed(1)}%');
    return filters.join(', ');
  }

  String _getSortLabel() {
    final direction = _sortAscending ? '↑' : '↓';
    switch (_sortBy) {
      case 'auctionDate':
        return AppLocalizations.of(context)?.auctionDateSort(direction) ?? 'Auction Date $direction';
      case 'taxAmount':
        return AppLocalizations.of(context)?.taxAmountSort(direction) ?? 'Tax Amount $direction';
      case 'interestRate':
        return AppLocalizations.of(context)?.interestRateSort(direction) ?? 'Interest Rate $direction';
      case 'assessedValue':
        return AppLocalizations.of(context)?.assessedValueSort(direction) ?? 'Assessed Value $direction';
      case 'redemptionDeadline':
        return AppLocalizations.of(context)?.redemptionDeadlineSort(direction) ?? 'Redemption Deadline $direction';
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
        title: Text(AppLocalizations.of(context)?.lienNumber(widget.lien.parcelId) ?? 'Lien #${widget.lien.parcelId}'),
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
                      AppLocalizations.of(context)?.owner(widget.lien.owner) ?? 'Owner: ${widget.lien.owner}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            AppLocalizations.of(context)?.taxAmount ?? 'Tax Amount',
                            '\$${widget.lien.taxAmount.toStringAsFixed(2)}',
                            Icons.attach_money,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            AppLocalizations.of(context)?.interestRate ?? 'Interest Rate',
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
                            AppLocalizations.of(context)?.assessedValue ?? 'Assessed Value',
                            '\$${widget.lien.assessedValue.toStringAsFixed(2)}',
                            Icons.assessment,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            AppLocalizations.of(context)?.auctionDate ?? 'Auction Date',
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
                      AppLocalizations.of(context)?.additionalInfo ?? 'Additional Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Parcel ID', widget.lien.parcelId),
                    _buildDetailRow(AppLocalizations.of(context)?.county ?? 'County', widget.lien.county),
                    _buildDetailRow(AppLocalizations.of(context)?.state ?? 'State', widget.lien.state),
                    _buildDetailRow(AppLocalizations.of(context)?.redemptionDeadline ?? 'Redemption Deadline', _formatDate(widget.lien.redemptionDeadline)),
                    _buildDetailRow(AppLocalizations.of(context)?.status ?? 'Status', _getStatusLabel(widget.lien.status)),
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
                    AppLocalizations.of(context)?.buyLien ?? 'Buy Lien',
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
        return AppLocalizations.of(context)?.availableForPurchase ?? 'Available for purchase';
      case 'sold':
        return AppLocalizations.of(context)?.sold ?? 'Sold';
      case 'redeemed':
        return AppLocalizations.of(context)?.redeemed ?? 'Redeemed';
      case 'foreclosed':
        return AppLocalizations.of(context)?.foreclosed ?? 'Foreclosed';
      default:
        return status;
    }
  }

  void _showPurchaseDialog(BuildContext context) {
    final bidController = TextEditingController(text: widget.lien.taxAmount.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.purchaseLien ?? 'Purchase Lien'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)?.enterBidAmount(widget.lien.taxAmount.toStringAsFixed(2)) ?? 'Enter bid amount (minimum \$${widget.lien.taxAmount.toStringAsFixed(2)}):'),
            const SizedBox(height: 16),
            TextField(
              controller: bidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.bidAmount ?? 'Bid Amount',
                prefixText: '\$',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final bidAmount = double.tryParse(bidController.text);
              if (bidAmount != null && bidAmount >= widget.lien.taxAmount) {
                Navigator.pop(context);
                final success = await widget.taxLienService.purchaseLien(widget.lien.id, bidAmount);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)?.lienPurchasedSuccessfully ?? 'Lien purchased successfully!')),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.taxLienService.error ?? (AppLocalizations.of(context)?.purchaseError ?? 'Purchase error')),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)?.invalidBidAmount ?? 'Invalid bid amount')),
                );
              }
            },
            child: Text(AppLocalizations.of(context)?.buy ?? 'Buy'),
          ),
        ],
      ),
    );
  }
}
