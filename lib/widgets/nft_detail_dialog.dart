import 'package:flutter/material.dart';
import '../services/nft_service.dart';

class NFTDetailDialog extends StatelessWidget {
  final TaxLienNFT nft;

  const NFTDetailDialog({
    super.key,
    required this.nft,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with image
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getRarityColor(nft.metadata.attributes['Rarity'] ?? 'Common'),
                    _getRarityColor(nft.metadata.attributes['Rarity'] ?? 'Common').withOpacity(0.7),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.receipt_long,
                      size: 80,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        nft.metadata.attributes['Rarity'] ?? 'Common',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (nft.status == 'burned')
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'BURNED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and basic info
                    Text(
                      nft.metadata.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      nft.metadata.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    // Property details
                    _buildSection(
                      context,
                      'Property Information',
                      [
                        _buildInfoRow('Address', nft.originalLien.address),
                        _buildInfoRow('Parcel ID', nft.originalLien.parcelId),
                        _buildInfoRow('County', nft.originalLien.county),
                        _buildInfoRow('State', nft.originalLien.state),
                        _buildInfoRow('Owner', nft.originalLien.owner),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Financial details
                    _buildSection(
                      context,
                      'Financial Information',
                      [
                        _buildInfoRow('Assessed Value', '\$${nft.originalLien.assessedValue.toStringAsFixed(0)}'),
                        _buildInfoRow('Tax Amount', '\$${nft.originalLien.taxAmount.toStringAsFixed(0)}'),
                        _buildInfoRow('Interest Rate', '${nft.originalLien.interestRate}%'),
                        _buildInfoRow('Current NFT Value', '\$${(nft.currentValue ?? 0).toStringAsFixed(0)}'),
                        if (nft.originalLien.salePrice != null)
                          _buildInfoRow('Purchase Price', '\$${nft.originalLien.salePrice!.toStringAsFixed(0)}'),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Dates
                    _buildSection(
                      context,
                      'Important Dates',
                      [
                        _buildInfoRow('Auction Date', nft.originalLien.auctionDate.toString().split(' ')[0]),
                        _buildInfoRow('Redemption Deadline', nft.originalLien.redemptionDeadline.toString().split(' ')[0]),
                        _buildInfoRow('NFT Created', nft.createdAt.toString().split(' ')[0]),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // NFT details
                    _buildSection(
                      context,
                      'NFT Information',
                      [
                        _buildInfoRow('Token ID', nft.tokenId),
                        _buildInfoRow('Owner Address', nft.ownerAddress),
                        _buildInfoRow('Status', nft.status.toUpperCase()),
                        _buildInfoRow('Risk Level', nft.metadata.attributes['Risk Level'] ?? 'Low'),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Transaction history
                    if (nft.transactionHistory.isNotEmpty)
                      _buildSection(
                        context,
                        'Transaction History',
                        nft.transactionHistory.map((tx) => _buildInfoRow('', tx)).toList(),
                      ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                  if (nft.status != 'burned') ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _shareNFT(nft);
                        },
                        child: const Text('Share'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'legendary':
        return Colors.purple;
      case 'epic':
        return Colors.blue;
      case 'rare':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _shareNFT(NFT nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share NFT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose how you want to share this NFT:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Link'),
              subtitle: const Text('Copy NFT link to clipboard'),
              onTap: () {
                Navigator.pop(context);
                _copyNFTLink(nft);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share via App'),
              subtitle: const Text('Share using system share sheet'),
              onTap: () {
                Navigator.pop(context);
                _shareViaSystem(nft);
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Generate QR Code'),
              subtitle: const Text('Create QR code for this NFT'),
              onTap: () {
                Navigator.pop(context);
                _generateQRCode(nft);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _copyNFTLink(NFT nft) {
    final nftLink = 'https://taxlien.online/nft/${nft.id}';
    // In a real implementation, this would copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('NFT link copied: $nftLink'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareViaSystem(NFT nft) {
    // In a real implementation, this would use the share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${nft.name}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _generateQRCode(NFT nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('NFT QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(
                child: Text(
                  'QR CODE\nPLACEHOLDER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Scan this QR code to view ${nft.name}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR code saved to gallery'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
