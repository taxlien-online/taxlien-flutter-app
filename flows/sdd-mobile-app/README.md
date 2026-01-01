# SDD: Mobile App - In-App Education & Monetization

> Flutter мобильное приложение с Learn-to-Earn концепцией
> Status: Requirements Complete ✅
> Last Updated: 2025-12-31

## 🎯 Overview

Превратить TAXLIEN.online мобильное приложение в **"Learn-to-Earn" платформу**, где образование открывает функционал и монетизируется через 7 источников дохода.

**Текущее состояние:**
- MVP готов на 85% (Flutter app)
- ❌ 365-дневный trial (КРИТИЧНО - уже исправлено на 14 дней!)
- ❌ Заниженные цены $29.99 (исправлено на $49.99)
- ❌ Mock AI service (нужна интеграция с ML API)
- ⏳ Firebase Analytics частично интегрирован
- ⏳ Нужна система in-app education

**Бизнес-цели:**
- Year 1 Revenue: $300K-500K
- Month 12 MRR: $50K-80K
- Free → Paid conversion: 5% → 10%
- Churn reduction: 15% → 5%

---

## 📁 Documentation

### Quick Reference
- **[SUMMARY.md](SUMMARY.md)** - Quick reference guide 📋
  - 7 revenue streams summary ($81K MRR target)
  - Critical changes (trial, pricing)
  - Learn-to-Earn flow diagram
  - Paywall triggers, tech stack, next steps

### Requirements
- **[01-requirements.md](01-requirements.md)** - Complete requirements ✅
  - Problem statement (365-day trial, low prices, no education)
  - 7 revenue streams (subscriptions, courses, fees, referrals, data API, white-label, NFT)
  - 8 primary user stories (onboarding, paywall, AI predictions, purchases, referrals)
  - Feature requirements (education system, paywall triggers, ML integration, Firebase Analytics)
  - Success metrics (10% conversion, $50K MRR, 5% churn)

### Specifications
- **[02-specifications.md](02-specifications.md)** - Pending
  - UI/UX wireframes (paywall, education, referrals)
  - API integration specs (ML service, RevenueCat, Stripe)
  - Firebase Analytics taxonomy
  - IAP configuration

### Plan
- **[03-plan.md](03-plan.md)** - Pending
  - Implementation tasks breakdown
  - Educational content production plan
  - Testing strategy
  - 12-week deployment roadmap

---

## 💰 7 Revenue Streams

### 1. Subscriptions (Основной доход)

```
FREE:
- 10 searches/day
- Top 10 counties
- 3 AI analyses/month
- Module 1 only

STARTER: $19.99/мес ($199.99/год)
- Unlimited searches
- 50 counties
- 10 AI analyses/month
- Modules 1-2

PREMIUM: $49.99/мес ($499.99/год) ← ОСНОВНОЙ
- All 3,000+ counties
- Unlimited AI
- NFT integration
- Modules 1-5 (full course)
- Real-time bidding

ENTERPRISE: $199.99/мес ($1,999.99/год)
- API access
- Multi-user (10 seats)
- White-label options
```

**Trial:** ~~365 days~~ → **14 days** (уже исправлено!)

**Expected MRR (Month 12):**
- 500 paid users × $49.99 avg = **$24,995/мес**

### 2. Educational Products

```
Tax Lien Mastery Course: $297
County Research Bundle: $47
Portfolio Templates: $27
Full Bundle: $297
```

**Content Source:** 3rdparty/awesomely guidebook

**Expected Revenue:** $10,000/мес

### 3. Transaction Fees

```
Lien purchase: 2.5% (min $5)
NFT minting: $19.99 flat
NFT sales: 5%
Withdrawals: 1%
```

**Expected Revenue** (at $500K GMV): $32,500/мес

### 4. Referral Program

```
Referrer: $20 cash
Referee: $10 discount
Top referrers (10+): Limited Edition NFT
```

**CAC Reduction:** $50 organic + $30 referral = $80 total

### 5. Data-as-a-Service

```
API access for institutional investors:
$99/мес → $999/мес
```

**Expected Revenue** (10 clients): $2,990/мес

### 6. White-Label Platform

```
Setup: $5,000 one-time
Monthly: $1,500-$5,000
```

**Expected Revenue** (3 clients): $7,500/мес

### 7. Fractional NFT Marketplace

```
Trading fee: 3%
```

