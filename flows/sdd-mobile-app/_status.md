# Status: sdd-mobile-app

## Current Phase

**REQUIREMENTS** | SPECIFICATIONS | PLAN | IMPLEMENTATION

## Phase Status

**DRAFT** (Requirements being documented)

## Last Updated

2026-01-01 by Claude (Deep Refactoring & Code Verification)

## Blockers

- None currently - Critical pricing changes VERIFIED in code
- **NEXT:** Move to SPECIFICATIONS phase (approved)

## Progress

- [x] Requirements drafted ✅ **COMPLETE**
- [ ] Requirements approved
- [ ] Specifications drafted
- [ ] Specifications approved
- [ ] Plan drafted
- [ ] Plan approved
- [ ] Implementation started
- [ ] Implementation complete

## Context Notes

Key decisions and context for resuming:

### Business Model (7 Revenue Streams)
1. **Subscriptions** (main): $19.99 Starter, $49.99 Premium, $199.99 Enterprise
2. **Educational Products**: $27-$297 courses (content from 3rdparty/awesomely)
3. **Transaction Fees**: 2.5% lien purchase, 5% NFT sales, 1% withdrawals
4. **Referral Program**: $20 referrer, $10 referee
5. **Data-as-a-Service**: $99-$999/мес API access
6. **White-Label**: $5K setup + $1.5-5K/мес
7. **Fractional NFT**: 3% trading fees

**Year 1 Revenue Target**: $300K-500K
**Month 12 MRR Target**: $50K-80K

### Critical Changes Status

**✅ COMPLETED (CODE VERIFIED 2026-01-01):**
1. ✅ **Trial Period**: 365 days → 14 days **IMPLEMENTED ✓**
   - File: `lib/core/constants/subscription_constants.dart:43`
   - `trialDurationDays = 14` + tiered trials (7/14/30)
   - Impact: Prevents $300K/year revenue loss
   - Status: **Code verified - DONE**

2. ✅ **Pricing**: $29.99 → $49.99 Premium **IMPLEMENTED ✓**
   - File: `lib/core/constants/subscription_constants.dart:123`
   - `premiumMonthlyPrice = '$49.99'`
   - Impact: +67% ARPU
   - Status: **Code verified - DONE**

3. ✅ **New Tier**: Starter $19.99 **IMPLEMENTED ✓**
   - File: `lib/core/constants/subscription_constants.dart:118-120`
   - `starterMonthlyPrice = '$19.99'`
   - Impact: Entry point for price-sensitive users
   - Status: **Code verified - Constants defined, needs IAP store config**

**HIGH PRIORITY (Week 2-4):**
4. ⏳ **Paywall Triggers**: Strategic moments (search limit, AI limit)
   - New file: `lib/services/paywall_trigger_service.dart`
   - Impact: Increase free → paid conversion 5% → 10%

5. ⏳ **ML API Integration**: Replace mock AI service
   - File: `lib/services/ai_investment_advisor_service.dart`
   - Dependency: sdd-ml-service API deployment
   - Impact: Real predictions, higher trust

6. ⏳ **Firebase Analytics**: Event tracking, funnels
   - Files: Various screens + services
   - Impact: Data-driven optimization

**MEDIUM PRIORITY (Week 5-8):**
7. ⏳ **In-App Education**: 5 modules (start with Module 1)
   - New directory: `lib/features/education/`
   - Content: 3rdparty/awesomely guidebook
   - Impact: Reduce churn, increase engagement

8. ⏳ **Referral Program**: Codes, rewards, tracking
   - New feature: `lib/features/referrals/`
   - Impact: Viral growth, CAC reduction

9. ⏳ **Transaction Fees**: Calculate and collect
   - New file: `lib/core/constants/fee_constants.dart`
   - Impact: Additional $32K/мес at $500K GMV

### Technology Stack Confirmed
- **Framework**: Flutter (existing)
- **Authentication**: Firebase Auth
- **Analytics**: Firebase Analytics
- **IAP**: RevenueCat (recommended) or in_app_purchase plugin
- **Video**: Vimeo (educational content)
- **Storage**: MinIO/S3 (PDFs, documents)
- **Payment**: Stripe (courses, transaction fees)
- **Backend**: FastAPI ML service + existing Magento API

### User Stories Summary (8 Primary)
1. **Onboarding**: Learn-to-Earn flow (modules unlock features)
2. **Subscription Management**: Paywall, tier comparison, trial
3. **AI Predictions**: Real ML (redemption, risk, ROI)
4. **Educational Purchases**: Buy courses separately
5. **Referral Program**: Share code, earn rewards
6. **Transaction Fees**: Transparent fee calculation
7. **Portfolio Analytics**: Premium feature
8. **Firebase Analytics**: Track all user actions

### Key Design Principles
1. **Learn-to-Earn**: Education unlocks features (gamification)
2. **Transparent Pricing**: Clear value props, no hidden fees
3. **Data-Driven**: Firebase Analytics for optimization
4. **Premium Justification**: ML predictions worth $297/month
5. **Viral Mechanics**: Referrals, NFT social sharing

### Integration with Other SDDs
- **sdd-ml-service**: Provides AI predictions API
  - Endpoints: `/predict/redemption`, `/predict/risk`, `/predict/roi`
  - Response time: <200ms target
  - Fallback: Cached predictions if API fails

- **sdd-data-structure**: Property data source
  - 90+ attributes for ML features
  - PostgreSQL queries for search

- **sdd-scraper-service**: Fresh property data
  - 15+ platforms support
  - Daily updates

### Open Design Questions
- [ ] **IAP Platform**: RevenueCat vs native in_app_purchase?
  - RevenueCat: Easier, analytics, but $1/month per subscriber
  - Native: Free, but more complex

- [ ] **Video Hosting**: Vimeo vs YouTube private?
  - Vimeo: Better DRM, but $20/month
  - YouTube: Free, but watermark

- [ ] **Content Production**: In-house vs Fiverr?
  - In-house: Higher quality, but slower
  - Fiverr: Faster, cheaper ($2K for 15 videos)

- [ ] **A/B Testing**: Firebase Remote Config vs Optimizely?
  - Firebase: Free, integrated
  - Optimizely: More features, but $50K/year

## Next Actions

1. **User Review**: Validate monetization assumptions
   - Are prices acceptable? ($19.99, $49.99, $199.99)
   - Is 14-day trial sufficient?
   - Which revenue streams to prioritize?

2. **Approve Requirements** or iterate on open questions

3. **Move to SPECIFICATIONS Phase**:
   - UI/UX wireframes (Figma mockups)
   - API integration specs (ML service, Stripe, RevenueCat)
   - Firebase Analytics event taxonomy
   - IAP product configuration (App Store + Google Play)

4. **Content Planning**:
   - Script Module 1 videos (3 lessons × 10 min)
   - Design quiz questions
   - Create PDF guidebook chapters

5. **Dependencies Check**:
   - Is ML service API ready? (sdd-ml-service)
   - Is PostgreSQL populated? (sdd-data-structure)
   - Is Firebase project created?
