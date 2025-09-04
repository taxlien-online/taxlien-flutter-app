import 'package:flutter/material.dart';
import '../services/realtime_bidding_service.dart';

class BidHistoryList extends StatelessWidget {
  final List<Bid> bids;
  final String myUserId;

  const BidHistoryList({
    Key? key,
    required this.bids,
    required this.myUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bids.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gavel_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Bids Yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to place a bid!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: bids.length,
      itemBuilder: (context, index) {
        final bid = bids[index];
        final isMyBid = bid.bidderId == myUserId;
        final isHighestBid = index == 0;
        
        return _buildBidCard(context, bid, isMyBid, isHighestBid);
      },
    );
  }

  Widget _buildBidCard(BuildContext context, Bid bid, bool isMyBid, bool isHighestBid) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: isMyBid
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : isHighestBid
                ? Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.3)
                : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Bid amount
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${bid.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isMyBid
                            ? Theme.of(context).colorScheme.primary
                            : isHighestBid
                                ? Theme.of(context).colorScheme.tertiary
                                : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTimestamp(bid.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bidder info
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isMyBid ? 'You' : _maskBidderName(bid.bidderName),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isMyBid
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        if (isMyBid) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.person,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    _buildBidStatus(context, bid),
                  ],
                ),
              ),
              
              // Status indicators
              Column(
                children: [
                  if (isHighestBid)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'HIGHEST',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  if (isMyBid && !isHighestBid)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'YOURS',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBidStatus(BuildContext context, Bid bid) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (bid.status) {
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Accepted';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Rejected';
        break;
      case 'pending':
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'Pending';
        break;
    }
    
    return Row(
      children: [
        Icon(
          statusIcon,
          size: 12,
          color: statusColor,
        ),
        const SizedBox(width: 4),
        Text(
          statusText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  String _maskBidderName(String name) {
    if (name.length <= 2) return name;
    
    final firstChar = name[0];
    final lastChar = name[name.length - 1];
    final middleChars = '*' * (name.length - 2);
    
    return '$firstChar$middleChars$lastChar';
  }
}

class BidHistorySummary extends StatelessWidget {
  final List<Bid> bids;
  final String myUserId;

  const BidHistorySummary({
    Key? key,
    required this.bids,
    required this.myUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bids.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalBids = bids.length;
    final myBids = bids.where((bid) => bid.bidderId == myUserId).length;
    final uniqueBidders = bids.map((bid) => bid.bidderId).toSet().length;
    final highestBid = bids.first.amount;
    final lowestBid = bids.last.amount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bidding Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Total Bids',
                    totalBids.toString(),
                    Icons.gavel,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Your Bids',
                    myBids.toString(),
                    Icons.person,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Bidders',
                    uniqueBidders.toString(),
                    Icons.people,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Range',
                    '\$${lowestBid.toStringAsFixed(0)} - \$${highestBid.toStringAsFixed(0)}',
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
