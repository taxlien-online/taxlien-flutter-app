import 'package:flutter/foundation.dart';
import 'offline_data_loader_service.dart';

/// Service for searching tax liens from .rada files
class TaxLienSearchService {
  final OfflineDataLoaderService _dataLoader;

  TaxLienSearchService(this._dataLoader);

  /// Search tax liens with filters
  Future<List<TaxLien>> searchLiens({
    String? query,
    String? state,
    String? county,
    double? minAmount,
    double? maxAmount,
    double? minInterestRate,
    double? maxInterestRate,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // Get products from offline loader
      final products = await _dataLoader.getProducts(
        state: state,
        county: county,
        limit: limit * 2, // Get more to filter
        offset: offset,
      );

      // Convert to TaxLien objects
      List<TaxLien> liens = products.map((p) => TaxLien.fromMap(p)).toList();

      // Apply filters
      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        liens = liens.where((lien) {
          return lien.address.toLowerCase().contains(lowerQuery) ||
              lien.city.toLowerCase().contains(lowerQuery) ||
              lien.county.toLowerCase().contains(lowerQuery) ||
              lien.parcelId.toLowerCase().contains(lowerQuery);
        }).toList();
      }

      if (minAmount != null) {
        liens = liens.where((lien) => lien.amount >= minAmount).toList();
      }

      if (maxAmount != null) {
        liens = liens.where((lien) => lien.amount <= maxAmount).toList();
      }

      if (minInterestRate != null) {
        liens = liens
            .where((lien) => lien.interestRate >= minInterestRate)
            .toList();
      }

      if (maxInterestRate != null) {
        liens = liens
            .where((lien) => lien.interestRate <= maxInterestRate)
            .toList();
      }

      // Sort by interest rate (highest first)
      liens.sort((a, b) => b.interestRate.compareTo(a.interestRate));

      // Apply limit
      if (liens.length > limit) {
        liens = liens.sublist(0, limit);
      }

      return liens;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching liens: $e');
      }
      return [];
    }
  }

  /// Get statistics
  Future<SearchStatistics> getStatistics() async {
    try {
      final products = await _dataLoader.getProducts();
      final liens = products.map((p) => TaxLien.fromMap(p)).toList();

      if (liens.isEmpty) {
        return SearchStatistics.empty();
      }

      final totalCount = liens.length;
      final totalAmount = liens.fold<double>(
        0,
        (sum, lien) => sum + lien.amount,
      );
      final avgInterestRate = liens.fold<double>(
            0,
            (sum, lien) => sum + lien.interestRate,
          ) /
          liens.length;

      // Count by state
      final stateCount = <String, int>{};
      for (var lien in liens) {
        stateCount[lien.state] = (stateCount[lien.state] ?? 0) + 1;
      }

      return SearchStatistics(
        totalCount: totalCount,
        totalAmount: totalAmount,
        avgInterestRate: avgInterestRate,
        stateCount: stateCount,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error getting statistics: $e');
      }
      return SearchStatistics.empty();
    }
  }
}

/// Tax Lien model
class TaxLien {
  final String id;
  final String parcelId;
  final String address;
  final String city;
  final String county;
  final String state;
  final String zipCode;
  final double amount;
  final double interestRate;
  final String status;
  final DateTime? auctionDate;
  final String? ownerName;
  final double? assessedValue;

  TaxLien({
    required this.id,
    required this.parcelId,
    required this.address,
    required this.city,
    required this.county,
    required this.state,
    required this.zipCode,
    required this.amount,
    required this.interestRate,
    required this.status,
    this.auctionDate,
    this.ownerName,
    this.assessedValue,
  });

  factory TaxLien.fromMap(Map<String, dynamic> map) {
    return TaxLien(
      id: map['id']?.toString() ?? map['sku']?.toString() ?? '',
      parcelId: map['parcel_id']?.toString() ?? map['sku']?.toString() ?? '',
      address: map['address']?.toString() ?? map['name']?.toString() ?? 'N/A',
      city: map['city']?.toString() ?? _extractCity(map) ?? 'N/A',
      county: map['county']?.toString() ?? _extractCounty(map) ?? 'N/A',
      state: map['state']?.toString() ?? _extractState(map) ?? 'N/A',
      zipCode: map['zip_code']?.toString() ?? map['zip']?.toString() ?? '',
      amount:
          _parseDouble(map['amount'] ?? map['price'] ?? map['tax_amount'] ?? 0),
      interestRate: _parseDouble(map['interest_rate'] ?? map['rate'] ?? 0),
      status: map['status']?.toString() ?? 'available',
      auctionDate: _parseDate(map['auction_date']),
      ownerName: map['owner_name']?.toString() ?? map['owner']?.toString(),
      assessedValue: _parseDouble(map['assessed_value'] ?? map['value']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static String? _extractCity(Map<String, dynamic> map) {
    final name = map['name']?.toString() ?? '';
    final parts = name.split(',');
    if (parts.length >= 2) return parts[1].trim();
    return null;
  }

  static String? _extractCounty(Map<String, dynamic> map) {
    final description = map['description']?.toString() ?? '';
    if (description.contains('County:')) {
      final parts = description.split('County:');
      if (parts.length > 1) {
        return parts[1].split(',').first.trim();
      }
    }
    return null;
  }

  static String? _extractState(Map<String, dynamic> map) {
    final name = map['name']?.toString() ?? '';
    final parts = name.split(',');
    if (parts.length >= 3) {
      final statePart = parts[2].trim();
      if (statePart.length >= 2) return statePart.substring(0, 2);
    }
    return null;
  }
}

/// Search statistics
class SearchStatistics {
  final int totalCount;
  final double totalAmount;
  final double avgInterestRate;
  final Map<String, int> stateCount;

  SearchStatistics({
    required this.totalCount,
    required this.totalAmount,
    required this.avgInterestRate,
    required this.stateCount,
  });

  factory SearchStatistics.empty() {
    return SearchStatistics(
      totalCount: 0,
      totalAmount: 0,
      avgInterestRate: 0,
      stateCount: {},
    );
  }
}
