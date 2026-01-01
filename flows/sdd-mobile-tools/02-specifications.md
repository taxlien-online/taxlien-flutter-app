# Specifications: Mobile Tools (P0 - Market Finder + Sweet Spot Analyzer)

> Version: 1.0
> Status: DRAFT
> Last Updated: 2025-12-31
> Requirements: [01-requirements.md](01-requirements.md)

## Overview

This specification covers the detailed technical design for the first two standalone mobile tools (P0 priority):

1. **Tax Lien Market Finder** - State/county comparison tool
2. **Sweet Spot Property Analyzer** - Property filtering and analysis tool

Both tools share common infrastructure (auth, payments, analytics) and follow a freemium monetization model with clear upgrade paths to the main TAXLIEN.online Premium app.

**Target Platform:** iOS and Android (Flutter)
**Timeline:** 6-8 weeks to MVP launch
**Revenue Target:** $26K/month (conservative: 1,800 downloads combined)

---

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| **Flutter Mobile Apps** | Create | 2 new standalone apps with shared codebase |
| **Firebase Auth** | Modify | Unified authentication across tools |
| **Firebase Firestore** | Create | User profiles, favorites, usage tracking |
| **PostgreSQL (County Data)** | Read | Access existing county database |
| **RevenueCat** | Create | In-app purchase management |
| **Firebase Analytics** | Create | User behavior tracking, conversion funnels |
| **FastAPI Backend** | Modify | Extend existing API for tool-specific endpoints |
| **App Store Connect** | Create | 2 new app listings |
| **Google Play Console** | Create | 2 new app listings |

---

## Architecture

### High-Level Component Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    USER DEVICES                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐         ┌──────────────────┐         │
│  │  Market Finder   │         │  Sweet Spot      │         │
│  │  (Flutter App)   │         │  (Flutter App)   │         │
│  └────────┬─────────┘         └────────┬─────────┘         │
│           │                            │                    │
└───────────┼────────────────────────────┼────────────────────┘
            │                            │
            └──────────┬─────────────────┘
                       │
            ┌──────────▼─────────────┐
            │  Shared Infrastructure  │
            │  (Flutter Package)      │
            ├─────────────────────────┤
            │  - Auth Service         │
            │  - Payment Service      │
            │  - Analytics Service    │
            │  - API Client           │
            │  - Shared UI Components │
            └──────────┬──────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
┌───────▼──────┐ ┌────▼─────┐ ┌──────▼──────┐
│   Firebase   │ │ FastAPI  │ │ RevenueCat  │
│              │ │ Backend  │ │             │
├──────────────┤ ├──────────┤ ├─────────────┤
│ - Auth       │ │ - API    │ │ - IAP       │
│ - Firestore  │ │ - Data   │ │ - Subs      │
│ - Analytics  │ │ - Logic  │ │ - Receipts  │
└──────┬───────┘ └────┬─────┘ └─────────────┘
       │              │
       │      ┌───────▼────────┐
       │      │  PostgreSQL    │
       │      │  (County Data) │
       │      └────────────────┘
       │
┌──────▼──────────────┐
│    Firestore DB     │
├─────────────────────┤
│ - user_profiles     │
│ - favorites         │
│ - search_history    │
│ - usage_analytics   │
└─────────────────────┘
```

### Data Flow

#### Flow 1: User Authentication (Cross-Tool)

```
User opens App A (Market Finder)
     │
     ├─> Check Firebase Auth token
     │   ├─> Token exists & valid
     │   │   └─> Load user profile from Firestore
     │   │       └─> Navigate to Home Screen
     │   │
     │   └─> No token or expired
     │       └─> Show Sign In Screen
     │           ├─> Google Sign-In
     │           ├─> Apple Sign-In
     │           └─> Email/Password
     │               └─> Firebase Auth creates/authenticates user
     │                   └─> Create Firestore user profile
     │                       └─> Navigate to Home Screen
     │
User opens App B (Sweet Spot) → Auto-signed in (shared token!)
```

#### Flow 2: Freemium Feature Access

```
User tries to access Premium feature
     │
     ├─> Check RevenueCat subscription status
     │   ├─> Active subscription (Pro or Enterprise)
     │   │   └─> Grant access to feature
     │   │
     │   └─> No subscription or Free tier
     │       └─> Show Paywall Screen
     │           ├─> User taps "Upgrade to Pro"
     │           │   └─> RevenueCat purchase flow
     │           │       ├─> Success
     │           │       │   ├─> Update local subscription status
     │           │       │   ├─> Log conversion event (Firebase Analytics)
     │           │       │   ├─> Show success message
     │           │       │   └─> Grant feature access
     │           │       │
     │           │       └─> Failure
     │           │           └─> Show error, retry option
     │           │
     │           └─> User taps "Try Main App"
     │               └─> Deep link to TAXLIEN.online Premium
     │                   └─> Log upsell event (Analytics)
```

#### Flow 3: Data Fetching (Market Finder)

```
User searches for "Florida counties"
     │
     ├─> Client: Build query params
     │   └─> { state: "FL", sortBy: "roi", limit: 10 }
     │
     ├─> Client: Call API
     │   └─> GET /api/v1/counties?state=FL&sort=roi&limit=10
     │
     ├─> Backend: Check cache (Redis)
     │   ├─> Cache hit → Return cached data
     │   │
     │   └─> Cache miss
     │       ├─> Query PostgreSQL
     │       │   SELECT county_name, avg_roi, redemption_period, ...
     │       │   FROM counties
     │       │   WHERE state = 'FL'
     │       │   ORDER BY avg_roi DESC
     │       │   LIMIT 10;
     │       │
     │       ├─> Cache result (Redis, TTL: 1 hour)
     │       └─> Return JSON response
     │
     ├─> Client: Parse response
     │   └─> Update UI state (Provider/Bloc)
     │       └─> Render county cards in ListView
     │
     └─> User taps "Save Favorite"
         └─> POST /api/v1/favorites
             └─> Write to Firestore: /users/{uid}/favorites/{countyId}
                 └─> Log event: "favorite_added" (Analytics)
