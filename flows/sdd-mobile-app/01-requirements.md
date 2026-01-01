# Requirements: Mobile App - In-App Education & Monetization

> Version: 1.0
> Status: DRAFT
> Last Updated: 2025-12-31

## Problem Statement

### Current State

TAXLIEN.online мобильное приложение (Flutter) находится в состоянии MVP (85% готовности), но имеет критические проблемы с монетизацией и retention:

**Проблемы:**
1. **365-дневный trial** - потеря 11 месяцев потенциального дохода (КРИТИЧНО!)
2. **Заниженные цены** - $29.99/мес против industry standard $49.99-99.99
3. **Нет in-app education** - высокий барьер входа для новичков
4. **Mock AI service** - не реальные ML прогнозы, низкая ценность
5. **Слабая аналитика** - Firebase Analytics частично интегрирован
6. **Нет product ladder** - отсутствует путь от Free к Premium
7. **Только подписки** - нет transaction fees, educational products, etc.

### Why This Matters

**Business Impact:**
- **Потерянный доход**: 365-day trial = $300K/год при 1000 users
- **Low ARPU**: $29.99 вместо $49.99-99.99 индустриального стандарта
- **High churn**: Без education пользователи не понимают ценность
- **Slow growth**: Нет viral mechanics (referrals, NFT social sharing)

**User Impact:**
- **Confusion**: Новички не знают, с чего начать (tax liens сложная тема)
- **No guidance**: Нет пошагового onboarding
- **Fear**: Страх потерять деньги без понимания рисков

**Technical Impact:**
- **Mock AI**: Не реальные прогнозы → низкое доверие
- **No analytics**: Не понимаем user behavior → не можем оптимизировать
- **Fragmented features**: NFT, real-time bidding есть, но не monetized

---

## Business Model & Monetization Strategy

### Концепция: "Learn-to-Earn" Platform

Превратить приложение в образовательную платформу, где:
1. **Обучение открывает функционал** - каждый урок = новая фича
2. **Gamification** - progress bars, badges, achievements
3. **Multiple revenue streams** - subscriptions, courses, transaction fees
4. **Viral growth** - referrals, NFT marketplace social sharing

### Revenue Streams (7 источников дохода)

#### 1. Subscriptions (Основной доход)

**3-Tier Model:**

```
FREE Tier:
- 10 searches/day
- Top 10 counties only
- 3 AI analyses/month
- Save 5 favorites
- Educational Module 1 only
ЦЕЛЬ: User acquisition, email capture

STARTER Tier: $19.99/мес ($199.99/год)
- Unlimited searches
- 50 counties
- 10 AI analyses/month
- Save 25 favorites
- Modules 1-2
- Basic analytics
- Email alerts (daily digest)
ЦЕЛЬ: Entry point для price-sensitive users

PREMIUM Tier: $49.99/мес ($499.99/год) ← ОСНОВНОЙ
- All 3,000+ counties
- Unlimited AI analyses
- Unlimited portfolio
- Modules 1-5 (full course)
- NFT integration
- Real-time bidding
- Push notifications
- Priority support
ЦЕЛЬ: Power users, serious investors

ENTERPRISE Tier: $199.99/мес ($1,999.99/год)
- API access (10K requests/month)
- Bulk operations
- Multi-user (10 seats)
- White-label options
- Dedicated account manager
ЦЕЛЬ: B2B (agencies, firms)
```

**Trial Optimization:**
- ~~365 days~~ → **14 days** (критическое изменение!)
- Starter: 7 days trial
- Premium: 14 days trial
- Enterprise: 30 days trial

**Expected Revenue:**
- 1,000 users × 10% conversion × $49.99 = $4,999/месяц
- Year 1 target: 10,000 users → $49,990/месяц MRR

#### 2. Educational Products (Digital Goods)

**Продукты (на основе 3rdparty/awesomely контента):**

```
Tax Lien Mastery Course: $297 one-time
- Tax-Yields-Guidebook (PDF, уже готов!)
- 15 video lessons (10 min each)
- County research scripts
- Portfolio tracker template
- Live Q&A sessions (monthly)
- Case studies (5 real examples)

County Research Bundle: $47
- Phone scripts для county research
- State-by-State cheat sheet
- Due diligence checklist

Portfolio Templates: $27
- Excel template для tracking
- ROI calculator
- Tax reporting template

Full Bundle (все 3): $297 (вместо $371)
```

