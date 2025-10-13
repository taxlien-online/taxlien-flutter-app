/// Magento Customer model
class MagentoCustomer {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final int groupId;
  final int storeId;
  final int websiteId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<MagentoAddress>? addresses;
  final Map<String, dynamic>? customAttributes;

  MagentoCustomer({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.groupId,
    required this.storeId,
    required this.websiteId,
    this.createdAt,
    this.updatedAt,
    this.addresses,
    this.customAttributes,
  });

  factory MagentoCustomer.fromJson(Map<String, dynamic> json) {
    return MagentoCustomer(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      groupId: json['group_id'] ?? 1,
      storeId: json['store_id'] ?? 1,
      websiteId: json['website_id'] ?? 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      addresses: json['addresses'] != null
          ? (json['addresses'] as List)
              .map((e) => MagentoAddress.fromJson(e))
              .toList()
          : null,
      customAttributes: json['custom_attributes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'group_id': groupId,
      'store_id': storeId,
      'website_id': websiteId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'addresses': addresses?.map((e) => e.toJson()).toList(),
      'custom_attributes': customAttributes,
    };
  }

  String get fullName => '$firstname $lastname';
}

/// Customer Address model
class MagentoAddress {
  final int? id;
  final int? customerId;
  final String? firstname;
  final String? lastname;
  final String? street;
  final String? city;
  final String? region;
  final String? postcode;
  final String? countryId;
  final String? telephone;
  final bool? defaultShipping;
  final bool? defaultBilling;

  MagentoAddress({
    this.id,
    this.customerId,
    this.firstname,
    this.lastname,
    this.street,
    this.city,
    this.region,
    this.postcode,
    this.countryId,
    this.telephone,
    this.defaultShipping,
    this.defaultBilling,
  });

  factory MagentoAddress.fromJson(Map<String, dynamic> json) {
    return MagentoAddress(
      id: json['id'],
      customerId: json['customer_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      street: json['street'] is List
          ? (json['street'] as List).join(', ')
          : json['street'],
      city: json['city'],
      region: json['region'],
      postcode: json['postcode'],
      countryId: json['country_id'],
      telephone: json['telephone'],
      defaultShipping: json['default_shipping'],
      defaultBilling: json['default_billing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      'firstname': firstname,
      'lastname': lastname,
      'street': street != null ? [street] : [],
      'city': city,
      'region': region,
      'postcode': postcode,
      'country_id': countryId,
      'telephone': telephone,
      'default_shipping': defaultShipping,
      'default_billing': defaultBilling,
    };
  }
}
