/// Magento Category model
class MagentoCategory {
  final int id;
  final String name;
  final bool isActive;
  final int level;
  final int? parentId;
  final int position;
  final List<int> children;
  final String? urlKey;
  final String? urlPath;
  final int? productCount;

  MagentoCategory({
    required this.id,
    required this.name,
    required this.isActive,
    required this.level,
    this.parentId,
    required this.position,
    this.children = const [],
    this.urlKey,
    this.urlPath,
    this.productCount,
  });

  factory MagentoCategory.fromJson(Map<String, dynamic> json) {
    return MagentoCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isActive: json['is_active'] ?? true,
      level: json['level'] ?? 0,
      parentId: json['parent_id'],
      position: json['position'] ?? 0,
      children:
          json['children'] != null ? List<int>.from(json['children']) : [],
      urlKey: json['url_key'],
      urlPath: json['url_path'],
      productCount: json['product_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
      'level': level,
      'parent_id': parentId,
      'position': position,
      'children': children,
      'url_key': urlKey,
      'url_path': urlPath,
      'product_count': productCount,
    };
  }
}
