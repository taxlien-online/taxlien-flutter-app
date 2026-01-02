import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/models/tax_lien_models.dart';
import '../../../services/tax_lien_service.dart';
import '../widgets/swipeable_property_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/match_notification_modal.dart';
import '../widgets/share_property_sheet.dart';
import '../widgets/detective_tutorial.dart';
import '../screens/detective_preferences_screen.dart';
import '../constants/detective_constants.dart';
import '../services/match_service.dart';
import '../services/daily_limit_service.dart';
import '../models/user_preferences.dart';

/// Deal Detective Screen
///
/// Tinder-style swipe interface for property discovery
class DealDetectiveScreen extends StatefulWidget {
  final String? userId;
  final bool isPremium;

  const DealDetectiveScreen({
    super.key,
    this.userId,
    this.isPremium = false,
  });

  @override
  State<DealDetectiveScreen> createState() => _DealDetectiveScreenState();
}

class _DealDetectiveScreenState extends State<DealDetectiveScreen> {
  final List<TaxLien> _cardStack = [];
  final List<TaxLien> _swipeHistory = [];
  int _currentIndex = 0;
  int _swipeCount = 0;
  bool _isLoading = true;
  String? _error;
  UserPreferences _preferences = UserPreferences.defaults;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadProperties();
    _showTutorialIfNeeded();
  }

  Future<void> _loadPreferences() async {
    // Load user preferences from storage
    // For now, using defaults
    setState(() {
      _preferences = UserPreferences.defaults;
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      await DetectiveTutorial.showIfNeeded(context);
    }
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual service call
      // For now, using mock data
      final taxLienService = TaxLienService();
      final properties = await taxLienService.searchLiens();

      setState(() {
        _cardStack.addAll(properties);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = DetectiveConstants.errorNetworkFailure;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProperties() async {
    // Load next batch when running low
    if (_cardStack.length - _currentIndex < 3) {
      try {
        final taxLienService = TaxLienService();
        final moreProperties = await taxLienService.searchLiens();
        setState(() {
          _cardStack.addAll(moreProperties);
        });
      } catch (e) {
        // Silently fail for prefetch
        debugPrint('Failed to load more properties: $e');
      }
    }
  }

  void _handleSwipeLeft() {
    _recordSwipe(DetectiveConstants.swipeLeft);
    _moveToNextCard();
  }

  void _handleSwipeRight() async {
    _recordSwipe(DetectiveConstants.swipeRight);

    // Check for match
    final property = _cardStack[_currentIndex];
    final matchService = MatchService.instance;
    final isMatch = matchService.isMatch(
      property: property,
      preferences: _preferences,
    );

    if (isMatch && widget.userId != null) {
      final match = matchService.createMatch(
        userId: widget.userId!,
        property: property,
        preferences: _preferences,
      );

      // Show match notification after card animates away
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          MatchNotificationModal.show(
            context: context,
            match: match,
            onViewProperty: () {
              // TODO: Navigate to property detail
              debugPrint('View property: ${property.id}');
            },
          );
        }
      });
    }

    _moveToNextCard();
  }

  void _handleSwipeUp() {
    _recordSwipe(DetectiveConstants.swipeUp);
    _moveToNextCard();
    _showWatchlistConfirmation();
  }

  void _handleSwipeDown() {
    _recordSwipe(DetectiveConstants.swipeDown);
    _moveToNextCard();
  }

  void _recordSwipe(String direction) async {
    // Increment daily limit counter
    await DailyLimitService.instance.incrementSwipeCount();

    _swipeCount++;

    // Check daily limit for free users
    final canSwipe = await DailyLimitService.instance.canSwipe(
      isPremium: widget.isPremium,
    );

    if (!canSwipe) {
      _showLimitReachedDialog();
      return;
    }

    // Add to history for undo
    if (_currentIndex < _cardStack.length) {
      _swipeHistory.add(_cardStack[_currentIndex]);
    }

    // TODO: Send to backend
    // _swipeService.recordSwipe(propertyId, direction);

    // Check if approaching limit and show warning
    final warning = await DailyLimitService.instance.getLimitWarning(
      isPremium: widget.isPremium,
    );
    if (warning != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(warning),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _moveToNextCard() {
    setState(() {
      _currentIndex++;
    });

    // Load more if needed
    if (_cardStack.length - _currentIndex < DetectiveConstants.prefetchCount) {
      _loadMoreProperties();
    }

    // Check if out of cards
    if (_currentIndex >= _cardStack.length) {
      _showNoMoreCardsDialog();
    }
  }

  void _handleUndo() async {
    if (_swipeHistory.isEmpty) return;

    // Check undo limit for free users
    final canUndo = await DailyLimitService.instance.canUndo(
      isPremium: widget.isPremium,
    );

    if (!canUndo) {
      _showUpgradeDialog('Undo limit reached');
      return;
    }

    // Increment undo counter
    await DailyLimitService.instance.incrementUndoCount();
    await DailyLimitService.instance.decrementSwipeCount();

    setState(() {
      _currentIndex--;
      _swipeHistory.removeLast();
      _swipeCount--;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(DetectiveConstants.successUndo),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showWatchlistConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(DetectiveConstants.successAddedToWatchlist),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLimitReachedDialog() async {
    final timeUntilReset = await DailyLimitService.instance.getTimeUntilResetFormatted();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Limit Reached'),
        content: Text(
          '${DetectiveConstants.errorDailyLimitReached}\n\nResets in: $timeUntilReset',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to paywall
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  void _showNoMoreCardsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No More Properties'),
        content: const Text(DetectiveConstants.errorNoMoreCards),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _swipeCount = 0;
                _swipeHistory.clear();
              });
              _loadProperties();
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(String reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: Text(reason),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to paywall
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  void _openPreferences() async {
    final result = await Navigator.push<UserPreferences>(
      context,
      MaterialPageRoute(
        builder: (context) => DetectivePreferencesScreen(
          initialPreferences: _preferences,
          onSave: (prefs) {
            setState(() {
              _preferences = prefs;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _preferences = result;
      });
    }
  }

  void _shareCurrentProperty() {
    if (_currentIndex < _cardStack.length) {
      final property = _cardStack[_currentIndex];
      SharePropertySheet.show(
        context: context,
        property: property,
        referralCode: widget.userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deal Detective'),
        actions: [
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareCurrentProperty,
          ),
          // Preferences button
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _openPreferences,
          ),
          // Swipe counter
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '$_swipeCount/${widget.isPremium ? '∞' : DetectiveConstants.freeDailySwipeLimit}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : _buildCardStack(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProperties,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    if (_currentIndex >= _cardStack.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'No more properties!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Check back later for new listings'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                  _swipeCount = 0;
                  _swipeHistory.clear();
                });
                _loadProperties();
              },
              child: const Text('Start Over'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Card stack (show up to 3 cards)
        ...List.generate(
          math.min(DetectiveConstants.visibleCardCount,
              _cardStack.length - _currentIndex),
          (index) {
            final cardIndex = _currentIndex + index;
            final property = _cardStack[cardIndex];
            final isFront = index == 0;

            return Positioned.fill(
              top: index * DetectiveConstants.cardVerticalOffset,
              child: Center(
                child: Transform.scale(
                  scale: 1.0 -
                      (index * DetectiveConstants.cardScaleDecrement),
                  child: SwipeablePropertyCard(
                    property: property,
                    isFront: isFront,
                    onSwipeLeft: isFront ? _handleSwipeLeft : null,
                    onSwipeRight: isFront ? _handleSwipeRight : null,
                    onSwipeUp: isFront ? _handleSwipeUp : null,
                    onSwipeDown: isFront ? _handleSwipeDown : null,
                  ),
                ),
              ),
            );
          },
        ).reversed.toList(),

        // Action buttons at bottom
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: ActionButtons(
            onPass: _handleSwipeLeft,
            onLike: _handleSwipeRight,
            onSuperLike: _handleSwipeUp,
            onUndo: _swipeHistory.isNotEmpty ? _handleUndo : null,
          ),
        ),
      ],
    );
  }
}
