#!/bin/bash

# TaxLien.online App Store Build and Upload Script
# This script builds and uploads the Flutter app to App Store Connect

set -e

echo "🚀 Building and uploading TaxLien.online to App Store Connect..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="TaxLien.online"
WORKSPACE_PATH="ios/Runner.xcworkspace"
SCHEME="Runner"
CONFIGURATION="Release"
EXPORT_OPTIONS_PLIST="ios/ExportOptions.plist"

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

# Check if xcrun is available (for altool)
if ! command -v xcrun &> /dev/null; then
    echo -e "${RED}❌ Error: xcrun not found. This is required for App Store uploads.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites are met${NC}"

# Create ExportOptions.plist if it doesn't exist
if [ ! -f "$EXPORT_OPTIONS_PLIST" ]; then
    echo -e "${BLUE}📝 Creating ExportOptions.plist...${NC}"
    cat > "$EXPORT_OPTIONS_PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>
EOF
    echo -e "${YELLOW}⚠️  Please update YOUR_TEAM_ID in $EXPORT_OPTIONS_PLIST${NC}"
    echo -e "${YELLOW}⚠️  You can find your Team ID in Apple Developer account${NC}"
fi

# Clean and prepare
echo -e "${BLUE}🧹 Cleaning and preparing...${NC}"
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

# Build iOS application
echo -e "${BLUE}🔨 Building iOS application...${NC}"
flutter build ios --release --no-codesign

# Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ iOS application built successfully!${NC}"
else
    echo -e "${RED}❌ Error building iOS application${NC}"
    exit 1
fi

# Go to iOS directory
cd ios

# Clean Xcode project
echo -e "${BLUE}🧹 Cleaning Xcode project...${NC}"
xcodebuild clean -workspace "$WORKSPACE_PATH" -scheme "$SCHEME"

# Build archive
echo -e "${BLUE}📦 Building archive...${NC}"
ARCHIVE_PATH="$(pwd)/build/Runner.xcarchive"

xcodebuild archive \
    -workspace "$WORKSPACE_PATH" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    -allowProvisioningUpdates

# Check if archive was successful
if [ $? -eq 0 ] && [ -d "$ARCHIVE_PATH" ]; then
    echo -e "${GREEN}✅ Archive created successfully at: $ARCHIVE_PATH${NC}"
else
    echo -e "${RED}❌ Error creating archive${NC}"
    exit 1
fi

# Export IPA
echo -e "${BLUE}📱 Exporting IPA...${NC}"
IPA_PATH="$(pwd)/build/Runner.ipa"

xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$(pwd)/build" \
    -exportOptionsPlist "../$EXPORT_OPTIONS_PLIST"

# Check if IPA was created
if [ -f "$IPA_PATH" ]; then
    echo -e "${GREEN}✅ IPA created successfully at: $IPA_PATH${NC}"
    echo -e "${BLUE}📏 IPA size: $(du -sh "$IPA_PATH" | cut -f1)${NC}"
else
    echo -e "${RED}❌ Error creating IPA${NC}"
    exit 1
fi

# Return to root directory
cd ..

# Upload to App Store Connect
echo -e "${BLUE}☁️  Uploading to App Store Connect...${NC}"
echo -e "${YELLOW}⚠️  Note: This step requires Apple Developer account and proper code signing${NC}"

read -p "Do you want to upload to App Store Connect now? (y/n): " upload_now

if [ "$upload_now" = "y" ] || [ "$upload_now" = "Y" ]; then
    echo -e "${BLUE}📤 Starting upload...${NC}"
    
    # Check if altool is available (Xcode 12 and earlier)
    if command -v altool &> /dev/null; then
        echo -e "${BLUE}🔐 Using altool for upload...${NC}"
        echo -e "${YELLOW}⚠️  You will be prompted for your Apple ID and app-specific password${NC}"
        
        xcrun altool --upload-app \
            --type ios \
            --file "ios/build/Runner.ipa" \
            --username "YOUR_APPLE_ID" \
            --password "YOUR_APP_SPECIFIC_PASSWORD"
            
    # Check if notarytool is available (Xcode 13 and later)
    elif command -v notarytool &> /dev/null; then
        echo -e "${BLUE}🔐 Using notarytool for upload...${NC}"
        echo -e "${YELLOW}⚠️  You will be prompted for your Apple ID and app-specific password${NC}"
        
        xcrun notarytool submit "ios/build/Runner.ipa" \
            --apple-id "YOUR_APPLE_ID" \
            --password "YOUR_APP_SPECIFIC_PASSWORD" \
            --team-id "YOUR_TEAM_ID"
    else
        echo -e "${RED}❌ Neither altool nor notarytool found. Please update Xcode.${NC}"
        echo -e "${YELLOW}💡 You can manually upload the IPA from Xcode Organizer${NC}"
    fi
else
    echo -e "${BLUE}💡 Skipping upload. You can upload manually later.${NC}"
fi

echo -e "${GREEN}🎉 Build and export completed successfully!${NC}"
echo -e "${BLUE}📱 IPA file location: ios/build/Runner.ipa${NC}"
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "${YELLOW}1. Upload IPA to App Store Connect (if not done automatically)${NC}"
echo -e "${YELLOW}2. Configure app metadata in App Store Connect${NC}"
echo -e "${YELLOW}3. Submit for review${NC}"
echo -e "${YELLOW}4. Wait for Apple's review process${NC}"

echo -e "${BLUE}💡 Manual upload:${NC}"
echo -e "${YELLOW}1. Open Xcode${NC}"
echo -e "${YELLOW}2. Window -> Organizer${NC}"
echo -e "${YELLOW}3. Select your archive${NC}"
echo -e "${YELLOW}4. Click 'Distribute App'${NC}"
echo -e "${YELLOW}5. Choose 'App Store Connect'${NC}"
