import 'package:flutter/material.dart';
// import 'package:flutter_nft/flutter_nft.dart';
import '../core/mocks/nft_mocks.dart';
import 'yuku_marketplace_screen.dart';

class YukuIntegrationDemoScreen extends StatefulWidget {
  final NFTClient nftClient;
  final dynamic yukuService;
  final dynamic nftService;

  const YukuIntegrationDemoScreen({
    super.key,
    required this.nftClient,
    this.yukuService,
    this.nftService,
  });

  @override
  State<YukuIntegrationDemoScreen> createState() =>
      _YukuIntegrationDemoScreenState();
}

class _YukuIntegrationDemoScreenState extends State<YukuIntegrationDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yuku Integration Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 24),
            _buildFeaturesSection(),
            const SizedBox(height: 24),
            _buildDemoActionsSection(),
            const SizedBox(height: 24),
            _buildIntegrationInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.store,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Yuku Marketplace Integration',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Buy and sell NFT tax liens on Internet Computer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: Icons.shopping_cart,
              title: 'Buy NFTs',
              description:
                  'Purchase tax lien NFTs directly from the marketplace',
            ),
            _buildFeatureItem(
              icon: Icons.storefront,
              title: 'Sell NFTs',
              description:
                  'List your tax lien NFTs for sale with custom pricing',
            ),
            _buildFeatureItem(
              icon: Icons.attach_money,
              title: 'Make Offers',
              description: 'Negotiate prices with make offer functionality',
            ),
            _buildFeatureItem(
              icon: Icons.currency_exchange,
              title: 'Multi-Currency',
              description: 'Support for ICP, WICP, and USD transactions',
            ),
            _buildFeatureItem(
              icon: Icons.security,
              title: 'Secure Trading',
              description: 'Built on Internet Computer blockchain for security',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demo Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showMarketplace(),
                icon: const Icon(Icons.store),
                label: const Text('Open Yuku Marketplace'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _createDemoListing(),
                icon: const Icon(Icons.add),
                label: const Text('Create Demo Listing'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _makeDemoOffer(),
                icon: const Icon(Icons.attach_money),
                label: const Text('Make Demo Offer'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Integration Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoItem('Platform', 'Yuku.app'),
            _buildInfoItem('Blockchain', 'Internet Computer (ICP)'),
            _buildInfoItem('Supported Tokens', 'ICP, WICP, USD'),
            _buildInfoItem('NFT Standard', 'ICRC-7'),
            _buildInfoItem('Security', 'Multi-signature wallets'),
            _buildInfoItem('Fees', 'Low transaction fees'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMarketplace() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YukuMarketplaceScreen(
          nftClient: widget.nftClient,
        ),
      ),
    );
  }

  void _createDemoListing() async {
    final success = await widget.yukuService.createListing(
      nftId: 'demo_nft_${DateTime.now().millisecondsSinceEpoch}',
      price: 1000.0,
      currency: 'ICP',
      expirationDays: 30,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demo listing created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.yukuService.error ?? 'Failed to create listing'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _makeDemoOffer() async {
    final success = await widget.yukuService.makeOffer(
      nftId: 'demo_nft_${DateTime.now().millisecondsSinceEpoch}',
      amount: 950.0,
      currency: 'ICP',
      expirationDays: 7,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demo offer made successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.yukuService.error ?? 'Failed to make offer'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
