# Screen Flow Diagram - Mobile App UI/UX

> Visual map of all 18 screens and user navigation paths
> Created: 2025-12-31

---

## User Journey Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     USER JOURNEY MAP                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  New User → Onboarding → Education → Hit Limit → Paywall   │
│                              ↓                               │
│                      Practice Simulator                     │
│                              ↓                               │
│                    Swipe Properties                         │
│                              ↓                               │
│                     Smart Alerts                            │
│                              ↓                               │
│              Real Investment → Success                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Complete Screen Map (18 Screens)

### Phase 1: Onboarding & Education (8 screens)

```
┌──────────────────────────────────────────────────────────────┐
│                    ONBOARDING FLOW                           │
└──────────────────────────────────────────────────────────────┘

    1. Welcome Screen
           ↓
    2. Learn-to-Earn Explanation
           ↓
    3. Pricing Tiers Preview
           ↓
    4. Permissions Request
           ↓
    5. Ready to Go!

                    ↓

┌──────────────────────────────────────────────────────────────┐
│                   EDUCATION SCREENS                          │
└──────────────────────────────────────────────────────────────┘

    6. Course Home ←─────────┐
           ↓                 │
    7. Video Lesson          │
           ↓                 │
    8. Quiz → Results        │
           └─────────────────┘

                    ↓

┌──────────────────────────────────────────────────────────────┐
│                 MONETIZATION SCREENS                         │
└──────────────────────────────────────────────────────────────┘

    9. Paywall (3 variations)
           ↓
    10. AI Analysis (Premium feature showcase)
           ↓
    11. Achievement Unlock (gamification)
           ↓
    12. Referral Dashboard
```

---

### Phase 2: Innovative Features (10 NEW screens)

```
┌──────────────────────────────────────────────────────────────┐
│               PRACTICE & LEARNING TOOLS                      │
└──────────────────────────────────────────────────────────────┘

    13. Portfolio Simulator 🎮
        • Virtual $10K to invest
        • Time travel (fast-forward)
        • See outcomes (redemption/foreclosure)
        • Learn without risk

    14. ROI Calculator Live 📊
        • Interactive sliders
        • Real-time calculations
        • What-if scenarios
        • Save comparisons

┌──────────────────────────────────────────────────────────────┐
│               PROPERTY DISCOVERY TOOLS                       │
└──────────────────────────────────────────────────────────────┘

    15. Deal Detective 👈👉
        • Swipe left/right on properties
        • AI scoring (0-10)
        • Quick evaluation (100+ props in 5 min)
        • Addictive UX

    16. County Heatmap 🗺️
        • Geographic visualization
        • Color-coded (hot/moderate/slow)
        • Filter by ROI, price, type
        • Tap clusters → details

    17. Smart Alerts 🔔
        • AI-powered deal matching
        • Custom criteria (location, ROI, budget)
        • Push notifications
        • "Why it matches" explanations

┌──────────────────────────────────────────────────────────────┐
│               RISK & PLANNING TOOLS                          │
└──────────────────────────────────────────────────────────────┘

    18. Risk Radar 📡
        • 5-dimension radar chart
        • Visual risk breakdown
        • Mitigation strategies
        • Educational tooltips

    19. Exit Strategy Planner 📋
        • 3 scenarios (redemption/foreclosure/complications)
        • Financial projections
        • Timeline estimates
        • Downloadable PDF

┌──────────────────────────────────────────────────────────────┐
│               ENGAGEMENT & RETENTION                         │
└──────────────────────────────────────────────────────────────┘

    20. Auction Timer ⏰
        • Live countdown
        • Real-time urgency
        • Calendar integration
        • Watchlist tracking

    21. Journey Map 🎯
        • 5 levels (Novice → Master)
        • Progress tracking
        • Unlock rewards
        • Gamification

    22. Leaderboard 🏆
        • Top investors ranking
        • Social proof
        • Competition
        • Share achievements
```

---

## Navigation Flow

### Entry Points

