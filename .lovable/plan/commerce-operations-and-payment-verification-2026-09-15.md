# Commerce operations and payment verification

## Outcome

Build and verify a secure operations workflow around the existing storefront, using the current four products temporarily and Paystack test mode for the payment walkthrough.

## User-facing pages

- Add a secure email/password `/login` page for staff access. No profile table will be added; administrator access remains in the separate role table.
- Add a protected `/admin` workspace with:
  - Overview metrics for new, unpaid, paid, and fulfilment-backlog orders.
  - Searchable and filterable order list.
  - Order detail with customer delivery data, line items, payment events, internal notes, and fulfilment status controls.
  - Product editing for prices, options, minimum quantities, volume tiers, stock status, images, publishing, and display order.
  - Server-side admin checks for every read and write; browser visibility alone will never authorize access.
- Add `/order-return`, where a customer can paste or enter the secure payment token.
- Add the token-backed order result page at `/order/$token`, showing only the minimum status summary, item totals, masked contact detail, payment state, and fulfilment state.
- Link checkout and provider callbacks to the return flow, including pending, paid, failed, expired, and unknown-token states.

## Payment processing

- Wire Paystack and Stripe webhook endpoints using raw-body signature verification.
- Validate payloads, provider references, amount, currency, and expected order state before changing an order.
- Record compact, idempotent payment events and safely handle duplicate, replayed, delayed, failed, or out-of-order callbacks.
- Mark orders paid only after a verified provider event; keep payment failures and mismatches visible to administrators.
- Add the required Paystack and Stripe credentials/signing values through the secure secret flow, never in source code.

## Data and security

- Preserve the existing opaque, hashed, expiring lookup-token design and reduced public order response.
- Add any missing server functions, audit writes, indexes, and admin policies with explicit grants and separate role checks.
- Reject invalid fulfilment transitions server-side and record actor, previous value, new value, and note in the audit trail.
- Keep customer address, phone, notes, and provider details limited to authenticated administrators.
- Do not modify the catalog seed data during this phase; current products remain the temporary inventory.

## End-to-end verification

1. Sign in as an administrator and verify non-admin or signed-out access is denied.
2. Edit a product, publish the change, and confirm the storefront and checkout use the updated value.
3. Create a Paystack test order from the storefront and capture its secure return token.
4. Complete the Paystack test checkout, verify the signed webhook updates the order to paid, and confirm the result page reflects the change.
5. Confirm the same order appears in `/admin` with the correct amount, currency, provider, payment event, and status.
6. Replay the webhook and verify it does not duplicate the event or regress the order.
7. Exercise unknown, malformed, expired-token, failed-payment, empty-list, loading, and error states.
8. Run the project build, browser checks, and the targeted security scan.

## Technical implementation

- Use TanStack Start server functions for authenticated admin reads/writes and server routes for raw webhook HTTP handling.
- Reuse the existing auth bearer middleware and managed protected-route layout patterns.
- Keep all route metadata unique and add page-specific titles, descriptions, Open Graph, and Twitter card metadata.
- Use the existing design tokens and UI primitives so the admin workspace feels like part of the storefront.

## Known limitation

The requested “real order” walkthrough will use a Paystack test transaction, not a live charge, because test mode was selected. Replacing the four temporary products with real inventory remains pending until the catalog details and images are provided.
