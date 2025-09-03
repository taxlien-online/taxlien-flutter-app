# Google Play Store Publication Guide for TaxLien.online

## Prerequisites

1. **Google Play Console Account**
   - Create a developer account at [Google Play Console](https://play.google.com/console)
   - Pay the one-time $25 registration fee
   - Complete account verification

2. **App Signing Setup**
   - Generate a keystore for app signing
   - Configure signing in your Android build

## Step 1: Prepare App Signing

### Generate Keystore
```bash
keytool -genkey -v -keystore taxlien-release-key.keystore -alias taxlien-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

### Create keystore.properties
Create `android/keystore.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=taxlien-key-alias
storeFile=../taxlien-release-key.keystore
```

## Step 2: Update Android Configuration

### Update build.gradle.kts
```kotlin
android {
    // ... existing config ...
    
    signingConfigs {
        create("release") {
            val keystoreProperties = Properties()
            val keystorePropertiesFile = rootProject.file("keystore.properties")
            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            minifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}
```

### Update AndroidManifest.xml
Add required permissions and metadata:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application
        android:label="TaxLien.online"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:allowBackup="false"
        android:fullBackupContent="false">
        
        <!-- ... existing activity config ... -->
        
        <meta-data
            android:name="com.google.android.gms.version"
            android:value="@integer/google_play_services_version" />
    </application>
</manifest>
```

## Step 3: Build Release APK

### Run Build Script
```bash
./build_apk.sh
```

Or manually:
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## Step 4: Google Play Console Setup

### 1. Create New App
- Go to [Google Play Console](https://play.google.com/console)
- Click "Create app"
- Choose "App" as app type
- Enter app name: "TaxLien.online"
- Select "Free" or "Paid" (recommend starting with free)
- Accept terms

### 2. App Information
- **App name**: TaxLien.online
- **Short description**: Mobile application for investing in tax liens
- **Full description**: 
```
TaxLien.online is your comprehensive mobile platform for investing in tax liens. 
Discover properties, analyze investment opportunities, and manage your portfolio 
with our intuitive mobile app. Access real-time data, advanced filtering, and 
secure transaction management for tax lien investments.
```
- **Category**: Finance
- **Tags**: tax liens, real estate, investment, finance

### 3. Content Rating
- Complete content rating questionnaire
- Get content rating certificate

### 4. Pricing & Distribution
- Set price (Free or Paid)
- Select countries for distribution
- Choose content guidelines compliance

### 5. App Release
- **Release name**: Production
- **Release notes**: Initial release of TaxLien.online mobile app
- Upload your APK file
- Review and roll out

## Step 5: Upload APK

### Via Google Play Console
1. Go to "Production" → "Create new release"
2. Upload APK file from `build/app/outputs/flutter-apk/app-release.apk`
3. Add release notes
4. Save and review release
5. Start rollout to production

### Via Google Play Console API (Optional)
For automated uploads, you can use the Google Play Console API.

## Step 6: App Store Listing

### Graphics Requirements
- **Feature graphic**: 1024 x 500 px
- **App icon**: 512 x 512 px
- **Screenshots**: 
  - Phone: 1080 x 1920 px (minimum 2, maximum 8)
  - 7-inch tablet: 1200 x 1920 px
  - 10-inch tablet: 1920 x 1200 px

### Content
- **App description**: Detailed description of features
- **What's new**: Release notes for each update
- **Keywords**: SEO-optimized keywords

## Step 7: Review Process

1. **Submit for review**
2. **Wait for Google review** (typically 1-3 days)
3. **Address any issues** if app is rejected
4. **Resubmit** if necessary

## Common Issues & Solutions

### App Rejection Reasons
- **Content policy violations**: Ensure app complies with Google Play policies
- **Technical issues**: Test thoroughly before submission
- **Metadata issues**: Provide accurate app information

### Performance Optimization
- APK size should be under 150MB for initial download
- Use App Bundle (AAB) for better optimization
- Implement proper ProGuard rules

## Maintenance

### Regular Updates
- Monitor crash reports
- Update app regularly
- Respond to user reviews
- Monitor performance metrics

### Version Management
- Increment version code for each release
- Use semantic versioning
- Maintain changelog

## Support Resources

- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Flutter Deployment Guide](https://flutter.dev/docs/deployment/android)
- [Google Play Policy Center](https://play.google.com/about/developer-content-policy/)

## Next Steps

1. Complete the keystore setup
2. Update Android configuration files
3. Build release APK
4. Create Google Play Console account
5. Submit app for review
6. Monitor and maintain

---

**Note**: This guide covers the basic publication process. For advanced features like in-app purchases, subscriptions, or ads, additional setup may be required.

