# Mobile App SDD - Quick Reference

> Last Updated: 2025-12-31
> Status: REQUIREMENTS phase (COMPLETE ✅)

## 🎯 One-Liner

Превратить Flutter app в **"Learn-to-Earn"** платформу с 7 источниками дохода, где образование открывает функционал и монетизируется.

---

## 💰 7 Revenue Streams (Month 12 Target: $81K MRR)

| Stream | Pricing | Expected MRR |
|--------|---------|--------------|
| **1. Subscriptions** | $19.99-$199.99 | $24,995 |
| **2. Educational Products** | $27-$297 | $10,000 |
| **3. Transaction Fees** | 2.5-5% | $32,500 |
| **4. Referral Program** | $20 per conversion | Included in subscriptions |
| **5. Data API** | $99-$999 | $2,990 |
| **6. White-Label** | $1.5K-5K | $7,500 |
| **7. NFT Trading** | 3% fee | $3,000 |
| **TOTAL** | | **$80,985** |

---

## 🚨 Critical Changes (URGENT - Week 1)

### ✅ Already Fixed in Code

1. **Trial Period:** 365 days → 14 days
   - File: [subscription_constants.dart](../../apps/taxlien-app/lib/core/constants/subscription_constants.dart:43)
   - Impact: Prevents $300K/year revenue loss
   - Status: ✅ DONE

2. **Pricing:** $29.99 → $49.99 Premium
   - File: [subscription_constants.dart](../../apps/taxlien-app/lib/core/constants/subscription_constants.dart:123)
   - Impact: +67% ARPU
   - Status: ✅ DONE

3. **New Tier:** Starter $19.99
   - File: [subscription_constants.dart](../../apps/taxlien-app/lib/core/constants/subscription_constants.dart:118)
   - Impact: Entry point for price-sensitive users
   - Status: ✅ Constants defined

### ⏳ Pending Implementation

4. **Configure IAP Products** (App Store + Google Play)
5. **Paywall Triggers** (search limit, AI limit, county access)
6. **ML API Integration** (replace mock service)
7. **Firebase Analytics** (event tracking, funnels)

---

## 🎓 Learn-to-Earn Flow

```
USER JOURNEY:

Sign Up (FREE)
   ↓
Module 1: "What is a Tax Lien?" (8 min video)
   ↓ Quiz passed (80%+)
UNLOCK: Search feature (10 searches/day)
   ↓
After 10th search → PAYWALL
   ↓ Option A: Upgrade to STARTER ($19.99)
Module 2: "Property Research" (18 min)
   ↓ Quiz passed
UNLOCK: County data (50 counties), unlimited searches
   ↓
After 10th AI analysis → PAYWALL
   ↓ Option B: Upgrade to PREMIUM ($49.99)
Module 3-5: Full course (97 min total)
   ↓ All quizzes passed
UNLOCK: All features (AI, NFT, analytics, real-time bidding)
   ↓
ACHIEVEMENT: "Tax Lien Master" + Certificate PDF
```

---

## 🚪 Paywall Triggers (Strategic Moments)

### Free Tier → Starter/Premium

```dart
// When to interrupt user with paywall:

1. SEARCH LIMIT: After 10th search today
   → "Unlock unlimited searches with Starter"

2. AI LIMIT: After 3rd AI analysis this month
   → "Get 10 AI analyses/month with Starter, unlimited with Premium"

3. PORTFOLIO LIMIT: When saving 6th favorite
   → "Expand your portfolio to 25 with Starter, unlimited with Premium"

4. COUNTY ACCESS: Trying to access 11+ county
   → "Access all 3,000+ counties with Premium"

5. FEATURE LOCK: NFT minting, export, real-time bidding
   → "This is a Premium feature"
```

**Paywall Design:**
- Comparison table (Free vs Starter vs Premium)
- Social proof ("Join 10,000+ investors")
- Urgency ("14-day trial ending in 3 days")
- CTA: "Start 14-Day Free Trial" (large button)

---

## 🤖 AI Integration (Mock → Real ML)

### Current Implementation (Mock)

```dart
// lib/services/ai_investment_advisor_service.dart
class AIInvestmentAdvisorService {
  Future<AIAnalysisResult> analyzeTaxLien(TaxLien lien) async {
    // Hardcoded formulas
    double riskScore = _calculateRiskScore(lien); // ❌ Not real ML
    // ...
  }
}
```

### New Implementation (Real ML API)