**Включение в подписки:**
- Free: Module 1 only (teaser)
- Starter: Modules 1-2
- Premium: Full course included ($297 value!)
- Enterprise: Full course + consulting

**Expected Revenue:**
- 100 sales/месяц × $100 average = $10,000/месяц

#### 3. Transaction Fees

```dart
class TransactionFees {
  // Lien purchase fees (когда покупка через приложение)
  static const double purchaseFeePercent = 2.5;
  static const double minPurchaseFee = 5.00;

  // NFT minting & trading
  static const double nftMintingFee = 19.99;      // Flat fee
  static const double nftSaleFeePercent = 5.0;    // 5% от продажи
  static const double nftListingFee = 9.99;       // Flat fee за listing

  // Withdrawal fees
  static const double withdrawalFeePercent = 1.0;
  static const double minWithdrawalFee = 2.00;
}
```

**Expected Revenue** (при $500K GMV/месяц):
- Purchase fees: $12,500
- NFT fees: $15,000
- Withdrawal fees: $5,000
**Total: $32,500/месяц**

#### 4. Referral Program

```
User Referral Rewards:
- Referrer: $20 cash bonus
- Referee: $10 cash bonus
- Top referrers (10+ refs): Limited Edition Tax Lien NFT

Affiliate Program (for agents, bloggers):
- 20% recurring commission
- Example: Agent refers 50 clients → 50 × $49.99 × 20% = $499/мес
```

**Cost vs Revenue:**
- Cost: $30 per conversion
- LTV: $600+ (12 months × $49.99)
- CAC: $50 organic + $30 referral = $80
- Payback: 1.6 months

#### 5. Data-as-a-Service (B2B)

**API for Institutional Investors:**

```
Starter API: $99/мес (1K requests)
Professional API: $299/мес (10K requests)
Enterprise API: $999/мес (Unlimited)

DATA:
- Redemption predictions (ML)
- County statistics
- Auction calendars
- Historical trends
```

**Expected Revenue** (10 clients):
- 10 × $299 = $2,990/месяц

#### 6. White-Label Platform

```
Setup fee: $5,000 one-time
Monthly: $1,500-$5,000 (зависит от брендинга)
Revenue share: 10% от их transactions

Target: 5 clients × $2,500 avg = $12,500/месяц
```

#### 7. Fractional NFT Marketplace

```
Модель:
- Разделить $10K lien на 1,000 tokens по $10
- Platform fee: 3% за каждую сделку
- More liquidity = more trading volume

Expected Revenue:
- $100K trading volume/месяц × 3% = $3,000
```

### Total Revenue Projection (Month 12)

```
Subscriptions (500 paid users):         $24,995/мес
Educational products:                   $10,000/мес
Transaction fees:                       $32,500/мес
Data API (10 clients):                  $2,990/мес
White-label (3 clients):                $7,500/мес
Fractional NFT trading:                 $3,000/мес
----------------------------------------
TOTAL MRR:                              $80,985/мес
ANNUAL:                                 $971,820

Year 1 более реалистично: $300K-500K
```

---

## User Stories

### Primary Stories

#### Story 1: New User Onboarding (Learn-to-Earn)

**As a** complete beginner investor
**I want** step-by-step education built into the app
**So that** I can learn while exploring features

**Acceptance Criteria:**
- Onboarding wizard (5 steps, 3 min total)
- Educational modules unlock features:
  - Module 1 (Free): "What is a Tax Lien?" → Unlock search
  - Module 2 (Starter): "How to Research Properties" → Unlock county data
  - Module 3 (Premium): "Sweet Spot Strategy" → Unlock AI predictions
  - Module 4 (Premium): "NFT Integration" → Unlock NFT features
  - Module 5 (Premium): "Advanced Strategies" → Unlock portfolio analytics
- Progress tracking (Firebase Analytics events)
- Gamification: badges, progress bars, achievements
- Quiz at end of each module (80% to pass)

#### Story 2: Subscription Management & Paywall

**As a** free user
**I want** clear understanding of what Premium unlocks
**So that** I can decide if it's worth paying