**Expected Revenue:** $3,000/мес

### Total Projected Revenue (Month 12)

```
Subscriptions:          $24,995
Educational products:   $10,000
Transaction fees:       $32,500
Data API:               $2,990
White-label:            $7,500
NFT trading:            $3,000
---------------------------------
TOTAL MRR:              $80,985/мес
ANNUAL:                 $971,820

Year 1 realistic: $300K-500K
```

---

## 🎓 Learn-to-Earn Education System

### Module Structure (5 Modules)

**Module 1: Tax Lien Basics** (FREE)
- 3 video lessons (19 min total)
- Quiz (5 questions, 80% to pass)
- **Unlocks:** Search feature

**Module 2: Property Research** (STARTER)
- 3 lessons + phone scripts
- Quiz (10 questions)
- **Unlocks:** County data (50 counties)

**Module 3: Sweet Spot Strategy** (PREMIUM)
- 4 lessons (33 min)
- Quiz (15 questions)
- **Unlocks:** AI predictions + Sweet Spot filter

**Module 4: NFT Integration** (PREMIUM)
- 3 lessons (24 min)
- Quiz (10 questions)
- **Unlocks:** NFT minting & trading

**Module 5: Advanced Strategies** (PREMIUM)
- 4 lessons (45 min)
- Quiz (20 questions)
- **Unlocks:** Portfolio analytics

### Gamification

```
Achievements:
- First Search (10 points)
- Module 1 Complete (50 points)
- First AI Analysis (25 points)
- Premium Subscriber (100 points)
- First NFT Mint (75 points)
- 10 Referrals (200 points)
```

**Progress Tracking:** Firebase Firestore sync
**Certificates:** Generated PDF after completion

---

## 🚪 Paywall Strategy

### Triggers (When to Show Paywall)

```dart
FREE TIER:
- After 10th search in a day
- After 3rd AI analysis in a month
- When portfolio reaches 5 liens
- When accessing 11+ county
- When trying to export data
- When trying to mint NFT

STARTER TIER:
- After 10th AI analysis in a month
- When accessing 51+ county
- When trying NFT features
```

### Paywall Components

- **Comparison Table**: Free vs Starter vs Premium
- **Social Proof**: "Join 10,000+ investors"
- **Urgency**: "14-day trial ending in X days"
- **Value Props**: "Unlock AI predictions worth $297/month"
- **Risk Reduction**: "Cancel anytime"
- **CTA**: "Start 14-Day Free Trial"

**A/B Testing:** Firebase Remote Config for copy optimization

---

## 🤖 AI Integration (Real ML)

### Current (Mock Service)

```dart
// Mock calculations with hardcoded formulas
double riskScore = _calculateRiskScore(lien);
double profitPotential = _calculateProfitPotential(lien);
```

### New (Real ML API)

```dart
// Call ML service API
final response = await http.post(
  '$mlApiUrl/predict/batch',
  body: {
    'parcel_ids': [lien.parcelId],
    'models': ['redemption', 'risk', 'roi'],
  },
);

// Parse predictions
redemptionProbability = data['redemption_probability'];
riskScore = data['risk_score'];
expectedROI = data['expected_roi'];
```

**Integration Point:** sdd-ml-service API
**Performance:** <3 sec response time (target <2 sec)
**Fallback:** Cached predictions if API fails

---

## 📊 Firebase Analytics

### Key Events

```
User Lifecycle:
- app_open, sign_up, login

Subscription:
- subscription_start, subscription_cancel
- trial_start, trial_convert, trial_expire

Paywall:
- paywall_view, paywall_convert, paywall_dismiss

Search & Browse:
- search_property, view_property, save_favorite

AI Analysis:
- ai_analysis_request, ai_analysis_complete

Education:
- course_module_start, course_module_complete
- quiz_attempt, quiz_pass

Referrals:
- referral_code_share, referral_conversion

NFT:
- nft_mint, nft_list, nft_sale

Purchases:
- course_purchase, lien_purchase
```

### User Properties

```
- subscription_tier
- trial_days_remaining
- ltv (lifetime value)
- cohort (e.g., "2025-12")
- total_ai_analyses
- course_completion_rate
- referral_count
```

### Conversion Funnels

```
Sign-up → Trial → Paid
Free → Paywall → Paid
Course Viewer → Course Buyer
```

---

## 🔧 Tech Stack

**Framework:**
- Flutter (existing codebase)
- Dart 3.0+

