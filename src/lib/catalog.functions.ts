/** Public storefront catalog reads. */
import { createServerFn } from "@tanstack/react-start";

import type { Product } from "@/data/catalog";
import { PRODUCT_COLUMNS, mapProduct, type ProductRow } from "@/lib/product-mapper";

export const listPublishedProducts = createServerFn({ method: "GET" }).handler(
  async (): Promise<Product[]> => {
    const { createPublicClient } = await import("@/lib/supabase-public.server");
    const supabase = createPublicClient();
    const { data, error } = await supabase
      .from("products")
      .select(PRODUCT_COLUMNS)
      .eq("published", true)
      .order("sort_order", { ascending: true });

    if (error) {
      console.error("listPublishedProducts failed", error);
      return [];
    }
    return (data as unknown as ProductRow[]).map(mapProduct);
  },
);