**Acceptance Criteria:**
- Paywall triggers at strategic moments:
  - After 10th search in a day
  - After 3rd AI analysis in a month
  - When trying to access 11+ county
  - When trying to export data
  - When trying to mint NFT
- Paywall shows:
  - Feature comparison table (Free vs Starter vs Premium)
  - Testimonials from successful users
  - 14-day trial offer (Premium tier)
  - Clear pricing with annual savings
- A/B test different paywall copy
- Firebase Analytics: track paywall views, conversions

#### Story 3: AI Investment Advisor (Real ML)

**As an** investor
**I want** accurate AI predictions for redemption probability
**So that** I can make data-driven decisions

**Acceptance Criteria:**
- Replace mock AI service with real ML API calls
- Display:
  - Redemption probability (0-100%)
  - Risk score (0-100, lower = safer)
  - Expected ROI (percentage)
  - Payback months
  - Feature importance explanation (top 5 factors)
- Free tier: 3 analyses/month
- Starter tier: 10 analyses/month
- Premium tier: Unlimited analyses
- Show confidence score with each prediction
- Fallback to cached predictions if API fails

#### Story 4: Educational Content Purchase

**As a** user who wants to learn without subscribing
**I want** to buy courses separately
**So that** I can pay one-time instead of monthly

**Acceptance Criteria:**
- In-app purchases for:
  - Tax Lien Mastery Course: $297
  - County Research Bundle: $47
  - Portfolio Templates: $27
  - Full Bundle: $297 (save $74)
- Course content delivered via:
  - WebView for video lessons (hosted on Vimeo)
  - PDF downloads (stored in MinIO/S3)
  - Interactive quizzes (in-app)
- Purchase unlocks content permanently (no subscription required)
- Cross-platform sync (iOS/Android/Web)
- Firebase Analytics: track course completion rates

#### Story 5: Referral Program

**As a** satisfied user
**I want** to invite friends and earn rewards
**So that** I can get discounts or cash

**Acceptance Criteria:**
- Referral code generation (unique per user)
- Share via:
  - SMS
  - Email
  - Social media (pre-filled message)
  - QR code
- Rewards tracking dashboard:
  - Total referrals
  - Pending rewards
  - Paid rewards
- Referrer gets: $20 cash (credited to account)
- Referee gets: $10 discount on first purchase
- Top referrers (10+ refs): Limited Edition Tax Lien NFT
- Firebase Analytics: track referral funnel

### Secondary Stories

#### Story 6: Transaction Fee Collection

**As a** platform owner
**I want** to charge fees on lien purchases and NFT trades
**So that** I can generate revenue from transactions

**Acceptance Criteria:**
- Fees calculated and displayed before checkout:
  - Lien purchase: 2.5% (min $5)
  - NFT minting: $19.99 flat
  - NFT sale: 5% of sale price
  - Withdrawal: 1% (min $2)
- Fees breakdown shown in receipt
- Compliance: Clear disclosure in ToS
- Firebase Analytics: track GMV, fee revenue

#### Story 7: Portfolio Analytics (Premium)

**As a** Premium user
**I want** advanced portfolio analytics
**So that** I can optimize my investments

**Acceptance Criteria:**
- Portfolio dashboard shows:
  - Total value
  - ROI by property
  - Redemption status tracking
  - Risk distribution (pie chart)
  - County diversification
  - Projected returns
- Export to CSV/PDF
- Historical performance charts
- Comparison to county averages

#### Story 8: Firebase Analytics Integration

**As a** product manager
**I want** detailed user behavior analytics
**So that** I can optimize conversion funnels

**Acceptance Criteria:**
- Track key events:
  - `app_open`, `sign_up`, `subscription_start`, `subscription_cancel`
  - `paywall_view`, `paywall_convert`, `paywall_dismiss`
  - `search_property`, `view_property`, `save_favorite`
  - `ai_analysis_request`, `ai_analysis_complete`
  - `course_module_start`, `course_module_complete`
  - `referral_code_share`, `referral_conversion`
  - `nft_mint`, `nft_list`, `nft_sale`
- User properties:
  - `subscription_tier`, `trial_days_remaining`, `ltv`, `cohort`
