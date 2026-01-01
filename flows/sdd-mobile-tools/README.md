# SDD: Mobile Tools (Standalone Apps)

> **Status:** REQUIREMENTS (Draft)
> **Started:** 2025-12-31
> **Owner:** Anton (Product Owner)

## Overview

Standalone mobile tools ecosystem for tax lien investors. Instead of one monolithic app, create 7 focused mini-apps that solve specific problems and can be monetized separately.

### Vision

Transform tax lien investment education into a **suite of practical tools** that generate revenue at every step of the investor journey.

### Key Strategy

**Freemium Funnel:**
```
Free Tool → Paid Tool ($9.99-49.99) → Main App Trial → Subscription ($49.99/mo)
```

Each tool serves as both:
1. **Standalone product** (revenue)
2. **Lead magnet** for main app (upsell)

---

## 📁 Documentation

### Quick Reference
- **[SUMMARY.md](SUMMARY.md)** - Quick reference guide 📋
  - 7 tools overview
  - Revenue projections ($58K/month conservative)
  - Launch strategy (3 phases)
  - Technical architecture

### Requirements
- **[01-requirements.md](01-requirements.md)** - Complete requirements ✅
  - Tool-by-tool breakdown (7 tools)
  - UI/UX wireframes for each
  - Monetization strategy
  - Integration with main app
  - Revenue projections

### Specifications
- **[02-specifications.md](02-specifications.md)** - Technical specifications ✅
  - P0 tools: Market Finder + Sweet Spot Analyzer
  - Shared infrastructure (Auth, Payments, Analytics)
  - Complete UI/UX designs with layouts
  - API contracts and data models
  - Database schemas (PostgreSQL + Firestore)
  - Testing strategy

### Status
- **[_status.md](_status.md)** - Current phase and progress
  - Phase: SPECIFICATIONS (COMPLETED)
  - P0 tools fully specified
  - Next: User approval → PLAN phase

---

## 🛠️ 7 Tools at a Glance

### P0 - Must Build First
1. **Market Comparison Calculator** - Compare states/counties
2. **Sweet Spot Property Analyzer** - Filter 11K properties → buy list

### P1 - Build Next
3. **ROI & Profit Calculator** - Quick return calculations
4. **Investment Strategy Quiz** - Passive vs Active recommendation
5. **County Research Assistant** - Phone scripts, call tracking

### P2 - Nice to Have
6. **Due Diligence Checklist** - Pre-purchase verification
7. **Research Routine Tracker** - Daily habits, streaks

---

## 💰 Business Case

### Revenue Potential

**Conservative (1,000 downloads/tool/month):**
- Direct tool sales: $58K/month
- Main app upsells: $3.8K/month
- **Total: $62K/month**
- **Annual: $744K**

**Aggressive (5,000 downloads/tool/month):**
- Direct tool sales: $290K/month
- Main app upsells: $19K/month
- **Total: $309K/month**
- **Annual: $3.7M**

### Why Standalone Tools?

| Benefit | Description |
|---------|-------------|
| **More Revenue Streams** | 7 products vs 1 |
| **Lower Barrier** | $9.99 tool vs $49.99/mo subscription |
| **Better Discovery** | 7 App Store listings vs 1 |
| **Faster Validation** | Test concepts quickly |
| **Focused Value** | Solve one problem well |

---

## 🎯 Prioritization

| Tool | Business Impact | Dev Effort | Revenue/Mo | Priority |
|------|----------------|------------|------------|----------|
| Market Finder | HIGH | 2-3 weeks | $10K | 🔥 P0 |
| Sweet Spot | HIGH | 3-4 weeks | $16K | 🔥 P0 |
| ROI Calculator | MEDIUM | 1-2 weeks | $7.5K | ⚡ P1 |
| Strategy Quiz | MEDIUM | 1 week | $6K | ⚡ P1 |
| County Assistant | MEDIUM | 2-3 weeks | $7.5K | ⚡ P1 |
| Due Diligence | MEDIUM | 2 weeks | $8K | 📅 P2 |
| Routine Tracker | LOW | 2 weeks | $3K | 📅 P2 |

---

## 🚀 Implementation Roadmap

### Phase 1: Foundation (Weeks 1-7)
**Build P0 Tools:**
1. Market Comparison Calculator (3 weeks)
2. Sweet Spot Property Analyzer (4 weeks)

**Deliverables:**
- 2 live tools in App Store
- $26K/month revenue potential
- Funnel to main app working

---

### Phase 2: Expansion (Weeks 8-14)
**Add P1 Tools:**
3. ROI Calculator (1.5 weeks)
4. Strategy Quiz (1 week)
5. County Assistant (2.5 weeks)

**Deliverables:**
- 5 tools live
- $47K/month cumulative revenue
- Cross-tool analytics working

---

### Phase 3: Complete Suite (Weeks 15-19)
**Add P2 Tools:**
6. Due Diligence Checklist (2 weeks)
7. Routine Tracker (2 weeks)

**Deliverables:**
- Complete 7-tool ecosystem
- $58K/month cumulative revenue
- Full funnel optimization

---

## 🔧 Technical Stack

| Component | Technology | Why |
|-----------|-----------|-----|
| **Framework** | Flutter | Cross-platform, fast development |
| **Backend** | Firebase/FastAPI | Shared infrastructure |
| **Database** | Firestore + PostgreSQL | Real-time + county data |
| **Auth** | Firebase Auth | Single sign-on across tools |
| **Payments** | RevenueCat | IAP management |
| **Analytics** | Firebase + Mixpanel | User behavior tracking |

