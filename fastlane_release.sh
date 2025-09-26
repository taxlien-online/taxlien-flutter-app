#!/bin/bash

# TaxLien.online Fastlane Release Script
# This script provides an easy way to release the app using fastlane

set -e

echo "🚀 TaxLien.online Fastlane Release Script"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="TaxLien.online"
FLUTTER_PROJECT_ROOT="$(pwd)"

# Check if we're in the Flutter project directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found. Make sure you are in the Flutter project root directory.${NC}"
    exit 1
fi

# Check if fastlane is installed
if ! command -v fastlane &> /dev/null; then
    echo -e "${RED}❌ Error: fastlane not found. Install fastlane first:${NC}"
    echo -e "${BLUE}   gem install fastlane${NC}"
    exit 1
fi

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Error: Flutter not found. Install Flutter and add it to your PATH.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites are met${NC}"

# Function to show usage
show_usage() {
    echo -e "${BLUE}Usage: $0 [OPTIONS] [PLATFORM] [TRACK]${NC}"
    echo ""
    echo -e "${BLUE}Platforms:${NC}"
    echo "  ios       - iOS App Store"
    echo "  android   - Google Play Store"
    echo "  all       - Both platforms"
    echo ""
    echo -e "${BLUE}Tracks:${NC}"
    echo "  release   - Production release"
    echo "  beta      - Beta/TestFlight release"
    echo "  alpha     - Alpha release (Android only)"
    echo "  build     - Build only (no upload)"
    echo ""
    echo -e "${BLUE}Options:${NC}"
    echo "  -h, --help     Show this help message"
    echo "  -c, --clean    Clean before building"
    echo "  -t, --test     Run tests before building"
    echo "  -d, --doctor   Run Flutter doctor"
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0 ios release          # Release iOS to App Store"
    echo "  $0 android beta         # Release Android to Beta track"
    echo "  $0 all release          # Release both platforms"
    echo "  $0 ios build            # Build iOS app only"
    echo "  $0 --clean --test ios release  # Clean, test, then release iOS"
}

# Parse command line arguments
CLEAN=false
TEST=false
DOCTOR=false
PLATFORM=""
TRACK=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -t|--test)
            TEST=true
            shift
            ;;
        -d|--doctor)
            DOCTOR=true
            shift
            ;;
        ios|android|all)
            PLATFORM="$1"
            shift
            ;;
        release|beta|alpha|build)
            TRACK="$1"
            shift
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# Validate arguments
if [ -z "$PLATFORM" ]; then
    echo -e "${RED}❌ Error: Platform is required${NC}"
    show_usage
    exit 1
fi

if [ -z "$TRACK" ]; then
    echo -e "${RED}❌ Error: Track is required${NC}"
    show_usage
    exit 1
fi

# Validate platform and track combination
if [ "$PLATFORM" = "ios" ] && [ "$TRACK" = "alpha" ]; then
    echo -e "${RED}❌ Error: iOS doesn't support alpha track${NC}"
    echo -e "${BLUE}💡 Use 'beta' for TestFlight instead${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Configuration:${NC}"
echo -e "${BLUE}  Platform: $PLATFORM${NC}"
echo -e "${BLUE}  Track: $TRACK${NC}"
echo -e "${BLUE}  Clean: $CLEAN${NC}"
echo -e "${BLUE}  Test: $TEST${NC}"
echo -e "${BLUE}  Doctor: $DOCTOR${NC}"
echo ""

# Run Flutter doctor if requested
if [ "$DOCTOR" = true ]; then
    echo -e "${BLUE}🔍 Running Flutter doctor...${NC}"
    flutter doctor
    echo ""
fi

# Clean if requested
if [ "$CLEAN" = true ]; then
    echo -e "${BLUE}🧹 Cleaning project...${NC}"
    flutter clean
    echo ""
fi

# Run tests if requested
if [ "$TEST" = true ]; then
    echo -e "${BLUE}🧪 Running tests...${NC}"
    flutter test
    echo ""
fi

# Generate localization files
echo -e "${BLUE}🌐 Generating localization files...${NC}"
flutter gen-l10n
echo ""

# Execute fastlane commands based on platform and track
case "$PLATFORM" in
    "ios")
        case "$TRACK" in
            "release")
                echo -e "${BLUE}🍎 Building and releasing iOS app to App Store...${NC}"
                fastlane ios release
                ;;
            "beta")
                echo -e "${BLUE}🍎 Building and releasing iOS app to TestFlight...${NC}"
                fastlane ios beta
                ;;
            "build")
                echo -e "${BLUE}🍎 Building iOS app...${NC}"
                fastlane ios build
                ;;
            *)
                echo -e "${RED}❌ Error: Invalid track '$TRACK' for iOS${NC}"
                exit 1
                ;;
        esac
        ;;
    "android")
        case "$TRACK" in
            "release")
                echo -e "${BLUE}🤖 Building and releasing Android app to Google Play Store...${NC}"
                fastlane android release
                ;;
            "beta")
                echo -e "${BLUE}🤖 Building and releasing Android app to Google Play Store Beta...${NC}"
                fastlane android beta
                ;;
            "alpha")
                echo -e "${BLUE}🤖 Building and releasing Android app to Google Play Store Alpha...${NC}"
                fastlane android alpha
                ;;
            "build")
                echo -e "${BLUE}🤖 Building Android app...${NC}"
                fastlane android build
                ;;
            *)
                echo -e "${RED}❌ Error: Invalid track '$TRACK' for Android${NC}"
                exit 1
                ;;
        esac
        ;;
    "all")
        case "$TRACK" in
            "release")
                echo -e "${BLUE}📱 Building and releasing both platforms...${NC}"
                fastlane release_all
                ;;
            "beta")
                echo -e "${BLUE}📱 Building and releasing both platforms to beta...${NC}"
                fastlane beta_all
                ;;
            "build")
                echo -e "${BLUE}📱 Building both platforms...${NC}"
                fastlane build_all
                ;;
            *)
                echo -e "${RED}❌ Error: Invalid track '$TRACK' for all platforms${NC}"
                exit 1
                ;;
        esac
        ;;
    *)
        echo -e "${RED}❌ Error: Invalid platform '$PLATFORM'${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Release completed successfully!${NC}"

# Show next steps based on track
case "$TRACK" in
    "release")
        if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "all" ]; then
            echo -e "${BLUE}🍎 iOS: Check App Store Connect for review status${NC}"
        fi
        if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "all" ]; then
            echo -e "${BLUE}🤖 Android: Check Google Play Console for review status${NC}"
        fi
        ;;
    "beta")
        if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "all" ]; then
            echo -e "${BLUE}🍎 iOS: Check TestFlight for beta testing${NC}"
        fi
        if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "all" ]; then
            echo -e "${BLUE}🤖 Android: Check Google Play Console Beta track${NC}"
        fi
        ;;
    "alpha")
        echo -e "${BLUE}🤖 Android: Check Google Play Console Alpha track${NC}"
        ;;
    "build")
        echo -e "${BLUE}📱 Build artifacts are ready for manual upload${NC}"
        ;;
esac

echo -e "${GREEN}✅ Done!${NC}"
