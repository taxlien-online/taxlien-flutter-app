# Requirements: Mobile App UI/UX - Learn-to-Earn Interface Design

> Version: 1.0
> Status: DRAFT
> Last Updated: 2025-12-31

## Problem Statement

### Current State

TAXLIEN.online Flutter приложение имеет 50+ экранов, но отсутствует **единая UI/UX концепция** для Learn-to-Earn flow и монетизации:

**Проблемы:**
1. **Fragmented UX** - нет единого onboarding journey
2. **Paywall недостаточно убедительный** - простой экран выбора планов, без psychology
3. **Нет educational UI** - отсутствуют экраны для курсов, уроков, квизов
4. **Слабая визуализация ценности** - не показываем why Premium стоит $49.99
5. **Нет gamification UI** - отсутствуют badges, progress bars, achievements
6. **Inconsistent design patterns** - разные стили кнопок, карточек, spacing

### Why This Matters

**Business Impact:**
- **Low conversion** - плохой UX = низкая конверсия Free → Paid (5% вместо 10%+)
- **High bounce rate** - пользователи не понимают value proposition
- **Weak retention** - без gamification нет engagement

**User Impact:**
- **Confusion** - не понятно, что делать дальше
- **No motivation** - нет визуального прогресса (progress bars, badges)
- **Fear to commit** - paywall не снимает objections

**Technical Impact:**
- **Design debt** - inconsistent patterns сложнее поддерживать
- **Slow development** - каждый экран создается с нуля
- **A/B testing complexity** - без unified components сложно тестировать variations

---

## User Stories

### Primary Stories

#### Story 1: First-Time User Onboarding (Visual Journey)

**As a** first-time user
**I want** clear visual steps showing my progress
**So that** I understand what I'm unlocking

**Acceptance Criteria:**
- **Welcome Screen** with value proposition (3 key benefits)
- **Progress Indicator** (Step 1/5) at top
- **Animated transitions** between onboarding steps
- **"Skip" button** (but encourage completion with "Unlock search in 2 min")
- **Educational teaser**: "Watch 3-minute video to unlock search"
- **Visual rewards**: Confetti animation when completing step
- **CTA button**: "Start Learning" (prominent, gradient background)

**UI Components:**
- Hero illustration (tax lien investment concept)
- Stepper widget (horizontal dots: ● ○ ○ ○ ○)
- Animated card transitions (slide in from right)
- Floating action button with pulse animation

#### Story 2: Course Module Screen (Educational UI)

**As a** user taking a course
**I want** clear visual structure of lessons
**So that** I can track my learning progress

**Acceptance Criteria:**
- **Module card** with:
  - Title, duration (e.g., "Module 1 - Tax Lien Basics · 19 min")
  - Progress bar (0-100%)
  - Lock icon (if locked, requires Premium)
  - "Continue" or "Start" button
- **Lesson list** with:
  - Lesson number, title, duration
  - Checkmark icon (if completed)
  - Play icon (if video lesson)
  - Lock icon (if locked)
- **Quiz indicator**: "Quiz: 5 questions · 80% to pass"
- **Unlock benefit**: "Complete to unlock Search feature"

**UI Components:**
- Expandable accordion (tap module to expand lessons)
- Progress circle animation (0% → 75%)
- Locked content overlay with upgrade CTA
- Video player embed (Vimeo)

#### Story 3: Paywall Screen (Conversion-Optimized)

**As a** free user hitting a limit
**I want** clear comparison of plans
**So that** I can decide if Premium is worth it

**Acceptance Criteria:**
- **Trigger context**: Show WHY paywall appeared (e.g., "You've used 10/10 searches today")
- **Comparison table**: Free vs Starter vs Premium (3 columns)
- **Highlighted tier**: Premium (recommended badge, glowing border)
- **Social proof**: "Join 10,000+ investors" + testimonial carousel
- **Value props**: "Unlock AI predictions worth $297/month"
- **Urgency**: "14-day free trial ending in 3 days" (if trial active)
- **Risk reduction**: "Cancel anytime · No questions asked"
- **CTA buttons**:
  - Primary: "Start 14-Day Free Trial" (large, gradient)
  - Secondary: "Restore Purchases" (text button)
  - Tertiary: "Maybe Later" (if dismissible)
- **Annual savings**: "Save 17% with annual plan"

**UI Components:**
- Feature comparison table (checkmarks, crosses)
- Pricing cards (3 tiers, Premium highlighted)
- Testimonial carousel (swipeable)
- Countdown timer (trial expiry)
- Toggle switch (Monthly / Annual)

#### Story 4: AI Analysis Result Screen

**As an** investor using AI predictions
**I want** visually clear risk assessment
**So that** I can make quick decisions

**Acceptance Criteria:**
- **Property header**: Image, address, price
- **AI Prediction Cards**:
  - Redemption Probability: Large number (78.5%) + gauge chart
  - Risk Score: 0-100 scale with color coding (green/amber/red)
  - Expected ROI: Percentage + payback months
- **Feature Importance**: Horizontal bar chart (top 5 factors)
- **Recommendation**: "BUY" or "AVOID" with reasoning
- **Confidence Score**: "92% confident" with explanation
- **Share button**: Export as PDF or share via social

**UI Components:**
- Gauge chart (redemption probability)
- Risk meter (0-100 with color gradient)
- Horizontal bar chart (feature importance)
- Action buttons (Save, Share, Request Full Report)

#### Story 5: Achievement Unlock (Gamification)

**As a** user completing a milestone
**I want** satisfying visual feedback
**So that** I feel motivated to continue

**Acceptance Criteria:**
- **Full-screen overlay** with:
  - Achievement badge (large, animated)
  - Achievement title: "Tax Lien Scholar"
  - Description: "Completed Module 1"
  - Points earned: "+50 points"
  - Progress to next level: "250/500 points to Level 2"
- **Animations**:
  - Confetti particles falling
  - Badge zoom in + pulse
  - Sound effect (optional)
- **Share CTA**: "Share on LinkedIn"
- **Next action**: "Start Module 2" button

**UI Components:**
- Modal overlay (blurred background)
- Animated SVG badge
- Confetti particle system
- Progress bar to next level

### Secondary Stories

#### Story 6: Referral Dashboard

**As a** user with referrals
**I want** clear tracking of rewards
**So that** I know how much I've earned

**Acceptance Criteria:**
- **Referral code**: Large, copyable (tap to copy)
- **Stats cards**:
  - Total referrals: 12
  - Pending rewards: $40
  - Paid rewards: $120
- **Referral list**: Name, status (pending/paid), amount
- **Share buttons**: SMS, Email, WhatsApp, Instagram
- **Progress to NFT**: "8 more referrals to unlock Limited Edition NFT"

#### Story 7: Portfolio Dashboard

**As a** Premium user
**I want** visual analytics of my investments
**So that** I can optimize my strategy

**Acceptance Criteria:**
- **Total value**: Large number at top
- **Performance charts**:
  - ROI by property (bar chart)
  - Risk distribution (pie chart)
  - County diversification (map)
- **Property cards**: Thumbnail, address, status, ROI
- **Filters**: County, risk level, status
- **Export button**: Download CSV/PDF

---

## Design System

### Color Palette (Already Defined)

**Primary Colors:**
```dart
Deep Blue (Trust):     #1E3A8A  // Primary
Blue (Active):         #3B82F6  // Primary Light
Gold (Wealth):         #F59E0B  // Secondary
```

**Semantic Colors:**
```dart
Success (Green):       #10B981  // Redemption likely, Low risk
Warning (Amber):       #F59E0B  // Medium risk
Error (Red):           #EF4444  // High risk, Avoid
Info (Blue):           #3B82F6  // Information
```

**Status Colors:**
```dart
Tax Lien Available:    #10B981  // Green
Tax Lien Sold:         #EF4444  // Red
Tax Lien Pending:      #F59E0B  // Amber
Tax Lien Redeemed:     #3B82F6  // Blue
```

**Risk Level Colors:**
```dart
Risk Low (0-30):       #10B981  // Green
Risk Medium (31-60):   #F59E0B  // Amber
Risk High (61-100):    #EF4444  // Red
```

### Typography (Google Fonts Inter)

```dart
// Headings
H1: Inter 32px Bold       // Screen titles
H2: Inter 24px SemiBold   // Section titles
H3: Inter 20px SemiBold   // Card titles
H4: Inter 18px SemiBold   // Subsections

// Body
Body Large:  Inter 16px Regular   // Main content
Body Medium: Inter 14px Regular   // Secondary content
Body Small:  Inter 12px Regular   // Captions

// Buttons
Button Text: Inter 16px SemiBold

// Labels
Label:       Inter 12px Medium (UPPERCASE)
```

