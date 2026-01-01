# Implementation Plan: sdd-mobile-app-ui (MVP Scope)

**Project:** TAXLIEN.online Mobile App UI Enhancement
**Phase:** PLAN (MVP Reduced Scope)
**Date:** 2026-01-01
**Version:** 2.0 (Scope Reduction: 18 → 3 Screens)

---

## Executive Summary

**Original Scope:** 18 innovative screens (10-week timeline) ❌ TOO AMBITIOUS
**MVP Scope:** 3 priority screens (10-week timeline) ✅ REALISTIC

**Rationale for Reduction:**
- Focus on highest-impact features (Pareto 80/20 rule)
- Faster time-to-market = earlier revenue validation
- Reduce technical debt and complexity
- Learn from user feedback before expanding

**Top 3 Screens (P0 Priority):**
1. 🥇 **Portfolio Simulator** - Risk-free learning (Weeks 5-8)
2. 🥈 **Deal Detective** - Swipe UI engagement (Weeks 9-11)
3. 🥉 **Smart Alerts** - Retention driver (Weeks 12-14)

**Deferred to Post-MVP:** 15 other screens (build after validation)

---

## MVP Success Criteria

### Business Metrics
- **Conversion Rate:** Free → Paid from 5% → 10% (+100%)
- **Engagement:** DAU/MAU from 0.15 → 0.30 (+100%)
- **Session Duration:** 3min → 8min (+167%)
- **Retention:** D7 from 20% → 35% (+75%)

### Technical Metrics
- **Test Coverage:** 80%+ on critical paths
- **Crash-Free Rate:** 99.5%+
- **API Response Time:** <200ms p95
- **App Size:** <50MB (avoid bloat)

### User Metrics
- **Simulator:** 70% of free users try it
- **Swipe:** 500+ swipes per user per week
- **Alerts:** 80% of paid users enable them

---

## Screen 1: Portfolio Simulator (Weeks 5-8)

### Overview
**What:** Virtual investment practice mode with $100K fake capital
**Why:** Risk-free learning builds trust and drives conversion
**Target:** Free users → trial users (unlock premium features)

### User Flow
```
Landing → Create Portfolio → Browse Properties → Simulate Purchase
→ Time Acceleration → View Outcomes → Leaderboard → Upgrade Prompt
```

### Component Breakdown (23 Tasks)

#### Week 5: Foundation (5 tasks)
1. **Setup Project Structure**
   - Create `lib/features/portfolio_simulator/` directory
   - Add routing in `app_router.dart`
   - Create constants in `simulator_constants.dart`
   - Set up Riverpod providers
   - **Files:** 4 new files
   - **Complexity:** Low (4 hours)

2. **Data Models**
   - `SimulatedPortfolio` model (id, name, capital, positions)
   - `SimulatedPosition` model (property, purchase_price, status)
   - `SimulationOutcome` model (redemption_status, profit, timeline)
   - JSON serialization (freezed + json_serializable)
   - **Files:** 3 new files
   - **Complexity:** Low (6 hours)

3. **Local Storage (Hive)**
   - Portfolio persistence (save/load)
   - Position history tracking
   - Leaderboard cache
   - Migration logic (future-proofing)
   - **Files:** 2 new files
   - **Complexity:** Medium (8 hours)

4. **Simulator Dashboard UI**
   - Portfolio list screen (grid view)
   - Create new portfolio dialog
   - Portfolio card widget (capital, ROI, position count)
   - Empty state (first-time user)
   - **Files:** 4 new files
   - **Complexity:** Medium (10 hours)

5. **Navigation & State**
   - Portfolio selection state (Riverpod)
   - Active portfolio provider
   - Navigation to property browse
   - Bottom navigation integration
   - **Files:** 2 new files
   - **Complexity:** Low (4 hours)

**Week 5 Total:** 32 hours (4 days)

---

#### Week 6: Core Simulation (6 tasks)
6. **Property Browse (Simulated)**
   - Reuse existing search UI (filter: "simulator mode")
   - Add "Simulate Purchase" button
   - Show simulated price (±10% random variance)
   - Disable real purchase options
   - **Files:** 2 modified, 1 new
   - **Complexity:** Low (6 hours)

