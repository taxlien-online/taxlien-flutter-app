import 'package:flutter/material.dart';
// import 'package:flutter_nft/flutter_nft.dart';
// import 'package:flutter_icp/flutter_icp.dart';
import '../core/mocks/nft_mocks.dart';

class PlugWalletScreen extends StatefulWidget {
  final NFTClient nftClient;

  const PlugWalletScreen({
    super.key,
    required this.nftClient,
  });

  @override
  State<PlugWalletScreen> createState() => _PlugWalletScreenState();
}

class _PlugWalletScreenState extends State<PlugWalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plug Wallet'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (widget.plugWalletService.isConnected) {
                widget.plugWalletService.initialize();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          isScrollable: true,
          tabs: const [
            Tab(text: 'Wallet'),
            Tab(text: 'Balance'),
            Tab(text: 'Transactions'),
            Tab(text: 'NFTs'),
            Tab(text: 'Stats'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.plugWalletService,
        builder: (context, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildWalletTab(),
              _buildBalanceTab(),
              _buildTransactionsTab(),
              _buildNFTsTab(),
              _buildStatsTab(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWalletTab() {
    if (widget.plugWalletService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!widget.plugWalletService.isConnected) {
      return _buildConnectionPrompt();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWalletInfoCard(),
          const SizedBox(height: 16),
          _buildQuickActionsCard(),
          const SizedBox(height: 16),
          _buildNetworkInfoCard(),
          const SizedBox(height: 16),
          _buildRecentActivityCard(),
        ],
      ),
    );
  }

  Widget _buildConnectionPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Connect to Plug Wallet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Connect your Plug Wallet to manage ICP tokens and interact with Internet Computer dApps',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _connectWallet(),
                icon: const Icon(Icons.link),
                label: const Text('Connect Wallet'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _openPlugWalletWebsite(),
              child: const Text('Don\'t have Plug Wallet? Get it here'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletInfoCard() {
    final walletInfo = widget.plugWalletService.walletInfo;
    if (walletInfo == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plug Wallet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Connected',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _disconnectWallet(),
                  icon: const Icon(Icons.logout),
                  tooltip: 'Disconnect',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
                'Principal ID',
                widget.plugWalletService
                    .formatPrincipal(walletInfo['principal'] ?? '')),
            _buildInfoRow(
                'Account ID',
                widget.plugWalletService
                    .formatAccountId(walletInfo['accountId'] ?? '')),
            _buildInfoRow('Network',
                widget.plugWalletService.isTestnet ? 'Testnet' : 'Mainnet'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.send,
                    label: 'Send',
                    onTap: () => _showSendDialog(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.download,
                    label: 'Receive',
                    onTap: () => _showReceiveDialog(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.collections,
                    label: 'Import NFT',
                    onTap: () => _showImportNFTDialog(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wifi,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Network Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Network',
                widget.plugWalletService.isTestnet ? 'Testnet' : 'Mainnet'),
            _buildInfoRow('Status', 'Connected'),
            _buildInfoRow('Block Height', '12,345,678'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _tabController.animateTo(2),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: widget.plugWalletService.getTransactionHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Text('No recent activity');
                }

                final transactions = snapshot.data!.take(3).toList();
                return Column(
                  children: transactions
                      .map((tx) => _buildTransactionItem(tx))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceTab() {
    if (!widget.plugWalletService.isConnected) {
      return _buildConnectionPrompt();
    }

    return FutureBuilder<Map<String, double>>(
      future: widget.plugWalletService.getBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load balance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final balances = snapshot.data ?? {};
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTotalBalanceCard(balances),
            const SizedBox(height: 16),
            ...balances.entries
                .map((entry) => _buildBalanceCard(entry.key, entry.value)),
          ],
        );
      },
    );
  }

  Widget _buildTotalBalanceCard(Map<String, double> balances) {
    double totalValue = 0.0;
    balances.forEach((currency, amount) {
      // Mock conversion rates
      switch (currency) {
        case 'ICP':
        case 'WICP':
          totalValue += amount * 12.5;
          break;
        case 'USD':
          totalValue += amount;
          break;
        case 'BTC':
          totalValue += amount * 45000;
          break;
        case 'ETH':
          totalValue += amount * 2500;
          break;
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Total Portfolio Value',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${totalValue.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Assets', balances.length.toString()),
                _buildStatItem('24h Change', '+2.5%'),
                _buildStatItem('7d Change', '+8.3%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(String currency, double amount) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCurrencyColor(currency).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getCurrencyIcon(currency),
                color: _getCurrencyColor(currency),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    widget.plugWalletService.formatBalance(amount, currency),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showSendDialog(currency: currency),
              icon: const Icon(Icons.send),
              tooltip: 'Send $currency',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    if (!widget.plugWalletService.isConnected) {
      return _buildConnectionPrompt();
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.plugWalletService.getTransactionHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load transactions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final transactions = snapshot.data ?? [];
        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No transactions yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your transaction history will appear here',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return _buildTransactionCard(transactions[index]);
          },
        );
      },
    );
  }

  Widget _buildNFTsTab() {
    if (!widget.plugWalletService.isConnected) {
      return _buildConnectionPrompt();
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.plugWalletService.getNFTBalances(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load NFTs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final nfts = snapshot.data ?? [];
        if (nfts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.collections,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No NFTs found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Import your NFTs to get started',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showImportNFTDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Import NFT'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: nfts.length,
          itemBuilder: (context, index) {
            return _buildNFTCard(nfts[index]);
          },
        );
      },
    );
  }

  Widget _buildStatsTab() {
    if (!widget.plugWalletService.isConnected) {
      return _buildConnectionPrompt();
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: widget.plugWalletService.getWalletStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load stats',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final stats = snapshot.data ?? {};
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStatsOverviewCard(stats),
            const SizedBox(height: 16),
            _buildPerformanceCard(),
            const SizedBox(height: 16),
            _buildActivityCard(stats),
          ],
        );
      },
    );
  }

  Widget _buildStatsOverviewCard(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Value',
                    '\$${(stats['totalValue'] ?? 0.0).toStringAsFixed(2)}',
                    Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Transactions',
                    (stats['totalTransactions'] ?? 0).toString(),
                    Icons.receipt_long,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'NFTs',
                    (stats['totalNFTs'] ?? 0).toString(),
                    Icons.collections,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Network',
                    stats['network'] ?? 'Unknown',
                    Icons.wifi,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildPerformanceRow('24h', '+2.5%', Colors.green),
            _buildPerformanceRow('7d', '+8.3%', Colors.green),
            _buildPerformanceRow('30d', '+15.2%', Colors.green),
            _buildPerformanceRow('1y', '+45.7%', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceRow(String period, String change, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            period,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          Text(
            change,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildActivityRow(
                'Last Transaction', stats['lastTransaction'] ?? 'Never'),
            _buildActivityRow('Total Transactions',
                (stats['totalTransactions'] ?? 0).toString()),
            _buildActivityRow('Network', stats['network'] ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final type = transaction['type'] as String;
    final amount = transaction['amount'] as double;
    final currency = transaction['currency'] as String;
    final timestamp = DateTime.parse(transaction['timestamp'] as String);
    final status = transaction['status'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: type == 'send'
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            type == 'send' ? Icons.arrow_upward : Icons.arrow_downward,
            color: type == 'send' ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          '${type == 'send' ? 'Sent' : 'Received'} $currency',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${type == 'send' ? '-' : '+'}${widget.plugWalletService.formatBalance(amount, currency)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: type == 'send' ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: status == 'completed'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          status == 'completed' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        onTap: () => _showTransactionDetails(transaction),
      ),
    );
  }

  Widget _buildNFTCard(Map<String, dynamic> nft) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  nft['image'] ?? 'https://via.placeholder.com/60',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nft['name'] ?? 'Unknown NFT',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nft['description'] ?? 'No description',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Token ID: ${nft['tokenId']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontFamily: 'monospace',
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showNFTDetails(nft),
              icon: const Icon(Icons.info_outline),
              tooltip: 'View Details',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final type = transaction['type'] as String;
    final amount = transaction['amount'] as double;
    final currency = transaction['currency'] as String;
    final timestamp = DateTime.parse(transaction['timestamp'] as String);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: type == 'send'
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              type == 'send' ? Icons.arrow_upward : Icons.arrow_downward,
              color: type == 'send' ? Colors.red : Colors.green,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${type == 'send' ? 'Sent' : 'Received'} $currency',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Text(
            '${type == 'send' ? '-' : '+'}${widget.plugWalletService.formatBalance(amount, currency)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: type == 'send' ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Color _getCurrencyColor(String currency) {
    switch (currency) {
      case 'ICP':
        return Colors.blue;
      case 'WICP':
        return Colors.blue[700]!;
      case 'USD':
        return Colors.green;
      case 'BTC':
        return Colors.orange;
      case 'ETH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCurrencyIcon(String currency) {
    switch (currency) {
      case 'ICP':
      case 'WICP':
        return Icons.currency_bitcoin;
      case 'USD':
        return Icons.attach_money;
      case 'BTC':
        return Icons.currency_bitcoin;
      case 'ETH':
        return Icons.currency_exchange;
      default:
        return Icons.monetization_on;
    }
  }

  // Action methods
  Future<void> _connectWallet() async {
    final success = await widget.plugWalletService.connect();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully connected to Plug Wallet'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.plugWalletService.error ?? 'Failed to connect'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _disconnectWallet() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Wallet'),
        content:
            const Text('Are you sure you want to disconnect from Plug Wallet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await widget.plugWalletService.disconnect();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully disconnected from Plug Wallet'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showSendDialog({String? currency}) {
    final amountController = TextEditingController();
    final addressController = TextEditingController();
    final selectedCurrency = currency ?? 'ICP';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send $selectedCurrency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount ($selectedCurrency)',
                border: const OutlineInputBorder(),
                suffixText: selectedCurrency,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Recipient Address',
                border: OutlineInputBorder(),
                hintText: 'Enter wallet address...',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Available: 100.0 $selectedCurrency',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty &&
                  addressController.text.isNotEmpty) {
                Navigator.pop(context);
                _processSend(selectedCurrency, amountController.text,
                    addressController.text);
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _processSend(String currency, String amount, String address) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending $amount $currency to $address...'),
        backgroundColor: Colors.blue,
      ),
    );

    // Simulate transaction processing
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully sent $amount $currency!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showReceiveDialog() {
    final walletAddress = 'rdmx6-jaaaa-aaaah-qcaiq-cai'; // Mock wallet address

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receive Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this address to receive funds:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                walletAddress,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Copy to clipboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Address copied to clipboard')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Share address
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Share functionality coming soon')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
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

  void _showImportNFTDialog() {
    final nftIdController = TextEditingController();
    final collectionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import NFT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nftIdController,
              decoration: const InputDecoration(
                labelText: 'NFT ID',
                border: OutlineInputBorder(),
                hintText: 'Enter NFT identifier...',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: collectionController,
              decoration: const InputDecoration(
                labelText: 'Collection (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Enter collection name...',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: You can only import NFTs that you own.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nftIdController.text.isNotEmpty) {
                Navigator.pop(context);
                _processImportNFT(
                    nftIdController.text, collectionController.text);
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _processImportNFT(String nftId, String collection) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Importing NFT: $nftId...'),
        backgroundColor: Colors.blue,
      ),
    );

    // Simulate import process
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully imported NFT: $nftId'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Transaction ID', transaction['id'] ?? 'N/A'),
              _buildDetailRow('Type', transaction['type'] ?? 'N/A'),
              _buildDetailRow('Amount',
                  '${transaction['amount'] ?? 'N/A'} ${transaction['currency'] ?? ''}'),
              _buildDetailRow('From', transaction['from'] ?? 'N/A'),
              _buildDetailRow('To', transaction['to'] ?? 'N/A'),
              _buildDetailRow('Status', transaction['status'] ?? 'N/A'),
              _buildDetailRow('Date', transaction['date'] ?? 'N/A'),
              _buildDetailRow('Fee',
                  '${transaction['fee'] ?? 'N/A'} ${transaction['currency'] ?? ''}'),
              if (transaction['memo'] != null)
                _buildDetailRow('Memo', transaction['memo']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Transaction copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  void _showNFTDetails(Map<String, dynamic> nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(nft['name'] ?? 'NFT Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (nft['image'] != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      nft['image'] ?? '🖼️',
                      style: const TextStyle(fontSize: 64),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _buildDetailRow('Name', nft['name'] ?? 'N/A'),
              _buildDetailRow('Collection', nft['collection'] ?? 'N/A'),
              _buildDetailRow('Token ID', nft['tokenId'] ?? 'N/A'),
              _buildDetailRow('Owner', nft['owner'] ?? 'N/A'),
              _buildDetailRow('Description', nft['description'] ?? 'N/A'),
              if (nft['attributes'] != null)
                _buildDetailRow('Attributes', nft['attributes'].toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('NFT details copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy Details'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wallet Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Testnet Mode'),
              subtitle: const Text('Use testnet instead of mainnet'),
              value: widget.plugWalletService.isTestnet,
              onChanged: (value) {
                widget.plugWalletService.switchNetwork(value);
                Navigator.pop(context);
              },
            ),
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

  void _openPlugWalletWebsite() {
    // In a real implementation, this would use url_launcher to open the website
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Plug Wallet'),
        content: const Text(
            'This would open the Plug Wallet website in your browser.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening Plug Wallet website...'),
                  backgroundColor: Colors.blue,
                ),
              );

              // Simulate opening website
              Future.delayed(const Duration(seconds: 1), () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Website opened successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              });
            },
            child: const Text('Open Website'),
          ),
        ],
      ),
    );
  }
}