### Shared Infrastructure Benefits
- Build backend once, reuse for all 7 tools
- Unified user accounts (login to one = login to all)
- Cross-tool analytics
- Easy upselling between tools

---

## 📊 Success Metrics

### Per-Tool KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| Downloads | 1,000/month | App Store Connect |
| Free → Paid | 15% | RevenueCat |
| Tool → Main App | 30% | Firebase Analytics |
| DAU/MAU | 40% | Firebase Analytics |
| Day 7 Retention | 50% | Firebase Analytics |

### Business KPIs (Month 12)

| Metric | Target |
|--------|--------|
| Total Tool Revenue | $60K/month |
| Main App Referrals | 1,800/month |
| Main App Conversions | 180/month |
| Total Ecosystem Revenue | $150K/month |

---

## 🔗 Integration Strategy

### With Main App

Every tool includes:
1. **"Try Premium" CTA** after upgrade to Pro
2. **Cross-promotion** in success messages
3. **Unified accounts** (login once, access all)
4. **Shared data** (favorites sync across tools)

### Upsell Flow Example

```
User Journey:
1. Downloads "Market Finder" (free)
2. Uses it, loves it
3. Hits limit (top 5 states only)
4. Upgrades to Pro ($9.99)
5. Sees: "Want AI analysis? Try TAXLIEN.online Premium"
6. Clicks → Downloads main app
7. Starts 14-day trial
8. Converts to $49.99/month
9. Total LTV: $9.99 + ($49.99 × 12) = $609.87
```

---

## ⚠️ Critical Decisions

### 1. Branding
**Option A:** Separate brands (e.g., "Market Finder Pro")
**Option B:** Family brand (e.g., "TAXLIEN Market Finder")

**Recommendation:** Family brand for easier cross-promotion

### 2. Pricing Strategy
**Option A:** One-time purchase only ($9.99-49.99)
**Option B:** Freemium + subscription ($9.99/year updates)
**Option C:** Hybrid (one-time + optional subscription)

**Recommendation:** Hybrid - best of both worlds

### 3. Launch Sequence
**Option A:** Launch all 7 at once (big splash)
**Option B:** Stagger launch (validate each)

**Recommendation:** Stagger - P0 first, then P1, then P2

### 4. Scope
**Option A:** Build only P0 tools (MVP)
**Option B:** Build P0 + P1 (strong ecosystem)
**Option C:** Build all 7 (complete suite)

**Recommendation:** Start with P0, expand based on traction

---

## 📝 Next Steps

### For User Review
1. **Approve concept:** Standalone tools vs all-in-one?
2. **Choose initial tools:** P0 only or include P1?
3. **Pricing strategy:** One-time, subscription, or hybrid?
4. **Branding:** Separate or family brand?
5. **Budget:** $50K-100K for Phase 1 (P0 tools)?

### For Development
1. **SPECIFICATIONS Phase:**
   - Detailed UI/UX for P0 tools
   - Database schema design
   - API contracts

2. **Development:**
   - Build Market Finder (3 weeks)
   - Build Sweet Spot Analyzer (4 weeks)
   - Testing & QA (1 week)
   - App Store submission (1 week)

3. **Marketing:**
   - ASO (App Store Optimization)
   - Landing pages
   - Content marketing (blog, YouTube)

---

## 🎯 Recommended Action

**Start with P0 Tools (Market Finder + Sweet Spot)**

### Why?
1. **Highest impact** - Solve biggest pain points
2. **Test funnel** - Validate standalone → main app conversion
3. **Revenue proof** - $26K/month potential
4. **Fast to market** - 6-8 weeks vs 6 months for all 7
5. **Low risk** - Can pivot if needed

### Timeline
- **Week 1-3:** Market Finder development
- **Week 4-7:** Sweet Spot Analyzer development
- **Week 8:** Testing, QA, App Store submission
- **Week 9:** Launch + marketing
- **Week 10-12:** Monitor metrics, iterate

**Total:** 12 weeks to 2 live tools

---

## 📞 Quick Links

**Documentation:**
- [Requirements](01-requirements.md) - Full specification
- [Summary](SUMMARY.md) - Quick reference
- [Status](_status.md) - Current phase

**Related SDDs:**
- [Mobile App](../sdd-mobile-app/) - Main app business logic
- [Mobile App UI](../sdd-mobile-app-ui/) - Main app UI/UX
- [System Architecture](../sdd-system-architecture/) - Overall architecture

**Decision:**
- Approve P0 tools to proceed to SPECIFICATIONS
- Request changes to tool selection
- Approve full suite (all 7 tools)

---

**Last Updated:** 2025-12-31 by Claude (AI Assistant)
**Current Status:** SPECIFICATIONS completed ✅
**Next Milestone:** User approval → PLAN phase
**Timeline:** 6-8 weeks to first 2 tools live
**Expected Impact:**
- Direct revenue: $26K/month (P0 tools)
- Main app upsells: $3.8K/month
- Total: $30K/month ecosystem revenue

**Key Deliverables (Specs Phase):**
- ✅ Shared infrastructure design (Firebase Auth, RevenueCat, Analytics)
- ✅ Market Finder: 5 screens, 6 API endpoints, full data models
- ✅ Sweet Spot Analyzer: 5 screens, scoring algorithm, batch analysis
- ✅ Database schemas: PostgreSQL (counties) + Firestore (users, favorites)
- ✅ Testing strategy: Unit, integration, manual verification
