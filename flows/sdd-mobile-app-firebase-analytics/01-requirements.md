# Requirements: Firebase Analytics Integration

**Version**: 1.0
**Status**: DRAFT
**Created**: 2026-01-01
**Last Updated**: 2026-01-01

---

## Executive Summary

Replace the current stub [analytics_service.dart:1-43] implementation with a comprehensive Firebase Analytics integration to enable data-driven product decisions, measure conversion funnels, and optimize the user journey toward paid subscriptions.

**Current State**:
- Firebase Analytics SDK installed ([pubspec.yaml:144])
- Stub implementation exists ([analytics_service.dart:1-43]) - only prints to console
- No actual event tracking
- No funnel measurement
- No user property tracking

**Problem Statement**:
Without analytics, we're flying blind. We cannot:
1. Measure free → trial → paid conversion rates
2. Identify where users drop off in onboarding
3. Understand which features drive engagement
4. Calculate ARPU, LTV, churn rate accurately
5. A/B test pricing, paywalls, or UI changes
6. Optimize CAC by tracking referral sources

**Business Impact**:
- **Revenue Risk**: $300K-500K Year 1 revenue target depends on 10% conversion rate (currently unknown if we're at 1% or 15%)
- **Wasted Spend**: Cannot measure which acquisition channels work
- **Missed Opportunities**: Don't know which features to prioritize for retention

---

## 1. Problem Context

### 1.1 Current Architecture

```
AnalyticsService (stub)
  ├─> initialize() - creates empty NavigatorObserver
  ├─> trackScreenView() - only debugPrint
  ├─> trackEvent() - only debugPrint
  ├─> trackUserAction() - only debugPrint
  └─> trackError() - only debugPrint
```

**What's Missing:**
- No Firebase Analytics SDK integration
- No event taxonomy (which events to track)
- No funnel definitions
- No user property tracking (subscription tier, trial status)
- No integration with existing screens

### 1.2 Related Systems

This integration affects:
- **Subscription Flow**: Track paywall views, tier selections, purchase completions
- **Onboarding**: Measure educational module completion rates
- **Search & Discovery**: Track property searches, filter usage, saved properties
- **AI Features**: Measure AI prediction requests (premium feature)
- **Referral Program**: Track referral code usage, conversions
- **In-App Purchases**: Track course purchases (educational products)

---

## 2. User Stories

### Story 1: Product Manager Measures Conversion Funnel

**As a** product manager
**I want to** see the free → trial → paid conversion funnel in Firebase Analytics console
**So that** I can identify drop-off points and optimize them

**Acceptance Criteria:**
- **Given** 1000 new users sign up
- **When** I check Firebase Analytics console
- **Then** I see a funnel showing:
  - 1000 users completed onboarding (100%)
  - 400 users started trial (40%)
  - 100 users converted to paid (10% of trial starts = 4% overall)
- **And** I can drill down to see which step loses most users

**Technical Requirements:**
- Track `onboarding_complete` event
- Track `trial_start` event with parameters: `{tier: 'starter'|'premium'|'enterprise'}`
- Track `subscription_purchase` event with revenue value
- Create funnel in Firebase Analytics console

---

### Story 2: Developer Debugs Low Conversion

**As a** developer
**I want to** see real-time event logs during testing
**So that** I can verify analytics are firing correctly

**Acceptance Criteria:**
- **Given** I'm running the app in debug mode on iOS Simulator
- **When** I navigate to paywall screen
- **Then** I see Firebase Analytics DebugView showing `screen_view: paywall` event
- **And** event includes parameters: `{tier: 'premium', price: '$49.99'}`

**Technical Requirements:**
- Enable Firebase Analytics debug mode for development
- Add comprehensive parameters to all events
- Validate events fire before screen transitions

---

### Story 3: Marketing Team Tracks Campaigns

**As a** marketing manager
**I want to** track which acquisition channels drive paid conversions
**So that** I can optimize ad spend

**Acceptance Criteria:**
- **Given** user clicks Instagram ad with UTM parameters
- **When** user signs up and converts to paid
- **Then** Firebase Analytics attributes conversion to `instagram_ad` campaign
- **And** I see campaign ROI in Firebase console

**Technical Requirements:**
- Automatically capture UTM parameters from deep links
- Set user properties: `acquisition_source`, `campaign_name`
- Track `first_open` event with campaign parameters

---

### Story 4: User Researcher Understands Feature Usage

**As a** UX researcher
**I want to** see which app features are most/least used
**So that** I can recommend what to improve or remove

**Acceptance Criteria:**
- **Given** 500 active users in past week
- **When** I check Firebase Analytics console
- **Then** I see event counts:
  - `property_search`: 3,200 events (avg 6.4 per user)
  - `ai_prediction_request`: 450 events (only 90 users = 18% adoption)
  - `nft_mint_view`: 20 events (only 4 users = 0.8% adoption)
- **And** I conclude AI predictions need better onboarding, NFTs need rework

**Technical Requirements:**
- Track all major feature interactions
- Include user ID for unique user counting
- Group events by feature category

---

### Story 5: CFO Calculates LTV and Churn

**As a** CFO
**I want to** export cohort data with subscription revenue
**So that** I can calculate customer lifetime value and churn rate

**Acceptance Criteria:**
- **Given** 100 users subscribed in January 2026
- **When** I check March 2026 (3 months later)
- **Then** Firebase Analytics shows:
  - 85 users still subscribed (15% churn)
  - $4,250 total revenue from cohort ($42.50 LTV so far)
- **And** I can export data to Google Sheets for financial model

**Technical Requirements:**
- Set user property: `subscription_tier`, `subscription_start_date`
- Track `subscription_cancel` event
- Enable BigQuery export (if needed for complex analysis)

---

## 3. Event Taxonomy

### 3.1 Critical Events (Must Track - Week 1)

#### Onboarding & Authentication
| Event Name | Trigger | Parameters |
|------------|---------|------------|
| `app_open` | First app launch | `{platform: 'ios'|'android'}` |
| `signup_start` | User taps "Sign Up" | `{method: 'email'|'google'|'apple'}` |
| `signup_complete` | Account created | `{method: 'email'|'google'|'apple', user_id}` |
| `onboarding_step` | Each onboarding screen | `{step_number: 1-5, step_name: 'welcome'|'permissions'|...}` |
| `onboarding_complete` | User finishes onboarding | `{duration_seconds: 120}` |

#### Subscription & Monetization
| Event Name | Trigger | Parameters |
|------------|---------|------------|
| `paywall_view` | Paywall screen shown | `{trigger: 'onboarding'|'search_limit'|'ai_limit', tier_shown: 'premium'}` |
| `trial_start` | User starts trial | `{tier: 'starter'|'premium'|'enterprise', trial_days: 14}` |
| `subscription_purchase` | Subscription purchased | `{tier, price: '$49.99', period: 'monthly'|'annual', revenue: 49.99}` |
| `subscription_cancel` | User cancels subscription | `{tier, cancel_reason: 'too_expensive'|'not_using'|...}` |
| `paywall_dismiss` | User closes paywall without purchasing | `{tier_shown: 'premium', time_viewed_seconds: 15}` |

#### Feature Usage
| Event Name | Trigger | Parameters |
|------------|---------|------------|
| `property_search` | User searches properties | `{query_length: 5, filters_used: ['state', 'price'], results_count: 23}` |
| `property_view` | User views property details | `{property_id, source: 'search'|'saved'|'recommendation'}` |
| `property_save` | User saves/favorites property | `{property_id}` |
| `ai_prediction_request` | User requests AI analysis | `{prediction_type: 'redemption'|'risk'|'roi', is_premium: true}` |
| `educational_module_start` | User starts learning module | `{module_id: 1-5, module_name: 'Tax Lien Basics'}` |
| `educational_module_complete` | User completes module | `{module_id, duration_seconds: 600, quiz_score: 0.8}` |

---

### 3.2 Important Events (Week 2-3)

#### Educational Products
| Event Name | Trigger | Parameters |
|------------|---------|------------|
| `course_view` | User views course details | `{course_id, course_name, price: '$97'}` |
| `course_purchase` | Course purchased | `{course_id, price: '$97', revenue: 97, payment_method: 'stripe'}` |
| `video_watch` | User watches educational video | `{video_id, video_duration: 600, watched_duration: 180, completion_rate: 0.3}` |

#### Referral Program
| Event Name | Trigger | Parameters |
|------------|---------|------------|
| `referral_code_share` | User shares referral code | `{method: 'copy'|'whatsapp'|'email'}` |
| `referral_signup` | New user signs up via referral | `{referrer_id, referee_id}` |
| `referral_reward_earned` | Referrer earns $20 reward | `{referrer_id, referee_id, reward_amount: 20}` |

#### NFT & Blockchain
| Event Name | Trigger | Parameters |
|------------|---------|------------|
| `nft_mint_view` | User views NFT minting screen | `{property_id}` |
| `nft_mint_start` | User initiates NFT minting | `{property_id, nft_type: 'full'|'fractional'}` |
| `nft_mint_complete` | NFT successfully minted | `{nft_id, mint_fee: 0.1}` |
| `nft_transfer` | NFT transferred to another wallet | `{nft_id, transfer_fee: 5}` |

---

### 3.3 User Properties

User properties persist across sessions for segmentation:

| Property Name | Values | Set When |
|---------------|--------|----------|
| `subscription_tier` | `'free'`, `'trial'`, `'starter'`, `'premium'`, `'enterprise'` | Signup, subscription change |
| `trial_status` | `'never_trialed'`, `'in_trial'`, `'trial_expired'`, `'converted'` | Trial events |
| `acquisition_source` | `'organic'`, `'instagram_ad'`, `'google_ad'`, `'referral'` | First app open |
| `onboarding_completed` | `true`, `false` | Onboarding complete |
| `educational_modules_completed` | `0-5` | Module completion |
| `lifetime_revenue` | `0`, `49.99`, `199.99`, etc. | Purchase events |
| `days_since_signup` | `0`, `1`, `7`, `30`, etc. | Daily calculation |

---

## 4. Funnel Definitions

### 4.1 Free → Paid Conversion Funnel

**Critical for Revenue Optimization**

```
Step 1: App Install (100%)
   ↓
Step 2: Signup Complete (60% - target: 70%)
   ↓
Step 3: Onboarding Complete (90% - target: 95%)
   ↓
Step 4: Paywall View (40% - target: 60%)
   ↓
Step 5: Trial Start (50% of paywall views - target: 60%)
   ↓
Step 6: Subscription Purchase (10% of trial starts - target: 15%)
```

**Events Used:**
- `app_open` (first time)
- `signup_complete`
- `onboarding_complete`
- `paywall_view`
- `trial_start`
- `subscription_purchase`

---

### 4.2 Educational Engagement Funnel

```
Step 1: Module 1 Start (100%)
   ↓
Step 2: Module 1 Complete (70%)
   ↓
Step 3: Module 2 Start (60%)
   ↓
Step 4: Module 3 Start (40%)
   ↓
Step 5: All 5 Modules Complete (20%)
```

**Hypothesis**: Users who complete 3+ modules have 3x higher conversion rate

---

### 4.3 Property Search → Save Funnel

```
Step 1: Property Search (100%)
   ↓
Step 2: Property View (30% of searches)
   ↓
Step 3: Property Save (15% of views)
   ↓
Step 4: AI Prediction Request (40% of saves - premium only)
```

---

## 5. Success Metrics

### 5.1 Conversion Metrics

| Metric | Baseline (Unknown) | Target (Month 3) | Measurement |
|--------|-------------------|------------------|-------------|
| **Install → Signup** | ? | 60% | `signup_complete` / `app_open` |
| **Signup → Onboarding Complete** | ? | 95% | `onboarding_complete` / `signup_complete` |
| **Onboarding → Paywall View** | ? | 60% | `paywall_view` / `onboarding_complete` |
| **Paywall View → Trial Start** | ? | 50% | `trial_start` / `paywall_view` |
| **Trial Start → Paid** | ? | 15% | `subscription_purchase` / `trial_start` |
| **Overall Free → Paid** | ? | **10%** | `subscription_purchase` / `signup_complete` |

### 5.2 Engagement Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| **DAU/MAU** | 30% | Unique users per day / unique users per month |
| **Session Duration** | 8 minutes | Avg time between `app_open` and `app_background` |
| **Sessions per User per Week** | 3 | Count `app_open` events per user per week |
| **Feature Adoption: AI Predictions** | 30% of premium users | Users who triggered `ai_prediction_request` |

### 5.3 Revenue Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| **ARPU (Avg Revenue Per User)** | $5/month | Sum(`revenue`) / count(users) |
| **LTV (Lifetime Value)** | $150 (3 years) | Cohort analysis over time |
| **Churn Rate** | <5%/month | `subscription_cancel` events / active subscriptions |
| **Monthly Recurring Revenue (MRR)** | $50K (Month 12) | Sum(active subscriptions * price) |

---

## 6. Privacy & Compliance

### 6.1 User Consent

**Requirement**: Ask for analytics tracking permission during onboarding

**Implementation**:
- Show permission dialog: "Help us improve the app by sharing anonymous usage data?"
- Options: "Allow" / "Don't Allow"
- If declined, disable all Firebase Analytics calls
- Store preference in `shared_preferences`

**Copy**:
```
We'd like to collect anonymous usage data to improve your experience.
This includes:
- Pages you visit
- Features you use
- App crashes

We never collect:
- Personal property search data
- Financial information
- Location data

You can change this in Settings anytime.
```

### 6.2 Data Minimization

**DO Track:**
- Screen views, button clicks, feature usage
- Conversion events (signup, trial, purchase)
- App performance (load times, errors)

**DO NOT Track:**
- Specific property addresses searched
- User's financial details (credit card, bank account)
- Precise location (GPS coordinates)
- Personally identifiable information (PII)

**Anonymization Rules:**
- Property IDs → use hashed IDs
- User emails → never sent to analytics
- Search queries → track query *length* and *filters used*, not actual query text

### 6.3 GDPR Compliance

- Allow users to opt-out in Settings
- Provide "Delete my data" button (calls Firebase Analytics `resetAnalyticsData()`)
- Update Privacy Policy to mention Firebase Analytics
- Enable IP anonymization in Firebase console

---

## 7. Technical Requirements

### 7.1 SDK Integration

**Prerequisites:**
- ✅ Firebase Analytics SDK already installed ([pubspec.yaml:144])
- ⏳ Firebase project created? (verify `GoogleService-Info.plist` and `google-services.json` exist)
- ⏳ Firebase console access for team

**Initialization:**
- Call `FirebaseAnalytics.instance` during app startup
- Enable debug mode for development builds
- Disable analytics in test environment

### 7.2 Service Architecture

Replace [analytics_service.dart:1-43] with:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static bool _isEnabled = true; // Set based on user preference

  /// Initialize analytics with user consent
  static Future<void> initialize({required bool userConsent}) async {
    _isEnabled = userConsent;
    if (!_isEnabled) {
      await _analytics.setAnalyticsCollectionEnabled(false);
    }
  }

  /// Get Firebase Analytics observer for navigation tracking
  static FirebaseAnalyticsObserver get navigatorObserver {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  /// Track screen view (auto-tracked via observer, manual for custom screens)
  static Future<void> trackScreenView(String screenName, {String? screenClass}) async {
    if (!_isEnabled) return;
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  /// Track custom event
  static Future<void> trackEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isEnabled) return;
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  /// Track purchase/revenue event
  static Future<void> trackPurchase({
    required String itemId,
    required String itemName,
    required double value,
    required String currency,
  }) async {
    if (!_isEnabled) return;
    await _analytics.logPurchase(
      value: value,
      currency: currency,
      parameters: {
        'item_id': itemId,
        'item_name': itemName,
      },
    );
  }

  /// Set user property
  static Future<void> setUserProperty(String name, String? value) async {
    if (!_isEnabled) return;
    await _analytics.setUserProperty(name: name, value: value);
  }

  /// Set user ID
  static Future<void> setUserId(String? userId) async {
    if (!_isEnabled) return;
    await _analytics.setUserId(id: userId);
  }

  /// Reset analytics data (GDPR compliance)
  static Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
    _isEnabled = false;
  }
}
```

### 7.3 Screen Integration

**Pattern for All Screens:**

```dart
class PaywallScreen extends StatefulWidget {
  // ... existing code ...

