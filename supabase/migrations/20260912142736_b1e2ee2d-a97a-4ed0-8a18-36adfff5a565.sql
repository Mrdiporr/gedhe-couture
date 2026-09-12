CREATE SCHEMA IF NOT EXISTS private;

CREATE OR REPLACE FUNCTION private.has_role(_user_id uuid, _role public.app_role)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

REVOKE ALL ON FUNCTION private.has_role(uuid, public.app_role) FROM PUBLIC, anon;
GRANT USAGE ON SCHEMA private TO authenticated;
GRANT EXECUTE ON FUNCTION private.has_role(uuid, public.app_role) TO authenticated;

DROP POLICY "Admins can update orders" ON public.orders;
CREATE POLICY "Admins can update orders" ON public.orders FOR UPDATE TO authenticated USING (private.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (private.has_role(auth.uid(), 'admin'::public.app_role));
DROP POLICY "Admins can view orders" ON public.orders;
CREATE POLICY "Admins can view orders" ON public.orders FOR SELECT TO authenticated USING (private.has_role(auth.uid(), 'admin'::public.app_role));
DROP POLICY "Admins can view payment events" ON public.payment_events;
CREATE POLICY "Admins can view payment events" ON public.payment_events FOR SELECT TO authenticated USING (private.has_role(auth.uid(), 'admin'::public.app_role));
DROP POLICY "Admins can delete products" ON public.products;
CREATE POLICY "Admins can delete products" ON public.products FOR DELETE TO authenticated USING (private.has_role(auth.uid(), 'admin'::public.app_role));
DROP POLICY "Admins can insert products" ON public.products;
CREATE POLICY "Admins can insert products" ON public.products FOR INSERT TO authenticated WITH CHECK (private.has_role(auth.uid(), 'admin'::public.app_role));
DROP POLICY "Admins can update products" ON public.products;
CREATE POLICY "Admins can update products" ON public.products FOR UPDATE TO authenticated USING (private.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (private.has_role(auth.uid(), 'admin'::public.app_role));
DROP POLICY "Admins can view all products" ON public.products;
CREATE POLICY "Admins can view all products" ON public.products FOR SELECT TO authenticated USING (private.has_role(auth.uid(), 'admin'::public.app_role));
DROP POLICY "Admins can read all roles" ON public.user_roles;
CREATE POLICY "Admins can read all roles" ON public.user_roles FOR SELECT TO authenticated USING (private.has_role(auth.uid(), 'admin'::public.app_role));

DROP FUNCTION public.has_role(uuid, public.app_role);