```
App Launch
    ↓
First Time User?
    YES → Screen 1 (Welcome)
    NO  → Screen 6 (Course Home) OR Screen 13 (Simulator)
```

### Main Navigation Tabs

```
┌─────────────────────────────────────────────────────────────┐
│  [Learn] [Discover] [Tools] [Portfolio] [Profile]          │
└─────────────────────────────────────────────────────────────┘
    │        │         │         │           │
    │        │         │         │           │
    ↓        ↓         ↓         ↓           ↓

 Course   Swipe UI   Calc    Simulator   Settings
  Home     Heatmap   Radar    Journey    Referrals
  Video    Alerts    Exit     Portfolio  Leaderboard
  Quiz     Auction
```

---

## User Flow: First Week Journey

### Day 1 (First Session - 15 min)

```
1. Welcome Screen (30 sec)
   ↓
2. Learn-to-Earn Explanation (1 min)
   ↓
3. Pricing Tiers (1 min)
   ↓
4. Permissions (30 sec)
   ↓
5. Ready to Go! (30 sec)
   ↓
6. Course Home (1 min browsing)
   ↓
7. Video Lesson (8 min watch)
   ↓
8. Quiz (2 min)
   ↓
11. Achievement Unlock! 🎉 (30 sec celebration)
```

**Outcome:** User completes Module 1, unlocks Search feature

---

### Day 2 (Exploration - 20 min)

```
6. Course Home
   ↓
13. Portfolio Simulator (15 min playing)
    • Invest virtual $10K
    • Fast-forward to see outcomes
    • Learn what happens with redemption
    ↓
11. Achievement Unlock! (Simulator Master)
```

**Outcome:** User understands tax lien lifecycle

---

### Day 3 (Discovery - 10 min)

```
15. Deal Detective (8 min swiping)
    • Swipe through 50+ properties
    • See AI scores
    • Save 5 properties to watchlist
    ↓
17. Smart Alert creation (2 min)
    • Set criteria: Phoenix, 16%+ ROI, $1K-$5K
```

**Outcome:** User actively browsing properties

---

### Day 4-7 (Engagement)

```
17. Smart Alert notification 🔔
    ↓
15. Deal Detective (view hot property)
    ↓
18. Risk Radar (check risk breakdown)
    ↓
19. Exit Strategy (plan what-if scenarios)
    ↓
9. Paywall (hit free tier limit)
   ↓
10. AI Analysis (see Premium value)
   ↓
CONVERSION → Upgrade to Premium
```

---

## Screen Priorities for Development

### MVP Phase 1 (Weeks 1-4): Portfolio Simulator

```
Build Order:
1. Simulator dashboard UI
2. Virtual balance tracking
3. Property selection flow
4. Time simulation logic
5. Outcome screens (redeemed/foreclosed)
6. Educational overlays

Dependencies:
- Property data API
- Time simulation engine
- Achievement system
```

---

### MVP Phase 2 (Weeks 5-7): Deal Detective

```
Build Order:
1. Swipeable card stack
2. AI scoring integration
3. Gesture handling (left/right/up/down)
4. Filter bottom sheet
5. Session stats tracking
6. Smooth animations (60fps)

Dependencies:
- ML Service API (AI scoring)
- Property images CDN
- Swipe gesture library
```

---

### MVP Phase 3 (Weeks 8-10): Smart Alerts

```
Build Order:
1. Alert creation UI
2. Criteria builder
3. Property matching logic
4. Push notification service
5. Match reasoning display
6. Stats dashboard

Dependencies:
- Firebase Cloud Messaging
- Background job scheduler
- Alert matching algorithm
```

---

## Screen Interconnections

### High Traffic Paths

```
Course Home (Screen 6)
    ↓ 60% of users
Portfolio Simulator (Screen 13)
    ↓ 40% continue to
Deal Detective (Screen 15)
    ↓ 25% convert via
Paywall (Screen 9)
```

### Discovery Paths

