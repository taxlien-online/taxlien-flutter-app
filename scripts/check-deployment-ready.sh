#!/bin/bash

# TaxLien.online - Universal Deployment Readiness Check
# Checks if the app is ready for deployment to both Google Play and App Store

set -e

echo "🔍 TaxLien.online - Deployment Readiness Check"
echo "=============================================="

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

echo -e "${BLUE}📋 Running deployment readiness checks...${NC}"
echo ""

# 1. Check Flutter environment
echo -e "${BLUE}🔍 Flutter Environment${NC}"
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -1)
    add_check "PASS" "Flutter installed: $FLUTTER_VERSION"
    
    # Check Flutter doctor
    if flutter doctor | grep -q "No issues found"; then
        add_check "PASS" "Flutter doctor: No issues found"
    else
        add_check "WARN" "Flutter doctor: Some issues found (check output)"
    fi
else
    add_check "FAIL" "Flutter not installed"
fi

# 2. Check project structure
echo -e "${BLUE}🔍 Project Structure${NC}"
if [ -f "pubspec.yaml" ]; then
    VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //')
    add_check "PASS" "Version: $VERSION"
    
    # Check version format
    if [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$ ]]; then
        add_check "PASS" "Version format is correct (X.Y.Z+BUILD)"
    else
        add_check "WARN" "Version format should be X.Y.Z+BUILD"
    fi
else
    add_check "FAIL" "pubspec.yaml not found"
fi

# 3. Check Android setup
echo -e "${BLUE}🔍 Android Setup${NC}"
if [ -d "android" ]; then
    add_check "PASS" "Android directory exists"
    
    # Check keystore
    if [ -f "android/taxlien-release-key.keystore" ]; then
        add_check "PASS" "Android keystore exists"
    else
        add_check "FAIL" "Android keystore not found"
    fi
    
    # Check keystore.properties
    if [ -f "android/keystore.properties" ]; then
        if grep -q "YOUR_STORE_PASSWORD\|YOUR_KEY_PASSWORD" android/keystore.properties; then
            add_check "WARN" "Android keystore.properties has placeholder values"
        else
            add_check "PASS" "Android keystore.properties configured"
        fi
    else
        add_check "FAIL" "Android keystore.properties not found"
    fi
    
    # Check build.gradle.kts
    if [ -f "android/app/build.gradle.kts" ]; then
        add_check "PASS" "Android build.gradle.kts exists"
    else
        add_check "FAIL" "Android build.gradle.kts not found"
    fi
else
    add_check "FAIL" "Android directory not found"
fi

# 4. Check iOS setup
echo -e "${BLUE}🔍 iOS Setup${NC}"
if [ -d "ios" ]; then
    add_check "PASS" "iOS directory exists"
    
    # Check Xcode workspace
    if [ -d "ios/Runner.xcworkspace" ]; then
        add_check "PASS" "Xcode workspace exists"
    else
        add_check "FAIL" "Xcode workspace not found"
    fi
    
    # Check Info.plist
    if [ -f "ios/Runner/Info.plist" ]; then
        add_check "PASS" "Info.plist exists"
        
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
    
    # Check app icons
    if [ -d "ios/Runner/Assets.xcassets/AppIcon.appiconset" ]; then
        ICON_COUNT=$(find ios/Runner/Assets.xcassets/AppIcon.appiconset -name "*.png" | wc -l)
        if [ $ICON_COUNT -ge 20 ]; then
            add_check "PASS" "iOS app icons: $ICON_COUNT (complete)"
        elif [ $ICON_COUNT -ge 10 ]; then
            add_check "WARN" "iOS app icons: $ICON_COUNT (may be incomplete)"
        else
            add_check "FAIL" "iOS app icons: $ICON_COUNT (incomplete)"
        fi
    else
        add_check "FAIL" "iOS app icons directory not found"
    fi
    
    # Check CocoaPods
    if [ -f "ios/Podfile.lock" ]; then
        add_check "PASS" "CocoaPods dependencies locked"
    else
        add_check "WARN" "CocoaPods dependencies not locked"
    fi
else
    add_check "FAIL" "iOS directory not found"
fi

