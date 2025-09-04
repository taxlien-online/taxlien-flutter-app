import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../core/models/tax_lien_models.dart';

/// Real-time bidding service for tax lien auctions
class RealtimeBiddingService extends ChangeNotifier {
  static const String _baseUrl = 'wss://api.taxlien.online/ws';
  
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  
  // Bidding state
  bool _isConnected = false;
  bool _isBidding = false;
  String? _error;
  
  // Current auction data
  TaxLienAuction? _currentAuction;
  List<Bid> _bids = [];
  Bid? _myHighestBid;
  Timer? _auctionTimer;
  Duration? _timeRemaining;
  
  // Event streams
  final StreamController<Bid> _bidController = StreamController<Bid>.broadcast();
  final StreamController<TaxLienAuction> _auctionController = StreamController<TaxLienAuction>.broadcast();
  final StreamController<String> _notificationController = StreamController<String>.broadcast();
  
  // Getters
  bool get isConnected => _isConnected;
  bool get isBidding => _isBidding;
  String? get error => _error;
  TaxLienAuction? get currentAuction => _currentAuction;
  List<Bid> get bids => List.unmodifiable(_bids);
  Bid? get myHighestBid => _myHighestBid;
  Duration? get timeRemaining => _timeRemaining;
  
  // Streams
  Stream<Bid> get bidStream => _bidController.stream;
  Stream<TaxLienAuction> get auctionStream => _auctionController.stream;
  Stream<String> get notificationStream => _notificationController.stream;
  
