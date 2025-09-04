import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BidInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double currentHighestBid;
  final bool isPlacingBid;
  final Function(double) onBidPlaced;
  final Function(double) onQuickBid;

  const BidInputWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.currentHighestBid,
    required this.isPlacingBid,
    required this.onBidPlaced,
    required this.onQuickBid,
  }) : super(key: key);

  @override
  State<BidInputWidget> createState() => _BidInputWidgetState();
}

class _BidInputWidgetState extends State<BidInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  final List<double> _quickBidAmounts = [];
  String? _bidError;

  @override
  void initState() {
    super.initState();
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
    
    _updateQuickBidAmounts();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _updateQuickBidAmounts() {
    final minBid = widget.currentHighestBid + 100;
    _quickBidAmounts.clear();
    
    // Generate quick bid amounts
    _quickBidAmounts.addAll([
      minBid,
      minBid + 500,
      minBid + 1000,
      minBid + 2500,
      minBid + 5000,
    ]);
  }

  @override
  void didUpdateWidget(BidInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentHighestBid != widget.currentHighestBid) {
      _updateQuickBidAmounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Quick bid buttons
        _buildQuickBidButtons(),
        
        const SizedBox(height: 16),
        
        // Bid input field
        _buildBidInputField(),
        
        const SizedBox(height: 16),
        
        // Place bid button
        _buildPlaceBidButton(),
      ],
    );
  }

  Widget _buildQuickBidButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Bid',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickBidAmounts.map((amount) {
            return _buildQuickBidButton(amount);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickBidButton(double amount) {
    final isMinimumBid = amount == _quickBidAmounts.first;
    
    return Material(
      color: isMinimumBid
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: widget.isPlacingBid ? null : () => widget.onQuickBid(amount),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isMinimumBid
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Text(
            '\$${amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isMinimumBid
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: isMinimumBid ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBidInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Bid Amount',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                enabled: !widget.isPlacingBid,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: 'Enter bid amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 2,
                    ),
                  ),
                  suffixIcon: widget.isPlacingBid
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          onPressed: _clearBid,
                          icon: const Icon(Icons.clear),
                        ),
                ),
                onSubmitted: (value) => _submitBid(),
              ),
            );
          },
        ),
        if (_bidError != null) ...[
          const SizedBox(height: 8),
          Text(
            _bidError!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceBidButton() {
    final bidAmount = double.tryParse(widget.controller.text);
    final isValidBid = bidAmount != null && bidAmount > widget.currentHighestBid;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: (widget.isPlacingBid || !isValidBid) ? null : _submitBid,
        icon: widget.isPlacingBid
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.gavel),
        label: Text(
          widget.isPlacingBid
              ? 'Placing Bid...'
              : 'Place Bid',
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _submitBid() {
    final bidAmount = double.tryParse(widget.controller.text);
    
    if (bidAmount == null) {
      _showError('Please enter a valid bid amount');
      return;
    }
    
    if (bidAmount <= widget.currentHighestBid) {
      _showError('Bid must be higher than \$${widget.currentHighestBid.toStringAsFixed(2)}');
      return;
    }
    
    if (bidAmount < 100) {
      _showError('Minimum bid amount is \$100');
      return;
    }
    
    _clearError();
    widget.onBidPlaced(bidAmount);
  }

  void _clearBid() {
    widget.controller.clear();
    _clearError();
  }

  void _showError(String error) {
    setState(() {
      _bidError = error;
    });
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  void _clearError() {
    setState(() {
      _bidError = null;
    });
  }
}

class BidValidationWidget extends StatelessWidget {
  final double bidAmount;
  final double currentHighestBid;
  final double minimumBid;

  const BidValidationWidget({
    Key? key,
    required this.bidAmount,
    required this.currentHighestBid,
    required this.minimumBid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validation = _validateBid();
    
    if (validation == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: validation.isValid
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: validation.isValid
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
        ),
      ),
      child: Row(
        children: [
          Icon(
            validation.isValid ? Icons.check_circle : Icons.error,
            color: validation.isValid
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              validation.message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: validation.isValid
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BidValidation? _validateBid() {
    if (bidAmount <= 0) return null;
    
    if (bidAmount < minimumBid) {
      return BidValidation(
        isValid: false,
        message: 'Bid must be at least \$${minimumBid.toStringAsFixed(2)}',
      );
    }
    
    if (bidAmount <= currentHighestBid) {
      return BidValidation(
        isValid: false,
        message: 'Bid must be higher than current highest bid',
      );
    }
    
    final increment = bidAmount - currentHighestBid;
    if (increment < 100) {
      return BidValidation(
        isValid: false,
        message: 'Minimum bid increment is \$100',
      );
    }
    
    return BidValidation(
      isValid: true,
      message: 'Valid bid amount',
    );
  }
}

class BidValidation {
  final bool isValid;
  final String message;

  const BidValidation({
    required this.isValid,
    required this.message,
  });
}
