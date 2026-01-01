# Implementation Plan - Mobile App UI/UX

> **Phase:** PLAN
> **Created:** 2025-12-31
> **Status:** DRAFT

---

## Executive Summary

### Scope

**Building:** Top 3 priority screens (MVP)
- 🥇 Portfolio Simulator (4 weeks)
- 🥈 Deal Detective (3 weeks)
- 🥉 Smart Alerts (3 weeks)

**Total Timeline:** 10 weeks

**Team Size:** 2 developers + 1 designer (optional)

**Target Launch:** Week 11 (soft launch), Week 12 (public release)

---

## Project Structure

### Directory Layout (Flutter)

```
lib/
├── main.dart
├── app/
│   ├── app.dart                      # MaterialApp configuration
│   ├── routes.dart                   # Named routes
│   └── theme.dart                    # Theme data (from specs)
├── core/
│   ├── constants/
│   │   ├── colors.dart              # AppColors (from 02-specifications.md)
│   │   ├── typography.dart          # AppTextStyles
│   │   ├── spacing.dart             # AppSpacing (8px grid)
│   │   └── animations.dart          # Duration, Curves
│   ├── utils/
│   │   ├── formatters.dart          # Currency, date formatters
│   │   └── validators.dart          # Input validation
│   └── services/
│       ├── api_service.dart         # HTTP client wrapper
│       ├── ml_service.dart          # ML API integration
│       └── notification_service.dart # Push notifications
├── data/
│   ├── models/
│   │   ├── property.dart            # Property model
│   │   ├── simulation.dart          # Simulation state
│   │   ├── alert.dart               # Alert configuration
│   │   └── ai_prediction.dart       # ML response model
│   ├── repositories/
│   │   ├── property_repository.dart
│   │   ├── simulator_repository.dart
│   │   └── alert_repository.dart
│   └── providers/
│       └── api_provider.dart        # Dio/HTTP provider
├── features/
│   ├── simulator/
│   │   ├── bloc/
│   │   │   ├── simulator_bloc.dart
│   │   │   ├── simulator_event.dart
│   │   │   └── simulator_state.dart
│   │   ├── screens/
│   │   │   ├── simulator_dashboard_screen.dart
│   │   │   ├── property_selection_screen.dart
│   │   │   └── outcome_screen.dart
│   │   └── widgets/
│   │       ├── balance_card.dart
│   │       ├── portfolio_list.dart
│   │       ├── time_controller.dart
│   │       └── educational_tooltip.dart
│   ├── swipe/
│   │   ├── bloc/
│   │   │   ├── swipe_bloc.dart
│   │   │   ├── swipe_event.dart
│   │   │   └── swipe_state.dart
│   │   ├── screens/
│   │   │   └── deal_detective_screen.dart
│   │   └── widgets/
│   │       ├── swipeable_card.dart
│   │       ├── ai_score_badge.dart
│   │       ├── filter_bottom_sheet.dart
│   │       └── session_stats.dart
│   └── alerts/
│       ├── bloc/
│       │   ├── alert_bloc.dart
│       │   ├── alert_event.dart
│       │   └── alert_state.dart
│       ├── screens/
│       │   ├── alert_creation_screen.dart
│       │   └── alert_dashboard_screen.dart
│       └── widgets/
│           ├── criteria_builder.dart
│           ├── match_card.dart
│           └── alert_stats.dart
└── shared/
    └── widgets/
        ├── buttons/
        │   ├── primary_button.dart
        │   ├── secondary_button.dart
        │   └── text_button.dart
        ├── cards/
        │   ├── property_card.dart
        │   └── stat_card.dart
        ├── charts/
        │   ├── radar_chart.dart
        │   └── bar_chart.dart
        ├── progress/
        │   ├── linear_progress.dart
        │   └── circular_progress.dart
        └── badges/
            ├── ai_score_badge.dart
            ├── risk_badge.dart
            └── achievement_badge.dart

test/
├── unit/
│   ├── blocs/
│   ├── repositories/
│   └── models/
├── widget/
│   └── features/
└── integration/
    └── flows/

assets/
├── images/
│   ├── onboarding/
│   ├── properties/
│   └── achievements/
├── icons/
└── animations/
    └── confetti.json         # Lottie animation
```

