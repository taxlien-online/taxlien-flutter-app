# Requirements: Educational Products Store

> Version: 1.0
> Status: DRAFT
> Last Updated: 2025-12-30

## Problem Statement

### Untapped Content Monetization

We have high-quality educational content in `3rdparty/awesomely/` but it's currently not monetized:

**Existing Assets:**
- ✅ Tax Yields Guidebook (2,434 lines of educational content)
- ✅ Phone scripts for county research
- ✅ State-by-state cheat sheets
- ✅ Portfolio tracking templates

**Current State:** These sit unused on disk, generating $0 revenue.

**Opportunity:**
- Package as digital products
- Sell standalone OR bundle with Premium subscription
- **99% profit margin** (zero marginal cost for digital goods)
- **Quick implementation:** 3-4 days to launch
- **Immediate revenue:** $1K-3K in first month

### Missing In-App Store

Users who want to learn but can't afford $49.99/month Premium have no option to purchase educational content separately. We're losing:
- Price-sensitive customers
- One-time buyers (vs subscription commitment)
- Course completion dopamine (gamification)

---

## User Stories

### Primary

#### Story 1: Budget-conscious learner wants to buy just the course

**As a** beginner investor with limited budget
**I want** to buy just the educational course ($47-297) without a monthly subscription
**So that** I can learn at my own pace without recurring costs

**Scenario:**
- User downloads free app
- Explores and realizes they need education
- Sees "Store" tab with courses
- Purchases "Tax Lien Master Course" for $297 one-time
- Gets immediate access to all lessons

#### Story 2: Premium user wants downloadable guides

**As a** Premium subscriber
**I want** downloadable PDF guides and templates
**So that** I can reference them offline and share with my accountant

**Scenario:**
- Premium user unlocks all in-app lessons
- Wants a PDF version for printing
- Purchases "Complete Guidebook PDF Bundle" for $97
- Downloads high-quality PDF to device

#### Story 3: Free user tests with low-cost product

**As a** skeptical user who doesn't trust the platform yet
**I want** to buy a cheap starter product ($27-47)
**So that** I can test the quality before committing to Premium

**Scenario:**
- User on 14-day trial, not sure about Premium
- Sees "County Research Templates" for $47
- Buys it to test quality
- Impressed, upgrades to Premium later

---

### Secondary

#### Story 4: Gift buyer purchases for a friend

**As a** user who wants to help a friend get started
**I want** to gift a course via email
**So that** my friend can start learning without payment friction

#### Story 5: Affiliate partner earns commission

**As a** real estate blogger or influencer
**I want** to promote tax lien courses and earn 20% commission
**So that** I can monetize my audience

---

## Product Catalog

### Tier 1: Entry Products ($27-47)

#### Product 1: County Research Starter Kit - $47

**Contents:**
- Phone script templates (from 3rdparty/awesomely)
- State-by-state redemption period cheat sheet
- Top 50 counties ranked by ROI
- Email templates for county tax offices

**Format:** PDF bundle (3-4 files)
**Delivery:** Instant download via email
**Target Customer:** New investors, DIY researchers

---

#### Product 2: Portfolio Tracker Templates - $27

**Contents:**
- Excel/Google Sheets template
- Pre-built formulas for ROI calculation
- Redemption timeline tracker
- Tax payment schedule

**Format:** .xlsx + Google Sheets link
**Delivery:** Download link via email
**Target Customer:** Active investors managing multiple liens

---

### Tier 2: Core Products ($97-147)

#### Product 3: Complete Tax Lien Guidebook (PDF) - $97

**Contents:**
- Full 3rdparty/awesomely guidebook formatted as beautiful PDF
- 100+ pages with illustrations
- Case studies with real numbers
- Worksheets and checklists

**Format:** PDF (designed in Canva or similar)
**Delivery:** Instant download
**Target Customer:** Serious learners who want offline reference
**Production Cost:** $200-500 (one-time Canva design)

