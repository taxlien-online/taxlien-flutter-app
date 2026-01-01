# Requirements: Trial Period & Pricing Optimization

> Version: 1.0
> Status: DRAFT
> Last Updated: 2025-12-30

## Problem Statement

### Critical Revenue Leak

The current trial configuration has a **365-day trial period** - this is catastrophic for monetization:

```dart
// apps/taxlien-app/lib/core/constants/subscription_constants.dart:34
class TrialConfig {
  static const int trialDurationDays = 365;  // 🚨 PROBLEM!
}
```

**Impact Analysis:**
- Users get 1 full year of Premium features for free
- No urgency to convert to paid subscription
- Lost revenue: ~$300K/year at 1,000 trial users
- Industry standard: 7-30 days, not 365 days
- Psychological effect: "I'll decide later" → never converts

### Under-Pricing Problem

Current pricing is below market rate:
- Premium: $29.99/month (should be $49.99)
- Enterprise: $99.99/month (should be $199.99)
- No Starter tier for price-sensitive users
- Competitors (RealtyTrac, Foreclosure.com): $50-100/month

### Missing Paywall Triggers

Currently, free users can access too much without hitting limits:
- No search limits
- No AI analysis limits
- No portfolio size limits
- No county access restrictions

**Result:** Users never feel the need to upgrade.

---

## User Stories

### Primary

#### Story 1: Platform Owner wants to protect revenue

**As a** platform owner
**I want** a reasonable trial period (14 days)
**So that** users convert to paid subscriptions instead of using free trial indefinitely

**Success Metrics:**
- Trial-to-paid conversion rate: 10-15% (industry standard)
- Revenue increase: 67% from pricing changes
- Reduced trial abuse

#### Story 2: Free user hits meaningful limits

**As a** free-tier user
**I want** to explore the app with reasonable limits
**So that** I understand the value before committing to paid subscription

**Limits Design:**
- 10 property searches per day (enough to explore)
- 3 AI analyses per month (taste of premium feature)
- 5 properties in portfolio (can track a few)
- Access to top 10 counties only (covers major markets)

#### Story 3: Price-sensitive user finds affordable option

**As a** beginner investor with limited budget
**I want** a Starter tier at $19.99/month
**So that** I can access basic features without committing to Premium pricing

### Secondary

#### Story 4: Premium user sees clear value

**As a** Premium subscriber
**I want** unlimited access and advanced features
**So that** the $49.99/month feels justified

#### Story 5: Enterprise user gets professional tools

**As an** institutional investor or power user
**I want** bulk operations, API access, and priority support
**So that** the $199.99/month investment makes sense for my scale

---

## Acceptance Criteria

### Must Have

#### 1. Trial Period Reduction

**Given** a new user signs up
**When** they start the trial
**Then** the trial period is 14 days (not 365)

**Implementation:**
```dart
class TrialConfig {
  static const int trialDurationDays = 14;
  static const int starterTrialDays = 7;    // Starter tier
  static const int premiumTrialDays = 14;   // Premium tier
  static const int enterpriseTrialDays = 30; // Enterprise tier
}
```

#### 2. Paywall Triggers for Free Users

**Given** a free-tier user
**When** they hit usage limits
**Then** they see a paywall with upgrade CTA

**Limits:**
- ✅ 10 searches per day
- ✅ 3 AI analyses per month
- ✅ 5 properties in portfolio
- ✅ Top 10 counties only

#### 3. New Pricing Tiers

**Given** pricing needs to match market value
**When** displaying subscription options
**Then** show 3 tiers:

| Tier | Monthly | Yearly | Features |
|------|---------|--------|----------|
| **Starter** | $19.99 | $199.99 | Basic search, 10 counties, limited AI |
| **Premium** | $49.99 | $499.99 | Unlimited, all counties, NFT, real-time |
| **Enterprise** | $199.99 | $1,999.99 | API access, bulk ops, priority support |

#### 4. Paywall Screen Updates

**Given** user hits a premium feature or limit
**When** paywall is shown
**Then** display:
- Clear feature comparison table
- Trial countdown (if in trial: "14 days left")
- Urgency messaging ("Unlock unlimited searches now")
- CTA buttons for each tier

#### 5. Grace Period After Trial

**Given** trial expires
**When** user tries to use premium features
**Then** show soft paywall (can still browse free features, but premium blocked)

**Not a hard lock:** User can still access:
- Basic property viewing
- Educational content (Module 1)
- Account settings

#### 6. Grandfather Existing Users

