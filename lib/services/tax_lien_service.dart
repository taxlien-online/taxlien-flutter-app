import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class TaxLien {
  final String id;
  final String parcelId;
  final String owner;
  final String address;
  final String county;
  final String state;
  final double assessedValue;
  final double taxAmount;
  final double interestRate;
  final DateTime auctionDate;
  final DateTime redemptionDeadline;
  final String status; // 'available', 'sold', 'redeemed', 'foreclosed'
  final double? salePrice;
  final String? buyerId;
  final Map<String, dynamic>? additionalData;

  TaxLien({
    required this.id,
    required this.parcelId,
    required this.owner,
    required this.address,
    required this.county,
    required this.state,
    required this.assessedValue,
    required this.taxAmount,
    required this.interestRate,
    required this.auctionDate,
    required this.redemptionDeadline,
    required this.status,
    this.salePrice,
    this.buyerId,
    this.additionalData,
  });

  factory TaxLien.fromJson(Map<String, dynamic> json) {
    return TaxLien(
      id: json['id'],
      parcelId: json['parcelId'],
      owner: json['owner'],
      address: json['address'],
      county: json['county'],
      state: json['state'],
      assessedValue: json['assessedValue'].toDouble(),
      taxAmount: json['taxAmount'].toDouble(),
      interestRate: json['interestRate'].toDouble(),
      auctionDate: DateTime.parse(json['auctionDate']),
      redemptionDeadline: DateTime.parse(json['redemptionDeadline']),
      status: json['status'],
      salePrice: json['salePrice']?.toDouble(),
      buyerId: json['buyerId'],
      additionalData: json['additionalData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parcelId': parcelId,
      'owner': owner,
      'address': address,
      'county': county,
      'state': state,
      'assessedValue': assessedValue,
      'taxAmount': taxAmount,
      'interestRate': interestRate,
      'auctionDate': auctionDate.toIso8601String(),
      'redemptionDeadline': redemptionDeadline.toIso8601String(),
      'status': status,
      'salePrice': salePrice,
      'buyerId': buyerId,
      'additionalData': additionalData,
    };
  }
}

class TaxLienService extends ChangeNotifier {
  static const String _baseUrl = 'https://api.taxlien.online';
  List<TaxLien> _availableLiens = [];
  List<TaxLien> _myLiens = [];
  bool _isLoading = false;
  String? _error;

  List<TaxLien> get availableLiens => _availableLiens;
  List<TaxLien> get myLiens => _myLiens;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    await loadAvailableLiens();
    await loadMyLiens();
  }

  Future<void> loadAvailableLiens() async {
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/tax-liens/available'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _availableLiens = data.map((json) => TaxLien.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load available liens';
      }
    } catch (e) {
      _error = 'Network error: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMyLiens() async {
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/tax-liens/my-liens'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _myLiens = data.map((json) => TaxLien.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load my liens';
      }
    } catch (e) {
      _error = 'Network error: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> purchaseLien(String lienId, double bidAmount) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/tax-liens/$lienId/purchase'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'bidAmount': bidAmount}),
      );

      if (response.statusCode == 200) {
        await loadAvailableLiens();
        await loadMyLiens();
        _error = null;
        return true;
      } else {
        _error = 'Failed to purchase lien';
        return false;
      }
    } catch (e) {
      _error = 'Network error: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<TaxLien>> searchLiens({
    String? county,
    String? state,
    double? minAmount,
    double? maxAmount,
    double? minInterestRate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (county != null) queryParams['county'] = county;
      if (state != null) queryParams['state'] = state;
      if (minAmount != null) queryParams['minAmount'] = minAmount.toString();
      if (maxAmount != null) queryParams['maxAmount'] = maxAmount.toString();
      if (minInterestRate != null) queryParams['minInterestRate'] = minInterestRate.toString();

      final uri = Uri.parse('$_baseUrl/api/tax-liens/search').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TaxLien.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search liens');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