- Conversion funnels:
  - Sign-up → Trial → Paid
  - Free → Paywall → Paid
  - Course viewer → Course buyer
- A/B testing framework (Firebase Remote Config)

---

## Feature Requirements

### 1. In-App Education System

#### Module Structure

```
Module 1: Tax Lien Basics (FREE)
├── Lesson 1.1: What is a Tax Lien? (video 8 min)
├── Lesson 1.2: Tax Lien vs Tax Deed (video 6 min)
├── Lesson 1.3: Why Invest? (video 5 min)
├── Quiz (5 questions, 80% to pass)
└── Unlock: Search feature

Module 2: Property Research (STARTER)
├── Lesson 2.1: How to Research Counties (video 10 min)
├── Lesson 2.2: Using County Websites (video 8 min)
├── Lesson 2.3: Phone Scripts (PDF + audio)
├── Quiz (10 questions)
└── Unlock: County data access (50 counties)

Module 3: Sweet Spot Strategy (PREMIUM)
├── Lesson 3.1: What Makes a Sweet Spot? (video 12 min)
├── Lesson 3.2: Population Growth (video 7 min)
├── Lesson 3.3: School Districts (video 6 min)
├── Lesson 3.4: Property Value Delta (video 8 min)
├── Quiz (15 questions)
└── Unlock: AI predictions + Sweet Spot filter

Module 4: NFT Integration (PREMIUM)
├── Lesson 4.1: Why Tokenize? (video 10 min)
├── Lesson 4.2: Fractional Ownership (video 8 min)
├── Lesson 4.3: Liquidity Benefits (video 6 min)
├── Quiz (10 questions)
└── Unlock: NFT minting & trading

Module 5: Advanced Strategies (PREMIUM)
├── Lesson 5.1: Serial Late Payer Play (video 15 min)
├── Lesson 5.2: Portfolio Diversification (video 10 min)
├── Lesson 5.3: Tax Implications (video 12 min)
├── Lesson 5.4: Exit Strategies (video 8 min)
├── Quiz (20 questions)
└── Unlock: Portfolio analytics
```

#### Content Delivery

- **Videos**: Hosted on Vimeo (private, protected)
- **PDFs**: Stored in MinIO/S3, signed URLs
- **Quizzes**: In-app (SQLite local storage)
- **Progress**: Synced via Firebase Firestore
- **Certificates**: Generated PDF after completion

#### Gamification

```dart
class AchievementSystem {
  static const List<Achievement> achievements = [
    Achievement(
      id: 'first_search',
      title: 'First Steps',
      description: 'Performed your first property search',
      icon: 'search',
      points: 10,
    ),
    Achievement(
      id: 'module_1_complete',
      title: 'Tax Lien Scholar',
      description: 'Completed Module 1',
      icon: 'graduation_cap',
      points: 50,
    ),
    Achievement(
      id: 'first_ai_analysis',
      title: 'AI Advisor',
      description: 'Used AI analysis for the first time',
      icon: 'robot',
      points: 25,
    ),
    Achievement(
      id: 'premium_subscriber',
      title: 'Power Investor',
      description: 'Upgraded to Premium',
      icon: 'star',
      points: 100,
    ),
    Achievement(
      id: 'first_nft_mint',
      title: 'NFT Pioneer',
      description: 'Minted your first Tax Lien NFT',
      icon: 'token',
      points: 75,
    ),
    Achievement(
      id: '10_referrals',
      title: 'Community Builder',
      description: 'Referred 10 friends',
      icon: 'users',
      points: 200,
    ),
  ];
}
```

### 2. Subscription & Paywall System

#### Paywall Triggers