```

---

## Shared Infrastructure Specifications

### 1. Authentication Service

**File:** `shared_tools/lib/services/auth_service.dart`

```dart
/// Unified authentication service for all standalone tools
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Current authenticated user
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    // 1. Trigger Google Sign-In flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw AuthException('Google sign-in cancelled');

    // 2. Obtain auth details
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // 3. Create Firebase credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 4. Sign in to Firebase
    final userCredential = await _auth.signInWithCredential(credential);

    // 5. Create or update user profile
    await _ensureUserProfile(userCredential.user!);

    return userCredential;
  }

  /// Sign in with Apple
  Future<UserCredential> signInWithApple() async {
    // Similar flow to Google, using Apple auth provider
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential = await _auth.signInWithCredential(oauthCredential);
    await _ensureUserProfile(userCredential.user!);

    return userCredential;
  }

  /// Sign in with Email/Password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _ensureUserProfile(userCredential.user!);
    return userCredential;
  }

  /// Create account with Email/Password
  Future<UserCredential> createAccount(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _ensureUserProfile(userCredential.user!);
    return userCredential;
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  /// Ensure user profile exists in Firestore
  Future<void> _ensureUserProfile(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      // Create new user profile
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'tools_installed': [], // Track which tools user has
      });
    } else {
      // Update last login
      await userDoc.update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
```

**Firestore Schema:**

```
/users/{userId}
  ├─ uid: string
  ├─ email: string
  ├─ displayName: string | null
  ├─ photoURL: string | null
  ├─ createdAt: timestamp
  ├─ lastLoginAt: timestamp
  ├─ tools_installed: string[] ("market_finder", "sweet_spot", ...)
  └─ subscription_status: map
      ├─ tier: string ("free", "pro", "enterprise")
      ├─ tool: string ("market_finder", "sweet_spot", "main_app")
      ├─ expiresAt: timestamp | null
      └─ source: string ("ios", "android", "web")
```

---

### 2. Payment Service (RevenueCat Integration)

**File:** `shared_tools/lib/services/payment_service.dart`

```dart
/// In-app purchase and subscription management
class PaymentService {
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY';

  /// Initialize RevenueCat
  Future<void> initialize() async {
    await Purchases.setDebugLogsEnabled(true); // Disable in production
    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  /// Get available offerings
  Future<Offerings> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      throw PaymentException('Failed to load offerings: $e');
    }
  }

  /// Purchase a product
  Future<PurchaserInfo> purchase(Package package) async {
    try {
      final purchaserInfo = await Purchases.purchasePackage(package);

      // Log purchase event
      await FirebaseAnalytics.instance.logEvent(
        name: 'purchase',
        parameters: {
          'product_id': package.identifier,
          'price': package.storeProduct.priceString,
          'currency': package.storeProduct.currencyCode,
        },
      );

      return purchaserInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        throw PaymentCancelledException();
      } else {
        throw PaymentException('Purchase failed: ${e.message}');
      }
    }
  }

  /// Restore purchases
  Future<PurchaserInfo> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      throw PaymentException('Failed to restore purchases: $e');
    }
  }

  /// Get current subscription status
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();

      // Check active entitlements
      if (purchaserInfo.entitlements.all['pro']?.isActive == true) {
        return SubscriptionStatus(
          tier: SubscriptionTier.pro,
          isActive: true,
          expiresAt: purchaserInfo.entitlements.all['pro']!.expirationDate,
        );
      } else if (purchaserInfo.entitlements.all['enterprise']?.isActive == true) {
        return SubscriptionStatus(
          tier: SubscriptionTier.enterprise,
          isActive: true,
          expiresAt: purchaserInfo.entitlements.all['enterprise']!.expirationDate,
        );
      } else {
        return SubscriptionStatus(
          tier: SubscriptionTier.free,
          isActive: false,
          expiresAt: null,
        );
      }
    } catch (e) {
      // Default to free if check fails
      return SubscriptionStatus(
        tier: SubscriptionTier.free,
        isActive: false,
        expiresAt: null,
      );
    }
  }

  /// Check if user has access to feature
  Future<bool> hasAccess(String feature) async {
    final status = await getSubscriptionStatus();

    switch (feature) {
      case 'unlimited_searches':
      case 'all_counties':
      case 'export_csv':
        return status.tier != SubscriptionTier.free;

      case 'api_access':
      case 'bulk_operations':
        return status.tier == SubscriptionTier.enterprise;

      default:
        return true; // Default to allowing access
    }
  }
}

/// Subscription tiers
enum SubscriptionTier {
  free,
  pro,
  enterprise,
}

/// Subscription status model
class SubscriptionStatus {
  final SubscriptionTier tier;
  final bool isActive;
  final DateTime? expiresAt;

  SubscriptionStatus({
    required this.tier,
    required this.isActive,
    this.expiresAt,
  });

  bool get isPro => tier == SubscriptionTier.pro;
  bool get isEnterprise => tier == SubscriptionTier.enterprise;
  bool get isFree => tier == SubscriptionTier.free;
}
```

**RevenueCat Product Configuration:**

**Market Finder Products:**
```
PRODUCT_IDS:
  - market_finder_pro_monthly: $9.99/month
  - market_finder_pro_yearly: $99.99/year (save 17%)
  - market_finder_enterprise_yearly: $499.99/year

ENTITLEMENTS:
  - pro: Unlocks all 50 states, county data, favorites, export
  - enterprise: Adds API access, bulk operations, priority support
```

**Sweet Spot Analyzer Products:**
```
PRODUCT_IDS:
  - sweet_spot_pro_monthly: $19.99/month
  - sweet_spot_pro_yearly: $199.99/year (save 17%)
  - sweet_spot_enterprise_yearly: $499.99/year

ENTITLEMENTS:
  - pro: Unlimited properties, advanced filters, export, batch analysis
  - enterprise: API access, custom criteria, white-label reports
