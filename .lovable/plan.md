# Secure commerce operations build

## Confirmed current state

- Checkout and order creation are in `src/lib/checkout.functions.ts`; the browser calls `startCheckout` from the cart panel.
- `makeReference()` combines a timestamp with only three non-cryptographic random characters, and `getOrderByReference` uses that value alone to return name, phone, address, notes, items, totals, and statuses.
- The order table is restricted to administrators for direct database reads, so the public lookup currently bypasses that protection through a privileged server function.
- Stripe and Paystack checkout initialization exists, but no order-return page or webhook handler currently consumes the provider callbacks.
- The database has products, orders, payment events, and a separate user roles table with row-level security; the current payment-events table lacks a uniqueness rule for provider event IDs.
- No authenticated route layout, admin dashboard, admin server functions, or product/order management screens currently exist.

## Build outcome

Deliver a production-grade storefront operations system with:

1. A secure customer order-return experience.
2. Verified Stripe and Paystack payment state.
3. An authenticated, role-protected admin workspace.
4. Safer operational controls for fulfilment, catalogue, and payment reconciliation.

## 1. Close the order-reference vulnerability first

- Separate the customer-facing order number from the private order-access capability.
- Generate the private capability with cryptographically secure randomness, store only a protected/opaque value, and enforce uniqueness in the database.
- Keep provider references separate from the customer-access token, so a value visible in payment URLs or provider records cannot unlock customer data.
- Change all checkout return URLs to carry the private capability, not the display reference.
- Replace the public lookup response with a minimum-necessary confirmation DTO: display reference, item summary, totals, currency, payment state, fulfilment state, and masked contact information. Do not return phone, address, or internal notes.
- Add token expiry and invalid/expired states. Add request throttling or an equivalent abuse-control boundary for unauthenticated lookups.
- Preserve a safe fallback for existing orders during migration, without exposing legacy references as permanent credentials.
- Add automated checks for enumeration attempts, malformed tokens, expired tokens, and PII absence.

## 2. Build the order-return page

Create `/order/$token` as a public, shareable return page that:

- Shows a clear order reference, payment state, fulfilment state, itemized totals, and next steps.
- Distinguishes pending, paid, failed, cancelled, and WhatsApp-routed orders.
- Explains that payment confirmation is authoritative only after the provider callback is received.
- Offers a safe retry-payment action when the original payment is incomplete, without creating duplicate orders.
- Includes a WhatsApp contact action using only the existing brand contact configuration.
- Handles unknown, expired, and temporarily unavailable orders without leaking whether another customer’s order exists.
- Has its own title, description, Open Graph metadata, and Twitter card metadata.

## 3. Implement verified payment webhooks

Add public webhook routes for both providers:

- Stripe: verify the raw request body and `Stripe-Signature` before parsing or writing.
- Paystack: verify the raw request body and `x-paystack-signature` before parsing or writing.
- Validate payloads with schemas and reject malformed or unsigned requests.
- Make processing idempotent using a unique provider/event ID constraint and a safe insert-before-update flow.
- Match orders using provider reference and a server-created amount/currency expectation; reject mismatches and log them without exposing provider details to customers.
- Update payment status, provider reference, paid timestamp, and fulfilment eligibility only after verified events.
- Store a compact payment-event audit record, avoiding raw card data and unnecessary personal data.
- Return provider-compatible success responses while keeping detailed errors in server logs.
- Add retry-safe handling for duplicate, out-of-order, and already-finalized events.

Provider credentials and webhook signing values will be requested only after the routes are deployed and their callback URLs are available.

## 4. Add authenticated admin operations

Create an authenticated admin area with a focused operations layout:

- Sign-in entry point and protected route group using the existing auth middleware and separate role table.
- Server-side role verification inside every admin server function; never rely on browser storage or route visibility alone.
- Dashboard overview with new orders, unpaid orders, fulfilment backlog, paid revenue by currency, and payment exceptions.
- Orders workspace with search, status filters, date range, currency/provider filters, pagination, and clear loading/error/empty states.
- Order detail view showing customer delivery details, line items, payment events, provider reference, fulfilment history, and internal notes.
- Controlled fulfilment transitions: New → Confirmed → Packed → Dispatched → Delivered, plus Cancelled, with invalid transitions rejected server-side.
- Admin notes and an audit trail recording who changed payment/fulfilment state and when.
- Safe WhatsApp reply links that do not expose private admin notes.
- Products workspace for create, edit, duplicate, publish/unpublish, archive, ordering, stock status, both currencies, options, minimum quantity, and Asoebi volume tiers.
- Explicit confirmation for destructive actions and clear unsaved-change handling.

## 5. Strengthen the data model and access controls

Use a reviewed Lovable Cloud migration to add:

- Unique constraints/indexes for display references, lookup capabilities, and provider event identities.
- Lookup-token expiry/revocation fields and a controlled retry/payment state.
- Order status history/audit records and administrator identity fields.
- Payment-event uniqueness and useful indexes for order/provider/date queries.
- Carefully scoped grants and row-level security for every new public table.
- Server-only privileged writes for checkout/webhooks, with ordinary admin reads and updates performed through authenticated user context where appropriate.
- Validation for allowed currencies, providers, payment states, fulfilment states, non-negative totals, and valid state transitions.
- Retention-minded handling for customer addresses, phones, notes, and payment audit data.

## 6. Recommended business features included in the design

These fit the current storefront and reduce operational risk:

- Asoebi event-date and quantity capture, with an admin urgency indicator for production timelines.
- Low-stock and “inquire for timeline” alerts visible in the operations dashboard.
- Payment exception queue for amount mismatches, failed callbacks, duplicate events, and abandoned checkouts.
- Customer notification hooks after payment confirmation and fulfilment milestones, designed so email or WhatsApp delivery can be enabled without exposing private data.
- Revenue reporting separated by NGN and GBP rather than mixing currencies.
- Catalogue change history for price and volume-tier edits, preventing silent pricing disputes.
- Order export for fulfilment and accounting, with PII access limited to authenticated administrators.

## Technical implementation order

1. Database migration for secure capabilities, uniqueness, expiry, event idempotency, and audit history.
2. Checkout refactor to create and return the secure order capability, with server-authoritative payment retry handling.
3. Verified Stripe and Paystack webhook routes and payment-state reconciliation.
4. Public order-return page and safe customer status DTO.
5. Authenticated admin shell, dashboard, order list/detail, status transitions, notes, and audit history.
6. Product management and operational alerts.
7. Automated security checks, browser checks for checkout/return/admin flows, webhook replay tests, and final security scan.

## Completion checks

- A guessed or legacy reference cannot retrieve customer PII.
- Only a valid, unexpired capability can retrieve the minimum public order summary.
- Unsigned, malformed, replayed, mismatched, and out-of-order provider events are handled safely.
- Admin pages redirect signed-out users and deny non-admin users at the server boundary.
- Every requested route has working loading, empty, error, and not-found states.
- Checkout, WhatsApp routing, provider returns, webhook updates, and admin fulfilment changes are verified in the running preview.
