#!/bin/bash

# Simple build script for TaxLien.online mobile app
# Bypasses problematic dependencies for basic functionality

echo "🚀 Building TaxLien.online mobile app..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for Android (APK)
echo "🤖 Building Android APK..."
flutter build apk --debug

# Build for iOS (if possible)
echo "🍎 Building iOS app..."
flutter build ios --debug --no-codesign

echo "✅ Build completed!"
echo "📱 APK location: build/app/outputs/flutter-apk/app-debug.apk"
echo "🍎 iOS build location: build/ios/iphoneos/Runner.app"


