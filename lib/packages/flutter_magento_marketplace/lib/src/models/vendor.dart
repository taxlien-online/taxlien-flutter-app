/// Marketplace Vendor model
class MarketplaceVendor {
  final int id;
  final String name;
  final String email;
  final String? shopUrl;
  final String? logo;
  final String? description;
  final bool isActive;
  final double rating;
  final int totalProducts;
  final int totalSales;
  final DateTime? createdAt;
  final Map<String, dynamic>? customAttributes;

  MarketplaceVendor({
    required this.id,
    required this.name,
    required this.email,
    this.shopUrl,
    this.logo,
    this.description,
    required this.isActive,
    this.rating = 0.0,
    this.totalProducts = 0,
    this.totalSales = 0,
    this.createdAt,
    this.customAttributes,
  });

  factory MarketplaceVendor.fromJson(Map<String, dynamic> json) {
    return MarketplaceVendor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      shopUrl: json['shop_url'],
      logo: json['logo'],
      description: json['description'],
      isActive: json['is_active'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      totalProducts: json['total_products'] ?? 0,
      totalSales: json['total_sales'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      customAttributes: json['custom_attributes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'shop_url': shopUrl,
      'logo': logo,
      'description': description,
      'is_active': isActive,
      'rating': rating,
      'total_products': totalProducts,
      'total_sales': totalSales,
      'created_at': createdAt?.toIso8601String(),
      'custom_attributes': customAttributes,
    };
  }
}