# 5. Check CI/CD setup
echo -e "${BLUE}🔍 CI/CD Setup${NC}"
if [ -d ".github/workflows" ]; then
    add_check "PASS" "GitHub Actions workflows directory exists"
    if [ -f ".github/workflows/ci-cd.yml" ]; then
        add_check "PASS" "GitHub Actions CI/CD workflow exists"
    else
        add_check "WARN" "GitHub Actions CI/CD workflow not found"
    fi
elif [ -f ".gitlab-ci.yml" ]; then
    add_check "PASS" "GitLab CI/CD configuration exists"
else
    add_check "WARN" "No CI/CD configuration found"
fi

# 6. Check secrets configuration
echo -e "${BLUE}🔍 Secrets Configuration${NC}"
if [ -f ".env.secrets.template" ]; then
    add_check "PASS" "Secrets template exists"
else
    add_check "WARN" "Secrets template not found"
fi

# Check for base64 encoded files
if [ -f "android-keystore-base64.txt" ]; then
    add_check "PASS" "Android keystore base64 file exists"
else
    add_check "WARN" "Android keystore base64 file not found"
fi

# 7. Check localization
echo -e "${BLUE}🔍 Localization${NC}"
if [ -d "lib/l10n" ]; then
    add_check "PASS" "Localization directory exists"
    
    # Check for ARB files
    ARB_COUNT=$(find lib/l10n -name "*.arb" | wc -l)
    if [ $ARB_COUNT -gt 0 ]; then
        add_check "PASS" "Localization files: $ARB_COUNT ARB files"
    else
        add_check "WARN" "No ARB localization files found"
    fi
else
    add_check "WARN" "Localization directory not found"
fi

# 8. Check build scripts
echo -e "${BLUE}🔍 Build Scripts${NC}"
if [ -f "build_google_play.sh" ]; then
    add_check "PASS" "Google Play build script exists"
else
    add_check "WARN" "Google Play build script not found"
fi

if [ -f "build_ipa.sh" ]; then
    add_check "PASS" "iOS build script exists"
else
    add_check "WARN" "iOS build script not found"
fi

if [ -f "upload_to_play_store.sh" ]; then
    add_check "PASS" "Google Play upload script exists"
else
    add_check "WARN" "Google Play upload script not found"
fi

# 9. Check dependencies
echo -e "${BLUE}🔍 Dependencies${NC}"
if [ -f "pubspec.lock" ]; then
    add_check "PASS" "Dependencies locked in pubspec.lock"
else
    add_check "WARN" "Dependencies not locked"
fi

# 10. Check for common issues
echo -e "${BLUE}🔍 Common Issues${NC}"

# Check for hardcoded paths
if grep -r "/Users/" ios/ 2>/dev/null | head -1; then
    add_check "WARN" "Hardcoded user paths found in iOS files"
else
    add_check "PASS" "No hardcoded user paths found"
fi

# Check for debug configurations
if grep -r "Debug" android/app/build.gradle.kts 2>/dev/null | grep -q "Release"; then
    add_check "PASS" "Release configuration available"
else
    add_check "WARN" "Release configuration may not be properly configured"
fi

# Check app size
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    add_check "PASS" "Release APK exists: $APK_SIZE"
else
    add_check "WARN" "Release APK not found (run build first)"
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
        echo -e "${GREEN}🎉 All checks passed! Your app is ready for deployment.${NC}"
        DEPLOYMENT_READY=true
    else
        echo -e "${YELLOW}⚠️  App is mostly ready but has some warnings to address.${NC}"
        DEPLOYMENT_READY=true
    fi
else
    echo -e "${RED}❌ App has errors that must be fixed before deployment.${NC}"
    DEPLOYMENT_READY=false
fi

echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}1. Fix all errors above${NC}"
fi
if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}2. Address warnings (recommended)${NC}"
fi

if [ "$DEPLOYMENT_READY" = true ]; then
    echo -e "${GREEN}3. Run: ./scripts/setup-ci-cd.sh (if not done already)${NC}"
    echo -e "${GREEN}4. Configure secrets in your CI/CD platform${NC}"
    echo -e "${GREEN}5. Run: ./deploy.sh to trigger deployment${NC}"
else
    echo -e "${RED}3. Fix all errors before proceeding with deployment${NC}"
fi

# Exit with error code if there are errors
if [ $ERRORS -gt 0 ]; then
    exit 1
fi
