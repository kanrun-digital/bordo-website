# Bordo Beauty Studio — Landing Page

Production-ready static site for **Bordo Beauty Studio** (rebrand of Young & Beautiful).
Single-page landing in **PL** (default) and **UA** (`/uk/`).

**Address:** Władysława Jagiełły 3/7, 50-201 Wrocław · Śródmieście
**Phone:** +48 730 377 032
**Email:** youngandbeautiful.wro@gmail.com
**Booksy:** https://youngandbeautiful.booksy.com/a/

---

## File structure

```
site/
├── index.html              ← PL landing (canonical)
├── uk/index.html           ← UA landing (built from PL)
├── assets/
│   └── favicon.svg         ← Bordo monogram favicon
├── robots.txt
├── sitemap.xml             ← PL + UA URLs with hreflang
├── vercel.json             ← Vercel config (security headers, caching, redirects)
├── _headers                ← Cloudflare Pages / Netlify equivalent
├── _redirects              ← /ru → /uk/ redirects
├── build-uk.ps1            ← Regenerates /uk/index.html from /index.html
└── README.md               ← this file
```

---

## How to deploy

### Vercel (recommended)
```
vercel --prod
```
Pick `D:\bordo salon\site` as the project root. `vercel.json` handles everything.

### Cloudflare Pages
1. Push folder to a GitHub repo.
2. Connect in Cloudflare Pages dashboard → Build output directory: `/`
3. `_headers` and `_redirects` will be picked up automatically.

### Netlify
Same as Cloudflare — drag-and-drop the folder or connect a repo. `_headers` and `_redirects` work natively.

### Plain web host (FTP)
Upload everything in `site/` to your web root. Make sure `.htaccess` rules cover the redirects below if using Apache:

```apache
RedirectMatch 301 ^/ru$ /uk/
RedirectMatch 301 ^/ru/.* /uk/
```

---

## Editing content

### 1. PL is the source of truth

All edits go to `index.html` first.

### 2. After editing PL — rebuild UA

Open PowerShell in `D:\bordo salon\site\` and run:

```powershell
.\build-uk.ps1
```

The script does string-by-string PL→UA replacements and writes `uk/index.html`.

> **Important:** the script must be UTF-8 with BOM (PowerShell 5.1 needs it for Cyrillic). It already is — don't re-save it without BOM, or the script will fail.

### 3. New strings = update build-uk.ps1

If you add new Polish text to `index.html`, add the matching `$h.Replace(...)` line to `build-uk.ps1` before re-running it.

---

## Legacy-brand migration (Young & Beautiful → Bordo)

The rebrand is **partially complete**. Working/critical infrastructure still uses the legacy slug because rebranding it requires actions outside the codebase:

| Asset | Current value | Target | Action required |
|---|---|---|---|
| Booksy URL | `youngandbeautiful.booksy.com/a/` | `bordo-wroclaw.booksy.com/a/` (or whatever Booksy assigns) | **Owner action:** request URL slug change in Booksy admin → settings → business URL. Booksy auto-301s old URL. |
| Email | `youngandbeautiful.wro@gmail.com` | `kontakt@bordo.studio` or `hello@bordo.pl` | **Owner action:** register `bordo.studio` (or `.pl`) domain → set up Google Workspace / Zoho Mail / Fastmail → forward gmail to new inbox for transition period. |
| Domain | `bordo.studio` (placeholder canonical) | TBD — buy and point DNS | **Owner action:** purchase domain, set DNS, deploy site. |
| Instagram | `bordo.wro` ✅ migrated | — | done |
| Facebook | `bordo.wro` ✅ migrated | — | done |
| Google Business Profile | unknown — still under old name? | "Bordo Beauty Studio" | **Owner action:** Google allows one rebrand without re-verification if address+phone unchanged. Rename in GBP admin. |

### When new Booksy URL is ready

In `D:\bordo salon\site\`, run global find-replace via PowerShell:

```powershell
$files = @('index.html', 'build-uk.ps1')
foreach ($f in $files) {
  $content = [System.IO.File]::ReadAllText("D:\bordo salon\site\$f", [System.Text.Encoding]::UTF8)
  $content = $content.Replace('youngandbeautiful.booksy.com/a/', 'NEW-BOOKSY-URL.booksy.com/a/')
  $bom = New-Object System.Text.UTF8Encoding($true)
  [System.IO.File]::WriteAllText("D:\bordo salon\site\$f", $content, $bom)
}
& 'D:\bordo salon\site\build-uk.ps1'  # rebuild UA
```

Replaces all 8 occurrences in PL + propagates to UA via build script.

### When new email is ready

```powershell
$files = @('index.html', 'build-uk.ps1')
foreach ($f in $files) {
  $content = [System.IO.File]::ReadAllText("D:\bordo salon\site\$f", [System.Text.Encoding]::UTF8)
  $content = $content.Replace('youngandbeautiful.wro@gmail.com', 'kontakt@bordo.studio')
  $bom = New-Object System.Text.UTF8Encoding($true)
  [System.IO.File]::WriteAllText("D:\bordo salon\site\$f", $content, $bom)
}
& 'D:\bordo salon\site\build-uk.ps1'
```

Replaces all 4 occurrences in PL + propagates to UA.

### When `bordo.studio` domain is set up

Update `vercel.json`, `sitemap.xml`, and JSON-LD blocks if you change the domain placeholder. All current canonical/hreflang/og:url use `https://bordo.studio/` — if your real domain is different, do a global replace of `bordo.studio` to the real one.