### Spacing Scale

```dart
// Based on 8px grid
xs:  4px   // Tight spacing
sm:  8px   // Small spacing
md:  16px  // Default spacing
lg:  24px  // Section spacing
xl:  32px  // Large spacing
2xl: 48px  // Extra large spacing
3xl: 64px  // Screen margins
```

### Border Radius

```dart
// Rounded corners
sm:     4px   // Tight radius (tags, badges)
md:     8px   // Default radius (cards)
lg:     12px  // Large radius (buttons)
xl:     16px  // Extra large (modals)
2xl:    24px  // Rounded (hero elements)
full:   999px // Pills (achievement badges)
```

### Elevation (Shadows)

```dart
// Light theme shadows
elevation-sm:  0 1px 2px rgba(0,0,0,0.05)
elevation-md:  0 4px 6px rgba(0,0,0,0.1)
elevation-lg:  0 10px 15px rgba(0,0,0,0.1)
elevation-xl:  0 20px 25px rgba(0,0,0,0.15)

// Dark theme shadows
elevation-sm:  0 1px 2px rgba(0,0,0,0.25)
elevation-md:  0 4px 6px rgba(0,0,0,0.3)
elevation-lg:  0 10px 15px rgba(0,0,0,0.3)
elevation-xl:  0 20px 25px rgba(0,0,0,0.4)
```

---

## UI Components Library

### 1. Buttons

#### Primary Button
```dart
// Large, gradient background, prominent CTA
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: Text('Start 14-Day Free Trial'),
)
```

**Use cases:**
- Main CTA on paywall
- "Start Learning" button
- "Upgrade to Premium"

#### Secondary Button
```dart
// Outlined, less prominent
OutlinedButton(
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: AppColors.primary, width: 1.5),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: Text('Maybe Later'),
)
```

**Use cases:**
- "Restore Purchases"
- "Skip" button
- Secondary actions

#### Text Button
```dart
// No border, minimal
TextButton(
  child: Text('Terms & Privacy'),
)
```

**Use cases:**
- "Learn More"
- Legal links
- Dismissive actions

#### Icon Button
```dart
// Circular background
IconButton(
  icon: Icon(Icons.share),
  style: IconButton.styleFrom(
    backgroundColor: AppColors.lightSurfaceVariant,
  ),
)
```

**Use cases:**
- Share
- Favorite
- Menu

### 2. Cards

#### Property Card
```dart
Card(
  child: Column(
    children: [
      // Property image
      Image.network(propertyImageUrl, height: 120, fit: BoxFit.cover),

      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Address
            Text(property.address, style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),

            // Key metrics
            Row(
              children: [
                _buildMetric('Tax Amount', '\$2,500'),
                _buildMetric('Interest', '18%'),
                _buildMetric('Risk', 'Low'),
              ],
            ),

            SizedBox(height: 12),

            // AI prediction badge
            _buildAIPredictionBadge(0.785), // 78.5% redemption
          ],
        ),
      ),
    ],
  ),
)
```

**Variants:**
- Property card (with image)
- Module card (with progress bar)
- Pricing card (with features list)

#### Stat Card
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.lightSurface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [elevation-md],
  ),
  child: Column(
    children: [
      Icon(Icons.trending_up, color: AppColors.success),
      SizedBox(height: 8),
      Text('\$15,420', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      Text('Total Portfolio Value', style: TextStyle(color: AppColors.lightOnSurfaceVariant)),
    ],
  ),
)
```

**Use cases:**
- Portfolio stats
- Referral stats
- Achievement points

### 3. Progress Indicators

#### Linear Progress Bar
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Module 1 Progress'),
        Text('75%'),
      ],
    ),
    SizedBox(height: 8),
    LinearProgressIndicator(
      value: 0.75,
      backgroundColor: AppColors.neutral200,
      color: AppColors.success,
      minHeight: 8,
      borderRadius: BorderRadius.circular(4),
    ),
  ],
)
```

**Use cases:**
- Course completion
- Upload/download progress
- Level progress

#### Circular Progress (Gauge)
```dart
CustomPaint(
  size: Size(120, 120),
  painter: GaugePainter(value: 0.785, color: AppColors.success),
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('78.5%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('Redemption', style: TextStyle(fontSize: 12, color: AppColors.lightOnSurfaceVariant)),
      ],
    ),
  ),
)
```

**Use cases:**
- Redemption probability
- Risk score
- Confidence level

#### Stepper (Horizontal Dots)
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: List.generate(5, (index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: index <= currentStep ? 8 : 6,
      height: index <= currentStep ? 8 : 6,
      decoration: BoxDecoration(
        color: index <= currentStep ? AppColors.primary : AppColors.neutral300,
        shape: BoxShape.circle,
      ),
    );
  }),
)
```

**Use cases:**
- Onboarding steps
- Quiz progress
- Multi-step forms

### 4. Badges & Tags

#### Achievement Badge
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    gradient: AppColors.successGradient,
    borderRadius: BorderRadius.circular(999),
    boxShadow: [elevation-md],
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.emoji_events, size: 16, color: Colors.white),
      SizedBox(width: 4),
      Text('Tax Lien Scholar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    ],
  ),
)
```

**Variants:**
- Achievement badge (gradient)
- Status tag (flat color)
- Risk level badge (color-coded)

