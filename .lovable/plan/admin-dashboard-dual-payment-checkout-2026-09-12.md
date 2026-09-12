# Admin dashboard + dual payment checkout

## Where the store is today

Everything on the site is fixed in the code: the four products, their prices, images and stock labels. Orders are not recorded anywhere — checkout ends in a WhatsApp message and a confirmation screen. There is no login, no order history, and no real payment.

This plan adds the missing half of the store: a real database behind it, an admin area to run orders and products, and live payment through Stripe and Paystack.

## 1. Backend foundation

Turn on Lovable Cloud (database, logins, secure server code). Tables:

- **products** — name, category, variant, description, pattern, option list, NGN price, GBP price, volume tiers, stock status, images, published flag.
- **orders** — order reference, customer name, WhatsApp number, city, address, notes, item list, currency, subtotal, delivery fee, total, payment provider, payment status, fulfilment status, timestamps.
- **admin roles** — a separate roles table so only approved accounts reach the dashboard.

The storefront reads published products from the database, so the catalog, quick-view and cart all reflect what the admin sets. Your current four products are loaded in as starting data with their existing images and prices.

## 2. Admin dashboard (`/admin`)

Reachable only after signing in with an admin account.

- **Orders (main focus)** — table of every order with reference, customer, total, currency, payment status and fulfilment status. Search and filter by status. Open an order to see items, delivery details, notes and payment record; change fulfilment status (New → Confirmed → Packed → Dispatched → Delivered, plus Cancelled); one-tap WhatsApp reply to the customer; internal notes.
- **Products** — list, create, edit, duplicate, archive. Edit prices in both NGN and GBP, options, volume tiers for Asoebi, stock status, and upload images.
- **Header summary** — counts of new orders, unfulfilled orders, and paid revenue today/this month, so the order screen is useful at a glance.

Sign-in page for admins; the first admin account is granted the role directly in the database, and that admin can grant others.

## 3. Checkout with Stripe + Paystack

- The checkout detects the shopper's region. Nigeria and other African countries default to **Paystack** with NGN pricing; everywhere else defaults to **Stripe** with GBP pricing. A visible switch lets the shopper change provider and currency.
- Prices, delivery fee and totals redisplay in the chosen currency.
- Pressing pay creates the order in the database as *pending*, then sends the shopper to the provider's hosted checkout. Totals are always recalculated on the server from database prices, never trusted from the browser.
- On return, the shopper sees the existing confirmation screen with the order reference and payment status.
- Payment confirmation comes from the providers' webhooks, which verify their signatures and mark the order paid. The order only counts as paid once the provider confirms it.
- WhatsApp routing stays as a third option for shoppers who prefer to confirm with a stylist.

I will need two keys from you when we reach this step: your Stripe secret key and your Paystack secret key (plus each provider's webhook signing secret, which you create in their dashboards once the webhook addresses exist). I will ask for them through the secure key form — never paste them into chat.

## Technical notes

- Data access through `createServerFn` with an authenticated Supabase client; RLS on every table. Public read policy limited to published product columns. Orders readable only by admins; customer-facing status lookup by reference through a narrow server function.
- Admin routes live under `src/routes/_authenticated/admin/*` behind the managed auth gate, with a server-side `has_role(auth.uid(), 'admin')` check inside every admin server function — the route gate is UX only.
- Webhooks as server routes at `src/routes/api/public/webhooks/stripe.ts` and `.../paystack.ts`, verifying `stripe-signature` and Paystack's `x-paystack-signature` HMAC before writing, with idempotency on provider event id.
- Paystack charges in NGN (kobo), Stripe in GBP (pence). Both amounts stored per order; product rows carry both prices so no live FX conversion is needed.
- `src/data/catalog.ts` keeps its types and helpers (`unitPriceFor`, `formatNGN`, `buildSku`); the hardcoded `PRODUCTS` array is replaced by database reads and a money formatter that handles both currencies.

## Build order

1. Cloud + schema + seed existing products; storefront reads from database.
2. Admin sign-in, role check, orders screen, product management.
3. Stripe and Paystack checkout, webhooks, confirmation and admin payment status.
