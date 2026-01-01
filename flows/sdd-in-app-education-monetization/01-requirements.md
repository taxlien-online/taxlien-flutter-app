# Requirements: In-App Education Monetization System

> Version: 1.0
> Status: DRAFT
> Last Updated: 2025-12-30

## Problem Statement

### Current Situation
TAXLIEN.online приложение имеет сложный функционал (поиск tax liens, NFT conversion, portfolio management), но новые пользователи не понимают:
- **Что** такое tax liens и как они работают
- **Как** начать инвестировать
- **Зачем** использовать различные функции приложения

Это приводит к:
- Низкой engagement rate
- Высокому churn rate на trial периоде
- Неиспользованию premium функций
- Потере потенциальной revenue

### Opportunity
Создадим **уникальный образовательный курс** прямо в приложении:
- **Оригинальный контент**, написанный специально для нашей платформы
- **Интерактивный формат** с практическими заданиями
- **Интеграция с функциями приложения** (каждый урок учит использовать feature)
- **Gamification** через NFT rewards и прогресс-трекинг

Мы можем:
1. **Создать Learn-to-Earn систему** (учись → зарабатывай)
2. **Монетизировать через unlock** ($19.99-49.99 за курс)
3. **Повысить retention** через постепенное открытие функций
4. **Отслеживать прогресс** через Firebase Analytics
5. **Уникальный контент** = competitive moat

### Why This Matters
- **Original IP**: наш собственный курс = уникальная ценность
- **Competitive advantage**: конкуренты не обучают пользователей
- **Higher LTV**: обученные юзеры = платящие юзеры
- **Viral potential**: "I learned & earned" = powerful story
- **SEO/Content marketing**: можем публиковать части курса как blog posts

---

## Оригинальная Структура Курса

### Концепция: "From Zero to First Deal in 30 Days"

**Философия:**
Каждый урок = 1 действие = 1 разблокированная feature

**Формат:**
- 5 модулей по 4-6 уроков каждый (20-30 уроков всего)
- Каждый урок: 3-5 минут чтения + практическое задание
- После каждого модуля: интерактивный quiz + NFT badge

### Module 1: Tax Lien Basics (Free) 🎓
**Goal:** Понять что такое tax liens и как они работают
**Unlocks:** Basic Search, Property Viewer

**Lessons:**
1. "What Are Tax Liens?" (3 min)
   - Простым языком: property tax → не заплачен → lien продается
   - Real example: $50K house, $2K tax debt, 18% interest
   - **Action:** Browse sample properties в приложении

2. "How You Make Money" (4 min)
   - Scenario 1: Owner pays back → you earn interest (18-24%)
   - Scenario 2: Owner doesn't pay → you can get property
   - Risk/reward визуализация
   - **Action:** Use ROI calculator на sample property

3. "The 3 Players" (3 min)
   - County government (needs money)
   - Property owner (owes taxes)
   - You, the investor (buy the lien)
   - **Action:** View county map, see auction schedule

4. "Tax Lien vs Tax Deed" (4 min)
   - Lien = lending money (get interest)
   - Deed = buying property (get real estate)
   - State-by-state map visualization
   - **Action:** Filter counties by type (lien/deed)

5. "Your First $100 Investment" (5 min)
   - Start small: можно начать с $50-100
   - Example deal walkthrough
   - Expected returns timeline
   - **Action:** Add first property to Watchlist

**Quiz:** 5 questions, 80% to pass
**Reward:** "Tax Lien Rookie" NFT badge
**Feature Unlock:** Search Filter, County Stats, Watchlist

---

### Module 2: Finding Good Deals ($19.99 или Premium) 🔍
**Goal:** Научиться искать profitable opportunities
**Unlocks:** Advanced Filters, AI Analysis, Property Details

