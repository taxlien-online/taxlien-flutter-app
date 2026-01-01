# flows/ Directory

**Spec-Driven Development (SDD) Projects for TAXLIEN.online**

---

## Quick Start

### 📋 Master Plan
Start here: **[ROADMAP.md](ROADMAP.md)** - See all projects, phases, dependencies, and timelines.

### 🔍 Recent Changes
See: **[REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)** - Deep refactoring report (2026-01-01)

### 📚 SDD Process
Learn: **[sdd.md](sdd.md)** - How Spec-Driven Development works

---

## Active Projects

### 1. [sdd-mobile-app](sdd-mobile-app/) - Monetization Foundation
**Status:** REQUIREMENTS → SPECIFICATIONS (next)
**Priority:** 🔥 P0 CRITICAL
**Timeline:** Weeks 1-8

**Focus:** Revenue-critical features
- ✅ Trial period: 365d → 14d (DONE in code)
- ✅ Pricing: $29.99 → $49.99 (DONE in code)
- ⏳ Paywall system, In-app education, Transaction fees

**Impact:** Protects $300K/year revenue

---

### 2. [sdd-mobile-app-ui](sdd-mobile-app-ui/) - UI/UX Enhancement
**Status:** PLAN COMPLETE → IMPLEMENTATION (ready)
**Priority:** 🔥 P0 CRITICAL
**Timeline:** Weeks 5-18

**Focus:** 3 MVP screens (reduced from 18)
1. 🥇 Portfolio Simulator - Risk-free learning
2. 🥈 Deal Detective - Swipe UI engagement
3. 🥉 Smart Alerts - Retention driver

**Impact:** 2x conversion rate (5% → 10%)

**Files:**
- [03-plan-MVP.md](sdd-mobile-app-ui/03-plan-MVP.md) - MVP implementation plan (55 tasks, 10 weeks)
- [03-plan.md](sdd-mobile-app-ui/03-plan.md) - Original 18-screen plan (deferred)

---

### 3. [sdd-mobile-tools](sdd-mobile-tools/) - Standalone Tools Ecosystem
**Status:** SPECIFICATIONS → PLAN (next)
**Priority:** ⚡ P1 HIGH
**Timeline:** Weeks 15-26

**Focus:** Standalone apps for lead generation
- P0: Market Comparison Calculator ($9.99/mo)
- P0: Sweet Spot Property Analyzer ($19.99/mo)

**Impact:** +$11K MRR new revenue stream

---

## Archived Projects

### [_archived/sdd-trial-pricing-optimization](_archived/sdd-trial-pricing-optimization/)
**Reason:** Duplicate scope (merged into sdd-mobile-app)
**Date Archived:** 2026-01-01

---

## Directory Structure

```
flows/
├── README.md                       # ← You are here
├── ROADMAP.md                      # Master coordination (START HERE)
├── REFACTORING_SUMMARY.md          # Deep refactoring report (2026-01-01)
├── sdd.md                          # SDD process guide
│
├── sdd-mobile-app/                 # ✅ ACTIVE: Monetization
│   ├── _status.md                  # Current phase tracker
│   ├── 01-requirements.md          # What & Why (917 lines)
│   ├── README.md                   # Project summary
│   └── SUMMARY.md                  # Quick reference
│
├── sdd-mobile-app-ui/              # ✅ ACTIVE: UI/UX (MVP)
│   ├── _status.md                  # Current phase tracker
│   ├── 01-requirements.md          # 18 screens designed
│   ├── 02-specifications.md        # Component library, animations
│   ├── 03-plan.md                  # Original 18-screen plan
│   ├── 03-plan-MVP.md              # ✨ MVP plan (3 screens, 10 weeks)
│   ├── 04-implementation-log.md    # Progress tracking (TBD)
│   ├── FINAL-SUMMARY.md            # Project summary
│   ├── GAP-ANALYSIS.md             # Guidebook gaps identified
│   ├── INTEGRATION-PLAN.md         # How screens connect
│   ├── PLAN-SUMMARY.md             # Plan overview
│   ├── PRIORITIES.md               # Top 3 screens analysis
│   ├── README.md                   # Project summary
│   ├── SCREEN-FLOW.md              # User flow diagrams
│   └── SUMMARY.md                  # Quick reference
│
├── sdd-mobile-tools/               # ✅ ACTIVE: Standalone tools
│   ├── _status.md                  # Current phase tracker
│   ├── 01-requirements.md          # 7 tools defined (690 lines)
│   ├── 02-specifications.md        # Shared infra, API design
│   ├── README.md                   # Project summary
│   └── SUMMARY.md                  # Quick reference
│
└── _archived/                      # 🗄️ Inactive projects
    └── sdd-trial-pricing-optimization/
```

