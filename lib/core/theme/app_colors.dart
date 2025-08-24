import 'package:flutter/material.dart';

/// Modern color scheme for TaxLien.online
/// Based on the vision of the team with spiritual and freedom-oriented colors
class AppColors {
  // Private constructor
  AppColors._();

  // Primary Colors - Deep Blue representing trust and stability
  static const Color primary = Color(0xFF1E3A8A); // Deep Blue
  static const Color primaryLight = Color(0xFF3B82F6); // Blue
  static const Color primaryDark = Color(0xFF1E40AF); // Darker Blue
  static const Color onPrimary = Color(0xFFFFFFFF); // White

  // Secondary Colors - Gold representing wealth and prosperity
  static const Color secondary = Color(0xFFF59E0B); // Amber
  static const Color secondaryLight = Color(0xFFFBBF24); // Light Amber
  static const Color secondaryDark = Color(0xFFD97706); // Dark Amber
  static const Color onSecondary = Color(0xFF000000); // Black

  // Success Colors - Green representing growth and success
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color successLight = Color(0xFF34D399); // Light Emerald
  static const Color successDark = Color(0xFF059669); // Dark Emerald
  static const Color onSuccess = Color(0xFFFFFFFF); // White

  // Warning Colors - Orange representing caution
  static const Color warning = Color(0xFFF97316); // Orange
  static const Color warningLight = Color(0xFFFB923C); // Light Orange
  static const Color warningDark = Color(0xFFEA580C); // Dark Orange
  static const Color onWarning = Color(0xFFFFFFFF); // White

  // Error Colors - Red representing danger
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFF87171); // Light Red
  static const Color errorDark = Color(0xFFDC2626); // Dark Red
  static const Color onError = Color(0xFFFFFFFF); // White

  // Info Colors - Blue representing information
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFF60A5FA); // Light Blue
  static const Color infoDark = Color(0xFF2563EB); // Dark Blue
  static const Color onInfo = Color(0xFFFFFFFF); // White

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightOnSurface = Color(0xFF1F2937);
  static const Color lightOnSurfaceVariant = Color(0xFF6B7280);
  static const Color lightInputBackground = Color(0xFFF9FAFB);
  static const Color lightInputBorder = Color(0xFFD1D5DB);
  static const Color lightShadow = Color(0x1A000000);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkSurfaceVariant = Color(0xFF374151);
  static const Color darkOnSurface = Color(0xFFF9FAFB);
  static const Color darkOnSurfaceVariant = Color(0xFF9CA3AF);
  static const Color darkInputBackground = Color(0xFF374151);
  static const Color darkInputBorder = Color(0xFF4B5563);
  static const Color darkShadow = Color(0x40000000);

  // Neutral Colors
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, warningLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, errorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Special Colors for Tax Lien Features
  static const Color taxLienAvailable = Color(0xFF10B981); // Green
  static const Color taxLienSold = Color(0xFFEF4444); // Red
  static const Color taxLienPending = Color(0xFFF59E0B); // Amber
  static const Color taxLienRedeemed = Color(0xFF3B82F6); // Blue

  // NFT Colors
  static const Color nftCommon = Color(0xFF6B7280); // Gray
  static const Color nftRare = Color(0xFF3B82F6); // Blue
  static const Color nftEpic = Color(0xFF8B5CF6); // Purple
  static const Color nftLegendary = Color(0xFFF59E0B); // Amber

  // Risk Level Colors
  static const Color riskLow = Color(0xFF10B981); // Green
  static const Color riskMedium = Color(0xFFF59E0B); // Amber
  static const Color riskHigh = Color(0xFFEF4444); // Red

  // Investment Status Colors
  static const Color investmentActive = Color(0xFF10B981); // Green
  static const Color investmentPending = Color(0xFFF59E0B); // Amber
  static const Color investmentCompleted = Color(0xFF3B82F6); // Blue
  static const Color investmentCancelled = Color(0xFFEF4444); // Red

  // Light Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    tertiary: info,
    onTertiary: onInfo,
    error: error,
    onError: onError,
    background: lightBackground,
    onBackground: lightOnSurface,
    surface: lightSurface,
    onSurface: lightOnSurface,
    surfaceVariant: lightSurfaceVariant,
    onSurfaceVariant: lightOnSurfaceVariant,
    outline: lightInputBorder,
    outlineVariant: neutral300,
    shadow: lightShadow,
    scrim: Color(0x52000000),
    inverseSurface: darkSurface,
    onInverseSurface: darkOnSurface,
    inversePrimary: primaryLight,
    surfaceTint: primary,
  );

  // Dark Color Scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight,
    onPrimary: onPrimary,
    secondary: secondaryLight,
    onSecondary: onSecondary,
    tertiary: infoLight,
    onTertiary: onInfo,
    error: errorLight,
    onError: onError,
    background: darkBackground,
    onBackground: darkOnSurface,
    surface: darkSurface,
    onSurface: darkOnSurface,
    surfaceVariant: darkSurfaceVariant,
    onSurfaceVariant: darkOnSurfaceVariant,
    outline: darkInputBorder,
    outlineVariant: neutral600,
    shadow: darkShadow,
    scrim: Color(0x52000000),
    inverseSurface: lightSurface,
    onInverseSurface: lightOnSurface,
    inversePrimary: primary,
    surfaceTint: primaryLight,
  );

  // Utility Methods
  static ColorScheme getColorScheme(Brightness brightness) {
    return brightness == Brightness.light ? lightColorScheme : darkColorScheme;
  }

  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSurface : darkSurface;
  }

  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }

  static Color getOnSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light ? lightOnSurface : darkOnSurface;
  }

  static Color getOnSurfaceVariantColor(Brightness brightness) {
    return brightness == Brightness.light ? lightOnSurfaceVariant : darkOnSurfaceVariant;
  }

  static Color getInputBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightInputBackground : darkInputBackground;
  }

  static Color getInputBorderColor(Brightness brightness) {
    return brightness == Brightness.light ? lightInputBorder : darkInputBorder;
  }

  static Color getShadowColor(Brightness brightness) {
    return brightness == Brightness.light ? lightShadow : darkShadow;
  }
}
