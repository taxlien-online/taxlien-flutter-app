#!/bin/bash

# TaxLien.online Google Play Store Build Script
# This script prepares and builds the app for Google Play Store publication

set -e

echo "🚀 Preparing TaxLien.online for Google Play Store publication..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="TaxLien.online"
KEYSTORE_FILE="android/taxlien-release-key.keystore"
KEYSTORE_PROPERTIES="android/keystore.properties"

# Check prerequisites
echo -e "${BLUE}📋 Checking prerequisites...${NC}"

# Check if we're in the Flutter project directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found. Make sure you are in the Flutter project root directory.${NC}"
    exit 1
fi

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Error: Flutter not found. Install Flutter to build the application.${NC}"
    exit 1
fi

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Error: Java not found. Install Java to build Android applications.${NC}"
    exit 1
fi

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo -e "${RED}❌ Error: keytool not found. Install Java JDK to get keytool.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites are met${NC}"

# Check keystore setup
echo -e "${BLUE}🔐 Checking keystore setup...${NC}"

if [ ! -f "$KEYSTORE_FILE" ]; then
    echo -e "${YELLOW}⚠️  Keystore file not found. Creating new keystore...${NC}"
    echo -e "${BLUE}📝 Please provide the following information for your keystore:${NC}"
    
    read -p "Enter keystore password: " STORE_PASSWORD
    read -p "Enter key password (can be same as keystore): " KEY_PASSWORD
    read -p "Enter your name: " NAME
    read -p "Enter your organization: " ORGANIZATION
    read -p "Enter your city: " CITY
    read -p "Enter your state: " STATE
    read -p "Enter your country code (e.g., US): " COUNTRY
    
    # Generate keystore
    keytool -genkey -v \
        -keystore "$KEYSTORE_FILE" \
        -alias taxlien-key-alias \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -storepass "$STORE_PASSWORD" \
        -keypass "$KEY_PASSWORD" \
        -dname "CN=$NAME, OU=$ORGANIZATION, L=$CITY, ST=$STATE, C=$COUNTRY"
    
    echo -e "${GREEN}✅ Keystore created successfully${NC}"
else
    echo -e "${GREEN}✅ Keystore file found${NC}"
fi

# Check keystore.properties
if [ ! -f "$KEYSTORE_PROPERTIES" ]; then
    echo -e "${YELLOW}⚠️  keystore.properties not found. Creating template...${NC}"
    echo -e "${BLUE}📝 Please update the passwords in $KEYSTORE_PROPERTIES${NC}"
    
    cat > "$KEYSTORE_PROPERTIES" << EOF
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=taxlien-key-alias
storeFile=../taxlien-release-key.keystore
EOF
    
    echo -e "${YELLOW}⚠️  Please update the passwords in $KEYSTORE_PROPERTIES before continuing${NC}"
    echo -e "${YELLOW}⚠️  Press Enter when ready to continue...${NC}"
    read
fi

# Verify keystore.properties has real passwords
if grep -q "YOUR_STORE_PASSWORD\|YOUR_KEY_PASSWORD" "$KEYSTORE_PROPERTIES"; then
    echo -e "${RED}❌ Error: Please update the passwords in $KEYSTORE_PROPERTIES${NC}"
    echo -e "${BLUE}📝 Edit the file and replace YOUR_STORE_PASSWORD and YOUR_KEY_PASSWORD with real values${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Keystore configuration is ready${NC}"

# Clean and prepare
echo -e "${BLUE}🧹 Cleaning and preparing...${NC}"
flutter clean
flutter pub get

# Generate localization files
echo -e "${BLUE}🌐 Generating localization files...${NC}"
flutter gen-l10n

# Check Flutter doctor
echo -e "${BLUE}🔍 Running Flutter doctor...${NC}"
flutter doctor

# Build APK for Google Play Store
echo -e "${BLUE}🔨 Building APK for Google Play Store...${NC}"
flutter build apk --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ APK built successfully!${NC}"
    
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$APK_PATH" ]; then
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        echo -e "${GREEN}📱 APK file: $APK_PATH${NC}"
        echo -e "${GREEN}📏 APK size: $APK_SIZE${NC}"
        
        # Verify APK is signed
        echo -e "${BLUE}🔍 Verifying APK signature...${NC}"
        if jarsigner -verify -verbose -certs "$APK_PATH" | grep -q "jar verified"; then
            echo -e "${GREEN}✅ APK is properly signed${NC}"
        else
            echo -e "${RED}❌ APK signature verification failed${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ APK file not found at expected location${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Error building APK${NC}"
    exit 1
fi

# Build App Bundle (AAB) for Google Play Store
echo -e "${BLUE}📦 Building App Bundle (AAB) for Google Play Store...${NC}"
flutter build appbundle --release

# Check if AAB build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ App Bundle built successfully!${NC}"
    
    AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
    if [ -f "$AAB_PATH" ]; then
        AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
        echo -e "${GREEN}📦 App Bundle file: $AAB_PATH${NC}"
        echo -e "${GREEN}📏 App Bundle size: $AAB_SIZE${NC}"
    else
        echo -e "${RED}❌ App Bundle file not found at expected location${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Error building App Bundle${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Build completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps for Google Play Store publication:${NC}"
echo -e "${BLUE}1. Go to [Google Play Console](https://play.google.com/console)${NC}"
echo -e "${BLUE}2. Create a new app or use existing one${NC}"
echo -e "${BLUE}3. Upload your App Bundle (AAB) file: $AAB_PATH${NC}"
echo -e "${BLUE}4. Fill in app information and metadata${NC}"
echo -e "${BLUE}5. Submit for review${NC}"
echo ""
echo -e "${BLUE}📚 See GOOGLE_PLAY_PUBLISH.md for detailed instructions${NC}"
echo ""
echo -e "${GREEN}🚀 Your app is ready for Google Play Store!${NC}"


