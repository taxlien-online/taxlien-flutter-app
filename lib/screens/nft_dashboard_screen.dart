import 'package:flutter/material.dart';
import '../services/nft_service.dart';
import '../services/tax_lien_service.dart';
import '../widgets/nft_card.dart';
import '../widgets/nft_detail_dialog.dart';
import '../widgets/mint_nft_dialog.dart';

class NFTDashboardScreen extends StatefulWidget {
  final NFTService nftService;
  final TaxLienService taxLienService;

  const NFTDashboardScreen({
    super.key,
    required this.nftService,
    required this.taxLienService,
  });

  @override
  State<NFTDashboardScreen> createState() => _NFTDashboardScreenState();
}

class _NFTDashboardScreenState extends State<NFTDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
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
        title: const Text('NFT Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              widget.nftService.loadMyNFTs();
              widget.nftService.loadMarketplaceNFTs();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).colorScheme.onPrimary,
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
              tabs: const [
                Tab(text: 'My NFTs'),
                Tab(text: 'Marketplace'),
                Tab(text: 'Mint NFT'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyNFTsTab(),
                _buildMarketplaceTab(),
                _buildMintNFTTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyNFTsTab() {
    return ListenableBuilder(
      listenable: widget.nftService,
      builder: (context, child) {
        if (widget.nftService.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.nftService.error != null) {
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
                  'Error: ${widget.nftService.error}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.nftService.clearError();
                    widget.nftService.loadMyNFTs();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (widget.nftService.myNFTs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.collections,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No NFTs yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Mint your first NFT from a tax lien',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _tabController.animateTo(2);
                  },
                  child: const Text('Mint NFT'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await widget.nftService.loadMyNFTs();
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: widget.nftService.myNFTs.length,
            itemBuilder: (context, index) {
              final nft = widget.nftService.myNFTs[index];
              return NFTCard(
                nft: nft,
                onTap: () => _showNFTDetails(nft),
                onTransfer: () => _showTransferDialog(nft),
                onBurn: () => _showBurnDialog(nft),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMarketplaceTab() {
    return ListenableBuilder(
      listenable: widget.nftService,
      builder: (context, child) {
        if (widget.nftService.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.nftService.marketplaceNFTs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No NFTs in marketplace',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for new listings',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await widget.nftService.loadMarketplaceNFTs();
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: widget.nftService.marketplaceNFTs.length,
            itemBuilder: (context, index) {
              final nft = widget.nftService.marketplaceNFTs[index];
              return NFTCard(
                nft: nft,
                onTap: () => _showNFTDetails(nft),
                showActions: false,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMintNFTTab() {
    return ListenableBuilder(
      listenable: widget.taxLienService,
      builder: (context, child) {
        if (widget.taxLienService.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final availableLiens = widget.taxLienService.myLiens
            .where((lien) => lien.status == 'sold')
            .toList();

        if (availableLiens.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No purchased liens available',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Purchase a tax lien first to mint an NFT',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: availableLiens.length,
          itemBuilder: (context, index) {
            final lien = availableLiens[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text('Tax Lien #${lien.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lien.address),
                    Text('Amount: \$${lien.taxAmount.toStringAsFixed(0)}'),
                    Text('Interest: ${lien.interestRate}%'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () => _showMintDialog(lien),
                  child: const Text('Mint NFT'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNFTDetails(TaxLienNFT nft) {
    showDialog(
      context: context,
      builder: (context) => NFTDetailDialog(nft: nft),
    );
  }

  void _showMintDialog(TaxLien lien) {
    showDialog(
      context: context,
      builder: (context) => MintNFTDialog(
        lien: lien,
        onMint: () async {
          final success = await widget.nftService.mintNFTFromLien(lien);
          if (success && mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('NFT minted successfully!')),
            );
          }
        },
      ),
    );
  }

  void _showTransferDialog(TaxLienNFT nft) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer NFT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Transfer ${nft.metadata.name} to:'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Recipient Address',
                hintText: 'Enter wallet address',
              ),
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
                final success = await widget.nftService.transferNFT(
                  nft.id,
                  controller.text,
                );
                if (success && mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('NFT transferred successfully!')),
                  );
                }
              }
            },
            child: const Text('Transfer'),
          ),
        ],
      ),
    );
  }

  void _showBurnDialog(TaxLienNFT nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Burn NFT'),
        content: Text(
          'Are you sure you want to burn ${nft.metadata.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await widget.nftService.burnNFT(nft.id);
              if (success && mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('NFT burned successfully!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Burn'),
          ),
        ],
      ),
    );
  }
}