```dart
class PaywallTrigger {
  static bool shouldShowPaywall(UserContext context) {
    if (context.subscriptionTier == SubscriptionTier.premium ||
        context.subscriptionTier == SubscriptionTier.enterprise) {
      return false; // Already paid
    }

    // Free tier limits
    if (context.subscriptionTier == SubscriptionTier.free) {
      if (context.searchesToday >= FeatureLimits.freeSearchesPerDay) {
        return PaywallReason.searchLimitReached;
      }
      if (context.aiAnalysesThisMonth >= FeatureLimits.freeAIAnalysesPerMonth) {
        return PaywallReason.aiLimitReached;
      }
      if (context.portfolioSize >= FeatureLimits.freePortfolioSize) {
        return PaywallReason.portfolioLimitReached;
      }
      if (context.attemptedCountyNotInTop10) {
        return PaywallReason.countyAccessDenied;
      }
    }

    // Starter tier limits
    if (context.subscriptionTier == SubscriptionTier.starter) {
      if (context.aiAnalysesThisMonth >= FeatureLimits.starterAIAnalysesPerMonth) {
        return PaywallReason.aiLimitReached;
      }
    }

    // Feature-specific paywalls
    if (context.attemptedFeature == 'nft_minting') {
      return PaywallReason.premiumFeatureRequired;
    }
    if (context.attemptedFeature == 'real_time_bidding') {
      return PaywallReason.premiumFeatureRequired;
    }
    if (context.attemptedFeature == 'export_data') {
      return PaywallReason.premiumFeatureRequired;
    }

    return false; // No paywall
  }
}
```

#### Paywall UI Components

- **Comparison Table**: Free vs Starter vs Premium
- **Social Proof**: "Join 10,000+ investors" + testimonials
- **Urgency**: "14-day trial ending in 3 days"
- **Value Props**: "Unlock AI predictions worth $297/month"
- **Risk Reduction**: "Cancel anytime, no questions asked"
- **CTA**: "Start 14-Day Free Trial" (prominent button)

### 3. AI Integration (Real ML API)

#### Service Replacement

**Current (Mock):**
```dart
// lib/services/ai_investment_advisor_service.dart
class AIInvestmentAdvisorService {
  Future<AIAnalysisResult> analyzeTaxLien(TaxLien lien) async {
    // Mock calculations
    double riskScore = _calculateRiskScore(lien); // Hardcoded
    // ...
  }
}
```

**New (Real ML API):**
```dart
class AIInvestmentAdvisorService {
  final String mlApiUrl = 'https://api.taxlien.online/api/v1';
  final HttpClient http;

  Future<AIAnalysisResult> analyzeTaxLien(TaxLien lien) async {
    // Check usage limits
    if (!await _checkUsageLimits()) {
      throw AIUsageLimitException();
    }

    // Call real ML API
    final response = await http.post(
      Uri.parse('$mlApiUrl/predict/batch'),
      headers: {
        'Authorization': 'Bearer ${await _getAuthToken()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'parcel_ids': [lien.parcelId],
        'models': ['redemption', 'risk', 'roi'],
      }),
    );

    if (response.statusCode != 200) {
      // Fallback to cached prediction
      return await _getCachedPrediction(lien.parcelId);
    }

    final data = jsonDecode(response.body)['predictions'][0];

    // Track usage
    await _incrementUsageCounter();

    // Firebase Analytics event
    FirebaseAnalytics.instance.logEvent(
      name: 'ai_analysis_complete',
      parameters: {
        'parcel_id': lien.parcelId,
        'redemption_probability': data['redemption_probability'],
        'risk_score': data['risk_score'],
      },
    );

    return AIAnalysisResult(
      riskScore: data['risk_score'].toDouble(),
      profitPotential: data['redemption_probability'] * 100,
      expectedROI: data['expected_roi'].toDouble(),
      paybackMonths: data['payback_months'],
      recommendation: _generateRecommendation(data),
      pros: _generateProsFromFeatures(data['feature_importance']),
      cons: _generateConsFromRiskFactors(data),
      riskLevel: _mapRiskLevel(data['risk_score']),
      mlModelVersion: data['ml_model_version'],
    );
  }
}
```

### 4. Firebase Analytics Integration

#### Events to Track

