import { createFileRoute } from "@tanstack/react-router";
import { useSuspenseQuery } from "@tanstack/react-query";

import { StoreProvider } from "@/lib/store";
import { publishedProductsQueryOptions } from "@/lib/catalog.functions";
import { SiteHeader } from "@/components/site-header";
import { Hero } from "@/components/hero";
import { Catalog } from "@/components/catalog";
import { AsoebiNote } from "@/components/asoebi-note";
import { CartPanel } from "@/components/cart-panel";
import { SiteFooter } from "@/components/site-footer";

const TITLE = "3kbelowankara — Affordable Ankara, Premium Heritage";
const DESCRIPTION =
  "Shop 100% cotton 3-yard Ankara bundles, ready-to-wear bubu gowns and palazzo trousers, plus asoebi bulk supply with volume pricing. Nationwide delivery from Lagos.";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: TITLE },
      { name: "description", content: DESCRIPTION },
      { property: "og:title", content: TITLE },
      { property: "og:description", content: DESCRIPTION },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  loader: ({ context }) =>
    context.queryClient.ensureQueryData(publishedProductsQueryOptions()),
  component: Index,
});

function Index() {
  const { data: products } = useSuspenseQuery(publishedProductsQueryOptions());

  return (
    <StoreProvider products={products}>
      <SiteHeader />
      <main>
        <Hero />
        <Catalog />
        <AsoebiNote />
      </main>
      <SiteFooter />
      <CartPanel />
    </StoreProvider>
  );
}
