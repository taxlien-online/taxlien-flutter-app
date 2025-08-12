import 'package:flutter/material.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/tax_lien_card.dart';

class MyInvestmentsScreen extends StatefulWidget {
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;

  const MyInvestmentsScreen({
    super.key,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
  });

  @override
  State<MyInvestmentsScreen> createState() => _MyInvestmentsScreenState();
}

class _MyInvestmentsScreenState extends State<MyInvestmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TaxLien> _myLiens = [];
  List<TaxLien> _favoriteLiens = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
    widget.taxLienService.addListener(_onTaxLienServiceChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.taxLienService.removeListener(_onTaxLienServiceChanged);
    super.dispose();
  }

  void _onTaxLienServiceChanged() {
    if (mounted) {
      setState(() {
        _myLiens = widget.taxLienService.myLiens;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.taxLienService.loadMyLiens();
      _myLiens = widget.taxLienService.myLiens;
      
      // Загрузка избранных закладных
      final favoriteIds = await widget.databaseService.getFavoriteLienIds();
      _favoriteLiens = widget.taxLienService.availableLiens
          .where((lien) => favoriteIds.contains(lien.id))
          .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои инвестиции'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Мои закладные'),
            Tab(text: 'Избранное'),
            Tab(text: 'Статистика'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyLiensTab(),
          _buildFavoritesTab(),
          _buildStatisticsTab(),
        ],
      ),
    );
  }

  Widget _buildMyLiensTab() {
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
              onPressed: _loadData,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_myLiens.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'У вас пока нет инвестиций',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Перейдите на рынок, чтобы купить налоговые закладные',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Навигация к рынку
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Перейти на рынок'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _myLiens.length,
        itemBuilder: (context, index) {
          final lien = _myLiens[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
    );
  }

  Widget _buildFavoritesTab() {
    if (_favoriteLiens.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет избранных закладных',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Добавляйте закладные в избранное для быстрого доступа',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favoriteLiens.length,
        itemBuilder: (context, index) {
          final lien = _favoriteLiens[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TaxLienCard(
              lien: lien,
              onTap: () => _showLienDetails(lien),
              onFavoriteToggle: () async {
                await widget.databaseService.removeFromFavorites(lien.id);
                setState(() {
                  _favoriteLiens.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsTab() {
    final totalInvested = _myLiens.fold<double>(
      0,
      (sum, lien) => sum + (lien.salePrice ?? lien.taxAmount),
    );

    final totalValue = _myLiens.fold<double>(
      0,
      (sum, lien) {
        if (lien.status == 'redeemed') {
          return sum + (lien.salePrice ?? lien.taxAmount);
        } else {
          // Расчет текущей стоимости с учетом процентов
          final daysHeld = DateTime.now().difference(lien.auctionDate).inDays;
          final interestEarned = (lien.salePrice ?? lien.taxAmount) * 
              (lien.interestRate / 100) * (daysHeld / 365);
          return sum + (lien.salePrice ?? lien.taxAmount) + interestEarned;
        }
      },
    );

    final activeLiens = _myLiens.where((lien) => lien.status == 'sold').length;
    final redeemedLiens = _myLiens.where((lien) => lien.status == 'redeemed').length;
    final foreclosedLiens = _myLiens.where((lien) => lien.status == 'foreclosed').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Общая статистика
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Общая статистика',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('Всего инвестировано', '\$${totalInvested.toStringAsFixed(2)}'),
                  _buildStatRow('Текущая стоимость', '\$${totalValue.toStringAsFixed(2)}'),
                  _buildStatRow('Прибыль/убыток', '\$${(totalValue - totalInvested).toStringAsFixed(2)}',
                      color: totalValue >= totalInvested ? Colors.green : Colors.red),
                  _buildStatRow('ROI', '${((totalValue - totalInvested) / totalInvested * 100).toStringAsFixed(1)}%',
                      color: totalValue >= totalInvested ? Colors.green : Colors.red),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Статистика по статусам
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статистика по статусам',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('Активные закладные', activeLiens.toString()),
                  _buildStatRow('Погашенные закладные', redeemedLiens.toString()),
                  _buildStatRow('Обращенные в собственность', foreclosedLiens.toString()),
                  _buildStatRow('Всего закладных', _myLiens.length.toString()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // График доходности
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Доходность по месяцам',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: _buildProfitChart(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Топ закладных по доходности
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Топ закладных по доходности',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._myLiens
                      .where((lien) => lien.status == 'sold')
                      .take(5)
                      .map((lien) => _buildTopLienTile(lien)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitChart() {
    // Простая реализация графика
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'График доходности\n(в разработке)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTopLienTile(TaxLien lien) {
    final daysHeld = DateTime.now().difference(lien.auctionDate).inDays;
    final interestEarned = (lien.salePrice ?? lien.taxAmount) * 
        (lien.interestRate / 100) * (daysHeld / 365);
    final roi = interestEarned / (lien.salePrice ?? lien.taxAmount) * 100;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          '${roi.toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      title: Text(lien.address),
      subtitle: Text('ROI: ${roi.toStringAsFixed(1)}%'),
      trailing: Text(
        '\$${interestEarned.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      onTap: () => _showLienDetails(lien),
    );
  }

  void _showLienDetails(TaxLien lien) {
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
}

class TaxLienDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Закладная #${lien.parcelId}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Основная информация
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Информация об инвестиции
            if (lien.status == 'sold' || lien.status == 'redeemed')
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Информация об инвестиции',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Дата покупки', _formatDate(lien.auctionDate)),
                      _buildDetailRow('Сумма покупки', '\$${(lien.salePrice ?? lien.taxAmount).toStringAsFixed(2)}'),
                      if (lien.status == 'sold') ...[
                        _buildDetailRow('Дней в инвестиции', 
                            DateTime.now().difference(lien.auctionDate).inDays.toString()),
                        _buildDetailRow('Заработанные проценты', 
                            _calculateInterestEarned(lien).toStringAsFixed(2)),
                      ],
                      if (lien.status == 'redeemed')
                        _buildDetailRow('Дата погашения', _formatDate(lien.redemptionDeadline)),
                    ],
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
      padding: const EdgeInsets.symmetric(vertical: 4),
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

  double _calculateInterestEarned(TaxLien lien) {
    final daysHeld = DateTime.now().difference(lien.auctionDate).inDays;
    return (lien.salePrice ?? lien.taxAmount) * 
        (lien.interestRate / 100) * (daysHeld / 365);
  }
}
