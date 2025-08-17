import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradients for TaxLien.online application
/// Based on deep blue tones with accents of freedom and spirituality
/// Support light and dark themes
class AppGradients {
  // Private constructor to prevent instantiation
  AppGradients._();

  /// Main background gradient (light theme)
  static const LinearGradient lightBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.lightBackgroundPrimary,
      AppColors.lightBackgroundSecondary,
    ],
  );

  /// Main background gradient (dark theme)
  static const LinearGradient darkBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.darkBackgroundPrimary,
      AppColors.darkBackgroundSecondary,
    ],
  );

  /// Card gradient (light theme)
  static const LinearGradient lightCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.lightCardBackground,
      AppColors.lightCardBackgroundSecondary,
    ],
  );

  /// Card gradient (dark theme)
  static const LinearGradient darkCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.darkCardBackground,
      AppColors.darkCardBackgroundSecondary,
    ],
  );

  /// Button gradient
  static const LinearGradient button = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.primary,
      AppColors.accent,
    ],
  );

  /// Progress bar gradient
  static const LinearGradient progress = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.accent,
      AppColors.accentLight,
    ],
  );

  /// Calibration gradient
  static const LinearGradient calibration = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.spiritual,
    ],
  );

  /// Scanner gradient
  static const LinearGradient scanner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.info,
      AppColors.primary,
    ],
  );

  /// Control gradient
  static const LinearGradient control = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.primaryLight,
    ],
  );

  /// Monitoring gradient
  static const LinearGradient monitoring = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accent,
      AppColors.success,
    ],
  );

  /// Profile gradient
  static const LinearGradient profile = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.spiritual,
      AppColors.spiritualLight,
    ],
  );

  /// Connection gradient
  static const LinearGradient connection = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.accent,
    ],
  );

  /// FreeDome status gradient
  static const LinearGradient freedomeStatus = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.freedomeConnected,
      AppColors.accent,
    ],
  );

  /// Freedom gradient
  static const LinearGradient freedom = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.accent,
    ],
  );

  /// Spiritual gradient
  static const LinearGradient spiritual = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.spiritual,
      AppColors.spiritualLight,
    ],
  );

  /// Success gradient
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.success,
      AppColors.accentLight,
    ],
  );

  /// Warning gradient
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.warning,
      AppColors.accent,
    ],
  );

  /// Error gradient
  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.error,
      AppColors.primary,
    ],
  );

  /// Methods for getting gradients based on theme
  static LinearGradient getBackground(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }

  static LinearGradient getCard(Brightness brightness) {
    return brightness == Brightness.light ? lightCard : darkCard;
  }

  /// Method for creating custom gradient
  static LinearGradient custom({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
      tileMode: tileMode,
      transform: transform,
    );
  }

  /// Method for creating radial gradient
  static RadialGradient radial({
    required List<Color> colors,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    return RadialGradient(
      colors: colors,
      center: center,
      radius: radius,
      stops: stops,
      tileMode: tileMode,
      transform: transform,
    );
  }
} 