---

#### Product 4: Video Course Bundle - $147

**Contents:**
- 10-15 videos (10 minutes each)
- Screen recordings of app usage
- County research walkthrough
- Live auction participation demo

**Format:** Hosted on Vimeo/YouTube (private links)
**Delivery:** Email with access links
**Target Customer:** Visual learners
**Production Cost:** $1,000-2,000 (Fiverr/Upwork video editing)
**Timeline:** Record in 1 week, edit in 1 week

---

### Tier 3: Premium Products ($297+)

#### Product 5: Tax Lien Master Course - $297

**Contents:**
- ALL educational content (guidebook + videos + templates)
- Bonus: 30-minute 1-on-1 consultation call
- Lifetime updates to course materials
- Private community access (Discord/Circle)

**Format:** Multi-format bundle
**Delivery:** Custom course portal or Gumroad library
**Target Customer:** Committed learners, high LTV customers
**Upsell:** "Includes everything from Store, save $200+"

---

#### Product 6: Enterprise Training Package - $997

**Contents:**
- All Master Course content
- White-label version for training employees
- Group licenses (up to 10 users)
- Quarterly Q&A webinars

**Format:** LMS platform or Google Classroom
**Delivery:** Custom onboarding
**Target Customer:** Investment firms, real estate agencies
**Sales:** Direct outreach, not self-serve

---

## Pricing Strategy

### Product Ladder (Ascending Value)

```
FREE → Portfolio Tracker (email capture)
  ↓
$27 → Templates
  ↓
$47 → County Research Kit
  ↓
$97 → Guidebook PDF
  ↓
$147 → Video Course
  ↓
$297 → Master Course (BEST VALUE)
  ↓
$49.99/mo → Premium App Subscription (recurring)
  ↓
$997 → Enterprise Training
```

### Bundle Discounts

**Bundle 1: "Starter Pack"** - $97 (save $77)
- County Research Kit ($47)
- Portfolio Tracker ($27)
- Guidebook PDF ($97)
- Regular price: $171 → Bundled: $97

**Bundle 2: "Complete Package"** - $297 (save $194)
- ALL individual products (would be $491)
- Bundled: $297

**Bundle 3: "Premium Upgrade"** - $49.99/mo
- All educational products included
- Plus live app features
- Best ongoing value

---

## Acceptance Criteria

### Must Have

#### 1. In-App Store Tab

**Given** user opens the app
**When** they navigate to bottom tab bar
**Then** they see a "Store" tab (shopping bag icon)

**UI Mockup:**
- Icon: 🛒 Shopping bag
- Position: 4th tab (Home, Search, Portfolio, Store, Profile)
- Badge: "New" label for first 30 days

#### 2. Product Catalog Page

**Given** user taps Store tab
**When** catalog page loads
**Then** display all products in cards:

**Card Contents:**
- Product image/thumbnail
- Title
- Price
- "Best Value" badge (for bundles)
- Short description (2-3 lines)
- "Buy Now" CTA button

**Layout:** Grid (2 columns on mobile, 3 on tablet)

#### 3. Product Detail Page

**Given** user taps a product card
**When** detail page opens
**Then** show:
- Hero image
- Full description
- "What's Included" checklist
- Customer testimonials (future)
- "Buy Now" button
- "Add to Cart" button (future)

#### 4. Stripe Payment Integration

**Given** user taps "Buy Now"
**When** checkout flow starts
**Then** redirect to Stripe Checkout hosted page

**Implementation:**
```dart
// lib/services/store_service.dart
class StoreService {
  Future<void> purchaseProduct(String productId) async {
    final checkoutUrl = await getStripeCheckoutUrl(productId);
    await launchUrl(Uri.parse(checkoutUrl));
  }
}
```

**Stripe Products to Create:**
- county_research_kit: $47
- portfolio_tracker: $27
- guidebook_pdf: $97
- video_course: $147
- master_course: $297

