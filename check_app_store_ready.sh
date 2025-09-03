#!/bin/bash

# TaxLien.online App Store Readiness Check
# This script checks if the app is ready for App Store publication

set -e

echo "🔍 Checking TaxLien.online readiness for App Store publication..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
WARNINGS=0
ERRORS=0

# Function to add check result
add_check() {
    local result=$1
    local message=$2
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    case $result in
        "PASS")
            echo -e "${GREEN}✅ $message${NC}"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
            ;;
        "WARN")
            echo -e "${YELLOW}⚠️  $message${NC}"
            WARNINGS=$((WARNINGS + 1))
            ;;
        "FAIL")
            echo -e "${RED}❌ $message${NC}"
            ERRORS=$((ERRORS + 1))
            ;;
    esac
}

# Check if we're in the Flutter project directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found. Make sure you are in the Flutter project root directory.${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Running readiness checks...${NC}"
echo ""

# 1. Check Flutter version
echo -e "${BLUE}🔍 Flutter Environment${NC}"
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -1)
    add_check "PASS" "Flutter installed: $FLUTTER_VERSION"
else
    add_check "FAIL" "Flutter not installed"
fi

# 2. Check Xcode
echo -e "${BLUE}🔍 Xcode${NC}"
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -1)
    add_check "PASS" "Xcode installed: $XCODE_VERSION"
else
    add_check "FAIL" "Xcode not installed"
fi

# 3. Check CocoaPods
echo -e "${BLUE}🔍 CocoaPods${NC}"
if command -v pod &> /dev/null; then
    POD_VERSION=$(pod --version)
    add_check "PASS" "CocoaPods installed: $POD_VERSION"
else
    add_check "FAIL" "CocoaPods not installed"
fi

# 4. Check project structure
echo -e "${BLUE}🔍 Project Structure${NC}"
if [ -d "ios" ]; then
    add_check "PASS" "iOS directory exists"
else
    add_check "FAIL" "iOS directory not found"
fi

if [ -d "ios/Runner.xcworkspace" ]; then
    add_check "PASS" "Xcode workspace exists"
else
    add_check "FAIL" "Xcode workspace not found"
fi

# 5. Check pubspec.yaml
echo -e "${BLUE}🔍 pubspec.yaml${NC}"
if [ -f "pubspec.yaml" ]; then
    VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //')
    add_check "PASS" "Version: $VERSION"
    
    # Check if version follows semantic versioning
    if [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$ ]]; then
        add_check "PASS" "Version format is correct"
    else
        add_check "WARN" "Version format should be X.Y.Z+BUILD"
    fi
else
    add_check "FAIL" "pubspec.yaml not found"
fi