```

---

### 3. Analytics Service

**File:** `shared_tools/lib/services/analytics_service.dart`

```dart
/// Firebase Analytics wrapper
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Track screen view
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

  /// Track feature usage
  Future<void> logFeatureUsage(String featureName, {Map<String, dynamic>? params}) async {
    await _analytics.logEvent(
      name: 'feature_used',
      parameters: {
        'feature_name': featureName,
        ...?params,
      },
    );
  }

  /// Track paywall shown
  Future<void> logPaywallShown(String source) async {
    await _analytics.logEvent(
      name: 'paywall_shown',
      parameters: {
        'source': source, // e.g., "search_limit", "export_button", "county_detail"
      },
    );
  }

  /// Track conversion (Free → Pro)
  Future<void> logConversion(String fromTier, String toTier, double price) async {
    await _analytics.logEvent(
      name: 'conversion',
      parameters: {
        'from_tier': fromTier,
        'to_tier': toTier,
        'price': price,
        'currency': 'USD',
      },
    );
  }

  /// Track main app upsell
  Future<void> logMainAppUpsell(String source) async {
    await _analytics.logEvent(
      name: 'main_app_upsell_clicked',
      parameters: {
        'source': source, // e.g., "post_upgrade_message", "paywall_cta"
      },
    );
  }

  /// Track search query
  Future<void> logSearch(String query, int resultCount) async {
    await _analytics.logEvent(
      name: 'search',
      parameters: {
        'search_term': query,
        'result_count': resultCount,
      },
    );
  }

  /// Track favorite added
  Future<void> logFavoriteAdded(String itemType, String itemId) async {
    await _analytics.logEvent(
      name: 'favorite_added',
      parameters: {
        'item_type': itemType, // "county", "property"
        'item_id': itemId,
      },
    );
  }

  /// Track export
  Future<void> logExport(String format, int itemCount) async {
    await _analytics.logEvent(
      name: 'export',
      parameters: {
        'format': format, // "csv", "pdf"
        'item_count': itemCount,
      },
    );
  }

  /// Set user properties
  Future<void> setUserProperties({
    required String userId,
    String? subscriptionTier,
    List<String>? toolsInstalled,
  }) async {
    await _analytics.setUserId(id: userId);

    if (subscriptionTier != null) {
      await _analytics.setUserProperty(
        name: 'subscription_tier',
        value: subscriptionTier,
      );
    }

    if (toolsInstalled != null) {
      await _analytics.setUserProperty(
        name: 'tools_count',
        value: toolsInstalled.length.toString(),
      );
    }
  }
}
```

**Key Analytics Events to Track:**

| Event | Purpose | Triggers |
|-------|---------|----------|
| `screen_view` | User navigation | Every screen change |
| `feature_used` | Feature engagement | Search, filter, export, etc. |
| `paywall_shown` | Conversion funnel | Hit feature limit |
| `conversion` | Revenue tracking | Successful purchase |
| `main_app_upsell_clicked` | Cross-sell funnel | Deep link to main app |
| `search` | Content effectiveness | Every search query |
| `favorite_added` | Engagement | Save county/property |
| `export` | Premium feature usage | CSV/PDF export |

---

## Tool #1: Market Finder Specifications

### Overview

**Purpose:** Help investors find the best tax lien markets (states and counties) based on customizable criteria (ROI, redemption period, auction type).

**Monetization:**
- Free: Compare top 5 states only
- Pro ($9.99/month or $99.99/year): All 50 states, county-level data, favorites, export
- Enterprise ($499.99/year): API access, bulk export

### UI/UX Specifications

#### Screen 1: Home / Market Selector

**Layout:**
```
┌─────────────────────────────────────┐
│  Tax Lien Market Finder        [⚙]  │
├─────────────────────────────────────┤
│  Find Your Best Markets              │
│                                      │
│  ┌───────────────────────────────┐  │
│  │ 🔍 Search states or counties  │  │
│  └───────────────────────────────┘  │
│                                      │
│  Quick Filters:                      │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │ High │ │ Short│ │ Tax  │        │
│  │ ROI  │ │Period│ │ Lien │        │
│  └──────┘ └──────┘ └──────┘        │
│                                      │
│  Top Markets:                        │
│  ┌───────────────────────────────┐  │
│  │ 🏆 Arizona                     │  │
│  │ 16% ROI • 3 years • Tax Lien  │  │
│  │ ⭐ 4.5/5 investor rating       │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ 🏆 Florida                     │  │
│  │ 18% ROI • 2 years • Tax Deed  │  │
│  │ ⭐ 4.7/5 investor rating       │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ 🔒 Illinois (Pro Only)         │  │ ← Paywall indicator
│  │ Upgrade to see details         │  │
│  └───────────────────────────────┘  │
│                                      │
│  [View All States →]                 │
└─────────────────────────────────────┘
```

**Components:**
- `MarketSearchBar` - Autocomplete search with Algolia/Typesense
- `QuickFilterChips` - Preset filter buttons (High ROI, Short Period, etc.)
- `MarketCard` - Display state/county with key metrics
- `PaywallLockedCard` - Teaser for Pro features

**State Management:**
```dart
class MarketFinderState {
  List<Market> topMarkets;
  String? searchQuery;
  List<FilterCriteria> activeFilters;
  SubscriptionTier userTier;

  // Computed
  List<Market> get visibleMarkets {
    if (userTier == SubscriptionTier.free) {
      return topMarkets.take(5).toList(); // Limit to 5 for free users
    }
    return topMarkets;
  }
}
```

#### Screen 2: Market Detail (State Level)

**Layout:**
```
┌─────────────────────────────────────┐
│  ← Arizona                           │
├─────────────────────────────────────┤
│  ┌─────────────────────────────────┐│
│  │  16% Avg ROI                    ││
│  │  3 years redemption             ││
│  │  Tax Lien certificates          ││
│  │  [⭐ Add to Favorites]           ││
│  └─────────────────────────────────┘│
│                                      │
│  Key Metrics:                        │
│  ┌──────────┬──────────┬──────────┐ │
│  │   ROI    │  Period  │   Type   │ │
│  │   16%    │ 3 years  │Tax Lien  │ │
│  └──────────┴──────────┴──────────┘ │
│                                      │
│  Counties (15):                      │
│  ┌───────────────────────────────┐  │
│  │ Maricopa County               │  │
│  │ 18% ROI • $2.3M avg value     │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ Pima County                   │  │
│  │ 14% ROI • $1.8M avg value     │  │
│  └───────────────────────────────┘  │
│  ...                                 │
│                                      │
│  Resources:                          │
│  • State tax lien laws               │
│  • County contact directory          │
│  • Auction calendar                  │
│                                      │
│  [Export Market Report (Pro)]        │ ← Paywall
└─────────────────────────────────────┘
```

**Data Model:**
```dart
class Market {
  final String id;
  final String name; // "Arizona" or "Maricopa County, AZ"
  final MarketType type; // state, county
  final double avgROI;
  final int redemptionPeriodMonths;
  final LienType lienType; // taxLien, taxDeed, hybrid
  final double avgPropertyValue;
  final int auctionFrequencyDays;
  final double investorRating; // 0-5 stars
  final int reviewCount;
  final DateTime lastUpdated;

  // For states only
  final List<String>? countyIds;