#### Risk Level Badge
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: getRiskColor(riskScore).withOpacity(0.1),
    border: Border.all(color: getRiskColor(riskScore)),
    borderRadius: BorderRadius.circular(4),
  ),
  child: Text(
    getRiskLabel(riskScore), // "LOW", "MEDIUM", "HIGH"
    style: TextStyle(
      color: getRiskColor(riskScore),
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

**Use cases:**
- Risk level (Low/Medium/High)
- Subscription tier (Free/Starter/Premium)
- Status (Active/Pending/Sold)

### 5. Charts

#### Bar Chart (Horizontal)
```dart
// Feature importance visualization
Column(
  children: features.map((feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(feature.name, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: feature.importance,
              backgroundColor: AppColors.neutral200,
              color: AppColors.primary,
              minHeight: 12,
            ),
          ),
          SizedBox(width: 8),
          Text('${(feature.importance * 100).toInt()}%'),
        ],
      ),
    );
  }).toList(),
)
```

**Use cases:**
- AI feature importance
- Portfolio distribution by county
- Risk factor breakdown

#### Pie Chart
```dart
// Risk distribution
PieChart(
  sections: [
    PieChartSectionData(
      value: 40,
      color: AppColors.riskLow,
      title: 'Low\n40%',
      radius: 60,
    ),
    PieChartSectionData(
      value: 35,
      color: AppColors.riskMedium,
      title: 'Medium\n35%',
      radius: 60,
    ),
    PieChartSectionData(
      value: 25,
      color: AppColors.riskHigh,
      title: 'High\n25%',
      radius: 60,
    ),
  ],
)
```

**Use cases:**
- Risk distribution
- Asset allocation
- County diversification

### 6. Modals & Overlays

#### Bottom Sheet (Feature Paywall)
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Drag handle
                Container(width: 40, height: 4, color: AppColors.neutral300),
                SizedBox(height: 16),

                // Lock icon
                Icon(Icons.lock, size: 48, color: AppColors.primary),
                SizedBox(height: 16),

                // Title
                Text('This is a Premium Feature', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),

                // Description
                Text('Upgrade to Premium to unlock AI predictions and advanced analytics'),
                SizedBox(height: 24),

                // CTA
                ElevatedButton(child: Text('Upgrade to Premium')),
              ],
            ),
          ),
        );
      },
    );
  },
);
```

**Use cases:**
- Feature paywalls
- Filter sheets
- Action menus

#### Full-Screen Modal (Achievement Unlock)
```dart
Dialog.fullscreen(
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primary.withOpacity(0.9), AppColors.primaryDark.withOpacity(0.9)],
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Confetti animation (background)
          ConfettiWidget(),

          // Badge animation
          AnimatedBadge(badge: achievement),
          SizedBox(height: 24),

          // Title
          Text('Achievement Unlocked!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 16),

          // Points
          Text('+${achievement.points} points', style: TextStyle(fontSize: 24, color: Colors.white)),
          SizedBox(height: 48),

          // CTA
          ElevatedButton(child: Text('Continue'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    ),
  ),
)
```

**Use cases:**
- Achievement unlocks
- Course completion celebration
- Level up notification

---

## Screen Specifications (Wireframes)

### 1. Onboarding Flow (5 Screens)

#### Screen 1.1: Welcome

```
┌─────────────────────────────────────┐
│  ●  ○  ○  ○  ○        [Skip]       │ <- Stepper + Skip
├─────────────────────────────────────┤
│                                     │
│        [Hero Illustration]          │ <- Tax lien investment concept
│         💰  🏠  📈                  │
│                                     │
│   Welcome to TAXLIEN.online         │ <- H1
│                                     │
│   Earn 18% Returns on               │ <- H2
│   Tax Lien Investments              │
│                                     │
│   ✓ AI-Powered Predictions          │ <- 3 bullet points
│   ✓ NFT Fractional Ownership        │
│   ✓ Learn While You Earn            │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  [     Start Learning     ]         │ <- Primary CTA (gradient)
│                                     │
└─────────────────────────────────────┘
```

#### Screen 1.2: Learn-to-Earn Explanation

```
┌─────────────────────────────────────┐
│  ○  ●  ○  ○  ○        [Skip]       │
├─────────────────────────────────────┤
│                                     │
│        [Animation: Lock → Key]      │ <- Animated icon
│                                     │
│   Complete Lessons,                 │
│   Unlock Features                   │
│                                     │
│   Each module you complete          │
│   unlocks powerful features:        │
│                                     │
│   📖 Module 1 → 🔍 Search           │ <- Feature unlocks
│   📖 Module 2 → 🗺️ County Data      │
│   📖 Module 3 → 🤖 AI Predictions    │
│   📖 Module 4 → 🎨 NFT Integration   │
│   📖 Module 5 → 📊 Analytics         │
│                                     │
├─────────────────────────────────────┤
│  [       Continue       ]           │
└─────────────────────────────────────┘
```

#### Screen 1.3: Subscription Tiers Preview

```
┌─────────────────────────────────────┐
│  ○  ○  ●  ○  ○        [Skip]       │
├─────────────────────────────────────┤
│                                     │
│   Choose Your Plan                  │
│                                     │
│  ┌─────────┬──────────┬──────────┐  │
│  │  FREE   │ STARTER  │ PREMIUM  │  │ <- Tier cards
│  │         │          │ ⭐ Popular│  │
│  ├─────────┼──────────┼──────────┤  │
│  │ $0      │ $19.99   │ $49.99   │  │
│  │ /month  │ /month   │ /month   │  │
│  ├─────────┼──────────┼──────────┤  │
│  │ 10      │ Unlim.   │ Unlim.   │  │ <- Key features
│  │ searches│ searches │ searches │  │
│  │         │          │          │  │
│  │ 3 AI    │ 10 AI    │ Unlim. AI│  │
│  │ /month  │ /month   │          │  │
│  │         │          │          │  │
│  │ Top 10  │ 50       │ All      │  │
│  │ counties│ counties │ counties │  │
│  └─────────┴──────────┴──────────┘  │
│                                     │
│  Start with FREE, upgrade anytime   │
│                                     │
├─────────────────────────────────────┤
│  [   Try Premium Free (14 days)  ]  │ <- Primary CTA
│  [       Start with FREE       ]    │ <- Secondary CTA
└─────────────────────────────────────┘
```

#### Screen 1.4: Permissions

```
┌─────────────────────────────────────┐
│  ○  ○  ○  ●  ○                     │
├─────────────────────────────────────┤
│                                     │
│        [Icon: 🔔 + 📊]              │
│                                     │
│   Enable Notifications              │
│   & Analytics                       │
│                                     │
│   🔔 Get alerts for:                │
│   · New auctions in your area       │
│   · Price changes                   │
│   · AI recommendations              │
│                                     │
│   📊 Help us improve:               │
│   · Anonymous usage analytics       │
│   · Crash reporting                 │
│                                     │
├─────────────────────────────────────┤
│  [     Enable Both     ]            │ <- Primary
│  [   Enable Notifications Only  ]   │ <- Secondary
│  [         Skip         ]           │ <- Tertiary
└─────────────────────────────────────┘
```

#### Screen 1.5: Ready to Go!

```
┌─────────────────────────────────────┐
│  ○  ○  ○  ○  ●                     │
├─────────────────────────────────────┤
│                                     │
│      [Checkmark Animation] ✅       │ <- Animated success
│                                     │
│   You're All Set!                   │
│                                     │
│   Your free trial includes:         │
│                                     │
│   ✓ 14 days of Premium access       │
│   ✓ Unlimited AI predictions        │
│   ✓ Full course access (5 modules)  │
│   ✓ NFT integration                 │
│                                     │
│   Trial ends: January 14, 2026      │ <- Countdown
│                                     │
├─────────────────────────────────────┤
│  [     Start Exploring     ]        │ <- Primary CTA
└─────────────────────────────────────┘
```

### 2. Education Screens

#### Screen 2.1: Course Home

```
┌─────────────────────────────────────┐
│ ← Learn               [Profile] ⚙️   │ <- Header
├─────────────────────────────────────┤
│                                     │
│  Your Learning Progress             │ <- H2
│                                     │
│  ┌─────────────────────────────┐   │
│  │  ████████░░░░░░░░░░░░  35%  │   │ <- Overall progress bar
│  │  175 / 500 points           │   │
│  │  Level 1 · 325 pts to Lvl 2 │   │
│  └─────────────────────────────┘   │
│                                     │
│  Modules                            │
│                                     │
│  ┌─────────────────────────────┐   │ <- Module card (expanded)
│  │ ✓ Module 1: Tax Lien Basics │   │
│  │   19 min · 100% complete    │   │
│  │                             │   │
│  │   Lessons:                  │   │
│  │   ✓ 1.1 What is a Tax Lien? │   │
│  │   ✓ 1.2 Tax Lien vs Deed    │   │
│  │   ✓ 1.3 Why Invest?         │   │
│  │   ✓ Quiz (5 questions)      │   │
│  │                             │   │
│  │   🎉 Unlocked: Search       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │ <- Module card (collapsed)
│  │ ▶ Module 2: Property Research│   │
│  │   18 min · 0% complete      │   │
│  │   🔒 STARTER                │   │ <- Lock badge
│  │                             │   │
│  │   [   Upgrade to Unlock   ]  │   │ <- Upgrade CTA
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ▶ Module 3: Sweet Spot      │   │
│  │   33 min · 0% complete      │   │
│  │   🔒 PREMIUM                │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

#### Screen 2.2: Video Lesson

```
┌─────────────────────────────────────┐
│ ← Module 1           [•••]          │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │ <- Video player (16:9)
│  │       [Video Playing]       │   │
│  │         ▶️  ⏸  ⏭           │   │
│  │    ●●●●●●●●●●○○○○  5:23     │   │ <- Progress bar + time
│  └─────────────────────────────┘   │
│                                     │
│  Lesson 1.1: What is a Tax Lien?    │ <- H3
│  8 minutes                          │
│                                     │
│  In this lesson, you'll learn:      │ <- Description
│  • Definition of tax liens          │
│  • How they work                    │
│  • Why they're a good investment    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Transcript (optional)      │   │ <- Expandable
│  │  [Tap to expand]            │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  [   Mark as Complete   ]           │ <- Primary CTA
│  [     Next Lesson      ]           │ <- Secondary
└─────────────────────────────────────┘
```

#### Screen 2.3: Quiz

```
┌─────────────────────────────────────┐
│ ← Quiz                              │
├─────────────────────────────────────┤
│                                     │
│  Module 1 Quiz                      │ <- H2
│  Question 3 of 5                    │
│                                     │
│  ●  ●  ●  ○  ○                      │ <- Progress dots
│                                     │
│  What is the primary benefit of     │ <- Question
│  investing in tax liens?            │
│                                     │
│  ○ Guaranteed property ownership    │ <- Options (radio buttons)
│  ○ High interest rates              │
│  ○ Low risk                         │
│  ○ Quick profits                    │
│                                     │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│  [      Next Question      ]        │ <- Primary (disabled until selected)
│  [        Skip Quiz        ]        │ <- Tertiary (text button)
└─────────────────────────────────────┘
```

#### Screen 2.4: Quiz Results

