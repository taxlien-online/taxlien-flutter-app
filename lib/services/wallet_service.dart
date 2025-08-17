import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WalletInfo {
  final String address;
  final String name;
  final String type; // 'metamask', 'walletconnect', 'coinbase', etc.
  final bool isConnected;
  final double? balance;
  final List<String> supportedChains;
  final DateTime? lastConnected;

  WalletInfo({
    required this.address,
    required this.name,
    required this.type,
    required this.isConnected,
    this.balance,
    required this.supportedChains,
    this.lastConnected,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      address: json['address'],
      name: json['name'],
      type: json['type'],
      isConnected: json['isConnected'],
      balance: json['balance']?.toDouble(),
      supportedChains: List<String>.from(json['supportedChains']),
      lastConnected: json['lastConnected'] != null 
          ? DateTime.parse(json['lastConnected']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'name': name,
      'type': type,
      'isConnected': isConnected,
      'balance': balance,
      'supportedChains': supportedChains,
      'lastConnected': lastConnected?.toIso8601String(),
    };
  }
}

class NFTBalance {
  final String tokenId;
  final String contractAddress;
  final String name;
  final String symbol;
  final String? image;
  final int balance;
  final String? metadata;

  NFTBalance({
    required this.tokenId,
    required this.contractAddress,
    required this.name,
    required this.symbol,
    this.image,
    required this.balance,
    this.metadata,
  });

  factory NFTBalance.fromJson(Map<String, dynamic> json) {
    return NFTBalance(
      tokenId: json['tokenId'],
      contractAddress: json['contractAddress'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      balance: json['balance'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokenId': tokenId,
      'contractAddress': contractAddress,
      'name': name,
      'symbol': symbol,
      'image': image,
      'balance': balance,
      'metadata': metadata,
    };
  }
}

class WalletService extends ChangeNotifier {
  static const String _baseUrl = 'https://api.taxlien.online';
  
  WalletInfo? _connectedWallet;
  List<WalletInfo> _availableWallets = [];
  List<NFTBalance> _nftBalances = [];
  bool _isLoading = false;
  String? _error;
  bool _isConnecting = false;

  // Mock wallet data for prototype
  final List<Map<String, dynamic>> _mockWallets = [
    {
      'address': '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
      'name': 'MetaMask',
      'type': 'metamask',
      'isConnected': false,
      'balance': 2.45,
      'supportedChains': ['ethereum', 'polygon', 'bsc'],
      'lastConnected': null,
    },
    {
      'address': '0x8ba1f109551bD432803012645Hac136c772c3c3',
      'name': 'WalletConnect',
      'type': 'walletconnect',
      'isConnected': false,
      'balance': 1.23,
      'supportedChains': ['ethereum', 'polygon', 'avalanche'],
      'lastConnected': null,
    },
    {
      'address': '0x1234567890123456789012345678901234567890',
      'name': 'Coinbase Wallet',
      'type': 'coinbase',
      'isConnected': false,
      'balance': 5.67,
      'supportedChains': ['ethereum', 'polygon'],
      'lastConnected': null,
    },
  ];

  final List<Map<String, dynamic>> _mockNFTBalances = [
    {
      'tokenId': 'NFT_TL001_1703123456789',
      'contractAddress': '0x1234567890123456789012345678901234567890',
      'name': 'Tax Lien NFT #TL001',
      'symbol': 'TLNFT',
      'image': 'https://api.taxlien.online/images/nft/TL001.png',
      'balance': 1,
      'metadata': '{"rarity": "Rare", "risk": "Low"}',
    },
    {
      'tokenId': 'NFT_TL002_1703123456790',
      'contractAddress': '0x1234567890123456789012345678901234567890',
      'name': 'Tax Lien NFT #TL002',
      'symbol': 'TLNFT',
      'image': 'https://api.taxlien.online/images/nft/TL002.png',
      'balance': 1,
      'metadata': '{"rarity": "Epic", "risk": "Medium"}',
    },
  ];

  WalletInfo? get connectedWallet => _connectedWallet;
  List<WalletInfo> get availableWallets => _availableWallets;
  List<NFTBalance> get nftBalances => _nftBalances;
  bool get isLoading => _isLoading;
  bool get isConnecting => _isConnecting;
  String? get error => _error;
  bool get isWalletConnected => _connectedWallet != null && _connectedWallet!.isConnected;

  Future<void> initialize() async {
    await loadAvailableWallets();
  }

  Future<void> loadAvailableWallets() async {
    _setLoading(true);
    try {
      // For prototype, we'll use mock data
      await Future.delayed(Duration(milliseconds: 500));
      
      _availableWallets = _mockWallets.map((json) => WalletInfo.fromJson(json)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load available wallets: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> connectWallet(String walletType) async {
    _setConnecting(true);
    try {
      // Simulate wallet connection
      await Future.delayed(Duration(seconds: 2));
      
      final walletIndex = _availableWallets.indexWhere((w) => w.type == walletType);
      if (walletIndex != -1) {
        final wallet = _availableWallets[walletIndex];
        _connectedWallet = WalletInfo(
          address: wallet.address,
          name: wallet.name,
          type: wallet.type,
          isConnected: true,
          balance: wallet.balance,
          supportedChains: wallet.supportedChains,
          lastConnected: DateTime.now(),
        );
        
        // Update the wallet in the list
        _availableWallets[walletIndex] = _connectedWallet!;
        
        // Load NFT balances
        await loadNFTBalances();
        
        _error = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to connect wallet: $e';
      return false;
    } finally {
      _setConnecting(false);
    }
  }

  Future<bool> disconnectWallet() async {
    _setLoading(true);
    try {
      // Simulate wallet disconnection
      await Future.delayed(Duration(milliseconds: 500));
      
      if (_connectedWallet != null) {
        final walletIndex = _availableWallets.indexWhere((w) => w.address == _connectedWallet!.address);
        if (walletIndex != -1) {
          _availableWallets[walletIndex] = WalletInfo(
            address: _connectedWallet!.address,
            name: _connectedWallet!.name,
            type: _connectedWallet!.type,
            isConnected: false,
            balance: _connectedWallet!.balance,
            supportedChains: _connectedWallet!.supportedChains,
            lastConnected: _connectedWallet!.lastConnected,
          );
        }
        
        _connectedWallet = null;
        _nftBalances.clear();
        
        _error = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to disconnect wallet: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadNFTBalances() async {
    if (_connectedWallet == null) return;
    
    _setLoading(true);
    try {
      // For prototype, we'll use mock data
      await Future.delayed(Duration(milliseconds: 800));
      
      _nftBalances = _mockNFTBalances.map((json) => NFTBalance.fromJson(json)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load NFT balances: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendTransaction({
    required String toAddress,
    required double amount,
    String? data,
  }) async {
    if (_connectedWallet == null) return false;
    
    _setLoading(true);
    try {
      // Simulate transaction
      await Future.delayed(Duration(seconds: 3));
      
      // Update wallet balance
      if (_connectedWallet!.balance != null) {
        _connectedWallet = WalletInfo(
          address: _connectedWallet!.address,
          name: _connectedWallet!.name,
          type: _connectedWallet!.type,
          isConnected: _connectedWallet!.isConnected,
          balance: _connectedWallet!.balance! - amount,
          supportedChains: _connectedWallet!.supportedChains,
          lastConnected: _connectedWallet!.lastConnected,
        );
        
        // Update in available wallets list
        final walletIndex = _availableWallets.indexWhere((w) => w.address == _connectedWallet!.address);
        if (walletIndex != -1) {
          _availableWallets[walletIndex] = _connectedWallet!;
        }
      }
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Transaction failed: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signMessage(String message) async {
    if (_connectedWallet == null) return false;
    
    _setLoading(true);
    try {
      // Simulate message signing
      await Future.delayed(Duration(seconds: 1));
      
      _error = null;
      return true;
    } catch (e) {
      _error = 'Failed to sign message: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> getWalletAddress() async {
    if (_connectedWallet == null) return null;
    return _connectedWallet!.address;
  }

  Future<double?> getWalletBalance() async {
    if (_connectedWallet == null) return null;
    return _connectedWallet!.balance;
  }

  Future<List<String>> getSupportedChains() async {
    if (_connectedWallet == null) return [];
    return _connectedWallet!.supportedChains;
  }

  Future<bool> switchChain(String chainId) async {
    if (_connectedWallet == null) return false;
    
    _setLoading(true);
    try {
      // Simulate chain switching
      await Future.delayed(Duration(milliseconds: 500));
      
      _error = null;
      return true;
    } catch (e) {
      _error = 'Failed to switch chain: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setConnecting(bool connecting) {
    _isConnecting = connecting;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
