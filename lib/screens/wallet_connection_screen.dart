import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WalletConnectionScreen extends StatefulWidget {
  final WalletService walletService;
  final VoidCallback onWalletConnected;

  const WalletConnectionScreen({
    super.key,
    required this.walletService,
    required this.onWalletConnected,
  });

  @override
  State<WalletConnectionScreen> createState() => _WalletConnectionScreenState();
}

class _WalletConnectionScreenState extends State<WalletConnectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    Expanded(
                      child: _buildWalletList(),
                    ),
                    const SizedBox(height: 20),
                    _buildSkipButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.account_balance_wallet,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Connect Your Wallet',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Connect your crypto wallet to manage your NFT tax liens and participate in the marketplace',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWalletList() {
    return ListenableBuilder(
      listenable: widget.walletService,
      builder: (context, child) {
        if (widget.walletService.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        if (widget.walletService.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${widget.walletService.error}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.walletService.clearError();
                    widget.walletService.loadAvailableWallets();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: widget.walletService.availableWallets.length,
          itemBuilder: (context, index) {
            final wallet = widget.walletService.availableWallets[index];
            return _buildWalletCard(wallet);
          },
        );
      },
    );
  }

  Widget _buildWalletCard(WalletInfo wallet) {
    final isConnected = wallet.isConnected;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: isConnected ? null : () => _connectWallet(wallet.type),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isConnected
                  ? LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.1),
                        Colors.green.withOpacity(0.05),
                      ],
                    )
                  : null,
            ),
            child: Row(
              children: [
                _buildWalletIcon(wallet.type),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            wallet.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isConnected) ...[
                            const SizedBox(width: 8),
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
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getWalletDescription(wallet.type),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (wallet.balance != null)
                        Text(
                          'Balance: ${wallet.balance!.toStringAsFixed(4)} ETH',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Chains: ${wallet.supportedChains.join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isConnected)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
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
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 30,
      ),
    );
  }

  String _getWalletDescription(String walletType) {
    switch (walletType) {
      case 'metamask':
        return 'Most popular Ethereum wallet with browser extension';
      case 'walletconnect':
        return 'Connect any wallet via QR code or deep linking';
      case 'coinbase':
        return 'User-friendly wallet from Coinbase exchange';
      default:
        return 'Crypto wallet for managing digital assets';
    }
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: () {
        widget.onWalletConnected();
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white.withOpacity(0.8),
      ),
      child: const Text(
        'Skip for now',
        style: TextStyle(fontSize: 16),
      ),
    );
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
      
      // Wait a bit before proceeding
      await Future.delayed(const Duration(seconds: 1));
      widget.onWalletConnected();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect to ${walletType}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