**Backend Integration:**
- ML Service API (FastAPI from sdd-ml-service)
- Magento API (existing)

**Firebase Services:**
- Authentication (email, Google, Apple)
- Analytics (events, funnels, user properties)
- Crashlytics (crash reporting)
- Remote Config (A/B testing)
- Firestore (course progress sync)

**In-App Purchases:**
- RevenueCat (recommended) or in_app_purchase plugin
- Apple App Store
- Google Play Store

**Payment Processing:**
- Stripe (for courses, transaction fees)

**Content Delivery:**
- Vimeo (video hosting, private)
- MinIO/S3 (PDF storage)

**Local Storage:**
- SQLite (course progress, offline data)
- Hive (settings, preferences)

---

## 📈 Success Metrics

### Business KPIs (12 months)

| Metric | Baseline | Target | Measurement |
|--------|----------|--------|-------------|
| **Free → Paid Conversion** | 5% | 10% | Firebase Analytics |
| **MRR** | $0 | $50,000 | RevenueCat |
| **ARPU** | $29.99 | $49.99 | Revenue / Paid users |
| **Churn Rate** | 15%/mo | 5%/mo | Cancelled / Total |
| **Trial → Paid** | 10% | 25% | Trial conversions |
| **Course Sales** | 0 | $10K/mo | IAP revenue |

### User Engagement KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| **DAU/MAU** | 30% | Firebase Analytics |
| **Session Duration** | 8 min | Firebase Analytics |
| **Course Completion** | 50% | Custom events |
| **Referral Rate** | 15% | Users with refs / Total |

### Technical KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Crash-Free Rate** | 99.9% | Firebase Crashlytics |
| **App Load Time** | <2 sec | Firebase Performance |
| **API Success Rate** | 99.5% | Backend monitoring |

---

## 🔗 Related SDDs

### Dependencies

- **[sdd-ml-service](../sdd-ml-service/)** - AI predictions API
  - `/predict/redemption` endpoint (<200ms)
  - `/predict/risk` endpoint
  - `/predict/roi` endpoint

- **[sdd-data-structure](../sdd-data-structure/)** - Property data
  - PostgreSQL 90+ attributes
  - Search queries

- **[sdd-scraper-service](../sdd-scraper-service/)** - Fresh data
  - 15+ platform support
  - Daily updates

---

## 🚀 Implementation Roadmap

### Week 1-2: Critical Fixes ✅
- ✅ Trial period: 365 → 14 days (DONE)
- ✅ Pricing: $29.99 → $49.99 (DONE)
- ✅ Add Starter tier $19.99 (DONE in constants)
- ⏳ Configure IAP products (App Store + Google Play)

### Week 3-4: Paywall & Analytics
- Paywall trigger system
- Firebase Analytics integration
- A/B testing framework

### Week 5-6: ML Integration
- Replace mock AI service
- Real ML API calls
- Error handling & fallback

### Week 7-8: Education MVP
- Module 1 implementation (3 lessons)
- Quiz system
- Progress tracking

### Week 9-10: Referral & Fees
- Referral code generation
- Transaction fee calculation
- Stripe integration

### Week 11-12: Testing & Launch
- E2E testing
- Beta testing (TestFlight/Internal Track)
- Soft launch

---

## 🚦 Status

**Current Phase:** REQUIREMENTS
**Phase Status:** COMPLETE ✅
**Last Updated:** 2025-12-31

**Progress:**
- ✅ Requirements complete (7 revenue streams, 8 user stories, success metrics)
- ⏳ Specifications pending (UI/UX, API integration)
- ⏳ Plan pending (12-week roadmap)
- ⏳ Implementation pending

**Critical Changes Already Made:**
- ✅ Trial: 365 days → 14 days (in [subscription_constants.dart](../../apps/taxlien-app/lib/core/constants/subscription_constants.dart))
- ✅ Pricing: $29.99 → $49.99 Premium
- ✅ New tier: Starter $19.99

**Next Actions:**
1. Review and approve requirements
2. Create UI/UX wireframes (Figma)
3. Plan educational content production
4. Configure IAP products
5. Move to SPECIFICATIONS phase

---

**Timeline:** 12 weeks to launch
**Team:** 2 Flutter Developers + 1 Designer + 1 Content Creator
**Investment:** ~$5K (content production)
**Expected ROI:** 20x+ in Year 1