7. **Purchase Simulation Logic**
   - Deduct capital on "purchase"
   - Create SimulatedPosition
   - Validate sufficient funds
   - Transaction animation (confetti)
   - **Files:** 3 new files
   - **Complexity:** Medium (8 hours)

8. **Time Acceleration Engine**
   - Background timer (1 real hour = 1 simulated week)
   - Simulation state machine (purchased → auction → outcome)
   - Outcome calculation (redemption probability from real data)
   - Notification triggers (outcome ready)
   - **Files:** 2 new files
   - **Complexity:** High (12 hours)

9. **Outcome Generation (ML-based)**
   - API call to ML service (`/simulate/outcome`)
   - Fallback: Rule-based (historical county averages)
   - Randomness layer (realistic variance)
   - Outcome types: redeemed, foreclosed, partial_payment
   - **Files:** 2 new files (service + model)
   - **Complexity:** High (10 hours)

10. **Portfolio Detail Screen**
    - Position list (active, completed, failed)
    - Performance chart (capital over time)
    - Stats cards (ROI, win rate, avg profit)
    - Position detail modal
    - **Files:** 5 new files
    - **Complexity:** Medium (10 hours)

11. **Outcome Reveal UI**
    - Modal with animation (success/failure)
    - Profit/loss calculation display
    - Lesson learned callout (educational)
    - "Try Again" vs "Upgrade" CTA
    - **Files:** 3 new files
    - **Complexity:** Medium (8 hours)

**Week 6 Total:** 54 hours (6.75 days) → **REDUCE to 40 hours**
- Cut: Advanced animations, focus on core flow

---

#### Week 7: Gamification (6 tasks)
12. **Leaderboard Backend Integration**
    - API endpoint: `GET /simulator/leaderboard?period=weekly`
    - Submit score: `POST /simulator/score` (ROI, portfolio value)
    - Authentication (Firebase token)
    - Rate limiting (prevent cheating)
    - **Files:** 1 service file, 1 provider
    - **Complexity:** Medium (8 hours)

13. **Leaderboard UI**
    - Top 10 global (weekly, all-time)
    - User rank display ("You're #42")
    - Avatar + username + score
    - Refresh logic (pull-to-refresh)
    - **Files:** 3 new files
    - **Complexity:** Medium (8 hours)

14. **Achievements System**
    - 10 achievements (first purchase, 10x ROI, 100 positions, etc.)
    - Badge icons (asset bundle)
    - Achievement unlock modal
    - Progress tracking (Hive storage)
    - **Files:** 4 new files
    - **Complexity:** Medium (10 hours)