---

## Phase Breakdown

### Phase 1: Portfolio Simulator (Weeks 1-4)

#### Week 1: Foundation Setup

**Tasks:**
1. ✅ Project structure creation
2. ✅ Core constants setup (colors, typography, spacing)
3. ✅ Data models (Property, Simulation, SimulationEvent)
4. ✅ Repository pattern implementation
5. ✅ SimulatorBloc skeleton
6. ✅ Basic navigation setup

**Deliverables:**
- [ ] Core constants files
- [ ] Data models with tests
- [ ] SimulatorBloc with events/states
- [ ] Repository interfaces

**Dependencies:**
- Property API endpoint (mock data acceptable for Week 1)

---

#### Week 2: UI Components

**Tasks:**
1. ✅ Simulator dashboard screen layout
2. ✅ Balance card widget
3. ✅ Portfolio list widget
4. ✅ Time controller widget (play/pause/fast-forward)
5. ✅ Property selection flow
6. ✅ Shared buttons/cards from component library

**Deliverables:**
- [ ] Simulator dashboard (functional but no time simulation yet)
- [ ] Property selection screen
- [ ] Reusable widgets (button, card components)

**Dependencies:**
- None (can use mock data)

---

#### Week 3: Simulation Logic

**Tasks:**
1. ✅ Time simulation engine
   - Fast-forward logic (skip months/years)
   - Event generation (redemption, interest payments)
   - Outcome calculation (profit/loss)
2. ✅ Educational tooltips
3. ✅ Outcome screens (redemption, foreclosure, complications)
4. ✅ Animation polish (smooth transitions)
5. ✅ Achievement integration (unlock after 5 simulations)

**Deliverables:**
- [ ] Working time simulation
- [ ] Outcome screens with animations
- [ ] Educational overlays
- [ ] Achievement unlock flow

**Dependencies:**
- Achievement system API (can stub initially)

---

#### Week 4: Polish & Testing

**Tasks:**
1. ✅ UI/UX refinements
2. ✅ Unit tests (SimulatorBloc, repositories)
3. ✅ Widget tests (UI components)
4. ✅ Integration test (full simulation flow)
5. ✅ Bug fixes
6. ✅ Performance optimization (60fps target)
7. ✅ Documentation (inline comments)

**Deliverables:**
- [ ] 80%+ test coverage for simulator feature
- [ ] Bug-free simulator ready for QA
- [ ] Performance metrics (frame rate, memory)

**Acceptance Criteria:**
- User can invest virtual $10K
- Time fast-forward works smoothly
- All 3 outcomes (redemption, foreclosure, complications) display correctly
- Educational tooltips appear at right moments
- Achievement unlocks after 5 completed simulations

---

### Phase 2: Deal Detective (Weeks 5-7)

#### Week 5: Swipe Mechanics

**Tasks:**
1. ✅ Swipeable card stack widget
2. ✅ Gesture detection (left/right/up/down)
3. ✅ Card animations (drag, rotate, snap)
4. ✅ SwipeBloc setup
5. ✅ Property image loading (CDN integration)
6. ✅ AI score badge display

**Deliverables:**
- [ ] Working card stack with swipe gestures
- [ ] Smooth 60fps animations
- [ ] AI score integration

**Dependencies:**
- ML Service API for AI scoring
- Property images CDN

---

#### Week 6: Filters & Stats

**Tasks:**
1. ✅ Filter bottom sheet UI
2. ✅ Filter criteria (location, ROI, price range)
3. ✅ Session stats tracking (swipes, saves)
4. ✅ Watchlist integration
5. ✅ Property detail view (tap to expand)
6. ✅ Undo last swipe functionality

**Deliverables:**
- [ ] Fully functional filter system
- [ ] Session statistics display
- [ ] Watchlist save/view flow

**Dependencies:**
- Watchlist API endpoint

---

#### Week 7: Polish & Testing

**Tasks:**
1. ✅ UI refinements (card design, animations)
2. ✅ Unit tests (SwipeBloc, filter logic)
3. ✅ Widget tests (swipeable cards)
4. ✅ Integration test (full swipe session)
5. ✅ Performance testing (large property sets)
6. ✅ Bug fixes

