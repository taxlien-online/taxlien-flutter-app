import 'package:flutter/material.dart';
import '../services/tax_lien_service.dart';
import '../core/models/tax_lien_models.dart';

class MintNFTDialog extends StatefulWidget {
  final dynamic lien;
  final VoidCallback onMint;

  const MintNFTDialog({
    super.key,
    required this.lien,
    required this.onMint,
  });

  @override
  State<MintNFTDialog> createState() => _MintNFTDialogState();
}

class _MintNFTDialogState extends State<MintNFTDialog> {
  bool _isLoading = false;
  String _customName = '';
  String _customDescription = '';

  @override
  void initState() {
    super.initState();
    _customName = 'Tax Lien NFT #${widget.lien.id}';
    _customDescription = 'NFT representing a tax lien on property at ${widget.lien.address}. '
        'This NFT entitles the holder to collect interest and potentially foreclose on the property.';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mint NFT from Tax Lien',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lien preview
                  _buildLienPreview(),
                  const SizedBox(height: 20),
                  
                  // Customization options
                  Text(
                    'Customize Your NFT',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Name field
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'NFT Name',
                      hintText: 'Enter a custom name for your NFT',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _customName),
                    onChanged: (value) => _customName = value,
                  ),
                  const SizedBox(height: 12),
                  
                  // Description field
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter a description for your NFT',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _customDescription),
                    onChanged: (value) => _customDescription = value,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  
                  // NFT preview
                  _buildNFTPreview(),
                  const SizedBox(height: 20),
                  
                  // Benefits
                  _buildBenefits(),
                ],
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleMint,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Mint NFT'),
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

  Widget _buildLienPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Original Tax Lien',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('ID', widget.lien.id),
          _buildInfoRow('Address', widget.lien.address),
          _buildInfoRow('Amount', '\$${widget.lien.taxAmount.toStringAsFixed(0)}'),
          _buildInfoRow('Interest', '${widget.lien.interestRate}%'),
          _buildInfoRow('Value', '\$${widget.lien.assessedValue.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildNFTPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getRarityColor(_calculateRarity()),
            _getRarityColor(_calculateRarity()).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 48,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 12),
          Text(
            _customName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _calculateRarity(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Benefits of NFT Conversion',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildBenefitItem('🎯', 'Tradeable on NFT marketplaces'),
          _buildBenefitItem('🔒', 'Immutable ownership record'),
          _buildBenefitItem('💎', 'Unique digital collectible'),
          _buildBenefitItem('📈', 'Potential value appreciation'),
          _buildBenefitItem('🌐', 'Global accessibility'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateRarity() {
    if (widget.lien.assessedValue > 200000) return 'Legendary';
    if (widget.lien.assessedValue > 100000) return 'Epic';
    if (widget.lien.assessedValue > 50000) return 'Rare';
    return 'Common';
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

  void _handleMint() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate minting process
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        widget.onMint();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mint NFT: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
