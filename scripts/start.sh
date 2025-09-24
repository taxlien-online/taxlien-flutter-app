#!/bin/bash

echo "📱 Starting TaxLien.online..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter SDK."
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Generate localization files
echo "🌐 Generating localization files..."
flutter gen-l10n

# Run the application
echo "🚀 Starting the application..."
flutter run 