#### 5. Purchase Confirmation & Delivery

**Given** user completes Stripe checkout
**When** payment succeeds
**Then** system:
1. Sends confirmation email with download links
2. Unlocks product in app (if applicable)
3. Tracks purchase in Firebase Analytics
4. Shows "Thank you" screen in app

**Email Template:**
```
Subject: Your Tax Lien Master Course is Ready!

Hi {name},

Thanks for purchasing {product_name}!

Your download links:
[Download Guidebook PDF]
[Watch Video Course]
[Get Templates]

These links are active for 90 days.

Questions? Reply to this email.

- TAXLIEN.online Team
```

#### 6. Purchased Products Access

**Given** user has purchased a product
**When** they return to Store tab
**Then** show "Purchased" badge on product cards

**Additional:**
- "Download Again" button
- "Access Course" button (if video course)

---

### Should Have

#### 7. Abandoned Cart Email

**Given** user adds product to cart but doesn't checkout
**When** 24 hours pass
**Then** send email reminder with 10% discount code

**Email:**
```
Subject: You left something in your cart... here's 10% off

Hi {name},

You were checking out {product_name} but didn't complete your purchase.

Use code COMPLETE10 for 10% off (valid 48 hours).

[Complete Purchase →]
```

#### 8. Product Bundles

**Given** user viewing individual products
**When** they scroll to bottom
**Then** show "Save with Bundles" section

**Dynamic Bundling:**
- If viewing County Kit → suggest "Starter Pack Bundle"
- If viewing multiple products → "You could save $X with Master Course"

#### 9. Gift Purchase Option

**Given** user wants to gift a course
**When** on product page
**Then** show "Buy as Gift" toggle

**Flow:**
1. User enters recipient email
2. Optional: Add personal message
3. Checkout
4. Recipient gets email: "You received a gift from {name}!"

#### 10. Affiliate Link Support

**Given** influencer wants to promote products
**When** they sign up for affiliate program
**Then** receive unique tracking links

**Commission:** 20% of sale
**Tracking:** Via UTM parameters + Stripe metadata
**Payout:** Monthly via PayPal (minimum $100)

---

### Won't Have (This Iteration)