```
┌─────────────────────────────────────┐
│ ← Results                           │
├─────────────────────────────────────┤
│                                     │
│        [Trophy Icon] 🏆             │ <- Success icon
│                                     │
│   Congratulations!                  │ <- H1
│                                     │
│   You scored 80%                    │ <- Large score
│   (4 out of 5 correct)              │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  ████████████████░░░░  80%  │   │ <- Progress bar
│  │  You passed! (80% required) │   │
│  └─────────────────────────────┘   │
│                                     │
│   +50 points earned                 │ <- Gamification
│                                     │
│   🎉 Feature Unlocked:              │
│   Search (10 searches/day)          │
│                                     │
├─────────────────────────────────────┤
│  [   Continue to Module 2   ]       │ <- Primary CTA
│  [      Review Answers      ]       │ <- Secondary
└─────────────────────────────────────┘
```

### 3. Paywall Screens

#### Screen 3.1: Paywall (Search Limit Reached)

```
┌─────────────────────────────────────┐
│                  [X]                │ <- Dismissible (if allowed)
├─────────────────────────────────────┤
│                                     │
│        [Icon: 🔒]                   │
│                                     │
│   Daily Search Limit Reached        │ <- H1
│                                     │
│   You've used all 10 searches       │ <- Trigger context
│   today. Upgrade for unlimited!     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Compare Plans              │   │ <- Comparison table
│  │                             │   │
│  │       FREE  STARTER PREMIUM │   │
│  │                             │   │
│  │ Daily   10      ∞       ∞   │   │
│  │ Search                      │   │
│  │                             │   │
│  │ AI/mo    3      10      ∞   │   │
│  │                             │   │
│  │ Counties 10     50    3000+ │   │
│  │                             │   │
│  │ Price   $0   $19.99  $49.99 │   │
│  │                             │   │
│  │       [Upgrade] [Try Free]  │   │ <- CTAs
│  └─────────────────────────────┘   │
│                                     │
│  ⭐ Recommended: Try Premium Free   │ <- Recommendation
│  14-day trial · Cancel anytime      │
│                                     │
├─────────────────────────────────────┤
│  [   Start 14-Day Free Trial   ]    │ <- Primary CTA (gradient)
│  [      Upgrade to Starter     ]    │ <- Secondary
│                                     │
│       Maybe Later                   │ <- Tertiary (text button)
└─────────────────────────────────────┘
```

#### Screen 3.2: Paywall (Full Comparison)

```
┌─────────────────────────────────────┐
│ ← Choose Plan                   [?] │ <- Help icon
├─────────────────────────────────────┤
│                                     │
│  Choose Your Plan                   │ <- H1
│                                     │
│  [Monthly] / [Annual] (Save 17%)    │ <- Toggle switch
│                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │ FREE   │ │STARTER │ │PREMIUM │  │ <- Pricing cards
│  │        │ │        │ │⭐ BEST │  │
│  ├────────┤ ├────────┤ ├────────┤  │
│  │  $0    │ │ $19.99 │ │ $49.99 │  │
│  │ /month │ │ /month │ │ /month │  │
│  ├────────┤ ├────────┤ ├────────┤  │
│  │ ✓ 10   │ │ ✓ Unlm │ │ ✓ Unlm │  │
│  │ search │ │ search │ │ search │  │
│  │        │ │        │ │        │  │
│  │ ✓ 3 AI │ │ ✓ 10 AI│ │ ✓ ∞ AI │  │
│  │        │ │        │ │        │  │
│  │ ✗ NFT  │ │ ✗ NFT  │ │ ✓ NFT  │  │
│  │        │ │        │ │        │  │
│  │ ✗ Exp. │ │ ✓ CSV  │ │ ✓ PDF  │  │
│  ├────────┤ ├────────┤ ├────────┤  │
│  │[Current│ │[Select]│ │[Try 14 │  │
│  │  Plan] │ │        │ │  days] │  │
│  └────────┘ └────────┘ └────────┘  │
│                                     │
│  💬 "This app paid for itself      │ <- Testimonial
│  in the first month!" - John D.     │
│                                     │
│  👥 Join 10,000+ investors          │ <- Social proof
│                                     │
├─────────────────────────────────────┤
│      Restore Purchases              │ <- Text button
└─────────────────────────────────────┘
```

#### Screen 3.3: Trial Ending Soon

```
┌─────────────────────────────────────┐
│                  [X]                │
├─────────────────────────────────────┤
│                                     │
│     [Icon: ⏰ + Countdown]          │
│                                     │
│   Your Trial Ends Soon              │ <- H1
│                                     │
│       3 days remaining               │ <- Large countdown
│                                     │
│   Continue enjoying:                │
│   ✓ Unlimited AI predictions        │ <- Benefits reminder
│   ✓ All 3,000+ counties             │
│   ✓ NFT integration                 │
│   ✓ Priority support                │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Upgrade now and save 17%   │   │ <- Discount offer
│  │                             │   │
│  │  [Monthly] / [Annual]       │   │ <- Toggle
│  │                             │   │
│  │  $49.99/mo → $499.99/year   │   │
│  │  (Save $99.89)              │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  [  Subscribe to Annual (17% off) ] │ <- Primary CTA
│  [    Subscribe to Monthly      ]   │ <- Secondary
│                                     │
│       Remind Me Later                │ <- Tertiary
└─────────────────────────────────────┘
```

### 4. AI Analysis Screen

```
┌─────────────────────────────────────┐
│ ← Analysis            [Share] 📤    │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │  [Property Image]           │   │ <- Photo
│  └─────────────────────────────┘   │
│                                     │
│  123 Main St, Union County, FL      │ <- H3
│  $2,500 tax amount · 18% interest   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  AI Prediction Summary      │   │ <- Section
│  │                             │   │
│  │   ┌────────────────┐        │   │
│  │   │       78.5%    │        │   │ <- Gauge chart
│  │   │   Redemption   │        │   │
│  │   │     Likely     │        │   │
│  │   └────────────────┘        │   │
│  │                             │   │
│  │  Risk Score: 35 (LOW) 🟢    │   │ <- Risk badge
│  │  ████████░░░░░░░░░░░░  35   │   │
│  │                             │   │
│  │  Expected ROI: 18.5%        │   │
│  │  Payback: 8 months          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Key Factors (Top 5)        │   │ <- Bar chart
│  │                             │   │
│  │  Homestead Exempt ████ 25%  │   │
│  │  Owner Tenure     ███  18%  │   │
│  │  Tax/Value Ratio  ██   15%  │   │
│  │  County Avg       █    12%  │   │
│  │  Property Type    █    10%  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  💡 Recommendation          │   │
│  │                             │   │
│  │  ✅ BUY                     │   │ <- Large recommendation
│  │                             │   │
│  │  This property shows strong │   │
│  │  redemption indicators and  │   │
│  │  low risk factors.          │   │
│  │                             │   │
│  │  Confidence: 92%            │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  [ Save to Portfolio ]  [Share PDF] │ <- Action buttons
└─────────────────────────────────────┘
```

### 5. Achievement Unlock (Full-Screen Modal)

```
┌─────────────────────────────────────┐
│                                     │
│         ✨ ✨ ✨ ✨                  │ <- Confetti animation
│    ✨              ✨               │
│  ✨                  ✨             │
│                                     │
│        ┌───────────┐                │
│        │           │                │ <- Badge (large, animated)
│        │     🏆    │                │
│        │           │                │
│        └───────────┘                │
│                                     │
│   Achievement Unlocked!             │ <- H1 (white text)
│                                     │
│   Tax Lien Scholar                  │ <- H2
│   Completed Module 1                │
│                                     │
│        +50 points                   │ <- Large points
│                                     │
│   ████████░░░░░░░░░░  250/500       │ <- Progress to next level
│   Level 1 · 250 pts to Level 2      │
│                                     │
│                                     │
│  ✨              ✨                 │
│    ✨          ✨                   │
│       ✨ ✨ ✨                       │
│                                     │
├─────────────────────────────────────┤
│  [       Continue       ]           │ <- Primary CTA (white bg)
│       Share on LinkedIn              │ <- Secondary (text)
└─────────────────────────────────────┘
```

### 6. Referral Dashboard

