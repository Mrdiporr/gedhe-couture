# Ankara Elegance Hub

[SYSTEM INSTRUCTION: UNANIMOUS, REALISTIC, PREMIUM AGENCY-GRADE SINGLE BUILD PROMPT]
You are the Master Orchestrator Agent. Your task is to generate a fully production-ready, highly polished, premium agency-grade E-Commerce frontend build for the Ankara fashion brand "@3kbelowankara". 

The brand specializes in affordable luxury, providing 100% Cotton Ankara fabrics (3 yards), ready-to-wear pieces (Bubu Gowns, Palazzo Trousers), and high-volume Asoebi bulk supplies.

This single build must bridge elite, premium aesthetic design with strict transactional utility, operating via deterministic quality gates and structural modularity.

---

### SECTION 1: ARCHITECTURAL SPECIFICATIONS & TECH STACK

Build a single-page reactive application framework with an elegant, responsive fluid layout optimized heavily for mobile devices (the primary traffic driver for Instagram social commerce).

- Framework: Tailwind CSS + Native JavaScript Components (or React/Next.js equivalent component states).
- Architectural Rule: Rigid separation of core UI rendering logic from the e-commerce product schema data engine.
- State Management: Centralized transactional state to track active filters, catalog views, and cart volume.

---

### SECTION 2: THE VISUAL & BRAND EXPERIENCE SYSTEM (Premium Discipline)

The visual design must immediately bridge the gap between "accessible pricing" and "luxury aesthetic." 

- Color Palette: Rich, premium earthy luxury tones combined with minimalist structures to let the vibrant Ankara patterns stand out.
  - Primary Base: Deep Midnight Charcoal (#1A1A1A) / Soft Linen Off-White (#FBF9F6).
  - Accents: Burnished Warm Gold (#D4AF37) / Muted Clay Terracotta (#C57B57).
- Typography: High-contrast editorial style. Serif headers paired with ultra-clean sans-serif body text.
- Media Containers: Edge-to-edge product cards with subtle image zoom actions, preserving pattern clarity and detail.

---

### SECTION 3: CORE COMPONENT LAYOUTS & USER JOURNEY

#### 1. Premium Editorial Hero Section
- High-impact header: "Affordable Ankara, Premium Heritage."
- Value Proposition Matrix: Clear badges highlighting "100% Cotton Fabrics," "Ready-to-Wear Polish," and "Asoebi Bulk Supply Specialists."
- Call to Action: A prominent "Explore the Catalog" primary button featuring a smooth magnetic hover state.

#### 2. Fully Decoupled Catalog Layout & Smart Merchandising Grid
- Component Architecture: A sticky filter bar enabling instant switching between product verticals:
  1. 3-Yard Cotton Ankara (Fabric Catalog)
  2. Ready-To-Wear (Bubu Gowns, Palazzo Trousers)
  3. Asoebi Bulk Ordering (With integrated volume pricing rules)
- Catalog-SEO Micro-Layout: Every product container must cleanly isolate product titles, real-time stock indicators, and pricing typography.

#### 3. Frictionless Transactional Checkout Panel (Cart-Friction Mitigation)
- Design Framework: A slide-out panel that maintains a continuous checkout flow.
- Structural Gates: A clear 3-step checkout flow architecture built natively into the UI:
  1. Product Overview (Itemized variants with clear SKU definitions)
  2. Order Routing Details (Structured inputs for shipping coordinates and delivery notes)
  3. Integrated Payment Gateways (Mock-ups for local card gateways, bank transfers, and direct WhatsApp Order routing handles)

---

### SECTION 4: DETERMINISTIC QUALITY GATE MATRIX (AOS Core Engine Compliance)

Before completing the build, the layout must pass through the following integrated QA guardrails:

1. Entry Gate Check: Ensure all product card layouts consume structured metadata objects including titles, patterns, price attributes, and availability status.
2. Exit Gate Check: Validate that all interactive states—including variant adjustments, size options, filter toggles, and cart volume updates—operate deterministically with clear visual feedback.
3. The Transactional Trust Rule: The checkout UI must explicitly display dynamic security indicators, payment processing micro-copy, and data privacy notifications to minimize user friction.

---

### SECTION 5: INITIALIZING PRODUCT DATA SCHEMA (JSON Data Core)

Embed this exact product catalog model straight into the frontend code to populate the user interface:

```json
{
  "brand": "3kbelowankara",
  "currency": "NGN",
  "products": [
    {
      "id": "ank-001",
      "name": "Premium 100% Cotton Ankara",
      "category": "Fabrics",
      "variant": "3-Yard Bundle",
      "base_price": 3000,
      "stock_status": "In Stock",
      "description": "Authentic, high-grade cotton weave featuring traditional vibrant print styling."
    },
    {
      "id": "rtw-002",
      "name": "Elegance Bubu Gown",
      "category": "Ready-to-Wear",
      "variant": "Free Size",
      "base_price": 12500,
      "stock_status": "Limited Stock",
      "description": "Flowing, sophisticated silhouette engineered for modern everyday luxury."
    },
    {
      "id": "rtw-003",
      "name": "Tailored Palazzo Trousers",
      "category": "Ready-to-Wear",
      "variant": "Adjustable Waist",
      "base_price": 8500,
      "stock_status": "In Stock",
      "description": "Wide-leg cut with premium pattern alignment across all structural seams."
    },
    {
      "id": "aso-004",
      "name": "Custom Asoebi Bulk Supply",
      "category": "Asoebi",
      "variant": "Minimum 10 Packs",
      "base_price": 2800,
      "stock_status": "Inquire for Timeline",
      "description": "High-volume fabric pairing and coordination tailored for traditional event 


For visual representation of the business see social-media page here https://www.instagram.com/3kbelowankara gather as much business information as you can if needed.

sizing."
    }
  ]
}
```

---

[EXECUTION DIRECTIVE]
Generate the complete single-file or modular frontend build. Output fully commented, production-grade markup, layout structures, styling files, and interactive scripts. Ensure every interaction adheres strictly to the elite, unanimous, realistic, and premium agency-grade benchmark.

This project was built with [Lovable](https://lovable.dev).

**Live app**: https://ankara-heritage-shop.lovable.app

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/ac505079-b9d7-4127-91cc-06cac9d8598c).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