- **Shopping cart** (one-click purchase only for v1)
- **Installment payments** (future: Affirm, Klarna integration)
- **Subscription option** for courses (Premium sub already exists)
- **Course progress tracking** (that's in the in-app education SDD)
- **User reviews/ratings** (future: social proof)
- **Course forums** (future: community feature)

---

## Technical Constraints

### Platform Requirements

- **Must** work on iOS, Android, Web
- **Must** use Stripe for payments (already chosen)
- **Must** integrate with existing Firebase Analytics
- **Must NOT** require custom backend (use Stripe webhooks + Vercel functions)

### Payment Flow

**Option A: Stripe Payment Links (Recommended for MVP)**
```dart
const productUrls = {
  'county_kit': 'https://buy.stripe.com/abc123',
  'guidebook': 'https://buy.stripe.com/def456',
  // Pre-generated in Stripe Dashboard
};
```

**Pros:**
- Zero backend code needed
- Stripe handles checkout UI
- Mobile-optimized automatically
- PCI compliance automatic

**Cons:**
- Less customization
- Redirect out of app

**Option B: Gumroad**
```dart
const gumroadLinks = {
  'master_course': 'https://taxlien.gumroad.com/l/master',
};
```

**Pros:**
- Affiliate system built-in
- Email delivery automatic
- Beautiful checkout
- Analytics dashboard

**Cons:**
- 10% fee (vs Stripe 2.9%)
- Less control

**Decision:** Start with Stripe Payment Links (cheaper fees), migrate to custom Stripe Checkout later if needed.

### Product Delivery

**Digital Downloads:**
- Host PDFs on Firebase Storage or S3
- Generate time-limited signed URLs (valid 90 days)
- Email via SendGrid or Mailgun

**Video Courses:**
- Host on Vimeo (private videos)
- OR: YouTube (unlisted videos)
- Send access links via email

**In-App Unlocks:**
- Store purchase records in Firestore
- Check entitlement before showing content
```dart
Future<bool> hasPurchased(String productId) async {
  final doc = await FirebaseFirestore.instance
    .collection('purchases')
    .doc('$userId-$productId')
    .get();
  return doc.exists;
}
```

---

## Revenue Projections

### Conservative Estimates (First 3 Months)

**Month 1:**
- 100 app users
- 10 purchases (10% conversion)
- Average order value: $100
- Revenue: **$1,000**

**Month 2:**
- 300 app users
- 30 purchases
- AOV: $120 (more bundle sales)
- Revenue: **$3,600**

**Month 3:**
- 500 app users
- 50 purchases
- AOV: $150
- Revenue: **$7,500**

**Year 1 Target:** $50,000 in product sales (separate from subscriptions)

### Costs

**One-Time:**
- PDF design (Canva): $200
- Video production: $1,500
- **Total:** $1,700

**Recurring:**
- Stripe fees (2.9% + $0.30): ~$3 per $100 sale
- Email delivery (SendGrid): $15/month
- Video hosting (Vimeo): $20/month
- **Total:** ~$35/month + 3% transaction fees

**Profit Margin:** 94-97%

---

## Open Questions

- [ ] **Content packaging:** Reuse in-app education content or create separate "course" versions?
- [ ] **Stripe vs Gumroad:** Which platform for MVP? (Recommendation: Stripe for lower fees)
- [ ] **Delivery automation:** Use Zapier/Make.com or custom Vercel functions?
- [ ] **Video hosting:** Vimeo, YouTube, or Wistia?
- [ ] **Pricing validation:** A/B test $297 vs $397 for Master Course?
- [ ] **Bundle strategy:** Auto-discount bundles or manual promo codes?
- [ ] **Affiliate program:** Launch immediately or wait until Month 2?

---

## Success Metrics

**Week 1-2 (Setup):**
- [ ] Stripe products created
- [ ] PDFs designed and uploaded
- [ ] Store UI implemented in app
- [ ] First test purchase completed

**Month 1:**
- 10+ purchases
- $1,000+ revenue
- 90%+ delivery success rate (emails received)
- <1% refund rate

**Month 3:**
- 50+ purchases
- $7,500+ revenue
- 15%+ product-to-Premium conversion (product buyers upgrade to subscription)
- 4.5+ star average rating (from customer feedback)

**Key Metrics to Track:**
1. **Conversion Rate:** Store page views → purchases
2. **AOV (Average Order Value):** Track bundle uptake
3. **Product Mix:** Which products sell best?
4. **Upsell Rate:** % of product buyers who later subscribe
5. **Refund Rate:** Target <2%

---

## References

- Existing content: [3rdparty/awesomely/Tax-Yields-Guidebook.md](/Users/anton/proj/TAXLIEN.online/3rdparty/awesomely/Tax-Yields-Guidebook.md)
- Business plan: [.claude/plans/hashed-petting-fox.md](/Users/anton/.claude/plans/hashed-petting-fox.md)
- Competitor pricing:
  - Udemy tax lien courses: $49-199
  - Real estate investor courses: $297-997
  - Specialized bootcamps: $1,997+
- Platform options:
  - Stripe Payment Links: https://stripe.com/payments/payment-links
  - Gumroad: https://gumroad.com/features
  - Teachable: https://teachable.com (overkill for MVP)

---

## Approval

- [ ] Reviewed by: Anton (Product Owner)
- [ ] Approved on: [Pending review]
- [ ] Notes: Validate that packaging 3rdparty/awesomely content for sale doesn't violate any licensing (assuming it's our own content or public domain)
