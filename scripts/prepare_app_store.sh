#!/bin/bash

# TaxLien.online App Store Preparation Script
# This script prepares the Flutter app for Apple Store publication

set -e

echo "🚀 Preparing TaxLien.online for Apple Store publication..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${BLUE}📋 Checking prerequisites...${NC}"

# Check if we're in the Flutter project directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found. Make sure you are in the Flutter project root directory.${NC}"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Error: Xcode not found. Install Xcode to build iOS applications.${NC}"
    exit 1
fi

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Error: Flutter not found. Install Flutter to build the application.${NC}"
    exit 1
fi

# Check if CocoaPods is available
if ! command -v pod &> /dev/null; then
    echo -e "${RED}❌ Error: CocoaPods not found. Install CocoaPods to manage iOS dependencies.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites are met${NC}"

# Update version if needed
echo -e "${BLUE}📱 Current app version: $(grep '^version:' pubspec.yaml | sed 's/version: //')${NC}"
read -p "Do you want to update the version? (y/n): " update_version

if [ "$update_version" = "y" ] || [ "$update_version" = "Y" ]; then
    read -p "Enter new version (e.g., 2.0.1): " new_version
    read -p "Enter new build number (e.g., 2): " new_build
    
    # Validate inputs
    if [ -z "$new_version" ] || [ -z "$new_build" ]; then
        echo -e "${YELLOW}⚠️  Version or build number is empty, skipping update${NC}"
    else
        # Update pubspec.yaml
        sed -i.bak "s/^version: .*/version: ${new_version}+${new_build}/" pubspec.yaml
        echo -e "${GREEN}✅ Version updated to ${new_version}+${new_build}${NC}"
    fi
fi

# Clean and get dependencies
echo -e "${BLUE}🧹 Cleaning and updating dependencies...${NC}"
flutter clean
flutter pub get

# Update iOS dependencies
echo -e "${BLUE}📦 Updating iOS dependencies...${NC}"
cd ios
pod install --repo-update
cd ..

# Check Flutter doctor
echo -e "${BLUE}🔍 Running Flutter doctor...${NC}"
flutter doctor

# Build configuration check
echo -e "${BLUE}⚙️  Checking build configuration...${NC}"

# Check if Bundle Identifier is set
if grep -q "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj; then
    echo -e "${GREEN}✅ Bundle Identifier is configured${NC}"
else
    echo -e "${YELLOW}⚠️  Bundle Identifier not found in project configuration${NC}"
fi

# Check Info.plist
if [ -f "ios/Runner/Info.plist" ]; then
    echo -e "${GREEN}✅ Info.plist exists${NC}"
    
    # Check display name
    display_name=$(grep -A1 "CFBundleDisplayName" ios/Runner/Info.plist | tail -1 | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
    echo -e "${BLUE}📱 Display Name: ${display_name}${NC}"
    
    # Check bundle identifier
    bundle_id=$(grep -A1 "CFBundleIdentifier" ios/Runner/Info.plist | tail -1 | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
    echo -e "${BLUE}🆔 Bundle ID: ${bundle_id}${NC}"
else
    echo -e "${RED}❌ Info.plist not found${NC}"
fi

# Check app icons
if [ -d "ios/Runner/Assets.xcassets/AppIcon.appiconset" ]; then
    icon_count=$(find ios/Runner/Assets.xcassets/AppIcon.appiconset -name "*.png" | wc -l)
    echo -e "${BLUE}🎨 App icons found: ${icon_count}${NC}"
    
    if [ $icon_count -lt 20 ]; then
        echo -e "${YELLOW}⚠️  Warning: App icons may be incomplete. iOS requires multiple sizes.${NC}"
    fi
else
    echo -e "${RED}❌ App icons not found${NC}"
fi

# Check launch screen
if [ -f "ios/Runner/Base.lproj/LaunchScreen.storyboard" ]; then
    echo -e "${GREEN}✅ Launch screen exists${NC}"
else
    echo -e "${YELLOW}⚠️  Launch screen not found${NC}"
fi

echo -e "${BLUE}📋 Next steps for App Store publication:${NC}"
echo -e "${YELLOW}1. Open ios/Runner.xcworkspace in Xcode${NC}"
echo -e "${YELLOW}2. Configure Bundle Identifier in project settings${NC}"
echo -e "${YELLOW}3. Set up code signing with your Apple Developer account${NC}"
echo -e "${YELLOW}4. Configure App Store Connect in Xcode${NC}"
echo -e "${YELLOW}5. Build and archive the app${NC}"
echo -e "${YELLOW}6. Upload to App Store Connect${NC}"

echo -e "${GREEN}🎉 Preparation completed!${NC}"
echo -e "${BLUE}💡 Run: open ios/Runner.xcworkspace${NC}"
echo -e "${BLUE}💡 Or use: ./build_and_upload.sh${NC}"
