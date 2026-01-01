# TAXLIEN.online Development Roadmap

**Last Updated:** 2026-01-01
**Version:** 1.0
**Owner:** Development Team

---

## Executive Summary

This roadmap coordinates all active SDD (Spec-Driven Development) projects for TAXLIEN.online mobile app. It defines dependencies, priorities, and execution sequence to maximize revenue impact while maintaining development velocity.

### Strategic Goals (Year 1)
- **Revenue Target:** $300K-500K
- **MRR Target (Month 12):** $50K-80K
- **User Acquisition:** 5,000-10,000 active users
- **Conversion Rate:** Free → Paid 5% → 10%

---

## Project Overview

| Project | Phase | Priority | Status | Timeline | Impact |
|---------|-------|----------|--------|----------|--------|
| [sdd-mobile-app](#sdd-mobile-app) | REQUIREMENTS | 🔥 P0 CRITICAL | ✅ Verified | Weeks 1-8 | $300K/year revenue protection |
| [sdd-mobile-app-ui](#sdd-mobile-app-ui) | PLAN COMPLETE | 🔥 P0 CRITICAL | 📋 Ready | Weeks 5-18 | 2x conversion rate |
| [sdd-mobile-tools](#sdd-mobile-tools) | SPECIFICATIONS | ⚡ P1 HIGH | 🚧 In Progress | Weeks 15-26 | +$58K-290K/mo new revenue |

**Legend:**
- 🔥 P0 = Critical (revenue blocking)
- ⚡ P1 = High (growth accelerator)
- 📋 P2 = Medium (enhancement)

---

## Dependency Graph

```
sdd-mobile-app (Monetization Foundation)
    ↓
    ├─→ sdd-mobile-app-ui (UI/UX Enhancement)
    │       ↓
    │       └─→ Full Production Launch
    │
    └─→ sdd-mobile-tools (Standalone Tools Ecosystem)
            ↓
            └─→ Lead Generation Funnel
```

**Critical Path:** `sdd-mobile-app → sdd-mobile-app-ui → Production Launch`

---

## Phase 1: Monetization Foundation (Weeks 1-8)
### Project: sdd-mobile-app

**Objective:** Implement revenue-critical features to protect $300K/year and enable sustainable business model.

### Week 1-2: Core Monetization ✅ CODE VERIFIED
- [x] Trial Period: 365d → 14d (DONE - `subscription_constants.dart:43`)
- [x] Pricing: $29.99 → $49.99 (DONE - `subscription_constants.dart:123`)
- [x] New Tier: Starter $19.99 (DONE - `subscription_constants.dart:118`)
- [ ] **NEXT:** Create 02-specifications.md
- [ ] **NEXT:** IAP store configuration (App Store Connect + Google Play Console)

### Week 3-4: Paywall System
- [ ] Paywall trigger service (search limits, AI limits)
- [ ] Paywall screen implementation
- [ ] A/B testing framework (Firebase Remote Config)
- [ ] Analytics integration (Firebase Analytics)

### Week 5-6: In-App Education
- [ ] Module 1: Tax Lien Fundamentals (3 lessons)
- [ ] Quiz system with gamification
- [ ] Progress tracking & unlocks
- [ ] Video player integration (Vimeo)

### Week 7-8: Transaction Fees
- [ ] Fee calculation engine (2.5% lien, 5% NFT, 1% withdrawal)
- [ ] Stripe integration
- [ ] Transaction history & receipts
- [ ] Revenue reporting dashboard

**Deliverables:**
- ✅ `subscription_constants.dart` (DONE)
- [ ] `02-specifications.md` (In Progress)
- [ ] `03-plan.md` (Week 2)
- [ ] `04-implementation-log.md` (Weeks 3-8)

**Success Metrics:**
- Trial conversion: 5% → 8%
- ARPU: $29.99 → $49.99 (+67%)
- MRR: $0 → $5K (Month 2)

---

## Phase 2: UI/UX Enhancement (Weeks 5-18)
### Project: sdd-mobile-app-ui

**Objective:** Build 3 innovative screens (MVP) to double conversion rate and increase engagement.

### Current Status
- ✅ Requirements: 18 screens designed (COMPLETE)
- ✅ Specifications: Component library, animations (COMPLETE)
- ✅ Plan: 73 tasks, 10-week timeline (COMPLETE)
- 📋 **READY FOR IMPLEMENTATION**

### MVP Scope Reduction (18 → 3 Screens)

**Top 3 Priority Screens:**

#### 🥇 Screen 1: Portfolio Simulator (Weeks 5-8)
**Why First:**
- Risk-free learning = trust building
- Practice mode = lower barrier to entry
- Gamification = high engagement
- Data collection = ML training

**Features:**
- Virtual $100K starting capital
- Real property data (but simulated outcomes)
- Time acceleration (1 week = 1 hour real-time)
- Leaderboard & achievements

**Success Metrics:**
- 70% of free users try simulator
- 15% convert to paid after simulation
- 10+ simulations per user (avg)

#### 🥈 Screen 2: Deal Detective (Weeks 9-11)
**Why Second:**
- Swipe UI = familiar (Tinder for properties)
- Quick decision-making = engagement
- ML training data = swipe preferences
- Viral potential = share-worthy

**Features:**
- Swipe right (good deal), left (pass)
- AI learns user preferences
- "Match" notifications for deals
- Share deals with friends

**Success Metrics:**
- 500+ swipes per user per week
- 20% match rate (user likes property)
- 5% conversion (liked → portfolio)

#### 🥉 Screen 3: Smart Alerts (Weeks 12-14)
**Why Third:**
- Retention driver = daily engagement
- Premium feature = paid conversion
- Personalization = AI value demo
- Push notifications = re-engagement

**Features:**
- AI-powered deal matching
- Real-time push notifications
- Custom alert rules
- Alert performance tracking

**Success Metrics:**
- 80% enable alerts (paid users)
- 3+ alerts per week per user
- 30% click-through rate (alert → app)

### Deferred (Post-MVP)
- Risk Radar (visual risk assessment)
- ROI Calculator Live (interactive tool)
- County Heatmap (geographic finder)
- Auction Timer (countdown & urgency)
- Journey Map (progress tracking)
- Leaderboard (competition)
- Exit Strategy Planner (scenario planning)

**Deliverables:**
- ✅ `01-requirements.md` (COMPLETE)
- ✅ `02-specifications.md` (COMPLETE)
- ✅ `03-plan.md` (COMPLETE)
- [ ] `03-plan-mvp.md` (MVP scope - Week 4)
- [ ] `04-implementation-log.md` (Weeks 5-14)

**Success Metrics:**
- Conversion: 5% → 10% (+100%)
- DAU/MAU: 0.15 → 0.30 (+100%)
- Session duration: 3min → 8min (+167%)

---

## Phase 3: Tool Ecosystem (Weeks 15-26)
### Project: sdd-mobile-tools

**Objective:** Launch standalone tools to generate leads and create new revenue streams.

### Current Status
- ✅ Requirements: 7 tools defined, P0 prioritized (COMPLETE)
- ✅ Specifications: Shared infrastructure, API design (COMPLETE)
- ❌ Plan: Task breakdown needed (NEXT)

### P0 Tools (Build First)

#### Tool 1: Market Comparison Calculator (Weeks 15-20)
**Pricing:** $9.99/mo or $99.99/year
**Target Users:** Beginner investors (county comparison)

**Features:**
- Compare 2-5 counties side-by-side
- 15+ metrics (redemption rate, ROI, competition)
- Data visualization (charts, heatmaps)
- Export reports (PDF)

**Revenue Projection:**
- 500 downloads/month × $9.99 = $5K MRR
- Conversion to main app: 1.5% = 7-8 new subscribers

#### Tool 2: Sweet Spot Property Analyzer (Weeks 21-26)
**Pricing:** $19.99/mo or $199.99/year
**Target Users:** Intermediate investors (property analysis)

**Features:**
- AI property scoring (0-100)
- Risk assessment (low/medium/high)
- ROI predictions (ML-powered)
- Personalized recommendations

**Revenue Projection:**
- 300 downloads/month × $19.99 = $6K MRR
- Conversion to main app: 2% = 6 new subscribers

### P1 Tools (Later)
- ROI & Profit Calculator
- Investment Strategy Quiz
- County Research Assistant

### P2 Tools (Future)
- Due Diligence Checklist
- Research Routine Tracker

**Deliverables:**
- ✅ `01-requirements.md` (COMPLETE)
- ✅ `02-specifications.md` (COMPLETE)
- [ ] `03-plan.md` (Week 14)
- [ ] `04-implementation-log.md` (Weeks 15-26)

**Success Metrics:**
- Combined tool revenue: $11K MRR (Month 6)
- Main app conversions: 13-14 new subscribers/month
- App Store visibility: 2 featured apps

---

## Resource Allocation

### Development Team
- **2 Flutter Developers** (full-time)
- **1 Backend Developer** (part-time, API integration)
- **1 UI/UX Designer** (contract, Figma mockups)
- **1 QA Engineer** (part-time, testing)

### Sprint Allocation

| Weeks | Project | Team Split | Deliverable |
|-------|---------|------------|-------------|
| 1-4 | sdd-mobile-app | 2 devs (100%) | Specs + IAP config |
| 5-8 | sdd-mobile-app | 2 devs (100%) | Paywall + Education |
| 5-8 | sdd-mobile-app-ui | (parallel) | Portfolio Simulator |
| 9-11 | sdd-mobile-app-ui | 2 devs (100%) | Deal Detective |
| 12-14 | sdd-mobile-app-ui | 2 devs (100%) | Smart Alerts |
| 15-20 | sdd-mobile-tools | 1 dev + 1 backend | Market Finder |
| 21-26 | sdd-mobile-tools | 1 dev + 1 backend | Sweet Spot |

---

## Risk Mitigation

### Technical Risks

**Risk 1: ML API Not Ready**
- **Impact:** High (blocks AI features)
- **Probability:** Medium
- **Mitigation:** Mock service with cached predictions
- **Fallback:** Use rule-based scoring instead of ML

**Risk 2: IAP Store Approval Delays**
- **Impact:** Critical (blocks revenue)
- **Probability:** Medium
- **Mitigation:** Submit 2 weeks early, prepare appeals
- **Fallback:** Web checkout (Stripe) as backup

**Risk 3: Scope Creep (sdd-mobile-app-ui)**
- **Impact:** High (delays launch)
- **Probability:** High
- **Mitigation:** ✅ MVP scope reduction (18 → 3 screens)
- **Enforcement:** Strict feature freeze after Week 4

### Business Risks

**Risk 4: Low Trial Conversion (<5%)**
- **Impact:** Critical (revenue miss)
- **Probability:** Medium
- **Mitigation:** A/B test paywalls, onboarding optimization
- **Trigger:** If Week 8 conversion <3%, pivot to 30-day trial

**Risk 5: Tool Cannibalization**
- **Impact:** Medium (main app sales affected)
- **Probability:** Low
- **Mitigation:** Tools = feature-limited, main app = full power
- **Monitoring:** Track conversion funnel tool → main app

---

## Decision Log

### 2026-01-01: Deep Refactoring

**Decisions:**
1. ✅ **Archived** `sdd-trial-pricing-optimization` (duplicate of sdd-mobile-app)
2. ✅ **Deleted** `sdd-web-app` (empty, no plans)
3. ✅ **Verified** code changes in `subscription_constants.dart` (all DONE)
4. ✅ **Reduced scope** sdd-mobile-app-ui (18 → 3 screens MVP)
5. ✅ **Created** this ROADMAP.md for master coordination

**Rationale:**
- Eliminate duplication and confusion
- Focus on highest-impact work (Pareto 80/20)
- Create clear dependency chain
- Enable parallel development where possible

---

## Next Actions

### Week 1 (Immediate)
1. [ ] **User Review:** Approve this ROADMAP.md
2. [ ] **sdd-mobile-app:** Create 02-specifications.md
3. [ ] **sdd-mobile-app:** Configure IAP products (App Store + Google Play)
4. [ ] **sdd-mobile-app-ui:** Create 03-plan-mvp.md (MVP scope only)

### Week 2
5. [ ] **sdd-mobile-app:** Create 03-plan.md (task breakdown)
6. [ ] **sdd-mobile-tools:** Create 03-plan.md (P0 tools only)
7. [ ] **All projects:** Begin implementation phase

### Week 4 (Milestone Review)
8. [ ] Review progress on sdd-mobile-app (Paywall + Analytics)
9. [ ] Decision: Proceed with sdd-mobile-app-ui or iterate?
10. [ ] Adjust roadmap based on learnings

---

## Success Criteria (6-Month Checkpoint)

**Revenue:**
- [x] Trial period fixed (protects $300K/year) ✅ DONE
- [ ] MRR: $15K (500 subscribers × $30 avg)
- [ ] Tool revenue: $11K MRR (800 tool users)
- [ ] Total MRR: $26K

**Product:**
- [ ] 3 innovative screens shipped (Simulator, Detective, Alerts)
- [ ] 2 standalone tools launched (Market Finder, Sweet Spot)
- [ ] 80%+ test coverage (critical paths)

**Users:**
- [ ] 5,000 registered users
- [ ] 500 paid subscribers (10% conversion)
- [ ] 800 tool users (separate funnel)

**Velocity:**
- [ ] All 3 SDD projects in IMPLEMENTATION phase
- [ ] Weekly releases (CI/CD pipeline)
- [ ] <5% rollback rate (quality)

---

## Appendix

### Related Documents
- [SDD Process Guide](sdd.md)
- [sdd-mobile-app Status](sdd-mobile-app/_status.md)
- [sdd-mobile-app-ui Status](sdd-mobile-app-ui/_status.md)
- [sdd-mobile-tools Status](sdd-mobile-tools/_status.md)

### Changelog
- **2026-01-01:** Initial roadmap created (deep refactoring)
- **2026-01-01:** MVP scope reduction (sdd-mobile-app-ui: 18 → 3 screens)
- **2026-01-01:** Code verification (subscription_constants.dart changes confirmed)

---

**Questions or Feedback?**
Update this roadmap as decisions are made. Treat this as a living document.