```
┌─────────────────────────────────────┐
│ ← Referrals         [How it works?] │
├─────────────────────────────────────┤
│                                     │
│  Your Referral Code                 │ <- H2
│                                     │
│  ┌─────────────────────────────┐   │
│  │     TAXLIEN2025             │   │ <- Large code (tap to copy)
│  │     [Tap to copy]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  Share via:                         │
│  [💬 SMS] [📧 Email] [📱 WhatsApp]  │ <- Share buttons
│                                     │
│  ┌──────────┬──────────┬─────────┐  │
│  │    12    │   $40    │  $120   │  │ <- Stats cards
│  │ Referrals│ Pending  │  Paid   │  │
│  └──────────┴──────────┴─────────┘  │
│                                     │
│  🎨 8 more referrals to unlock      │ <- Progress to NFT
│  Limited Edition Tax Lien NFT       │
│  ████████░░░░░░░░░░░░  12/20        │
│                                     │
│  Recent Referrals                   │ <- H3
│                                     │
│  ┌─────────────────────────────┐   │
│  │ John D.                     │   │ <- Referral list item
│  │ Signed up Dec 30            │   │
│  │ Status: Pending · $20       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Sarah M.                    │   │
│  │ Subscribed Dec 15           │   │
│  │ Status: Paid · $20  ✅      │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## Acceptance Criteria

### Functional

- ✅ **Onboarding flow** (5 screens with stepper navigation)
- ✅ **Course home** (module cards, progress tracking, locked content)
- ✅ **Video lessons** (Vimeo embed, progress tracking)
- ✅ **Quizzes** (multiple choice, results screen, retry)
- ✅ **Paywall variations** (feature-specific, comparison, trial expiry)
- ✅ **AI analysis** (gauge charts, bar charts, recommendations)
- ✅ **Achievement unlock** (full-screen modal, confetti animation)
- ✅ **Referral dashboard** (code sharing, stats, progress to NFT)

### Non-Functional

- ✅ **Responsive design** (iPhone SE to iPad Pro)
- ✅ **Dark mode support** (all screens)
- ✅ **Accessibility** (VoiceOver, Dynamic Type)
- ✅ **Animations** (60fps smooth transitions)
- ✅ **Loading states** (skeleton screens, progress indicators)
- ✅ **Error states** (friendly error messages, retry actions)

---

## Constraints & Assumptions

### Constraints

1. **Flutter framework** - must use Flutter widgets
2. **Material Design 3** - follow Material 3 guidelines
3. **Existing theme** - use AppColors, AppTheme (already defined)
4. **Video hosting** - Vimeo (requires player embed)
5. **Platform support** - iOS 14+, Android 7+

### Assumptions

1. **Content ready** - videos, PDFs from 3rdparty/awesomely
2. **ML API available** - AI predictions from sdd-ml-service
3. **Firebase configured** - Analytics, Auth ready
4. **RevenueCat configured** - IAP products set up
5. **Design assets** - icons, illustrations (use Material Icons + custom SVG)

---

## Out of Scope (Not in MVP)

- ❌ Web responsive design (mobile-only)
- ❌ Tablet-specific layouts (use mobile layout on tablet)
- ❌ Landscape mode optimization (portrait-only)
- ❌ Offline video downloads (stream-only)
- ❌ Custom video player (use Vimeo embed)
- ❌ Social login UI customization (use default Firebase UI)

---

## Success Metrics

### UI/UX KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Onboarding completion** | 70% | Firebase Analytics funnel |
| **Paywall conversion** | 10% | Paywall views → Subscriptions |
| **Course completion rate** | 50% | Module completions / Starts |
| **Quiz pass rate** | 80% | Passed / Attempted |
| **Daily active users** | 30% DAU/MAU | Firebase Analytics |
| **Session duration** | 8 min | Firebase Analytics |

### Technical KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Page load time** | <2 sec | Firebase Performance |
| **Animation FPS** | 60 fps | Flutter DevTools |
| **Crash-free rate** | 99.9% | Firebase Crashlytics |
| **Accessibility score** | 95%+ | Accessibility scanner |

---

## Dependencies

### Design Dependencies

- **Figma mockups** - high-fidelity designs (optional, can use wireframes)
- **Icon pack** - Material Icons (already included)
- **Illustrations** - undraw.co or custom SVG
- **Video thumbnails** - extracted from Vimeo

### Technical Dependencies

- **sdd-mobile-app** - business logic, state management
- **sdd-ml-service** - AI predictions API
- **Firebase** - Analytics, Auth, Remote Config
- **RevenueCat** - IAP management
- **Vimeo** - video hosting

---

## Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Design inconsistency** | Medium | High | Use design system, component library |
| **Poor video playback** | High | Medium | Test on low-end devices, adaptive bitrate |
| **Paywall rejection (App Store)** | High | Low | Follow Apple guidelines, clear disclosures |
| **Accessibility issues** | Medium | Medium | Test with VoiceOver, Dynamic Type |
| **Animation performance** | Medium | Medium | Optimize animations, use Hero widgets |

---

## Next Steps

1. **SPECIFICATIONS Phase:**
   - Create Figma mockups (high-fidelity)
   - Animate prototypes (interactive)
   - User testing (5-10 users)

2. **Component Implementation:**
   - Build reusable widgets library
   - Storybook for components (widget gallery)
   - Unit tests for widgets

3. **Screen Implementation:**
   - Onboarding flow (Week 1)
   - Education screens (Week 2-3)
   - Paywall variations (Week 4)
   - AI analysis (Week 5)

4. **Testing:**
   - Widget tests
   - Integration tests (screen flows)
   - Accessibility audit
   - Performance profiling

---

## NEW INNOVATIVE SCREENS (Original Ideas)

### 7. Deal Detective (Swipe-Based Property Scanner)

#### Screen 7.1: Swipe Interface

```
┌─────────────────────────────────────┐
│ Deal Detective 🔍        [Filters]  │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │  ┌─────────────────────┐    │   │ <- Card stack (3 cards visible)
│  │  │ [Property Image]     │    │   │
│  │  │ 📍 123 Oak St        │    │   │
│  │  │ Phoenix, AZ 85001    │    │   │
│  │  │                      │    │   │
│  │  │ 💰 Tax Lien: $2,450  │    │   │
│  │  │ 🏠 Est. Value: $185K │    │   │
│  │  │ 📊 ROI: 16%          │    │   │
│  │  │                      │    │   │
│  │  │ ⚡ AI Score: 8.7/10  │    │   │ <- Large score badge
│  │  │ "High-quality deal"  │    │   │
│  │  │                      │    │   │
│  │  │ 🟢 Low Risk          │    │   │
│  │  │ ⏱️ 18 mo redemption  │    │   │
│  │  └─────────────────────┘    │   │
│  │    ┌───────────────────┐    │   │ <- Next card (peek)
│  │    │ [Blurred preview] │    │   │
│  │    └───────────────────┘    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ← ─────────────────────────── →   │ <- Swipe indicator
│  Skip                         Save  │
│                                     │
│  ┌──────┬──────┬──────┬──────┐     │
│  │  👈  │  ⭐  │  💾  │  👉  │     │ <- Action buttons
│  │ Pass │ Watch│ Save │ Buy! │     │
│  └──────┴──────┴──────┴──────┘     │
│                                     │
│  Reviewed: 12 · Saved: 3            │ <- Progress stats
└─────────────────────────────────────┘
```

**User Story:**
```
As an investor browsing properties
I want a quick swipe interface like dating apps
So that I can evaluate 100+ properties in 5 minutes
```

**Acceptance Criteria:**
- **Swipe gestures:**
  - Left swipe = Pass (skip property)
  - Right swipe = Buy List (add to favorites)
  - Up swipe = Watchlist (track for later)
  - Down swipe = Reject (never show again)
- **Card stack:** Show 3 cards at once (current + 2 preview)
- **AI scoring:** 0-10 scale with reasoning
- **Quick stats:** Tax amount, value, ROI, risk
- **Filters button:** County, price range, ROI min
- **Session stats:** Track how many reviewed/saved
- **Animations:** Smooth card transitions (60fps)

**UI Components:**
- Swipeable card stack (custom widget)
- Action button row (4 buttons)
- AI score badge (gradient, large font)
- Property image carousel (3-5 photos)
- Filter bottom sheet

---

### 8. Risk Radar (Visual Risk Assessment)

#### Screen 8.1: Radar Chart View

```
┌─────────────────────────────────────┐
│ ← Risk Radar              [Share]   │
├─────────────────────────────────────┤
│  123 Main St, Union County, FL      │ <- Property header
│  $2,500 · 18% ROI                   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │     Neighborhood Quality    │   │
│  │            90%  ▲           │   │ <- Radar chart (pentagon)
│  │                 │           │   │
│  │    Legal    ●───┼───●       │   │
│  │    Risk 40%   ╱ │ ╲  Property│  │
│  │             ╱   │   ╲ Cond. │   │
│  │           ●─────┼─────● 75% │   │
│  │         Market  │  Financial│   │
│  │         85%     ▼  Strength │   │
│  │                    60%      │   │
│  └─────────────────────────────┘   │
│                                     │
│  Overall Risk: MEDIUM 🟡            │ <- Large risk badge
│  ██████████░░░░░░░░░░  48/100       │
│                                     │
│  Top Risk Factors:                  │ <- Expandable list
│  ┌─────────────────────────────┐   │
│  │ ⚠️ Legal Complexity         │   │
│  │ Foreclosure process: 6-12 mo│   │
│  │ [Learn More]                │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚠️ Property Condition       │   │
│  │ Est. repairs: $8K           │   │
│  │ [View Photos]               │   │
│  └─────────────────────────────┘   │
│                                     │
│  💡 Mitigation Strategies:          │
│  • Set aside $10K for repairs       │
│  • Budget 12 months for legal       │
│  • Consider cash offer if foreclosed│
│                                     │
├─────────────────────────────────────┤
│  [ Save to Portfolio ]  [Buy Now]   │
└─────────────────────────────────────┘
```

**User Story:**
```
As a risk-averse investor
I want visual breakdown of all risk factors
So that I understand what could go wrong
```

**Acceptance Criteria:**
- **Radar chart:** 5 dimensions (Legal, Financial, Property, Market, Neighborhood)
- **Each dimension:** 0-100 scale, color-coded
- **Overall score:** Weighted average of all dimensions
- **Risk factors list:** Expandable cards with explanations
- **Mitigation advice:** AI-generated strategies
- **Educational links:** "Learn More" → help articles
- **Share feature:** Export as PDF report

**UI Components:**
- Custom radar chart (CustomPaint)
- Risk score meter (linear progress)
- Expandable accordion (risk factors)
- Action buttons (Save, Buy, Share)

---

### 9. Portfolio Simulator (Practice Mode)

#### Screen 9.1: Sandbox Dashboard

```
┌─────────────────────────────────────┐
│ 🎮 Practice Mode        [Exit]  ⚙️  │
├─────────────────────────────────────┤
│  Virtual Portfolio                  │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💵 Balance: $10,000         │   │ <- Starting virtual cash
│  │ 💰 Invested: $7,200         │   │
│  │ 📈 Profit: +$480 (6.7%)     │   │
│  │ ⏱️ Day 45 of 730           │   │ <- Time simulation
│  └─────────────────────────────┘   │
│                                     │
│  Your Virtual Investments:          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏠 Property A               │   │ <- Investment card
│  │ 123 Oak St, Phoenix         │   │
│  │                             │   │
│  │ Invested: $2,100 · Day 45   │   │
│  │ Status: ✅ REDEEMED         │   │
│  │ Profit: +$480 (16% APR)     │   │
│  │                             │   │
│  │ 💡 What happened:           │   │
│  │ Owner paid taxes + interest │   │
│  │ You earned $480 in 10 mo    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏡 Property B               │   │
│  │ 456 Pine Ln, Scottsdale     │   │
│  │                             │   │
│  │ Invested: $3,600 · Day 45   │   │
│  │ Status: ⏳ PENDING          │   │
│  │ Est. return: $720 (12 mo)   │   │
│  │                             │   │
│  │ Next event: Check in 30 days│   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏚️ Property C                │   │
│  │ 789 Elm Dr, Tucson          │   │
│  │                             │   │
│  │ Invested: $1,500 · Day 45   │   │
│  │ Status: ⚠️ FORECLOSING      │   │
│  │ You'll own this property!   │   │
│  │                             │   │
│  │ Next: Legal process (6 mo)  │   │
│  │ [Learn About Foreclosure]   │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  [Fast Forward 30 Days →]           │ <- Time skip button
│  [Browse More Properties]           │
└─────────────────────────────────────┘
```

**User Story:**
```
As a beginner investor
I want to practice without risking real money
So that I can learn the investment lifecycle
```

**Acceptance Criteria:**
- **Virtual cash:** Start with $10,000 (configurable)
- **Real properties:** Use actual tax lien data (flagged as "practice")
- **Time simulation:** Fast-forward 1 day, 7 days, 30 days, 1 year
- **Realistic outcomes:** Based on historical redemption rates
- **Educational popups:** Explain what happened at each stage
- **Progress tracking:** Track simulation performance
- **Unlock real investing:** After 5 successful simulations
- **Share results:** "I made $2,500 profit in practice mode!"

**UI Components:**
- Balance cards (Cash, Invested, Profit)
- Investment timeline (Day X of Y)
- Property status cards (Redeemed, Pending, Foreclosing)
- Time skip controls (fast-forward buttons)
- Educational overlays (what happens next)

---

### 10. ROI Calculator Live (Interactive Slider Tool)

#### Screen 10.1: Calculator Interface

```
┌─────────────────────────────────────┐
│ ← ROI Calculator           [Save]   │
├─────────────────────────────────────┤
│  Calculate Your Returns             │
│                                     │
│  Your Investment:                   │
│  ┌─────────────────────────────┐   │
│  │ $2,500                      │   │ <- Large number (editable)
│  │ [━━━━●───────────] $10,000  │   │ <- Slider
│  └─────────────────────────────┘   │
│                                     │
│  Interest Rate:                     │
│  ┌─────────────────────────────┐   │
│  │ 16% annual                  │   │
│  │ [━━━●────────────] 24%      │   │
│  └─────────────────────────────┘   │
│                                     │
│  Redemption Period:                 │
│  ┌─────────────────────────────┐   │
│  │ 18 months                   │   │
│  │ [━━━━●───────────] 36 mo    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  📊 Your Potential Return:          │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │     💵 $3,100               │   │ <- Large result
│  │     Profit: $600            │   │
│  │     ROI: 24%                │   │
│  │                             │   │
│  │  ██████████████░░░░░  24%   │   │ <- Visual ROI bar
│  └─────────────────────────────┘   │
│                                     │
│  ⚠️ If NOT Redeemed:                │
│  ┌─────────────────────────────┐   │
│  │ You become property owner   │   │
│  │ Est. property value: $185K  │   │
│  │ Potential profit: $182K     │   │
│  │                             │   │
│  │ [View Exit Scenarios]       │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  [Save Scenario] [Compare to Others]│
└─────────────────────────────────────┘
```

**User Story:**
```
As an investor evaluating a property
I want to play with numbers (amount, rate, time)
So that I can see how returns change
```

**Acceptance Criteria:**
- **3 input sliders:** Investment amount, interest rate, redemption period
- **Live calculation:** Update results instantly as sliders move
- **Visual feedback:** ROI bar grows/shrinks with changes
- **Foreclosure scenario:** Show what happens if not redeemed
- **Save scenarios:** Store custom calculations
- **Compare feature:** Side-by-side scenario comparison
- **Haptic feedback:** Vibrate when hitting "sweet spots" (18%+ ROI)

**UI Components:**
- Custom sliders with value labels
- Large result card (animated number changes)
- ROI progress bar
- Foreclosure alternate outcome card
- Action buttons (Save, Compare, Share)

---

### 11. County Heatmap (Geographic Deal Finder)

#### Screen 11.1: Interactive Map

```
┌─────────────────────────────────────┐
│ ← Deal Heatmap            [Filters] │
├─────────────────────────────────────┤
│                                     │
│  [Interactive Map - Full Screen]    │ <- Google Maps / Mapbox
│                                     │
│  ┌─────────────────────────────┐   │
│  │        ARIZONA              │   │
│  │                             │   │
│  │  ┌────────┐                 │   │
│  │  │🔴 PHX  │ 127 deals       │   │ <- Pin clusters
│  │  │18% ROI │                 │   │
│  │  └────────┘                 │   │
│  │                             │   │
│  │         ┌────────┐          │   │
│  │         │🟡 TUC  │ 43      │   │
│  │         │14% ROI │          │   │
│  │         └────────┘          │   │
│  │                             │   │
│  │                ┌────────┐   │   │
│  │                │🔵 FLG  │12 │   │
│  │                │11% ROI │   │   │
│  │                └────────┘   │   │
│  └─────────────────────────────┘   │
│                                     │
│  🔴 = Hot (100+ deals, 16%+ ROI)    │ <- Legend
│  🟡 = Moderate (20-100, 12-16%)     │
│  🔵 = Slow (<20 deals, <12%)        │
│                                     │
│  ┌─────────────────────────────┐   │ <- Tap cluster → detail view
│  │ Phoenix (Maricopa County)   │   │
│  │ ───────────────────────────  │   │
│  │ 127 available properties    │   │
│  │ Avg ROI: 18%                │   │
│  │ Avg Price: $2,800           │   │
│  │ Next Auction: Jan 15        │   │
│  │                             │   │
│  │ [View All Properties →]     │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  [List View] [Map View] [My Alerts] │
└─────────────────────────────────────┘
```

**User Story:**
```
As an investor exploring markets
I want a geographic view of where deals are
So that I can target the best counties
```

**Acceptance Criteria:**
- **Interactive map:** Google Maps or Mapbox integration
- **Pin clustering:** Group nearby properties by county
- **Color coding:** Red (hot), Yellow (moderate), Blue (slow)
- **Tap to expand:** Show county details in bottom sheet
- **Filter by:**
  - Min ROI
  - Max price
  - Auction date range
  - Property type
- **My Alerts:** Set geo-alerts for new properties
- **List/Map toggle:** Switch between views

**UI Components:**
- Map widget (Google Maps Flutter)
- Custom map pins (colored clusters)
- Bottom sheet (county details)
- Filter bottom sheet
- Toggle buttons (List/Map)

---

### 12. Auction Countdown Timer (Real-Time Urgency)

#### Screen 12.1: Upcoming Auctions

```
┌─────────────────────────────────────┐
│ ⏰ Auctions            [Calendar] 📅 │
├─────────────────────────────────────┤
│                                     │
│  🔥 LIVE NOW                        │ <- Pulsing badge
│  ┌─────────────────────────────┐   │
│  │ Maricopa County Auction     │   │
│  │ ⏱️ Ends in: 02:34:18        │   │ <- Live countdown
│  │ 📍 87 properties remaining  │   │
│  │                             │   │
│  │ [Join Auction Now →]        │   │ <- Urgent CTA
│  └─────────────────────────────┘   │
│                                     │
│  📅 TOMORROW                        │
│  ┌─────────────────────────────┐   │
│  │ Orange County Auction       │   │
│  │ ⏰ Jan 15 · 9:00 AM EST     │   │
│  │ 📊 124 properties           │   │
│  │ Avg ROI: 17%                │   │
│  │                             │   │
│  │ 🔔 Reminder set ✅          │   │
│  │ [View Property List]        │   │
│  └─────────────────────────────┘   │
│                                     │
│  📆 THIS WEEK                       │
│  ┌─────────────────────────────┐   │
│  │ Thu · Pima County           │   │
│  │ 10:00 AM · 45 properties    │   │
│  │ [Set Reminder 🔔]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Fri · Pinal County          │   │
│  │ 2:00 PM · 32 properties     │   │
│  │ [Set Reminder 🔔]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  🎯 Your Watchlist (3)              │ <- Tracked properties
│  ┌─────────────────────────────┐   │
│  │ 123 Oak St · Wed 9 AM       │   │
│  │ Estimated: $2,100           │   │
│  │ [Remove from Watchlist]     │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**User Story:**
```
As an active bidder
I want to know when auctions are happening
So that I never miss a good deal
```

