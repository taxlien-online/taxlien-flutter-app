import 'package:flutter/material.dart';
import 'package:flutter_nft/flutter_nft.dart';
// import 'package:flutter_icp/flutter_icp.dart'; // Not needed here

class YukuMarketplaceScreen extends StatefulWidget {
  final NFTClient nftClient;

  const YukuMarketplaceScreen({
    super.key,
    required this.nftClient,
  });

  @override
  State<YukuMarketplaceScreen> createState() => _YukuMarketplaceScreenState();
}

class _YukuMarketplaceScreenState extends State<YukuMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // Providers
  late MarketplaceProvider _marketplaceProvider;
  late WalletProvider _walletProvider;
  late NFTProvider _nftProvider;

  // State
  bool _isLoading = false;
  String? _error;
  List<NFTListing> _activeListings = [];
  List<NFTListing> _myListings = [];
  List<NFTOffer> _myOffers = [];
  List<NFTOffer> _receivedOffers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });

    // Get providers - handle null safety
    _marketplaceProvider =
        widget.nftClient.getMarketplaceProvider(BlockchainNetwork.icp)!;
    _walletProvider =
        widget.nftClient.getWalletProvider(BlockchainNetwork.icp)!;
    _nftProvider = widget.nftClient.getNFTProvider(BlockchainNetwork.icp)!;

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
      // Load active listings
      _activeListings = await _marketplaceProvider.getActiveListings();

      // Load user's listings and offers if wallet is connected
      if (_walletProvider.isConnected &&
          _walletProvider.connectedAddress != null) {
        _myListings = await _marketplaceProvider
            .getUserListings(_walletProvider.connectedAddress!);
        _myOffers = await _marketplaceProvider
            .getUserOffers(_walletProvider.connectedAddress!);
        _receivedOffers = await _marketplaceProvider.getActiveOffers();
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
        title: const Text('Yuku Marketplace'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
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
            Tab(text: 'Browse', icon: Icon(Icons.store)),
            Tab(text: 'My Listings', icon: Icon(Icons.list)),
            Tab(text: 'My Offers', icon: Icon(Icons.local_offer)),
            Tab(text: 'Received', icon: Icon(Icons.inbox)),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildBrowseTab(),
        _buildMyListingsTab(),
        _buildMyOffersTab(),
        _buildReceivedOffersTab(),
      ],
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

  Widget _buildBrowseTab() {
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

  Widget _buildMyListingsTab() {
    if (!_walletProvider.isConnected) {
      return _buildConnectWalletWidget();
    }

    if (_myListings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Listings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'You haven\'t created any listings yet.',
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
        itemCount: _myListings.length,
        itemBuilder: (context, index) {
          final listing = _myListings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.image),
              ),
              title: Text('NFT #${listing.nftId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.formattedPrice),
                  Text(
                    'Status: ${listing.status.name}',
                    style: TextStyle(
                      color: listing.status == ListingStatus.active
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  if (listing.status == ListingStatus.active)
                    PopupMenuItem(
                      value: 'cancel',
                      child: const Text('Cancel Listing'),
                    ),
                  PopupMenuItem(
                    value: 'details',
                    child: const Text('View Details'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'cancel') {
                    _cancelListing(listing.id);
                  } else if (value == 'details') {
                    _showListingDetails(listing);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyOffersTab() {
    if (!_walletProvider.isConnected) {
      return _buildConnectWalletWidget();
    }

    if (_myOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Offers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'You haven\'t made any offers yet.',
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
        itemCount: _myOffers.length,
        itemBuilder: (context, index) {
          final offer = _myOffers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.local_offer),
              ),
              title: Text('NFT #${offer.nftId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer.formattedAmount),
                  Text(
                    'Status: ${offer.status.name}',
                    style: TextStyle(
                      color: offer.status == OfferStatus.pending
                          ? Colors.orange
                          : offer.status == OfferStatus.accepted
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  if (offer.status == OfferStatus.pending)
                    PopupMenuItem(
                      value: 'cancel',
                      child: const Text('Cancel Offer'),
                    ),
                  PopupMenuItem(
                    value: 'details',
                    child: const Text('View Details'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'cancel') {
                    _cancelOffer(offer.id);
                  } else if (value == 'details') {
                    _showOfferDetails(offer);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceivedOffersTab() {
    if (!_walletProvider.isConnected) {
      return _buildConnectWalletWidget();
    }

    if (_receivedOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Received Offers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'You haven\'t received any offers yet.',
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
        itemCount: _receivedOffers.length,
        itemBuilder: (context, index) {
          final offer = _receivedOffers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.inbox),
              ),
              title: Text('NFT #${offer.nftId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Offer: ${offer.formattedAmount}'),
                  Text('From: ${offer.buyerAddress.substring(0, 10)}...'),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  if (offer.status == OfferStatus.pending) ...[
                    PopupMenuItem(
                      value: 'accept',
                      child: const Text('Accept'),
                    ),
                    PopupMenuItem(
                      value: 'reject',
                      child: const Text('Reject'),
                    ),
                  ],
                  PopupMenuItem(
                    value: 'details',
                    child: const Text('View Details'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'accept') {
                    _acceptOffer(offer.id);
                  } else if (value == 'reject') {
                    _rejectOffer(offer.id);
                  } else if (value == 'details') {
                    _showOfferDetails(offer);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConnectWalletWidget() {
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
            'Connect your wallet to manage your listings and offers.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await _walletProvider.connect();
              _loadData();
            },
            child: const Text('Connect Wallet'),
          ),
        ],
      ),
    );
  }

  Future<void> _buyNFT(NFTListing listing) async {
    if (!_walletProvider.isConnected) {
      await _walletProvider.connect();
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

  Future<void> _cancelListing(String listingId) async {
    try {
      final success = await _marketplaceProvider.cancelListing(listingId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel listing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cancelOffer(String offerId) async {
    try {
      final success = await _marketplaceProvider.cancelOffer(offerId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _acceptOffer(String offerId) async {
    try {
      final success = await _marketplaceProvider.acceptOffer(offerId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer accepted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectOffer(String offerId) async {
    try {
      final success = await _marketplaceProvider.rejectOffer(offerId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer rejected successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showListingDetails(NFTListing listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Listing Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NFT ID: ${listing.nftId}'),
            Text('Price: ${listing.formattedPrice}'),
            Text('Status: ${listing.status.name}'),
            Text('Created: ${listing.createdAt.toString()}'),
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

  void _showOfferDetails(NFTOffer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Offer Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NFT ID: ${offer.nftId}'),
            Text('Amount: ${offer.formattedAmount}'),
            Text('Status: ${offer.status.name}'),
            Text('Created: ${offer.createdAt.toString()}'),
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
