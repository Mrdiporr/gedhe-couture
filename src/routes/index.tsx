import { createFileRoute } from "@tanstack/react-router";

import { StoreProvider } from "@/lib/store";
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
    ],
  }),
  component: Index,
});

function Index() {
  return (
    <StoreProvider>
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
