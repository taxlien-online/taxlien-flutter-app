/// Marketplace Seller model
class MarketplaceSeller {
  final int id;
  final int vendorId;
  final String firstname;
  final String lastname;
  final String email;
  final String? phone;
  final bool isActive;
  final List<String> permissions;
  final DateTime? createdAt;

  MarketplaceSeller({
    required this.id,
    required this.vendorId,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.phone,
    required this.isActive,
    this.permissions = const [],
    this.createdAt,
  });

  factory MarketplaceSeller.fromJson(Map<String, dynamic> json) {
    return MarketplaceSeller(
      id: json['id'] ?? 0,
      vendorId: json['vendor_id'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      isActive: json['is_active'] ?? false,
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'is_active': isActive,
      'permissions': permissions,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get fullName => '$firstname $lastname';
}
