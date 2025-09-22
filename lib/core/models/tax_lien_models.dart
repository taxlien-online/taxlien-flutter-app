/// Tax lien models for the application

/// Tax lien model representing a tax lien property
class TaxLien {
  final String id;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String county;
  final double assessedValue;
  final double taxAmount;
  final double interestRate;
  final DateTime taxYear;
  final DateTime saleDate;
  final String status; // 'available', 'sold', 'redeemed'
  final String? ownerName;
  final String? description;
  final List<String> images;
  final Map<String, dynamic>? additionalInfo;

  const TaxLien({
    required this.id,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.county,
    required this.assessedValue,
    required this.taxAmount,
    required this.interestRate,
    required this.taxYear,
    required this.saleDate,
    required this.status,
    this.ownerName,
    this.description,
    this.images = const [],
    this.additionalInfo,
  });

  factory TaxLien.fromJson(Map<String, dynamic> json) {
    return TaxLien(
      id: json['id'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      county: json['county'],
      assessedValue: json['assessed_value']?.toDouble() ?? 0.0,
      taxAmount: json['tax_amount']?.toDouble() ?? 0.0,
      interestRate: json['interest_rate']?.toDouble() ?? 0.0,
      taxYear: DateTime.parse(json['tax_year']),
      saleDate: DateTime.parse(json['sale_date']),
      status: json['status'],
      ownerName: json['owner_name'],
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      additionalInfo: json['additional_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'county': county,
      'assessed_value': assessedValue,
      'tax_amount': taxAmount,
      'interest_rate': interestRate,
      'tax_year': taxYear.toIso8601String(),
      'sale_date': saleDate.toIso8601String(),
      'status': status,
      'owner_name': ownerName,
      'description': description,
      'images': images,
      'additional_info': additionalInfo,
    };
  }

  String get fullAddress => '$address, $city, $state $zipCode';

  bool get isAvailable => status == 'available';
  bool get isSold => status == 'sold';
  bool get isRedeemed => status == 'redeemed';
}

/// Tax lien auction model
class TaxLienAuction {
  final String id;
  final TaxLien lien;
  final double startingBid;
  final double reservePrice;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'upcoming', 'active', 'ended'
  final String? winnerId;
  final double? winningBid;
  final List<String> participants;

  const TaxLienAuction({
    required this.id,
    required this.lien,
    required this.startingBid,
    required this.reservePrice,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.winnerId,
    this.winningBid,
    this.participants = const [],
  });

  factory TaxLienAuction.fromJson(Map<String, dynamic> json) {
    return TaxLienAuction(
      id: json['id'],
      lien: TaxLien.fromJson(json['lien']),
      startingBid: json['starting_bid'].toDouble(),
      reservePrice: json['reserve_price'].toDouble(),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'],
      winnerId: json['winner_id'],
      winningBid: json['winning_bid']?.toDouble(),
      participants: List<String>.from(json['participants'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lien': lien.toJson(),
      'starting_bid': startingBid,
      'reserve_price': reservePrice,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'status': status,
      'winner_id': winnerId,
      'winning_bid': winningBid,
      'participants': participants,
    };
  }

  bool get isActive => status == 'active' && DateTime.now().isBefore(endTime);
  bool get isEnded => status == 'ended' || DateTime.now().isAfter(endTime);
  Duration get timeRemaining => endTime.difference(DateTime.now());
}

/// Bid model for tax lien auctions
class Bid {
  final String id;
  final String auctionId;
  final String bidderId;
  final String bidderName;
  final double amount;
  final DateTime timestamp;
  final String status; // 'pending', 'accepted', 'rejected'

  const Bid({
    required this.id,
    required this.auctionId,
    required this.bidderId,
    required this.bidderName,
    required this.amount,
    required this.timestamp,
    this.status = 'pending',
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'],
      auctionId: json['auction_id'],
      bidderId: json['bidder_id'],
      bidderName: json['bidder_name'],
      amount: json['amount'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auction_id': auctionId,
      'bidder_id': bidderId,
      'bidder_name': bidderName,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}

/// Portfolio model for user's tax lien investments
class TaxLienPortfolio {
  final String userId;
  final List<TaxLienInvestment> investments;
  final double totalInvested;
  final double totalValue;
  final double totalReturn;
  final double totalReturnPercentage;

  const TaxLienPortfolio({
    required this.userId,
    required this.investments,
    required this.totalInvested,
    required this.totalValue,
    required this.totalReturn,
    required this.totalReturnPercentage,
  });

  factory TaxLienPortfolio.fromJson(Map<String, dynamic> json) {
    return TaxLienPortfolio(
      userId: json['user_id'],
      investments: (json['investments'] as List)
          .map((investment) => TaxLienInvestment.fromJson(investment))
          .toList(),
      totalInvested: json['total_invested'].toDouble(),
      totalValue: json['total_value'].toDouble(),
      totalReturn: json['total_return'].toDouble(),
      totalReturnPercentage: json['total_return_percentage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'investments':
          investments.map((investment) => investment.toJson()).toList(),
      'total_invested': totalInvested,
      'total_value': totalValue,
      'total_return': totalReturn,
      'total_return_percentage': totalReturnPercentage,
    };
  }
}

/// Tax lien investment model
class TaxLienInvestment {
  final String id;
  final String userId;
  final TaxLien lien;
  final double amountInvested;
  final DateTime investmentDate;
  final String status; // 'active', 'redeemed', 'foreclosed'
  final double? currentValue;
  final double? returnAmount;
  final DateTime? redemptionDate;
  final String? notes;

  const TaxLienInvestment({
    required this.id,
    required this.userId,
    required this.lien,
    required this.amountInvested,
    required this.investmentDate,
    required this.status,
    this.currentValue,
    this.returnAmount,
    this.redemptionDate,
    this.notes,
  });

  factory TaxLienInvestment.fromJson(Map<String, dynamic> json) {
    return TaxLienInvestment(
      id: json['id'],
      userId: json['user_id'],
      lien: TaxLien.fromJson(json['lien']),
      amountInvested: json['amount_invested'].toDouble(),
      investmentDate: DateTime.parse(json['investment_date']),
      status: json['status'],
      currentValue: json['current_value']?.toDouble(),
      returnAmount: json['return_amount']?.toDouble(),
      redemptionDate: json['redemption_date'] != null
          ? DateTime.parse(json['redemption_date'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'lien': lien.toJson(),
      'amount_invested': amountInvested,
      'investment_date': investmentDate.toIso8601String(),
      'status': status,
      'current_value': currentValue,
      'return_amount': returnAmount,
      'redemption_date': redemptionDate?.toIso8601String(),
      'notes': notes,
    };
  }

  bool get isActive => status == 'active';
  bool get isRedeemed => status == 'redeemed';
  bool get isForeclosed => status == 'foreclosed';

  double get returnPercentage {
    if (returnAmount == null || amountInvested == 0) return 0.0;
    return (returnAmount! / amountInvested) * 100;
  }
}

/// Search filters for tax lien properties
class TaxLienSearchFilters {
  final String? state;
  final String? county;
  final String? city;
  final double? minTaxAmount;
  final double? maxTaxAmount;
  final double? minAssessedValue;
  final double? maxAssessedValue;
  final double? minInterestRate;
  final double? maxInterestRate;
  final DateTime? minSaleDate;
  final DateTime? maxSaleDate;
  final List<String> statuses;
  final String? searchQuery;

  const TaxLienSearchFilters({
    this.state,
    this.county,
    this.city,
    this.minTaxAmount,
    this.maxTaxAmount,
    this.minAssessedValue,
    this.maxAssessedValue,
    this.minInterestRate,
    this.maxInterestRate,
    this.minSaleDate,
    this.maxSaleDate,
    this.statuses = const [],
    this.searchQuery,
  });

  factory TaxLienSearchFilters.fromJson(Map<String, dynamic> json) {
    return TaxLienSearchFilters(
      state: json['state'],
      county: json['county'],
      city: json['city'],
      minTaxAmount: json['min_tax_amount']?.toDouble(),
      maxTaxAmount: json['max_tax_amount']?.toDouble(),
      minAssessedValue: json['min_assessed_value']?.toDouble(),
      maxAssessedValue: json['max_assessed_value']?.toDouble(),
      minInterestRate: json['min_interest_rate']?.toDouble(),
      maxInterestRate: json['max_interest_rate']?.toDouble(),
      minSaleDate: json['min_sale_date'] != null
          ? DateTime.parse(json['min_sale_date'])
          : null,
      maxSaleDate: json['max_sale_date'] != null
          ? DateTime.parse(json['max_sale_date'])
          : null,
      statuses: List<String>.from(json['statuses'] ?? []),
      searchQuery: json['search_query'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'county': county,
      'city': city,
      'min_tax_amount': minTaxAmount,
      'max_tax_amount': maxTaxAmount,
      'min_assessed_value': minAssessedValue,
      'max_assessed_value': maxAssessedValue,
      'min_interest_rate': minInterestRate,
      'max_interest_rate': maxInterestRate,
      'min_sale_date': minSaleDate?.toIso8601String(),
      'max_sale_date': maxSaleDate?.toIso8601String(),
      'statuses': statuses,
      'search_query': searchQuery,
    };
  }

  bool get hasFilters =>
      state != null ||
      county != null ||
      city != null ||
      minTaxAmount != null ||
      maxTaxAmount != null ||
      minAssessedValue != null ||
      maxAssessedValue != null ||
      minInterestRate != null ||
      maxInterestRate != null ||
      minSaleDate != null ||
      maxSaleDate != null ||
      statuses.isNotEmpty ||
      (searchQuery != null && searchQuery!.isNotEmpty);
}
