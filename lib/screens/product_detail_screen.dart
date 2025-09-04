import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/models/magento_models.dart';
import '../core/constants/app_constants.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

/// Product detail screen for tax lien products
class ProductDetailScreen extends StatefulWidget {
  final MagentoProduct product;
  final AuthService authService;
  final DatabaseService databaseService;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.authService,
    required this.databaseService,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await widget.databaseService.isFavorite(widget.product.sku);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProductImage(),
            ),
            actions: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Share functionality
                },
                icon: Icon(
                  Icons.share,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Product details
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and price
                    _buildTitleSection(),
                    
                    const SizedBox(height: 20),
                    
                    // Tax lien specific details
                    _buildTaxLienDetails(),
                    
                    const SizedBox(height: 20),
                    
                    // Description
                    _buildDescriptionSection(),
                    
                    const SizedBox(height: 20),
                    
                    // Additional attributes
                    _buildAttributesSection(),
                    
                    const SizedBox(height: 100), // Space for floating button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Purchase button
      floatingActionButton: _buildPurchaseButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildProductImage() {
    if (widget.product.mediaGalleryEntries?.isNotEmpty == true) {
      final imageUrl = '${AppConstants.magentoMediaUrl}${widget.product.mediaGalleryEntries!.first.file ?? ''}';
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildImagePlaceholder(),
        errorWidget: (context, url, error) => _buildImagePlaceholder(),
      );
    }
    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      color: colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.account_balance,
          size: 80,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'SKU: ${widget.product.sku}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Text(
              '\$${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            
            if (widget.product.specialPrice != null && widget.product.specialPrice! < (widget.product.price ?? 0)) ...[
              const SizedBox(width: 12),
              Text(
                '\$${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
                style: theme.textTheme.titleMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            
            const Spacer(),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (widget.product.status ?? 0) == 1 ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (widget.product.status ?? 0) == 1 ? 'Available' : 'Sold',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaxLienDetails() {
    final theme = Theme.of(context);
    final customAttributes = widget.product.customAttributes ?? [];
    
    // Extract tax lien specific data
    final taxAmount = _getAttributeValue('tax_amount', '0');
    final interestRate = _getAttributeValue('interest_rate', '0');
    final propertyLocation = _getAttributeValue('property_location', 'N/A');
    final auctionDate = _getAttributeValue('auction_date', 'N/A');
    final redemptionPeriod = _getAttributeValue('redemption_period', 'N/A');
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tax Lien Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Tax Amount',
                    '\$${double.tryParse(taxAmount)?.toStringAsFixed(2) ?? '0.00'}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Interest Rate',
                    '${double.tryParse(interestRate)?.toStringAsFixed(1) ?? '0.0'}%',
                    Icons.percent,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (propertyLocation != 'N/A')
              _buildDetailRow('Property Location', propertyLocation),
            
            if (auctionDate != 'N/A')
              _buildDetailRow('Auction Date', auctionDate),
            
            if (redemptionPeriod != 'N/A')
              _buildDetailRow('Redemption Period', redemptionPeriod),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          widget.product.name, // Using name as description for now
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAttributesSection() {
    final theme = Theme.of(context);
    final customAttributes = widget.product.customAttributes ?? [];
    
    if (customAttributes.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: customAttributes
                  .where((attr) => !['tax_amount', 'interest_rate', 'property_location', 'auction_date', 'redemption_period'].contains(attr.attributeCode))
                  .map((attr) => _buildDetailRow(
                        attr.attributeCode.replaceAll('_', ' ').toUpperCase(),
                        attr.value.toString(),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (widget.product.status != 1) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _showPurchaseDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Purchase for \$${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }

  String _getAttributeValue(String attributeCode, String defaultValue) {
    final customAttributes = widget.product.customAttributes ?? [];
    final attribute = customAttributes.firstWhere(
      (attr) => attr.attributeCode == attributeCode,
      orElse: () => MagentoProductAttribute(attributeCode: attributeCode, value: defaultValue),
    );
    return attribute.value.toString();
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFavorite) {
        await widget.databaseService.removeFromFavorites(widget.product.sku);
      } else {
        await widget.databaseService.addToFavorites(widget.product.sku);
      }
      
      setState(() {
        _isFavorite = !_isFavorite;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPurchaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Tax Lien'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product: ${widget.product.name}'),
            const SizedBox(height: 8),
            Text('Price: \$${widget.product.price?.toStringAsFixed(2) ?? '0.00'}'),
            const SizedBox(height: 16),
            const Text('Are you sure you want to purchase this tax lien?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processPurchase();
            },
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  Future<void> _processPurchase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final magentoNotifier = ref.read(magentoProvider.notifier);
      
      // Get or create cart
      String? cartId = await widget.databaseService.getCartId();
      if (cartId == null) {
        cartId = await magentoNotifier.createCart();
        if (cartId != null) {
          await widget.databaseService.saveCartId(cartId);
        }
      }
      
      if (cartId == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create cart'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Add product to cart
      final success = await magentoNotifier.addToCart(
        cartId: cartId,
        sku: widget.product.sku,
        quantity: 1,
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.product.name} added to cart!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add product to cart'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing purchase: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