  // For counties only
  final String? stateId;
  final String? auctionWebsite;
  final String? contactPhone;
}

enum MarketType { state, county }
enum LienType { taxLien, taxDeed, hybrid, redeemableDeed }
```

#### Screen 3: Compare Markets

**Layout:**
```
┌─────────────────────────────────────┐
│  ← Compare Markets                   │
├─────────────────────────────────────┤
│  Selected (2/4):                     │
│  [Arizona ×] [Florida ×] [+ Add]     │
│                                      │
│  ┌──────────┬──────────┬──────────┐ │
│  │ Metric   │ Arizona  │ Florida  │ │
│  ├──────────┼──────────┼──────────┤ │
│  │ ROI      │ 16% ✓    │ 18% ✓✓   │ │
│  │ Period   │ 3 years  │ 2 years✓ │ │
│  │ Type     │Tax Lien  │Tax Deed  │ │
│  │ Auction  │ Yearly   │Quarterly✓│ │
│  │ Rating   │ 4.5⭐    │ 4.7⭐✓   │ │
│  └──────────┴──────────┴──────────┘ │
│                                      │
│  [Export Comparison (Pro)]           │ ← Paywall
└─────────────────────────────────────┘
```

**Features:**
- Side-by-side comparison of up to 4 markets
- Visual indicators for "best" in each category
- Export as PDF (Pro feature)

#### Screen 4: Paywall (Market Finder)

**Layout:**
```
┌─────────────────────────────────────┐
│  Unlock All Markets                  │
├─────────────────────────────────────┤
│  You're on the Free plan             │
│  Limited to top 5 states only        │
│                                      │
│  ✓ All 50 states                     │
│  ✓ 3,143 county-level data           │
│  ✓ Save unlimited favorites          │
│  ✓ Export market reports (PDF)       │
│  ✓ Real-time auction updates         │
│                                      │
│  ┌─────────────────────────────────┐│
│  │  Pro - $9.99/month              ││
│  │  or $99.99/year (save 17%)      ││
│  │  [Start 7-Day Free Trial]       ││
│  └─────────────────────────────────┘│
│                                      │
│  ┌─────────────────────────────────┐│
│  │  Want more? Try TAXLIEN.online  ││
│  │  Premium for AI analysis,       ││
│  │  NFT integration, and more.     ││
│  │  [Learn More →]                 ││ ← Main app upsell
│  └─────────────────────────────────┘│
│                                      │
│  [Maybe Later]                       │
└─────────────────────────────────────┘
```

**Conversion Strategy:**
- Show paywall after user views 5 states
- Trigger on "Export" button tap
- Trigger on county detail view
- Offer 7-day free trial for Pro tier

---

### API Endpoints (Market Finder)

**Base URL:** `https://api.taxlien.online/v1/tools/market-finder`

#### GET `/markets/states`

**Purpose:** List all states with summary metrics

**Query Params:**
- `sort`: `roi` | `period` | `rating` (default: `roi`)
- `lienType`: `tax_lien` | `tax_deed` | `hybrid`
- `minROI`: number (percentage)
- `maxPeriod`: number (months)
- `limit`: number (default: 50)
- `offset`: number (default: 0)

**Response:**
```json
{
  "states": [
    {
      "id": "az",
      "name": "Arizona",
      "avgROI": 16.0,
      "redemptionPeriodMonths": 36,
      "lienType": "tax_lien",
      "avgPropertyValue": 325000,
      "investorRating": 4.5,
      "reviewCount": 1243,
      "countyCount": 15,
      "lastUpdated": "2025-12-31T10:00:00Z"
    },
    ...
  ],
  "total": 50,
  "limit": 50,
  "offset": 0
}
```

#### GET `/markets/counties`

**Purpose:** List counties for a state or filter across all states

**Query Params:**
- `state`: state ID (e.g., "az")
- `sort`: `roi` | `value` | `rating`
- `minROI`: number
- `maxPropertyValue`: number
- `limit`: number
- `offset`: number

**Response:**
```json
{
  "counties": [
    {
      "id": "az-maricopa",
      "name": "Maricopa County",
      "state": "Arizona",
      "stateId": "az",
      "avgROI": 18.0,
      "redemptionPeriodMonths": 36,
      "lienType": "tax_lien",
      "avgPropertyValue": 450000,
      "auctionFrequencyDays": 365,
      "investorRating": 4.7,
      "auctionWebsite": "https://treasurer.maricopa.gov",
      "contactPhone": "+1-602-555-0100",
      "lastUpdated": "2025-12-31T10:00:00Z"
    },
    ...
  ],
  "total": 3143,
  "limit": 20,
  "offset": 0
}
```

#### GET `/markets/{id}`

**Purpose:** Get detailed info for a specific market (state or county)

**Response:**
```json
{
  "market": {
    "id": "az",
    "name": "Arizona",
    "type": "state",
    "avgROI": 16.0,
    "redemptionPeriodMonths": 36,
    "lienType": "tax_lien",
    "avgPropertyValue": 325000,
    "auctionFrequencyDays": 365,
    "investorRating": 4.5,
    "reviewCount": 1243,
    "counties": ["az-maricopa", "az-pima", ...],
    "resources": [
      {
        "title": "Arizona Tax Lien Laws",
        "url": "https://www.azleg.gov/...",
        "type": "legal"
      },
      {
        "title": "County Contact Directory",
        "url": "https://taxlien.online/counties/az",
        "type": "directory"
      }
    ],
    "statistics": {
      "totalAuctions2024": 52,
      "totalPropertiesSold": 12543,
      "avgWinningBid": 15000,
      "redemptionRate": 82.5
    },
    "lastUpdated": "2025-12-31T10:00:00Z"
  }
}
```

#### POST `/favorites`

**Purpose:** Add market to user favorites

**Auth:** Required (Firebase Auth token)

**Request:**
```json
{
  "marketId": "az",
  "type": "state"
}
```

**Response:**
```json
{
  "success": true,
  "favorite": {
    "id": "fav_123",
    "userId": "user_456",
    "marketId": "az",
    "createdAt": "2025-12-31T12:00:00Z"
  }
}
```

#### DELETE `/favorites/{favoriteId}`

**Purpose:** Remove market from favorites

**Auth:** Required

**Response:**
```json
{
  "success": true
}
```

#### GET `/favorites`

**Purpose:** Get user's favorite markets

**Auth:** Required

