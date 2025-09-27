import 'tax_lien_models.dart';

/// Base class for Magento models
abstract class MagentoModel {
  Map<String, dynamic> toJson();
}

/// Magento Customer model
class MagentoCustomer extends MagentoModel {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? middlename;
  final int? groupId;
  final String? dob;
  final String? taxvat;
  final String? gender;
  final bool? isSubscribed;
  final String? prefix;
  final String? suffix;
  final String? defaultBilling;
  final String? defaultShipping;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<MagentoAddress>? addresses;

  MagentoCustomer({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.middlename,
    this.groupId,
    this.dob,
    this.taxvat,
    this.gender,
    this.isSubscribed,
    this.prefix,
    this.suffix,
    this.defaultBilling,
    this.defaultShipping,
    this.createdAt,
    this.updatedAt,
    this.addresses,
  });

  factory MagentoCustomer.fromJson(Map<String, dynamic> json) {
    return MagentoCustomer(
      id: json['id'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
      groupId: json['group_id'],
      dob: json['dob'],
      taxvat: json['taxvat'],
      gender: json['gender'],
      isSubscribed: json['is_subscribed'],
      prefix: json['prefix'],
      suffix: json['suffix'],
      defaultBilling: json['default_billing'],
      defaultShipping: json['default_shipping'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      addresses: json['addresses'] != null
          ? List<MagentoAddress>.from(
              json['addresses'].map((x) => MagentoAddress.fromJson(x)))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'group_id': groupId,
      'dob': dob,
      'taxvat': taxvat,
      'gender': gender,
      'is_subscribed': isSubscribed,
      'prefix': prefix,
      'suffix': suffix,
      'default_billing': defaultBilling,
      'default_shipping': defaultShipping,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'addresses': addresses?.map((x) => x.toJson()).toList(),
    };
  }

  String get fullName => '$firstname $lastname';
  String get displayName =>
      middlename != null ? '$firstname $middlename $lastname' : fullName;
}

/// Magento Address model
class MagentoAddress extends MagentoModel {
  final int? id;
  final int? customerId;
  final String? region;
  final int? regionId;
  final String? regionCode;
  final String? countryId;
  final List<String>? street;
  final String? company;
  final String? telephone;
  final String? fax;
  final String? postcode;
  final String? city;
  final String? firstname;
  final String? lastname;
  final String? middlename;
  final String? prefix;
  final String? suffix;
  final String? vatId;
  final bool? defaultShipping;
  final bool? defaultBilling;

  MagentoAddress({
    this.id,
    this.customerId,
    this.region,
    this.regionId,
    this.regionCode,
    this.countryId,
    this.street,
    this.company,
    this.telephone,
    this.fax,
    this.postcode,
    this.city,
    this.firstname,
    this.lastname,
    this.middlename,
    this.prefix,
    this.suffix,
    this.vatId,
    this.defaultShipping,
    this.defaultBilling,
  });

  factory MagentoAddress.fromJson(Map<String, dynamic> json) {
    return MagentoAddress(
      id: json['id'],
      customerId: json['customer_id'],
      region: json['region'],
      regionId: json['region_id'],
      regionCode: json['region_code'],
      countryId: json['country_id'],
      street: json['street'] != null ? List<String>.from(json['street']) : null,
      company: json['company'],
      telephone: json['telephone'],
      fax: json['fax'],
      postcode: json['postcode'],
      city: json['city'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
      prefix: json['prefix'],
      suffix: json['suffix'],
      vatId: json['vat_id'],
      defaultShipping: json['default_shipping'],
      defaultBilling: json['default_billing'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'region': region,
      'region_id': regionId,
      'region_code': regionCode,
      'country_id': countryId,
      'street': street,
      'company': company,
      'telephone': telephone,
      'fax': fax,
      'postcode': postcode,
      'city': city,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'prefix': prefix,
      'suffix': suffix,
      'vat_id': vatId,
      'default_shipping': defaultShipping,
      'default_billing': defaultBilling,
    };
  }

  String get fullAddress {
    final parts = <String>[];
    if (street != null && street!.isNotEmpty) {
      parts.addAll(street!);
    }
    if (city != null) parts.add(city!);
    if (region != null) parts.add(region!);
    if (postcode != null) parts.add(postcode!);
    if (countryId != null) parts.add(countryId!);
    return parts.join(', ');
  }
}

/// Magento Product model
class MagentoProduct extends MagentoModel {
  final String sku;
  final String name;
  final String? description;
  final String? shortDescription;
  final double? price;
  final double? specialPrice;
  final String? specialPriceFromDate;
  final String? specialPriceToDate;
  final double? weight;
  final String? typeId;
  final String? attributeSetId;
  final String? urlKey;
  final bool? isActive;
  final bool? isVisible;
  final bool? isInStock;
  final int? qty;
  final String? visibility;
  final int? status;
  final List<String>? categoryIds;
  final List<MagentoProductImage>? mediaGalleryEntries;
  final List<MagentoProductAttribute>? customAttributes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MagentoProduct({
    required this.sku,
    required this.name,
    this.description,
    this.shortDescription,
    this.price,
    this.specialPrice,
    this.specialPriceFromDate,
    this.specialPriceToDate,
    this.weight,
    this.typeId,
    this.attributeSetId,
    this.urlKey,
    this.isActive,
    this.isVisible,
    this.isInStock,
    this.qty,
    this.visibility,
    this.status,
    this.categoryIds,
    this.mediaGalleryEntries,
    this.customAttributes,
    this.createdAt,
    this.updatedAt,
  });

  factory MagentoProduct.fromJson(Map<String, dynamic> json) {
    return MagentoProduct(
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      shortDescription: json['short_description'],
      price: json['price']?.toDouble(),
      specialPrice: json['special_price']?.toDouble(),
      specialPriceFromDate: json['special_price_from_date'],
      specialPriceToDate: json['special_price_to_date'],
      weight: json['weight']?.toDouble(),
      typeId: json['type_id'],
      attributeSetId: json['attribute_set_id'],
      urlKey: json['url_key'],
      isActive: json['is_active'],
      isVisible: json['is_visible'],
      isInStock: json['is_in_stock'],
      qty: json['qty'],
      visibility: json['visibility'],
      status: json['status'],
      categoryIds: json['category_ids'] != null
          ? List<String>.from(json['category_ids'])
          : null,
      mediaGalleryEntries: json['media_gallery_entries'] != null
          ? List<MagentoProductImage>.from(json['media_gallery_entries']
              .map((x) => MagentoProductImage.fromJson(x)))
          : null,
      customAttributes: json['custom_attributes'] != null
          ? List<MagentoProductAttribute>.from(json['custom_attributes']
              .map((x) => MagentoProductAttribute.fromJson(x)))
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'name': name,
      'description': description,
      'short_description': shortDescription,
      'price': price,
      'special_price': specialPrice,
      'special_price_from_date': specialPriceFromDate,
      'special_price_to_date': specialPriceToDate,
      'weight': weight,
      'type_id': typeId,
      'attribute_set_id': attributeSetId,
      'url_key': urlKey,
      'is_active': isActive,
      'is_visible': isVisible,
      'is_in_stock': isInStock,
      'qty': qty,
      'visibility': visibility,
      'status': status,
      'category_ids': categoryIds,
      'media_gallery_entries':
          mediaGalleryEntries?.map((x) => x.toJson()).toList(),
      'custom_attributes': customAttributes?.map((x) => x.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  double get finalPrice => specialPrice ?? price ?? 0.0;
  bool get hasSpecialPrice =>
      specialPrice != null && specialPrice! < (price ?? 0.0);
  String? get mainImageUrl => mediaGalleryEntries
      ?.firstWhere((img) => img.types?.contains('image') ?? false,
          orElse: () => MagentoProductImage())
      .url;

  // Tax Lien specific methods using custom attributes
  String? get taxLienId => _getCustomAttributeValue('tax_lien_id');
  String? get parcelId => _getCustomAttributeValue('parcel_id');
  String? get ownerName => _getCustomAttributeValue('owner_name');
  String? get taxLienAddress => _getCustomAttributeValue('address');
  String? get taxLienCity => _getCustomAttributeValue('city');
  String? get taxLienState => _getCustomAttributeValue('state');
  String? get zipCode => _getCustomAttributeValue('zip_code');
  String? get county => _getCustomAttributeValue('county');
  double? get assessedValue =>
      double.tryParse(_getCustomAttributeValue('assessed_value') ?? '0');
  double? get taxAmount =>
      double.tryParse(_getCustomAttributeValue('tax_amount') ?? '0');
  double? get interestRate =>
      double.tryParse(_getCustomAttributeValue('interest_rate') ?? '0');
  DateTime? get taxYear => _parseDate(_getCustomAttributeValue('tax_year'));
  DateTime? get saleDate => _parseDate(_getCustomAttributeValue('sale_date'));
  String? get taxLienStatus => _getCustomAttributeValue('status');
  DateTime? get issueDate => _parseDate(_getCustomAttributeValue('issue_date'));

  // Helper methods for custom attributes
  String? _getCustomAttributeValue(String attributeCode) {
    final attribute = customAttributes?.firstWhere(
      (attr) => attr.attributeCode == attributeCode,
      orElse: () => MagentoProductAttribute(attributeCode: '', value: null),
    );
    return attribute?.value?.toString();
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Tax Lien specific getters
  String get fullTaxLienAddress =>
      '$taxLienAddress, $taxLienCity, $taxLienState $zipCode';
  bool get isTaxLienAvailable => taxLienStatus == 'available';
  bool get isTaxLienSold => taxLienStatus == 'sold';
  bool get isTaxLienRedeemed => taxLienStatus == 'redeemed';
}

/// Magento Product List model
class MagentoProductList extends MagentoModel {
  final List<MagentoProduct> items;
  final int totalCount;
  final MagentoSearchCriteria searchCriteria;

  MagentoProductList({
    required this.items,
    required this.totalCount,
    required this.searchCriteria,
  });

  factory MagentoProductList.fromJson(Map<String, dynamic> json) {
    return MagentoProductList(
      items: List<MagentoProduct>.from(
          json['items'].map((x) => MagentoProduct.fromJson(x))),
      totalCount: json['total_count'],
      searchCriteria: MagentoSearchCriteria.fromJson(json['search_criteria']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((x) => x.toJson()).toList(),
      'total_count': totalCount,
      'search_criteria': searchCriteria.toJson(),
    };
  }
}

/// Magento Product Image model
class MagentoProductImage extends MagentoModel {
  final int? id;
  final String? mediaType;
  final String? label;
  final int? position;
  final bool? disabled;
  final List<String>? types;
  final String? url;
  final String? file;

  MagentoProductImage({
    this.id,
    this.mediaType,
    this.label,
    this.position,
    this.disabled,
    this.types,
    this.url,
    this.file,
  });

  factory MagentoProductImage.fromJson(Map<String, dynamic> json) {
    return MagentoProductImage(
      id: json['id'],
      mediaType: json['media_type'],
      label: json['label'],
      position: json['position'],
      disabled: json['disabled'],
      types: json['types'] != null ? List<String>.from(json['types']) : null,
      url: json['url'],
      file: json['file'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_type': mediaType,
      'label': label,
      'position': position,
      'disabled': disabled,
      'types': types,
      'url': url,
      'file': file,
    };
  }
}

/// Magento Product Attribute model
class MagentoProductAttribute extends MagentoModel {
  final String attributeCode;
  final dynamic value;

  MagentoProductAttribute({
    required this.attributeCode,
    required this.value,
  });

  factory MagentoProductAttribute.fromJson(Map<String, dynamic> json) {
    return MagentoProductAttribute(
      attributeCode: json['attribute_code'],
      value: json['value'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'attribute_code': attributeCode,
      'value': value,
    };
  }
}

/// Magento Search Criteria model
class MagentoSearchCriteria extends MagentoModel {
  final List<MagentoFilterGroup> filterGroups;
  final List<MagentoSortOrder> sortOrders;
  final int pageSize;
  final int currentPage;

  MagentoSearchCriteria({
    required this.filterGroups,
    required this.sortOrders,
    required this.pageSize,
    required this.currentPage,
  });

  factory MagentoSearchCriteria.fromJson(Map<String, dynamic> json) {
    return MagentoSearchCriteria(
      filterGroups: List<MagentoFilterGroup>.from(
          json['filter_groups'].map((x) => MagentoFilterGroup.fromJson(x))),
      sortOrders: List<MagentoSortOrder>.from(
          json['sort_orders'].map((x) => MagentoSortOrder.fromJson(x))),
      pageSize: json['page_size'],
      currentPage: json['current_page'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'filter_groups': filterGroups.map((x) => x.toJson()).toList(),
      'sort_orders': sortOrders.map((x) => x.toJson()).toList(),
      'page_size': pageSize,
      'current_page': currentPage,
    };
  }
}

/// Magento Filter Group model
class MagentoFilterGroup extends MagentoModel {
  final List<MagentoFilter> filters;

  MagentoFilterGroup({
    required this.filters,
  });

  factory MagentoFilterGroup.fromJson(Map<String, dynamic> json) {
    return MagentoFilterGroup(
      filters: List<MagentoFilter>.from(
          json['filters'].map((x) => MagentoFilter.fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'filters': filters.map((x) => x.toJson()).toList(),
    };
  }
}

/// Magento Filter model
class MagentoFilter extends MagentoModel {
  final String field;
  final String value;
  final String conditionType;

  MagentoFilter({
    required this.field,
    required this.value,
    required this.conditionType,
  });

  factory MagentoFilter.fromJson(Map<String, dynamic> json) {
    return MagentoFilter(
      field: json['field'],
      value: json['value'],
      conditionType: json['condition_type'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'value': value,
      'condition_type': conditionType,
    };
  }
}

/// Magento Sort Order model
class MagentoSortOrder extends MagentoModel {
  final String field;
  final String direction;

  MagentoSortOrder({
    required this.field,
    required this.direction,
  });

  factory MagentoSortOrder.fromJson(Map<String, dynamic> json) {
    return MagentoSortOrder(
      field: json['field'],
      direction: json['direction'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'direction': direction,
    };
  }
}

/// Magento Category model
class MagentoCategory extends MagentoModel {
  final int id;
  final int? parentId;
  final String name;
  final bool isActive;
  final int position;
  final int level;
  final String? urlKey;
  final String? description;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaKeywords;
  final int? productCount;
  final List<MagentoCategory>? childrenData;

  MagentoCategory({
    required this.id,
    this.parentId,
    required this.name,
    required this.isActive,
    required this.position,
    required this.level,
    this.urlKey,
    this.description,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.productCount,
    this.childrenData,
  });

  factory MagentoCategory.fromJson(Map<String, dynamic> json) {
    return MagentoCategory(
      id: json['id'],
      parentId: json['parent_id'],
      name: json['name'],
      isActive: json['is_active'],
      position: json['position'],
      level: json['level'],
      urlKey: json['url_key'],
      description: json['description'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      metaKeywords: json['meta_keywords'],
      productCount: json['product_count'],
      childrenData: json['children_data'] != null
          ? List<MagentoCategory>.from(
              json['children_data'].map((x) => MagentoCategory.fromJson(x)))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'name': name,
      'is_active': isActive,
      'position': position,
      'level': level,
      'url_key': urlKey,
      'description': description,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
      'product_count': productCount,
      'children_data': childrenData?.map((x) => x.toJson()).toList(),
    };
  }
}

/// Magento Cart model
class MagentoCart extends MagentoModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isVirtual;
  final List<MagentoCartItem> items;
  final int itemsCount;
  final int itemsQty;
  final MagentoCartTotals? totals;
  final String? currencyCode;
  final MagentoCustomer? customer;

  MagentoCart({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.isVirtual,
    required this.items,
    required this.itemsCount,
    required this.itemsQty,
    this.totals,
    this.currencyCode,
    this.customer,
  });

  factory MagentoCart.fromJson(Map<String, dynamic> json) {
    return MagentoCart(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'],
      isVirtual: json['is_virtual'],
      items: List<MagentoCartItem>.from(
          json['items'].map((x) => MagentoCartItem.fromJson(x))),
      itemsCount: json['items_count'],
      itemsQty: json['items_qty'],
      totals: json['totals'] != null
          ? MagentoCartTotals.fromJson(json['totals'])
          : null,
      currencyCode: json['currency_code'],
      customer: json['customer'] != null
          ? MagentoCustomer.fromJson(json['customer'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'is_virtual': isVirtual,
      'items': items.map((x) => x.toJson()).toList(),
      'items_count': itemsCount,
      'items_qty': itemsQty,
      'totals': totals?.toJson(),
      'currency_code': currencyCode,
      'customer': customer?.toJson(),
    };
  }
}

/// Magento Cart Item model
class MagentoCartItem extends MagentoModel {
  final int itemId;
  final String sku;
  final int qty;
  final String name;
  final double price;
  final double? originalPrice;
  final double? discountAmount;
  final double? taxAmount;
  final double? rowTotal;
  final double? rowTotalWithDiscount;
  final List<MagentoProductAttribute>? productOption;

  MagentoCartItem({
    required this.itemId,
    required this.sku,
    required this.qty,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discountAmount,
    this.taxAmount,
    this.rowTotal,
    this.rowTotalWithDiscount,
    this.productOption,
  });

  factory MagentoCartItem.fromJson(Map<String, dynamic> json) {
    return MagentoCartItem(
      itemId: json['item_id'],
      sku: json['sku'],
      qty: json['qty'],
      name: json['name'],
      price: json['price'].toDouble(),
      originalPrice: json['original_price']?.toDouble(),
      discountAmount: json['discount_amount']?.toDouble(),
      taxAmount: json['tax_amount']?.toDouble(),
      rowTotal: json['row_total']?.toDouble(),
      rowTotalWithDiscount: json['row_total_with_discount']?.toDouble(),
      productOption: json['product_option'] != null
          ? List<MagentoProductAttribute>.from(json['product_option']
              .map((x) => MagentoProductAttribute.fromJson(x)))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'sku': sku,
      'qty': qty,
      'name': name,
      'price': price,
      'original_price': originalPrice,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'row_total': rowTotal,
      'row_total_with_discount': rowTotalWithDiscount,
      'product_option': productOption?.map((x) => x.toJson()).toList(),
    };
  }
}

/// Magento Cart Totals model
class MagentoCartTotals extends MagentoModel {
  final double grandTotal;
  final double baseGrandTotal;
  final double subtotal;
  final double baseSubtotal;
  final double? discountAmount;
  final double? baseDiscountAmount;
  final double? shippingAmount;
  final double? baseShippingAmount;
  final double? taxAmount;
  final double? baseTaxAmount;
  final String? currencyCode;

  MagentoCartTotals({
    required this.grandTotal,
    required this.baseGrandTotal,
    required this.subtotal,
    required this.baseSubtotal,
    this.discountAmount,
    this.baseDiscountAmount,
    this.shippingAmount,
    this.baseShippingAmount,
    this.taxAmount,
    this.baseTaxAmount,
    this.currencyCode,
  });

  factory MagentoCartTotals.fromJson(Map<String, dynamic> json) {
    return MagentoCartTotals(
      grandTotal: json['grand_total'].toDouble(),
      baseGrandTotal: json['base_grand_total'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      baseSubtotal: json['base_subtotal'].toDouble(),
      discountAmount: json['discount_amount']?.toDouble(),
      baseDiscountAmount: json['base_discount_amount']?.toDouble(),
      shippingAmount: json['shipping_amount']?.toDouble(),
      baseShippingAmount: json['base_shipping_amount']?.toDouble(),
      taxAmount: json['tax_amount']?.toDouble(),
      baseTaxAmount: json['base_tax_amount']?.toDouble(),
      currencyCode: json['currency_code'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'grand_total': grandTotal,
      'base_grand_total': baseGrandTotal,
      'subtotal': subtotal,
      'base_subtotal': baseSubtotal,
      'discount_amount': discountAmount,
      'base_discount_amount': baseDiscountAmount,
      'shipping_amount': shippingAmount,
      'base_shipping_amount': baseShippingAmount,
      'tax_amount': taxAmount,
      'base_tax_amount': baseTaxAmount,
      'currency_code': currencyCode,
    };
  }
}

/// Magento Order model
class MagentoOrder extends MagentoModel {
  final int entityId;
  final String incrementId;
  final String state;
  final String status;
  final double grandTotal;
  final double baseGrandTotal;
  final double subtotal;
  final double baseSubtotal;
  final double? discountAmount;
  final double? baseDiscountAmount;
  final double? shippingAmount;
  final double? baseShippingAmount;
  final double? taxAmount;
  final double? baseTaxAmount;
  final String? currencyCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MagentoCustomer? customer;
  final List<MagentoOrderItem>? items;

  MagentoOrder({
    required this.entityId,
    required this.incrementId,
    required this.state,
    required this.status,
    required this.grandTotal,
    required this.baseGrandTotal,
    required this.subtotal,
    required this.baseSubtotal,
    this.discountAmount,
    this.baseDiscountAmount,
    this.shippingAmount,
    this.baseShippingAmount,
    this.taxAmount,
    this.baseTaxAmount,
    this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
    this.customer,
    this.items,
  });

  factory MagentoOrder.fromJson(Map<String, dynamic> json) {
    return MagentoOrder(
      entityId: json['entity_id'],
      incrementId: json['increment_id'],
      state: json['state'],
      status: json['status'],
      grandTotal: json['grand_total'].toDouble(),
      baseGrandTotal: json['base_grand_total'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      baseSubtotal: json['base_subtotal'].toDouble(),
      discountAmount: json['discount_amount']?.toDouble(),
      baseDiscountAmount: json['base_discount_amount']?.toDouble(),
      shippingAmount: json['shipping_amount']?.toDouble(),
      baseShippingAmount: json['base_shipping_amount']?.toDouble(),
      taxAmount: json['tax_amount']?.toDouble(),
      baseTaxAmount: json['base_tax_amount']?.toDouble(),
      currencyCode: json['currency_code'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      customer: json['customer'] != null
          ? MagentoCustomer.fromJson(json['customer'])
          : null,
      items: json['items'] != null
          ? List<MagentoOrderItem>.from(
              json['items'].map((x) => MagentoOrderItem.fromJson(x)))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'entity_id': entityId,
      'increment_id': incrementId,
      'state': state,
      'status': status,
      'grand_total': grandTotal,
      'base_grand_total': baseGrandTotal,
      'subtotal': subtotal,
      'base_subtotal': baseSubtotal,
      'discount_amount': discountAmount,
      'base_discount_amount': baseDiscountAmount,
      'shipping_amount': shippingAmount,
      'base_shipping_amount': baseShippingAmount,
      'tax_amount': taxAmount,
      'base_tax_amount': baseTaxAmount,
      'currency_code': currencyCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'customer': customer?.toJson(),
      'items': items?.map((x) => x.toJson()).toList(),
    };
  }
}

/// Magento Order Item model
class MagentoOrderItem extends MagentoModel {
  final int itemId;
  final String sku;
  final String name;
  final int qty;
  final double price;
  final double? originalPrice;
  final double? discountAmount;
  final double? taxAmount;
  final double? rowTotal;
  final double? rowTotalWithDiscount;

  MagentoOrderItem({
    required this.itemId,
    required this.sku,
    required this.name,
    required this.qty,
    required this.price,
    this.originalPrice,
    this.discountAmount,
    this.taxAmount,
    this.rowTotal,
    this.rowTotalWithDiscount,
  });

  factory MagentoOrderItem.fromJson(Map<String, dynamic> json) {
    return MagentoOrderItem(
      itemId: json['item_id'],
      sku: json['sku'],
      name: json['name'],
      qty: json['qty'],
      price: json['price'].toDouble(),
      originalPrice: json['original_price']?.toDouble(),
      discountAmount: json['discount_amount']?.toDouble(),
      taxAmount: json['tax_amount']?.toDouble(),
      rowTotal: json['row_total']?.toDouble(),
      rowTotalWithDiscount: json['row_total_with_discount']?.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'sku': sku,
      'name': name,
      'qty': qty,
      'price': price,
      'original_price': originalPrice,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'row_total': rowTotal,
      'row_total_with_discount': rowTotalWithDiscount,
    };
  }
}

/// Magento Order Request model
class MagentoOrderRequest extends MagentoModel {
  final MagentoOrderAddress? billingAddress;
  final MagentoOrderAddress? shippingAddress;
  final MagentoOrderPayment paymentMethod;
  final String? email;

  MagentoOrderRequest({
    this.billingAddress,
    this.shippingAddress,
    required this.paymentMethod,
    this.email,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'billingAddress': billingAddress?.toJson(),
      'shippingAddress': shippingAddress?.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'email': email,
    };
  }
}

/// Magento Order Address model
class MagentoOrderAddress extends MagentoModel {
  final String? region;
  final int? regionId;
  final String? regionCode;
  final String? countryId;
  final List<String>? street;
  final String? company;
  final String? telephone;
  final String? fax;
  final String? postcode;
  final String? city;
  final String? firstname;
  final String? lastname;
  final String? middlename;
  final String? prefix;
  final String? suffix;
  final String? vatId;
  final bool? saveInAddressBook;

  MagentoOrderAddress({
    this.region,
    this.regionId,
    this.regionCode,
    this.countryId,
    this.street,
    this.company,
    this.telephone,
    this.fax,
    this.postcode,
    this.city,
    this.firstname,
    this.lastname,
    this.middlename,
    this.prefix,
    this.suffix,
    this.vatId,
    this.saveInAddressBook,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'region': region,
      'region_id': regionId,
      'region_code': regionCode,
      'country_id': countryId,
      'street': street,
      'company': company,
      'telephone': telephone,
      'fax': fax,
      'postcode': postcode,
      'city': city,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'prefix': prefix,
      'suffix': suffix,
      'vat_id': vatId,
      'save_in_address_book': saveInAddressBook,
    };
  }
}

/// Magento Order Payment model
class MagentoOrderPayment extends MagentoModel {
  final String method;
  final Map<String, dynamic>? additionalData;

  MagentoOrderPayment({
    required this.method,
    this.additionalData,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'additional_data': additionalData,
    };
  }
}

/// Magento Wishlist model
class MagentoWishlist extends MagentoModel {
  final int id;
  final int customerId;
  final bool shared;
  final List<MagentoWishlistItem> items;

  MagentoWishlist({
    required this.id,
    required this.customerId,
    required this.shared,
    required this.items,
  });

  factory MagentoWishlist.fromJson(Map<String, dynamic> json) {
    return MagentoWishlist(
      id: json['id'],
      customerId: json['customer_id'],
      shared: json['shared'],
      items: List<MagentoWishlistItem>.from(
          json['items'].map((x) => MagentoWishlistItem.fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'shared': shared,
      'items': items.map((x) => x.toJson()).toList(),
    };
  }
}

/// Magento Wishlist Item model
class MagentoWishlistItem extends MagentoModel {
  final int id;
  final int wishlistId;
  final String sku;
  final String name;
  final double price;
  final String? description;
  final DateTime addedAt;

  MagentoWishlistItem({
    required this.id,
    required this.wishlistId,
    required this.sku,
    required this.name,
    required this.price,
    this.description,
    required this.addedAt,
  });

  factory MagentoWishlistItem.fromJson(Map<String, dynamic> json) {
    return MagentoWishlistItem(
      id: json['id'],
      wishlistId: json['wishlist_id'],
      sku: json['sku'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      addedAt: DateTime.parse(json['added_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wishlist_id': wishlistId,
      'sku': sku,
      'name': name,
      'price': price,
      'description': description,
      'added_at': addedAt.toIso8601String(),
    };
  }
}

/// Magento Store Config model
class MagentoStoreConfig extends MagentoModel {
  final int id;
  final String code;
  final String websiteId;
  final String locale;
  final String baseCurrencyCode;
  final String defaultDisplayCurrencyCode;
  final String timezone;
  final String weightUnit;
  final String baseUrl;
  final String baseLinkUrl;
  final String baseStaticUrl;
  final String baseMediaUrl;
  final String secureBaseUrl;
  final String secureBaseLinkUrl;
  final String secureBaseStaticUrl;
  final String secureBaseMediaUrl;

  MagentoStoreConfig({
    required this.id,
    required this.code,
    required this.websiteId,
    required this.locale,
    required this.baseCurrencyCode,
    required this.defaultDisplayCurrencyCode,
    required this.timezone,
    required this.weightUnit,
    required this.baseUrl,
    required this.baseLinkUrl,
    required this.baseStaticUrl,
    required this.baseMediaUrl,
    required this.secureBaseUrl,
    required this.secureBaseLinkUrl,
    required this.secureBaseStaticUrl,
    required this.secureBaseMediaUrl,
  });

  factory MagentoStoreConfig.fromJson(Map<String, dynamic> json) {
    return MagentoStoreConfig(
      id: json['id'],
      code: json['code'],
      websiteId: json['website_id'],
      locale: json['locale'],
      baseCurrencyCode: json['base_currency_code'],
      defaultDisplayCurrencyCode: json['default_display_currency_code'],
      timezone: json['timezone'],
      weightUnit: json['weight_unit'],
      baseUrl: json['base_url'],
      baseLinkUrl: json['base_link_url'],
      baseStaticUrl: json['base_static_url'],
      baseMediaUrl: json['base_media_url'],
      secureBaseUrl: json['secure_base_url'],
      secureBaseLinkUrl: json['secure_base_link_url'],
      secureBaseStaticUrl: json['secure_base_static_url'],
      secureBaseMediaUrl: json['secure_base_media_url'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'website_id': websiteId,
      'locale': locale,
      'base_currency_code': baseCurrencyCode,
      'default_display_currency_code': defaultDisplayCurrencyCode,
      'timezone': timezone,
      'weight_unit': weightUnit,
      'base_url': baseUrl,
      'base_link_url': baseLinkUrl,
      'base_static_url': baseStaticUrl,
      'base_media_url': baseMediaUrl,
      'secure_base_url': secureBaseUrl,
      'secure_base_link_url': secureBaseLinkUrl,
      'secure_base_static_url': secureBaseStaticUrl,
      'secure_base_media_url': secureBaseMediaUrl,
    };
  }
}

/// Magento Currency model
class MagentoCurrency extends MagentoModel {
  final String currencyCode;
  final String currencySymbol;
  final double rate;

  MagentoCurrency({
    required this.currencyCode,
    required this.currencySymbol,
    required this.rate,
  });

  factory MagentoCurrency.fromJson(Map<String, dynamic> json) {
    return MagentoCurrency(
      currencyCode: json['currency_code'],
      currencySymbol: json['currency_symbol'],
      rate: json['rate'].toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'currency_code': currencyCode,
      'currency_symbol': currencySymbol,
      'rate': rate,
    };
  }
}

/// Magento Country model
class MagentoCountry extends MagentoModel {
  final String id;
  final String twoLetterAbbreviation;
  final String threeLetterAbbreviation;
  final String fullNameLocale;
  final String fullNameEnglish;
  final List<MagentoRegion>? availableRegions;

  MagentoCountry({
    required this.id,
    required this.twoLetterAbbreviation,
    required this.threeLetterAbbreviation,
    required this.fullNameLocale,
    required this.fullNameEnglish,
    this.availableRegions,
  });

  factory MagentoCountry.fromJson(Map<String, dynamic> json) {
    return MagentoCountry(
      id: json['id'],
      twoLetterAbbreviation: json['two_letter_abbreviation'],
      threeLetterAbbreviation: json['three_letter_abbreviation'],
      fullNameLocale: json['full_name_locale'],
      fullNameEnglish: json['full_name_english'],
      availableRegions: json['available_regions'] != null
          ? List<MagentoRegion>.from(
              json['available_regions'].map((x) => MagentoRegion.fromJson(x)))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'two_letter_abbreviation': twoLetterAbbreviation,
      'three_letter_abbreviation': threeLetterAbbreviation,
      'full_name_locale': fullNameLocale,
      'full_name_english': fullNameEnglish,
      'available_regions': availableRegions?.map((x) => x.toJson()).toList(),
    };
  }
}

/// Magento Region model
class MagentoRegion extends MagentoModel {
  final int id;
  final String code;
  final String name;

  MagentoRegion({
    required this.id,
    required this.code,
    required this.name,
  });

  factory MagentoRegion.fromJson(Map<String, dynamic> json) {
    return MagentoRegion(
      id: json['id'],
      code: json['code'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }
}

/// Tax Lien to Magento Product Converter
class TaxLienMagentoConverter {
  /// Convert TaxLien to MagentoProduct with custom attributes
  static MagentoProduct taxLienToMagentoProduct(TaxLien taxLien) {
    return MagentoProduct(
      sku: taxLien.id,
      name: taxLien.fullAddress,
      description: taxLien.description,
      shortDescription: 'Tax Lien in ${taxLien.county}, ${taxLien.state}',
      price: taxLien.assessedValue,
      typeId: 'tax_lien',
      urlKey: 'tax-lien-${taxLien.id}',
      isActive: true,
      isVisible: true,
      isInStock: taxLien.isAvailable,
      qty: (taxLien.isAvailable ?? false) ? 1 : 0,
      visibility: '4', // Visible in catalog and search
      status: 1, // Enabled
      customAttributes: _createTaxLienCustomAttributes(taxLien),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Convert MagentoProduct to TaxLien
  static TaxLien magentoProductToTaxLien(MagentoProduct product) {
    return TaxLien(
      id: product.sku,
      propertyAddress: product.taxLienAddress ?? '',
      city: product.taxLienCity ?? '',
      state: product.taxLienState ?? '',
      zipCode: product.zipCode ?? '',
      county: product.county ?? '',
      assessedValue: product.assessedValue ?? 0.0,
      estimatedValue: product.assessedValue ?? 0.0,
      auctionDate: DateTime.now(),
      propertyType: 'residential',
      taxAmount: product.taxAmount ?? 0.0,
      interestRate: product.interestRate ?? 0.0,
      taxYear: product.taxYear ?? DateTime.now(),
      saleDate: product.saleDate ?? DateTime.now(),
      status: product.taxLienStatus ?? 'available',
      description: product.description ?? '',
      images: product.mediaGalleryEntries
              ?.map((img) => img.url ?? '')
              .where((url) => url.isNotEmpty)
              .toList() ??
          [],
      ownerName: product.ownerName,
      additionalInfo: null,
      parcelId: product.parcelId,
      owner: product.ownerName,
      issueDate: product.issueDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create custom attributes for TaxLien
  static List<MagentoProductAttribute> _createTaxLienCustomAttributes(
      TaxLien taxLien) {
    return [
      MagentoProductAttribute(attributeCode: 'tax_lien_id', value: taxLien.id),
      MagentoProductAttribute(
          attributeCode: 'parcel_id', value: taxLien.parcelId),
      MagentoProductAttribute(
          attributeCode: 'owner_name', value: taxLien.ownerName),
      MagentoProductAttribute(attributeCode: 'address', value: taxLien.address),
      MagentoProductAttribute(attributeCode: 'city', value: taxLien.city),
      MagentoProductAttribute(attributeCode: 'state', value: taxLien.state),
      MagentoProductAttribute(
          attributeCode: 'zip_code', value: taxLien.zipCode),
      MagentoProductAttribute(attributeCode: 'county', value: taxLien.county),
      MagentoProductAttribute(
          attributeCode: 'assessed_value',
          value: taxLien.assessedValue.toString()),
      MagentoProductAttribute(
          attributeCode: 'tax_amount', value: taxLien.taxAmount.toString()),
      MagentoProductAttribute(
          attributeCode: 'interest_rate',
          value: taxLien.interestRate.toString()),
      MagentoProductAttribute(
          attributeCode: 'tax_year',
          value: taxLien.taxYear?.toIso8601String() ?? ''),
      MagentoProductAttribute(
          attributeCode: 'sale_date',
          value: taxLien.saleDate?.toIso8601String() ?? ''),
      MagentoProductAttribute(attributeCode: 'status', value: taxLien.status),
      if (taxLien.issueDate != null)
        MagentoProductAttribute(
            attributeCode: 'issue_date',
            value: taxLien.issueDate!.toIso8601String()),
    ];
  }

  /// Update MagentoProduct with TaxLien data
  static MagentoProduct updateMagentoProductWithTaxLien(
      MagentoProduct product, TaxLien taxLien) {
    final updatedCustomAttributes =
        List<MagentoProductAttribute>.from(product.customAttributes ?? []);

    // Update existing attributes or add new ones
    final newAttributes = _createTaxLienCustomAttributes(taxLien);
    for (final newAttr in newAttributes) {
      final existingIndex = updatedCustomAttributes.indexWhere(
        (attr) => attr.attributeCode == newAttr.attributeCode,
      );

      if (existingIndex >= 0) {
        updatedCustomAttributes[existingIndex] = newAttr;
      } else {
        updatedCustomAttributes.add(newAttr);
      }
    }

    return MagentoProduct(
      sku: product.sku,
      name: taxLien.fullAddress,
      description: taxLien.description,
      shortDescription: product.shortDescription,
      price: taxLien.assessedValue,
      specialPrice: product.specialPrice,
      specialPriceFromDate: product.specialPriceFromDate,
      specialPriceToDate: product.specialPriceToDate,
      weight: product.weight,
      typeId: product.typeId ?? 'tax_lien',
      attributeSetId: product.attributeSetId,
      urlKey: product.urlKey ?? 'tax-lien-${taxLien.id}',
      isActive: product.isActive,
      isVisible: product.isVisible,
      isInStock: taxLien.isAvailable,
      qty: (taxLien.isAvailable ?? false) ? 1 : 0,
      visibility: product.visibility,
      status: product.status,
      categoryIds: product.categoryIds,
      mediaGalleryEntries: product.mediaGalleryEntries,
      customAttributes: updatedCustomAttributes,
      createdAt: product.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
