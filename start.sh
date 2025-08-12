#!/bin/bash

echo "📱 Запуск FreeDome Manager..."

# Проверяем наличие Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter не установлен. Установите Flutter SDK."
    exit 1
fi

# Устанавливаем зависимости
echo "📦 Установка зависимостей..."
flutter pub get

# Генерируем файлы локализации
echo "🌐 Генерируем файлы локализации..."
flutter gen-l10n

# Запускаем приложение
echo "🚀 Запуск приложения..."
flutter run 