**Deliverables:**
- [ ] 80%+ test coverage
- [ ] Smooth swipe experience (no jank)
- [ ] Ready for QA

**Acceptance Criteria:**
- User can swipe through 100+ properties without lag
- All 4 swipe directions work correctly
- Filters narrow down results accurately
- Session stats update in real-time
- AI scores display with reasoning

---

### Phase 3: Smart Alerts (Weeks 8-10)

#### Week 8: Alert Creation

**Tasks:**
1. ✅ Alert creation UI
2. ✅ Criteria builder widget (location, ROI, budget)
3. ✅ AlertBloc setup
4. ✅ Alert storage (local + cloud sync)
5. ✅ Alert dashboard screen
6. ✅ Edit/delete alert functionality

**Deliverables:**
- [ ] Alert creation flow
- [ ] Criteria builder (multi-criteria support)
- [ ] Alert management dashboard

**Dependencies:**
- Alert API endpoints (create, update, delete)

---

#### Week 9: Notifications & Matching

**Tasks:**
1. ✅ Firebase Cloud Messaging integration
2. ✅ Push notification handling
3. ✅ Property matching algorithm (client-side logic)
4. ✅ Match reasoning display ("Why it matches")
5. ✅ Alert stats (matches sent, clicks)
6. ✅ Background job setup (alert checking)

**Deliverables:**
- [ ] Push notifications working (iOS + Android)
- [ ] Match reasoning explanations
- [ ] Alert stats tracking

**Dependencies:**
- Firebase project setup
- Background job scheduler (WorkManager for Android, BGTaskScheduler for iOS)

---

#### Week 10: Polish & Testing

**Tasks:**
1. ✅ UI refinements (notification UI, match cards)
2. ✅ Unit tests (AlertBloc, matching logic)
3. ✅ Widget tests (criteria builder)
4. ✅ Integration test (create alert → receive notification)
5. ✅ Push notification testing (both platforms)
6. ✅ Bug fixes

**Deliverables:**
- [ ] 80%+ test coverage
- [ ] Notifications working reliably
- [ ] Ready for QA

**Acceptance Criteria:**
- User can create alert with multiple criteria
- Push notifications arrive within 5 min of match
- Match reasoning is clear and accurate
- User can view all active alerts
- Stats show match performance

---

## Week 11: Integration & QA

**Tasks:**
1. ✅ Integrate all 3 features
2. ✅ End-to-end testing (full user journey)
3. ✅ Performance testing (memory, battery, network)
4. ✅ Accessibility audit (VoiceOver, TalkBack)
5. ✅ Bug bash (team-wide testing)
6. ✅ Analytics implementation (Firebase Analytics)
7. ✅ Crash reporting (Firebase Crashlytics)

**Deliverables:**
- [ ] All 3 features working together seamlessly
- [ ] No critical bugs
- [ ] Performance benchmarks met
- [ ] Analytics tracking all key events

**QA Checklist:**
- [ ] Simulator → Swipe flow works
- [ ] Swipe → Alert creation flow works
- [ ] Alert notification → Property view flow works
- [ ] No memory leaks (tested with Dart DevTools)
- [ ] 60fps maintained on mid-range devices
- [ ] Accessible (screen reader compatible)

---

## Week 12: Launch Prep & Soft Launch

**Tasks:**
1. ✅ App Store assets (screenshots, description)
2. ✅ Beta testing (TestFlight + Firebase App Distribution)
3. ✅ Feature flags setup (gradual rollout)
4. ✅ Monitoring dashboards (Firebase Console)
5. ✅ Final bug fixes
6. ✅ Soft launch (10% of users)
7. ✅ Monitor metrics (crash rate, engagement)

**Deliverables:**
- [ ] App submitted to App Store + Play Store
- [ ] Beta testers recruited (20-50 users)
- [ ] Feature flags configured
- [ ] Monitoring alerts set up

**Launch Criteria:**
- Crash-free rate > 99%
- App Store rating > 4.5 (from beta)
- No critical bugs reported
- Performance metrics acceptable

---

## Task Breakdown (Detailed)

### Task List (73 tasks total)

