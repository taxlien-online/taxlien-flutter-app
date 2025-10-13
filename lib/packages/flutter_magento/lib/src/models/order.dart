/// Magento Order model
class MagentoOrder {
  final int entityId;
  final String incrementId;
  final DateTime createdAt;
  final String status;
  final String state;
  final double grandTotal;
  final double subtotal;
  final String? customerEmail;
  final String? customerFirstname;
  final String? customerLastname;
  final List<MagentoOrderItem> items;

  MagentoOrder({
    required this.entityId,
    required this.incrementId,
    required this.createdAt,
    required this.status,
    required this.state,
    required this.grandTotal,
    required this.subtotal,
    this.customerEmail,
    this.customerFirstname,
    this.customerLastname,
    this.items = const [],
  });

  factory MagentoOrder.fromJson(Map<String, dynamic> json) {
    return MagentoOrder(
      entityId: json['entity_id'] ?? 0,
      incrementId: json['increment_id'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      state: json['state'] ?? '',
      grandTotal: (json['grand_total'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      customerEmail: json['customer_email'],
      customerFirstname: json['customer_firstname'],
      customerLastname: json['customer_lastname'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => MagentoOrderItem.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entity_id': entityId,
      'increment_id': incrementId,
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'state': state,
      'grand_total': grandTotal,
      'subtotal': subtotal,
      'customer_email': customerEmail,
      'customer_firstname': customerFirstname,
      'customer_lastname': customerLastname,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

/// Order Item model
class MagentoOrderItem {
  final int itemId;
  final String sku;
  final String name;
  final int qtyOrdered;
  final double price;
  final double rowTotal;

  MagentoOrderItem({
    required this.itemId,
    required this.sku,
    required this.name,
    required this.qtyOrdered,
    required this.price,
    required this.rowTotal,
  });

  factory MagentoOrderItem.fromJson(Map<String, dynamic> json) {
    return MagentoOrderItem(
      itemId: json['item_id'] ?? 0,
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      qtyOrdered: json['qty_ordered'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      rowTotal: (json['row_total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'sku': sku,
      'name': name,
      'qty_ordered': qtyOrdered,
      'price': price,
      'row_total': rowTotal,
    };
  }
}
