import 'package:flutter/material.dart';
// import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
// import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
import '../services/tax_lien_service.dart';
import '../widgets/nft_card.dart';
import '../widgets/nft_detail_dialog.dart';
import '../widgets/mint_nft_dialog.dart';

class NFTDashboardScreen extends StatefulWidget {
  final NFTClient nftClient;
  final TaxLienService taxLienService;

  const NFTDashboardScreen({
    super.key,
    required this.nftClient,
    required this.taxLienService,
  });

  @override
  State<NFTDashboardScreen> createState() => _NFTDashboardScreenState();
}

class _NFTDashboardScreenState extends State<NFTDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  // NFT providers
  late NFTProvider _nftProvider;
  late WalletProvider _walletProvider;
  late MarketplaceProvider _marketplaceProvider;

  // State
  bool _isLoading = false;
  String? _error;
  List<NFT> _myNFTs = [];
  List<NFTListing> _activeListings = [];
  String? _connectedAddress;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    // Get providers - handle null safety
    _nftProvider = widget.nftClient.getNFTProvider(BlockchainNetwork.icp)!;
    _walletProvider =
        widget.nftClient.getWalletProvider(BlockchainNetwork.icp)!;
    _marketplaceProvider =
        widget.nftClient.getMarketplaceProvider(BlockchainNetwork.icp)!;

    // Load initial data
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check wallet connection
      if (_walletProvider.isConnected) {
        _connectedAddress = _walletProvider.connectedAddress;

        // Load user's NFTs
        if (_connectedAddress != null) {
          _myNFTs = await _nftProvider.getNFTsByOwner(_connectedAddress!);
        }
      }

      // Load active listings
      _activeListings = await _marketplaceProvider.getActiveListings();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _connectWallet() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final connected = await _walletProvider.connect();
      if (connected) {
        _connectedAddress = _walletProvider.connectedAddress;
        await _loadData();
      } else {
        setState(() {
          _error = 'Failed to connect wallet';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
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
        title: const Text('NFT Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          tabs: const [
            Tab(text: 'My NFTs', icon: Icon(Icons.person)),
            Tab(text: 'Marketplace', icon: Icon(Icons.store)),
            Tab(text: 'Mint', icon: Icon(Icons.add)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMyNFTsTab(),
                    _buildMarketplaceTab(),
                    _buildMintTab(),
                  ],
                ),
    );
  }

  Widget _buildErrorWidget() {
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
            'Error',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _error = null;
              });
              _loadData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildMyNFTsTab() {
    if (!_walletProvider.isConnected || _connectedAddress == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Connect Wallet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Connect your wallet to view your NFTs',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _connectWallet,
              child: const Text('Connect Wallet'),
            ),
          ],
        ),
      );
    }

    if (_myNFTs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No NFTs Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'You don\'t have any NFTs yet. Mint one from your tax liens!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _myNFTs.length,
        itemBuilder: (context, index) {
          final nft = _myNFTs[index];
          return NFTCard(
            nft: nft,
            onTap: () => _showNFTDetails(nft),
          );
        },
      ),
    );
  }

  Widget _buildMarketplaceTab() {
    if (_activeListings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Listings Available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'There are no NFT listings available at the moment.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _activeListings.length,
        itemBuilder: (context, index) {
          final listing = _activeListings[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 48),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NFT #${listing.nftId}',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        listing.formattedPrice,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _buyNFT(listing),
                          child: const Text('Buy'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMintTab() {
    return FutureBuilder<List<dynamic>>(
      future: widget.taxLienService.getTaxLiens(),
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
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading tax liens',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(snapshot.error.toString()),
              ],
            ),
          );
        }

        final taxLiens = snapshot.data ?? [];

        if (taxLiens.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Tax Liens Available',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'You need to have tax liens to mint NFTs.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: taxLiens.length,
          itemBuilder: (context, index) {
            final lien = taxLiens[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.receipt, color: Colors.white),
                ),
                title: Text(lien.propertyAddress ?? 'Unknown Property'),
                subtitle:
                    Text('Amount: \$${lien.lienAmount?.toStringAsFixed(2)}'),
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

  void _showNFTDetails(NFT nft) {
    showDialog(
      context: context,
      builder: (context) => NFTDetailDialog(nft: nft),
    );
  }

  void _showMintDialog(dynamic lien) {
    showDialog(
      context: context,
      builder: (context) => MintNFTDialog(
        lien: lien,
        onMint: () async {
          try {
            final success = await _mintNFTFromLien(lien);
            if (success && mounted) {
              Navigator.of(context).pop();
              _loadData(); // Refresh data
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to mint NFT: $e')),
              );
            }
          }
        },
      ),
    );
  }

  Future<bool> _mintNFTFromLien(dynamic lien) async {
    if (_connectedAddress == null) return false;

    try {
      final metadata = NFTMetadata(
        name: 'Tax Lien NFT #${lien.id}',
        description: 'NFT representing tax lien for ${lien.propertyAddress}',
        image: 'https://via.placeholder.com/300x300.png?text=Tax+Lien+NFT',
        attributes: {
          'Property Address': lien.propertyAddress ?? 'Unknown',
          'Lien Amount': lien.lienAmount?.toString() ?? '0',
          'Interest Rate': lien.interestRate?.toString() ?? '0',
          'Type': 'Tax Lien',
        },
        properties: {
          'lien_id': lien.id.toString(),
          'minted_at': DateTime.now().toIso8601String(),
        },
      );

      await _nftProvider.mintNFT(
        toAddress: _connectedAddress!,
        metadata: metadata,
        contractAddress:
            'tax-lien-nft-canister-id', // Replace with actual canister ID
      );

      return true;
    } catch (e) {
      throw Exception('Failed to mint NFT: $e');
    }
  }

  Future<void> _buyNFT(NFTListing listing) async {
    if (!_walletProvider.isConnected) {
      await _connectWallet();
      return;
    }

    try {
      final transactionHash = await _marketplaceProvider.buyNFT(
        listingId: listing.id,
        buyerAddress: _walletProvider.connectedAddress!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('NFT purchased! Transaction: $transactionHash'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to buy NFT: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