#### Foundation (8 tasks)
1. Create Flutter project structure
2. Set up core constants (colors, typography, spacing)
3. Create Property model
4. Create Simulation model
5. Create AIPrediction model
6. Create Alert model
7. Set up named routes
8. Create AppTheme configuration

#### Portfolio Simulator (18 tasks)
9. Create SimulatorBloc skeleton
10. Implement SimulatorEvent classes
11. Implement SimulatorState classes
12. Create SimulatorRepository
13. Build simulator dashboard screen layout
14. Create BalanceCard widget
15. Create PortfolioList widget
16. Create TimeController widget
17. Build property selection screen
18. Implement time simulation engine
19. Create redemption outcome screen
20. Create foreclosure outcome screen
21. Create complication outcome screen
22. Add educational tooltips
23. Implement achievement unlock flow
24. Write unit tests for SimulatorBloc
25. Write widget tests for simulator components
26. Write integration test for full simulation flow

#### Deal Detective (20 tasks)
27. Create SwipeBloc skeleton
28. Implement SwipeEvent classes
29. Implement SwipeState classes
30. Create SwipeRepository
31. Build swipeable card stack widget
32. Implement gesture detection (4 directions)
33. Add card drag animation
34. Add card rotate animation
35. Add card snap animation
36. Create AIScoreBadge widget
37. Integrate property image CDN
38. Build filter bottom sheet
39. Implement filter logic (location, ROI, price)
40. Create session stats widget
41. Add watchlist save functionality
42. Build property detail expansion view
43. Implement undo last swipe
44. Write unit tests for SwipeBloc
45. Write widget tests for swipeable cards
46. Write integration test for swipe session

#### Smart Alerts (22 tasks)
47. Create AlertBloc skeleton
48. Implement AlertEvent classes
49. Implement AlertState classes
50. Create AlertRepository
51. Build alert creation screen
52. Create CriteriaBuilder widget
53. Implement multi-criteria support
54. Build alert dashboard screen
55. Add edit alert functionality
56. Add delete alert functionality
57. Set up Firebase Cloud Messaging
58. Implement push notification handler (iOS)
59. Implement push notification handler (Android)
60. Create property matching algorithm
61. Build match reasoning display
62. Create alert stats widget
63. Set up background job scheduler (Android)
64. Set up background task scheduler (iOS)
65. Write unit tests for AlertBloc
66. Write unit tests for matching logic
67. Write widget tests for criteria builder
68. Write integration test for alert flow

#### Integration & QA (5 tasks)
69. End-to-end integration testing
70. Performance testing (memory, battery, network)
71. Accessibility audit
72. Analytics implementation
73. Crash reporting setup

---

## Team Assignments

### Developer 1 (Backend Focus)
**Weeks 1-4:** Portfolio Simulator
- Time simulation engine
- Repository pattern
- SimulatorBloc
- API integration (mock → real)

**Weeks 5-7:** Deal Detective
- SwipeBloc
- ML Service integration
- Image CDN integration
- Watchlist API

**Weeks 8-10:** Smart Alerts
- AlertBloc
- Firebase Cloud Messaging
- Background jobs
- Matching algorithm

### Developer 2 (UI Focus)
**Weeks 1-4:** Portfolio Simulator
- UI components (dashboard, cards, widgets)
- Animations (transitions, tooltips)
- Educational overlays
- Achievement UI

**Weeks 5-7:** Deal Detective
- Swipeable card stack
- Gesture animations
- Filter UI
- Session stats UI

**Weeks 8-10:** Smart Alerts
- Alert creation UI
- Criteria builder
- Notification UI
- Alert dashboard

### Designer (Optional, Part-time)
**Weeks 1-12:** Visual Design Support
- Review UI implementations
- Create asset files (icons, illustrations)
- Design App Store screenshots
- Provide design QA feedback

---

## Testing Strategy

### Unit Tests (Target: 80% coverage)

**Test all BLoCs:**
- SimulatorBloc (events → states)
- SwipeBloc (events → states)
- AlertBloc (events → states)

**Test all repositories:**
- Mock API responses
- Test error handling
- Test data transformations

**Test utilities:**
- Formatters (currency, dates)
- Validators (input validation)

### Widget Tests

**Test all custom widgets:**
- BalanceCard rendering
- PortfolioList item display
- SwipeableCard gestures
- CriteriaBuilder interactions
- All shared components (buttons, badges, charts)