```dart
class AIInvestmentAdvisorService {
  final String mlApiUrl = 'https://api.taxlien.online/api/v1';

  Future<AIAnalysisResult> analyzeTaxLien(TaxLien lien) async {
    // Check usage limits
    if (!await _canUseAI()) throw AIUsageLimitException();

    // Call real ML API (sdd-ml-service)
    final response = await http.post(
      '$mlApiUrl/predict/batch',
      body: {'parcel_ids': [lien.parcelId]},
    );

    // Parse predictions
    return AIAnalysisResult(
      riskScore: data['risk_score'],
      redemptionProbability: data['redemption_probability'],
      expectedROI: data['expected_roi'],
      paybackMonths: data['payback_months'],
      featureImportance: data['feature_importance'], // Top 5 factors
    );
  }
}
```

**Dependency:** [sdd-ml-service](../sdd-ml-service/) API must be deployed
**Performance Target:** <3 sec (ideally <2 sec)
**Fallback:** Cached predictions if API fails

---

## 📊 Firebase Analytics Events

### Critical Events to Track

```dart
// User lifecycle
'app_open', 'sign_up', 'login'

// Subscription funnel
'trial_start', 'trial_convert', 'trial_expire'
'subscription_start', 'subscription_cancel'

// Paywall conversion
'paywall_view', 'paywall_convert', 'paywall_dismiss'

// Feature usage
'search_property', 'view_property', 'save_favorite'
'ai_analysis_request', 'ai_analysis_complete'

// Education
'course_module_start', 'course_module_complete'
'quiz_attempt', 'quiz_pass', 'quiz_fail'

// Monetization
'course_purchase', 'lien_purchase', 'nft_mint'
'referral_code_share', 'referral_conversion'
```

### User Properties

```dart
// Segment users by:
'subscription_tier': 'free' | 'starter' | 'premium' | 'enterprise'
'trial_days_remaining': 14 → 0
'ltv': $0 → $600+
'cohort': '2025-12'
'course_completion_rate': 0% → 100%
```

---

## 🎯 Success Metrics (12-Month Targets)

### Business KPIs

| Metric | Baseline | Target | How to Measure |
|--------|----------|--------|----------------|
| **MRR** | $0 | $50,000 | RevenueCat dashboard |
| **Free → Paid** | 5% | 10% | Firebase funnel |
| **ARPU** | $29.99 | $49.99 | Revenue / Paid users |
| **Churn Rate** | 15%/mo | 5%/mo | Cancelled / Total |
| **Trial → Paid** | 10% | 25% | Trial conversions |
| **Course Sales** | 0 | $10K/mo | IAP revenue |

### User Engagement

| Metric | Target | How to Measure |
|--------|--------|----------------|
| **DAU/MAU** | 30% | Firebase Analytics |
| **Session Duration** | 8 min | Firebase Analytics |
| **Course Completion** | 50% | Custom events |
| **Referral Rate** | 15% | Users with 1+ ref / Total |

---

## 🔧 Tech Stack Summary

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Framework** | Flutter | Cross-platform mobile |
| **Backend** | FastAPI (ML), Magento (existing) | APIs |
| **Auth** | Firebase Auth | Email, Google, Apple sign-in |
| **Analytics** | Firebase Analytics | Events, funnels, properties |
| **IAP** | RevenueCat | Subscription management |
| **Payment** | Stripe | Courses, transaction fees |
| **Video** | Vimeo | Educational content |
| **Storage** | MinIO/S3 | PDFs, documents |
| **Database** | PostgreSQL (remote), SQLite (local) | Property data, offline |

---

## 📁 File Structure (New Files to Create)

```
apps/taxlien-app/lib/
├── features/
│   ├── education/
│   │   ├── models/
│   │   │   ├── course_module.dart
│   │   │   ├── lesson.dart
│   │   │   └── quiz.dart
│   │   ├── screens/
│   │   │   ├── course_home_screen.dart
│   │   │   ├── lesson_video_screen.dart
│   │   │   └── quiz_screen.dart
│   │   ├── widgets/
│   │   │   ├── progress_bar.dart
│   │   │   ├── achievement_badge.dart
│   │   │   └── certificate_viewer.dart
│   │   └── services/
│   │       ├── course_progress_service.dart
│   │       └── achievement_service.dart
│   │
│   ├── paywall/
│   │   ├── screens/
│   │   │   ├── paywall_screen.dart
│   │   │   └── subscription_management_screen.dart
│   │   ├── widgets/
│   │   │   ├── tier_comparison_table.dart
│   │   │   └── pricing_card.dart
│   │   └── services/
│   │       └── paywall_trigger_service.dart
│   │
│   └── referrals/
│       ├── screens/
│       │   └── referral_dashboard_screen.dart
│       ├── widgets/
│       │   ├── referral_code_widget.dart
│       │   └── reward_tracker.dart
│       └── services/
│           └── referral_service.dart
│
├── services/
│   ├── ai_investment_advisor_service.dart (UPDATE)
│   ├── analytics_service.dart (NEW)
│   └── subscription_service.dart (NEW)
│
└── core/
    └── constants/
        └── fee_constants.dart (NEW)
```

---

## 🔗 Integration with Other SDDs

