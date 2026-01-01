import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/models/tax_lien_models.dart';
import '../constants/detective_constants.dart';

/// Swipeable property card widget
///
/// Full-screen card with drag gesture support and rotation animation
class SwipeablePropertyCard extends StatefulWidget {
  final TaxLien property;
  final bool isFront;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;

  const SwipeablePropertyCard({
    super.key,
    required this.property,
    this.isFront = true,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
  });

  @override
  State<SwipeablePropertyCard> createState() => _SwipeablePropertyCardState();
}

class _SwipeablePropertyCardState extends State<SwipeablePropertyCard>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  late AnimationController _snapBackController;

  @override
  void initState() {
    super.initState();
    _snapBackController = AnimationController(
      duration: Duration(
        milliseconds: DetectiveConstants.snapBackDuration,
      ),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _snapBackController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.isFront) return;
    setState(() {
      _isDragging = true;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.isFront) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.isFront) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Check if swipe threshold met
    if (_dragOffset.dx.abs() > DetectiveConstants.swipeThreshold) {
      // Horizontal swipe
      if (_dragOffset.dx > 0) {
        _swipeRight();
      } else {
        _swipeLeft();
      }
    } else if (_dragOffset.dy.abs() > DetectiveConstants.swipeThreshold) {
      // Vertical swipe
      if (_dragOffset.dy < 0) {
        _swipeUp();
      } else {
        _swipeDown();
      }
    } else {
      // Snap back
      _snapBack();
    }
  }

  void _swipeLeft() {
    final screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      _dragOffset = Offset(-screenWidth * 2, _dragOffset.dy);
    });
    Future.delayed(
      Duration(milliseconds: DetectiveConstants.swipeOutDuration),
      () {
        widget.onSwipeLeft?.call();
      },
    );
  }

  void _swipeRight() {
    final screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      _dragOffset = Offset(screenWidth * 2, _dragOffset.dy);
    });
    Future.delayed(
      Duration(milliseconds: DetectiveConstants.swipeOutDuration),
      () {
        widget.onSwipeRight?.call();
      },
    );
  }

  void _swipeUp() {
    final screenHeight = MediaQuery.of(context).size.height;
    setState(() {
      _dragOffset = Offset(_dragOffset.dx, -screenHeight * 2);
    });
    Future.delayed(
      Duration(milliseconds: DetectiveConstants.swipeOutDuration),
      () {
        widget.onSwipeUp?.call();
      },
    );
  }

  void _swipeDown() {
    final screenHeight = MediaQuery.of(context).size.height;
    setState(() {
      _dragOffset = Offset(_dragOffset.dx, screenHeight * 2);
    });
    Future.delayed(
      Duration(milliseconds: DetectiveConstants.swipeOutDuration),
      () {
        widget.onSwipeDown?.call();
      },
    );
  }

  void _snapBack() {
    final animation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _snapBackController,
        curve: Curves.elasticOut,
      ),
    );

    animation.addListener(() {
      setState(() {
        _dragOffset = animation.value;
      });
    });

    _snapBackController.forward(from: 0).then((_) {
      setState(() {
        _isDragging = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Calculate rotation based on drag
    final rotation = (_dragOffset.dx / screenSize.width) *
        DetectiveConstants.rotationFactor;
    final clampedRotation =
        rotation.clamp(-DetectiveConstants.maxRotation, DetectiveConstants.maxRotation);

    // Calculate opacity for overlays
    final rightOpacity = (_dragOffset.dx > 0)
        ? (_dragOffset.dx / DetectiveConstants.swipeThreshold).clamp(0.0, 1.0)
        : 0.0;
    final leftOpacity = (_dragOffset.dx < 0)
        ? (-_dragOffset.dx / DetectiveConstants.swipeThreshold).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onPanStart: _handleDragStart,
      onPanUpdate: _handleDragUpdate,
      onPanEnd: _handleDragEnd,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: clampedRotation,
          child: _buildCard(
            context,
            rightOpacity: rightOpacity,
            leftOpacity: leftOpacity,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required double rightOpacity,
    required double leftOpacity,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DetectiveConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DetectiveConstants.cardBorderRadius),
        child: Stack(
          children: [
            // Property image
            _buildPropertyImage(),

            // Gradient overlay
            _buildGradientOverlay(),

            // Property info
            _buildPropertyInfo(),

            // Swipe direction overlays
            if (rightOpacity > 0) _buildSwipeOverlay('LIKE', Colors.green, rightOpacity),
            if (leftOpacity > 0) _buildSwipeOverlay('PASS', Colors.red, leftOpacity),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyImage() {
    if (widget.property.images.isNotEmpty) {
      return Positioned.fill(
        child: Image.network(
          widget.property.images.first,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.home, size: 100, color: Colors.grey),
            );
          },
        ),
      );
    }

    return Positioned.fill(
      child: Container(
        color: Colors.grey[300],
        child: const Icon(Icons.home, size: 100, color: Colors.grey),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
            stops: const [0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyInfo() {
    final roi = ((widget.property.estimatedValue - widget.property.taxAmount) /
            widget.property.taxAmount *
            100)
        .toStringAsFixed(1);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address
            Text(
              widget.property.propertyAddress,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${widget.property.county}, ${widget.property.state}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats row
            Row(
              children: [
                _buildStatChip(
                  icon: Icons.attach_money,
                  label: '\$${widget.property.taxAmount.toStringAsFixed(0)}',
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  icon: Icons.trending_up,
                  label: '$roi% ROI',
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  icon: Icons.percent,
                  label: '${widget.property.interestRate}% APR',
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeOverlay(String text, Color color, double opacity) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 5),
          borderRadius: BorderRadius.circular(DetectiveConstants.cardBorderRadius),
        ),
        child: Center(
          child: Transform.rotate(
            angle: -0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(opacity),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
