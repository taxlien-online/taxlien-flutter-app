#!/bin/bash

# HolySpots IPA Build Script
# Script for building Flutter iOS application IPA file

echo "🚀 Starting IPA build for HolySpots..."

# Check that we are in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Make sure you are in the Flutter project root directory."
    exit 1
fi

# Check that Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode not found. Install Xcode to build iOS applications."
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Check Flutter
echo "🔍 Checking Flutter..."
flutter doctor

# Go to iOS directory
cd ios

# Clean iOS project
echo "🧹 Cleaning iOS project..."
xcodebuild clean -workspace Runner.xcworkspace -scheme Runner

# Return to root directory
cd ..

# Build iOS application
echo "🔨 Building iOS application..."
flutter build ios --release --no-codesign

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ iOS application built successfully!"
    echo "📱 Application is located at: build/ios/iphoneos/Runner.app"
    
    # Create IPA file (requires signed code)
    echo "📦 Creating IPA file..."
    
    # Check for signed application
    if [ -d "build/ios/iphoneos/Runner.app" ]; then
        echo "📏 Application size: $(du -sh build/ios/iphoneos/Runner.app | cut -f1)"
        echo "ℹ️  Signed code is required to create IPA file."
        echo "💡 Use Xcode to sign and create IPA:"
        echo "   1. Open ios/Runner.xcworkspace in Xcode"
        echo "   2. Select Product -> Archive"
        echo "   3. In Organizer select Distribute App"
        echo "   4. Choose Ad Hoc or App Store"
        echo "   5. Sign and export IPA"
    else
        echo "❌ Application not found in build/ios/iphoneos/Runner.app"
    fi
    
    echo "🎉 Build completed successfully!"
else
    echo "❌ Error building iOS application"
    exit 1
fi 