  @override
  void initState() {
    super.initState();

    // Track screen view
    AnalyticsService.trackScreenView('paywall');

    // Track event with context
    AnalyticsService.trackEvent('paywall_view', parameters: {
      'tier_shown': widget.tier, // 'premium', 'starter', 'enterprise'
      'trigger': widget.trigger, // 'onboarding', 'search_limit', 'ai_limit'
    });
  }
}
```

**Screens to Instrument (Priority Order):**
1. ✅ Paywall Screen (highest priority - measures conversions)
2. ✅ Onboarding Screens (all steps)
3. ✅ Property Search Screen
4. ✅ Property Details Screen
5. Educational Module Screens
6. AI Prediction Screen
7. Subscription Management Screen
8. Referral Screen
9. NFT Screens

---

## 8. Testing Strategy

### 8.1 Development Testing

**Firebase DebugView:**
- Enable debug mode: `flutter run --dart-define=FIREBASE_DEBUG=true`
- iOS: `adb shell setprop debug.firebase.analytics.app [package_name]`
- Android: Terminal command to enable debug logging
- Verify events appear in Firebase Console → DebugView within 10 seconds

**Test Cases:**
1. **Onboarding Flow**:
   - Launch app → see `app_open` event
   - Complete signup → see `signup_complete` with correct `method` parameter
   - Complete onboarding → see `onboarding_complete` with `duration_seconds`

2. **Subscription Flow**:
   - View paywall → see `paywall_view` with `tier_shown` and `trigger`
   - Start trial → see `trial_start` with `tier` and `trial_days`
   - Purchase subscription → see `subscription_purchase` with revenue value

3. **User Properties**:
   - After signup → check user property `subscription_tier = 'free'`
   - After trial start → check `subscription_tier = 'trial'`, `trial_status = 'in_trial'`

### 8.2 Production Validation

**Week 1 Checklist:**
- [ ] 100+ `app_open` events per day
- [ ] 60+ `signup_complete` events per day (60% of app opens)
- [ ] 50+ `onboarding_complete` events per day (90% of signups)
- [ ] 20+ `paywall_view` events per day (40% of onboarding completes)
- [ ] 5+ `trial_start` events per day (25% of paywall views)
- [ ] All events have required parameters
- [ ] User properties are set correctly
- [ ] No PII (emails, addresses) in event logs

**Monitoring:**
- Set up Firebase Analytics dashboard with key metrics
- Create Slack alert for anomalies (e.g., 0 events for 1 hour)
- Weekly review of funnel conversion rates

---

## 9. Constraints & Non-Goals

### 9.1 Constraints

**Technical:**
- Must use Firebase Analytics (free tier) - no Mixpanel, Amplitude, etc.
- Events must follow [Firebase naming conventions](https://firebase.google.com/docs/analytics/events) (lowercase, underscores)
- Max 25 user properties per user
- Max 500 distinct event types
- Event names max 40 characters
- Parameter keys max 40 characters, values max 100 characters

**Privacy:**
- Must comply with GDPR, CCPA
- Cannot track without user consent
- Must provide opt-out mechanism
- Cannot collect PII (emails, addresses, SSNs)

**Performance:**
- Analytics calls must not block UI thread
- Max 5ms overhead per event
- Batch events to minimize network calls

### 9.2 Non-Goals (Out of Scope)

**Not in This Implementation:**
- ❌ A/B testing (Firebase Remote Config - separate SDD)
- ❌ Crash reporting (Firebase Crashlytics already integrated)
- ❌ Performance monitoring (Firebase Performance - future enhancement)
- ❌ BigQuery export (only needed if >1M events/month)
- ❌ Custom dashboards (use Firebase console for now)
- ❌ Integration with Google Ads (no paid ads yet)
- ❌ Predictive analytics (Firebase Predictions - future)

---

## 10. Open Questions

### 10.1 For User/Stakeholder

1. **Privacy Consent**:
   - Should analytics opt-in be required or opt-out?
   - Recommendation: Opt-in with clear benefits ("Help us improve")

2. **Event Priorities**:
   - Which features are most critical to measure first?
   - Recommendation: Subscription funnel > Educational engagement > NFT usage

3. **Dashboard Access**:
   - Who needs Firebase console access?
   - Required: Product manager, developer, marketing lead

4. **Budget**:
   - Free tier is 500M events/month (sufficient for 10K users)
   - If we exceed, upgrade to Blaze plan ($0.01 per 1000 events)
   - Expected cost at 10K users: ~$0 (well within free tier)

### 10.2 Technical Decisions

1. **Event Batching**:
   - Should we batch events for performance?
   - Recommendation: No - Firebase SDK already batches automatically

2. **Offline Events**:
   - What happens if user is offline?
   - Firebase SDK queues events, sends when online (no action needed)

3. **Testing Events**:
   - How to prevent test data from polluting production?
   - Use separate Firebase projects for dev/staging/prod

4. **User Identification**:
   - Should we set Firebase `userId`?
   - Yes - use anonymized user ID (hash of email or UUID)

---

## 11. Dependencies

### 11.1 Prerequisites

- [x] Firebase Analytics SDK installed ([pubspec.yaml:144])
- [ ] Firebase project created (verify `ios/Runner/GoogleService-Info.plist` exists)
- [ ] Firebase project created (verify `android/app/google-services.json` exists)
- [ ] Firebase console access granted to team

### 11.2 Blocking Dependencies

None - this is a foundational feature

### 11.3 Integration Points

**This SDD blocks:**
- `sdd-mobile-app` Story #6 (Firebase Analytics) - this IS that implementation
- Future A/B testing (needs analytics baseline first)
- Paywall optimization (needs conversion data first)

**This SDD depends on:**
- `sdd-mobile-app` Story #2 (Subscription Management) - to track subscription events
- `sdd-mobile-app` Story #1 (Onboarding) - to track onboarding events

---

## 12. Timeline & Phasing

### Phase 1: Foundation (Week 1) - HIGH PRIORITY

**Goal**: Track subscription conversion funnel

- [ ] Replace [analytics_service.dart:1-43] with Firebase implementation
- [ ] Add `FirebaseAnalyticsObserver` to app router
- [ ] Implement privacy consent dialog
- [ ] Instrument critical screens:
  - [ ] Paywall screen (`paywall_view`, `trial_start`)
  - [ ] Subscription purchase (`subscription_purchase`)
  - [ ] Onboarding screens (`onboarding_step`, `onboarding_complete`)
- [ ] Set user properties: `subscription_tier`, `trial_status`
- [ ] Test in Firebase DebugView
- [ ] Deploy to TestFlight/Internal Testing

**Success Criteria**: See 10+ test users complete onboarding → paywall → trial in Firebase console

---

### Phase 2: Feature Usage (Week 2-3) - MEDIUM PRIORITY

**Goal**: Understand which features drive engagement

- [ ] Instrument feature screens:
  - [ ] Property search (`property_search`, `property_view`, `property_save`)
  - [ ] AI predictions (`ai_prediction_request`)
  - [ ] Educational modules (`educational_module_start`, `educational_module_complete`)
- [ ] Track feature adoption metrics
- [ ] Create Firebase dashboards for feature usage

**Success Criteria**: Identify top 3 most-used and least-used features

---

### Phase 3: Monetization & Growth (Week 4+) - LOW PRIORITY

**Goal**: Track additional revenue streams

- [ ] Educational products: `course_view`, `course_purchase`, `video_watch`
- [ ] Referral program: `referral_code_share`, `referral_signup`
- [ ] NFT features: `nft_mint_view`, `nft_mint_complete`
- [ ] Set acquisition source from UTM parameters

**Success Criteria**: Calculate LTV, CAC, and referral conversion rate

---

## 13. Rollback Plan

**If analytics break the app:**

1. **Immediate Rollback** (< 5 minutes):
   ```dart
   // In analytics_service.dart
   static Future<void> trackEvent(...) async {
     return; // Disable all tracking
   }
   ```

2. **Hot Fix Deployment**:
   - Revert to stub implementation
   - Deploy via CodePush or emergency release

3. **Root Cause Analysis**:
   - Check Firebase console for SDK errors
   - Review crash logs in Firebase Crashlytics
   - Test on physical devices (not just simulator)

**Risks**:
- Low risk - analytics are non-blocking, fire-and-forget
- Worst case: Events don't get tracked (no user-facing impact)

---

## 14. Success Criteria for Requirements Approval

Before moving to SPECIFICATIONS phase:

- [ ] Stakeholder agrees on event taxonomy (Section 3)
- [ ] Stakeholder agrees on funnel definitions (Section 4)
- [ ] Stakeholder agrees on success metrics (Section 5)
- [ ] Privacy consent approach approved (Section 6)
- [ ] Open questions answered (Section 10)
- [ ] Phasing timeline acceptable (Section 12)

---

## Appendix A: Firebase Analytics Best Practices

1. **Event Naming**:
   - Use lowercase with underscores: `paywall_view`, not `paywallView`
   - Use nouns for objects, verbs for actions: `video_watch`, not `watch_video`
   - Be consistent: `course_purchase`, `subscription_purchase` (both end with `_purchase`)

2. **Parameters**:
   - Always include context: `{tier: 'premium'}`, `{source: 'search'}`
   - Use consistent parameter names across events
   - Limit to 25 parameters per event

3. **User Properties**:
   - Set once per session, not per event
   - Use for segmentation: `subscription_tier`, `acquisition_source`
   - Update when state changes: `trial_status` changes from `in_trial` to `converted`

4. **Testing**:
   - Use DebugView for real-time validation
   - Test all events before production deployment
   - Verify parameters are not null or empty

---

## Appendix B: Event Implementation Checklist

For each screen/feature:

- [ ] Identify user actions to track
- [ ] Define event name (follow naming convention)
- [ ] Define parameters (what context is needed?)
- [ ] Add `AnalyticsService.trackEvent()` call
- [ ] Test in DebugView
- [ ] Document in this spec
- [ ] Add to funnel definition (if applicable)

---

**END OF REQUIREMENTS DOCUMENT**

---

## Next Steps

1. **User Review**: Please review this requirements document
2. **Answer Open Questions**: See Section 10
3. **Approve or Request Changes**: Comment on any section
4. **Move to Specifications**: Once approved, we'll design the implementation

