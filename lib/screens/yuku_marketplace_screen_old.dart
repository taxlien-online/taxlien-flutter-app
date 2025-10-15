import 'package:flutter/material.dart';
// import 'package:flutter_nft/flutter_nft.dart';
// import 'package:flutter_icp/flutter_icp.dart';
import '../core/mocks/nft_mocks.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Yuku Marketplace'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Browse'),
            Tab(text: 'My Listings'),
            Tab(text: 'My Offers'),
            Tab(text: 'Received'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.yukuService,
        builder: (context, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildBrowseTab(),
              _buildMyListingsTab(),
              _buildMyOffersTab(),
              _buildReceivedOffersTab(),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBrowseTab() {
    if (widget.yukuService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.yukuService.activeListings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No active listings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new NFT listings',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => widget.yukuService.loadActiveListings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.yukuService.activeListings.length,
        itemBuilder: (context, index) {
          final listing = widget.yukuService.activeListings[index];
          return _buildListingCard(listing);
        },
      ),
    );
  }

  Widget _buildMyListingsTab() {
    if (widget.yukuService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.yukuService.myListings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_alt_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No listings yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first listing to start selling',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => widget.yukuService.loadMyListings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.yukuService.myListings.length,
        itemBuilder: (context, index) {
          final listing = widget.yukuService.myListings[index];
          return _buildMyListingCard(listing);
        },
      ),
    );
  }

  Widget _buildMyOffersTab() {
    if (widget.yukuService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.yukuService.myOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.attach_money,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No offers made',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Make offers on NFTs you\'re interested in',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => widget.yukuService.loadMyOffers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.yukuService.myOffers.length,
        itemBuilder: (context, index) {
          final offer = widget.yukuService.myOffers[index];
          return _buildOfferCard(offer, isMyOffer: true);
        },
      ),
    );
  }

  Widget _buildReceivedOffersTab() {
    if (widget.yukuService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.yukuService.receivedOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No received offers',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Offers for your NFTs will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => widget.yukuService.loadReceivedOffers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.yukuService.receivedOffers.length,
        itemBuilder: (context, index) {
          final offer = widget.yukuService.receivedOffers[index];
          return _buildOfferCard(offer, isMyOffer: false);
        },
      ),
    );
  }

  Widget _buildListingCard(YukuListing listing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.collections,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Lien NFT #${listing.nftId.split('_').last}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Listed by ${_formatAddress(listing.sellerAddress)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Listed ${_formatDate(listing.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${listing.price.toStringAsFixed(2)} ${listing.currency}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    if (listing.expiresAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Expires ${_formatDate(listing.expiresAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showMakeOfferDialog(listing),
                    child: const Text('Make Offer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _buyNFT(listing),
                    child: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyListingCard(YukuListing listing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.collections,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Lien NFT #${listing.nftId.split('_').last}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${listing.status.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(listing.status),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Listed ${_formatDate(listing.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${listing.price.toStringAsFixed(2)} ${listing.currency}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    if (listing.expiresAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Expires ${_formatDate(listing.expiresAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (listing.status == 'active') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cancelListing(listing),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _viewOffers(listing),
                      child: const Text('View Offers'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(YukuOffer offer, {required bool isMyOffer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.collections,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Lien NFT #${offer.nftId.split('_').last}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isMyOffer
                            ? 'Your offer'
                            : 'Offer from ${_formatAddress(offer.buyerAddress)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${offer.status.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(offer.status),
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${offer.amount.toStringAsFixed(2)} ${offer.currency}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    if (offer.expiresAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Expires ${_formatDate(offer.expiresAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (!isMyOffer && offer.status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectOffer(offer),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptOffer(offer),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
            if (isMyOffer && offer.status == 'pending') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _cancelOffer(offer),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Cancel Offer'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    switch (_currentIndex) {
      case 0: // Browse
        return null;
      case 1: // My Listings
        return FloatingActionButton(
          onPressed: () => _showCreateListingDialog(),
          child: const Icon(Icons.add),
        );
      case 2: // My Offers
        return null;
      case 3: // Received Offers
        return null;
      default:
        return null;
    }
  }

  void _showCreateListingDialog() {
    final nftIdController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCurrency = 'ICP';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Listing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nftIdController,
              decoration: const InputDecoration(
                labelText: 'NFT ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCurrency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              items: ['ICP', 'WICP', 'USD'].map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                selectedCurrency = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nftIdController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                Navigator.pop(context);
                final success = await widget.yukuService.createListing(
                  nftId: nftIdController.text,
                  price: double.parse(priceController.text),
                  currency: selectedCurrency,
                );
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Listing created successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showMakeOfferDialog(YukuListing listing) {
    final amountController = TextEditingController();
    String selectedCurrency = listing.currency;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make Offer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current price: ${listing.price.toStringAsFixed(2)} ${listing.currency}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Your offer',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCurrency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              items: ['ICP', 'WICP', 'USD'].map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                selectedCurrency = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isNotEmpty) {
                Navigator.pop(context);
                final success = await widget.yukuService.makeOffer(
                  nftId: listing.nftId,
                  amount: double.parse(amountController.text),
                  currency: selectedCurrency,
                );
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Offer made successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Make Offer'),
          ),
        ],
      ),
    );
  }

  void _buyNFT(YukuListing listing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buy NFT'),
        content: Text(
          'Are you sure you want to buy this NFT for ${listing.price.toStringAsFixed(2)} ${listing.currency}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Buy'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await widget.yukuService.buyNFT(listing.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NFT purchased successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _cancelListing(YukuListing listing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Listing'),
        content: const Text('Are you sure you want to cancel this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await widget.yukuService.cancelListing(listing.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _acceptOffer(YukuOffer offer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Offer'),
        content: Text(
          'Are you sure you want to accept this offer of ${offer.amount.toStringAsFixed(2)} ${offer.currency}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Accept'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await widget.yukuService.acceptOffer(offer.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer accepted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _rejectOffer(YukuOffer offer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Offer'),
        content: const Text('Are you sure you want to reject this offer?'),
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
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await widget.yukuService.rejectOffer(offer.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer rejected successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _cancelOffer(YukuOffer offer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Offer'),
        content: const Text('Are you sure you want to cancel this offer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await widget.yukuService.cancelOffer(offer.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _viewOffers(YukuListing listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Offers for ${listing.name}'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              // Mock offers data
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // Mock number of offers
                  itemBuilder: (context, index) {
                    final offerAmount = (listing.price * (0.8 + (index * 0.1)))
                        .toStringAsFixed(2);
                    final offerer = 'User${index + 1}';
                    final timeAgo = '${(index + 1) * 2} hours ago';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(offerer[4]), // First letter of username
                        ),
                        title: Text('$offerAmount ICP'),
                        subtitle: Text('From $offerer • $timeAgo'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _acceptOffer(listing, offerAmount, offerer);
                              },
                              child: const Text('Accept'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _rejectOffer(listing, offerer);
                              },
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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

  void _acceptOffer(YukuListing listing, String amount, String offerer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepting offer of $amount ICP from $offerer...'),
        backgroundColor: Colors.blue,
      ),
    );

    // Simulate accepting offer
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Offer accepted! ${listing.name} sold to $offerer for $amount ICP'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _rejectOffer(YukuListing listing, String offerer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Offer from $offerer rejected'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  String _formatAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'pending':
        return Colors.blue;
      case 'sold':
      case 'accepted':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      case 'expired':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
