#!/bin/bash

# TaxLien.online - Universal CI/CD Setup Script
# Supports both GitHub Actions and GitLab CI/CD

set -e

echo "🚀 TaxLien.online - Universal CI/CD Setup"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="TaxLien.online"
PACKAGE_NAME="taxlien.online"

# Detect CI/CD platform
detect_platform() {
    if [ -d ".github/workflows" ]; then
        echo "GitHub"
    elif [ -f ".gitlab-ci.yml" ]; then
        echo "GitLab"
    elif [ -d ".github" ]; then
        echo "GitHub"
    else
        echo "Unknown"
    fi
}

PLATFORM=$(detect_platform)

echo -e "${BLUE}📋 Detected platform: $PLATFORM${NC}"

# Function to create secrets template
create_secrets_template() {
    local platform=$1
    
    echo -e "${BLUE}📝 Creating secrets template for $platform...${NC}"
    
    if [ "$platform" = "GitHub" ]; then
        cat > .env.secrets.template << 'EOF'
# GitHub Secrets Template
# Add these secrets in GitHub Repository Settings > Secrets and variables > Actions

# Android Signing
ANDROID_KEYSTORE_BASE64=                    # Base64 encoded keystore file
ANDROID_STORE_PASSWORD=                     # Keystore password
ANDROID_KEY_PASSWORD=                       # Key password

# Google Play Store API
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON=           # Service account JSON for Google Play API

# iOS Signing
IOS_BUILD_CERTIFICATE_BASE64=               # Base64 encoded .p12 certificate
IOS_P12_PASSWORD=                           # Certificate password
IOS_BUILD_PROVISION_PROFILE_BASE64=         # Base64 encoded provisioning profile
IOS_KEYCHAIN_PASSWORD=                      # Keychain password
IOS_TEAM_ID=                                # Apple Developer Team ID

# App Store Connect
APPLE_ID=                                   # Apple ID email
APPLE_ID_PASSWORD=                          # App-specific password

# Optional: GitLab Token (if using GitLab)
GITLAB_TOKEN=                               # GitLab personal access token
EOF
    elif [ "$platform" = "GitLab" ]; then
        cat > .env.secrets.template << 'EOF'
# GitLab CI/CD Variables Template
# Add these variables in GitLab Project Settings > CI/CD > Variables

# Android Signing
ANDROID_KEYSTORE_BASE64=                    # Base64 encoded keystore file
ANDROID_STORE_PASSWORD=                     # Keystore password
ANDROID_KEY_PASSWORD=                       # Key password

# Google Play Store API
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON=           # Service account JSON for Google Play API

# iOS Signing (requires macOS runner)
IOS_BUILD_CERTIFICATE_BASE64=               # Base64 encoded .p12 certificate
IOS_P12_PASSWORD=                           # Certificate password
IOS_BUILD_PROVISION_PROFILE_BASE64=         # Base64 encoded provisioning profile
IOS_KEYCHAIN_PASSWORD=                      # Keychain password
IOS_TEAM_ID=                                # Apple Developer Team ID

# App Store Connect
APPLE_ID=                                   # Apple ID email
APPLE_ID_PASSWORD=                          # App-specific password

# GitLab Token
GITLAB_TOKEN=                               # GitLab personal access token
EOF
    fi
    
    echo -e "${GREEN}✅ Secrets template created: .env.secrets.template${NC}"
}

# Function to setup Android keystore
setup_android_keystore() {
    echo -e "${BLUE}🔐 Setting up Android keystore...${NC}"
    
    KEYSTORE_FILE="android/taxlien-release-key.keystore"
    KEYSTORE_PROPERTIES="android/keystore.properties"
    
    if [ ! -f "$KEYSTORE_FILE" ]; then
        echo -e "${YELLOW}⚠️  Keystore not found. Creating new keystore...${NC}"
        echo -e "${BLUE}📝 Please provide the following information:${NC}"
        
        read -p "Enter keystore password: " STORE_PASSWORD
        read -p "Enter key password (can be same as keystore): " KEY_PASSWORD
        read -p "Enter your name: " NAME
        read -p "Enter your organization: " ORGANIZATION
        read -p "Enter your city: " CITY
        read -p "Enter your state: " STATE
        read -p "Enter your country code (e.g., US): " COUNTRY
        
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
        echo -e "${GREEN}✅ Keystore already exists${NC}"
    fi
    
    # Create keystore.properties template
    if [ ! -f "$KEYSTORE_PROPERTIES" ]; then
        cat > "$KEYSTORE_PROPERTIES" << EOF
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=taxlien-key-alias
storeFile=../taxlien-release-key.keystore
EOF
        echo -e "${YELLOW}⚠️  Please update passwords in $KEYSTORE_PROPERTIES${NC}"
    fi
}

