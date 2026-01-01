# Trial and Subscriptions Setup Guide

This guide explains how to set up the 365-day trial period and in-app subscriptions for TaxLien.online app.

## Overview

- **Trial Period**: 365 days (maximum duration, as requested)
- **Trial Features**: Full premium access during trial
- **Subscription Tiers**: Free, Trial, Premium, Enterprise
- **Payment Processing**: Via Apple App Store and Google Play Store

## Features by Tier

### Free Tier
- Browse tax liens
- View basic property information
- Access to educational content
- Limited search results (10 per day)

### Trial Tier (365 days)
- All Free features
- Unlimited search results
- Advanced filters and sorting
- Property analytics
- Investment calculator
- Save favorites (unlimited)
- Email alerts
- Premium support

### Premium Tier
- All Trial features
- Real-time bidding
- Portfolio management
- NFT integration
- Advanced analytics
- Priority support
- Mobile app access
- Export data (CSV, PDF)

### Enterprise Tier
- All Premium features
- Bulk operations
- API access
- Custom reports
- Dedicated account manager
- White-label options
- Multi-user support
- Advanced integrations

---

## iOS Setup (App Store Connect)

### Step 1: Create In-App Products

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Select your app (TaxLien.online)
3. Navigate to **Features** > **In-App Purchases**
4. Click **+** to create new subscription

### Step 2: Create Subscription Groups

Create a subscription group named "TaxLien Premium"

### Step 3: Add Subscription Products

Create the following auto-renewable subscriptions:

#### 1. Premium Monthly
- **Product ID**: `taxlien_premium_monthly`
- **Reference Name**: TaxLien Premium Monthly
- **Subscription Duration**: 1 Month
- **Price**: $29.99 (or your preferred price)
- **Free Trial**: Optional (we handle this in-app)

#### 2. Premium Yearly
- **Product ID**: `taxlien_premium_yearly`
- **Reference Name**: TaxLien Premium Yearly
- **Subscription Duration**: 1 Year
- **Price**: $299.99 (17% savings vs monthly)
- **Free Trial**: Optional

#### 3. Enterprise Monthly
- **Product ID**: `taxlien_enterprise_monthly`
- **Reference Name**: TaxLien Enterprise Monthly
- **Subscription Duration**: 1 Month
- **Price**: $99.99

#### 4. Enterprise Yearly
- **Product ID**: `taxlien_enterprise_yearly`
- **Reference Name**: TaxLien Enterprise Yearly
- **Subscription Duration**: 1 Year
- **Price**: $999.99 (17% savings)

### Step 4: Configure StoreKit Configuration (for testing)

1. In Xcode, create `Configuration.storekit` file:
   - File > New > File > StoreKit Configuration File
2. Add the subscription products with same IDs
3. Use this for local testing

### Step 5: iOS Capabilities

The app is already configured with the required capabilities in `ios/Runner/Runner.entitlements`:
- In-App Purchase capability is automatically enabled

---

## Android Setup (Google Play Console)

### Step 1: Create Subscription Products