**Lessons:**
6. "The 3 Red Flags to Avoid" (4 min)
   - Red Flag 1: Property value too low (< $10K)
   - Red Flag 2: Tax amount too high (> 10% of value)
   - Red Flag 3: Contaminated/industrial land
   - **Action:** Use "Safety Score" filter в приложении

7. "The Golden Ratio: Value-to-Tax" (5 min)
   - Best deals: property value ÷ tax debt > 5:1
   - Example: $100K house, $2K debt = 50:1 (GREAT!)
   - How to calculate quickly
   - **Action:** Sort properties by Value/Tax ratio

8. "County Research 101" (6 min)
   - Which counties are investor-friendly?
   - Redemption periods (6 months - 3 years)
   - Interest rates by state (6% - 24%)
   - **Action:** Compare 3 counties in app, pick favorite

9. "Reading Property Details" (5 min)
   - Understanding assessment values
   - Building characteristics (year, sqft, type)
   - Sales history (is this flippable?)
   - **Action:** Analyze sample property in detail view

10. "AI-Powered Deal Analysis" (4 min)
    - How our AI scores properties (1-100)
    - What the AI looks at (11 factors)
    - When to trust AI vs manual research
    - **Action:** Run AI analysis on 5 properties

**Quiz:** 6 questions about finding deals
**Reward:** "Deal Hunter" NFT badge
**Feature Unlock:** AI Scoring, Historical Data, Comp Analysis

---

### Module 3: Making Your First Investment ($29.99 или Premium) 💰
**Goal:** Выполнить первую покупку (simulation или real)
**Unlocks:** Bidding System, Portfolio Tracker, Document Manager

**Lessons:**
11. "Pre-Auction Checklist" (6 min)
    - Documents needed (ID, proof of funds)
    - Registration process
    - Budget planning (start with $500-1000)
    - **Action:** Complete investor profile в приложении

12. "How Auctions Work" (5 min)
    - Online vs In-Person auctions
    - Bidding strategies (max bid calculator)
    - Common mistakes to avoid
    - **Action:** Practice with auction simulator

13. "Winning Your First Lien" (4 min)
    - Placing a bid walkthrough
    - What happens when you win?
    - Payment timeline (usually 24-48 hours)
    - **Action:** Simulate winning a bid

14. "After the Purchase" (5 min)
    - Getting your certificate
    - Tracking redemption period
    - Setting up notifications
    - **Action:** Add mock certificate to portfolio

15. "Portfolio Management" (5 min)
    - Tracking multiple liens
    - Calculating total ROI
    - When to expect redemption
    - **Action:** Create your first portfolio

**Quiz:** Practical scenario questions
**Reward:** "First Deal" NFT badge (gold if real purchase!)
**Feature Unlock:** Live Bidding, Portfolio Analytics, Payment Integration

---

### Module 4: NFT Innovation ($39.99 или Enterprise) 🚀
**Goal:** Understand NFT features (unique to our platform)
**Unlocks:** NFT Minting, Marketplace, Fractional Ownership

**Lessons:**
16. "Why NFTs for Tax Liens?" (4 min)
    - Problem: Traditional liens are illiquid
    - Solution: Convert to NFT → sell anytime
    - Liquidity premium example
    - **Action:** View NFT marketplace в приложении

17. "Converting Lien to NFT" (5 min)
    - Step-by-step conversion process
    - Minting fees ($19.99 flat fee)
    - Blockchain verification
    - **Action:** Simulate NFT minting

18. "Selling Your NFT Lien" (6 min)
    - Setting a price (use AI recommendation)
    - Listing on marketplace
    - Transfer process
    - **Action:** Create practice listing

19. "Fractional Ownership" (5 min)
    - Split $10K lien → 100 tokens × $100
    - More liquidity + more investors
    - How returns are distributed
    - **Action:** Explore fractional opportunities

20. "NFT Trading Strategies" (6 min)
    - Hold to maturity (max interest)
    - Sell early (liquidity premium)
    - Fractional diversification
    - **Action:** Build sample NFT portfolio