```dart
class AnalyticsEvents {
  // User lifecycle
  static const String appOpen = 'app_open';
  static const String signUp = 'sign_up';
  static const String login = 'login';

  // Subscription
  static const String subscriptionStart = 'subscription_start';
  static const String subscriptionCancel = 'subscription_cancel';
  static const String trialStart = 'trial_start';
  static const String trialConvert = 'trial_convert';
  static const String trialExpire = 'trial_expire';

  // Paywall
  static const String paywallView = 'paywall_view';
  static const String paywallConvert = 'paywall_convert';
  static const String paywallDismiss = 'paywall_dismiss';

  // Search & Browse
  static const String searchProperty = 'search_property';
  static const String viewProperty = 'view_property';
  static const String saveFavorite = 'save_favorite';
  static const String removeFavorite = 'remove_favorite';

  // AI Analysis
  static const String aiAnalysisRequest = 'ai_analysis_request';
  static const String aiAnalysisComplete = 'ai_analysis_complete';
  static const String aiAnalysisError = 'ai_analysis_error';

  // Education
  static const String courseModuleStart = 'course_module_start';
  static const String courseModuleComplete = 'course_module_complete';
  static const String quizAttempt = 'quiz_attempt';
  static const String quizPass = 'quiz_pass';
  static const String quizFail = 'quiz_fail';

  // Referrals
  static const String referralCodeShare = 'referral_code_share';
  static const String referralConversion = 'referral_conversion';

  // NFT
  static const String nftMint = 'nft_mint';
  static const String nftList = 'nft_list';
  static const String nftSale = 'nft_sale';

  // Purchases
  static const String coursePurchase = 'course_purchase';
  static const String lienPurchase = 'lien_purchase';
}
```

#### User Properties

```dart
class AnalyticsUserProperties {
  static const String subscriptionTier = 'subscription_tier';
  static const String trialDaysRemaining = 'trial_days_remaining';
  static const String lifetimeValue = 'ltv';
  static const String cohort = 'cohort'; // e.g., "2025-12"
  static const String totalSearches = 'total_searches';
  static const String totalAIAnalyses = 'total_ai_analyses';
  static const String courseCompletionRate = 'course_completion_rate';
  static const String referralCount = 'referral_count';
}
```

---

## Technical Requirements

### 1. Performance

| Metric | Target | Acceptable |
|--------|--------|------------|
| **App Startup** | <2 sec | <3 sec |
| **Search Results** | <1 sec | <2 sec |
| **AI Analysis** | <3 sec | <5 sec |
| **Video Loading** | <2 sec | <4 sec |
| **Page Transitions** | <300ms | <500ms |

### 2. Platform Support

- **iOS**: 14.0+ (iPhone, iPad)
- **Android**: 7.0+ (API 24+)
- **Web**: Chrome 90+, Safari 14+, Firefox 88+ (future)

### 3. Offline Support

- **Cached data**: Property details, favorites, course progress
- **Queue actions**: Save favorite, submit quiz (sync when online)
- **Local storage**: SQLite for course progress, Hive for settings

### 4. Security

- **Authentication**: Firebase Auth (email/password, Google, Apple)
- **API Keys**: Stored securely (iOS Keychain, Android Keystore)
- **Data Encryption**: At rest (SQLCipher) and in transit (HTTPS)
- **PII Protection**: No sensitive data in analytics

### 5. Compliance

- **GDPR**: Cookie consent, data export, right to deletion
- **CCPA**: California privacy disclosures
- **App Store Guidelines**: Clear subscription terms, restore purchases
- **Financial Regulations**: Disclosures for investment risks

---

## Acceptance Criteria

### Functional

- ✅ 14-day trial (not 365 days!)
- ✅ 3-tier pricing (Starter $19.99, Premium $49.99, Enterprise $199.99)
- ✅ Paywall triggers at strategic moments (search limit, AI limit, etc.)
- ✅ In-app education (5 modules, quizzes, progress tracking)
- ✅ Real ML API integration (replace mock service)
- ✅ Transaction fees calculation (lien purchase, NFT, withdrawal)
- ✅ Referral program (codes, rewards, tracking)
- ✅ Firebase Analytics (events, user properties, funnels)
- ✅ Educational product purchases (courses, bundles)
- ✅ Gamification (badges, achievements, progress bars)

### Non-Functional

- ✅ App startup <2 sec
- ✅ 99.9% crash-free rate (Firebase Crashlytics)
- ✅ Support iOS 14+ and Android 7+
- ✅ Offline mode for core features
- ✅ GDPR/CCPA compliant
- ✅ A/B testing framework (Firebase Remote Config)

---

## Constraints & Assumptions

### Constraints

