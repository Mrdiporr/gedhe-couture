# Implementation audit: admin dashboard and dual payment checkout

## Verdict

The archived plan is **partially implemented, not fully complete**. The backend foundation and storefront catalog are present, and checkout initiation is present. The admin dashboard, authenticated admin experience, customer order-return page, and payment webhooks are not implemented.

## Evidence by claim

### Backend foundation — implemented

- Lovable Cloud tables exist: `products`, `orders`, `payment_events`, and `user_roles`.
- Row-level security is enabled on all four tables.
- The separate `user_roles` table exists and the role-check helper is now `private.has_role`; admin policies reference it.
- The catalog seed migration inserts four published products with both currencies, images, galleries, options, and Asoebi volume tiers.
- Live database read confirms 4 products and 4 published products.
- `src/lib/catalog.functions.ts` reads published products from the database, and `src/routes/index.tsx` supplies them to the storefront.
- Live browser check confirms 4 product cards, quick view, and no page errors.

### Admin dashboard — not implemented

- No `/admin` route exists; only the root route is registered.
- No authenticated route layout or sign-in page exists in `src/routes`.
- No admin server functions exist for orders, products, roles, summaries, status updates, or notes.
- No UI exists for order search/filter/detail, fulfilment transitions, WhatsApp replies, product management, image upload, or revenue summaries.
- The database contains zero orders and zero payment events, so these workflows have not been demonstrated live.

### Checkout initiation — partially implemented

- Region-aware currency detection exists in `src/data/catalog.ts`, using the browser time zone to default Africa to NGN and elsewhere to GBP.
- The checkout visibly switches between NGN/Paystack and GBP/Stripe, with WhatsApp as the third route.
- `src/lib/checkout.functions.ts` prices products from database rows and creates pending orders.
- Stripe and Paystack hosted-checkout initialization code exists, but it depends on provider secrets that are not referenced as configured in the project secrets shown for this audit.
- Server totals are recalculated from database prices; the client totals are display-only.

### Order return and payment confirmation — not implemented

- Checkout URLs point to `/order/{reference}`, but no order route exists.
- A live browser check of `/order/TEST-REFERENCE` returns the default 404 page.
- `getOrderByReference` exists, but no page consumes it.
- No Stripe webhook route exists.
- No Paystack webhook route exists.
- No signature verification, idempotency handling, payment-event insertion, or paid-order update exists.
- Therefore payment status cannot currently be confirmed by provider callbacks.

### Technical notes — partially implemented or inaccurate

- Public product reads use a public server client and a narrow published-product policy.
- Checkout and public order lookup currently use the privileged server client rather than an authenticated user client; this differs from the plan's stated access model.
- The database policies restrict admin reads and writes through `private.has_role`, but the application-side admin checks and protected admin server functions do not yet exist.
- The catalog hardcoded product list was replaced by database reads, while the catalog types and money/SKU helpers remain.

## Build-order status

1. **Cloud + schema + seed + storefront database reads:** complete, with the security-helper migration also completed.
2. **Admin sign-in, role check, orders, product management:** not started.
3. **Stripe/Paystack webhooks, confirmation page, admin payment status:** checkout initiation is present; the webhook and confirmation portions are not started.

## Conclusion

The plan cannot be confirmed as fully implemented. The accurate status is: **foundation complete; storefront catalog complete; checkout start partially complete; admin and payment-confirmation systems incomplete**.
