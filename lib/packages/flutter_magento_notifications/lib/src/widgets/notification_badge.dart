import 'package:flutter/material.dart';
import '../models/notification_models.dart';
import '../models/notification_types.dart';

/// Widget for displaying notification badge with count
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
    required this.count,
    this.child,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.minValue = 1,
    this.maxValue = 99,
    this.showZero = false,
    this.size = 20,
    this.fontSize = 12,
    this.borderRadius = 10,
  });

  final int count;
  final Widget? child;
  final Color color;
  final Color textColor;
  final int minValue;
  final int maxValue;
  final bool showZero;
  final double size;
  final double fontSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final shouldShow = showZero ? count >= 0 : count >= minValue;

    if (!shouldShow) {
      return child ?? const SizedBox.shrink();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (child != null) child!,
        Positioned(
          right: -size / 2,
          top: -size / 2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            constraints: BoxConstraints(minWidth: size, minHeight: size),
            child: Center(
              child: Text(
                _getDisplayText(),
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getDisplayText() {
    if (count > maxValue) {
      return '${maxValue}+';
    }
    return count.toString();
  }
}

/// Widget for displaying notification badge with icon
class NotificationIconBadge extends StatelessWidget {
  const NotificationIconBadge({
    super.key,
    required this.count,
    required this.icon,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.minValue = 1,
    this.maxValue = 99,
    this.showZero = false,
    this.size = 24,
    this.fontSize = 12,
    this.borderRadius = 12,
    this.onTap,
  });

  final int count;
  final IconData icon;
  final Color color;
  final Color textColor;
  final int minValue;
  final int maxValue;
  final bool showZero;
  final double size;
  final double fontSize;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shouldShow = showZero ? count >= 0 : count >= minValue;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(
            icon,
            size: size,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (shouldShow)
          Positioned(
            right: -size / 2,
            top: -size / 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              constraints: BoxConstraints(
                minWidth: size * 0.6,
                minHeight: size * 0.6,
              ),
              child: Center(
                child: Text(
                  _getDisplayText(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getDisplayText() {
    if (count > maxValue) {
      return '${maxValue}+';
    }
    return count.toString();
  }
}

/// Widget for displaying notification badge with type-specific styling
class TypedNotificationBadge extends StatelessWidget {
  const TypedNotificationBadge({
    super.key,
    required this.count,
    required this.type,
    this.child,
    this.minValue = 1,
    this.maxValue = 99,
    this.showZero = false,
    this.size = 20,
    this.fontSize = 12,
    this.borderRadius = 10,
  });

  final int count;
  final MagentoNotificationType type;
  final Widget? child;
  final int minValue;
  final int maxValue;
  final bool showZero;
  final double size;
  final double fontSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final color = Color(type.colorValue);
    final textColor = _getTextColor(color);

    return NotificationBadge(
      count: count,
      child: child,
      color: color,
      textColor: textColor,
      minValue: minValue,
      maxValue: maxValue,
      showZero: showZero,
      size: size,
      fontSize: fontSize,
      borderRadius: borderRadius,
    );
  }

  Color _getTextColor(Color backgroundColor) {
    // Calculate luminance to determine if text should be light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Widget for displaying notification badge with priority-specific styling
class PriorityNotificationBadge extends StatelessWidget {
  const PriorityNotificationBadge({
    super.key,
    required this.count,
    required this.priority,
    this.child,
    this.minValue = 1,
    this.maxValue = 99,
    this.showZero = false,
    this.size = 20,
    this.fontSize = 12,
    this.borderRadius = 10,
  });

  final int count;
  final MagentoNotificationPriority priority;
  final Widget? child;
  final int minValue;
  final int maxValue;
  final bool showZero;
  final double size;
  final double fontSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority);
    final textColor = _getTextColor(color);

    return NotificationBadge(
      count: count,
      child: child,
      color: color,
      textColor: textColor,
      minValue: minValue,
      maxValue: maxValue,
      showZero: showZero,
      size: size,
      fontSize: fontSize,
      borderRadius: borderRadius,
    );
  }

  Color _getPriorityColor(MagentoNotificationPriority priority) {
    switch (priority) {
      case MagentoNotificationPriority.low:
        return Colors.grey;
      case MagentoNotificationPriority.normal:
        return Colors.blue;
      case MagentoNotificationPriority.high:
        return Colors.orange;
      case MagentoNotificationPriority.critical:
        return Colors.red;
    }
  }

  Color _getTextColor(Color backgroundColor) {
    // Calculate luminance to determine if text should be light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Widget for displaying notification badge with animation
class AnimatedNotificationBadge extends StatefulWidget {
  const AnimatedNotificationBadge({
    super.key,
    required this.count,
    this.child,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.minValue = 1,
    this.maxValue = 99,
    this.showZero = false,
    this.size = 20,
    this.fontSize = 12,
    this.borderRadius = 10,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final int count;
  final Widget? child;
  final Color color;
  final Color textColor;
  final int minValue;
  final int maxValue;
  final bool showZero;
  final double size;
  final double fontSize;
  final double borderRadius;
  final Duration animationDuration;

  @override
  State<AnimatedNotificationBadge> createState() =>
      _AnimatedNotificationBadgeState();
}

class _AnimatedNotificationBadgeState extends State<AnimatedNotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _previousCount = widget.count;
  }

  @override
  void didUpdateWidget(AnimatedNotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count && widget.count > _previousCount) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
    _previousCount = widget.count;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: NotificationBadge(
            count: widget.count,
            child: widget.child,
            color: widget.color,
            textColor: widget.textColor,
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            showZero: widget.showZero,
            size: widget.size,
            fontSize: widget.fontSize,
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}

/// Widget for displaying notification badge with pulse animation
class PulsingNotificationBadge extends StatefulWidget {
  const PulsingNotificationBadge({
    super.key,
    required this.count,
    this.child,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.minValue = 1,
    this.maxValue = 99,
    this.showZero = false,
    this.size = 20,
    this.fontSize = 12,
    this.borderRadius = 10,
    this.pulseDuration = const Duration(seconds: 2),
  });

  final int count;
  final Widget? child;
  final Color color;
  final Color textColor;
  final int minValue;
  final int maxValue;
  final bool showZero;
  final double size;
  final double fontSize;
  final double borderRadius;
  final Duration pulseDuration;

  @override
  State<PulsingNotificationBadge> createState() =>
      _PulsingNotificationBadgeState();
}

class _PulsingNotificationBadgeState extends State<PulsingNotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start pulsing if count is above minimum
    if (widget.count >= widget.minValue) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsingNotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count >= widget.minValue && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (widget.count < widget.minValue &&
        _animationController.isAnimating) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseAnimation.value,
          child: NotificationBadge(
            count: widget.count,
            child: widget.child,
            color: widget.color,
            textColor: widget.textColor,
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            showZero: widget.showZero,
            size: widget.size,
            fontSize: widget.fontSize,
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}