1. **Flutter Framework**: Must use Flutter (existing codebase)
2. **Firebase Dependency**: Firebase for auth, analytics, remote config
3. **ML API External**: ML service is separate microservice
4. **App Store Review**: Must comply with Apple/Google guidelines
5. **Budget**: Educational content production ~$5K

### Assumptions

1. **Content Ready**: 3rdparty/awesomely has guidebook content
2. **ML API Available**: ML service will be deployed before app launch
3. **Payment Processing**: RevenueCat or similar for IAP management
4. **Video Hosting**: Vimeo or YouTube for video content
5. **User Growth**: Organic + paid ads can reach 10K users in Year 1

---

## Out of Scope (Not in MVP)

- ❌ Social features (forums, chat)
- ❌ Live auction participation (real-time bidding)
- ❌ Blockchain integration (NFT on app launch, not MVP)
- ❌ Desktop app (focus on mobile first)
- ❌ Multiple languages (English only for MVP)
- ❌ Cryptocurrency payments (USD only)

---

## Success Metrics

### Business KPIs (12 months)

| Metric | Baseline | Target | Measurement |
|--------|----------|--------|-------------|
| **Free → Paid Conversion** | 5% | 10% | Firebase Analytics funnel |
| **MRR** | $0 | $50,000 | RevenueCat dashboard |
| **ARPU** | $29.99 | $49.99 | Subscription revenue / paid users |
| **Churn Rate** | 15%/mo | 5%/mo | Cancelled / Total subscribers |
| **Trial → Paid** | 10% | 25% | Trial conversions |
| **Course Sales** | 0 | $10K/mo | In-app purchase revenue |

### User Engagement KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| **DAU/MAU** | 30% | Firebase Analytics |
| **Session Duration** | 8 min | Firebase Analytics |
| **Course Completion** | 50% | Custom event tracking |
| **Referral Rate** | 15% | Users with 1+ referral / Total users |

### Technical KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Crash-Free Rate** | 99.9% | Firebase Crashlytics |
| **App Load Time** | <2 sec | Firebase Performance |
| **API Success Rate** | 99.5% | Backend monitoring |

---

## Dependencies

### Data Dependencies

- **sdd-ml-service**: Real AI predictions API
- **sdd-data-structure**: PostgreSQL for property data
- **sdd-scraper-service**: Fresh property data

### Infrastructure Dependencies

- Firebase (Auth, Analytics, Crashlytics, Remote Config)
- RevenueCat (or similar) for IAP management
- Vimeo for video hosting
- MinIO/S3 for PDF storage
- Stripe for payment processing (courses, transaction fees)

### Content Dependencies

- Educational content (videos, PDFs) - need production
- Tax-Yields-Guidebook from 3rdparty/awesomely

---

## Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Low conversion rate (<5%) | High | Medium | A/B test paywalls, improve education |
| High churn (>10%/mo) | High | Medium | Improve onboarding, add retention features |
| App Store rejection | High | Low | Follow guidelines, clear disclosures |
| ML API downtime | Medium | Low | Fallback to cached predictions |
| Educational content production delay | Medium | Medium | Start with Module 1 only, add modules incrementally |
| Privacy compliance issues | High | Low | GDPR/CCPA audit before launch |

---

## Next Steps

1. **SPECIFICATIONS Phase:**
   - UI/UX wireframes for paywall, education, referrals
   - API integration specs (ML service, payment processing)
   - Firebase Analytics event taxonomy
   - In-app purchase product IDs and configuration

2. **PLAN Phase:**
   - Break into implementation tasks
   - Educational content production plan
   - Testing strategy (unit, integration, E2E)
   - Deployment plan (staged rollout)

3. **IMPLEMENTATION Phase:**
   - Week 1-2: Trial fix, pricing update, paywall triggers
   - Week 3-4: ML API integration, Firebase Analytics
   - Week 5-6: Educational modules (MVP: Module 1)
   - Week 7-8: Referral program, transaction fees
   - Week 9-10: Testing, bug fixes
   - Week 11-12: Soft launch, monitoring

---

**Status:** REQUIREMENTS DRAFT ✅
**Next Phase:** SPECIFICATIONS (UI/UX design, API integration)
**Timeline:** 12 weeks to launch
**Team:** 2 Flutter Developers + 1 Designer + 1 Content Creator
