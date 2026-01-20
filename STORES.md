# App Store Deployment Guide (CI/CD)

This document describes how to use the automated CI/CD pipelines to deploy the TAXLIEN.online mobile app to various global and regional app stores.

## 🚀 Build Workflows (By Platform)

Builds are now separated by platform. You can trigger them either by pushing a specific git tag or manually through the GitHub Actions tab.

| Platform | Workflow File | Trigger Tag | Artifacts |
|----------|---------------|-------------|-----------|
| **Android** | `build-android.yml` | `v*-android` | APK & AAB |
| **iOS** | `build-ios.yml` | `v*-ios` | IPA |
| **Windows** | `build-windows.yml` | `v*-windows` | EXE |
| **Linux** | `build-linux.yml` | `v*-linux` | Bundle |

## 🛠️ How to Trigger a Build

### 1. Using Git Tags (Recommended)
Push a tag matching the pattern for the desired platform. For example, to build version 4.0.3 for Android:
```bash
git tag v4.0.3-android
git push origin v4.0.3-android
```

### 2. Manual Trigger
1. Go to the **Actions** tab in the GitHub repository.
2. Select the specific build workflow from the left sidebar (e.g., "Build - Windows").
3. Click the **Run workflow** dropdown button.
4. Select the branch (usually `main`) and click **Run workflow**.

---

## 🔐 Required GitHub Secrets

To make the pipelines work, ensure the following secrets are configured in **Settings > Secrets and variables > Actions**:

### Shared Secrets (Android)
- `ANDROID_KEYSTORE_BASE64`: Base64 encoded `.keystore` file.
- `ANDROID_STORE_PASSWORD`: Keystore password.
- `ANDROID_KEY_PASSWORD`: Key password.

### Google Play Store
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`: Service account JSON key with "Release Manager" permissions.

### Apple App Store
- `APPLE_ID`: Your Apple Developer email.
- `APPLE_ID_PASSWORD`: App-specific password.
- `IOS_TEAM_ID`: Your Apple Team ID.
- `IOS_BUILD_CERTIFICATE_BASE64`: P12 certificate for signing.
- `IOS_P12_PASSWORD`: Password for the P12 certificate.
- `IOS_BUILD_PROVISION_PROFILE_BASE64`: Mobile provisioning profile.

### RuStore
- `RUSTORE_CREDENTIALS_JSON`: JSON credentials from RuStore Console.
- `RUSTORE_APP_ID`: Your unique Application ID in RuStore.

### Huawei AppGallery
- `HUAWEI_CLIENT_ID`: API Client ID from AppGallery Connect.
- `HUAWEI_CLIENT_SECRET`: API Client Secret.
- `HUAWEI_APP_ID`: Your App ID in Huawei AppGallery.

### Xiaomi & Samsung (Coming Soon)
- `XIAOMI_USER_ID` / `XIAOMI_API_KEY`
- `SAMSUNG_SERVICE_ACCOUNT_ID` / `SAMSUNG_PRIVATE_KEY`

---

## 📝 Important Notes
- **Versioning:** Ensure you increment the `version` in `pubspec.yaml` before every release. Most stores will reject a build with a duplicate version number.
- **Code Quality:** All deployment workflows depend on the `CI - Test & Quality` workflow. If tests fail, deployment will be blocked.
- **Artifacts:** Successfully built binaries are automatically uploaded to GitHub Actions Artifacts for each run.