1. Go to [Google Play Console](https://play.google.com/console/)
2. Select TaxLien.online app
3. Navigate to **Monetize** > **Products** > **Subscriptions**
4. Click **Create subscription**

### Step 2: Add Subscription Products

Create the following subscriptions:

#### 1. Premium Monthly
- **Product ID**: `taxlien_premium_monthly`
- **Name**: TaxLien Premium Monthly
- **Description**: Unlimited access to all premium features
- **Billing Period**: 1 month
- **Price**: $29.99
- **Free Trial**: Optional (we handle this in-app)
- **Grace Period**: 3 days (recommended)

#### 2. Premium Yearly
- **Product ID**: `taxlien_premium_yearly`
- **Name**: TaxLien Premium Yearly
- **Description**: Annual subscription with 17% savings
- **Billing Period**: 1 year
- **Price**: $299.99
- **Introductory Price**: Optional

#### 3. Enterprise Monthly
- **Product ID**: `taxlien_enterprise_monthly`
- **Name**: TaxLien Enterprise Monthly
- **Description**: Advanced features for power users
- **Billing Period**: 1 month
- **Price**: $99.99

#### 4. Enterprise Yearly
- **Product ID**: `taxlien_enterprise_yearly`
- **Name**: TaxLien Enterprise Yearly
- **Description**: Annual enterprise subscription
- **Billing Period**: 1 year
- **Price**: $999.99

### Step 3: Configure Billing

1. Activate subscriptions
2. Set up base plans
3. Configure offers (optional)
4. Enable subscription benefits

### Step 4: Testing

1. Add test accounts in Google Play Console
2. Use test tracks (Internal/Closed/Open) for testing purchases
3. Test subscription flow before production release

---

## App Implementation

The app includes the following files for trial and subscription management:

### Core Files

1. **`lib/services/trial_service.dart`**
   - Manages 365-day trial period
   - Handles subscription state
   - Processes in-app purchases

2. **`lib/core/constants/subscription_constants.dart`**
   - Product IDs
   - Trial configuration
   - Feature lists
   - Pricing information

3. **`lib/screens/paywall_screen.dart`**
   - Beautiful subscription UI
   - Trial activation
   - Package selection
   - Purchase flow

4. **`lib/core/providers/subscription_provider.dart`**
   - Riverpod state management
   - Trial status provider
   - Access control

5. **Localization Files**
   - `lib/l10n/app_en.arb` - English
   - `lib/l10n/app_ru.arb` - Russian
   - (Add other languages as needed)

### Usage in App

```dart
// Check if user has access
final hasAccess = ref.watch(hasAccessProvider);

// Show paywall if no access
if (!hasAccess) {
  Navigator.pushNamed(context, AppRouter.paywall);
}

// Start trial
final trialNotifier = ref.read(trialStatusProvider.notifier);
await trialNotifier.startTrial();

// Check trial status
final trialStatus = ref.watch(trialStatusProvider);
print('Days remaining: ${trialStatus.daysRemaining}');
```

---

## Trial Logic

### How It Works

1. **First Launch**: User can start 365-day trial
2. **During Trial**: Full premium access
3. **Trial End**: User must subscribe to continue premium features
4. **One-Time Only**: Trial can only be used once per device

### Trial Storage

Trial information is stored locally using `shared_preferences`:
- `trial_start_date`: When trial started
- `trial_end_date`: When trial expires
- `has_completed_trial`: Flag to prevent re-activation
- `subscription_tier`: Current tier (free, trial, premium, enterprise)

### Access Control

```dart
// User has access if:
// - Trial is active, OR
// - Has premium subscription, OR
// - Has enterprise subscription

bool get hasAccess => 
    isActive || 
    tier == SubscriptionTier.premium || 
    tier == SubscriptionTier.enterprise;
```

---

## Testing

### iOS Testing

1. Use Sandbox testers from App Store Connect
2. Sign out of App Store on device
3. Run app and test purchase
4. Use StoreKit testing in Xcode

### Android Testing

1. Add tester email to license testing in Google Play Console
2. Install app from Internal Test track
3. Test subscription purchase
4. Verify in Google Play Console

### Trial Testing

```dart
// For development only - reset trial (DON'T USE IN PRODUCTION)
final prefs = await SharedPreferences.getInstance();
await prefs.remove('trial_start_date');
await prefs.remove('trial_end_date');
await prefs.remove('has_completed_trial');
await prefs.remove('subscription_tier');
```

---

## Important Notes

1. **Maximum Trial**: Set to 365 days (1 year) as requested - максимально долгий период
2. **Product IDs**: Must match exactly in code and store consoles
3. **Pricing**: Update prices in subscription constants for display
4. **Legal**: Terms and Privacy Policy must be accessible from paywall
5. **Restore**: Always provide "Restore Purchases" option
6. **Testing**: Test thoroughly before production release

---

## Revenue Model

### Projected Monthly Revenue (example)

Assuming 10,000 active users:
- 5% convert to Premium Monthly: 500 × $29.99 = $14,995
- 3% convert to Premium Yearly: 300 × $24.99/mo = $7,497
- 1% convert to Enterprise: 100 × $99.99 = $9,999
- **Total**: ~$32,491/month

### Store Fees

- **Apple**: 15-30% commission
- **Google**: 15-30% commission
- **After Year 1**: Both reduce to 15% for subscriptions

---

## Support

For issues or questions:
- Check Apple/Google documentation
- Review Flutter in_app_purchase package docs
- Test in sandbox/test environments first
- Monitor store review guidelines

---

## Next Steps

1. ✅ Create subscription products in App Store Connect
2. ✅ Create subscription products in Google Play Console
3. ✅ Test subscriptions with sandbox accounts
4. ✅ Verify trial flow (365 days)
5. ✅ Test restore purchases
6. ✅ Submit for review
7. ✅ Monitor analytics and revenue

---

**Last Updated**: 2025-10-25
**Trial Period**: 365 days (максимально долгий)
**Status**: Ready for store configuration