**Response:**
```json
{
  "favorites": [
    {
      "id": "fav_123",
      "market": { /* full market object */ },
      "createdAt": "2025-12-31T12:00:00Z"
    },
    ...
  ]
}
```

---

## Tool #2: Sweet Spot Analyzer Specifications

### Overview

**Purpose:** Help investors filter thousands of properties to find "sweet spot" investment opportunities based on custom criteria (tax amount, assessed value, redemption period, property type).

**Monetization:**
- Free: Analyze up to 25 properties at once
- Pro ($19.99/month or $199.99/year): Unlimited properties, advanced filters, batch analysis, export
- Enterprise ($499.99/year): API access, custom criteria, white-label reports

### UI/UX Specifications

#### Screen 1: Upload Properties

**Layout:**
```
┌─────────────────────────────────────┐
│  Sweet Spot Analyzer            [⚙]  │
├─────────────────────────────────────┤
│  Find Your Sweet Spot Properties     │
│                                      │
│  Step 1: Upload Property List        │
│                                      │
│  ┌─────────────────────────────────┐│
│  │  📎 Upload CSV or Excel         ││
│  │                                 ││
│  │  [Tap to select file]           ││
│  │                                 ││
│  │  Supported formats:             ││
│  │  • CSV (.csv)                   ││
│  │  • Excel (.xlsx, .xls)          ││
│  │  • JSON (.json)                 ││
│  │                                 ││
│  │  Required columns:              ││
│  │  - Parcel ID (or Address)       ││
│  │  - Tax Amount                   ││
│  │  - Assessed Value               ││
│  └─────────────────────────────────┘│
│                                      │
│  Or paste data manually:             │
│  ┌─────────────────────────────────┐│
│  │ [Paste CSV data here...]        ││
│  │                                 ││
│  └─────────────────────────────────┘│
│                                      │
│  Sample datasets:                    │
│  • Florida - Miami-Dade (1,234 props)│
│  • Arizona - Maricopa (856 props)    │
│                                      │
│  [Continue to Filters →]             │
└─────────────────────────────────────┘
```

**Features:**
- File upload via device picker
- CSV/Excel parsing with column mapping
- Manual paste for quick testing
- Sample datasets for demo

#### Screen 2: Filter Criteria

**Layout:**
```
┌─────────────────────────────────────┐
│  ← Sweet Spot Filters                │
├─────────────────────────────────────┤
│  11,234 properties loaded            │
│  🎯 Define your sweet spot criteria  │
│                                      │
│  Tax Amount:                         │
│  [$1,000 ─────●─────── $50,000]     │
│                                      │
│  Assessed Value:                     │
│  [$50K ────────●────── $500K]        │
│                                      │
│  Tax-to-Value Ratio:                 │
│  [0% ──●─────────────── 10%]         │
│  Current: < 2.5%                     │
│                                      │
│  Property Type:                      │
│  ☑ Residential    ☐ Commercial       │
│  ☐ Agricultural   ☐ Vacant Land      │
│                                      │
│  ⚡ Advanced Filters (Pro):           │
│  ┌─────────────────────────────────┐│
│  │ 🔒 Building Age                 ││
│  │ 🔒 Square Footage               ││
│  │ 🔒 Lot Size                     ││
│  │ 🔒 Redemption Likelihood        ││
│  │ [Upgrade to Pro →]              ││
│  └─────────────────────────────────┘│
│                                      │
│  Matching: 342 properties            │
│  [Apply Filters →]                   │
└─────────────────────────────────────┘
```

**Filter Criteria:**
```dart
class FilterCriteria {
  // Basic filters (Free)
  final RangeValues taxAmountRange;        // $1K - $50K
  final RangeValues assessedValueRange;    // $50K - $500K
  final double maxTaxToValueRatio;         // 0-10%
  final List<PropertyType> propertyTypes;  // Residential, etc.

  // Advanced filters (Pro only)
  final RangeValues? buildingAgeRange;     // 0-100 years
  final RangeValues? squareFootageRange;   // 500-10K sqft
  final RangeValues? lotSizeRange;         // 0.1-10 acres
  final double? minRedemptionProbability;  // 0-100% (AI prediction)

  // Sorting
  final SortBy sortBy; // taxAmount, roi, value, ratio
  final SortOrder sortOrder; // asc, desc
}
```

#### Screen 3: Results List

