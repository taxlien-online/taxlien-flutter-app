# Status: sdd-mobile-tools

## Current Phase

REQUIREMENTS | **SPECIFICATIONS** | PLAN | IMPLEMENTATION

## Phase Status

**IN PROGRESS** (Specifications being drafted for P0 tools)

## Last Updated

2025-12-31 by Claude (AI Assistant)

## Blockers

- None

## Progress

- [x] Standalone tools concept defined
- [x] 7 tools identified and prioritized
- [x] Requirements approved ✅
- [x] Specifications completed (P0 tools: Market Finder + Sweet Spot) ✅
  - [x] Shared infrastructure (Auth, Payments, Analytics)
  - [x] Market Finder (UI/UX, API, data models)
  - [x] Sweet Spot Analyzer (UI/UX, API, algorithms)
  - [x] Database schemas (PostgreSQL + Firestore)
  - [x] Testing strategy defined
- [ ] Specifications approved
- [ ] Plan drafted
- [ ] Plan approved
- [ ] Implementation started
- [ ] Implementation complete

## Context Notes

### Scope
- **Focus:** Standalone mobile tools for tax lien investors
- **Strategy:** Build ecosystem of focused apps (vs one monolith)
- **Monetization:** Each tool = separate product ($4.99-49.99)
- **Funnel:** Free tools → Paid tools → Main app subscription

### 7 Identified Tools

**P0 (Critical):**
1. Market Comparison Calculator - $9.99-49.99
2. Sweet Spot Property Analyzer - $19.99-49.99

**P1 (High):**
3. ROI & Profit Calculator - $4.99-9.99
4. Investment Strategy Quiz - $9.99-99
5. County Research Assistant - $14.99-29.99

**P2 (Medium):**
6. Due Diligence Checklist - $19.99-49.99
7. Research Routine Tracker - $9.99-29.99

### Business Model

**Revenue Streams:**
- One-time purchases ($4.99-49.99)
- Subscriptions ($9.99-49.99/year for updates)
- Main app upsells ($49.99/month)

**Projections:**
- Conservative: $58K/month (5,100 downloads total)
- Aggressive: $290K/month (25,000 downloads total)

### Development Strategy

**Phase 1 (Months 1-3):** Market Finder + Sweet Spot (P0)
**Phase 2 (Months 4-6):** ROI Calc + Strategy Quiz + County Assistant (P1)
**Phase 3 (Months 7-9):** Due Diligence + Routine Tracker (P2)

### Technical Approach

**Shared Infrastructure:**
- Backend: Firebase Functions / FastAPI
- Database: Firestore + PostgreSQL (county data)
- Auth: Firebase Auth (single sign-on)
- Payments: RevenueCat
- Analytics: Firebase Analytics

**Benefits:**
- Build once, reuse across tools
- Unified user accounts
- Cross-tool upselling
- Centralized data

### Key Advantages

**Why Standalone Tools?**
1. **Monetization:** Each = separate revenue stream
2. **Marketing:** Each = App Store visibility
3. **Focus:** Solve specific problem well
4. **Development:** Parallel with main app
5. **Testing:** Quick validation
6. **Upsell:** Funnel to main app

### Integration with Main App

**Freemium Funnel:**
```
Tool (Free) → Tool (Pro) → Main App Trial → Main App Subscription

Expected conversion: 1.5% (tool download → main app paid)
LTV: $609-650 (tool purchase + main app)
```

### Tool Status
- [x] Market Finder (requirements defined)
- [x] Sweet Spot Analyzer (requirements defined)
- [x] ROI Calculator (requirements defined)
- [x] Strategy Quiz (requirements defined)
- [x] County Assistant (requirements defined)
- [x] Due Diligence Checklist (requirements defined)
- [x] Routine Tracker (requirements defined)

### Resolved Questions
- [x] Which tools to build first? **APPROVED: P0 tools (Market Finder + Sweet Spot)**
- [x] Pricing strategy? **DECIDED: Hybrid (one-time + yearly subscription)**
  - Market Finder: $9.99/mo or $99.99/year
  - Sweet Spot: $19.99/mo or $199.99/year
- [x] Branding? **DECIDED: TAXLIEN.online family branding**
- [x] Launch sequence? **DECIDED: Staggered (P0 first, validate, then P1)**

### Open Questions (for Plan phase)
- [ ] Pricing bundles? (Both tools together for $24.99/mo vs $29.98?)
- [ ] Main app integration? (Premium subscription unlocks Pro tier in tools?)
- [ ] Enterprise white-label? (Allow agencies to rebrand tools?)
- [ ] Offline mode? (Cached data for offline use?)
- [ ] API rate limits? (1,000 req/hour for Market Finder, 100 analyses/day for Sweet Spot?)

## Next Actions

1. **User Review & Approval:**
   - Review [02-specifications.md](02-specifications.md) (complete technical design)
   - Approve specifications OR request changes
   - Clarify open questions if needed

2. **PLAN Phase (Next):**
   - Break specs into atomic development tasks
   - Identify file changes and dependencies
   - Estimate complexity for each task
   - Create 6-8 week implementation timeline

3. **Development:**
   - Build P0 tools in parallel
   - Timeline: 6-8 weeks to first 2 tools
   - Soft launch for testing

4. **Marketing:**
   - App Store optimization (ASO)
   - Landing pages for each tool
   - Content marketing (blog posts, YouTube)
