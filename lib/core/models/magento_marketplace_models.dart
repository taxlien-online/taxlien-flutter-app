/// Magento Marketplace Models for TaxLien.online
/// Simple immutable models for Magento integration

/// Product model compatible with Magento
class MagentoProduct {
  final int id;
  final String sku;
  final String name;
  final double price;
  final String? description;
  final String? shortDescription;
  final String? image;
  final List<String>? images;
  final List<MagentoCategory> categories;
  final Map<String, dynamic> customAttributes;
  final String typeId;
  final int qty;
  final bool inStock;

  const MagentoProduct({
    required this.id,
    required this.sku,
    required this.name,
    this.price = 0.0,
    this.description,
    this.shortDescription,
    this.image,
    this.images,
    this.categories = const [],
    this.customAttributes = const {},
    this.typeId = 'simple',
    this.qty = 0,
    this.inStock = true,
  });
}

/// Category model
class MagentoCategory {
  final int id;
  final String name;
  final String path;
  final int? parentId;
  final int level;
  final bool isActive;
  final int position;
  final List<MagentoCategory> children;
  final int productCount;
  final String? image;
  final String? description;

  const MagentoCategory({
    required this.id,
    required this.name,
    this.path = '',
    this.parentId,
    this.level = 0,
    this.isActive = true,
    this.position = 0,
    this.children = const [],
    this.productCount = 0,
    this.image,
    this.description,
  });
}

/// Cart model
class MagentoCart {
  final String id;
  final List<MagentoCartItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double discount;
  final double grandTotal;
  final String? currency;
  final int itemsCount;

  const MagentoCart({
    required this.id,
    this.items = const [],
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.shipping = 0.0,
    this.discount = 0.0,
    this.grandTotal = 0.0,
    this.currency,
    this.itemsCount = 0,
  });

  MagentoCart copyWith({
    String? id,
    List<MagentoCartItem>? items,
    double? subtotal,
    double? tax,
    double? shipping,
    double? discount,
    double? grandTotal,
    String? currency,
    int? itemsCount,
  }) {
    return MagentoCart(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shipping: shipping ?? this.shipping,
      discount: discount ?? this.discount,
      grandTotal: grandTotal ?? this.grandTotal,
      currency: currency ?? this.currency,
      itemsCount: itemsCount ?? this.itemsCount,
    );
  }
}

/// Cart item model
class MagentoCartItem {
  final int itemId;
  final String sku;
  final String name;
  final double price;
  final int qty;
  final String? image;
  final double rowTotal;

  const MagentoCartItem({
    required this.itemId,
    required this.sku,
    required this.name,
    required this.price,
    required this.qty,
    this.image,
    this.rowTotal = 0.0,
  });
}

/// Customer model
class MagentoCustomer {
  final int id;
  final String email;
  final String? firstname;
  final String? lastname;
  final List<MagentoAddress> addresses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MagentoCustomer({
    required this.id,
    required this.email,
    this.firstname,
    this.lastname,
    this.addresses = const [],
    this.createdAt,
    this.updatedAt,
  });
}

/// Address model
class MagentoAddress {
  final int? id;
  final String? street;
  final String? city;
  final String? region;
  final String? postcode;
  final String? countryId;
  final String? telephone;
  final bool isDefaultShipping;
  final bool isDefaultBilling;

  const MagentoAddress({
    this.id,
    this.street,
    this.city,
    this.region,
    this.postcode,
    this.countryId,
    this.telephone,
    this.isDefaultShipping = false,
    this.isDefaultBilling = false,
  });
}

/// Order model
class MagentoOrder {
  final int id;
  final String incrementId;
  final DateTime createdAt;
  final String status;
  final double grandTotal;
  final List<MagentoOrderItem> items;
  final MagentoAddress? billingAddress;
  final MagentoAddress? shippingAddress;
  final String? paymentMethod;
  final String? shippingMethod;

  const MagentoOrder({
    required this.id,
    required this.incrementId,
    required this.createdAt,
    required this.status,
    required this.grandTotal,
    this.items = const [],
    this.billingAddress,
    this.shippingAddress,
    this.paymentMethod,
    this.shippingMethod,
  });
}

/// Order item model
class MagentoOrderItem {
  final int itemId;
  final String sku;
  final String name;
  final double price;
  final int qtyOrdered;
  final double rowTotal;

  const MagentoOrderItem({
    required this.itemId,
    required this.sku,
    required this.name,
    required this.price,
    required this.qtyOrdered,
    this.rowTotal = 0.0,
  });
}

/// Review model
class MagentoReview {
  final int id;
  final String title;
  final String detail;
  final String nickname;
  final DateTime createdAt;
  final int rating;

  const MagentoReview({
    required this.id,
    required this.title,
    required this.detail,
    required this.nickname,
    required this.createdAt,
    this.rating = 0,
  });
}

/// Search criteria for products
class ProductSearchCriteria {
  final String? searchTerm;
  final List<int>? categoryIds;
  final double? minPrice;
  final double? maxPrice;
  final int currentPage;
  final int pageSize;
  final String? sortBy;
  final String sortOrder;

  const ProductSearchCriteria({
    this.searchTerm,
    this.categoryIds,
    this.minPrice,
    this.maxPrice,
    this.currentPage = 1,
    this.pageSize = 20,
    this.sortBy,
    this.sortOrder = 'ASC',
  });
}

/// Product search result
class ProductSearchResult {
  final List<MagentoProduct> items;
  final int totalCount;
  final int currentPage;
  final int pageSize;

  const ProductSearchResult({
    this.items = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.pageSize = 20,
  });
}

/// Wishlist model
class MagentoWishlist {
  final int id;
  final int customerId;
  final List<MagentoWishlistItem> items;
  final DateTime? updatedAt;

  const MagentoWishlist({
    required this.id,
    required this.customerId,
    this.items = const [],
    this.updatedAt,
  });
}

/// Wishlist item model
class MagentoWishlistItem {
  final int itemId;
  final int productId;
  final String sku;
  final String name;
  final double? price;
  final String? image;
  final DateTime? addedAt;

  const MagentoWishlistItem({
    required this.itemId,
    required this.productId,
    required this.sku,
    required this.name,
    this.price,
    this.image,
    this.addedAt,
  });
}
