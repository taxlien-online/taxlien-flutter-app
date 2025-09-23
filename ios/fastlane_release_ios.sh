#!/bin/bash

# TaxLien iOS Release Script
# This script automates the iOS release process using Fastlane

set -e  # Exit on any error

echo "🚀 Starting TaxLien iOS Release Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the Flutter project root directory."
    exit 1
fi

# Check if iOS directory exists
if [ ! -d "ios" ]; then
    print_error "iOS directory not found. This doesn't appear to be a Flutter project with iOS support."
    exit 1
fi

# Check if Fastlane is installed
if ! command -v fastlane &> /dev/null; then
    print_error "Fastlane is not installed. Please install it first:"
    echo "  gem install fastlane"
    exit 1
fi

# Check if we're in the iOS directory for Fastlane
cd ios

# Check if Fastlane is properly configured
if [ ! -f "fastlane/Fastfile" ]; then
    print_error "Fastlane configuration not found in ios/fastlane/"
    exit 1
fi

print_status "Fastlane configuration found. Starting release process..."

# Parse command line arguments
RELEASE_TYPE="release"
SUBMIT_FOR_REVIEW=false
AUTO_RELEASE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --beta)
            RELEASE_TYPE="beta"
            shift
            ;;
        --build)
            RELEASE_TYPE="build"
            shift
            ;;
        --submit)
            SUBMIT_FOR_REVIEW=true
            shift
            ;;
        --auto-release)
            AUTO_RELEASE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --beta              Build and upload to TestFlight"
            echo "  --build             Build for local testing only"
            echo "  --submit            Submit for App Store review"
            echo "  --auto-release      Automatically release after approval"
            echo "  --help              Show this help message"
            echo ""
            echo "Default: Full App Store release"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Set the appropriate Fastlane lane
case $RELEASE_TYPE in
    "beta")
        LANE="beta"
        print_status "Building for TestFlight (Beta) release..."
        ;;
    "build")
        LANE="build"
        print_status "Building for local testing..."
        ;;
    "release")
        LANE="release"
        print_status "Building for App Store release..."
        ;;
esac

# Run Fastlane
print_status "Running Fastlane lane: $LANE"

if fastlane $LANE; then
    print_success "Fastlane $LANE completed successfully!"
    
    # Additional actions based on release type
    if [ "$RELEASE_TYPE" = "release" ] && [ "$SUBMIT_FOR_REVIEW" = true ]; then
        print_status "Submitting app for review..."
        if fastlane submit; then
            print_success "App submitted for review successfully!"
        else
            print_error "Failed to submit app for review"
            exit 1
        fi
    fi
    
    if [ "$RELEASE_TYPE" = "release" ] && [ "$AUTO_RELEASE" = true ]; then
        print_status "Setting up automatic release after approval..."
        if fastlane release_auto; then
            print_success "Automatic release configured successfully!"
        else
            print_error "Failed to configure automatic release"
            exit 1
        fi
    fi
    
    print_success "🎉 iOS release process completed successfully!"
    print_status "Check App Store Connect for the uploaded build"
    
else
    print_error "Fastlane $LANE failed!"
    print_status "Check the logs above for error details"
    exit 1
fi

# Return to project root
cd ..

print_status "Release process completed. Returning to project root directory."