**Layout:**
```
┌─────────────────────────────────────┐
│  ← Sweet Spot Results                │
├─────────────────────────────────────┤
│  342 properties match your criteria  │
│                                      │
│  Sort by: [ROI ▼]   [⬇ Export]      │ ← Export = Paywall
│                                      │
│  ┌───────────────────────────────┐  │
│  │ 📍 123 Main St, Miami         │  │
│  │ Tax: $2,450 • Value: $125K    │  │
│  │ Ratio: 1.96% • Residential    │  │
│  │ ⭐ Sweet Spot Score: 8.5/10   │  │
│  │ [View Details →]              │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ 📍 456 Oak Ave, Miami         │  │
│  │ Tax: $3,200 • Value: $180K    │  │
│  │ Ratio: 1.78% • Residential    │  │
│  │ ⭐ Sweet Spot Score: 8.2/10   │  │
│  │ [View Details →]              │  │
│  └───────────────────────────────┘  │
│  ...                                 │
│                                      │
│  [Load More (25/342)]                │ ← Free limit
│  ┌───────────────────────────────┐  │
│  │ 🔒 See all 342 results         │  │
│  │ Upgrade to Pro to view all     │  │
│  │ [Unlock Pro →]                 │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**Sweet Spot Scoring Algorithm:**
```dart
double calculateSweetSpotScore(Property property) {
  double score = 0;

  // Factor 1: Tax-to-Value Ratio (30 points)
  // Lower is better (more equity protection)
  final ratio = property.taxAmount / property.assessedValue;
  if (ratio < 0.02) score += 30;
  else if (ratio < 0.03) score += 25;
  else if (ratio < 0.05) score += 15;
  else score += 5;

  // Factor 2: Absolute Tax Amount (25 points)
  // Sweet spot: $1K-$5K (not too small, not too risky)
  if (property.taxAmount >= 1000 && property.taxAmount <= 5000) {
    score += 25;
  } else if (property.taxAmount < 1000) {
    score += 10;
  } else {
    score += 15;
  }

  // Factor 3: Property Type (20 points)
  // Residential > Commercial > Vacant Land
  switch (property.propertyType) {
    case PropertyType.residential:
      score += 20;
      break;
    case PropertyType.commercial:
      score += 15;
      break;
    case PropertyType.agricultural:
      score += 10;
      break;
    case PropertyType.vacantLand:
      score += 5;
      break;
  }

  // Factor 4: Redemption Probability (15 points) - Pro feature
  if (property.redemptionProbability != null) {
    // Higher redemption = safer investment
    if (property.redemptionProbability! > 0.8) score += 15;
    else if (property.redemptionProbability! > 0.6) score += 10;
    else score += 5;
  } else {
    score += 7.5; // Default for free users
  }

  // Factor 5: Market Data (10 points)
  // County with good investor rating
  if (property.countyInvestorRating != null) {
    score += (property.countyInvestorRating! / 5) * 10;
  } else {
    score += 5;
  }

  return score; // 0-100 scale
}
```

#### Screen 4: Property Detail

**Layout:**
```
┌─────────────────────────────────────┐
│  ← Property Details                  │
├─────────────────────────────────────┤
│  📍 123 Main St, Miami, FL 33101     │
│  ⭐ Sweet Spot Score: 8.5/10         │
│                                      │
│  ┌──────────┬──────────┬──────────┐ │
│  │   Tax    │  Value   │  Ratio   │ │
│  │ $2,450   │ $125K    │  1.96%   │ │
│  └──────────┴──────────┴──────────┘ │
│                                      │
│  Property Info:                      │
│  • Type: Single Family Residential   │
│  • Building: 1,200 sqft, 3bd/2ba     │
│  • Lot: 0.25 acres                   │
│  • Built: 1995 (30 years old)        │
│  • Owner: John Doe                   │
│                                      │
│  Financial Analysis:                 │
│  • Potential ROI: 16% (if redeemed)  │
│  • Estimated Market Value: $135K     │
│  • Redemption Probability: 85% ✓     │ ← Pro feature
│                                      │
│  County: Miami-Dade                  │
│  • Investor Rating: 4.7⭐            │
│  • Redemption Period: 2 years        │
│  • Next Auction: Feb 15, 2026        │
│                                      │
│  [🔖 Add to Buy List]                │
│  [🔗 Share Property]                 │
│  [⬇ Export Report (Pro)]             │ ← Paywall
└─────────────────────────────────────┘
```

#### Screen 5: Export Options

**Layout:**
```
┌─────────────────────────────────────┐
│  Export Sweet Spot Results           │
├─────────────────────────────────────┤
│  342 properties ready to export      │
│                                      │
│  Format:                             │
│  ○ CSV (Excel-compatible)            │
│  ● PDF Report (recommended)          │
│  ○ JSON (for developers)             │
│                                      │
│  Include:                            │
│  ☑ Property details                  │
│  ☑ Sweet Spot scores                 │
│  ☑ Financial analysis                │
│  ☑ County information                │
│  ☑ Maps (PDF only)                   │
│                                      │
│  ┌─────────────────────────────────┐│
│  │  🔒 Export requires Pro          ││
│  │                                  ││
│  │  Upgrade to export unlimited     ││
│  │  properties with custom reports. ││
│  │                                  ││
│  │  [Upgrade to Pro - $19.99/mo]    ││
│  └─────────────────────────────────┘│
│                                      │
│  [Cancel]                            │
└─────────────────────────────────────┘
```

---

### Data Model (Sweet Spot Analyzer)

```dart
/// Property data model
class Property {
  // Core identifiers
  final String id;
  final String parcelId;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String countyId;

  // Financial data
  final double taxAmount;
  final double assessedValue;
  final double? marketValue; // Estimated
  final double taxToValueRatio;

  // Property characteristics
  final PropertyType propertyType;
  final int? buildingYear;
  final double? squareFootage;
  final double? lotSizeAcres;
  final int? bedrooms;
  final int? bathrooms;

  // Investment metrics
  final double sweetSpotScore; // 0-100
  final double? redemptionProbability; // 0-1 (AI prediction, Pro only)
  final double? estimatedROI;

  // County/Market data
  final String? countyName;
  final double? countyInvestorRating;
  final DateTime? nextAuctionDate;

  // Owner info
  final String? ownerName;
  final bool? ownerOccupied;

  // Metadata
  final DateTime createdAt;
  final DateTime? lastUpdated;
}

enum PropertyType {
  residential,
  commercial,
  agricultural,
  vacantLand,
  industrial,
  mixed,
}
```

---

### API Endpoints (Sweet Spot Analyzer)

**Base URL:** `https://api.taxlien.online/v1/tools/sweet-spot`

#### POST `/analyze`

**Purpose:** Upload and analyze property list

**Auth:** Required

**Request (multipart/form-data):**
```
file: CSV/Excel file
OR
data: JSON array of properties
```

**Response:**
```json
{
  "analysisId": "analysis_123",
  "totalProperties": 11234,
  "processed": 11234,
  "failed": 0,
  "uploadedAt": "2025-12-31T12:00:00Z",
  "status": "completed"
}
```

#### GET `/analyze/{analysisId}`

**Purpose:** Get analysis status and results

**Auth:** Required

**Response:**
```json
{
  "analysis": {
    "id": "analysis_123",
    "status": "completed",
    "totalProperties": 11234,
    "matchingProperties": 342,
    "filters": {
      "taxAmountMin": 1000,
      "taxAmountMax": 50000,
      "assessedValueMin": 50000,
      "assessedValueMax": 500000,
      "maxTaxToValueRatio": 0.025,
      "propertyTypes": ["residential"]
    },
    "uploadedAt": "2025-12-31T12:00:00Z",
    "completedAt": "2025-12-31T12:01:15Z"
  }
}
```

#### GET `/properties`

**Purpose:** Get filtered properties from analysis

**Auth:** Required

**Query Params:**
- `analysisId`: string (required)
- `limit`: number (default: 25, max: 100 for Pro)
- `offset`: number (default: 0)
- `sortBy`: `sweetSpotScore` | `taxAmount` | `assessedValue` | `ratio`
- `sortOrder`: `asc` | `desc`

