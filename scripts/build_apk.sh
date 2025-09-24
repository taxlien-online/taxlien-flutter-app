#!/bin/bash

# HolySpots APK Build Script
# Script for building Flutter application APK file

echo "🚀 Starting APK build for HolySpots..."

# Check that we are in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Make sure you are in the Flutter project root directory."
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate localization files
echo "🌐 Generating localization files..."
flutter gen-l10n

# Check Flutter
echo "🔍 Checking Flutter..."
flutter doctor

# Build APK in release mode
echo "🔨 Building APK in release mode..."
flutter build apk --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ APK built successfully!"
    echo "📱 APK file is located at: build/app/outputs/flutter-apk/app-release.apk"
    
    # Show file size
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
        echo "📏 APK size: $APK_SIZE"
    fi
    
    echo "🎉 Build completed successfully!"
else
    echo "❌ Error building APK"
    exit 1
fi 