**Quiz:** NFT concepts & strategies
**Reward:** "NFT Pioneer" platinum badge
**Feature Unlock:** Full NFT features, Fractional tools

---

### Module 5: Advanced Strategies ($49.99 или Enterprise) 📈
**Goal:** Scale to $10K+ invested
**Unlocks:** Bulk Operations, API Access, Analytics Dashboard

**Lessons:**
21. "Building a $10K Portfolio" (6 min)
    - Diversification across counties
    - Risk management (don't put all in one)
    - Expected annual returns
    - **Action:** Plan your 10-property portfolio

22. "Foreclosure Process" (7 min)
    - What if owner doesn't redeem?
    - Foreclosure timeline by state
    - Working with attorneys
    - **Action:** View foreclosure simulator

23. "Advanced County Research" (6 min)
    - Economic indicators to watch
    - Redemption rate statistics
    - Seasonal patterns
    - **Action:** Deep dive into county analytics

24. "Tax Deed Strategies" (6 min)
    - How tax deed sales differ
    - Overbid strategies
    - Property flipping basics
    - **Action:** Analyze tax deed opportunities

25. "Scaling with Data API" (5 min)
    - Export your data (CSV, JSON)
    - API access for automation
    - Integration with spreadsheets
    - **Action:** Generate portfolio report

**Quiz:** Advanced scenarios
**Reward:** "Tax Lien Master" diamond badge
**Feature Unlock:** All features, API access, Priority support

---

## Content Creation Methodology

### Writing Guidelines
- **Tone:** Friendly, encouraging, not overly technical
- **Length:** 3-7 minutes reading time (500-1000 words)
- **Examples:** Real numbers from sample data
- **Visuals:** Screenshots from actual app features
- **Actions:** Every lesson ends with "Try it now" button

### Interactive Elements
- **Embedded calculators** (ROI, bidding max, etc.)
- **Property cards** (tap to expand details)
- **County maps** (interactive, filterable)
- **Progress bars** (visual gamification)

### Content Sources (Reference Only)
- 3rdparty/awesomely/ materials for terminology
- Sample data from /samples/ for realistic examples
- Industry best practices (public domain)
- Our unique NFT/blockchain innovation

---

## Internationalization (i18n) Strategy

### Primary Language
**English (en-US)** - Base language for all content
- Tax liens primarily US market
- All course content written in English first
- Technical terminology established in English

### Target Markets & Languages (Prioritized by Revenue Potential)

#### Tier 1: High-Value Markets (Launch Priority)

**1. Spanish (es) - Latin America & Spain**
- **Market Size:** 580M native speakers
- **Revenue Potential:** 🟢🟢🟢🟢 Very High
- **Reasoning:**
  - Large Latin American diaspora in US (60M people)
  - Growing real estate investment interest
  - Access to US tax lien market from abroad
  - Spain has similar property tax concepts
- **Target Users:** US Hispanic investors, Latin American international investors
- **Estimated Market:** 5-10% of potential users
- **Translation Priority:** Module 1 (free) immediately, paid modules within 2 months

**2. Chinese (zh-CN) - Simplified Chinese**
- **Market Size:** 1.1B native speakers
- **Revenue Potential:** 🟢🟢🟢🟢🟢 Extremely High
- **Reasoning:**
  - High interest in US real estate investments
  - Wealthy Chinese investors seeking US assets
  - Strong tech adoption & mobile payment culture
  - Higher price tolerance ($49.99-199.99 acceptable)
- **Target Users:** Chinese investors buying US properties, diaspora in US
- **Estimated Market:** 3-8% of potential users
- **Translation Priority:** All modules, high quality professional translation

**3. Portuguese (pt-BR) - Brazilian Portuguese**
- **Market Size:** 260M speakers
- **Revenue Potential:** 🟢🟢🟢 High
- **Reasoning:**
  - Brazil has growing investor class
  - Interest in US real estate & alternative investments
  - Large Brazilian community in US (Florida especially)
  - Tax lien concept similar to "IPTU" tax system
- **Target Users:** Brazilian investors, Brazilian-Americans
- **Estimated Market:** 2-5% of potential users
- **Translation Priority:** Module 1-2 initially

#### Tier 2: Medium-Value Markets (3-6 months post-launch)

**4. Arabic (ar) - Modern Standard Arabic**
- **Market Size:** 420M speakers
- **Revenue Potential:** 🟢🟢🟢🟢 Very High (high ARPU)
- **Reasoning:**
  - Wealthy Gulf state investors (UAE, Saudi Arabia)
  - High interest in US property investments
  - Premium price tolerance
  - Growing fintech adoption
- **Target Users:** Gulf region investors, Arab-Americans
- **Estimated Market:** 1-3% of potential users, but HIGH value
- **Translation Priority:** Professional translation, RTL (right-to-left) UI support

**5. Russian (ru)**
- **Market Size:** 260M speakers
- **Revenue Potential:** 🟢🟢🟢 High
- **Reasoning:**
  - Russian investors active in US real estate
  - Tech-savvy population
  - Interest in alternative investments
  - Large Russian diaspora in US
- **Target Users:** Russian investors, Russian-Americans
- **Estimated Market:** 2-4% of potential users
- **Translation Priority:** Module 1-3

**6. Korean (ko)**
- **Market Size:** 80M speakers
- **Revenue Potential:** 🟢🟢🟢🟢 Very High
- **Reasoning:**
  - High per-capita wealth
  - Strong interest in US property market
  - Tech-early adopters (mobile-first culture)
  - Large Korean-American community
- **Target Users:** Korean investors, Korean-Americans
- **Estimated Market:** 1-2% of potential users, HIGH ARPU
- **Translation Priority:** All modules, professional quality

#### Tier 3: Lower Priority (6-12 months)

**7. Hindi (hi)** - India
- Market size: 600M speakers
- Growing middle class, but lower immediate revenue potential
- Long-term strategic market

**8. Japanese (ja)**
- Market size: 125M speakers
- Wealthy but aging population
- Conservative investment culture

**9. German (de)**
- Market size: 130M speakers
- Strong economy but lower US real estate investment interest

**10. French (fr)**
- Market size: 280M speakers
- African diaspora in US + Canadian French speakers

### Implementation Strategy

#### Phase 1: English Only (Months 1-2)
- Launch with English content
- Build translation infrastructure
- Identify most-requested languages via analytics

#### Phase 2: Spanish + Chinese (Months 2-4)
- **Spanish:** Community/crowdsourced translation for Module 1, professional for paid content
- **Chinese:** Professional translation all modules (quality critical for this market)
- A/B test pricing in different markets

#### Phase 3: Tier 2 Languages (Months 4-6)
- Add Arabic, Russian, Korean, Portuguese
- Hire native-speaking reviewers for quality
- Localize pricing (currency display, local payment methods)

### Technical Implementation

**Flutter Localization Files Structure:**
```
lib/l10n/
├── app_en.arb          (English - base)
├── app_es.arb          (Spanish)
├── app_zh.arb          (Chinese Simplified)
├── app_pt.arb          (Portuguese)
├── app_ar.arb          (Arabic - RTL)
├── app_ru.arb          (Russian)
├── app_ko.arb          (Korean)
├── app_hi.arb          (Hindi)
├── app_ja.arb          (Japanese)
└── app_education_en.arb   (Educational content - separate for easier management)
```

**Content Localization:**
- Lesson content stored in JSON format per language
- Images with text: create language-specific versions
- Videos (future): subtitles in multiple languages

**Firebase Analytics Events:**
```dart
// Track language selection & revenue by language
analytics.logEvent(
  name: 'language_selected',
  parameters: {
    'language_code': 'es',
    'user_region': 'US',
  }
);

analytics.logEvent(
  name: 'purchase_completed',
  parameters: {
    'product_id': 'module_2',
    'price': 19.99,
    'currency': 'USD',
    'user_language': 'zh',  // Track revenue by language!
  }
);
```

### Localization Best Practices

1. **Cultural Adaptation (not just translation):**
   - Example values adjusted by region (e.g., Chinese investors might invest $100K+, not $50)
   - Legal disclaimers adapted to local regulations
   - Success stories from diverse backgrounds

2. **Currency Display:**
   - Show USD always (since tax liens are US-only)
   - But display local currency equivalent for context
   - Example: "$49.99 (≈ ¥350 CNY)"

3. **Date/Number Formatting:**
   - Use locale-aware formatting (NumberFormat, DateFormat from intl package)
   - Example: 1,000.50 (US) vs 1.000,50 (ES)

4. **Right-to-Left (RTL) Support:**
   - Arabic requires full RTL UI
   - Test all layouts with `Directionality` widget
   - Mirror icons/arrows appropriately

5. **Translation Quality Tiers:**
   - **Free content (Module 1):** Community translation + review
   - **Paid content (Module 2-5):** Professional translation
   - **Legal/Financial terms:** Native expert review mandatory

### Revenue Optimization by Language

**Pricing Localization Strategy:**

```dart
class LocalizedPricing {
  // Base USD prices
  static const basePrices = {
    'module_2': 19.99,
    'module_3': 29.99,
    'premium_monthly': 49.99,
  };

  // Regional multipliers (based on purchasing power & competition)
  static const regionalMultipliers = {
    'en-US': 1.0,      // Base
    'es': 0.8,         // Latin America lower purchasing power
    'zh-CN': 1.2,      // China - higher prices acceptable
    'ar': 1.3,         // Gulf states - premium positioning
    'ko': 1.1,         // Korea - slight premium
    'pt-BR': 0.9,      // Brazil - moderate
    'ru': 1.0,         // Russia - standard
  };
}
```

**A/B Testing Plan:**
- Test 3 price points per language (base, +20%, -20%)
- Measure conversion rates & LTV
- Optimize within 3 months of language launch

### Expected Revenue Impact

**Conservative Estimates (Year 1):**

```
English users: 1,000 × $49.99 = $49,990/mo
Spanish users: 100 × $39.99 = $3,999/mo   (80% price, 10% of base)
Chinese users: 50 × $59.99 = $2,999/mo    (120% price, 5% of base, HIGH quality users)
Arabic users: 20 × $64.99 = $1,299/mo     (130% price, 2% of base, VERY HIGH value)

TOTAL MULTILINGUAL BONUS: ~$8,300/mo (+17% revenue)
Year 1 Impact: ~$100K additional revenue
```

**Costs:**
- Professional translation: $0.10-0.20/word
- 25 lessons × 500 words = 12,500 words per language
- Spanish: $1,250-2,500
- Chinese: $2,000-3,000 (higher rates for quality)
- **Total Year 1 translation budget:** $15K-20K
- **ROI:** 5-7x in first year

### Open Questions - Internationalization

- [ ] **Translation vendors:** Use professional service (Smartling, Lokalise) or freelancers (Upwork)?
- [ ] **Content priority:** Translate all 25 lessons at once or module-by-module?
- [ ] **Community translation:** Allow users to suggest improvements?
- [ ] **Language selector:** Auto-detect from device or force manual selection?
- [ ] **Fallback strategy:** Show English if translation missing, or hide untranslated content?
- [ ] **Payment methods:** Support WeChat Pay (China), Alipay, or USD-only initially?

---

## User Stories

### Primary

#### Story 1: Новичок хочет начать с нуля

**As a** complete beginner who knows nothing about tax liens
**I want** step-by-step education built into the app
**So that** I can learn while using the app and start investing confidently

**Acceptance Criteria:**
- Given I'm a new user launching the app for the first time
- When I complete onboarding
- Then I see "Start Learning" button that begins educational journey
- And I can see my progress (e.g., "Module 1/3 complete")

#### Story 2: Опытный инвестор хочет разблокировать функции

**As an** experienced investor who already knows tax liens basics
**I want** to skip beginner modules and unlock advanced features
**So that** I can immediately use advanced tools like NFT conversion

**Acceptance Criteria:**
- Given I have experience with tax liens
- When I select "I'm experienced" during onboarding
- Then I can take a quick quiz to verify knowledge
- And unlock specific modules/features without full course

#### Story 3: Пользователь хочет купить доступ к обучению

**As a** free tier user who wants to learn faster
**I want** to purchase the full educational course
**So that** I can unlock all modules and features immediately

**Acceptance Criteria:**
- Given I'm on free tier with limited access
- When I tap "Unlock Full Course"
- Then I see pricing options ($47 course-only, $49.99/mo Premium with course)
- And I can purchase through in-app purchase or Stripe
- And content unlocks immediately after payment

### Secondary

#### Story 4: Маркетолог хочет видеть эффективность обучения

**As a** marketing manager
**I want** to track user education progress via Firebase Analytics
**So that** I can optimize onboarding flow and improve conversions

**Acceptance Criteria:**
- Firebase events track: lesson_started, lesson_completed, quiz_passed
- Dashboard shows: completion rates, time-to-complete, drop-off points

#### Story 5: Пользователь хочет возвращаться к урокам

**As a** user who completed lessons
**I want** to review material anytime
**So that** I can refresh my knowledge before making investments

**Acceptance Criteria:**
- "Education Hub" accessible from main menu
- All completed lessons remain available
- Bookmarking/favorites system for key lessons

---

## Acceptance Criteria

### Must Have

1. **Educational Content Integration**
   - **Given** the guidebook content exists in `/3rdparty/awesomely/`
   - **When** development begins
   - **Then** content must be parsed into structured lessons (Module → Lesson → Steps)
   - **And** displayed in mobile-friendly format (not just PDF viewer)

2. **Progressive Unlock System ("Learn-to-Earn")**
   - **Given** user starts education journey
   - **When** user completes Module 1
   - **Then** Basic Search feature unlocks
   - **When** user completes Module 2
   - **Then** Advanced Filters + AI Analysis unlock
   - **When** user completes Module 3
   - **Then** NFT Conversion + Portfolio features unlock

3. **Monetization Gates**
   - **Given** user is on free tier
   - **When** user tries to access Module 2+
   - **Then** paywall appears with options:
     - "$47 - Unlock Full Course" (one-time)
     - "$49.99/mo - Premium (includes course + features)"
   - **And** purchase flow uses existing Stripe/IAP integration

4. **Firebase Analytics Events**
   - **When** any education event occurs
   - **Then** log to Firebase with properties:
     ```
     - education_module_started {module_id, module_name}
     - education_lesson_completed {module_id, lesson_id, time_spent}
     - education_quiz_attempted {quiz_id, score}
     - education_quiz_passed {quiz_id, score}
     - education_paywall_shown {module_id, price_shown}
     - education_purchase_completed {product_id, price, currency}
     - feature_unlocked {feature_name, unlock_method}
     ```

5. **Progress Tracking**
   - **Given** user progresses through content
   - **When** user opens app
   - **Then** display progress:
     - Overall completion percentage
     - Current module/lesson
     - "Continue Learning" button (goes to next incomplete lesson)
     - Estimated time remaining

6. **Mobile-First Content Display**
   - **Given** content comes from Markdown/PDF
   - **When** displayed in app
   - **Then** must be:
     - Responsive (works on all screen sizes)
     - Interactive (tap to expand, swipe between lessons)
     - Fast loading (< 1 second)
     - Offline-capable (cached after first load)

### Should Have

1. **Gamification Elements**
   - Badges for completing modules
   - Streak tracking (consecutive days learning)
   - Leaderboard (optional, privacy-conscious)
   - NFT rewards for top learners

2. **Interactive Quizzes**
   - Multiple choice questions after each module
   - Must score 80%+ to unlock next module
   - Retry unlimited times (learning tool, not gatekeeper)

3. **Practical Exercises**
   - "Try it now" buttons that open relevant app features
   - Guided walkthroughs for first tax lien search
   - Sample data to practice with

4. **Social Sharing**
   - "I completed Module 1!" share to social
   - Referral bonus for sharing course

### Won't Have (This Iteration)

- **Live coaching/webinars** (future: community feature)
- **User-generated content** (community guides)
- **Certificate of completion** (future: downloadable PDF)
- **AI tutor chatbot** (future: GPT integration)
- **Video lessons** (start with text/images only)

---

## Constraints

### Technical
- **Must** work within existing Flutter app architecture
- **Must** use existing Firebase Analytics instance
- **Must** integrate with existing subscription system (subscription_constants.dart)
- **Must** support iOS, Android, and Web platforms
- **Must NOT** break existing features (backward compatibility)
- **Must** support i18n (internationalization) from day 1
- **Must** use Flutter's localization system (flutter_localizations package already in pubspec.yaml)

### Performance
- **Content loading:** < 1 second per lesson
- **Image loading:** Progressive (show text first, images load async)
- **Offline mode:** All unlocked content available offline
- **App size increase:** < 10MB (compress images, lazy load content)

### Platform
- **iOS:** Minimum iOS 13+
- **Android:** Minimum Android 6.0+
- **Web:** Modern browsers (Chrome, Safari, Firefox)

### Dependencies
- **Firebase SDK** already integrated (firebase_analytics: 12.0.0)
- **Stripe/IAP** integration (existing in-app-purchase package)
- **Content parsing** (markdown to widgets, PDF rendering)

### Business
- **Pricing must align** with existing subscription tiers
- **Cannot cannibalize** existing subscriptions (course adds value)
- **Must track ROI** (Firebase Analytics → revenue attribution)

---

## Open Questions

- [ ] **Content Chunking:** How many lessons per module? (Suggestion: 5-8 lessons × 3 modules = 15-24 total lessons)
- [ ] **Quiz Difficulty:** How hard should quizzes be? (Suggestion: 5 questions, 80% pass rate = 4/5 correct)
- [ ] **Free vs Paid Split:** Which modules are free? (Suggestion: Module 1 free, Module 2-3 paid)
- [ ] **Unlock Timing:** Unlock features immediately after lesson, or after full module? (Suggestion: After full module)
- [ ] **Progress Reset:** Can users re-take course? (Suggestion: Yes, anytime)
- [ ] **Content Updates:** How to handle guidebook updates? (Suggestion: Version in metadata, auto-update)
- [ ] **Offline Content:** Pre-download all content or on-demand? (Suggestion: Pre-download Module 1, lazy load others)

---

## References

### Existing Code
- Firebase Analytics: `apps/taxlien-app/pubspec.yaml` (firebase_analytics: 12.0.0)
- Onboarding: `apps/taxlien-app/lib/screens/interactive_onboarding_screen.dart`
- Subscription: `apps/taxlien-app/lib/core/constants/subscription_constants.dart`
- Educational Content: `/3rdparty/awesomely/Tax-Yields-Guidebook.md`

### Business Plan
- Overall strategy: `/Users/anton/.claude/plans/hashed-petting-fox.md`
- Pricing: $47 (course-only), $49.99/mo (Premium), $199.99/mo (Enterprise)

### Methodology
- SDD Flow: `flows/sdd.md`
- Status: `flows/sdd-in-app-education-monetization/_status.md`

---

## Approval

- [ ] Reviewed by: Anton
- [ ] Approved on: [date]
- [ ] Notes: Waiting for approval to proceed to SPECIFICATIONS phase
