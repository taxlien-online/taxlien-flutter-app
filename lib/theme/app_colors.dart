import 'package:flutter/material.dart';

/// Color palette for TaxLien.online
/// Based on deep blue tones with accents of freedom and spirituality
class AppColors {
  // Private constructor
  AppColors._();

  // Main brand colors
  static const Color primary = Color(0xFF1E3A8A); // Deep blue
  static const Color primaryLight = Color(0xFF3B82F6); // Light blue
  static const Color primaryDark = Color(0xFF1E40AF); // Dark blue
  
  // Accent colors
  static const Color accent = Color(0xFF10B981); // Freedom green
  static const Color accentLight = Color(0xFF34D399); // Light green
  static const Color accentDark = Color(0xFF059669); // Dark green
  
  // Spiritual colors (inspired by HolySpots)
  static const Color spiritual = Color(0xFF8B5CF6); // Purple
  static const Color spiritualLight = Color(0xFFA78BFA); // Light purple
  static const Color spiritualDark = Color(0xFF7C3AED); // Dark purple
  
  // Light theme
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: accent,
    onSecondary: Colors.white,
    tertiary: spiritual,
    onTertiary: Colors.white,
    error: Color(0xFFEF4444),
    onError: Colors.white,
    background: lightBackgroundPrimary,
    onBackground: lightTextPrimary,
    surface: lightCardBackground,
    onSurface: lightTextPrimary,
    surfaceVariant: lightCardBackgroundSecondary,
    onSurfaceVariant: lightTextSecondary,
    outline: lightBorder,
    outlineVariant: lightBorderSecondary,
    shadow: lightShadow,
    scrim: Colors.black12,
    inverseSurface: darkCardBackground,
    onInverseSurface: darkTextPrimary,
    inversePrimary: primaryLight,
    surfaceTint: primary,
  );

  // Dark theme
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight,
    onPrimary: Colors.white,
    secondary: accentLight,
    onSecondary: Colors.white,
    tertiary: spiritualLight,
    onTertiary: Colors.white,
    error: Color(0xFFF87171),
    onError: Colors.white,
    background: darkBackgroundPrimary,
    onBackground: darkTextPrimary,
    surface: darkCardBackground,
    onSurface: darkTextPrimary,
    surfaceVariant: darkCardBackgroundSecondary,
    onSurfaceVariant: darkTextSecondary,
    outline: darkBorder,
    outlineVariant: darkBorderSecondary,
    shadow: darkShadow,
    scrim: Colors.black38,
    inverseSurface: lightCardBackground,
    onInverseSurface: lightTextPrimary,
    inversePrimary: primary,
    surfaceTint: primaryLight,
  );

  // Light theme - backgrounds
  static const Color lightBackgroundPrimary = Color(0xFFFAFAFA);
  static const Color lightBackgroundSecondary = Color(0xFFF5F5F5);
  static const Color lightCardBackground = Colors.white;
  static const Color lightCardBackgroundSecondary = Color(0xFFF8F9FA);
  static const Color lightNavigationBackground = Colors.white;
  static const Color lightInputBackground = Color(0xFFF8F9FA);

  // Light theme - texts
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  static const Color lightNavigationText = Color(0xFF1F2937);

  // Light theme - borders and shadows
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightBorderSecondary = Color(0xFFF3F4F6);
  static const Color lightBorderFocused = primary;
  static const Color lightInputBorder = Color(0xFFD1D5DB);
  static const Color lightInputBorderFocused = primary;
  static const Color lightShadow = Color(0x1A000000);
  static const Color lightCardShadow = Color(0x0A000000);

  // Dark theme - backgrounds
  static const Color darkBackgroundPrimary = Color(0xFF0F172A);
  static const Color darkBackgroundSecondary = Color(0xFF1E293B);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkCardBackgroundSecondary = Color(0xFF334155);
  static const Color darkNavigationBackground = Color(0xFF1E293B);
  static const Color darkInputBackground = Color(0xFF334155);

  // Dark theme - texts
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);
  static const Color darkNavigationText = Color(0xFFF8FAFC);

  // Dark theme - borders and shadows
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkBorderSecondary = Color(0xFF475569);
  static const Color darkBorderFocused = primaryLight;
  static const Color darkInputBorder = Color(0xFF475569);
  static const Color darkInputBorderFocused = primaryLight;
  static const Color darkShadow = Color(0x40000000);
  static const Color darkCardShadow = Color(0x20000000);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Buttons
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = accent;
  static const Color buttonText = Colors.white;
  static const Color buttonDisabled = Color(0xFF9CA3AF);

  // Switches
  static const Color switchActive = accent;
  static const Color switchInactive = Color(0xFFD1D5DB);
  static const Color switchActiveDark = accentLight;
  static const Color switchInactiveDark = Color(0xFF475569);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient spiritualGradient = LinearGradient(
    colors: [spiritual, spiritualLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient freedomGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Special colors for FreeDome
  static const Color freedomeConnected = success;
  static const Color freedomeDisconnected = error;
  static const Color freedomeConnecting = warning;
  static const Color freedomeCalibrating = info;

  // Methods for getting colors based on theme
  static Color getBackgroundPrimary(Brightness brightness) {
    return brightness == Brightness.light ? lightBackgroundPrimary : darkBackgroundPrimary;
  }

  static Color getBackgroundSecondary(Brightness brightness) {
    return brightness == Brightness.light ? lightBackgroundSecondary : darkBackgroundSecondary;
  }

  static Color getBackgroundTertiary(Brightness brightness) {
    return brightness == Brightness.light ? lightBackgroundSecondary : darkBackgroundSecondary;
  }

  static Color getTextPrimary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;
  }

  static Color getTextSecondary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextSecondary : darkTextSecondary;
  }

  static Color getTextTertiary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextTertiary : darkTextTertiary;
  }

  static Color getCardBackground(Brightness brightness) {
    return brightness == Brightness.light ? lightCardBackground : darkCardBackground;
  }

  static Color getCardBackgroundSecondary(Brightness brightness) {
    return brightness == Brightness.light ? lightCardBackgroundSecondary : darkCardBackgroundSecondary;
  }

  static Color getCardShadow(Brightness brightness) {
    return brightness == Brightness.light ? lightCardShadow : darkCardShadow;
  }

  static Color getNavigationBackground(Brightness brightness) {
    return brightness == Brightness.light ? lightNavigationBackground : darkNavigationBackground;
  }

  static Color getNavigationText(Brightness brightness) {
    return brightness == Brightness.light ? lightNavigationText : darkNavigationText;
  }

  static Color getDialogBackground(Brightness brightness) {
    return brightness == Brightness.light ? lightCardBackground : darkCardBackground;
  }

  static Color getDialogText(Brightness brightness) {
    return brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;
  }

  static Color getDialogTextSecondary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextSecondary : darkTextSecondary;
  }

  static Color getIconPrimary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;
  }

  static Color getIconSecondary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextSecondary : darkTextSecondary;
  }

  static Color getIconTertiary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextTertiary : darkTextTertiary;
  }

  static Color getInputBackground(Brightness brightness) {
    return brightness == Brightness.light ? lightInputBackground : darkInputBackground;
  }

  static Color getInputBorder(Brightness brightness) {
    return brightness == Brightness.light ? lightInputBorder : darkInputBorder;
  }

  static Color getInputBorderFocused(Brightness brightness) {
    return brightness == Brightness.light ? lightInputBorderFocused : darkInputBorderFocused;
  }

  static Color getInputText(Brightness brightness) {
    return brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;
  }

  static List<Color> getCardGradient(Brightness brightness) {
    return brightness == Brightness.light 
        ? [lightCardBackground, lightCardBackgroundSecondary]
        : [darkCardBackground, darkCardBackgroundSecondary];
  }

  // Colors for progress bars
  static const Color progressBackground = Color(0xFFE5E7EB);
  static const Color progressFill = accent;
} 