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
