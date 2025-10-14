import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/models/unified_asset.dart';
import '../services/unified_portfolio_service.dart';
import '../services/tax_lien_service.dart';
import '../services/nft_service.dart';
import '../services/yuku_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../widgets/tokenization_wizard.dart';
import '../widgets/detokenization_dialog.dart';

/// Unified Portfolio Dashboard
/// Shows both traditional liens and NFTs in one place
class UnifiedPortfolioDashboardScreen extends StatefulWidget {
  final UnifiedPortfolioService portfolioService;
  final TaxLienService taxLienService;
  final NFTService nftService;
  final YukuService? yukuService;

  const UnifiedPortfolioDashboardScreen({
    super.key,
    required this.portfolioService,
    required this.taxLienService,
    required this.nftService,
    this.yukuService,
  });

  @override
  State<UnifiedPortfolioDashboardScreen> createState() =>
      _UnifiedPortfolioDashboardScreenState();
}

class _UnifiedPortfolioDashboardScreenState
    extends State<UnifiedPortfolioDashboardScreen> {
  PortfolioViewMode _viewMode = PortfolioViewMode.unified;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await widget.portfolioService.loadAllAssets();
    await widget.portfolioService.loadLockedAssets();
  }

  Future<void> _refresh() async {
    await widget.portfolioService.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой Портфель'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: AnimatedBuilder(
          animation: widget.portfolioService,
          builder: (context, _) {
            if (widget.portfolioService.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.portfolioService.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(widget.portfolioService.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unified Overview
                  _buildUnifiedOverview(),
                  const SizedBox(height: AppDimensions.lg),

                  // Conversion Panel
                  _buildConversionPanel(),
                  const SizedBox(height: AppDimensions.lg),

                  // Search
                  _buildSearchBar(),
                  const SizedBox(height: AppDimensions.md),

                  // View Mode Toggle
                  _buildViewModeToggle(),
                  const SizedBox(height: AppDimensions.md),

                  // Assets List
                  _buildAssetsList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUnifiedOverview() {
    final stats = widget.portfolioService.stats;
    if (stats == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.dashboard, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Общий Портфель',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Total Value
            const Text(
              'Общая стоимость',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${stats.totalValue.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Breakdown: Traditional vs NFT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Traditional Assets
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Классические',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${stats.traditionalValue.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${stats.traditionalCount} залогов',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.trending_up,
                                color: Colors.greenAccent, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${stats.traditionalROI.toStringAsFixed(1)}% ROI',
                              style: const TextStyle(
                                  color: Colors.greenAccent, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    height: 80,
                    width: 1,
                    color: Colors.white.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),

                  // NFT Assets
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.collections,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'NFT',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${stats.nftValue.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${stats.nftCount} NFT',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.trending_up,
                                color: Colors.cyanAccent, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${stats.nftROI.toStringAsFixed(1)}% ROI',
                              style: const TextStyle(
                                  color: Colors.cyanAccent, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Weighted Average ROI
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calculate, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Средневзвешенный ROI: ',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  '${stats.weightedROI.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildConversionPanel() {
    final tokenizableCount = widget.portfolioService
        .getTokenizableLiens()
        .length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.swap_horiz, color: Colors.indigo, size: 28),
                SizedBox(width: 12),
                Text(
                  'Управление Активами',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Вы можете конвертировать активы между формами в зависимости от ваших целей:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Conversion Options
            Row(
              children: [
                // Traditional → NFT
                Expanded(
                  child: _buildConversionOption(
                    fromIcon: Icons.account_balance,
                    toIcon: Icons.collections,
                    description: 'Токенизировать',
                    color: Colors.blue,
                    benefits: [
                      '✓ Продажа на Yuku',
                      '✓ Дробное владение',
                      '✓ Ликвидность',
                    ],
                    onTap: () => _showTokenizationCandidates(),
                  ),
                ),
                const SizedBox(width: 16),

                // NFT → Traditional
                Expanded(
                  child: _buildConversionOption(
                    fromIcon: Icons.collections,
                    toIcon: Icons.account_balance,
                    description: 'Детокенизировать',
                    color: Colors.green,
                    benefits: [
                      '✓ Прямое управление',
                      '✓ Меньше комиссий',
                      '✓ Полный контроль',
                    ],
                    onTap: () => _showDetokenizationCandidates(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Stats
            if (tokenizableCount > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.amber.shade800, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'У вас есть $tokenizableCount залогов, доступных для конвертации в NFT',
                        style: TextStyle(
                            fontSize: 12, color: Colors.amber.shade900),
                      ),
                    ),
                    TextButton(
                      onPressed: _showTokenizationCandidates,
                      child: const Text('Смотреть →'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionOption({
    required IconData fromIcon,
    required IconData toIcon,
    required String description,
    required Color color,
    required List<String> benefits,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Column(
          children: [
            // Icons with arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(fromIcon, color: color, size: 32),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: color.withOpacity(0.6), size: 20),
                const SizedBox(width: 8),
                Icon(toIcon, color: color, size: 32),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color.shade800,
              ),
            ),
            const SizedBox(height: 8),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    benefit,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                )),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Начать', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Поиск активов...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      onChanged: (value) {
        setState(() => _searchQuery = value);
      },
    );
  }

  Widget _buildViewModeToggle() {
    return Row(
      children: [
        const Text(
          'Показать: ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SegmentedButton<PortfolioViewMode>(
            segments: const [
              ButtonSegment(
                value: PortfolioViewMode.unified,
                label: Text('Все', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.dashboard, size: 16),
              ),
              ButtonSegment(
                value: PortfolioViewMode.traditional,
                label: Text('Залоги', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.account_balance, size: 16),
              ),
              ButtonSegment(
                value: PortfolioViewMode.nft,
                label: Text('NFT', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.collections, size: 16),
              ),
            ],
            selected: {_viewMode},
            onSelectionChanged: (Set<PortfolioViewMode> newSelection) {
              setState(() => _viewMode = newSelection.first);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAssetsList() {
    var assets = widget.portfolioService.getAssetsByViewMode(_viewMode);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      assets = widget.portfolioService.searchAssets(_searchQuery);
    }

    if (assets.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Активов не найдено',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        return _buildAssetCard(assets[index]);
      },
    );
  }

  Widget _buildAssetCard(AssetItem asset) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _viewAssetDetails(asset),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Preview Image
              if (asset.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    asset.imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.home, color: Colors.grey),
                    ),
                  ),
                )
              else
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.home, color: Colors.grey),
                ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Type Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: asset.isNFT
                                ? Colors.purple.shade50
                                : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                asset.isNFT
                                    ? Icons.collections
                                    : Icons.account_balance,
                                size: 12,
                                color: asset.isNFT ? Colors.purple : Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                asset.isNFT ? 'NFT' : 'Залог',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      asset.isNFT ? Colors.purple : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Status Badge
                        if (asset.isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lock, size: 12, color: Colors.orange.shade700),
                                const SizedBox(width: 4),
                                Text(
                                  'Locked',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (asset.isForSale)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.store, size: 12, color: Colors.green.shade700),
                                const SizedBox(width: 4),
                                Text(
                                  'На Yuku',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      asset.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset.subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            size: 16, color: Colors.green),
                        Text(
                          '\$${asset.value.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.trending_up, size: 16, color: Colors.blue),
                        Text(
                          '${asset.roi.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Menu
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => _buildAssetActions(asset),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry> _buildAssetActions(AssetItem asset) {
    final actions = <PopupMenuEntry>[];

    if (asset.isNFT) {
      // NFT actions
      if (!asset.isForSale) {
        actions.add(
          PopupMenuItem(
            child: const ListTile(
              leading: Icon(Icons.store),
              title: Text('Продать на Yuku'),
              contentPadding: EdgeInsets.zero,
            ),
            onTap: () => _listNFTOnYuku(asset),
          ),
        );
      }

      actions.add(
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Детокенизировать'),
            contentPadding: EdgeInsets.zero,
          ),
          onTap: () => _detokenizeNFT(asset),
        ),
      );
    } else {
      // Traditional lien actions
      if (asset.lien!.canBeTokenized) {
        actions.add(
          PopupMenuItem(
            child: const ListTile(
              leading: Icon(Icons.collections),
              title: Text('Токенизировать'),
              contentPadding: EdgeInsets.zero,
            ),
            onTap: () => _tokenizeLien(asset),
          ),
        );
      }
    }

    actions.add(
      PopupMenuItem(
        child: const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Детали'),
          contentPadding: EdgeInsets.zero,
        ),
        onTap: () => _viewAssetDetails(asset),
      ),
    );

    return actions;
  }

  // Action handlers
  void _showTokenizationCandidates() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TokenizationWizard(
        portfolioService: widget.portfolioService,
        yukuService: widget.yukuService,
        walletAddress: 'user-wallet-address', // TODO: Get from auth
      ),
    );

    if (result == true) {
      _refresh();
    }
  }

  void _showDetokenizationCandidates() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetokenizationCandidatesScreen(
        portfolioService: widget.portfolioService,
      ),
    );

    if (result == true) {
      _refresh();
    }
  }

  void _viewAssetDetails(AssetItem asset) {
    // Navigate to details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${asset.title}')),
    );
  }

  void _listNFTOnYuku(AssetItem asset) {
    // Will integrate with Yuku in Module 8
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Listing ${asset.title} on Yuku...')),
    );
  }

  void _detokenizeNFT(AssetItem asset) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DetokenizationDialog(
        nftAsset: asset,
        portfolioService: widget.portfolioService,
      ),
    );

    if (result == true) {
      _refresh();
    }
  }

  void _tokenizeLien(AssetItem asset) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TokenizationWizard(
        portfolioService: widget.portfolioService,
        yukuService: widget.yukuService,
        walletAddress: 'user-wallet-address', // TODO: Get from auth
      ),
    );

    if (result == true) {
      _refresh();
    }
  }
}