### Integration Tests

**Test critical flows:**
1. Simulator flow: Dashboard → Select property → Fast-forward → See outcome
2. Swipe flow: Open Deal Detective → Swipe 10 properties → View watchlist
3. Alert flow: Create alert → Receive notification → View match

**Tools:**
- `flutter_test` for unit/widget tests
- `integration_test` for E2E flows
- `mockito` for mocking dependencies

---

## API Requirements

### ML Service API

**Endpoint:** `POST /api/v1/ml/score-property`

**Request:**
```json
{
  "property_id": "TX-12345",
  "features": {
    "lien_amount": 2500,
    "interest_rate": 0.18,
    "property_value": 85000,
    "county": "Maricopa",
    "lien_position": "1st"
  }
}
```

**Response:**
```json
{
  "score": 8.7,
  "reasoning": [
    "High interest rate (18%)",
    "1st position lien (priority)",
    "Strong property value ratio"
  ],
  "risk_factors": {
    "legal": 2,
    "financial": 1,
    "property": 3,
    "market": 2,
    "neighborhood": 1
  }
}
```

---

### Alert Matching API

**Endpoint:** `POST /api/v1/alerts/match`

**Request:**
```json
{
  "alert_id": "alert-abc123",
  "criteria": {
    "locations": ["Phoenix", "Scottsdale"],
    "min_roi": 0.16,
    "max_price": 5000
  }
}
```

**Response:**
```json
{
  "matches": [
    {
      "property_id": "AZ-67890",
      "match_score": 0.92,
      "reasoning": "18% ROI (exceeds 16%), $3,200 price (within budget), Phoenix location"
    }
  ]
}
```

---

### Simulation Engine API

**Endpoint:** `POST /api/v1/simulator/fast-forward`

**Request:**
```json
{
  "simulation_id": "sim-xyz789",
  "months_forward": 24,
  "current_portfolio": [
    {
      "property_id": "TX-12345",
      "invested": 2500,
      "purchase_date": "2024-01-15"
    }
  ]
}
```

**Response:**
```json
{
  "events": [
    {
      "date": "2024-07-15",
      "type": "interest_payment",
      "amount": 225
    },
    {
      "date": "2026-01-15",
      "type": "redemption",
      "amount": 3600,
      "profit": 1100
    }
  ],
  "final_balance": 11100,
  "total_profit": 1100
}
```

---

## Dependencies

### Flutter Packages

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

  # Networking
  dio: ^5.3.3
  retrofit: ^4.0.3

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Firebase
  firebase_core: ^2.20.0
  firebase_analytics: ^10.7.0
  firebase_crashlytics: ^3.4.3
  firebase_messaging: ^14.7.3

  # UI Components
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^2.7.0

  # Charts
  fl_chart: ^0.65.0

  # Utilities
  intl: ^0.18.1
  url_launcher: ^6.2.1
  share_plus: ^7.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Testing
  mockito: ^5.4.2
  build_runner: ^2.4.6
  integration_test:
    sdk: flutter

  # Code Quality
  flutter_lints: ^3.0.1
