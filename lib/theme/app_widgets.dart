import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_gradients.dart';

/// Common widgets for TaxLien.online application
/// Ensures UI component consistency
/// Supports light and dark themes
/// Based on deep blue tones with accents of freedom and spirituality
class AppWidgets {
  // Private constructor to prevent instantiation
  AppWidgets._();

  /// Card with gradient background
  static Widget gradientCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    List<Color>? colors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    Brightness? brightness,
  }) {
    final themeBrightness = brightness ?? WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final cardColors = colors ?? AppColors.getCardGradient(themeBrightness);
    
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.cardRadius),
        gradient: LinearGradient(
          colors: cardColors,
          begin: begin ?? Alignment.topLeft,
          end: end ?? Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  /// Button with gradient
  static Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    List<Color>? colors,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.radiusM),
        gradient: LinearGradient(
          colors: colors ?? [AppColors.primary, AppColors.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXXL,
            vertical: AppDimensions.paddingL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.radiusM),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: AppDimensions.loadingIndicatorSize,
                height: AppDimensions.loadingIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppDimensions.loadingIndicatorStrokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonText),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.buttonText),
                    const SizedBox(width: AppDimensions.paddingS),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.buttonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Progress bar with gradient
  static Widget gradientProgressBar({
    required double value,
    double? height,
    double? borderRadius,
    List<Color>? colors,
  }) {
    return Container(
      height: height ?? AppDimensions.progressBarHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.progressBarRadius),
        color: AppColors.progressBackground,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.progressBarRadius),
            gradient: LinearGradient(
              colors: colors ?? [AppColors.accent, AppColors.accentLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
    );
  }

  /// Chip with gradient
  static Widget gradientChip({
    required String label,
    VoidCallback? onDeleted,
    IconData? icon,
    List<Color>? colors,
    double? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.chipRadius),
        gradient: LinearGradient(
          colors: colors ?? [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.buttonText,
            fontWeight: FontWeight.w600,
          ),
        ),
        avatar: icon != null ? Icon(icon, color: AppColors.buttonText) : null,
        deleteIcon: onDeleted != null
            ? const Icon(Icons.close, color: AppColors.buttonText)
            : null,
        onDeleted: onDeleted,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.chipRadius),
        ),
      ),
    );
  }

  /// Avatar with gradient
  static Widget gradientAvatar({
    required String text,
    double? size,
    List<Color>? colors,
  }) {
    return Container(
      width: size ?? AppDimensions.avatarSizeL,
      height: size ?? AppDimensions.avatarSizeL,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors ?? [AppColors.spiritual, AppColors.spiritualLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          text.isNotEmpty ? text[0].toUpperCase() : 'F',
          style: const TextStyle(
            color: AppColors.buttonText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Loading indicator with gradient
  static Widget gradientLoadingIndicator({
    double? size,
    double? strokeWidth,
    List<Color>? colors,
  }) {
    return SizedBox(
      width: size ?? AppDimensions.loadingIndicatorSize,
      height: size ?? AppDimensions.loadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? AppDimensions.loadingIndicatorStrokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          colors?.first ?? AppColors.primary,
        ),
      ),
    );
  }

  /// Info card
  static Widget infoCard({
    required String title,
    required String subtitle,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    Brightness? brightness,
  }) {
    final themeBrightness = brightness ?? WidgetsBinding.instance.platformDispatcher.platformBrightness;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? AppColors.getIconPrimary(themeBrightness),
                  size: AppDimensions.iconSizeL,
                ),
                const SizedBox(width: AppDimensions.paddingL),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.getTextPrimary(themeBrightness),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.getTextSecondary(themeBrightness),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.getIconSecondary(themeBrightness),
                  size: AppDimensions.iconSizeS,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Divider with gradient
  static Widget gradientDivider({
    double? height,
    List<Color>? colors,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      height: height ?? 1.0,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? [AppColors.lightBackgroundSecondary, AppColors.lightBackgroundSecondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  /// Text with gradient
  static Widget gradientText({
    required String text,
    TextStyle? style,
    List<Color>? colors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors ?? [AppColors.primary, AppColors.accent],
        begin: begin ?? Alignment.topLeft,
        end: end ?? Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: style?.copyWith(color: Colors.white) ?? 
               const TextStyle(
                 color: Colors.white,
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
      ),
    );
  }

  /// FreeDome status indicator
  static Widget freedomeStatusIndicator({
    required bool isConnected,
    required bool isCalibrating,
    double? size,
  }) {
    Color statusColor;
    IconData statusIcon;
    
    if (isCalibrating) {
      statusColor = AppColors.freedomeCalibrating;
      statusIcon = Icons.sync;
    } else if (isConnected) {
      statusColor = AppColors.freedomeConnected;
      statusIcon = Icons.check_circle;
    } else {
      statusColor = AppColors.freedomeDisconnected;
      statusIcon = Icons.error;
    }

    return Container(
      width: size ?? AppDimensions.freedomeStatusIndicatorSize,
      height: size ?? AppDimensions.freedomeStatusIndicatorSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: statusColor,
      ),
      child: Icon(
        statusIcon,
        color: Colors.white,
        size: (size ?? AppDimensions.freedomeStatusIndicatorSize) * 0.6,
      ),
    );
  }

  /// FreeDome connection card
  static Widget freedomeConnectionCard({
    required String title,
    required String status,
    required bool isConnected,
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
    Brightness? brightness,
  }) {
    final themeBrightness = brightness ?? WidgetsBinding.instance.platformDispatcher.platformBrightness;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                freedomeStatusIndicator(
                  isConnected: isConnected,
                  isCalibrating: false,
                ),
                const SizedBox(width: AppDimensions.paddingL),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.getTextPrimary(themeBrightness),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          color: AppColors.getTextSecondary(themeBrightness),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Row(
              children: [
                                  if (isConnected)
                    Expanded(
                      child: gradientButton(
                        text: 'Disconnect',
                        onPressed: onDisconnect ?? () {},
                        icon: Icons.power_settings_new,
                        colors: [AppColors.error, AppColors.primary],
                      ),
                    )
                  else
                    Expanded(
                      child: gradientButton(
                        text: 'Connect',
                        onPressed: onConnect ?? () {},
                        icon: Icons.power_settings_new,
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Calibration card
  static Widget calibrationCard({
    required String title,
    required double progress,
    required String status,
    VoidCallback? onStart,
    VoidCallback? onStop,
    bool isCalibrating = false,
    Brightness? brightness,
  }) {
    final themeBrightness = brightness ?? WidgetsBinding.instance.platformDispatcher.platformBrightness;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.getTextPrimary(themeBrightness),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            gradientProgressBar(
              value: progress,
              height: AppDimensions.freedomeCalibrationProgressHeight,
              colors: [AppColors.primary, AppColors.spiritual],
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              status,
              style: TextStyle(
                color: AppColors.getTextSecondary(themeBrightness),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Row(
              children: [
                if (isCalibrating)
                  Expanded(
                    child: gradientButton(
                      text: 'Stop',
                      onPressed: onStop ?? () {},
                      icon: Icons.stop,
                      colors: [AppColors.warning, AppColors.error],
                    ),
                  )
                else
                  Expanded(
                    child: gradientButton(
                      text: 'Start',
                      onPressed: onStart ?? () {},
                      icon: Icons.play_arrow,
                      colors: [AppColors.primary, AppColors.spiritual],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 