**Acceptance Criteria:**
- **Live countdown:** Real-time timer (updates every second)
- **Pulsing "LIVE" badge:** Animated to grab attention
- **Push notifications:** 1 hour before auction, 15 min before
- **Calendar integration:** Add to iPhone/Android calendar
- **Watchlist tracking:** Filter auctions with tracked properties
- **Auto-refresh:** Pull latest auction data every 5 min
- **Timezone handling:** Convert to user's local time

**UI Components:**
- Countdown timer widget (real-time updates)
- Pulsing animation badge
- Auction cards (different states: Live, Upcoming, Past)
- Reminder toggle switch
- Watchlist integration

---

### 13. Investment Journey Map (Progress Tracking)

#### Screen 13.1: Journey Dashboard

```
┌─────────────────────────────────────┐
│ ← Your Journey          [Badges] 🏆 │
├─────────────────────────────────────┤
│                                     │
│  Level 3: Active Investor 🎯        │ <- Current level badge
│  ████████░░░░░░░░  80%              │ <- Progress to next level
│  400/500 pts to Level 4             │
│                                     │
│  Your Investment Path:              │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✅ Level 1: Novice          │   │ <- Completed level
│  │ Completed Dec 2024          │   │
│  │                             │   │
│  │ Achievements:               │   │
│  │ • Finished all courses      │   │
│  │ • Passed 5/5 quizzes        │   │
│  │ • Simulated first investment│   │
│  │                             │   │
│  │ Rewards:                    │   │
│  │ 🎁 Unlocked: Search feature │   │
│  │ 🏅 Badge: "Scholar"         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✅ Level 2: Learner         │   │
│  │ Completed Jan 2025          │   │
│  │                             │   │
│  │ Achievements:               │   │
│  │ • Simulated 5 investments   │   │
│  │ • Analyzed 50+ properties   │   │
│  │ • Earned $2K virtual profit │   │
│  │                             │   │
│  │ Rewards:                    │   │
│  │ 🎁 Unlocked: AI predictions │   │
│  │ 🏅 Badge: "Analyst"         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔵 Level 3: Active Investor │   │ <- Current level
│  │ In Progress                 │   │
│  │                             │   │
│  │ Current Tasks:              │   │
│  │ • [x] Made first purchase   │   │
│  │ • [x] Built portfolio of 3  │   │
│  │ • [x] Earned first profit   │   │
│  │ • [ ] Own 5 tax liens       │   │
│  │ • [ ] Earn $1K total profit │   │
│  │                             │   │
│  │ Next Milestone:             │   │
│  │ Buy 2 more properties       │   │
│  │ [Browse Deals →]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔒 Level 4: Expert Investor │   │ <- Locked level
│  │ Unlock at 500 points        │   │
│  │                             │   │
│  │ Requirements:               │   │
│  │ • Own 10+ tax liens         │   │
│  │ • $5K total profit          │   │
│  │ • Complete advanced course  │   │
│  │                             │   │
│  │ Rewards:                    │   │
│  │ 🎁 Unlock: NFT integration  │   │
│  │ 🏅 Badge: "Expert"          │   │
│  │ 💎 Bonus: 20% off Premium  │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  🏆 Achievements: 12/25 unlocked    │
│  [View All Badges →]                │
└─────────────────────────────────────┘
```

