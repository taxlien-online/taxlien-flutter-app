import 'package:flutter/material.dart';
import '../core/models/magento_models.dart';
import '../core/services/magento_api_service.dart';
import '../services/database_service.dart';
import 'enhanced_product_card.dart';

class SearchResultsList extends StatelessWidget {
  final List<MagentoProduct> magentoProducts;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const SearchResultsList({
    Key? key,
    required this.magentoProducts,
    this.onLoadMore,
    this.isLoadingMore = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (magentoProducts.isEmpty) {
      return const Center(
        child: Text('No products found'),
      );
    }

    return Column(
      children: [
        // Results count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${magentoProducts.length} products found',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              if (isLoadingMore)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),

        // Products grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: magentoProducts.length + (onLoadMore != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == magentoProducts.length) {
                // Load more button
                return _buildLoadMoreCard(context);
              }

              final product = magentoProducts[index];
              return EnhancedProductCard(
                product: product,
                onTap: () => _showProductDetails(context, product),
                onFavoriteToggle: () => _toggleFavorite(context, product),
                onAddToCart: () => _addToCart(context, product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreCard(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: isLoadingMore ? null : onLoadMore,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoadingMore)
                const CircularProgressIndicator()
              else
                Icon(
                  Icons.expand_more,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              const SizedBox(height: 8),
              Text(
                isLoadingMore ? 'Loading...' : 'Load More',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, MagentoProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      if (product.mediaGalleryEntries?.isNotEmpty == true)
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.mediaGalleryEntries!.first.url ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                );
                              },
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Price
                      Row(
                        children: [
                          Text(
                            '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (product.specialPrice != null &&
                              product.specialPrice! < product.price!) ...[
                            const SizedBox(width: 8),
                            Text(
                              '\$${product.price!.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Description
                      if (product.shortDescription?.isNotEmpty == true) ...[
                        Text(
                          'Description',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.shortDescription!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Product details
                      _buildProductDetails(context, product),

                      const SizedBox(height: 16),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _toggleFavorite(context, product),
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('Add to Favorites'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _addToCart(context, product),
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
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

  Widget _buildProductDetails(BuildContext context, MagentoProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        _buildDetailRow(context, 'SKU', product.sku ?? 'N/A'),
        _buildDetailRow(context, 'Type', product.typeId ?? 'N/A'),
        _buildDetailRow(context, 'Weight', product.weight?.toString() ?? 'N/A'),
        _buildDetailRow(context, 'Status', product.status?.toString() ?? 'N/A'),
        if (product.customAttributes?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Text(
            'Custom Attributes',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          ...product.customAttributes!.map((attr) => _buildDetailRow(
              context, attr.attributeCode ?? 'Unknown', attr.value ?? 'N/A')),
        ],
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(BuildContext context, MagentoProduct product) async {
    try {
      final databaseService = DatabaseService.instance;
      await databaseService.initialize();

      final isFavorite =
          await databaseService.isFavorite(product.sku, type: 'product');

      if (isFavorite) {
        await databaseService.removeFromFavorites(product.sku);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} removed from favorites'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        await databaseService.addToFavorites(product.sku);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} added to favorites'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating favorites: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _addToCart(BuildContext context, MagentoProduct product) async {
    try {
      final magentoApiService = MagentoApiService();

      // Create cart
      String? cartId = await magentoApiService.createCart();

      if (cartId != null) {
        // Add item to cart
        final success = await magentoApiService.addToCart(
          cartId: cartId,
          sku: product.sku,
          quantity: 1,
        );

        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} added to cart'),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add ${product.name} to cart'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create cart'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to cart: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