**Given** existing users on 365-day trial
**When** this update deploys
**Then** honor their existing trial end date (don't retroactively reduce)

**New users only:** 14-day trial applies to new sign-ups after deployment.

---

### Should Have

#### 7. Trial Extension for Engagement

**Given** user completes educational Module 1
**When** they finish the quiz
**Then** reward +7 days trial extension

**Gamification:** Incentivize education completion.

#### 8. Pricing A/B Test Infrastructure

**Given** need to optimize conversion rates
**When** new users sign up
**Then** randomly assign to A/B test groups:
- Control: $49.99 Premium
- Test A: $39.99 Premium
- Test B: $59.99 Premium

**Firebase Analytics:** Track conversion rates by price point.

#### 9. Referral Trial Bonus

**Given** user refers a friend
**When** friend signs up with referral code
**Then** both users get +7 days trial extension (max 30 days total)

#### 10. Feature Usage Analytics

**Given** need to understand paywall triggers
**When** user hits any limit
**Then** log Firebase Analytics event:
```dart
analytics.logEvent(
  name: 'paywall_triggered',
  parameters: {
    'trigger_type': 'search_limit', // or 'ai_limit', 'portfolio_limit', etc.
    'user_tier': 'free',
    'trial_days_remaining': 7,
  }
);
```

---

### Won't Have (This Iteration)

- **Dynamic pricing** based on user location (future: localized pricing)
- **Lifetime deals** (too risky for early-stage business)
- **Crypto payment option** (future: accept payment in ICP tokens)
- **Team/Family plans** (future: multi-user subscriptions)
- **Custom enterprise contracts** (future: negotiate pricing for large firms)

---

## Constraints

### Technical

- **Must** work with existing subscription_constants.dart structure
- **Must** integrate with current Riverpod state management
- **Must** support iOS, Android, and Web platforms
- **Must NOT** break existing payment flows
- **Must** handle App Store/Play Store product IDs correctly

### Performance

- **Paywall check:** < 50ms (shouldn't slow down app)
- **Trial countdown:** Calculate client-side, sync with server daily

### Platform

- **iOS:** Must comply with App Store guidelines (no misleading trial terms)
- **Android:** Must comply with Play Store subscription policies
- **Web:** Stripe Checkout for direct payment

### Business

- **Grandfather clause:** Don't anger existing users with retroactive changes
- **Communication:** Email all trial users 7 days before expiration
- **Support:** Prepare FAQ for "why did trial change?" questions

---

## Open Questions

- [ ] **App Store approval:** Will Apple approve the trial period change? (Need to update metadata)
- [ ] **Existing trial users:** Notify them of new pricing, or silent update?
- [ ] **Trial restart prevention:** How to prevent users from creating new accounts to restart trial?
  - Option A: Email verification + device fingerprinting
  - Option B: Require phone number verification (higher friction)
  - Option C: IP address tracking (easy to bypass with VPN)
- [ ] **Paywall messaging:** Friendly vs urgent tone? A/B test needed.
- [ ] **Starter tier features:** Exactly which features are included vs Premium?
- [ ] **Trial for paid downgrade:** If Enterprise downgrades to Premium, do they get a trial?

---

## References

- Current implementation: [apps/taxlien-app/lib/core/constants/subscription_constants.dart](/Users/anton/proj/TAXLIEN.online/apps/taxlien-app/lib/core/constants/subscription_constants.dart)
- Business plan: [.claude/plans/hashed-petting-fox.md](/Users/anton/.claude/plans/hashed-petting-fox.md)
- Competitor analysis:
  - RealtyTrac: $49.99/mo, 7-day trial
  - Foreclosure.com: $79.99/mo, 14-day trial
  - Tax Sale Lists: $29.99/mo, no trial
- Industry benchmarks:
  - SaaS average trial: 14 days
  - Trial-to-paid conversion: 10-15%
  - Acceptable churn rate: <5%/month

---

## Success Metrics

**Before Implementation:**
- Trial period: 365 days
- Pricing: $29.99 Premium, $99.99 Enterprise
- Trial conversion rate: Unknown (likely <5%)
- MRR: $0 (pre-launch)

**After Implementation (Target - Month 3):**
- Trial period: 14 days
- Pricing: $19.99 Starter, $49.99 Premium, $199.99 Enterprise
- Trial conversion rate: 10-15%
- MRR: $10,000 (200 users × average $50 ARPU)
- Revenue protection: $300K/year saved

**Key Performance Indicators:**
1. **Trial Conversion Rate:** % of trial users who become paid subscribers
2. **ARPU (Average Revenue Per User):** Should increase from $29.99 to ~$50
3. **Paywall Impression Rate:** How often users see paywall triggers
4. **Feature Upgrade Rate:** % who upgrade after hitting free limits
5. **Churn Rate:** % of paid users who cancel per month (target: <5%)

---

## Approval

- [ ] Reviewed by: Anton (Product Owner)
- [ ] Approved on: [Pending requirements review]
- [ ] Notes: Need to validate trial change doesn't violate any legal/contractual obligations to beta testers
