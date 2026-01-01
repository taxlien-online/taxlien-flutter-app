# Specifications: Mobile App UI/UX - Component Library & Animations

> Version: 1.0
> Status: DRAFT
> Last Updated: 2025-12-31
> Based on: 01-requirements.md (18 screens)

---

## Table of Contents

1. [Design System](#design-system)
2. [Component Library](#component-library)
3. [Animation Specifications](#animation-specifications)
4. [Screen-Specific Components](#screen-specific-components)
5. [State Management](#state-management)
6. [API Contracts](#api-contracts)
7. [Testing Strategy](#testing-strategy)

---

## Design System

### Color Palette (Expanded)

```dart
// lib/core/theme/app_colors.dart

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1E3A8A);        // Deep Blue
  static const Color primaryLight = Color(0xFF3B82F6);   // Blue
  static const Color primaryDark = Color(0xFF1E40AF);    // Dark Blue

  // Secondary Colors
  static const Color secondary = Color(0xFFF59E0B);      // Gold
  static const Color secondaryLight = Color(0xFFFBBF24); // Light Gold
  static const Color secondaryDark = Color(0xFFD97706);  // Dark Gold

  // Semantic Colors
  static const Color success = Color(0xFF10B981);        // Green
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);        // Amber
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);          // Red
  static const Color errorLight = Color(0xFFF87171);
  static const Color info = Color(0xFF3B82F6);           // Blue
  static const Color infoLight = Color(0xFF60A5FA);

  // Risk Level Colors
  static const Color riskLow = Color(0xFF10B981);        // Green
  static const Color riskMedium = Color(0xFFF59E0B);     // Amber
  static const Color riskHigh = Color(0xFFEF4444);       // Red

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF10B981)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
  );

  // Neutral Colors (Light Mode)
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF9FAFB);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6);
  static const Color lightOnBackground = Color(0xFF111827);
  static const Color lightOnSurface = Color(0xFF374151);
  static const Color lightOnSurfaceVariant = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Neutral Colors (Dark Mode)
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkSurfaceVariant = Color(0xFF374151);
  static const Color darkOnBackground = Color(0xFFF9FAFB);
  static const Color darkOnSurface = Color(0xFFE5E7EB);
  static const Color darkOnSurfaceVariant = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);
}
```

### Typography Scale

```dart
// lib/core/theme/app_text_styles.dart

class AppTextStyles {
  // Font Family
  static const String fontFamily = 'Inter';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700, // Bold
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.3,
    letterSpacing: -0.25,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // Labels
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    height: 1.2,
    letterSpacing: 1.0,
  );

  // Captions
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );
}
```

### Spacing System

```dart
// lib/core/theme/app_spacing.dart

class AppSpacing {
  // Base unit: 8px
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  // Padding presets
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);

  // Horizontal padding
  static const EdgeInsets paddingH_MD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingH_LG = EdgeInsets.symmetric(horizontal: lg);

  // Vertical padding
  static const EdgeInsets paddingV_MD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingV_LG = EdgeInsets.symmetric(vertical: lg);
}
```

### Border Radius

```dart
// lib/core/theme/app_dimensions.dart

class AppDimensions {
  // Border Radius
  static const double radiusSM = 4;
  static const double radiusMD = 8;
  static const double radiusLG = 12;
  static const double radiusXL = 16;
  static const double radiusXXL = 24;
  static const double radiusFull = 999;

  // Border Radius presets
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL = BorderRadius.all(Radius.circular(radiusXXL));

  // Elevation (Shadow)
  static const List<BoxShadow> elevationSM = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> elevationMD = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> elevationLG = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
  ];

  static const List<BoxShadow> elevationXL = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
  ];
}
```

---

## Component Library

### 1. Buttons

#### Primary Button

```dart
// lib/widgets/buttons/primary_button.dart

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppDimensions.borderRadiusLG,
        boxShadow: onPressed != null ? AppDimensions.elevationMD : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppDimensions.borderRadiusLG,
          child: Padding(
            padding: AppSpacing.paddingH_LG,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### Secondary Button (Outlined)

```dart
// lib/widgets/buttons/secondary_button.dart

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1.5),
        borderRadius: AppDimensions.borderRadiusLG,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppDimensions.borderRadiusLG,
          child: Padding(
            padding: AppSpacing.paddingH_LG,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primary, size: 20),
                  SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  text,
                  style: AppTextStyles.button.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 2. Cards

#### Property Card

```dart
// lib/widgets/cards/property_card.dart

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;
  final bool showAIScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusLG),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.borderRadiusLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLG)),
              child: Image.network(
                property.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: AppColors.lightSurfaceVariant,
                  child: Icon(Icons.home, size: 48, color: AppColors.lightOnSurfaceVariant),
                ),
              ),
            ),

            Padding(
              padding: AppSpacing.paddingMD,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address
                  Text(
                    property.address,
                    style: AppTextStyles.h4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.sm),

                  // Key Metrics Row
                  Row(
                    children: [
                      _buildMetric(
                        icon: Icons.attach_money,
                        label: 'Tax',
                        value: '\$${property.taxAmount.toStringAsFixed(0)}',
                      ),
                      SizedBox(width: AppSpacing.lg),
                      _buildMetric(
                        icon: Icons.trending_up,
                        label: 'ROI',
                        value: '${property.roi.toStringAsFixed(1)}%',
                      ),
                      SizedBox(width: AppSpacing.lg),
                      _buildMetric(
                        icon: Icons.warning_rounded,
                        label: 'Risk',
                        value: property.riskLevel,
                        valueColor: _getRiskColor(property.riskScore),
                      ),
                    ],
                  ),

                  if (showAIScore) ...[
                    SizedBox(height: AppSpacing.md),
                    AIScoreBadge(score: property.aiScore),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.lightOnSurfaceVariant),
            SizedBox(width: 4),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Color _getRiskColor(int riskScore) {
    if (riskScore <= 30) return AppColors.riskLow;
    if (riskScore <= 60) return AppColors.riskMedium;
    return AppColors.riskHigh;
  }
}
```

---

### 3. Progress Indicators

#### Linear Progress Bar

```dart
// lib/widgets/progress/linear_progress_bar.dart

class LinearProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String? label;
  final Color? color;
  final double height;

  const LinearProgressBar({
    Key? key,
    required this.value,
    this.label,
    this.color,
    this.height = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? AppColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label!, style: AppTextStyles.bodyMedium),
              Text(
                '${(value * 100).toInt()}%',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [progressColor, progressColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

#### Circular Gauge (Redemption Probability)

```dart
// lib/widgets/charts/circular_gauge.dart

class CircularGauge extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String centerText;
  final String subtitle;
  final double size;
  final Color? color;

  const CircularGauge({
    Key? key,
    required this.value,
    required this.centerText,
    required this.subtitle,
    this.size = 120,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gaugeColor = color ?? AppColors.success;

    return CustomPaint(
      size: Size(size, size),
      painter: _GaugePainter(
        value: value,
        color: gaugeColor,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                centerText,
                style: AppTextStyles.h2.copyWith(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.lightOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.15;

    // Background arc
    final bgPaint = Paint()
      ..color = AppColors.lightSurfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi,
      false,
      bgPaint,
    );

    // Foreground arc (progress)
    final fgPaint = Paint()
      ..shader = SweepGradient(
        colors: [color, color.withOpacity(0.5)],
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + value * 2 * math.pi,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      value * 2 * math.pi,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
```

---

### 4. Badges & Tags

#### AI Score Badge

```dart
// lib/widgets/badges/ai_score_badge.dart

class AIScoreBadge extends StatelessWidget {
  final double score; // 0.0 to 10.0
  final String? reasoning;

  const AIScoreBadge({
    Key? key,
    required this.score,
    this.reasoning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(score);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: AppDimensions.borderRadiusLG,
        boxShadow: AppDimensions.elevationSM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars, color: Colors.white, size: 20),
          SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Score: ${score.toStringAsFixed(1)}/10',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (reasoning != null)
                Text(
                  reasoning!,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return AppColors.success;
    if (score >= 6.0) return AppColors.warning;
    return AppColors.error;
  }
}
```

#### Risk Level Badge

```dart
// lib/widgets/badges/risk_badge.dart

class RiskBadge extends StatelessWidget {
  final int riskScore; // 0 to 100

  @override
  Widget build(BuildContext context) {
    final riskLevel = _getRiskLevel(riskScore);
    final color = _getRiskColor(riskScore);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1.5),
        borderRadius: AppDimensions.borderRadiusSM,
      ),
      child: Text(
        riskLevel.toUpperCase(),
        style: AppTextStyles.label.copyWith(color: color),
      ),
    );
  }

  String _getRiskLevel(int score) {
    if (score <= 30) return 'Low';
    if (score <= 60) return 'Medium';
    return 'High';
  }

  Color _getRiskColor(int score) {
    if (score <= 30) return AppColors.riskLow;
    if (score <= 60) return AppColors.riskMedium;
    return AppColors.riskHigh;
  }
}
```

---

## Animation Specifications

### 1. Screen Transitions

```dart
// lib/core/navigation/page_transitions.dart

class AppPageTransitions {
  // Slide from right (default)
  static Route<T> slideRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  // Fade
  static Route<T> fade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: Duration(milliseconds: 250),
    );
  }

  // Scale (for modals)
  static Route<T> scale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.9;
        const end = 1.0;
        const curve = Curves.easeOutCubic;

        var scaleTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }
}
```

### 2. Swipe Card Animation

```dart
// lib/widgets/swipeable/swipeable_card_stack.dart

class SwipeableCardStack extends StatefulWidget {
  final List<Property> properties;
  final Function(Property, SwipeDirection) onSwipe;

  @override
  _SwipeableCardStackState createState() => _SwipeableCardStackState();
}

class _SwipeableCardStackState extends State<SwipeableCardStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _swipeAnimation;
  late Animation<double> _rotationAnimation;

  Offset _dragPosition = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(_controller);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _isDragging = true;
      _dragPosition += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;

    if (_dragPosition.dx.abs() > threshold) {
      // Trigger swipe
      final direction = _dragPosition.dx > 0 ? SwipeDirection.right : SwipeDirection.left;
      _animateSwipe(direction);
    } else {
      // Return to center
      _animateReturn();
    }
  }

  void _animateSwipe(SwipeDirection direction) {
    final screenWidth = MediaQuery.of(context).size.width;
    final endX = direction == SwipeDirection.right ? screenWidth : -screenWidth;

    _swipeAnimation = Tween<Offset>(
      begin: _dragPosition,
      end: Offset(endX, _dragPosition.dy),
    ).animate(_controller);

    _rotationAnimation = Tween<double>(
      begin: _dragPosition.dx * 0.0005,
      end: direction == SwipeDirection.right ? 0.3 : -0.3,
    ).animate(_controller);

    _controller.forward(from: 0).then((_) {
      widget.onSwipe(widget.properties.first, direction);
      setState(() {
        _dragPosition = Offset.zero;
        _isDragging = false;
      });
      _controller.reset();
    });
  }

  void _animateReturn() {
    _swipeAnimation = Tween<Offset>(
      begin: _dragPosition,
      end: Offset.zero,
    ).animate(_controller);

    _rotationAnimation = Tween<double>(
      begin: _dragPosition.dx * 0.0005,
      end: 0.0,
    ).animate(_controller);

    _controller.forward(from: 0).then((_) {
      setState(() {
        _dragPosition = Offset.zero,
        _isDragging = false;
      });
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          // Next cards (peek)
          if (widget.properties.length > 1)
            _buildCard(widget.properties[1], offset: Offset(0, 8), scale: 0.95),
          if (widget.properties.length > 2)
            _buildCard(widget.properties[2], offset: Offset(0, 16), scale: 0.90),

          // Top card (draggable)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final offset = _isDragging ? _dragPosition : _swipeAnimation.value;
              final rotation = _isDragging
                  ? _dragPosition.dx * 0.0005
                  : _rotationAnimation.value;

              return Transform.translate(
                offset: offset,
                child: Transform.rotate(
                  angle: rotation,
                  child: child,
                ),
              );
            },
            child: PropertyCard(property: widget.properties.first),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Property property, {required Offset offset, required double scale}) {
    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: 0.5,
          child: PropertyCard(property: property),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

enum SwipeDirection { left, right, up, down }
```

### 3. Confetti Animation (Achievement Unlock)

```dart
// lib/widgets/animations/confetti_widget.dart

class ConfettiWidget extends StatefulWidget {
  final bool isActive;

  @override
  _ConfettiWidgetState createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _initializeParticles();

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  void _initializeParticles() {
    final random = math.Random();
    for (var i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(
        x: random.nextDouble(),
        y: -random.nextDouble() * 0.1,
        color: _getRandomColor(random),
        size: random.nextDouble() * 10 + 5,
        rotation: random.nextDouble() * math.pi * 2,
        velocityY: random.nextDouble() * 2 + 1,
        velocityX: (random.nextDouble() - 0.5) * 0.5,
      ));
    }
  }

  Color _getRandomColor(math.Random random) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double rotation;
  final double velocityY;
  final double velocityX;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.rotation,
    required this.velocityY,
    required this.velocityX,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final x = size.width * (particle.x + particle.velocityX * progress);
      final y = size.height * (particle.y + particle.velocityY * progress);

      if (y > size.height) continue; // Off-screen

      final paint = Paint()..color = particle.color.withOpacity(1 - progress);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + progress * math.pi * 4);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size / 2,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

---

## Screen-Specific Components

### Portfolio Simulator Components

#### Virtual Balance Card

```dart
// lib/features/simulator/widgets/virtual_balance_card.dart

class VirtualBalanceCard extends StatelessWidget {
  final double balance;
  final double invested;
  final double profit;
  final int daysPassed;
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    final profitPercentage = invested > 0 ? (profit / invested) * 100 : 0.0;

    return Container(
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppDimensions.borderRadiusXL,
        boxShadow: AppDimensions.elevationMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Virtual Portfolio',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
          SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(
                icon: Icons.account_balance_wallet,
                label: 'Balance',
                value: '\$${balance.toStringAsFixed(0)}',
              ),
              _buildStat(
                icon: Icons.trending_up,
                label: 'Invested',
                value: '\$${invested.toStringAsFixed(0)}',
              ),
              _buildStat(
                icon: Icons.show_chart,
                label: 'Profit',
                value: '\$${profit.toStringAsFixed(0)}',
                valueColor: profit >= 0 ? AppColors.successLight : AppColors.errorLight,
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Day $daysPassed of $totalDays',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
              Spacer(),
              Text(
                profitPercentage >= 0 ? '+${profitPercentage.toStringAsFixed(1)}%' : '${profitPercentage.toStringAsFixed(1)}%',
                style: AppTextStyles.h4.copyWith(
                  color: profit >= 0 ? AppColors.successLight : AppColors.errorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            SizedBox(width: 4),
            Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.h3.copyWith(color: valueColor ?? Colors.white),
        ),
      ],
    );
  }
}
```

---

### Risk Radar Components

#### Radar Chart Widget

```dart
// lib/widgets/charts/radar_chart.dart

class RadarChart extends StatelessWidget {
  final Map<String, double> data; // e.g., {"Legal": 0.4, "Financial": 0.6, ...}
  final double size;

  const RadarChart({
    Key? key,
    required this.data,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RadarChartPainter(data: data),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final Map<String, double> data;

  _RadarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;
    final numPoints = data.length;

    // Draw background grid (pentagon/hexagon)
    _drawBackgroundGrid(canvas, center, radius, numPoints);

    // Draw data polygon
    _drawDataPolygon(canvas, center, radius, numPoints);

    // Draw labels
    _drawLabels(canvas, center, radius, numPoints);
  }

  void _drawBackgroundGrid(Canvas canvas, Offset center, double radius, int numPoints) {
    final gridPaint = Paint()
      ..color = AppColors.lightBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw concentric polygons (20%, 40%, 60%, 80%, 100%)
    for (var i = 1; i <= 5; i++) {
      final r = radius * (i / 5);
      final path = Path();

      for (var j = 0; j < numPoints; j++) {
        final angle = (j / numPoints) * 2 * math.pi - math.pi / 2;
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);

        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw radial lines
    for (var i = 0; i < numPoints; i++) {
      final angle = (i / numPoints) * 2 * math.pi - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }
  }

  void _drawDataPolygon(Canvas canvas, Offset center, double radius, int numPoints) {
    final dataPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final values = data.values.toList();

    for (var i = 0; i < numPoints; i++) {
      final angle = (i / numPoints) * 2 * math.pi - math.pi / 2;
      final r = radius * values[i];
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, dataPaint);
    canvas.drawPath(path, borderPaint);

    // Draw dots on vertices
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    for (var i = 0; i < numPoints; i++) {
      final angle = (i / numPoints) * 2 * math.pi - math.pi / 2;
      final r = radius * values[i];
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius, int numPoints) {
    final keys = data.keys.toList();
    final values = data.values.toList();

    for (var i = 0; i < numPoints; i++) {
      final angle = (i / numPoints) * 2 * math.pi - math.pi / 2;
      final labelRadius = radius + 20;
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${keys[i]}\n${(values[i] * 100).toInt()}%',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(_RadarChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
```

---

## State Management

Using **flutter_bloc** for state management.

### Example: Simulator BLoC

```dart
// lib/features/simulator/bloc/simulator_bloc.dart

abstract class SimulatorEvent {}

class StartSimulation extends SimulatorEvent {
  final double initialBalance;
}

class InvestInProperty extends SimulatorEvent {
  final Property property;
  final double amount;
}

class FastForward extends SimulatorEvent {
  final int days;
}

class ResetSimulation extends SimulatorEvent {}

// ─────────────────────────────────

abstract class SimulatorState {}

class SimulatorInitial extends SimulatorState {}

class SimulatorActive extends SimulatorState {
  final double balance;
  final double invested;
  final double profit;
  final int daysPassed;
  final List<SimulatorInvestment> investments;

  SimulatorActive({
    required this.balance,
    required this.invested,
    required this.profit,
    required this.daysPassed,
    required this.investments,
  });
}

// ─────────────────────────────────

class SimulatorBloc extends Bloc<SimulatorEvent, SimulatorState> {
  final SimulatorRepository repository;

  SimulatorBloc({required this.repository}) : super(SimulatorInitial()) {
    on<StartSimulation>(_onStart);
    on<InvestInProperty>(_onInvest);
    on<FastForward>(_onFastForward);
    on<ResetSimulation>(_onReset);
  }

  void _onStart(StartSimulation event, Emitter<SimulatorState> emit) {
    emit(SimulatorActive(
      balance: event.initialBalance,
      invested: 0,
      profit: 0,
      daysPassed: 0,
      investments: [],
    ));
  }

  void _onInvest(InvestInProperty event, Emitter<SimulatorState> emit) {
    if (state is! SimulatorActive) return;
    final current = state as SimulatorActive;

    if (current.balance < event.amount) {
      // Insufficient balance
      return;
    }

    final investment = SimulatorInvestment(
      property: event.property,
      amount: event.amount,
      purchaseDay: current.daysPassed,
    );

    emit(SimulatorActive(
      balance: current.balance - event.amount,
      invested: current.invested + event.amount,
      profit: current.profit,
      daysPassed: current.daysPassed,
      investments: [...current.investments, investment],
    ));
  }

  Future<void> _onFastForward(FastForward event, Emitter<SimulatorState> emit) async {
    if (state is! SimulatorActive) return;
    final current = state as SimulatorActive;

    final newDaysPassed = current.daysPassed + event.days;
    double newBalance = current.balance;
    double newProfit = current.profit;
    List<SimulatorInvestment> updatedInvestments = [];

    for (var investment in current.investments) {
      final daysElapsed = newDaysPassed - investment.purchaseDay;
      final outcome = await repository.simulateOutcome(investment.property, daysElapsed);

      if (outcome.isRedeemed) {
        // Redemption occurred
        newBalance += outcome.returnAmount;
        newProfit += (outcome.returnAmount - investment.amount);
        updatedInvestments.add(investment.copyWith(status: 'redeemed'));
      } else if (outcome.isForeclosed) {
        // Foreclosure occurred
        updatedInvestments.add(investment.copyWith(status: 'foreclosed'));
      } else {
        // Still pending
        updatedInvestments.add(investment);
      }
    }

    emit(SimulatorActive(
      balance: newBalance,
      invested: current.invested,
      profit: newProfit,
      daysPassed: newDaysPassed,
      investments: updatedInvestments,
    ));
  }

  void _onReset(ResetSimulation event, Emitter<SimulatorState> emit) {
    emit(SimulatorInitial());
  }
}
```

---

## API Contracts

### ML Service (AI Scoring)

```dart
// lib/services/ml_service/ml_api.dart

class MLService {
  final Dio _dio;

  MLService({required String baseUrl})
      : _dio = Dio(BaseOptions(baseURL: baseUrl));

  /// Get AI prediction for a property
  Future<AIPrediction> predictRedemption(String propertyId) async {
    final response = await _dio.post('/predict/redemption', data: {
      'property_id': propertyId,
    });

    return AIPrediction.fromJson(response.data);
  }

  /// Get AI score (0-10) for swipe UI
  Future<AIScore> scoreProperty(Property property) async {
    final response = await _dio.post('/score/property', data: property.toJson());
    return AIScore.fromJson(response.data);
  }
}

class AIPrediction {
  final double redemptionProbability; // 0.0 to 1.0
  final int riskScore; // 0 to 100
  final double expectedROI;
  final Map<String, double> featureImportance;
  final String recommendation; // "BUY" or "AVOID"
  final double confidence; // 0.0 to 1.0

  AIPrediction({
    required this.redemptionProbability,
    required this.riskScore,
    required this.expectedROI,
    required this.featureImportance,
    required this.recommendation,
    required this.confidence,
  });

  factory AIPrediction.fromJson(Map<String, dynamic> json) {
    return AIPrediction(
      redemptionProbability: json['redemption_probability'],
      riskScore: json['risk_score'],
      expectedROI: json['expected_roi'],
      featureImportance: Map<String, double>.from(json['feature_importance']),
      recommendation: json['recommendation'],
      confidence: json['confidence'],
    );
  }
}

class AIScore {
  final double score; // 0.0 to 10.0
  final String reasoning;

  AIScore({required this.score, required this.reasoning});

  factory AIScore.fromJson(Map<String, dynamic> json) {
    return AIScore(
      score: json['score'],
      reasoning: json['reasoning'],
    );
  }
}
```

### Alert Service (Smart Alerts)

```dart
// lib/services/alert_service/alert_api.dart

class AlertService {
  final Dio _dio;

  /// Create a new alert
  Future<Alert> createAlert(AlertCriteria criteria) async {
    final response = await _dio.post('/alerts', data: criteria.toJson());
    return Alert.fromJson(response.data);
  }

  /// Get matches for an alert
  Future<List<PropertyMatch>> getMatches(String alertId) async {
    final response = await _dio.get('/alerts/$alertId/matches');
    return (response.data as List).map((e) => PropertyMatch.fromJson(e)).toList();
  }
}

class AlertCriteria {
  final String? location; // e.g., "Phoenix, AZ"
  final double? minROI;
  final double? maxROI;
  final double? minPrice;
  final double? maxPrice;
  final String? propertyType; // "residential", "commercial", etc.
  final String? riskLevel; // "low", "medium", "high"

  AlertCriteria({
    this.location,
    this.minROI,
    this.maxROI,
    this.minPrice,
    this.maxPrice,
    this.propertyType,
    this.riskLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      if (location != null) 'location': location,
      if (minROI != null) 'min_roi': minROI,
      if (maxROI != null) 'max_roi': maxROI,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (propertyType != null) 'property_type': propertyType,
      if (riskLevel != null) 'risk_level': riskLevel,
    };
  }
}

class PropertyMatch {
  final Property property;
  final double matchScore; // 0.0 to 10.0
  final List<String> matchReasons;
  final DateTime matchedAt;

  PropertyMatch({
    required this.property,
    required this.matchScore,
    required this.matchReasons,
    required this.matchedAt,
  });

  factory PropertyMatch.fromJson(Map<String, dynamic> json) {
    return PropertyMatch(
      property: Property.fromJson(json['property']),
      matchScore: json['match_score'],
      matchReasons: List<String>.from(json['match_reasons']),
      matchedAt: DateTime.parse(json['matched_at']),
    );
  }
}
```

---

## Testing Strategy

### Unit Tests (Widgets)

```dart
// test/widgets/buttons/primary_button_test.dart

void main() {
  group('PrimaryButton', () {
    testWidgets('renders text correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Click Me'),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Click Me', isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Click Me'), findsNothing);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(tapped, true);
    });
  });
}
```

### Integration Tests (Flows)

```dart
// integration_test/simulator_flow_test.dart

void main() {
  group('Simulator Flow', () {
    testWidgets('complete simulation from start to profit', (tester) async {
      await tester.pumpWidget(MyApp());

      // Navigate to simulator
      await tester.tap(find.text('Practice Mode'));
      await tester.pumpAndSettle();

      // Verify initial balance
      expect(find.text('\$10,000'), findsOneWidget);

      // Browse properties and invest
      await tester.tap(find.text('Browse More Properties'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(PropertyCard).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Invest \$2,500'));
      await tester.pumpAndSettle();

      // Verify investment was made
      expect(find.text('\$7,500'), findsOneWidget); // Updated balance
      expect(find.text('Invested: \$2,500'), findsOneWidget);

      // Fast forward
      await tester.tap(find.text('Fast Forward 30 Days'));
      await tester.pumpAndSettle();

      // Verify time advanced
      expect(find.text('Day 30 of 730'), findsOneWidget);
    });
  });
}
```

---

## Accessibility

### VoiceOver Support

```dart
// lib/widgets/buttons/primary_button.dart

Semantics(
  label: text,
  button: true,
  enabled: onPressed != null && !isLoading,
  child: Container(
    // ... button implementation
  ),
)
```

### Dynamic Type Support

```dart
// Use MediaQuery.of(context).textScaleFactor
Text(
  'Sample Text',
  style: AppTextStyles.bodyMedium.copyWith(
    fontSize: 14 * MediaQuery.of(context).textScaleFactor,
  ),
)
```

---

## Performance Optimizations

### Image Caching

```dart
// lib/widgets/images/cached_network_image.dart

CachedNetworkImage(
  imageUrl: property.imageUrl,
  placeholder: (context, url) => Shimmer.fromColors(
    baseColor: AppColors.lightSurfaceVariant,
    highlightColor: AppColors.lightSurface,
    child: Container(color: Colors.white),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 800, // Resize to avoid memory bloat
)
```

### List Performance (Lazy Loading)

```dart
ListView.builder(
  itemCount: properties.length,
  itemBuilder: (context, index) {
    return PropertyCard(property: properties[index]);
  },
  cacheExtent: 1000, // Preload items
)
```

---

**Status:** SPECIFICATIONS DRAFT ✅
**Next Phase:** PLAN (Task breakdown, file structure)
**Timeline:** Ready for implementation after approval