  /// Connect to the bidding WebSocket
  Future<bool> connect() async {
    try {
      _setError(null);
      
      _channel = WebSocketChannel.connect(Uri.parse(_baseUrl));
      
      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );
      
      // Send authentication message
      _sendMessage({
        'type': 'auth',
        'token': 'user_token_here', // TODO: Get from auth service
      });
      
      _isConnected = true;
      notifyListeners();
      
      return true;
    } catch (e) {
      _setError('Failed to connect: $e');
      return false;
    }
  }
  
  /// Disconnect from the bidding WebSocket
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    _auctionTimer?.cancel();
    
    _isConnected = false;
    _currentAuction = null;
    _bids.clear();
    _myHighestBid = null;
    _timeRemaining = null;
    
    notifyListeners();
  }
  
  /// Join an auction
  Future<bool> joinAuction(String auctionId) async {
    if (!_isConnected) {
      _setError('Not connected to bidding service');
      return false;
    }
    
    try {
      _sendMessage({
        'type': 'join_auction',
        'auction_id': auctionId,
      });
      
      return true;
    } catch (e) {
      _setError('Failed to join auction: $e');
      return false;
    }
  }
  
  /// Leave current auction
  void leaveAuction() {
    if (_isConnected && _currentAuction != null) {
      _sendMessage({
        'type': 'leave_auction',
        'auction_id': _currentAuction!.id,
      });
    }
    
    _currentAuction = null;
    _bids.clear();
    _myHighestBid = null;
    _auctionTimer?.cancel();
    _timeRemaining = null;
    
    notifyListeners();
  }
  
  /// Place a bid
  Future<bool> placeBid(double amount) async {
    if (!_isConnected || _currentAuction == null) {
      _setError('Not connected or no active auction');
      return false;
    }
    
    if (_isBidding) {
      _setError('Bid already in progress');
      return false;
    }
    
    // Validate bid amount
    final currentHighestBid = _bids.isNotEmpty ? _bids.first.amount : _currentAuction!.startingBid;
    if (amount <= currentHighestBid) {
      _setError('Bid must be higher than current highest bid');
      return false;
    }
    
    try {
      _setBidding(true);
      
      _sendMessage({
        'type': 'place_bid',
        'auction_id': _currentAuction!.id,
        'amount': amount,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      return true;
    } catch (e) {
      _setBidding(false);
      _setError('Failed to place bid: $e');
      return false;
    }
  }
  
  /// Get auction history
  Future<List<TaxLienAuction>> getAuctionHistory({int limit = 50}) async {
    try {
      // TODO: Implement API call to get auction history
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    } catch (e) {
      _setError('Failed to get auction history: $e');
      return [];
    }
  }
  
  /// Get my bidding history
  Future<List<Bid>> getMyBiddingHistory({int limit = 50}) async {
    try {
      // TODO: Implement API call to get user's bidding history
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    } catch (e) {
      _setError('Failed to get bidding history: $e');
      return [];
    }
  }
  
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final type = data['type'] as String;
      
      switch (type) {
        case 'auction_started':
          _handleAuctionStarted(data);
          break;
        case 'auction_updated':
          _handleAuctionUpdated(data);
          break;
        case 'auction_ended':
          _handleAuctionEnded(data);
          break;
        case 'bid_placed':
          _handleBidPlaced(data);
          break;
        case 'bid_accepted':
          _handleBidAccepted(data);
          break;
        case 'bid_rejected':
          _handleBidRejected(data);
          break;
        case 'notification':
          _handleNotification(data);
          break;
        case 'error':
          _handleError(data['message']);
          break;
        default:
          if (kDebugMode) {
            print('Unknown message type: $type');
          }
      }
    } catch (e) {
      _setError('Failed to parse message: $e');
    }
  }
  
  void _handleAuctionStarted(Map<String, dynamic> data) {
    _currentAuction = TaxLienAuction.fromJson(data['auction']);
    _bids.clear();
    _myHighestBid = null;
    
    _startAuctionTimer();
    _auctionController.add(_currentAuction!);
    _notificationController.add('Auction started for ${_currentAuction!.lien.address}');
    
    notifyListeners();
  }
  
  void _handleAuctionUpdated(Map<String, dynamic> data) {
    if (_currentAuction != null) {
      _currentAuction = TaxLienAuction.fromJson(data['auction']);
      _auctionController.add(_currentAuction!);
      notifyListeners();
    }
  }
  
  void _handleAuctionEnded(Map<String, dynamic> data) {
    if (_currentAuction != null) {
      _currentAuction = TaxLienAuction.fromJson(data['auction']);
      _auctionTimer?.cancel();
      _timeRemaining = null;
      
      _auctionController.add(_currentAuction!);
      _notificationController.add('Auction ended for ${_currentAuction!.lien.address}');
      
      notifyListeners();
    }
  }
  
  void _handleBidPlaced(Map<String, dynamic> data) {
    final bid = Bid.fromJson(data['bid']);
    _bids.insert(0, bid); // Add to beginning (highest first)
    
    // Keep only last 50 bids
    if (_bids.length > 50) {
      _bids = _bids.take(50).toList();
    }
    
    _bidController.add(bid);
    notifyListeners();
  }
  
  void _handleBidAccepted(Map<String, dynamic> data) {
    final bid = Bid.fromJson(data['bid']);
    
    // Update my highest bid if this is mine
    if (bid.bidderId == 'user123') { // TODO: Get actual user ID
      _myHighestBid = bid;
    }
    
    _setBidding(false);
    _notificationController.add('Your bid of \$${bid.amount.toStringAsFixed(2)} was accepted!');
    notifyListeners();
  }
  
  void _handleBidRejected(Map<String, dynamic> data) {
    _setBidding(false);
    _setError(data['reason'] ?? 'Bid was rejected');
    _notificationController.add('Your bid was rejected: ${data['reason'] ?? 'Unknown reason'}');
  }
  
  void _handleNotification(Map<String, dynamic> data) {
    _notificationController.add(data['message'] ?? '');
  }
  
  void _handleError(dynamic error) {
    _setError(error.toString());
    _setBidding(false);
  }
  
  void _handleDisconnect() {
    _isConnected = false;
    _auctionTimer?.cancel();
    _timeRemaining = null;
    notifyListeners();
  }
  
  void _sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }
  
  void _startAuctionTimer() {
    _auctionTimer?.cancel();
    
    if (_currentAuction != null) {
      _auctionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final endTime = _currentAuction!.endTime;
        
        if (now.isAfter(endTime)) {
          _timeRemaining = Duration.zero;
          timer.cancel();
        } else {
          _timeRemaining = endTime.difference(now);
        }
        
        notifyListeners();
      });
    }
  }
  
  void _setBidding(bool bidding) {
    _isBidding = bidding;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
  
  @override
  void dispose() {
    disconnect();
    _bidController.close();
    _auctionController.close();
    _notificationController.close();
    super.dispose();
  }
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

/// Bid model
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
