/// Magento Product model
class MagentoProduct {
  final int id;
  final String sku;
  final String name;
  final double price;
  final String? description;
  final String? shortDescription;
  final int status;
  final String typeId;
  final List<String> categoryIds;
  final Map<String, dynamic>? customAttributes;
  final List<MagentoMediaGalleryEntry>? mediaGallery;

  MagentoProduct({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    this.description,
    this.shortDescription,
    required this.status,
    required this.typeId,
    this.categoryIds = const [],
    this.customAttributes,
    this.mediaGallery,
  });

  factory MagentoProduct.fromJson(Map<String, dynamic> json) {
    return MagentoProduct(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      shortDescription: json['short_description'],
      status: json['status'] ?? 1,
      typeId: json['type_id'] ?? 'simple',
      categoryIds: json['category_ids'] != null
          ? List<String>.from(json['category_ids'])
          : [],
      customAttributes: json['custom_attributes'],
      mediaGallery: json['media_gallery_entries'] != null
          ? (json['media_gallery_entries'] as List)
              .map((e) => MagentoMediaGalleryEntry.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'price': price,
      'description': description,
      'short_description': shortDescription,
      'status': status,
      'type_id': typeId,
      'category_ids': categoryIds,
      'custom_attributes': customAttributes,
      'media_gallery_entries': mediaGallery?.map((e) => e.toJson()).toList(),
    };
  }
}

/// Media gallery entry model
class MagentoMediaGalleryEntry {
  final int id;
  final String mediaType;
  final String file;
  final List<String> types;
  final bool disabled;

  MagentoMediaGalleryEntry({
    required this.id,
    required this.mediaType,
    required this.file,
    this.types = const [],
    this.disabled = false,
  });

  factory MagentoMediaGalleryEntry.fromJson(Map<String, dynamic> json) {
    return MagentoMediaGalleryEntry(
      id: json['id'] ?? 0,
      mediaType: json['media_type'] ?? 'image',
      file: json['file'] ?? '',
      types: json['types'] != null ? List<String>.from(json['types']) : [],
      disabled: json['disabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_type': mediaType,
      'file': file,
      'types': types,
      'disabled': disabled,
    };
  }
}