```
County Heatmap (Screen 16)
    → Click cluster
    → Bottom sheet with deals
    → Launch Deal Detective (Screen 15)
    → Swipe to Save
    → View Risk Radar (Screen 18)
```

### Learning Paths

```
Video Lesson (Screen 7)
    → Mentions "foreclosure"
    → User taps "Learn More"
    → Exit Strategy Planner (Screen 19)
    → View foreclosure scenarios
    → Back to lesson
```

---

## A/B Testing Opportunities

### Test 1: Simulator Placement

```
Variant A: Simulator in Onboarding (after Screen 5)
Variant B: Simulator in Tab Navigation (standalone)

Hypothesis: Early exposure increases engagement
Metric: Simulator usage rate (target: 60%+)
```

### Test 2: Swipe Direction Mapping

```
Variant A: Right = Save, Left = Pass
Variant B: Right = Buy, Left = Pass, Up = Save

Hypothesis: 3-way swipe increases watchlist usage
Metric: Watchlist save rate
```

### Test 3: Alert Frequency

```
Variant A: Push every match (high volume)
Variant B: Daily digest (1 push/day)

Hypothesis: Daily digest reduces notification fatigue
Metric: Alert click-through rate
```

---

## Screen Dependencies Matrix

| Screen | Requires | Blocks |
|--------|----------|--------|
| **Simulator (#13)** | Property API, Time logic | None |
| **Deal Detective (#15)** | ML API, Images | None |
| **Smart Alerts (#17)** | Firebase, Matching logic | None |
| **Risk Radar (#18)** | ML API (5D analysis) | None |
| **Heatmap (#16)** | Maps API, Geo data | None |
| **Auction Timer (#20)** | Auction API, Calendar | None |
| **Journey Map (#21)** | User progress DB | None |
| **Exit Strategy (#19)** | Property data, ML | None |

**Key insight:** Top 3 screens are independent - can be built in parallel!

---

## Conversion Funnels

### Funnel 1: Free → Premium (via Education)

```
100 users start
    ↓
70 complete Onboarding (70%)
    ↓
45 complete Module 1 (64%)
    ↓
30 hit Paywall (67%)
    ↓
3 convert to Premium (10%)
```

**Optimization:** Increase Module 1 completion (45 → 55)

---

### Funnel 2: Free → Premium (via Simulator)

```
100 users start
    ↓
60 try Simulator (60%)
    ↓
40 complete 5+ simulations (67%)
    ↓
20 browse real properties (50%)
    ↓
6 convert to Premium (30%)
```

**Optimization:** Simulator shows 3x higher conversion! 🎯

---

### Funnel 3: Alerts → Conversion

```
100 users create alert
    ↓
80 receive first match (80%)
    ↓
40 click notification (50%)
    ↓
20 view property details (50%)
    ↓
8 convert to Premium (40%)
```

**Optimization:** Alerts drive retention + conversion

---

## Feature Flag Strategy

### Gradual Rollout Plan

```
Week 1: Enable for 10% of users
    - Monitor: Crash rate, engagement
    - Rollback if: Crash > 1%, Engagement < 5%

Week 2: Enable for 50% of users
    - Monitor: Conversion rate
    - Rollback if: Conversion drops

Week 3: Enable for 100% of users
    - Monitor: All metrics
    - Success: Declare GA (General Availability)
```

---

## Summary

### Total Screens: 18

- **Existing:** 8 screens (Onboarding, Education, Paywall)
- **New:** 10 innovative screens (Simulator, Swipe, Alerts, etc.)

### Top 3 for MVP:

1. 🥇 Portfolio Simulator (4 weeks)
2. 🥈 Deal Detective (3 weeks)
3. 🥉 Smart Alerts (3 weeks)

### Expected Impact:

- **Conversion:** 5% → 10% (+100%)
- **Engagement:** 5 min → 12 min (+140%)
- **Retention:** 40% → 60% Week 1 (+50%)

---

**Status:** READY FOR IMPLEMENTATION ✅

**Next Step:** Approve specifications → Create PLAN phase
