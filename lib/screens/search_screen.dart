import 'package:flutter/material.dart';
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
      // Игнорируем ошибки загрузки истории
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
      // Сохраняем поисковый запрос в историю
      await widget.databaseService.saveSearchHistory(query: query);
      await _loadSearchHistory();

      // Выполняем поиск
      final results = await widget.taxLienService.searchLiens();
      
      // Фильтруем результаты по поисковому запросу
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
        _error = 'Ошибка поиска: $e';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск закладных'),
        actions: [
          if (_searchResults.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
              tooltip: 'Очистить результаты',
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
                hintText: 'Поиск по адресу, владельцу, ID участка...',
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

          // Результаты поиска или история
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
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Выполняется поиск...'),
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
              'Ничего не найдено',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить поисковый запрос',
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
        // Заголовок с количеством результатов
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                'Найдено: ${_searchResults.length} закладных',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearSearch,
                child: const Text('Очистить'),
              ),
            ],
          ),
        ),

        // Список результатов
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
              'История поиска пуста',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Ваши поисковые запросы будут отображаться здесь',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Заголовок истории
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.history),
              const SizedBox(width: 8),
              Text(
                'История поиска',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearSearchHistory,
                child: const Text('Очистить'),
              ),
            ],
          ),
        ),

        // Список истории
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
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} дн. назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мин. назад';
    } else {
      return 'Только что';
    }
  }

  void _showLienDetails(TaxLien lien) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaxLienDetailScreen(
          lien: lien,
          taxLienService: widget.taxLienService,
          authService: null, // Не нужен для поиска
          databaseService: widget.databaseService,
        ),
      ),
    );
  }
}

class TaxLienDetailScreen extends StatelessWidget {
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
                      lien.address,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Владелец: ${lien.owner}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Сумма налога',
                            '\$${lien.taxAmount.toStringAsFixed(2)}',
                            Icons.attach_money,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Процентная ставка',
                            '${lien.interestRate.toStringAsFixed(1)}%',
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
                            '\$${lien.assessedValue.toStringAsFixed(2)}',
                            Icons.assessment,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Дата аукциона',
                            _formatDate(lien.auctionDate),
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

            // Кнопка покупки (если пользователь авторизован)
            if (lien.status == 'available' && authService?.isAuthenticated == true)
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
    final bidController = TextEditingController(text: lien.taxAmount.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Покупка закладной'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Введите сумму ставки (минимум \$${lien.taxAmount.toStringAsFixed(2)}):'),
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
              if (bidAmount != null && bidAmount >= lien.taxAmount) {
                Navigator.pop(context);
                final success = await taxLienService.purchaseLien(lien.id, bidAmount);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Закладная успешно куплена!')),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(taxLienService.error ?? 'Ошибка при покупке'),
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