15. **Tutorial/Onboarding**
    - First-time user walkthrough (3 steps)
    - Tooltips for key features
    - Sample portfolio (pre-filled demo)
    - Skip option (don't force)
    - **Files:** 2 new files
    - **Complexity:** Low (6 hours)

16. **Settings & Preferences**
    - Simulation speed (1x, 2x, 4x)
    - Notifications on/off
    - Reset portfolio (confirm dialog)
    - Export data (CSV of positions)
    - **Files:** 2 new files
    - **Complexity:** Low (6 hours)

17. **Paywall Integration**
    - Free limits: 1 portfolio, 5 positions max
    - Upgrade prompt on limit reached
    - Premium unlocks: unlimited portfolios, advanced stats
    - A/B test: prompt timing (immediate vs after 3 positions)
    - **Files:** 2 modified (add limits)
    - **Complexity:** Low (4 hours)

**Week 7 Total:** 42 hours (5.25 days)

---

#### Week 8: Polish & Testing (6 tasks)
18. **Error Handling**
    - Offline mode (cached data only)
    - API failure graceful degradation
    - Invalid state recovery
    - User-friendly error messages
    - **Files:** 1 service (error handler)
    - **Complexity:** Medium (8 hours)

19. **Performance Optimization**
    - List virtualization (large portfolios)
    - Image caching (property photos)
    - Debounce API calls
    - Reduce widget rebuilds (const constructors)
    - **Files:** Modify 5-6 files
    - **Complexity:** Medium (8 hours)

20. **Unit Tests**
    - Data models (serialization)
    - Simulation logic (outcome calculation)
    - State management (provider tests)
    - Coverage: 80%+ on core logic
    - **Files:** 10 test files
    - **Complexity:** High (12 hours)

21. **Widget Tests**
    - Dashboard screen (portfolio list)
    - Purchase flow (tap button → success)
    - Leaderboard UI (render top 10)
    - Coverage: Key user paths
    - **Files:** 5 test files
    - **Complexity:** Medium (10 hours)

22. **Integration Tests**
    - End-to-end: Create portfolio → Purchase → Outcome
    - API mocking (http_mock_adapter)
    - Golden tests (screenshot comparison)
    - Coverage: Happy path + 2 error cases
    - **Files:** 3 test files
    - **Complexity:** High (10 hours)

23. **Bug Fixes & QA**
    - Manual testing on iOS + Android
    - Fix issues from test results
    - Code review feedback
    - Final polish (animations, colors)
    - **Files:** TBD (based on bugs)
    - **Complexity:** Medium (12 hours)

**Week 8 Total:** 60 hours (7.5 days) → **REDUCE to 48 hours**
- Parallel testing (dev continues while QA tests)

---

### Screen 1 Total Estimate
- **Tasks:** 23
- **Hours:** 162 hours (reduced from 174)
- **Duration:** 4 weeks (Weeks 5-8)
- **Team:** 2 developers (parallel work on UI + logic)

---

## Screen 2: Deal Detective (Weeks 9-11)

### Overview
**What:** Tinder-style swipe UI for property discovery
**Why:** Engagement driver + ML training data (user preferences)
**Target:** All users (free + paid, but paid = unlimited swipes)

### User Flow
```
Open Detective → See Property Card → Swipe Right (like) / Left (pass)
→ Match Notification → Add to Portfolio → Share Deal
```

### Component Breakdown (17 Tasks)

#### Week 9: Swipe Mechanics (6 tasks)
24. **Setup Structure**
    - `lib/features/deal_detective/` directory
    - Routing, constants, providers
    - **Files:** 3 new
    - **Complexity:** Low (3 hours)

25. **Property Card UI**
    - Full-screen card (photo, price, ROI badge)
    - Overlay info (address, county, details)
    - Gradient background, shadows
    - Reusable widget (for stacking)
    - **Files:** 2 new
    - **Complexity:** Medium (8 hours)

26. **Swipe Gesture Logic**
    - Drag detector (horizontal swipe)
    - Rotation & translation animation
    - Threshold detection (>50% = action)
    - Snap back on insufficient swipe
    - **Files:** 2 new (gesture handler, animation controller)
    - **Complexity:** High (12 hours)

27. **Card Stack Management**
    - Load 10 properties ahead (prefetch)
    - Remove swiped cards from stack
    - Infinite scroll (load more)
    - Empty state (no more properties)
    - **Files:** 2 new (state manager, API service)
    - **Complexity:** Medium (8 hours)

28. **Swipe Actions Backend**
    - API: `POST /detective/swipe` (property_id, direction: left/right)
    - Store user preferences (ML training data)
    - Anonymized analytics (swipe patterns)
    - **Files:** 1 service
    - **Complexity:** Low (4 hours)

29. **Undo Feature**
    - Undo button (bottom-left)
    - Restore last swiped card (stack top)
    - Limit: 3 undos (free), unlimited (paid)
    - Animation (card flies back)
    - **Files:** 1 modified (gesture handler)
    - **Complexity:** Medium (6 hours)

**Week 9 Total:** 41 hours (5 days)

---

#### Week 10: Matching & Social (6 tasks)
30. **Match Algorithm**
    - Definition: User likes + Property meets criteria
    - Criteria: ROI > threshold, risk < threshold
    - Personalized scoring (ML preferences)
    - Match probability badge (before swipe)
    - **Files:** 2 new (algorithm, model)
    - **Complexity:** High (10 hours)

31. **Match Notification**
    - Push notification ("You matched with a property!")
    - In-app banner (confetti animation)
    - Deep link to property detail
    - Match list screen (history)
    - **Files:** 3 new
    - **Complexity:** Medium (8 hours)

32. **Share Feature**
    - Share button on property card
    - Generate share image (property photo + stats)
    - Social platforms: SMS, Email, Twitter, WhatsApp
    - Referral tracking (UTM params)
    - **Files:** 2 new (share service, image generator)
    - **Complexity:** Medium (8 hours)

33. **Filters & Preferences**
    - Settings screen (county, price range, ROI min)
    - Apply filters to card stack
    - Save preferences (Hive)
    - Reset to defaults
    - **Files:** 2 new
    - **Complexity:** Low (6 hours)

34. **Daily Limit (Free Users)**
    - Limit: 50 swipes/day (free), unlimited (paid)
    - Counter display (top-right, "42/50 left")
    - Paywall on limit reached
    - Reset at midnight (timezone-aware)
    - **Files:** 1 modified (swipe handler)
    - **Complexity:** Low (4 hours)

35. **Onboarding Flow**
    - First-time tutorial (3 cards)
    - Sample properties (always likable)
    - Guide arrows ("Swipe right to like")
    - Skip option
    - **Files:** 1 new
    - **Complexity:** Low (4 hours)

**Week 10 Total:** 40 hours (5 days)

---

#### Week 11: Polish & Testing (5 tasks)
36. **Error Handling**
    - Offline mode (show cached cards)
    - API failure (retry or skip)
    - Empty stack (graceful message)
    - **Files:** 1 service
    - **Complexity:** Low (4 hours)

37. **Performance**
    - Image preloading (next 3 cards)
    - Animation optimization (60fps)
    - Memory management (dispose controllers)
    - **Files:** Modify 3-4 files
    - **Complexity:** Medium (6 hours)

38. **Testing (Unit + Widget)**
    - Swipe gesture tests
    - Match algorithm tests
    - State management tests
    - Coverage: 75%+
    - **Files:** 8 test files
    - **Complexity:** High (16 hours)

39. **Integration Testing**
    - End-to-end: Swipe → Match → Add to portfolio
    - API mocking
    - Golden tests (card rendering)
    - **Files:** 2 test files
    - **Complexity:** Medium (8 hours)

40. **Bug Fixes & QA**
    - Manual testing (iOS + Android)
    - Fix animation glitches
    - Code review
    - Final polish
    - **Files:** TBD
    - **Complexity:** Medium (10 hours)

**Week 11 Total:** 44 hours (5.5 days)

---

### Screen 2 Total Estimate
- **Tasks:** 17
- **Hours:** 125 hours
- **Duration:** 3 weeks (Weeks 9-11)
- **Team:** 2 developers

---

## Screen 3: Smart Alerts (Weeks 12-14)

### Overview
**What:** AI-powered deal notifications with custom rules
**Why:** Retention driver (bring users back daily)
**Target:** Paid users only (premium feature)

### User Flow
```
Enable Alerts → Set Criteria → Receive Push Notification
→ Open App → View Deal → Add to Portfolio
```

### Component Breakdown (15 Tasks)

#### Week 12: Alert Setup (5 tasks)
41. **Setup Structure**
    - `lib/features/smart_alerts/` directory
    - Routing, constants, providers
    - **Files:** 3 new
    - **Complexity:** Low (3 hours)

42. **Alert Creation UI**
    - Form screen (county, price range, ROI min, risk max)
    - Frequency selector (instant, daily, weekly)
    - Alert name input
    - Save button
    - **Files:** 3 new
    - **Complexity:** Medium (8 hours)

43. **Alert Rule Storage**
    - Firestore collection: `users/{uid}/alerts`
    - Fields: name, criteria, frequency, enabled
    - CRUD operations (create, read, update, delete)
    - Sync with backend
    - **Files:** 2 new (model, service)
    - **Complexity:** Medium (8 hours)

44. **Alert List Screen**
    - List of active alerts (card view)
    - Toggle enabled/disabled
    - Edit/delete actions
    - Empty state (no alerts yet)
    - **Files:** 2 new
    - **Complexity:** Low (6 hours)

45. **Push Notification Setup**
    - Firebase Cloud Messaging (FCM)
    - Request permission (iOS + Android)
    - Token registration (store in Firestore)
    - Notification tap handler (deep link)
    - **Files:** 2 new (FCM service, handler)
    - **Complexity:** Medium (8 hours)

**Week 12 Total:** 33 hours (4 days)

---

#### Week 13: Backend Integration (5 tasks)
46. **Alert Matching Service (Backend)**
    - Cloud Function: `onPropertyCreate` trigger
    - Match properties against user alerts
    - Personalized scoring (ML preferences)
    - Send push notification via FCM
    - **Files:** 1 backend file (Cloud Function)
    - **Complexity:** High (12 hours)

47. **Alert Performance Tracking**
    - Track: alert sent → user opened → action taken
    - Metrics: CTR, conversion rate
    - Display in alert detail screen
    - Dashboard for user ("This alert found 12 deals")
    - **Files:** 3 new (analytics, model, UI)
    - **Complexity:** Medium (10 hours)

48. **Smart Suggestions (ML)**
    - API: `GET /alerts/suggestions` (based on user history)
    - Suggest alert criteria (auto-fill form)
    - "Properties like this one" feature
    - A/B test: manual vs suggested alerts
    - **Files:** 2 new (API service, UI)
    - **Complexity:** High (10 hours)

49. **Notification Customization**
    - Settings: enable/disable by frequency
    - Quiet hours (no notifications 10pm-8am)
    - Sound selection (iOS/Android)
    - Notification preview (test alert)
    - **Files:** 2 new
    - **Complexity:** Low (6 hours)

50. **Alert History**
    - Log all sent alerts (Firestore subcollection)
    - View past notifications
    - Re-open property from history
    - Mark as "seen" or "dismissed"
    - **Files:** 2 new
    - **Complexity:** Low (6 hours)

**Week 13 Total:** 44 hours (5.5 days)

---

#### Week 14: Polish & Testing (5 tasks)
51. **Error Handling**
    - Permission denied (guide user to settings)
    - API failure (retry logic)
    - Invalid criteria (validation)
    - **Files:** 1 service
    - **Complexity:** Low (4 hours)

52. **Performance**
    - Background sync (fetch alerts efficiently)
    - Notification batching (avoid spam)
    - Memory optimization
    - **Files:** Modify 2-3 files
    - **Complexity:** Medium (6 hours)

53. **Testing (Unit + Widget)**
    - Alert matching logic tests
    - FCM service tests
    - State management tests
    - Coverage: 80%+
    - **Files:** 7 test files
    - **Complexity:** High (14 hours)

54. **Integration Testing**
    - End-to-end: Create alert → Trigger → Receive notification
    - Mock FCM
    - Firestore emulator
    - **Files:** 2 test files
    - **Complexity:** High (10 hours)

55. **Bug Fixes & QA**
    - Manual testing (iOS + Android)
    - Test notification delivery
    - Code review
    - Final polish
    - **Files:** TBD
    - **Complexity:** Medium (10 hours)

**Week 14 Total:** 44 hours (5.5 days)

---

### Screen 3 Total Estimate
- **Tasks:** 15
- **Hours:** 121 hours
- **Duration:** 3 weeks (Weeks 12-14)
- **Team:** 1 developer + 1 backend (FCM setup)

---

## Grand Total (MVP)

| Screen | Tasks | Hours | Duration | Team |
|--------|-------|-------|----------|------|
| Portfolio Simulator | 23 | 162 | 4 weeks | 2 devs |
| Deal Detective | 17 | 125 | 3 weeks | 2 devs |
| Smart Alerts | 15 | 121 | 3 weeks | 1 dev + 1 backend |
| **TOTAL** | **55** | **408** | **10 weeks** | **2 devs** |

**Developer Weeks:** 408 hours ÷ 40 hours/week = **10.2 weeks** (with 2 developers)

---

## Dependencies

### External Services
- **ML API:** `/simulate/outcome`, `/alerts/suggestions`, `/detective/score`
  - **Mitigation:** Mock service with rule-based fallback
- **Firebase:** FCM (alerts), Firestore (alert rules), Analytics
  - **Mitigation:** Local-first (Hive) for offline mode
- **RevenueCat:** Paywall limits (simulator, swipe, alerts)
  - **Mitigation:** Hardcoded limits for MVP, upgrade later

### Internal Code
- **Existing Search UI:** Reuse for simulator property browse
- **Property Detail Screen:** Deep link from alerts/detective
- **Subscription Service:** Check tier for feature access

---

## Testing Strategy

### Coverage Targets
- **Unit Tests:** 80%+ on business logic
- **Widget Tests:** Key user flows (3-5 per screen)
- **Integration Tests:** End-to-end happy path + 2 error cases
- **Manual QA:** Both platforms (iOS + Android)

### Test Pyramid
```
        /\
       /  \  Integration (10%)
      /____\
     /      \  Widget Tests (30%)
    /________\
   /          \  Unit Tests (60%)
  /____________\
```

---

## Risk Mitigation

### Technical Risks

**Risk 1: ML API Latency (>500ms)**
- **Impact:** High (poor UX for simulator outcomes)
- **Mitigation:** Prefetch outcomes for likely purchases, cache results
- **Fallback:** Rule-based calculation (county historical averages)

**Risk 2: FCM Delivery Failure**
- **Impact:** Medium (alerts not received)
- **Mitigation:** In-app fallback (check on app open), retry logic
- **Monitoring:** Track delivery rate, alert if <95%

**Risk 3: Swipe Animation Janky (<30fps)**
- **Impact:** Medium (poor UX)
- **Mitigation:** Profile early (Week 9), optimize or simplify animation
- **Fallback:** Simpler fade animation instead of rotation

### Scope Risks

**Risk 4: Scope Creep (Adding Deferred Screens)**
- **Impact:** Critical (delays MVP launch)
- **Mitigation:** ✅ This document enforces 3-screen limit
- **Enforcement:** Reject any feature requests until post-MVP

**Risk 5: Underestimation (Tasks Take Longer)**
- **Impact:** High (miss Week 14 deadline)
- **Mitigation:** 20% buffer built into estimates, weekly checkpoints
- **Trigger:** If Week 8 behind schedule, cut polish tasks

---

## Next Steps

### Immediate (Week 4)
1. [ ] **User Approval:** Review and approve this MVP plan
2. [ ] **Setup Firebase Project:** FCM, Firestore rules, Analytics
3. [ ] **API Contracts:** Define ML endpoints with backend team
4. [ ] **Design Assets:** Simulator icons, leaderboard badges

### Week 5 (Start Implementation)
5. [ ] **Sprint 1 Kickoff:** Portfolio Simulator foundation
6. [ ] **Daily Standups:** Track progress, blockers
7. [ ] **Code Reviews:** Peer review all PRs

### Week 8 (Milestone Review)
8. [ ] **Demo Simulator:** Show to stakeholders
9. [ ] **User Testing:** 5-10 beta testers
10. [ ] **Decision:** Proceed to Deal Detective or iterate?

---

## Deferred Screens (Post-MVP)

**Build these ONLY after MVP validation:**
- Risk Radar (visual risk assessment)
- ROI Calculator Live (interactive sliders)
- County Heatmap (geographic visualization)
- Auction Timer (countdown & urgency)
- Journey Map (gamified progress)
- Leaderboard Expansion (social features)
- Exit Strategy Planner (scenario planning)
- ...and 8 more from original 18

**Decision Criteria:**
- Simulator conversion: >10%
- Swipe engagement: >500 swipes/user/week
- Alert CTR: >30%

**If metrics met → Expand. If not → Iterate MVP.**

---

**Document Status:** READY FOR REVIEW
**Approval Required:** Yes (User must approve before Week 5 start)
**Next Document:** `04-implementation-log.md` (track progress during Weeks 5-14)
