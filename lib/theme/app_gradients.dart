import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Градиенты приложения FreeDome Manager
/// Основаны на глубоких синих тонах с акцентами свободы и духовности
/// Поддерживают светлую и темную темы
class AppGradients {
  // Приватный конструктор для предотвращения создания экземпляров
  AppGradients._();

  /// Основной фоновый градиент (светлая тема)
  static const LinearGradient lightBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.lightBackgroundPrimary,
      AppColors.lightBackgroundSecondary,
    ],
  );

  /// Основной фоновый градиент (темная тема)
  static const LinearGradient darkBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.darkBackgroundPrimary,
      AppColors.darkBackgroundSecondary,
    ],
  );

  /// Градиент для карточек (светлая тема)
  static const LinearGradient lightCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.lightCardBackground,
      AppColors.lightCardBackgroundSecondary,
    ],
  );

  /// Градиент для карточек (темная тема)
  static const LinearGradient darkCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.darkCardBackground,
      AppColors.darkCardBackgroundSecondary,
    ],
  );

  /// Градиент для кнопок
  static const LinearGradient button = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.primary,
      AppColors.accent,
    ],
  );

  /// Градиент для прогресс-баров
  static const LinearGradient progress = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.accent,
      AppColors.accentLight,
    ],
  );

  /// Градиент для калибровки
  static const LinearGradient calibration = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.spiritual,
    ],
  );

  /// Градиент для сканера
  static const LinearGradient scanner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.info,
      AppColors.primary,
    ],
  );

  /// Градиент для управления
  static const LinearGradient control = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.primaryLight,
    ],
  );

  /// Градиент для мониторинга
  static const LinearGradient monitoring = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accent,
      AppColors.success,
    ],
  );

  /// Градиент для профиля
  static const LinearGradient profile = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.spiritual,
      AppColors.spiritualLight,
    ],
  );

  /// Градиент для подключения
  static const LinearGradient connection = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.accent,
    ],
  );

  /// Градиент для статуса FreeDome
  static const LinearGradient freedomeStatus = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.freedomeConnected,
      AppColors.accent,
    ],
  );

  /// Градиент для свободы
  static const LinearGradient freedom = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.accent,
    ],
  );

  /// Градиент для духовности
  static const LinearGradient spiritual = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.spiritual,
      AppColors.spiritualLight,
    ],
  );

  /// Градиент для успеха
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.success,
      AppColors.accentLight,
    ],
  );

  /// Градиент для предупреждений
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.warning,
      AppColors.accent,
    ],
  );

  /// Градиент для ошибок
  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.error,
      AppColors.primary,
    ],
  );

  /// Методы для получения градиентов в зависимости от темы
  static LinearGradient getBackground(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }

  static LinearGradient getCard(Brightness brightness) {
    return brightness == Brightness.light ? lightCard : darkCard;
  }

  /// Метод для создания кастомного градиента
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

  /// Метод для создания радиального градиента
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