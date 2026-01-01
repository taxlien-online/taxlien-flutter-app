# Mobile App UI/UX - Quick Reference

> Last Updated: 2025-12-31
> Status: REQUIREMENTS phase (DRAFT ✅)

## 🎯 One-Liner

Дизайн **Learn-to-Earn интерфейса** для TAXLIEN.online Flutter app с фокусом на конверсию, gamification и образовательный experience.

---

## 🎨 Design Philosophy

### Core Principles
1. **Conversion-First** - каждый экран движет к Premium подписке
2. **Educational** - Learn-to-Earn = образование разблокирует функции
3. **Gamification** - progress bars, badges, achievements
4. **Clarity** - простые, интуитивные flows
5. **Delight** - микроанимации, визуальная обратная связь

---

## 📱 Priority Screens (8)

### 1. Onboarding Flow (5 screens)
```
Step 1: Welcome → Value proposition
Step 2: Learn-to-Earn → Feature unlock explanation
Step 3: Pricing tiers → Free vs Starter vs Premium
Step 4: Permissions → Notifications + Analytics
Step 5: Ready! → Trial confirmation
```

### 2. Course Home
- Module cards (expandable accordion)
- Progress tracking (overall + per-module)
- Locked content badges (STARTER, PREMIUM)
- Upgrade CTAs

### 3. Video Lesson
- Vimeo player embed (16:9)
- Progress bar + timer
- Transcript (expandable)
- "Mark as Complete" CTA

### 4. Quiz
- Question progress (3/5 with dots)
- Multiple choice options
- Results screen (score, passed/failed, unlock notification)
- Retry capability

### 5. Paywall (3 variations)
- **Feature limit:** "You've used 10/10 searches"
- **Full comparison:** Free vs Starter vs Premium table
- **Trial ending:** Countdown timer + urgency

### 6. AI Analysis
- Property photo + details
- Gauge chart (redemption probability)
- Risk meter (0-100 with color)
- Bar chart (top 5 factors)
- Recommendation (BUY/AVOID)
- Share PDF + Save to Portfolio

### 7. Achievement Unlock
- Full-screen modal
- Confetti animation
- Badge (large, animated)
- Points earned
- Progress to next level
- Share on LinkedIn

### 8. Referral Dashboard
- Referral code (tap to copy)
- Share buttons (SMS, Email, WhatsApp)
- Stats cards (total referrals, pending, paid)
- Progress to NFT unlock
- Recent referrals list

---

## 🎨 Design System

### Color Palette

| Use Case | Color | Hex |
|----------|-------|-----|
| **Primary** | Deep Blue | #1E3A8A |
| **Primary Light** | Blue | #3B82F6 |
| **Secondary** | Gold | #F59E0B |
| **Success** | Green | #10B981 |
| **Warning** | Amber | #F59E0B |
| **Error** | Red | #EF4444 |

### Typography (Inter)

```
H1: 32px Bold      (Screen titles)
H2: 24px SemiBold  (Section titles)
H3: 20px SemiBold  (Card titles)
Body: 16px Regular (Main content)
Small: 12px Regular (Captions)
```

### Spacing (8px grid)

```
xs:  4px   (tight)
sm:  8px   (small)
md:  16px  (default)
lg:  24px  (section)
xl:  32px  (large)
2xl: 48px  (extra large)
```

### Border Radius

```
sm:   4px   (tags)
md:   8px   (cards)
lg:   12px  (buttons)
xl:   16px  (modals)
full: 999px (pills)
```

---

## 🧩 Component Library (10 Key Components)

### 1. Buttons
- Primary (gradient background, prominent)
- Secondary (outlined, less prominent)
- Text (minimal, legal links)
- Icon (circular background)

### 2. Cards
- Property card (image + metrics + AI badge)
- Module card (title + progress + lock badge)
- Pricing card (3 tiers comparison)
- Stat card (icon + number + label)

