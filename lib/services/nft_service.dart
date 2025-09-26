import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/models/tax_lien.dart';
import '../core/models/tax_lien_nft.dart';
import 'database_service.dart';

class NFTService {
  static NFTService? _instance;
  final DatabaseService _databaseService = DatabaseService.instance;

  NFTService._internal();

  static NFTService get instance {
    _instance ??= NFTService._internal();
    return _instance!;
  }

  // Get all NFTs
  Future<List<TaxLienNFT>> getAllNFTs() async {
    try {
      return await _databaseService.getAllTaxLienNFTs();
    } catch (e) {
      debugPrint('Error getting all NFTs: $e');
      return [];
    }
  }

  // Get NFTs by owner
  Future<List<TaxLienNFT>> getNFTsByOwner(String ownerAddress) async {
    try {
      return await _databaseService.getTaxLienNFTsByOwner(ownerAddress);
    } catch (e) {
      debugPrint('Error getting NFTs by owner: $e');
      return [];
    }
  }

  // Get NFT by ID
  Future<TaxLienNFT?> getNFTById(String id) async {
    try {
      return await _databaseService.getTaxLienNFTById(id);
    } catch (e) {
      debugPrint('Error getting NFT by ID: $e');
      return null;
    }
  }

  // Create NFT from TaxLien
  Future<TaxLienNFT?> createNFTFromTaxLien(
    TaxLien taxLien, {
    required String ownerAddress,
    required String contractAddress,
  }) async {
    try {
      final nft = TaxLienNFT(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tokenId: DateTime.now().millisecondsSinceEpoch.toString(),
        contractAddress: contractAddress,
        ownerAddress: ownerAddress,
        originalLien: taxLien,
        nftMetadata: _generateNFTMetadata(taxLien),
        imageUrl: taxLien.images.isNotEmpty ? taxLien.images.first : '',
        name: 'Tax Lien NFT - ${taxLien.propertyAddress}',
        description: 'NFT representing tax lien for ${taxLien.propertyAddress}',
        attributes: _generateAttributes(taxLien),
        mintedAt: DateTime.now(),
        status: 'minted',
      );

      await _databaseService.insertTaxLienNFT(nft);
      return nft;
    } catch (e) {
      debugPrint('Error creating NFT from tax lien: $e');
      return null;
    }
  }

  // Update NFT
  Future<bool> updateNFT(TaxLienNFT nft) async {
    try {
      await _databaseService.updateTaxLienNFT(nft);
      return true;
    } catch (e) {
      debugPrint('Error updating NFT: $e');
      return false;
    }
  }

  // Delete NFT
  Future<bool> deleteNFT(String id) async {
    try {
      await _databaseService.deleteTaxLienNFT(id);
      return true;
    } catch (e) {
      debugPrint('Error deleting NFT: $e');
      return false;
    }
  }

  // Transfer NFT
  Future<bool> transferNFT(String nftId, String newOwnerAddress) async {
    try {
      final nft = await getNFTById(nftId);
      if (nft == null) return false;

      final updatedNFT = nft.copyWith(
        ownerAddress: newOwnerAddress,
        status: 'transferred',
      );

      return await updateNFT(updatedNFT);
    } catch (e) {
      debugPrint('Error transferring NFT: $e');
      return false;
    }
  }

  // Sell NFT
  Future<bool> sellNFT(String nftId, double price) async {
    try {
      final nft = await getNFTById(nftId);
      if (nft == null) return false;

      final updatedNFT = nft.copyWith(
        salePrice: price,
        status: 'for_sale',
      );

      return await updateNFT(updatedNFT);
    } catch (e) {
      debugPrint('Error selling NFT: $e');
      return false;
    }
  }

  // Complete sale
  Future<bool> completeSale(String nftId, String newOwnerAddress) async {
    try {
      final nft = await getNFTById(nftId);
      if (nft == null) return false;

      final updatedNFT = nft.copyWith(
        ownerAddress: newOwnerAddress,
        soldAt: DateTime.now(),
        status: 'sold',
      );

      return await updateNFT(updatedNFT);
    } catch (e) {
      debugPrint('Error completing sale: $e');
      return false;
    }
  }

  // Generate NFT metadata
  String _generateNFTMetadata(TaxLien taxLien) {
    return '''
    {
      "name": "Tax Lien NFT - ${taxLien.propertyAddress}",
      "description": "NFT representing tax lien for ${taxLien.propertyAddress}",
      "image": "${taxLien.images.isNotEmpty ? taxLien.images.first : ''}",
      "attributes": [
        {
          "trait_type": "Property Address",
          "value": "${taxLien.propertyAddress}"
        },
        {
          "trait_type": "County",
          "value": "${taxLien.county}"
        },
        {
          "trait_type": "State",
          "value": "${taxLien.state}"
        },
        {
          "trait_type": "Tax Amount",
          "value": "${taxLien.taxAmount}"
        },
        {
          "trait_type": "Interest Rate",
          "value": "${taxLien.interestRate}"
        },
        {
          "trait_type": "Property Type",
          "value": "${taxLien.propertyType}"
        }
      ]
    }
    ''';
  }

  // Generate attributes
  List<String> _generateAttributes(TaxLien taxLien) {
    return [
      'Property Address: ${taxLien.propertyAddress}',
      'County: ${taxLien.county}',
      'State: ${taxLien.state}',
      'Tax Amount: \$${taxLien.taxAmount.toStringAsFixed(2)}',
      'Interest Rate: ${taxLien.interestRate}%',
      'Property Type: ${taxLien.propertyType}',
    ];
  }

  // Initialize method
  Future<void> initialize() async {
    try {
      // Initialize NFT service
      debugPrint('NFT Service initialized');
    } catch (e) {
      debugPrint('Error initializing NFT service: $e');
    }
  }

  // Check if service is initialized
  bool get isInitialized => true;

  // Get my NFTs
  List<TaxLienNFT> get myNFTs => [];
}