---

## SDD Workflow

```
REQUIREMENTS → SPECIFICATIONS → PLAN → IMPLEMENTATION
     ↑              ↑            ↑
     └──────────────┴────────────┴── (iterate at any phase)
```

### Phase Gates (User Approval Required)

1. **Requirements → Specifications**
   - [ ] Requirements reviewed
   - [ ] Open questions resolved
   - [ ] User approves: "requirements approved"

2. **Specifications → Plan**
   - [ ] Specifications reviewed
   - [ ] Edge cases documented
   - [ ] User approves: "specs approved"

3. **Plan → Implementation**
   - [ ] Plan reviewed
   - [ ] Tasks are atomic and testable
   - [ ] User approves: "plan approved"

---

## Current Status (2026-01-01)

### Completed ✅
- Deep refactoring of flows/ directory
- Code verification (trial period, pricing - all DONE)
- Eliminated duplicate projects (archived sdd-trial-pricing-optimization)
- Created master ROADMAP.md
- Reduced sdd-mobile-app-ui scope (18 → 3 screens MVP)
- Synchronized all _status.md files

### In Progress ⏳
- Awaiting user approval: ROADMAP.md
- Awaiting user approval: 03-plan-MVP.md

### Next Actions 📋
1. User review & approve ROADMAP.md
2. User review & approve 03-plan-MVP.md
3. Create sdd-mobile-app 02-specifications.md
4. Create sdd-mobile-tools 03-plan.md
5. Begin implementation (Week 3)

---

## Key Decisions

### 2026-01-01: Deep Refactoring

**Archived:**
- sdd-trial-pricing-optimization (duplicate)

**Deleted:**
- sdd-web-app (empty)

**Scope Reduced:**
- sdd-mobile-app-ui: 18 screens → 3 MVP screens

**Created:**
- ROADMAP.md (master coordination)
- 03-plan-MVP.md (realistic 10-week plan)
- REFACTORING_SUMMARY.md (this refactoring report)

**Rationale:**
- Focus on highest-impact work (Pareto 80/20)
- Eliminate confusion and duplication
- Realistic timelines (not overpromising)
- Revenue-first approach (Phase 1 before Phase 2)

---

## Success Metrics (6-Month Checkpoint)

### Revenue
- [x] Trial period fixed (protects $300K/year) ✅ DONE
- [ ] MRR: $15K (500 subscribers × $30 avg)
- [ ] Tool revenue: $11K MRR (800 tool users)
- [ ] Total MRR: $26K

### Product
- [ ] 3 innovative screens shipped (Simulator, Detective, Alerts)
- [ ] 2 standalone tools launched (Market Finder, Sweet Spot)
- [ ] 80%+ test coverage (critical paths)

### Users
- [ ] 5,000 registered users
- [ ] 500 paid subscribers (10% conversion)
- [ ] 800 tool users (separate funnel)

---

## Questions?

- **Process questions:** See [sdd.md](sdd.md)
- **Project status:** Check `_status.md` in each project folder
- **Master plan:** See [ROADMAP.md](ROADMAP.md)
- **Recent changes:** See [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)

---

**Last Updated:** 2026-01-01 by Claude
**Next Review:** Week 4 milestone (after Phase 1 sprint 1)
