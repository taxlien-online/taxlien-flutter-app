import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/models/magento_models.dart';
import '../core/constants/app_constants.dart';

/// Enhanced product card with modern design for tax lien marketplace
class EnhancedProductCard extends StatelessWidget {
  final MagentoProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart;
  final bool isFavorite;
  final bool showQuickActions;

  const EnhancedProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteToggle,
    this.onAddToCart,
    this.isFavorite = false,
    this.showQuickActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image section
            _buildImageSection(context),
            
            // Product info section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and favorite
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showQuickActions)
                          IconButton(
                            onPressed: onFavoriteToggle,
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // SKU and status
                    Text(
                      'ID: ${product.sku}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Custom attributes (tax lien specific)
                    _buildCustomAttributes(context),
                    
                    const Spacer(),
                    
                    // Price and action button
                    _buildPriceAndAction(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Stack(
        children: [
          // Product image
          if (product.mediaGalleryEntries?.isNotEmpty == true)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: '${AppConstants.magentoMediaUrl}${product.mediaGalleryEntries!.first.file ?? ''}',
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildImagePlaceholder(context),
                errorWidget: (context, url, error) => _buildImagePlaceholder(context),
              ),
            )
          else
            _buildImagePlaceholder(context),
          
          // Status badge
          if (product.status == 1)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          // Quick view button
          if (showQuickActions)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () {
                    // Quick view functionality
                    _showQuickView(context);
                  },
                  icon: const Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 16,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Icon(
        Icons.account_balance,
        size: 40,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildCustomAttributes(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    // Extract tax lien specific attributes from custom attributes
    final customAttributes = product.customAttributes ?? [];
    
    // Tax amount
    final taxAmountAttr = customAttributes.firstWhere(
      (attr) => attr.attributeCode == 'tax_amount',
      orElse: () => MagentoProductAttribute(attributeCode: 'tax_amount', value: '0'),
    );
    
    // Interest rate
    final interestRateAttr = customAttributes.firstWhere(
      (attr) => attr.attributeCode == 'interest_rate',
      orElse: () => MagentoProductAttribute(attributeCode: 'interest_rate', value: '0'),
    );
    
    // Location
    final locationAttr = customAttributes.firstWhere(
      (attr) => attr.attributeCode == 'property_location',
      orElse: () => MagentoProductAttribute(attributeCode: 'property_location', value: 'N/A'),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tax amount
        _buildAttributeRow(
          context,
          'Tax Amount',
          '\$${double.tryParse(taxAmountAttr.value.toString())?.toStringAsFixed(2) ?? '0.00'}',
          Icons.attach_money,
          Colors.green,
        ),
        
        const SizedBox(height: 4),
        
        // Interest rate
        _buildAttributeRow(
          context,
          'Interest Rate',
          '${double.tryParse(interestRateAttr.value.toString())?.toStringAsFixed(1) ?? '0.0'}%',
          Icons.percent,
          Colors.orange,
        ),
        
        const SizedBox(height: 4),
        
        // Location
        if (locationAttr.value.toString() != 'N/A')
          _buildAttributeRow(
            context,
            'Location',
            locationAttr.value.toString(),
            Icons.location_on,
            Colors.blue,
          ),
      ],
    );
  }

  Widget _buildAttributeRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: iconColor,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: iconColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndAction(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              if (product.specialPrice != null && product.specialPrice! < (product.price ?? 0))
                Text(
                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        
        if (showQuickActions)
          Material(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: onAddToCart,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.add_shopping_cart,
                  color: colorScheme.onPrimary,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showQuickView(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Quick view content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.sku,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Price
                      Text(
                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description or custom attributes
                      if (product.customAttributes?.isNotEmpty == true)
                        ...product.customAttributes!.map((attr) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  attr.attributeCode.replaceAll('_', ' ').toUpperCase(),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  attr.value.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        )),
                      
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onTap?.call();
                              },
                              child: const Text('View Details'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onAddToCart?.call();
                              },
                              child: const Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