---

## Real prices used (from physical price cards)

| Service column | Source |
|---|---|
| **Rzęsy** (Junior tier shown) | Lash card — Junior level |
| **Brwi** | Brows card |
| **Makijaż** | Makeup card |

> **Laser prices not yet on the site.** Currently the price-foot mentions «ceny indywidualne — bezpłatna konsultacja». When you have a real laser price card, send it and add a 4th column or replace one.

> **Lashes have 3 tiers** (Junior / Top / Art) — only Junior shown for visual balance. Tier note in the price-foot.

---

## What still uses placeholder data

The HTML is wired up with **real** contacts, Booksy, and prices. These items are still placeholders awaiting real content:

| Placeholder | What's needed |
|---|---|
| `og-image.jpg` | OG-image (1200×630) — use a hero photo |
| Service photos (4 cards) | Real macro shots: lashes, brows, laser, makeup |
| Signature combo photo | Editorial portrait combining brows + lashes result |
| Before/After (6 pairs) | Real client photos with consent — same lighting, same angle |
| Studio interior shot | Vertical 4:5 photo of the studio |
| Master portraits (4) | Anna K., Olena S., Daria P., Iryna V. — same style |
| Testimonial names + texts | Replace placeholders (Karolina M., Joanna K., Maria S.) with real Google reviews |
| Master names + tenure | Replace placeholders with real team |
| `bordo.studio` domain | Update canonical/hreflang/og:url across both files when domain is set up. Currently uses `bordo.studio` — change globally if different. |
| Email `hello@bordo.studio` | Replaced with `youngandbeautiful.wro@gmail.com` (real working). When `bordo.studio` domain + email are set up, run a global find-replace. |

---

## Tracking (recommended setup before paid traffic)

The HTML has `data-cta="..."` attributes on every conversion button. Wire them to:

1. **Google Tag Manager** — listen for clicks on `[data-cta]` → fire conversions.
2. **Meta Pixel + CAPI** — same selector for Lead / Contact events.
3. **TikTok Pixel** — same.
4. **GA4** — auto-track via enhanced measurement + click events.

CTA inventory (PL):
- `data-cta="header"` — header «Zarezerwuj»
- `data-cta="hero-primary"` — hero «Zarezerwuj wizytę»
- `data-cta="signature-combo"` — signature «Zarezerwuj kombo»
- `data-cta="ba-card"` — 6× before/after «Zarezerwuj efekt»
- `data-cta="location-whatsapp"` — location «Napisz na WhatsApp»
- `data-cta="final"` — final CTA «Zarezerwuj wizytę»
- `data-cta="sticky-booksy"` — mobile sticky bar
- `data-cta="sticky-whatsapp"` — mobile sticky bar

---

## Browser support

- Modern evergreen (Chrome / Safari / Firefox / Edge — last 2 years)
- iOS 14+ Safari
- Android 8+ Chrome
- No IE11 support (no polyfills)

---

## Performance baseline (target)

- LCP: < 2.0s
- CLS: < 0.05
- TBT: < 150ms
- Lighthouse Performance: ≥ 90 (after real photos optimized to AVIF/WebP)

Currently uses placeholder gradients instead of photos, so the score will jump once real photos with `loading="lazy"` and `srcset` are added.