# Function to generate base64 encoded files
generate_base64_files() {
    echo -e "${BLUE}📦 Generating base64 encoded files for CI/CD...${NC}"
    
    # Android keystore
    if [ -f "android/taxlien-release-key.keystore" ]; then
        base64 -i android/taxlien-release-key.keystore -o android-keystore-base64.txt
        echo -e "${GREEN}✅ Android keystore base64: android-keystore-base64.txt${NC}"
    fi
    
    # iOS certificate (if exists)
    if [ -f "ios-certificate.p12" ]; then
        base64 -i ios-certificate.p12 -o ios-certificate-base64.txt
        echo -e "${GREEN}✅ iOS certificate base64: ios-certificate-base64.txt${NC}"
    fi
    
    # iOS provisioning profile (if exists)
    if [ -f "ios-provisioning-profile.mobileprovision" ]; then
        base64 -i ios-provisioning-profile.mobileprovision -o ios-provisioning-profile-base64.txt
        echo -e "${GREEN}✅ iOS provisioning profile base64: ios-provisioning-profile-base64.txt${NC}"
    fi
}

# Function to create Google Play Service Account setup guide
create_google_play_guide() {
    echo -e "${BLUE}📚 Creating Google Play API setup guide...${NC}"
    
    cat > GOOGLE_PLAY_API_SETUP.md << 'EOF'
# Google Play Console API Setup Guide

## Step 1: Create Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project or create a new one
3. Navigate to "IAM & Admin" → "Service Accounts"
4. Click "Create Service Account"
5. Fill in:
   - Name: `taxlien-play-store-uploader`
   - Description: `Service account for TaxLien.online Play Store uploads`
6. Click "Create and Continue"
7. Roles: `Editor` (or `Service Account User`)
8. Click "Done"

## Step 2: Create JSON Key

1. Find the created service account
2. Click on it
3. Go to "Keys" → "Add Key" → "Create new key"
4. Choose "JSON"
5. Download the file and rename to `google-play-service-account.json`
6. Place the file in the project root

## Step 3: Configure Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to "Setup" → "API access"
4. Click "Link project" (if project not linked)
5. Find your service account
6. Click "Grant access"
7. Select permissions:
   - ✅ View app information and download bulk reports
   - ✅ Manage production releases
   - ✅ Manage testing track releases
   - ✅ View financial data, orders, and cancellation survey responses
8. Click "Invite user"

## Step 4: Add to CI/CD

Copy the contents of `google-play-service-account.json` and add it as a secret:
- **GitHub**: Repository Settings > Secrets and variables > Actions > `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- **GitLab**: Project Settings > CI/CD > Variables > `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
EOF

    echo -e "${GREEN}✅ Google Play API setup guide created: GOOGLE_PLAY_API_SETUP.md${NC}"
}

# Function to create iOS setup guide
create_ios_setup_guide() {
    echo -e "${BLUE}📚 Creating iOS setup guide...${NC}"
    
    cat > IOS_SETUP_GUIDE.md << 'EOF'
# iOS App Store Connect Setup Guide

## Step 1: Apple Developer Account

1. Ensure you have an active Apple Developer Program membership ($99/year)
2. Access to App Store Connect
3. Access to Xcode

## Step 2: Create Certificates

1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to "Certificates, Identifiers & Profiles"
3. Create a new certificate:
   - Type: "iOS Distribution"
   - Upload CSR from Keychain Access
   - Download the certificate

## Step 3: Create Provisioning Profile

1. In Apple Developer Portal, go to "Profiles"
2. Create new profile:
   - Type: "App Store"
   - Select your app ID
   - Select your distribution certificate
   - Download the profile

## Step 4: Convert to Base64

```bash
# Certificate
base64 -i your-certificate.p12 -o ios-certificate-base64.txt

# Provisioning Profile
base64 -i your-profile.mobileprovision -o ios-provisioning-profile-base64.txt
```

## Step 5: Add to CI/CD

Add these as secrets:
- **GitHub**: Repository Settings > Secrets and variables > Actions
- **GitLab**: Project Settings > CI/CD > Variables

Required secrets:
- `IOS_BUILD_CERTIFICATE_BASE64`: Contents of ios-certificate-base64.txt
- `IOS_P12_PASSWORD`: Password for your .p12 certificate
- `IOS_BUILD_PROVISION_PROFILE_BASE64`: Contents of ios-provisioning-profile-base64.txt
- `IOS_KEYCHAIN_PASSWORD`: Random password for CI keychain
- `IOS_TEAM_ID`: Your Apple Developer Team ID
- `APPLE_ID`: Your Apple ID email
- `APPLE_ID_PASSWORD`: App-specific password (not your Apple ID password)
EOF

    echo -e "${GREEN}✅ iOS setup guide created: IOS_SETUP_GUIDE.md${NC}"
}