### sdd-ml-service (AI Predictions)

**Endpoints:**
- `POST /api/v1/predict/redemption` → redemption_probability
- `POST /api/v1/predict/risk` → risk_score (0-100)
- `POST /api/v1/predict/roi` → expected_roi, payback_months

**Response Time:** <200ms (acceptable: <500ms)

**Error Handling:**
- API down → fallback to cached predictions
- Rate limit → show "Premium users get priority"
- Timeout → retry with exponential backoff

### sdd-data-structure (Property Data)

**PostgreSQL Queries:**
- Search properties (with filters: county, state, price range)
- Get property details (90+ attributes)
- Save favorites (user_id, parcel_id)

**Performance:** <1 sec for search results

### sdd-scraper-service (Fresh Data)

**Integration:**
- Daily updates from 15+ platforms
- New properties appear in search
- Updated tax amounts, auction dates

---

## ⚠️ Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Low conversion (<5%)** | High | Medium | A/B test paywalls, improve education |
| **High churn (>10%)** | High | Medium | Better onboarding, retention features |
| **App Store rejection** | High | Low | Follow guidelines, clear disclosures |
| **ML API downtime** | Medium | Low | Fallback to cached predictions |
| **Content production delay** | Medium | Medium | Start with Module 1 only |
| **Privacy compliance** | High | Low | GDPR/CCPA audit before launch |

---

## 📅 12-Week Implementation Plan

### Phase 1: Critical Fixes (Week 1-2) ✅
- ✅ Trial: 365 → 14 days
- ✅ Pricing: $29.99 → $49.99
- ⏳ Configure IAP (App Store + Google Play)

### Phase 2: Paywall & Analytics (Week 3-4)
- Paywall trigger system
- Firebase Analytics integration
- A/B testing framework (Remote Config)

### Phase 3: ML Integration (Week 5-6)
- Replace mock AI service
- API error handling
- Usage tracking (3 free analyses/month)

### Phase 4: Education MVP (Week 7-8)
- Module 1 implementation (videos, quiz)
- Progress tracking
- Achievement system

### Phase 5: Monetization (Week 9-10)
- Referral program
- Transaction fee calculation
- Stripe integration (courses)

### Phase 6: Launch (Week 11-12)
- E2E testing
- Beta testing (TestFlight/Internal)
- Soft launch + monitoring

---

## 📝 Next Steps (Immediate Actions)

### For User Review:

1. **Validate Pricing:**
   - Is $49.99 Premium acceptable? (Industry standard: $49-99)
   - Is $19.99 Starter a good entry point?
   - Is 14-day trial enough? (vs 7 days or 30 days)

2. **Prioritize Revenue Streams:**
   - Which to launch first? (Subscriptions + Education recommended)
   - Which can wait? (White-label, Data API can be later)

3. **Content Production:**
   - In-house vs Fiverr? (Fiverr = $2K for 15 videos)
   - Video length? (Current plan: 8-15 min per lesson)
   - Quiz difficulty? (Current: 80% to pass)

### For Development:

1. **SPECIFICATIONS Phase:**
   - Create Figma wireframes (paywall, education screens)
   - Define API integration specs
   - Plan Firebase Analytics taxonomy

2. **Content Planning:**
   - Script Module 1 videos (3 lessons)
   - Design quiz questions (5-20 per module)
   - Extract guidebook chapters (from 3rdparty/awesomely)

3. **Infrastructure:**
   - Create Firebase project
   - Set up RevenueCat account
   - Configure Stripe Connect

---

## 📞 Quick Links

**Documentation:**
- [Requirements](01-requirements.md) - Full business model, user stories, metrics
- [Status](_status.md) - Current phase, blockers, progress

**Code References:**
- [subscription_constants.dart](../../apps/taxlien-app/lib/core/constants/subscription_constants.dart) - Pricing, trial, limits
- [ai_investment_advisor_service.dart](../../apps/taxlien-app/lib/services/ai_investment_advisor_service.dart) - Mock AI (needs replacement)

**Related SDDs:**
- [ML Service](../sdd-ml-service/) - AI predictions API
- [Data Structure](../sdd-data-structure/) - PostgreSQL schema
- [Scraper Service](../sdd-scraper-service/) - Fresh property data

**External Resources:**
- Educational content: [3rdparty/awesomely/](../../3rdparty/awesomely/)
- Sample data: [samples/](../../samples/) (322 HTML files)

---

**Last Updated:** 2025-12-31 by Claude (AI Assistant)
**Current Status:** REQUIREMENTS complete ✅
**Next Milestone:** SPECIFICATIONS (UI/UX design, API integration)
**Timeline:** 12 weeks to launch
**Investment:** ~$5K (content production)
**Expected ROI:** 20x+ in Year 1 ($300K-500K revenue from $5K investment)