**User Story:**
```
As a motivated user
I want to see my investment progress over time
So that I stay engaged and motivated
```

**Acceptance Criteria:**
- **5 levels:** Novice → Learner → Active → Expert → Master
- **Progress tracking:** Points, badges, achievements
- **Level requirements:** Clear tasks to complete
- **Rewards:** Unlock features, badges, discounts
- **Timeline:** Show when each level was completed
- **Next steps:** What to do to level up
- **Share feature:** "I just reached Level 4!"
- **Social leaderboard:** Compare with friends (optional)

**UI Components:**
- Level progress bar
- Expandable level cards (completed, current, locked)
- Achievement badges (icon grid)
- Task checklist (checkboxes)
- Unlock preview cards

---

### 14. Smart Alerts (Personalized Deal Notifications)

#### Screen 14.1: Alert Preferences

```
┌─────────────────────────────────────┐
│ ← Smart Alerts               [Add]  │
├─────────────────────────────────────┤
│  Your Deal Preferences:             │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Alert 1: Phoenix Deals      │   │ <- Saved alert
│  │ Active · 3 new today        │   │
│  │                             │   │
│  │ Criteria:                   │   │
│  │ ✓ Location: Phoenix, AZ     │   │
│  │ ✓ ROI: 15%+ minimum         │   │
│  │ ✓ Type: Residential only    │   │
│  │ ✓ Budget: $1K - $5K         │   │
│  │                             │   │
│  │ [Edit] [Pause] [Delete]     │   │
│  └─────────────────────────────┘   │
│                                     │
│  🎯 New Matches Today (3):          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔥 HOT DEAL · 2 hrs ago     │   │ <- Recent match
│  │ 🏠 Single-family, Phoenix   │   │
│  │ 💰 $2,100 · ROI: 18%        │   │
│  │ ⭐ AI Score: 9.2/10         │   │
│  │                             │   │
│  │ Why it matches:             │   │
│  │ • Meets your ROI target     │   │
│  │ • In Phoenix area           │   │
│  │ • Within budget             │   │
│  │                             │   │
│  │ [View Details] [Save] [Pass]│   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✨ Good Match · 5 hrs ago   │   │
│  │ 🏘️ Condo, Scottsdale        │   │
│  │ 💵 $1,800 · ROI: 16%        │   │
│  │ ⭐ AI Score: 8.5/10         │   │
│  │                             │   │
│  │ [View Details] [Pass]       │   │
│  └─────────────────────────────┘   │
│                                     │
│  📊 Last 7 days:                    │
│  • 47 matches sent                  │
│  • 12 viewed by you                 │
│  • 3 purchased (6% conversion)      │
│                                     │
├─────────────────────────────────────┤
│  [Create New Alert +]               │
└─────────────────────────────────────┘
```