# Function to create deployment script
create_deployment_script() {
    echo -e "${BLUE}📝 Creating deployment script...${NC}"
    
    cat > deploy.sh << 'EOF'
#!/bin/bash

# TaxLien.online - Universal Deployment Script
# Supports both GitHub Actions and GitLab CI/CD

set -e

echo "🚀 TaxLien.online - Universal Deployment"
echo "========================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Detect platform
if [ -d ".github/workflows" ]; then
    PLATFORM="GitHub"
elif [ -f ".gitlab-ci.yml" ]; then
    PLATFORM="GitLab"
else
    echo -e "${RED}❌ No CI/CD platform detected${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Platform: $PLATFORM${NC}"

# Function to trigger GitHub Actions
trigger_github_actions() {
    echo -e "${BLUE}🚀 Triggering GitHub Actions...${NC}"
    
    # Check if we're on a release branch
    CURRENT_BRANCH=$(git branch --show-current)
    
    if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
        echo -e "${GREEN}✅ On main branch, CI/CD will run automatically${NC}"
        echo -e "${BLUE}📱 Check GitHub Actions tab for progress${NC}"
    else
        echo -e "${YELLOW}⚠️  Not on main branch. CI/CD will run on push to main${NC}"
        echo -e "${BLUE}💡 To trigger manually, push to main branch${NC}"
    fi
}

# Function to trigger GitLab CI
trigger_gitlab_ci() {
    echo -e "${BLUE}🚀 Triggering GitLab CI...${NC}"
    
    # Check if we're on a release branch
    CURRENT_BRANCH=$(git branch --show-current)
    
    if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
        echo -e "${GREEN}✅ On main branch, CI/CD will run automatically${NC}"
        echo -e "${BLUE}📱 Check GitLab CI/CD tab for progress${NC}"
    else
        echo -e "${YELLOW}⚠️  Not on main branch. CI/CD will run on push to main${NC}"
        echo -e "${BLUE}💡 To trigger manually, push to main branch${NC}"
    fi
}

# Main deployment logic
case $PLATFORM in
    "GitHub")
        trigger_github_actions
        ;;
    "GitLab")
        trigger_gitlab_ci
        ;;
    *)
        echo -e "${RED}❌ Unsupported platform: $PLATFORM${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}🎉 Deployment initiated!${NC}"
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "${YELLOW}1. Monitor CI/CD pipeline progress${NC}"
echo -e "${YELLOW}2. Check app stores for new releases${NC}"
echo -e "${YELLOW}3. Verify deployment success${NC}"
EOF

    chmod +x deploy.sh
    echo -e "${GREEN}✅ Deployment script created: deploy.sh${NC}"
}

# Main setup function
main() {
    echo -e "${BLUE}🔧 Setting up CI/CD for $PROJECT_NAME...${NC}"
    
    # Create necessary directories
    mkdir -p .github/workflows
    mkdir -p scripts
    
    # Setup Android keystore
    setup_android_keystore
    
    # Create secrets template
    create_secrets_template "$PLATFORM"
    
    # Generate base64 files
    generate_base64_files
    
    # Create setup guides
    create_google_play_guide
    create_ios_setup_guide
    
    # Create deployment script
    create_deployment_script
    
    echo -e "${GREEN}🎉 CI/CD setup completed!${NC}"
    echo ""
    echo -e "${BLUE}📋 Next steps:${NC}"
    echo -e "${YELLOW}1. Read .env.secrets.template and add secrets to your CI/CD platform${NC}"
    echo -e "${YELLOW}2. Follow GOOGLE_PLAY_API_SETUP.md for Google Play setup${NC}"
    echo -e "${YELLOW}3. Follow IOS_SETUP_GUIDE.md for iOS setup${NC}"
    echo -e "${YELLOW}4. Run ./deploy.sh to trigger deployment${NC}"
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo -e "${YELLOW}- .env.secrets.template - Secrets configuration${NC}"
    echo -e "${YELLOW}- GOOGLE_PLAY_API_SETUP.md - Google Play API setup${NC}"
    echo -e "${YELLOW}- IOS_SETUP_GUIDE.md - iOS setup guide${NC}"
    echo -e "${YELLOW}- deploy.sh - Deployment script${NC}"
}

# Run main function
main