### 3. Progress Indicators
- Linear progress bar (0-100%)
- Circular gauge (redemption probability)
- Stepper (horizontal dots: ● ○ ○ ○ ○)

### 4. Badges & Tags
- Achievement badge (gradient + icon)
- Risk level badge (color-coded: LOW/MEDIUM/HIGH)
- Status tag (Active/Pending/Sold)

### 5. Charts
- Horizontal bar chart (AI feature importance)
- Pie chart (risk distribution)
- Gauge chart (redemption probability)

### 6. Modals & Overlays
- Bottom sheet (feature paywall, draggable)
- Full-screen modal (achievement unlock)
- Alert dialog (confirmations)

### 7. Video Player
- Vimeo embed (16:9 aspect ratio)
- Custom controls (play/pause, scrub, fullscreen)
- Progress tracking

### 8. Forms
- Text input (email, password)
- Dropdown (county selection)
- Toggle switch (Monthly/Annual)
- Checkbox/Radio buttons

### 9. Lists
- Property list (search results)
- Lesson list (course content)
- Referral list (dashboard)

### 10. Navigation
- Bottom nav bar (5 tabs)
- Top app bar (with back button)
- Tab bar (filters, categories)

---

## 🎯 User Flows

### Learn-to-Earn Flow

```
Sign Up (Free)
   ↓
Onboarding (5 screens)
   ↓
Module 1: "Tax Lien Basics" (19 min)
   ↓ Quiz passed (80%+)
UNLOCK: Search (10/day)
   ↓
After 10th search → PAYWALL
   ↓ Option A: Upgrade to STARTER ($19.99)
Module 2: "Property Research" (18 min)
   ↓ Quiz passed
UNLOCK: Unlimited searches, 50 counties
   ↓
After 10th AI analysis → PAYWALL
   ↓ Option B: Upgrade to PREMIUM ($49.99)
Module 3-5: Full course (97 min)
   ↓ All quizzes passed
UNLOCK: All features (AI, NFT, analytics)
   ↓
ACHIEVEMENT: "Tax Lien Master" + Certificate
```

### Paywall Conversion Flow

```
User hits limit (search/AI/portfolio/county)
   ↓
Trigger-specific paywall appears
   ↓
User sees comparison (Free vs Starter vs Premium)
   ↓
User sees value props ("Unlock AI worth $297/mo")
   ↓
User sees social proof ("10,000+ investors")
   ↓
User sees urgency ("Trial ending in 3 days")
   ↓
User taps "Start 14-Day Free Trial"
   ↓
In-app purchase flow (RevenueCat)
   ↓
Subscription activated → All features unlocked
```

---

## 📊 Success Metrics

### UI/UX KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| Onboarding completion | 70% | Firebase funnel |
| Paywall conversion | 10% | Views → Subscriptions |
| Course completion | 50% | Completions / Starts |
| DAU/MAU | 30% | Firebase Analytics |
| Session duration | 8 min | Firebase Analytics |

### Technical KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| Page load time | <2 sec | Firebase Performance |
| Animation FPS | 60 fps | Flutter DevTools |
| Crash-free rate | 99.9% | Crashlytics |
| Accessibility score | 95%+ | Scanner |

---

## 🎬 Animations & Microinteractions

### Onboarding
- Slide transitions (left to right)
- Stepper animation (dots grow/shrink)
- Confetti on "Ready to Go!"

### Course
- Progress bar fill animation (smooth easing)
- Checkmark appear (scale + fade)
- Badge zoom in + pulse

### Paywall
- Slide up from bottom (modal)
- Comparison table fade in (staggered)
- Toggle switch flip

### AI Analysis
- Gauge chart animated fill (0% → 78.5%)
- Risk meter color shift (green → amber → red)
- Bar chart animated width

### Achievement
- Full-screen overlay fade in
- Confetti particles falling (physics)
- Badge scale + rotate
- Sound effect (optional)

---

## 🚨 Critical Design Decisions

### 1. Onboarding Length
**Decision:** 5 screens (not 10+)
**Reason:** Balance education vs friction. Can skip but incentivized to complete.

