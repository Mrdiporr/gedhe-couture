ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS lookup_token_hash text,
  ADD COLUMN IF NOT EXISTS lookup_expires_at timestamp with time zone,
  ADD COLUMN IF NOT EXISTS lookup_revoked_at timestamp with time zone,
  ADD COLUMN IF NOT EXISTS payment_attempts integer NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS last_payment_error text;

CREATE UNIQUE INDEX IF NOT EXISTS orders_reference_unique_idx ON public.orders (reference);
CREATE UNIQUE INDEX IF NOT EXISTS orders_lookup_token_hash_unique_idx ON public.orders (lookup_token_hash) WHERE lookup_token_hash IS NOT NULL;
CREATE INDEX IF NOT EXISTS orders_lookup_token_hash_idx ON public.orders (lookup_token_hash);
CREATE INDEX IF NOT EXISTS orders_created_at_idx ON public.orders (created_at DESC);
CREATE INDEX IF NOT EXISTS orders_payment_status_idx ON public.orders (payment_status);
CREATE INDEX IF NOT EXISTS orders_fulfilment_status_idx ON public.orders (fulfilment_status);

ALTER TABLE public.payment_events
  ADD COLUMN IF NOT EXISTS payload_hash text,
  ADD COLUMN IF NOT EXISTS processed_at timestamp with time zone,
  ADD COLUMN IF NOT EXISTS failure_reason text;

CREATE UNIQUE INDEX IF NOT EXISTS payment_events_provider_event_unique_idx ON public.payment_events (provider, event_id);
CREATE INDEX IF NOT EXISTS payment_events_order_reference_idx ON public.payment_events (order_reference);
CREATE INDEX IF NOT EXISTS payment_events_received_at_idx ON public.payment_events (received_at DESC);

CREATE TABLE IF NOT EXISTS public.order_audit_events (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders(id) on delete cascade not null,
  order_reference text not null,
  actor_user_id uuid,
  event_type text not null,
  from_value text,
  to_value text,
  note text not null default '',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamp with time zone not null default now()
);

GRANT SELECT ON public.order_audit_events TO authenticated;
GRANT ALL ON public.order_audit_events TO service_role;

ALTER TABLE public.order_audit_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view order audit events"
  ON public.order_audit_events
  FOR SELECT
  TO authenticated
  USING (private.has_role(auth.uid(), 'admin'::public.app_role));

ALTER TABLE public.orders
  ADD CONSTRAINT orders_currency_allowed CHECK (currency IN ('NGN', 'GBP')),
  ADD CONSTRAINT orders_payment_provider_allowed CHECK (payment_provider IN ('stripe', 'paystack', 'whatsapp')),
  ADD CONSTRAINT orders_payment_status_allowed CHECK (payment_status IN ('pending', 'paid', 'failed', 'cancelled', 'refunded')),
  ADD CONSTRAINT orders_fulfilment_status_allowed CHECK (fulfilment_status IN ('new', 'confirmed', 'packed', 'dispatched', 'delivered', 'cancelled')),
  ADD CONSTRAINT orders_totals_non_negative CHECK (subtotal >= 0 AND delivery_fee >= 0 AND total >= 0 AND volume >= 0);

ALTER TABLE public.payment_events
  ADD CONSTRAINT payment_events_provider_allowed CHECK (provider IN ('stripe', 'paystack'));
