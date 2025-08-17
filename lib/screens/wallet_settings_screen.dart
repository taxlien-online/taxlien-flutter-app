import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WalletSettingsScreen extends StatefulWidget {
  final WalletService walletService;

  const WalletSettingsScreen({
    super.key,
    required this.walletService,
  });

  @override
  State<WalletSettingsScreen> createState() => _WalletSettingsScreenState();
}

class _WalletSettingsScreenState extends State<WalletSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: widget.walletService,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConnectedWalletSection(),
                const SizedBox(height: 24),
                _buildAvailableWalletsSection(),
                const SizedBox(height: 24),
                _buildNFTBalancesSection(),
                const SizedBox(height: 24),
                _buildWalletActionsSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConnectedWalletSection() {
    final connectedWallet = widget.walletService.connectedWallet;
    
    if (connectedWallet == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Connected Wallet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No wallet connected',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  'Connected Wallet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Connected',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildWalletInfoRow('Name', connectedWallet.name),
            _buildWalletInfoRow('Type', connectedWallet.type.toUpperCase()),
            _buildWalletInfoRow('Address', _formatAddress(connectedWallet.address)),
            if (connectedWallet.balance != null)
              _buildWalletInfoRow('Balance', '${connectedWallet.balance!.toStringAsFixed(4)} ETH'),
            _buildWalletInfoRow('Chains', connectedWallet.supportedChains.join(', ')),
            if (connectedWallet.lastConnected != null)
              _buildWalletInfoRow('Last Connected', _formatDate(connectedWallet.lastConnected!)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableWalletsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.list,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Available Wallets',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...widget.walletService.availableWallets.map((wallet) => _buildWalletListItem(wallet)),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletListItem(WalletInfo wallet) {
    final isConnected = wallet.isConnected;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildWalletIcon(wallet.type),
        title: Text(wallet.name),
        subtitle: Text(
          '${wallet.type.toUpperCase()} • ${wallet.supportedChains.join(', ')}',
        ),
        trailing: isConnected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : TextButton(
                onPressed: () => _connectWallet(wallet.type),
                child: const Text('Connect'),
              ),
      ),
    );
  }

  Widget _buildNFTBalancesSection() {
    if (widget.walletService.nftBalances.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.collections,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'NFT Balances',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No NFTs found in connected wallet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.collections,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'NFT Balances',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...widget.walletService.nftBalances.map((nft) => _buildNFTBalanceItem(nft)),
          ],
        ),
      ),
    );
  }

  Widget _buildNFTBalanceItem(NFTBalance nft) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.collections,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(nft.name),
        subtitle: Text('${nft.symbol} • Balance: ${nft.balance}'),
        trailing: IconButton(
          onPressed: () => _viewNFTDetails(nft),
          icon: const Icon(Icons.info_outline),
        ),
      ),
    );
  }

  Widget _buildWalletActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Wallet Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.walletService.isWalletConnected) ...[
              _buildActionButton(
                'Refresh Balances',
                Icons.refresh,
                () => widget.walletService.loadNFTBalances(),
              ),
              _buildActionButton(
                'Switch Chain',
                Icons.swap_horiz,
                () => _showChainSelector(),
              ),
              _buildActionButton(
                'Sign Message',
                Icons.edit,
                () => _showSignMessageDialog(),
              ),
              _buildActionButton(
                'Disconnect Wallet',
                Icons.logout,
                () => _disconnectWallet(),
                isDestructive: true,
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Connect a wallet to access actions',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWalletInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletIcon(String walletType) {
    IconData iconData;
    Color iconColor;
    
    switch (walletType) {
      case 'metamask':
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.orange;
        break;
      case 'walletconnect':
        iconData = Icons.wifi;
        iconColor = Colors.blue;
        break;
      case 'coinbase':
        iconData = Icons.account_circle;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.grey;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onPressed, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : null,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onPressed,
      ),
    );
  }

  String _formatAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  void _connectWallet(String walletType) async {
    final success = await widget.walletService.connectWallet(walletType);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully connected to ${walletType}'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect to ${walletType}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _disconnectWallet() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Wallet'),
        content: const Text('Are you sure you want to disconnect your wallet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
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
      final success = await widget.walletService.disconnectWallet();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallet disconnected successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showChainSelector() {
    final connectedWallet = widget.walletService.connectedWallet;
    if (connectedWallet == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Chain'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: connectedWallet.supportedChains.map((chain) {
            return ListTile(
              title: Text(chain.toUpperCase()),
              onTap: () async {
                Navigator.of(context).pop();
                final success = await widget.walletService.switchChain(chain);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switched to ${chain.toUpperCase()}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSignMessageDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter a message to sign:'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                Navigator.of(context).pop();
                final success = await widget.walletService.signMessage(controller.text);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message signed successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Sign'),
          ),
        ],
      ),
    );
  }

  void _viewNFTDetails(NFTBalance nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(nft.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Symbol: ${nft.symbol}'),
            Text('Balance: ${nft.balance}'),
            Text('Contract: ${_formatAddress(nft.contractAddress)}'),
            if (nft.metadata != null) ...[
              const SizedBox(height: 8),
              const Text('Metadata:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(nft.metadata!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