**Response:**
```json
{
  "properties": [
    {
      "id": "prop_456",
      "parcelId": "12-34-56-789",
      "address": "123 Main St",
      "city": "Miami",
      "state": "FL",
      "zipCode": "33101",
      "countyId": "fl-miami-dade",
      "taxAmount": 2450,
      "assessedValue": 125000,
      "marketValue": 135000,
      "taxToValueRatio": 0.0196,
      "propertyType": "residential",
      "buildingYear": 1995,
      "squareFootage": 1200,
      "lotSizeAcres": 0.25,
      "bedrooms": 3,
      "bathrooms": 2,
      "sweetSpotScore": 85.0,
      "redemptionProbability": 0.85,
      "estimatedROI": 16.0,
      "countyName": "Miami-Dade",
      "countyInvestorRating": 4.7,
      "nextAuctionDate": "2026-02-15",
      "ownerName": "John Doe",
      "ownerOccupied": true
    },
    ...
  ],
  "total": 342,
  "limit": 25,
  "offset": 0,
  "hasMore": true
}
```

#### POST `/export`

**Purpose:** Export analysis results

**Auth:** Required (Pro tier)

**Request:**
```json
{
  "analysisId": "analysis_123",
  "format": "pdf", // "csv", "json", "pdf"
  "include": {
    "propertyDetails": true,
    "sweetSpotScores": true,
    "financialAnalysis": true,
    "countyInfo": true,
    "maps": true // PDF only
  }
}
```

**Response:**
```json
{
  "exportId": "export_789",
  "downloadUrl": "https://storage.taxlien.online/exports/export_789.pdf",
  "expiresAt": "2025-12-31T18:00:00Z",
  "format": "pdf",
  "fileSize": 2456789
}
```

---

## Database Schemas

### PostgreSQL (County Data) - Read-Only

**Table:** `counties`

```sql
CREATE TABLE counties (
  id VARCHAR(50) PRIMARY KEY, -- "az-maricopa"
  name VARCHAR(255) NOT NULL,
  state_id VARCHAR(2) NOT NULL,
  state_name VARCHAR(100) NOT NULL,

  -- Metrics
  avg_roi DECIMAL(5,2), -- 16.50
  redemption_period_months INT,
  lien_type VARCHAR(50), -- 'tax_lien', 'tax_deed', 'hybrid'
  avg_property_value BIGINT,
  auction_frequency_days INT,
  investor_rating DECIMAL(3,2), -- 4.75
  review_count INT DEFAULT 0,

  -- Contact info
  auction_website TEXT,
  contact_phone VARCHAR(20),
  contact_email VARCHAR(255),

  -- Statistics
  total_auctions_2024 INT DEFAULT 0,
  total_properties_sold_2024 INT DEFAULT 0,
  avg_winning_bid BIGINT,
  redemption_rate DECIMAL(5,2), -- 82.50

  -- Metadata
  last_updated TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),

  INDEX idx_state (state_id),
  INDEX idx_roi (avg_roi DESC),
  INDEX idx_rating (investor_rating DESC)
);
```

**Table:** `states`

```sql
CREATE TABLE states (
  id VARCHAR(2) PRIMARY KEY, -- "AZ"
  name VARCHAR(100) NOT NULL,

  -- Aggregated metrics from counties
  avg_roi DECIMAL(5,2),
  avg_redemption_period_months INT,
  primary_lien_type VARCHAR(50),
  avg_property_value BIGINT,
  investor_rating DECIMAL(3,2),
  review_count INT DEFAULT 0,
  county_count INT DEFAULT 0,

  -- Legal info
  tax_lien_laws_url TEXT,

  -- Metadata
  last_updated TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),

  INDEX idx_roi (avg_roi DESC)
);
```

### Firestore (User Data)

**Collection:** `users/{userId}`

```javascript
{
  uid: string,
  email: string,
  displayName: string | null,
  photoURL: string | null,
  createdAt: timestamp,
  lastLoginAt: timestamp,

  // Tools tracking
  tools_installed: string[], // ["market_finder", "sweet_spot"]

  // Subscription (synced from RevenueCat)
  subscription: {
    tier: string, // "free", "pro", "enterprise"
    tool: string, // "market_finder", "sweet_spot"
    expiresAt: timestamp | null,
    source: string, // "ios", "android"
  }
}
```

**Subcollection:** `users/{userId}/favorites`

```javascript
{
  id: string, // auto-generated
  marketId: string, // "az" or "az-maricopa"
  marketType: string, // "state" or "county"
  marketName: string, // "Arizona" or "Maricopa County, AZ"
  createdAt: timestamp,
}
```

**Subcollection:** `users/{userId}/analyses` (Sweet Spot)

```javascript
{
  id: string, // "analysis_123"
  status: string, // "pending", "processing", "completed", "failed"
  totalProperties: number,
  matchingProperties: number,
  filters: {
    taxAmountMin: number,
    taxAmountMax: number,
    assessedValueMin: number,
    assessedValueMax: number,
    maxTaxToValueRatio: number,
    propertyTypes: string[],
  },
  uploadedAt: timestamp,
  completedAt: timestamp | null,
}
```

**Subcollection:** `users/{userId}/buyList` (Sweet Spot)

```javascript
{
  id: string,
  propertyId: string,
  parcelId: string,
  address: string,
  taxAmount: number,
  assessedValue: number,
  sweetSpotScore: number,
  notes: string | null,
  addedAt: timestamp,
}
```

**Collection:** `analytics_events` (Custom tracking)

```javascript
{
  id: string, // auto-generated
  userId: string,
  tool: string, // "market_finder", "sweet_spot"
  eventType: string, // "search", "favorite_added", "paywall_shown", etc.
  eventData: map, // Additional event-specific data
  timestamp: timestamp,
}
```

---

## Testing Strategy

### Unit Tests

**Market Finder:**
- [ ] `MarketService.getStates()` - Returns sorted list of states
- [ ] `MarketService.getCounties(stateId)` - Returns counties for state
- [ ] `MarketService.searchMarkets(query)` - Search autocomplete works
- [ ] `FilterService.applyFilters()` - Filtering logic correct
- [ ] `FavoritesService.addFavorite()` - Saves to Firestore
- [ ] `FavoritesService.removeFavorite()` - Removes from Firestore
- [ ] `ExportService.generatePDF()` - Creates valid PDF

**Sweet Spot Analyzer:**
- [ ] `PropertyParser.parseCSV()` - Handles various CSV formats
- [ ] `PropertyParser.parseExcel()` - Handles XLSX files
- [ ] `SweetSpotService.calculateScore()` - Scoring algorithm accurate
- [ ] `FilterService.filterProperties()` - Applies criteria correctly
- [ ] `ExportService.exportCSV()` - Generates valid CSV
- [ ] `ExportService.exportPDF()` - Creates formatted PDF

