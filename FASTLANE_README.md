# TaxLien.online Fastlane Release Guide

This guide explains how to use fastlane for automated releases of the TaxLien.online mobile app to both iOS App Store and Google Play Store.

## Prerequisites

### Required Software
- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [fastlane](https://docs.fastlane.tools/getting-started/ios/setup/) installed globally
- [Xcode](https://developer.apple.com/xcode/) (for iOS releases)
- [Android Studio](https://developer.android.com/studio) (for Android releases)

### Required Accounts
- Apple Developer Account (for iOS releases)
- Google Play Console Account (for Android releases)

## Installation

### Install fastlane
```bash
# Install fastlane globally
gem install fastlane

# Or using Homebrew on macOS
brew install fastlane
```

### Verify Installation
```bash
fastlane --version
flutter --version
```

## Configuration

### iOS Configuration

1. **Apple Developer Account Setup**
   - Ensure your Apple Developer account is active
   - Your team ID is already configured: `6XT4R7V83F`
   - App ID: `online.taxlien`

2. **Xcode Setup**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Configure signing certificates and provisioning profiles
   - Ensure the bundle identifier matches: `online.taxlien`

3. **App Store Connect**
   - Create your app in App Store Connect
   - Configure app metadata, screenshots, and descriptions
   - Your App Store Connect Team ID: `120374799`

### Android Configuration

1. **Google Play Console Setup**
   - Create your app in Google Play Console
   - Package name: `com.taxlien.online.marketplace`
   - Configure app metadata, screenshots, and descriptions

2. **Service Account Setup**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one
   - Enable Google Play Developer API
   - Create a Service Account with the following roles:
     - Service Account User
     - Editor (or custom role with Play Console permissions)
   - Download the JSON key file
   - Place it as `android/google-play-service-account.json`

3. **Grant Permissions in Google Play Console**
   - Go to Google Play Console → Setup → API access
   - Link your Google Cloud project
   - Grant access to your Service Account with these permissions:
     - View app information and download bulk reports
     - Manage production releases
     - Manage testing track releases
     - View financial data, orders, and cancellation survey responses

## Usage

### Quick Start

The easiest way to release is using the provided script:

```bash
# Make the script executable (if not already done)
chmod +x fastlane_release.sh

# Release iOS to App Store
./fastlane_release.sh ios release

# Release Android to Google Play Store
./fastlane_release.sh android release

# Release both platforms
./fastlane_release.sh all release

# Beta release for iOS (TestFlight)
./fastlane_release.sh ios beta

# Beta release for Android
./fastlane_release.sh android beta

# Alpha release for Android
./fastlane_release.sh android alpha

# Build only (no upload)
./fastlane_release.sh ios build
./fastlane_release.sh android build
```

### Advanced Options

```bash
# Clean before building
./fastlane_release.sh --clean ios release

# Run tests before building
./fastlane_release.sh --test android release

# Run Flutter doctor
./fastlane_release.sh --doctor ios build

# Combine options
./fastlane_release.sh --clean --test --doctor all release
```

### Direct fastlane Commands

You can also use fastlane directly:

```bash
# iOS releases
fastlane ios release      # App Store
fastlane ios beta         # TestFlight
fastlane ios build        # Build only

# Android releases
fastlane android release  # Google Play Store
fastlane android beta     # Google Play Store Beta
fastlane android alpha    # Google Play Store Alpha
fastlane android build    # Build only

# Cross-platform
fastlane release_all      # Both platforms to production
fastlane beta_all         # Both platforms to beta
fastlane build_all        # Build both platforms
```

## Release Tracks

### iOS Tracks
- **release**: Production release to App Store
- **beta**: Beta release to TestFlight
- **build**: Build only, no upload

### Android Tracks
- **release**: Production release to Google Play Store
- **beta**: Beta release to Google Play Store Beta track
- **alpha**: Alpha release to Google Play Store Alpha track
- **build**: Build only, no upload

## Build Artifacts

### iOS
- **Development**: `ios/build/TaxLien-Development.ipa`
- **Beta**: `ios/build/TaxLien-Beta.ipa`
- **Production**: `ios/build/TaxLien.ipa`

### Android
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab`

## Troubleshooting

### Common Issues

1. **Flutter not found**
   ```bash
   # Add Flutter to your PATH
   export PATH="$PATH:/path/to/flutter/bin"
   ```

2. **fastlane not found**
   ```bash
   # Install fastlane
   gem install fastlane
   ```

3. **iOS signing issues**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Check signing certificates and provisioning profiles
   - Ensure your Apple Developer account is properly configured

4. **Android keystore issues**
   - Check `android/keystore.properties` file
   - Ensure keystore file exists: `android/taxlien-release-key.keystore`
   - Verify passwords in keystore.properties

5. **Google Play API issues**
   - Verify service account JSON file exists
   - Check permissions in Google Play Console
   - Ensure Google Play Developer API is enabled

### Debug Mode

Run fastlane in debug mode for more detailed output:

```bash
fastlane ios release --verbose
fastlane android release --verbose
```

### Clean Build

If you encounter build issues, try cleaning:

```bash
flutter clean
fastlane clean_all
```

## File Structure

```
taxlien-mobile-app/
├── fastlane/
│   ├── Fastfile          # Main fastlane configuration
│   └── Appfile           # App configuration
├── ios/
│   └── fastlane/
│       ├── Fastfile      # iOS-specific configuration
│       ├── Appfile       # iOS app configuration
│       └── metadata/     # App Store metadata
├── android/
│   └── fastlane/
│       ├── Fastfile      # Android-specific configuration
│       └── Appfile       # Android app configuration
├── fastlane_release.sh   # Release script
└── FASTLANE_README.md    # This file
```

## Best Practices

1. **Always test locally first**
   ```bash
   ./fastlane_release.sh ios build
   ./fastlane_release.sh android build
   ```

2. **Use beta/alpha tracks for testing**
   ```bash
   ./fastlane_release.sh ios beta
   ./fastlane_release.sh android alpha
   ```

3. **Keep your certificates and keystores secure**
   - Never commit keystore files to version control
   - Use environment variables for sensitive data
   - Regularly rotate certificates and keys

4. **Monitor release status**
   - Check App Store Connect for iOS releases
   - Check Google Play Console for Android releases

5. **Version management**
   - Update version in `pubspec.yaml`
   - fastlane will automatically increment build numbers

## Support

For issues with fastlane setup or releases:

1. Check the [fastlane documentation](https://docs.fastlane.tools/)
2. Review the [Flutter documentation](https://flutter.dev/docs)
3. Check platform-specific guides:
   - [iOS App Store](https://docs.fastlane.tools/actions/upload_to_app_store/)
   - [Google Play Store](https://docs.fastlane.tools/actions/upload_to_play_store/)

## Security Notes

- Never commit sensitive files (keystores, certificates, service account JSON)
- Use environment variables for passwords and API keys
- Regularly rotate your certificates and keys
- Keep your fastlane and Flutter installations up to date
