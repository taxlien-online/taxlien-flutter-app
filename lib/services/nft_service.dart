import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'tax_lien_service.dart';

class NFTMetadata {
  final String name;
  final String description;
  final String image;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> properties;

  NFTMetadata({
    required this.name,
    required this.description,
    required this.image,
    required this.attributes,
    required this.properties,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'attributes': attributes,
      'properties': properties,
    };
  }

  factory NFTMetadata.fromJson(Map<String, dynamic> json) {
    return NFTMetadata(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      attributes: Map<String, dynamic>.from(json['attributes']),
      properties: Map<String, dynamic>.from(json['properties']),
    );
  }
}

class TaxLienNFT {
  final String id;
  final String tokenId;
  final TaxLien originalLien;
  final NFTMetadata metadata;
  final String ownerAddress;
  final DateTime createdAt;
  final String status; // 'minted', 'transferred', 'burned'
  final double? currentValue;
  final List<String> transactionHistory;

  TaxLienNFT({
    required this.id,
    required this.tokenId,
    required this.originalLien,
    required this.metadata,
    required this.ownerAddress,
    required this.createdAt,
    required this.status,
    this.currentValue,
    required this.transactionHistory,
  });

  factory TaxLienNFT.fromJson(Map<String, dynamic> json) {
    return TaxLienNFT(
      id: json['id'],
      tokenId: json['tokenId'],
      originalLien: TaxLien.fromJson(json['originalLien']),
      metadata: NFTMetadata.fromJson(json['metadata']),
      ownerAddress: json['ownerAddress'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      currentValue: json['currentValue']?.toDouble(),
      transactionHistory: List<String>.from(json['transactionHistory']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tokenId': tokenId,
      'originalLien': originalLien.toJson(),
      'metadata': metadata.toJson(),
      'ownerAddress': ownerAddress,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'currentValue': currentValue,
      'transactionHistory': transactionHistory,
    };
  }
}

class NFTService extends ChangeNotifier {
  static const String _baseUrl = 'https://api.taxlien.online';
  List<TaxLienNFT> _myNFTs = [];
  List<TaxLienNFT> _marketplaceNFTs = [];
  bool _isLoading = false;
  String? _error;

  List<TaxLienNFT> get myNFTs => _myNFTs;
  List<TaxLienNFT> get marketplaceNFTs => _marketplaceNFTs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Mock data for prototype
  final List<Map<String, dynamic>> _mockLienData = [
    {
      'id': 'TL001',
      'parcelId': 'R00051-000',
      'owner': 'John Smith',
      'address': '123 Main St, Columbia, FL 32025',
      'county': 'Columbia',
      'state': 'FL',
      'assessedValue': 85000.0,
      'taxAmount': 1250.0,
      'interestRate': 18.0,
      'auctionDate': '2024-01-15',
      'redemptionDeadline': '2025-01-15',
      'status': 'sold',
      'salePrice': 1250.0,
      'buyerId': 'user123',
    },
    {
      'id': 'TL002',
      'parcelId': '340913449600000040',
      'owner': 'Mary Johnson',
      'address': '456 Oak Ave, Dixie, FL 32329',
      'county': 'Dixie',
      'state': 'FL',
      'assessedValue': 120000.0,
      'taxAmount': 1800.0,
      'interestRate': 18.0,
      'auctionDate': '2024-02-20',
      'redemptionDeadline': '2025-02-20',
      'status': 'sold',
      'salePrice': 1800.0,
      'buyerId': 'user123',
    },
    {
      'id': 'TL003',
      'parcelId': 'L00001-000',
      'owner': 'Robert Wilson',
      'address': '789 Pine Rd, Lafayette, FL 32060',
      'county': 'Lafayette',
      'state': 'FL',
      'assessedValue': 95000.0,
      'taxAmount': 1425.0,
      'interestRate': 18.0,
      'auctionDate': '2024-03-10',
      'redemptionDeadline': '2025-03-10',
      'status': 'sold',
      'salePrice': 1425.0,
      'buyerId': 'user123',
    },
    {
      'id': 'TL004',
      'parcelId': 'P00001-000',
      'owner': 'Sarah Davis',
      'address': '321 Elm St, Polk, FL 33801',
      'county': 'Polk',
      'state': 'FL',
      'assessedValue': 150000.0,
      'taxAmount': 2250.0,
      'interestRate': 18.0,
      'auctionDate': '2024-04-05',
      'redemptionDeadline': '2025-04-05',
      'status': 'sold',
      'salePrice': 2250.0,
      'buyerId': 'user123',
    },
  ];

  Future<void> initialize() async {
    await loadMyNFTs();
    await loadMarketplaceNFTs();
  }

  Future<void> loadMyNFTs() async {
    _setLoading(true);
    try {
      // For prototype, we'll use mock data
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
      
      _myNFTs = _mockLienData.map((lienData) {
        final lien = TaxLien.fromJson(lienData);
        return _createNFTFromLien(lien, 'user123');
      }).toList();
      
      _error = null;
    } catch (e) {
      _error = 'Failed to load my NFTs: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMarketplaceNFTs() async {
    _setLoading(true);
    try {
      // For prototype, we'll use mock data
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
      
      _marketplaceNFTs = _mockLienData.take(2).map((lienData) {
        final lien = TaxLien.fromJson(lienData);
        return _createNFTFromLien(lien, 'other_user_${Random().nextInt(1000)}');
      }).toList();
      
      _error = null;
    } catch (e) {
      _error = 'Failed to load marketplace NFTs: $e';
    } finally {
      _setLoading(false);
    }
  }

  TaxLienNFT _createNFTFromLien(TaxLien lien, String ownerAddress) {
    final tokenId = 'NFT_${lien.id}_${DateTime.now().millisecondsSinceEpoch}';
    
    final metadata = NFTMetadata(
      name: 'Tax Lien NFT #${lien.id}',
      description: 'NFT representing a tax lien on property at ${lien.address}. '
          'This NFT entitles the holder to collect interest and potentially foreclose on the property.',
      image: 'https://api.taxlien.online/images/nft/${lien.id}.png',
      attributes: {
        'Parcel ID': lien.parcelId,
        'Property Address': lien.address,
        'County': lien.county,
        'State': lien.state,
        'Assessed Value': '\$${lien.assessedValue.toStringAsFixed(0)}',
        'Tax Amount': '\$${lien.taxAmount.toStringAsFixed(0)}',
        'Interest Rate': '${lien.interestRate}%',
        'Auction Date': lien.auctionDate.toString().split(' ')[0],
        'Redemption Deadline': lien.redemptionDeadline.toString().split(' ')[0],
        'Rarity': _calculateRarity(lien),
        'Risk Level': _calculateRiskLevel(lien),
      },
      properties: {
        'original_lien_id': lien.id,
        'parcel_id': lien.parcelId,
        'county': lien.county,
        'state': lien.state,
        'assessed_value': lien.assessedValue,
        'tax_amount': lien.taxAmount,
        'interest_rate': lien.interestRate,
        'auction_date': lien.auctionDate.toIso8601String(),
        'redemption_deadline': lien.redemptionDeadline.toIso8601String(),
      },
    );

    return TaxLienNFT(
      id: 'nft_${lien.id}',
      tokenId: tokenId,
      originalLien: lien,
      metadata: metadata,
      ownerAddress: ownerAddress,
      createdAt: DateTime.now(),
      status: 'minted',
      currentValue: lien.salePrice != null ? lien.salePrice! * 1.05 : lien.taxAmount * 1.05,
      transactionHistory: ['Minted on ${DateTime.now().toString().split(' ')[0]}'],
    );
  }

  String _calculateRarity(TaxLien lien) {
    if (lien.assessedValue > 200000) return 'Legendary';
    if (lien.assessedValue > 100000) return 'Epic';
    if (lien.assessedValue > 50000) return 'Rare';
    return 'Common';
  }

  String _calculateRiskLevel(TaxLien lien) {
    final daysUntilRedemption = lien.redemptionDeadline.difference(DateTime.now()).inDays;
    if (daysUntilRedemption < 30) return 'High';
    if (daysUntilRedemption < 90) return 'Medium';
    return 'Low';
  }

  Future<bool> mintNFTFromLien(TaxLien lien) async {
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      final nft = _createNFTFromLien(lien, 'user123');
      _myNFTs.add(nft);
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to mint NFT: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> transferNFT(String nftId, String toAddress) async {
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      final nftIndex = _myNFTs.indexWhere((nft) => nft.id == nftId);
      if (nftIndex != -1) {
        final nft = _myNFTs[nftIndex];
        final updatedNFT = TaxLienNFT(
          id: nft.id,
          tokenId: nft.tokenId,
          originalLien: nft.originalLien,
          metadata: nft.metadata,
          ownerAddress: toAddress,
          createdAt: nft.createdAt,
          status: 'transferred',
          currentValue: nft.currentValue,
          transactionHistory: [...nft.transactionHistory, 'Transferred to $toAddress on ${DateTime.now().toString().split(' ')[0]}'],
        );
        
        _myNFTs.removeAt(nftIndex);
        _marketplaceNFTs.add(updatedNFT);
        
        _error = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to transfer NFT: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> burnNFT(String nftId) async {
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      final nftIndex = _myNFTs.indexWhere((nft) => nft.id == nftId);
      if (nftIndex != -1) {
        final nft = _myNFTs[nftIndex];
        final updatedNFT = TaxLienNFT(
          id: nft.id,
          tokenId: nft.tokenId,
          originalLien: nft.originalLien,
          metadata: nft.metadata,
          ownerAddress: nft.ownerAddress,
          createdAt: nft.createdAt,
          status: 'burned',
          currentValue: nft.currentValue,
          transactionHistory: [...nft.transactionHistory, 'Burned on ${DateTime.now().toString().split(' ')[0]}'],
        );
        
        _myNFTs[nftIndex] = updatedNFT;
        
        _error = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to burn NFT: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<TaxLienNFT>> searchNFTs({
    String? county,
    String? state,
    double? minValue,
    double? maxValue,
    String? rarity,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      
      List<TaxLienNFT> allNFTs = [..._myNFTs, ..._marketplaceNFTs];
      
      return allNFTs.where((nft) {
        if (county != null && nft.originalLien.county != county) return false;
        if (state != null && nft.originalLien.state != state) return false;
        if (minValue != null && (nft.currentValue ?? 0) < minValue) return false;
        if (maxValue != null && (nft.currentValue ?? 0) > maxValue) return false;
        if (rarity != null && nft.metadata.attributes['Rarity'] != rarity) return false;
        return true;
      }).toList();
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