**User Story:**
```
As a busy investor
I want AI to find deals matching my criteria
So that I don't have to search manually
```

**Acceptance Criteria:**
- **Multiple alerts:** Create up to 5 saved searches
- **Custom criteria:**
  - Location (city, county, state)
  - ROI min/max
  - Price range
  - Property type
  - Risk level
  - Auction date
- **Push notifications:** New match within 1 hour
- **Match ranking:** AI scores 0-10 how well it fits
- **Why it matches:** Explain which criteria matched
- **Quick actions:** View, Save, Pass, Snooze
- **Performance stats:** Track conversion rate

**UI Components:**
- Alert cards (editable, pausable)
- Match cards (recent deals)
- AI score badge
- Match reasoning (bullet list)
- Quick action buttons
- Stats dashboard

---

### 15. Community Leaderboard (Social Proof)

#### Screen 15.1: Top Investors

```
┌─────────────────────────────────────┐
│ ← Leaderboard         [Filter] 🏆   │
├─────────────────────────────────────┤
│  🏆 Top Investors This Month        │
│                                     │
│  [This Month] [All Time] [Friends]  │ <- Tabs
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🥇 #1 Sarah M. (Phoenix)    │   │ <- Top 3 highlighted
│  │    💰 $12,400 profit        │   │
│  │    📊 15 successful deals   │   │
│  │    🎓 Level 7: Master       │   │
│  │    ⭐ 18.2% avg ROI         │   │
│  │                             │   │
│  │    [View Profile]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🥈 #2 Mike T. (Orlando)     │   │
│  │    💵 $9,800 profit         │   │
│  │    📈 12 deals              │   │
│  │    🎓 Level 6: Expert       │   │
│  │    ⭐ 16.5% avg ROI         │   │
│  │                             │   │
│  │    [View Profile]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🥉 #3 Lisa K. (Denver)      │   │
│  │    💸 $7,200 profit         │   │
│  │    ⚡ 10 deals              │   │
│  │    🎓 Level 5: Advanced     │   │
│  │    ⭐ 15.8% avg ROI         │   │
│  │                             │   │
│  │    [View Profile]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ───────────────────────────────    │
│                                     │
│  47. You 🎯                         │ <- Your rank
│     $820 profit · 2 deals           │
│     🎓 Level 3: Active Investor     │
│                                     │
│     Next milestone:                 │
│     +2 deals to reach Top 30 🚀     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Top Counties This Month:    │   │ <- Bonus stats
│  │ 1. Maricopa (AZ) - $2.1M    │   │
│  │ 2. Orange (FL) - $1.8M      │   │
│  │ 3. Denver (CO) - $1.2M      │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  [See Full Rankings] [Share Stats]  │
└─────────────────────────────────────┘
```

**User Story:**
```
As a competitive investor
I want to see how I rank against others
So that I'm motivated to perform better
```

**Acceptance Criteria:**
- **Leaderboard views:**
  - This Month
  - All Time
  - Friends Only
- **Metrics tracked:**
  - Total profit
  - Number of deals
  - Avg ROI
  - Investor level
- **Your rank:** Highlighted position
- **Next milestone:** What's needed to climb
- **Privacy:** Opt-in only, can hide profile
- **Share feature:** "I'm #47 on TAXLIEN leaderboard!"
- **Bonus stats:** Top counties, top property types

**UI Components:**
- Tab selector (This Month, All Time, Friends)
- Top 3 cards (gold, silver, bronze badges)
- Your rank card (highlighted)
- Milestone progress
- Share button

---

### 16. Exit Strategy Planner (Scenario Planning)

#### Screen 16.1: Scenario Analyzer

```
┌─────────────────────────────────────┐
│ ← Exit Strategies          [Save]   │
├─────────────────────────────────────┤
│  Property: 123 Oak St, Phoenix      │
│  Investment: $2,500                 │
│                                     │
│  Scenario 1: ✅ REDEMPTION (80%)    │ <- Most likely
│  ┌─────────────────────────────┐   │
│  │ Owner pays back + interest  │   │
│  │                             │   │
│  │ You receive: $2,900         │   │
│  │ Profit: $400 (16%)          │   │
│  │ Timeline: 12-18 months      │   │
│  │                             │   │
│  │ Probability: 80%            │   │
│  │ ████████████████░░░░  80%   │   │
│  │                             │   │
│  │ [View Redemption Process]   │   │
│  └─────────────────────────────┘   │
│                                     │
│  Scenario 2: 🏠 FORECLOSURE (15%)   │
│  ┌─────────────────────────────┐   │
│  │ You become property owner   │   │
│  │                             │   │
│  │ Your Exit Options:          │   │
│  │                             │   │
│  │ A) 🏡 Sell Property         │   │
│  │    Est. sale: $185K         │   │
│  │    Minus costs: $10K        │   │
│  │    Net profit: ~$172K       │   │
│  │    Timeline: 3-6 months     │   │
│  │                             │   │
│  │ B) 🏠 Rent It Out           │   │
│  │    Est. rent: $1,800/mo     │   │
│  │    Annual ROI: 12%          │   │
│  │    Cash flow: $21K/year     │   │
│  │    Timeline: Ongoing        │   │
│  │                             │   │
│  │ C) 🔨 Fix & Flip            │   │
│  │    Renovation: $30K         │   │
│  │    Resale value: $220K      │   │
│  │    Net profit: ~$187K       │   │
│  │    Timeline: 6-12 months    │   │
│  │                             │   │
│  │ [Compare Exit Options]      │   │
│  └─────────────────────────────┘   │
│                                     │
│  Scenario 3: ⚠️ COMPLICATIONS (5%)  │
│  ┌─────────────────────────────┐   │
│  │ Potential Issues:           │   │
│  │ • Legal disputes            │   │
│  │ • Title problems            │   │
│  │ • Environmental liens       │   │
│  │                             │   │
│  │ Mitigation:                 │   │
│  │ • Title insurance ($500)    │   │
│  │ • Legal budget ($2K)        │   │
│  │ • Exit within 90 days       │   │
│  │                             │   │
│  │ [Learn About Risks]         │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  [Download Full Plan PDF]           │
│  [Share with Partner]               │
└─────────────────────────────────────┘
```

**User Story:**
```
As a risk-aware investor
I want to plan for all possible outcomes
So that I'm prepared no matter what happens
```

**Acceptance Criteria:**
- **3 scenarios:** Redemption, Foreclosure, Complications
- **Probability estimates:** Based on property data
- **Financial projections:** For each scenario
- **Timeline estimates:** How long each path takes
- **Exit options:** If foreclosure, show 3 exit paths
- **Risk mitigation:** Suggest insurance, budgets
- **Downloadable PDF:** Full strategy document
- **Share feature:** Email to partners, advisors

**UI Components:**
- Scenario cards (expandable)
- Probability bars
- Financial breakdown tables
- Timeline estimates
- Action buttons (Download, Share, Compare)

---

## Summary of New Screens

Total screens now: **8 existing + 10 new = 18 screens**

| # | Screen Name | Type | Priority | Effort |
|---|------------|------|----------|--------|
| 7 | **Deal Detective** | Swipe UI | P0 | 3 weeks |
| 8 | **Risk Radar** | Visual Analytics | P0 | 2 weeks |
| 9 | **Portfolio Simulator** | Gamification | P0 | 4 weeks |
| 10 | **ROI Calculator** | Interactive Tool | P1 | 1 week |
| 11 | **County Heatmap** | Geographic | P0 | 3 weeks |
| 12 | **Auction Timer** | Real-Time | P1 | 2 weeks |
| 13 | **Journey Map** | Gamification | P1 | 2 weeks |
| 14 | **Smart Alerts** | AI Matching | P0 | 3 weeks |
| 15 | **Leaderboard** | Social Proof | P2 | 1 week |
| 16 | **Exit Strategy** | Planning Tool | P0 | 2 weeks |

---

**Status:** REQUIREMENTS UPDATED ✅
**Next Phase:** SPECIFICATIONS (Component library, animations)
**Timeline:** 12-16 weeks to MVP (18 screens)
**Team:** 1 Designer + 3 Flutter Developers
