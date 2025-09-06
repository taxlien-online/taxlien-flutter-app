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
