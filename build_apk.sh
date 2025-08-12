#!/bin/bash

# HolySpots APK Build Script
# Скрипт для сборки APK файла Flutter приложения

echo "🚀 Начинаем сборку APK для HolySpots..."

# Проверяем, что мы в правильной директории
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Ошибка: pubspec.yaml не найден. Убедитесь, что вы находитесь в корневой папке Flutter проекта."
    exit 1
fi

# Очищаем предыдущие сборки
echo "🧹 Очищаем предыдущие сборки..."
flutter clean

# Получаем зависимости
echo "📦 Получаем зависимости..."
flutter pub get

# Генерируем файлы локализации
echo "🌐 Генерируем файлы локализации..."
flutter gen-l10n

# Проверяем Flutter
echo "🔍 Проверяем Flutter..."
flutter doctor

# Собираем APK в режиме release
echo "🔨 Собираем APK в режиме release..."
flutter build apk --release

# Проверяем, что сборка прошла успешно
if [ $? -eq 0 ]; then
    echo "✅ APK успешно собран!"
    echo "📱 APK файл находится в: build/app/outputs/flutter-apk/app-release.apk"
    
    # Показываем размер файла
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
        echo "📏 Размер APK: $APK_SIZE"
    fi
    
    echo "🎉 Сборка завершена успешно!"
else
    echo "❌ Ошибка при сборке APK"
    exit 1
fi 