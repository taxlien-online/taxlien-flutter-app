import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
      setState(() {
        _allLiens = widget.taxLienService.availableLiens;
        _applyFilters();
      });
    }
  }

  Future<void> _loadLiens() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.taxLienService.loadAvailableLiens();
      _allLiens = widget.taxLienService.availableLiens;
      _applyFilters();
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки данных: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        title: const Text('Рынок налоговых закладных'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
            tooltip: 'Фильтры',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLiens,
            tooltip: 'Обновить',
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
                hintText: 'Поиск по адресу, владельцу или ID участка...',
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
                    child: const Text('Очистить'),
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
                  'Найдено: ${_filteredLiens.length} закладных',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                if (_filteredLiens.isNotEmpty)
                  Text(
                    'Сортировка: ${_getSortLabel()}',
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
              child: const Text('Повторить'),
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
              'Налоговые закладные не найдены',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить параметры поиска или фильтры',
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
    if (_selectedState != null) filters.add('Штат: $_selectedState');
    if (_selectedCounty != null) filters.add('Округ: $_selectedCounty');
    if (_minAmount != null) filters.add('От: \$${_minAmount!.toStringAsFixed(2)}');
    if (_maxAmount != null) filters.add('До: \$${_maxAmount!.toStringAsFixed(2)}');
    if (_minInterestRate != null) filters.add('Ставка от: ${_minInterestRate!.toStringAsFixed(1)}%');
    return filters.join(', ');
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'auctionDate':
        return 'Дата аукциона ${_sortAscending ? '↑' : '↓'}';
      case 'taxAmount':
        return 'Сумма налога ${_sortAscending ? '↑' : '↓'}';
      case 'interestRate':
        return 'Процентная ставка ${_sortAscending ? '↑' : '↓'}';
      case 'assessedValue':
        return 'Оценочная стоимость ${_sortAscending ? '↑' : '↓'}';
      case 'redemptionDeadline':
        return 'Срок погашения ${_sortAscending ? '↑' : '↓'}';
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
        title: Text('Закладная #${lien.parcelId}'),
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
                      'Владелец: ${widget.lien.owner}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Сумма налога',
                            '\$${widget.lien.taxAmount.toStringAsFixed(2)}',
                            Icons.attach_money,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Процентная ставка',
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
                            'Оценочная стоимость',
                            '\$${widget.lien.assessedValue.toStringAsFixed(2)}',
                            Icons.assessment,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Дата аукциона',
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
                      'Дополнительная информация',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('ID участка', lien.parcelId),
                    _buildDetailRow('Округ', lien.county),
                    _buildDetailRow('Штат', lien.state),
                    _buildDetailRow('Срок погашения', _formatDate(lien.redemptionDeadline)),
                    _buildDetailRow('Статус', _getStatusLabel(lien.status)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Кнопка покупки
            if (lien.status == 'available' && authService.isAuthenticated)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showPurchaseDialog(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Купить закладную',
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
    switch (status) {
      case 'available':
        return 'Доступна для покупки';
      case 'sold':
        return 'Продана';
      case 'redeemed':
        return 'Погашена';
      case 'foreclosed':
        return 'Обращена в собственность';
      default:
        return status;
    }
  }

  void _showPurchaseDialog(BuildContext context) {
    final bidController = TextEditingController(text: widget.lien.taxAmount.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Покупка закладной'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Введите сумму ставки (минимум \$${widget.lien.taxAmount.toStringAsFixed(2)}):'),
            const SizedBox(height: 16),
            TextField(
              controller: bidController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сумма ставки',
                prefixText: '\$',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final bidAmount = double.tryParse(bidController.text);
              if (bidAmount != null && bidAmount >= widget.lien.taxAmount) {
                Navigator.pop(context);
                final success = await widget.taxLienService.purchaseLien(widget.lien.id, bidAmount);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Закладная успешно куплена!')),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.taxLienService.error ?? 'Ошибка при покупке'),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Неверная сумма ставки')),
                );
              }
            },
            child: const Text('Купить'),
          ),
        ],
      ),
    );
  }
}
