#!/bin/bash

# TaxLien Mobile App - Android Build and Run Script
# This script builds and runs the Flutter app on Android device

set -e

echo "🚀 Starting TaxLien Mobile App Android build and run process..."

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

# Check if Flutter is installed
check_flutter() {
    print_status "Checking Flutter installation..."
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed. Please install Flutter first."
        print_status "Visit: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    
    flutter_version=$(flutter --version | head -n 1)
    print_success "Flutter found: $flutter_version"
}

# Check if Android SDK is configured
check_android_sdk() {
    print_status "Checking Android SDK configuration..."
    
    if [ -z "$ANDROID_HOME" ]; then
        print_warning "ANDROID_HOME is not set. Trying to detect Android SDK..."
        
        # Common Android SDK locations
        possible_paths=(
            "$HOME/Android/Sdk"
            "$HOME/Library/Android/sdk"
            "/usr/local/android-sdk"
            "/opt/android-sdk"
        )
        
        for path in "${possible_paths[@]}"; do
            if [ -d "$path" ]; then
                export ANDROID_HOME="$path"
                print_success "Android SDK found at: $path"
                break
            fi
        done
        
        if [ -z "$ANDROID_HOME" ]; then
            print_error "Android SDK not found. Please install Android Studio and configure ANDROID_HOME."
            exit 1
        fi
    else
        print_success "Android SDK found at: $ANDROID_HOME"
    fi
}

# Check if Android device is connected
check_android_device() {
    print_status "Checking for connected Android devices..."
    
    # Check if adb is available
    if ! command -v adb &> /dev/null; then
        print_error "ADB not found. Please install Android SDK Platform Tools."
        exit 1
    fi
    
    # Get list of connected devices
    devices=$(adb devices | grep -v "List of devices" | grep -v "^$" | wc -l)
    
    if [ "$devices" -eq 0 ]; then
        print_warning "No Android devices found. Please connect a device or start an emulator."
        print_status "Starting Android emulator..."
        
        # Try to start an emulator
        if command -v emulator &> /dev/null; then
            # List available AVDs
            avds=$(emulator -list-avds | head -n 1)
            if [ -n "$avds" ]; then
                print_status "Starting emulator: $avds"
                emulator -avd "$avds" &
                sleep 30  # Wait for emulator to start
            else
                print_error "No Android Virtual Devices found. Please create an AVD in Android Studio."
                exit 1
            fi
        else
            print_error "Android emulator not found. Please install Android Studio."
            exit 1
        fi
    else
        print_success "Android device found and connected"
    fi
}

# Clean and get dependencies
setup_project() {
    print_status "Setting up Flutter project..."
    
    # Clean previous builds
    print_status "Cleaning previous builds..."
    flutter clean
    
    # Get dependencies
    print_status "Getting Flutter dependencies..."
    flutter pub get
    
    print_success "Project setup completed"
}

# Build and run the app
build_and_run() {
    print_status "Building and running the app on Android..."
    
    # Check if device is ready
    devices=$(adb devices | grep -v "List of devices" | grep -v "^$" | wc -l)
    if [ "$devices" -eq 0 ]; then
        print_error "No Android devices available for deployment"
        exit 1
    fi
    
    # Run the app
    print_status "Deploying app to Android device..."
    flutter run --release
    
    print_success "App deployed successfully!"
}

# Build APK for distribution
build_apk() {
    print_status "Building APK for distribution..."
    
    # Build release APK
    flutter build apk --release
    
    # Get APK path
    apk_path="build/app/outputs/flutter-apk/app-release.apk"
    
    if [ -f "$apk_path" ]; then
        print_success "APK built successfully!"
        print_status "APK location: $apk_path"
        print_status "APK size: $(du -h "$apk_path" | cut -f1)"
        
        # Copy APK to project root for easy access
        cp "$apk_path" "taxlien-app-release.apk"
        print_success "APK copied to project root as: taxlien-app-release.apk"
    else
        print_error "APK build failed"
        exit 1
    fi
}

# Main execution
main() {
    print_status "TaxLien Mobile App - Android Build Script"
    print_status "=========================================="
    
    # Check prerequisites
    check_flutter
    check_android_sdk
    check_android_device
    
    # Setup project
    setup_project
    
    # Check command line arguments
    if [ "$1" = "apk" ]; then
        build_apk
    else
        build_and_run
    fi
    
    print_success "Process completed successfully!"
}

# Run main function
main "$@"
