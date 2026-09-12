/** Trust rail + brand footer. */
import { Instagram, PackageCheck, ShieldCheck, Truck } from "lucide-react";
import { BRAND } from "@/data/catalog";

const TRUST = [
  { icon: PackageCheck, title: "Verified Cotton", copy: "Every bundle inspected for true wax weave." },
  { icon: Truck, title: "Nationwide Dispatch", copy: "Lagos same-day, 2–4 days interstate." },
  { icon: ShieldCheck, title: "Protected Payments", copy: "Tokenised cards, reconciled transfers." },
];

export function SiteFooter() {
  return (
    <footer className="surface-dark">
      <div className="mx-auto max-w-7xl px-5 py-14 sm:px-8 sm:py-20">
        <div className="grid gap-px overflow-hidden border border-linen/15 bg-linen/10 sm:grid-cols-3">
          {TRUST.map((item) => {
            const Icon = item.icon;
            return (
              <div key={item.title} className="bg-charcoal px-5 py-6">
                <Icon className="h-5 w-5 text-gold" />
                <p className="mt-3 font-display text-lg text-linen">{item.title}</p>
                <p className="mt-1.5 text-xs leading-relaxed text-linen/60">{item.copy}</p>
              </div>
            );
          })}
        </div>

        <div className="mt-12 grid gap-6 sm:grid-cols-[minmax(0,1fr)_auto] sm:items-end">
          <div className="min-w-0">
            <p className="font-display text-2xl tracking-tight text-linen sm:text-3xl">
              3kbelow<span className="text-gold">ankara</span>
            </p>
            <p className="mt-2 max-w-sm text-sm leading-relaxed text-linen/60">
              Affordable luxury Ankara — 3-yard cotton bundles, ready-to-wear and asoebi bulk
              coordination, shipped nationwide from Lagos.
            </p>
          </div>
          <a
            href={BRAND.instagram}
            target="_blank"
            rel="noreferrer noopener"
            className="inline-flex shrink-0 items-center gap-2 rounded-full border border-linen/25 px-5 py-3 text-[11px] font-bold uppercase tracking-[0.2em] text-linen transition-colors hover:border-gold hover:text-gold"
          >
            <Instagram className="h-4 w-4" /> @{BRAND.handle}
          </a>
        </div>

        <p className="mt-10 border-t border-linen/15 pt-6 text-[10px] uppercase tracking-[0.18em] text-linen/40">
          © {new Date().getFullYear()} {BRAND.handle} · Naira & Pound checkout · Privacy
          respected by default
        </p>
      </div>
    </footer>
  );
}