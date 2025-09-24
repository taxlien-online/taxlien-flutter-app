#!/bin/bash

# TaxLien.online Marketplace Launch Script
echo "🚀 Launching TaxLien.online Native Marketplace..."

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
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    flutter --version
    print_success "Flutter is available"
}

# Clean and get dependencies
setup_dependencies() {
    print_status "Setting up dependencies..."
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Generate localization files
    flutter gen-l10n
    
    # Run build_runner for code generation (if needed)
    if [ -f "pubspec.yaml" ] && grep -q "build_runner" pubspec.yaml; then
        print_status "Running build_runner..."
        flutter packages pub run build_runner build --delete-conflicting-outputs
    fi
    
    print_success "Dependencies setup completed"
}

# Check for available devices
check_devices() {
    print_status "Checking available devices..."
    flutter devices
    
    # Count available devices
    device_count=$(flutter devices | grep -c "•" || true)
    if [ "$device_count" -eq 0 ]; then
        print_warning "No devices found. Please connect a device or start an emulator."
        return 1
    fi
    
    print_success "$device_count device(s) available"
    return 0
}

# Build and run the app
run_app() {
    local target_device="$1"
    local mode="${2:-debug}"
    
    print_status "Building and running the app in $mode mode..."
    
    if [ "$mode" = "release" ]; then
        if [ -n "$target_device" ]; then
            flutter run --release -d "$target_device"
        else
            flutter run --release
        fi
    else
        if [ -n "$target_device" ]; then
            flutter run -d "$target_device"
        else
            flutter run
        fi
    fi
}

# Build APK for Android
build_apk() {
    print_status "Building APK for Android..."
    flutter build apk --release
    
    if [ $? -eq 0 ]; then
        print_success "APK built successfully!"
        print_status "APK location: build/app/outputs/flutter-apk/app-release.apk"
    else
        print_error "Failed to build APK"
        exit 1
    fi
}

# Build iOS (requires macOS)
build_ios() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "iOS build is only supported on macOS"
        exit 1
    fi
    
    print_status "Building iOS app..."
    flutter build ios --release
    
    if [ $? -eq 0 ]; then
        print_success "iOS build completed successfully!"
        print_status "Open ios/Runner.xcworkspace in Xcode to archive and distribute"
    else
        print_error "Failed to build iOS app"
        exit 1
    fi
}

# Doctor check
run_doctor() {
    print_status "Running Flutter doctor..."
    flutter doctor -v
}

# Show help
show_help() {
    echo "TaxLien.online Marketplace Launch Script"
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  run [device]     Run the app in debug mode (optionally specify device)"
    echo "  release [device] Run the app in release mode (optionally specify device)"
    echo "  build-apk        Build APK for Android"
    echo "  build-ios        Build iOS app (macOS only)"
    echo "  doctor           Run flutter doctor"
    echo "  setup            Setup dependencies only"
    echo "  help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 run                    # Run on default device"
    echo "  $0 run android           # Run on Android device/emulator"
    echo "  $0 run ios               # Run on iOS device/simulator"
    echo "  $0 release               # Run in release mode"
    echo "  $0 build-apk             # Build Android APK"
    echo "  $0 build-ios             # Build iOS app"
}

# Enhanced marketplace features info
show_features() {
    echo ""
    echo "🏪 TaxLien.online Native Marketplace Features:"
    echo "✅ Modern Material Design 3 UI"
    echo "✅ Magento API Integration"
    echo "✅ Enhanced Product Cards with Tax Lien Data"
    echo "✅ Advanced Search and Filtering"
    echo "✅ Category Navigation"
    echo "✅ Real-time Cart Management"
    echo "✅ Wishlist Functionality"
    echo "✅ Product Quick View"
    echo "✅ Infinite Scroll with Pagination"
    echo "✅ Pull-to-Refresh"
    echo "✅ Dark/Light Theme Support"
    echo "✅ Multi-language Support"
    echo "✅ Offline Capability"
    echo "✅ Secure Authentication"
    echo "✅ Performance Optimized"
    echo ""
}

# Main execution
main() {
    echo "=================================================="
    echo "🏛️  TaxLien.online Native Marketplace"
    echo "📱 Flutter Mobile Application"
    echo "=================================================="
    
    case "${1:-run}" in
        "run")
            check_flutter
            setup_dependencies
            if check_devices; then
                show_features
                run_app "$2" "debug"
            fi
            ;;
        "release")
            check_flutter
            setup_dependencies
            if check_devices; then
                show_features
                run_app "$2" "release"
            fi
            ;;
        "build-apk")
            check_flutter
            setup_dependencies
            build_apk
            ;;
        "build-ios")
            check_flutter
            setup_dependencies
            build_ios
            ;;
        "doctor")
            check_flutter
            run_doctor
            ;;
        "setup")
            check_flutter
            setup_dependencies
            print_success "Setup completed! You can now run the app."
            ;;
        "features")
            show_features
            ;;
        "help")
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
