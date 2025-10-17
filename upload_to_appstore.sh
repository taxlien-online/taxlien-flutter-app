#!/bin/bash

# Upload IPA to App Store Connect
# Version: 4.0.3

set -e

echo "======================================"
echo "  App Store Upload Script"
echo "  Version: 4.0.3"
echo "======================================"
echo ""

IPA_PATH="build/ios/ipa/taxlien.online.ipa"

# Check if IPA exists
if [ ! -f "$IPA_PATH" ]; then
    echo "❌ Error: IPA file not found at $IPA_PATH"
    echo "Please run: flutter build ipa --release"
    exit 1
fi

echo "✅ IPA file found: $IPA_PATH"
echo "   Size: $(du -h "$IPA_PATH" | cut -f1)"
echo ""

# Method 1: Apple Transporter (Recommended)
echo "📦 Method 1: Apple Transporter (Recommended)"
echo "------------------------------------"
if [ -d "/Applications/Transporter.app" ]; then
    echo "✅ Apple Transporter is installed"
    echo ""
    read -p "Do you want to open Transporter now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 Opening Transporter..."
        open -a "Transporter"
        echo ""
        echo "Instructions:"
        echo "1. Drag and drop this file to Transporter:"
        echo "   $PWD/$IPA_PATH"
        echo "2. Sign in with your Apple ID"
        echo "3. Click 'Deliver' to upload"
        echo ""
        exit 0
    fi
else
    echo "⚠️  Transporter not installed"
    echo "Download it from: https://apps.apple.com/app/transporter/id1450874784"
    echo ""
fi

# Method 2: Command Line with API Key
echo ""
echo "📦 Method 2: Command Line Upload"
echo "------------------------------------"
echo "To upload via command line, you need an App Store Connect API Key"
echo ""
read -p "Do you have an API Key configured? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Please enter your credentials:"
    read -p "API Key ID: " API_KEY
    read -p "Issuer ID: " ISSUER_ID
    read -p "API Key file path (.p8): " API_KEY_FILE
    
    if [ -f "$API_KEY_FILE" ]; then
        echo ""
        echo "🚀 Uploading to App Store Connect..."
        xcrun altool --upload-app \
            --type ios \
            --file "$IPA_PATH" \
            --apiKey "$API_KEY" \
            --apiIssuer "$ISSUER_ID"
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "✅ Upload successful!"
            echo ""
            echo "Next steps:"
            echo "1. Go to App Store Connect: https://appstoreconnect.apple.com"
            echo "2. Select your app"
            echo "3. Go to TestFlight"
            echo "4. Wait for processing (5-10 minutes)"
            echo "5. Submit for review"
        else
            echo ""
            echo "❌ Upload failed. Please check the error messages above."
            exit 1
        fi
    else
        echo "❌ API Key file not found: $API_KEY_FILE"
        exit 1
    fi
else
    echo ""
    echo "To create an API Key:"
    echo "1. Go to https://appstoreconnect.apple.com/access/api"
    echo "2. Click '+' to generate a new key"
    echo "3. Give it 'App Manager' or 'Developer' role"
    echo "4. Download the .p8 file"
    echo "5. Save the Key ID and Issuer ID"
    echo ""
fi

# Method 3: Manual Instructions
echo ""
echo "📦 Method 3: Manual Upload"
echo "------------------------------------"
echo ""
echo "1. Download Apple Transporter:"
echo "   https://apps.apple.com/app/transporter/id1450874784"
echo ""
echo "2. Open Transporter and sign in"
echo ""
echo "3. Drag and drop this file:"
echo "   $PWD/$IPA_PATH"
echo ""
echo "4. Click 'Deliver' to upload"
echo ""
echo "5. Go to App Store Connect and submit for review:"
echo "   https://appstoreconnect.apple.com"
echo ""

# Open IPA location in Finder
echo ""
read -p "Do you want to open IPA location in Finder? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open build/ios/ipa/
fi

echo ""
echo "======================================"
echo "  Build Information"
echo "======================================"
echo "Version: 4.0.3"
echo "Build: 22"
echo "Bundle ID: online.taxlien"
echo "IPA Size: $(du -h "$IPA_PATH" | cut -f1)"
echo "IPA Path: $PWD/$IPA_PATH"
echo ""
echo "✅ Ready for upload!"
echo ""