### 2. Paywall Timing
**Decision:** Trigger-based (not time-based)
**Reason:** Show paywall when user sees value (after 10 searches), not arbitrary time.

### 3. Video Player
**Decision:** Vimeo embed (not custom)
**Reason:** Faster implementation, better DRM, adaptive bitrate.

### 4. Dark Mode
**Decision:** Full support (all screens)
**Reason:** User preference, battery life (OLED), modern standard.

### 5. Gamification Extent
**Decision:** Moderate (badges, points, levels)
**Reason:** Motivating but not childish. Financial app needs trust.

### 6. Tablet Layout
**Decision:** Use mobile layout (no custom tablet)
**Reason:** 95% users on mobile. Tablet optimization = Phase 2.

---

## 🔗 Integration Points

### Backend Services
- **Mobile App SDD:** Business logic, state management
- **ML Service:** AI predictions API
- **Payment Service:** Stripe, RevenueCat

### Firebase
- **Analytics:** Event tracking, funnels
- **Crashlytics:** Error reporting
- **Remote Config:** A/B testing, feature flags
- **Auth:** Email, Google, Apple sign-in

### Third-Party
- **Vimeo:** Video hosting + player
- **RevenueCat:** IAP management
- **Stripe:** Payment processing

---

## 📁 Deliverables

### Requirements Phase ✅
- [x] User stories (8 primary)
- [x] Screen wireframes (ASCII art)
- [x] Component specs
- [x] Animation specs
- [x] Success metrics

### Specifications Phase (Next)
- [ ] Figma mockups (high-fidelity)
- [ ] Interactive prototypes
- [ ] Component library (Storybook-style)
- [ ] Responsive behavior specs
- [ ] Animation timings (easing curves)

### Plan Phase
- [ ] Flutter widget hierarchy
- [ ] State management approach
- [ ] Navigation structure
- [ ] Testing strategy
- [ ] Implementation timeline

### Implementation Phase
- [ ] Build reusable widgets
- [ ] Implement screens (8 priority)
- [ ] Add animations
- [ ] Accessibility audit
- [ ] Performance optimization

---

## ⚠️ Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| **Design inconsistency** | Medium | Use design system, component library |
| **Poor video playback** | High | Test on low-end devices, adaptive bitrate |
| **Paywall App Store rejection** | High | Follow Apple guidelines, clear disclosures |
| **Accessibility issues** | Medium | VoiceOver testing, Dynamic Type |
| **Animation jank** | Medium | Optimize, use Hero widgets |

---

## 🎓 Design References

### Inspiration
- **Duolingo** - Gamification, progress tracking
- **Headspace** - Onboarding, calm UI
- **Robinhood** - Financial data visualization
- **Masterclass** - Video lessons, course structure
- **Notion** - Clean cards, minimal design

### Resources
- **Material Design 3** - Component guidelines
- **Flutter Widget Catalog** - Widget examples
- **undraw.co** - Illustrations (free)
- **heroicons.com** - Icons (free)

---

## 📞 Quick Links

**Documentation:**
- [Requirements](01-requirements.md) - Full UI/UX specification (1,417 lines)
- [Status](_status.md) - Current phase, blockers, progress

**Related SDDs:**
- [sdd-mobile-app](../sdd-mobile-app/) - Business logic, backend integration
- [sdd-system-architecture](../sdd-system-architecture/) - Overall system design

**Design Tools:**
- Figma (optional) - High-fidelity mockups
- Flutter DevTools - Performance profiling
- Accessibility Scanner - Audit tool

---

**Last Updated:** 2025-12-31 by Claude (AI Assistant)
**Current Status:** REQUIREMENTS drafted ✅
**Next Milestone:** SPECIFICATIONS (Figma mockups, component library)
**Timeline:** 6-8 weeks to full implementation
**Team:** 1 Designer + 2 Flutter Developers
**Expected Impact:** 10%+ conversion rate, 70%+ onboarding completion
