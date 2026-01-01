#!/bin/bash

# Trial Mode Testing Script
# Quick test and run script for TaxLien.online trial functionality

echo "🎯 TaxLien.online - Trial Mode Testing"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check environment
echo -e "${BLUE}1. Checking environment...${NC}"
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    touch .env
fi
echo -e "${GREEN}✓ Environment ready${NC}"
echo ""

# Step 2: Run unit tests
echo -e "${BLUE}2. Running unit tests...${NC}"
flutter test test/trial_service_test.dart
echo ""

# Step 3: Check for lint errors
echo -e "${BLUE}3. Checking for lint errors...${NC}"
flutter analyze lib/services/trial_service.dart
flutter analyze lib/screens/paywall_screen.dart
flutter analyze lib/core/providers/subscription_provider.dart
echo ""

# Step 4: Build options
echo -e "${BLUE}4. Build and run options:${NC}"
echo ""
echo "Choose an option:"
echo "  1) Run on iOS Simulator"
echo "  2) Run on Android Emulator"
echo "  3) Build iOS (release)"
echo "  4) Build Android (release)"
echo "  5) Just show trial info"
echo "  6) Exit"
echo ""
read -p "Enter choice [1-6]: " choice

case $choice in
    1)
        echo -e "${YELLOW}Starting iOS Simulator...${NC}"
        flutter run -d iPhone
        ;;
    2)
        echo -e "${YELLOW}Starting Android Emulator...${NC}"
        flutter run -d emulator
        ;;
    3)
        echo -e "${YELLOW}Building iOS Release...${NC}"
        flutter build ios --release
        ;;
    4)
        echo -e "${YELLOW}Building Android Release...${NC}"
        flutter build appbundle --release
        ;;
    5)
        echo -e "${GREEN}Trial Mode Information:${NC}"
        echo ""
        echo "Trial Duration: 365 days (максимально долгий)"
        echo "Features: Full Premium access"
        echo "Storage: Local (SharedPreferences)"
        echo "One-time: Yes (can't restart)"
        echo ""
        echo "Product IDs:"
        echo "  - taxlien_premium_monthly"
        echo "  - taxlien_premium_yearly"
        echo "  - taxlien_enterprise_monthly"
        echo "  - taxlien_enterprise_yearly"
        echo ""
        echo "Documentation:"
        echo "  - TRIAL_MODE_README.md"
        echo "  - docs/TRIAL_AND_SUBSCRIPTIONS_SETUP.md"
        echo "  - TRIAL_IMPLEMENTATION_COMPLETE.md"
        ;;
    6)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✓ Done!${NC}"
echo ""
echo "📚 For more information, see:"
echo "   - TRIAL_MODE_README.md"
echo "   - docs/TRIAL_AND_SUBSCRIPTIONS_SETUP.md"
echo ""

