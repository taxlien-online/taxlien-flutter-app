#!/bin/bash

# TaxLien iOS Release Script - Project Root
# This script runs the iOS release from the project root directory

echo "🚀 TaxLien iOS Release - Starting from project root..."

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Please run this script from the Flutter project root directory."
    exit 1
fi

# Check if iOS release script exists
if [ ! -f "ios/fastlane_release_ios.sh" ]; then
    echo "❌ Error: iOS release script not found at ios/fastlane_release_ios.sh"
    exit 1
fi

# Run the iOS release script with all passed arguments
echo "📱 Running iOS release script..."
bash ios/fastlane_release_ios.sh "$@"
