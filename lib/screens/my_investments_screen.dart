import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myInvestments),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.myLiens),
            Tab(text: l10n.favorites),
            Tab(text: l10n.statistics),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: l10n.refresh,
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
      final l10n = AppLocalizations.of(context)!;
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
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_myLiens.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
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
              l10n.noInvestmentsYet,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.goToMarketplace,
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
              child: Text(l10n.goToMarketplaceButton),
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
      final l10n = AppLocalizations.of(context)!;
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
              l10n.noFavoriteLiens,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addToFavoritesHint,
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
    final l10n = AppLocalizations.of(context)!;
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
                    l10n.overallStatistics,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow(l10n.totalInvested, '\$${totalInvested.toStringAsFixed(2)}'),
                  _buildStatRow(l10n.currentValue, '\$${totalValue.toStringAsFixed(2)}'),
                  _buildStatRow(l10n.profitLoss, '\$${(totalValue - totalInvested).toStringAsFixed(2)}',
                      color: totalValue >= totalInvested ? Colors.green : Colors.red),
                  _buildStatRow(l10n.roi, '${((totalValue - totalInvested) / totalInvested * 100).toStringAsFixed(1)}%',
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
                    l10n.statusStatistics,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow(l10n.activeLiens, activeLiens.toString()),
                  _buildStatRow(l10n.redeemedLiens, redeemedLiens.toString()),
                  _buildStatRow(l10n.foreclosedLiens, foreclosedLiens.toString()),
                  _buildStatRow(l10n.totalLiens, _myLiens.length.toString()),
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
                    l10n.monthlyReturns,
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
                    l10n.topPerformingLiens,
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
    final l10n = AppLocalizations.of(context)!;
    // Простая реализация графика
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          l10n.profitChartInDevelopment,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTopLienTile(TaxLien lien) {
    final l10n = AppLocalizations.of(context)!;
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
      subtitle: Text('${l10n.roi}: ${roi.toStringAsFixed(1)}%'),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.lienNumber.replaceAll('{parcelId}', widget.lien.parcelId)}'),
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
                      widget.lien.address,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.owner.replaceAll('{owner}', widget.lien.owner),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            l10n.taxAmount,
                            '\$${widget.lien.taxAmount.toStringAsFixed(2)}',
                            Icons.attach_money,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            l10n.interestRate,
                            '${widget.lien.interestRate.toStringAsFixed(1)}%',
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
            if (widget.lien.status == 'sold' || widget.lien.status == 'redeemed')
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.investmentInfo,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(l10n.purchaseDate, _formatDate(widget.lien.auctionDate)),
                      _buildDetailRow(l10n.purchaseAmount, '\$${(widget.lien.salePrice ?? widget.lien.taxAmount).toStringAsFixed(2)}'),
                      if (widget.lien.status == 'sold') ...[
                        _buildDetailRow(l10n.daysInInvestment, 
                            DateTime.now().difference(widget.lien.auctionDate).inDays.toString()),
                        _buildDetailRow(l10n.interestEarned, 
                            _calculateInterestEarned(widget.lien).toStringAsFixed(2)),
                      ],
                      if (widget.lien.status == 'redeemed')
                        _buildDetailRow(l10n.redemptionDate, _formatDate(widget.lien.redemptionDeadline)),
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
