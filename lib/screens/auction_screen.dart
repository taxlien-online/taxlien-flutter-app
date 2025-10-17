import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/realtime_bidding_service.dart';
import '../core/models/tax_lien_models.dart';
import '../core/services/magento_api_service.dart';
import '../widgets/auction_timer.dart';
import '../widgets/bid_history_list.dart';
import '../widgets/bid_input_widget.dart';

class AuctionScreen extends StatefulWidget {
  final RealtimeBiddingService biddingService;
  final TaxLienAuction auction;

  const AuctionScreen({
    Key? key,
    required this.biddingService,
    required this.auction,
  }) : super(key: key);

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  
  final MagentoApiService _magentoApiService = MagentoApiService();
  
  final TextEditingController _bidController = TextEditingController();
  final FocusNode _bidFocusNode = FocusNode();
  
  bool _isPlacingBid = false;
  String? _bidError;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    _slideController.forward();
    
    // Join the auction
    widget.biddingService.joinAuction(widget.auction.id);
    
    // Listen to bid updates
    widget.biddingService.addListener(_onBiddingServiceChanged);
    
    // Set initial bid amount
    _updateBidAmount();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _bidController.dispose();
    _bidFocusNode.dispose();
    widget.biddingService.removeListener(_onBiddingServiceChanged);
    super.dispose();
  }

  void _onBiddingServiceChanged() {
    if (mounted) {
      setState(() {
        _updateBidAmount();
      });
      
      // Pulse animation when new bid is placed
      if (widget.biddingService.bids.isNotEmpty) {
        _pulseController.forward().then((_) {
          _pulseController.reverse();
        });
      }
    }
  }

  void _updateBidAmount() {
    final currentHighestBid = widget.biddingService.bids.isNotEmpty
        ? widget.biddingService.bids.first.amount
        : widget.auction.startingBid;
    
    final nextBidAmount = currentHighestBid + 100; // Minimum increment
    _bidController.text = nextBidAmount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Auction'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Connection status
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.biddingService.isConnected
                        ? Colors.green
                        : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.biddingService.isConnected ? 'Connected' : 'Disconnected',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Auction header
            _buildAuctionHeader(),
            
            // Property details
            _buildPropertyDetails(),
            
            // Current bid and timer
            _buildCurrentBidSection(),
            
            // Bid history
            Expanded(
              child: _buildBidHistory(),
            ),
            
            // Bid input section
            _buildBidInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.gavel,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Live Auction',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              AuctionTimer(
                endTime: widget.auction.endTime,
                onTimeUp: () {
                  // Handle auction end
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.auction.lien.address,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow('County', widget.auction.lien.county),
              _buildDetailRow('State', widget.auction.lien.state),
              _buildDetailRow('Parcel ID', widget.auction.lien.parcelId ?? 'N/A'),
              _buildDetailRow('Tax Amount', '\$${widget.auction.lien.taxAmount.toStringAsFixed(2)}'),
              _buildDetailRow('Interest Rate', '${widget.auction.lien.interestRate}%'),
              _buildDetailRow('Starting Bid', '\$${widget.auction.startingBid.toStringAsFixed(2)}'),
              _buildDetailRow('Reserve Price', '\$${widget.auction.reservePrice.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBidSection() {
    final currentHighestBid = widget.biddingService.bids.isNotEmpty
        ? widget.biddingService.bids.first.amount
        : widget.auction.startingBid;
    
    return FutureBuilder(
      future: _magentoApiService.getCurrentCustomer(),
      builder: (context, snapshot) {
        final customer = snapshot.data;
        final isMyBid = widget.biddingService.bids.isNotEmpty &&
            customer != null &&
            widget.biddingService.bids.first.bidderId == customer.id.toString();
    
        return Container(
          padding: const EdgeInsets.all(16),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Card(
                  color: isMyBid
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Current Highest Bid',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isMyBid
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${currentHighestBid.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: isMyBid
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.biddingService.bids.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'by ${widget.biddingService.bids.first.bidderName}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isMyBid
                                  ? Theme.of(context).colorScheme.onPrimaryContainer
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (isMyBid) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'YOUR BID',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBidHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Bid History',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder(
            future: _magentoApiService.getCurrentCustomer(),
            builder: (context, snapshot) {
              final customer = snapshot.data;
              return BidHistoryList(
                bids: widget.biddingService.bids,
                myUserId: customer?.id.toString() ?? '',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBidInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          if (_bidError != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _bidError!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          BidInputWidget(
            controller: _bidController,
            focusNode: _bidFocusNode,
            currentHighestBid: widget.biddingService.bids.isNotEmpty
                ? widget.biddingService.bids.first.amount
                : widget.auction.startingBid,
            isPlacingBid: _isPlacingBid,
            onBidPlaced: _placeBid,
            onQuickBid: _quickBid,
          ),
        ],
      ),
    );
  }

  Future<void> _placeBid(double amount) async {
    if (_isPlacingBid) return;
    
    setState(() {
      _isPlacingBid = true;
      _bidError = null;
    });
    
    try {
      final success = await widget.biddingService.placeBid(amount);
      
      if (!success && mounted) {
        setState(() {
          _bidError = widget.biddingService.error ?? 'Failed to place bid';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _bidError = 'Error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingBid = false;
        });
      }
    }
  }

  void _quickBid(double amount) {
    _bidController.text = amount.toStringAsFixed(0);
    _placeBid(amount);
  }
}
