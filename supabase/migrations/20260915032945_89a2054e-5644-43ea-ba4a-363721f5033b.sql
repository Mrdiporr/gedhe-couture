GRANT ALL ON public.orders TO service_role;
GRANT ALL ON public.payment_events TO service_role;
REVOKE INSERT ON public.orders FROM anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON public.payment_events FROM anon, authenticated;