# 6. Check iOS configuration
echo -e "${BLUE}🔍 iOS Configuration${NC}"
if [ -f "ios/Runner/Info.plist" ]; then
    add_check "PASS" "Info.plist exists"
    
    # Check display name
    if grep -q "CFBundleDisplayName" ios/Runner/Info.plist; then
        DISPLAY_NAME=$(grep -A1 "CFBundleDisplayName" ios/Runner/Info.plist | tail -1 | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
        add_check "PASS" "Display name: $DISPLAY_NAME"
    else
        add_check "WARN" "Display name not set"
    fi
    
    # Check bundle identifier
    if grep -q "CFBundleIdentifier" ios/Runner/Info.plist; then
        BUNDLE_ID=$(grep -A1 "CFBundleIdentifier" ios/Runner/Info.plist | tail -1 | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
        if [[ $BUNDLE_ID == *"$(PRODUCT_BUNDLE_IDENTIFIER)"* ]]; then
            add_check "PASS" "Bundle identifier uses variable"
        else
            add_check "WARN" "Bundle identifier: $BUNDLE_ID"
        fi
    else
        add_check "FAIL" "Bundle identifier not found"
    fi
else
    add_check "FAIL" "Info.plist not found"
fi

# 7. Check app icons
echo -e "${BLUE}🔍 App Icons${NC}"
if [ -d "ios/Runner/Assets.xcassets/AppIcon.appiconset" ]; then
    ICON_COUNT=$(find ios/Runner/Assets.xcassets/AppIcon.appiconset -name "*.png" | wc -l)
    if [ $ICON_COUNT -ge 20 ]; then
        add_check "PASS" "App icons: $ICON_COUNT (complete)"
    elif [ $ICON_COUNT -ge 10 ]; then
        add_check "WARN" "App icons: $ICON_COUNT (may be incomplete)"
    else
        add_check "FAIL" "App icons: $ICON_COUNT (incomplete)"
    fi
else
    add_check "FAIL" "App icons directory not found"
fi

# 8. Check launch screen
echo -e "${BLUE}🔍 Launch Screen${NC}"
if [ -f "ios/Runner/Base.lproj/LaunchScreen.storyboard" ]; then
    add_check "PASS" "Launch screen exists"
else
    add_check "WARN" "Launch screen not found"
fi

# 9. Check project.pbxproj
echo -e "${BLUE}🔍 Xcode Project${NC}"
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    add_check "PASS" "project.pbxproj exists"
    
    # Check for bundle identifier configuration
    if grep -q "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj; then
        add_check "PASS" "Bundle identifier configured in project"
    else
        add_check "WARN" "Bundle identifier not configured in project"
    fi
else
    add_check "FAIL" "project.pbxproj not found"
fi

# 10. Check dependencies
echo -e "${BLUE}🔍 Dependencies${NC}"
if [ -f "ios/Podfile.lock" ]; then
    add_check "PASS" "CocoaPods dependencies locked"
else
    add_check "WARN" "CocoaPods dependencies not locked"
fi

# 11. Check build scripts
echo -e "${BLUE}🔍 Build Scripts${NC}"
if [ -f "prepare_app_store.sh" ]; then
    add_check "PASS" "prepare_app_store.sh exists"
else
    add_check "WARN" "prepare_app_store.sh not found"
fi

if [ -f "build_and_upload.sh" ]; then
    add_check "PASS" "build_and_upload.sh exists"
else
    add_check "WARN" "build_and_upload.sh not found"
fi

# 12. Check for common issues
echo -e "${BLUE}🔍 Common Issues${NC}"

# Check for hardcoded paths
if grep -r "/Users/" ios/ 2>/dev/null | head -1; then
    add_check "WARN" "Hardcoded user paths found in iOS files"
else
    add_check "PASS" "No hardcoded user paths found"
fi

# Check for debug configurations
if grep -r "Debug" ios/Runner.xcodeproj/project.pbxproj | grep -q "Release"; then
    add_check "PASS" "Release configuration available"
else
    add_check "WARN" "Release configuration may not be properly configured"
fi

echo ""
echo -e "${BLUE}📊 Check Results Summary${NC}"
echo "=================================="
echo -e "Total checks: ${TOTAL_CHECKS}"
echo -e "Passed: ${GREEN}${PASSED_CHECKS}${NC}"
echo -e "Warnings: ${YELLOW}${WARNINGS}${NC}"
echo -e "Errors: ${RED}${ERRORS}${NC}"

echo ""
if [ $ERRORS -eq 0 ]; then
    if [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}🎉 All checks passed! Your app is ready for App Store publication.${NC}"
    else
        echo -e "${YELLOW}⚠️  App is mostly ready but has some warnings to address.${NC}"
    fi
else
    echo -e "${RED}❌ App has errors that must be fixed before publication.${NC}"
fi

echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}1. Fix all errors above${NC}"
fi
if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}2. Address warnings (recommended)${NC}"
fi
echo -e "${BLUE}3. Run: ./prepare_app_store.sh${NC}"
echo -e "${BLUE}4. Open Xcode and configure signing${NC}"
echo -e "${BLUE}5. Run: ./build_and_upload.sh${NC}"

# Exit with error code if there are errors
if [ $ERRORS -gt 0 ]; then
    exit 1
fi
