import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Тема приложения FreeDome Manager
/// Основана на глубоких синих тонах с акцентами свободы и духовности
class AppTheme {
  // Приватный конструктор
  AppTheme._();

  /// Светлая тема приложения
  static ThemeData get lightTheme {
    return ThemeData(
      // Основные настройки
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: AppColors.light,
      
      // Фон приложения
      scaffoldBackgroundColor: AppColors.lightBackgroundPrimary,

      // AppBar тема
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightNavigationBackground,
        foregroundColor: AppColors.lightNavigationText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.lightNavigationText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.lightNavigationText,
        ),
      ),

      // Карточки
      cardTheme: CardThemeData(
        color: AppColors.lightCardBackground,
        elevation: 2,
        shadowColor: AppColors.lightCardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.buttonText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Текстовые кнопки
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Поля ввода
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightInputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightInputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightInputBorderFocused),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Переключатели
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.switchActive;
          }
          return AppColors.switchInactive;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.switchActive.withOpacity(0.5);
          }
          return AppColors.switchInactive;
        }),
      ),

      // Слайдеры
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.lightBorder,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
      ),

      // Диалоги
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightCardBackground,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.lightTextSecondary,
          fontSize: 16,
        ),
      ),

      // Прогресс-бары
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.progressFill,
        linearTrackColor: AppColors.progressBackground,
      ),

      // Чипы
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.lightTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Боттомшиты
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightCardBackground,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
    );
  }

  /// Темная тема приложения
  static ThemeData get darkTheme {
    return ThemeData(
      // Основные настройки
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: AppColors.dark,
      
      // Фон приложения
      scaffoldBackgroundColor: AppColors.darkBackgroundPrimary,

      // AppBar тема
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkNavigationBackground,
        foregroundColor: AppColors.darkNavigationText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.darkNavigationText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.darkNavigationText,
        ),
      ),

      // Карточки
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 2,
        shadowColor: AppColors.darkCardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.buttonText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Текстовые кнопки
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Поля ввода
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkInputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkInputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkInputBorderFocused),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Переключатели
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.switchActiveDark;
          }
          return AppColors.switchInactiveDark;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.switchActiveDark.withOpacity(0.5);
          }
          return AppColors.switchInactiveDark;
        }),
      ),

      // Слайдеры
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryLight,
        inactiveTrackColor: AppColors.darkBorder,
        thumbColor: AppColors.primaryLight,
        overlayColor: AppColors.primaryLight.withOpacity(0.2),
      ),

      // Диалоги
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkCardBackground,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: 16,
        ),
      ),

      // Прогресс-бары
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.progressFill,
        linearTrackColor: AppColors.progressBackground,
      ),

      // Чипы
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Боттомшиты
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkCardBackground,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
    );
  }

  /// Получить тему в зависимости от яркости
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
} 