/// Marketplace Product model (extends Magento Product with vendor info)
class MarketplaceProduct {
  final int id;
  final String sku;
  final String name;
  final double price;
  final int vendorId;
  final String vendorName;
  final String? vendorShopUrl;
  final String? description;
  final int status;
  final int stock;
  final bool isApproved;
  final DateTime? createdAt;
  final Map<String, dynamic>? customAttributes;

  MarketplaceProduct({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.vendorId,
    required this.vendorName,
    this.vendorShopUrl,
    this.description,
    required this.status,
    required this.stock,
    required this.isApproved,
    this.createdAt,
    this.customAttributes,
  });

  factory MarketplaceProduct.fromJson(Map<String, dynamic> json) {
    return MarketplaceProduct(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      vendorId: json['vendor_id'] ?? 0,
      vendorName: json['vendor_name'] ?? '',
      vendorShopUrl: json['vendor_shop_url'],
      description: json['description'],
      status: json['status'] ?? 1,
      stock: json['stock'] ?? 0,
      isApproved: json['is_approved'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      customAttributes: json['custom_attributes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'price': price,
      'vendor_id': vendorId,
      'vendor_name': vendorName,
      'vendor_shop_url': vendorShopUrl,
      'description': description,
      'status': status,
      'stock': stock,
      'is_approved': isApproved,
      'created_at': createdAt?.toIso8601String(),
      'custom_attributes': customAttributes,
    };
  }
}