**Shared Services:**
- [ ] `AuthService.signInWithGoogle()` - Google OAuth flow
- [ ] `AuthService.signInWithApple()` - Apple Sign In flow
- [ ] `PaymentService.purchase()` - RevenueCat purchase
- [ ] `PaymentService.restorePurchases()` - Restore works
- [ ] `PaymentService.hasAccess()` - Tier checks correct
- [ ] `AnalyticsService.logEvent()` - Firebase Analytics integration

### Integration Tests

**Market Finder:**
- [ ] User can sign in and view top 5 states (Free tier)
- [ ] Paywall shown when tapping on 6th state
- [ ] User can purchase Pro and unlock all states
- [ ] Favorite markets sync across devices
- [ ] Export PDF generates with correct data

**Sweet Spot Analyzer:**
- [ ] User can upload CSV and see analysis results
- [ ] Free tier limited to 25 properties
- [ ] Pro tier shows all matching properties
- [ ] Sweet Spot scoring algorithm produces consistent results
- [ ] Export CSV contains all properties with correct formatting

**Cross-Tool:**
- [ ] Single sign-on works across both tools
- [ ] Purchasing Pro in one tool doesn't affect the other
- [ ] Main app upsell deep link opens main app
- [ ] Analytics events tracked correctly

### Manual Verification

**Market Finder:**
- [ ] Install on iOS device, sign in with Apple
- [ ] Search for "Florida", verify results
- [ ] Add Florida to favorites
- [ ] Trigger paywall by viewing 6th state
- [ ] Complete Pro purchase flow
- [ ] Verify all 50 states now accessible
- [ ] Export PDF report for Arizona
- [ ] Tap "Try Main App" CTA, verify deep link

**Sweet Spot Analyzer:**
- [ ] Install on Android device, sign in with Google
- [ ] Upload sample CSV (100 properties)
- [ ] Apply filters: $1K-$5K tax, residential only
- [ ] Verify Sweet Spot scores calculated
- [ ] View property detail page
- [ ] Add property to Buy List
- [ ] Trigger paywall by exporting
- [ ] Purchase Pro
- [ ] Export PDF report
- [ ] Verify same account works in Market Finder (SSO)

---

## Migration / Rollout

### Phase 1: Infrastructure Setup (Week 1)

1. **Firebase Project Setup**
   - Create Firebase project: "taxlien-mobile-tools"
   - Enable Authentication (Google, Apple, Email/Password)
   - Create Firestore database
   - Set up Firebase Analytics
   - Configure iOS and Android apps

2. **RevenueCat Setup**
   - Create RevenueCat account
   - Link to App Store Connect and Google Play Console
   - Create products and entitlements (see pricing section above)
   - Configure webhooks for subscription events

3. **Backend API Setup**
   - Deploy FastAPI endpoints to production
   - Set up Redis cache for county data
   - Configure CORS for mobile apps
   - Set up monitoring (Sentry, Datadog)

### Phase 2: Development (Week 2-5)

1. **Shared Infrastructure Package** (Week 2)
   - Create `shared_tools` Flutter package
   - Implement `AuthService`, `PaymentService`, `AnalyticsService`
   - Build reusable UI components (cards, buttons, paywalls)
   - Write unit tests

2. **Market Finder App** (Week 3-4)
   - Implement UI screens (Home, Market Detail, Compare, Paywall)
   - Integrate API endpoints
   - Add favorites functionality
   - Implement PDF export
   - Write integration tests

3. **Sweet Spot Analyzer App** (Week 4-5)
   - Implement UI screens (Upload, Filters, Results, Detail)
   - Build CSV/Excel parser
   - Implement Sweet Spot scoring algorithm
   - Add batch analysis
   - Implement PDF/CSV export
   - Write integration tests

### Phase 3: Testing & QA (Week 6)

1. **Internal Testing**
   - Unit tests: 100% coverage for business logic
   - Integration tests: All critical flows
   - Manual testing on iOS and Android
   - Performance testing (large datasets)

2. **Beta Testing**
   - TestFlight (iOS): 50 beta testers
   - Google Play Beta (Android): 50 beta testers
   - Collect feedback via in-app survey
   - Fix critical bugs

### Phase 4: App Store Submission (Week 7)

1. **App Store Preparation**
   - Create App Store listings (screenshots, descriptions)
   - Set up App Store Connect
   - Configure in-app purchases
   - Submit for review

2. **Google Play Preparation**
   - Create Google Play listing
   - Set up Google Play Console
   - Configure in-app purchases
   - Submit for review

### Phase 5: Launch & Marketing (Week 8+)

1. **Soft Launch**
   - Release to US market only
   - Monitor crash reports, analytics
   - A/B test paywall variations
   - Optimize conversion funnel

2. **Marketing Campaign**
   - Blog posts announcing launch
   - Email to existing TAXLIEN.online users
   - Social media campaign (LinkedIn, Facebook groups)
   - Reddit posts in r/realestateinvesting
   - Paid ads (Google, Facebook)

---

## Open Design Questions

- [ ] **Pricing Strategy:** Should we offer a bundle discount for purchasing both tools? (e.g., Market Finder + Sweet Spot for $24.99/month instead of $29.98)

- [ ] **Data Freshness:** How often should we update county data? (Currently: weekly scraping, could increase to daily for Premium users)

- [ ] **Offline Mode:** Should tools work offline with cached data? (Improves UX but increases complexity)

- [ ] **White-Label Option:** For Enterprise tier, allow custom branding? (e.g., "Powered by TAXLIEN.online" white-label for agencies)

- [ ] **API Rate Limits:** What rate limits for Enterprise API access? (Proposal: 1,000 requests/hour for Market Finder, 100 analyses/day for Sweet Spot)

- [ ] **Cross-Promotion:** Should Pro subscription in one tool give discount in the other? (e.g., 50% off second tool if you already have Pro in first)

- [ ] **Main App Integration:** Should purchasing TAXLIEN.online Premium automatically unlock Pro tier in both tools? (Increases LTV, reduces confusion)

---

## Approval

- [ ] Reviewed by: Anton (Product Owner)
- [ ] Approved on: [Pending]
- [ ] Notes: Specifications ready for Plan phase. Need user confirmation on:
  - Pricing bundles
  - Main app integration strategy
  - Enterprise white-label feasibility