```

---

## Risk Mitigation

### Technical Risks

**Risk 1: ML API Latency**
- **Impact:** Slow swipe experience if AI scoring takes >1s
- **Mitigation:** Pre-cache scores for next 20 properties
- **Fallback:** Show placeholder score while loading

**Risk 2: Push Notification Reliability**
- **Impact:** Users miss deal alerts
- **Mitigation:** Implement retry logic + in-app notification center
- **Fallback:** Daily digest email

**Risk 3: Animation Performance**
- **Impact:** Jank on older devices
- **Mitigation:** Profile on mid-range devices (iPhone 11, Pixel 5)
- **Fallback:** Reduce animation complexity on low-end devices

**Risk 4: Time Simulation Accuracy**
- **Impact:** Unrealistic outcomes hurt user trust
- **Mitigation:** Use real historical data for probabilities
- **Fallback:** Clearly label as "simulation, not guarantee"

### Business Risks

**Risk 5: Low Adoption**
- **Impact:** Features unused despite effort
- **Mitigation:** A/B test placement (onboarding vs tab)
- **Tracking:** Monitor adoption rate weekly

**Risk 6: Poor Conversion**
- **Impact:** Features don't drive Premium upgrades
- **Mitigation:** Add paywalls at strategic points
- **Tracking:** Conversion funnel analysis

---

## Success Metrics

### Week 4 (Simulator Launch)
- [ ] 60% of new users try simulator
- [ ] Average 3+ simulations per user
- [ ] 80% completion rate (users finish simulation)
- [ ] 4.5+ rating in beta feedback

### Week 7 (Swipe Launch)
- [ ] 40% daily active users use Deal Detective
- [ ] Average 25+ properties swiped per session
- [ ] 15% watchlist save rate
- [ ] 10+ min session duration

### Week 10 (Alerts Launch)
- [ ] 40% of users create at least 1 alert
- [ ] 50% notification click-through rate
- [ ] 80% Week 1 retention (for alert users)
- [ ] 10% Free → Premium conversion (from alerts)

### Week 12 (Full MVP)
- [ ] 99%+ crash-free rate
- [ ] 4.5+ App Store rating
- [ ] 12 min average session duration
- [ ] 60% Week 1 retention
- [ ] 10% Free → Premium conversion (overall)

---

## Launch Checklist

### Pre-Launch (Week 11)
- [ ] All features code complete
- [ ] 80%+ test coverage achieved
- [ ] No critical bugs in backlog
- [ ] Performance benchmarks met (60fps, <100MB memory)
- [ ] Accessibility audit passed
- [ ] Analytics events implemented
- [ ] Crash reporting configured
- [ ] App Store assets prepared (screenshots, description)
- [ ] Privacy policy updated
- [ ] Terms of service reviewed

### Soft Launch (Week 12, Day 1-3)
- [ ] Deploy to 10% of users via feature flag
- [ ] Monitor crash rate (target: <1%)
- [ ] Monitor engagement (target: 5+ min session)
- [ ] Check push notification delivery rate (target: >95%)
- [ ] Review user feedback (in-app + App Store reviews)

### Full Launch (Week 12, Day 4-7)
- [ ] Increase to 50% of users (if metrics healthy)
- [ ] Monitor conversion funnel
- [ ] Address any urgent bugs
- [ ] Increase to 100% of users (if stable)
- [ ] Announce new features (email, in-app)
- [ ] Update App Store listing

---

## Post-Launch (Week 13+)

### Immediate Follow-Up
1. **Week 13:** Bug fixes from user feedback
2. **Week 14:** A/B test variations (swipe directions, simulator placement)
3. **Week 15:** Iterate based on analytics (optimize low-performing flows)

### Future Enhancements (P1 Priority)
- Risk Radar (Week 16-17)
- Exit Strategy Planner (Week 18-19)
- County Heatmap (Week 20-22)

### Backlog (P2 Priority)
- Auction Timer
- Journey Map
- Leaderboard
- ROI Calculator Live

---

## Budget Estimate

### Personnel (10 weeks)
- **Developer 1:** 10 weeks × 40 hrs = 400 hrs
- **Developer 2:** 10 weeks × 40 hrs = 400 hrs
- **Designer (optional):** 10 weeks × 10 hrs = 100 hrs

**Total:** 900 hours

### Infrastructure
- Firebase (Blaze plan): ~$50/month
- ML API hosting: ~$100/month
- CDN (images): ~$30/month

**Total:** ~$180/month

### One-Time Costs
- App Store fee: $99/year
- Play Store fee: $25 one-time
- Design assets (if outsourced): ~$500

---

## Conclusion

This plan provides a detailed roadmap for implementing the Top 3 priority screens over 10 weeks. Key success factors:

1. ✅ **Clear task breakdown** (73 tasks)
2. ✅ **Realistic timeline** (4+3+3 weeks)
3. ✅ **Defined responsibilities** (2 developers)
4. ✅ **Testing strategy** (80% coverage)
5. ✅ **Risk mitigation** (5 technical risks identified)
6. ✅ **Success metrics** (measurable KPIs)

**Next Step:** Begin Week 1 tasks (foundation setup)

**Status:** PLAN DRAFT COMPLETE ✅

---

**Awaiting Approval to Move to IMPLEMENTATION Phase**
