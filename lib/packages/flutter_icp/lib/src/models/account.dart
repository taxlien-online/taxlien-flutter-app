/// ICP Account model
class ICPAccount {
  final String address;
  final double balance;
  final String? principal;
  final int? subaccount;
  final DateTime? lastUpdated;

  ICPAccount({
    required this.address,
    required this.balance,
    this.principal,
    this.subaccount,
    this.lastUpdated,
  });

  factory ICPAccount.fromJson(Map<String, dynamic> json) {
    return ICPAccount(
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      principal: json['principal'],
      subaccount: json['subaccount'],
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'balance': balance,
      'principal': principal,
      'subaccount': subaccount,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }
}
