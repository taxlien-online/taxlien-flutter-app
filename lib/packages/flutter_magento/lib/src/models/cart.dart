/// Magento Cart model
class MagentoCart {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int? customerId;
  final int itemsCount;
  final double subtotal;
  final double? grandTotal;
  final String? currency;
  final List<MagentoCartItem> items;

  MagentoCart({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.customerId,
    required this.itemsCount,
    required this.subtotal,
    this.grandTotal,
    this.currency,
    this.items = const [],
  });

  factory MagentoCart.fromJson(Map<String, dynamic> json) {
    return MagentoCart(
      id: json['id'] ?? 0,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? true,
      customerId: json['customer_id'],
      itemsCount: json['items_count'] ?? 0,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      grandTotal:
          json['grand_total'] != null ? json['grand_total'].toDouble() : null,
      currency: json['currency'] ?? 'USD',
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => MagentoCartItem.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'customer_id': customerId,
      'items_count': itemsCount,
      'subtotal': subtotal,
      'grand_total': grandTotal,
      'currency': currency,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

/// Cart Item model
class MagentoCartItem {
  final int itemId;
  final String sku;
  final int qty;
  final String name;
  final double price;
  final String? productType;
  final int? quoteId;

  MagentoCartItem({
    required this.itemId,
    required this.sku,
    required this.qty,
    required this.name,
    required this.price,
    this.productType,
    this.quoteId,
  });

  factory MagentoCartItem.fromJson(Map<String, dynamic> json) {
    return MagentoCartItem(
      itemId: json['item_id'] ?? 0,
      sku: json['sku'] ?? '',
      qty: json['qty'] ?? 1,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      productType: json['product_type'],
      quoteId: json['quote_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'sku': sku,
      'qty': qty,
      'name': name,
      'price': price,
      'product_type': productType,
      'quote_id': quoteId,
    };
  }
}
