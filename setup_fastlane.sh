#!/bin/bash

# TaxLien.online Fastlane Setup Script
# This script sets up fastlane for the TaxLien.online mobile app

set -e

echo "🚀 TaxLien.online Fastlane Setup"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the Flutter project directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found. Make sure you are in the Flutter project root directory.${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Checking prerequisites...${NC}"

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Error: Flutter not found. Install Flutter first:${NC}"
    echo -e "${BLUE}   https://flutter.dev/docs/get-started/install${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Flutter found${NC}"

# Check if fastlane is installed
if ! command -v fastlane &> /dev/null; then
    echo -e "${YELLOW}⚠️  fastlane not found. Installing fastlane...${NC}"
    
    # Check if gem is available
    if ! command -v gem &> /dev/null; then
        echo -e "${RED}❌ Error: Ruby gem not found. Install Ruby first:${NC}"
        echo -e "${BLUE}   https://www.ruby-lang.org/en/documentation/installation/${NC}"
        exit 1
    fi
    
    # Install fastlane
    gem install fastlane
    echo -e "${GREEN}✅ fastlane installed${NC}"
else
    echo -e "${GREEN}✅ fastlane found${NC}"
fi

# Check Flutter doctor
echo -e "${BLUE}🔍 Running Flutter doctor...${NC}"
flutter doctor

echo ""
echo -e "${BLUE}📁 Setting up fastlane directories...${NC}"

# Create fastlane directories if they don't exist
mkdir -p fastlane
mkdir -p ios/fastlane
mkdir -p android/fastlane

echo -e "${GREEN}✅ Fastlane directories created${NC}"

# Check if fastlane files exist
if [ ! -f "fastlane/Fastfile" ]; then
    echo -e "${YELLOW}⚠️  Main Fastfile not found. Please run the fastlane setup first.${NC}"
    echo -e "${BLUE}💡 The fastlane configuration files should be created by the main setup script.${NC}"
fi

if [ ! -f "ios/fastlane/Fastfile" ]; then
    echo -e "${YELLOW}⚠️  iOS Fastfile not found. Please run the fastlane setup first.${NC}"
fi

if [ ! -f "android/fastlane/Fastfile" ]; then
    echo -e "${YELLOW}⚠️  Android Fastfile not found. Please run the fastlane setup first.${NC}"
fi

echo ""
echo -e "${BLUE}🔐 Checking configuration files...${NC}"

# Check iOS configuration
if [ -f "ios/fastlane/Appfile" ]; then
    echo -e "${GREEN}✅ iOS Appfile found${NC}"
else
    echo -e "${YELLOW}⚠️  iOS Appfile not found${NC}"
fi

# Check Android configuration
if [ -f "android/fastlane/Appfile" ]; then
    echo -e "${GREEN}✅ Android Appfile found${NC}"
else
    echo -e "${YELLOW}⚠️  Android Appfile not found${NC}"
fi

# Check for Google Play service account
if [ -f "android/google-play-service-account.json" ]; then
    echo -e "${GREEN}✅ Google Play service account found${NC}"
else
    echo -e "${YELLOW}⚠️  Google Play service account not found${NC}"
    echo -e "${BLUE}💡 You'll need to set up Google Play Console API access${NC}"
    echo -e "${BLUE}   See FASTLANE_README.md for instructions${NC}"
fi

# Check for Android keystore
if [ -f "android/taxlien-release-key.keystore" ]; then
    echo -e "${GREEN}✅ Android keystore found${NC}"
else
    echo -e "${YELLOW}⚠️  Android keystore not found${NC}"
    echo -e "${BLUE}💡 You'll need to create a keystore for Android releases${NC}"
fi

# Check for keystore.properties
if [ -f "android/keystore.properties" ]; then
    echo -e "${GREEN}✅ Android keystore.properties found${NC}"
else
    echo -e "${YELLOW}⚠️  Android keystore.properties not found${NC}"
    echo -e "${BLUE}💡 You'll need to configure keystore properties${NC}"
fi

echo ""
echo -e "${BLUE}🧪 Testing fastlane configuration...${NC}"

# Test fastlane configuration
if [ -f "fastlane/Fastfile" ]; then
    echo -e "${BLUE}📱 Testing main fastlane configuration...${NC}"
    fastlane lanes
    echo ""
fi

if [ -f "ios/fastlane/Fastfile" ]; then
    echo -e "${BLUE}🍎 Testing iOS fastlane configuration...${NC}"
    cd ios && fastlane lanes && cd ..
    echo ""
fi

if [ -f "android/fastlane/Fastfile" ]; then
    echo -e "${BLUE}🤖 Testing Android fastlane configuration...${NC}"
    cd android && fastlane lanes && cd ..
    echo ""
fi

echo -e "${GREEN}🎉 Fastlane setup completed!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "${BLUE}1. Configure your Apple Developer account (for iOS)${NC}"
echo -e "${BLUE}2. Set up Google Play Console API (for Android)${NC}"
echo -e "${BLUE}3. Create Android keystore if needed${NC}"
echo -e "${BLUE}4. Test with build commands:${NC}"
echo -e "${BLUE}   ./fastlane_release.sh ios build${NC}"
echo -e "${BLUE}   ./fastlane_release.sh android build${NC}"
echo ""
echo -e "${BLUE}📖 See FASTLANE_README.md for detailed instructions${NC}"
echo -e "${GREEN}✅ Setup complete!${NC}"
