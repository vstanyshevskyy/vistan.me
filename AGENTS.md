# AGENTS.md

This file captures the current project context and the important decisions already made, so a future agent can continue work without re-deriving the whole site from chat history.

## Project Overview

- Personal website for `Vitaliy Stanyshevskyy`
- Built with `Astro`
- Styled with `Tailwind CSS v4` and CSS modules using `@apply`
- Target deployment: `Netlify`
- Domain: `https://vistan.me`
- Tone/design direction: minimal, editorial, typography-first, light by default with a dark blue dark theme

## Tooling

- Node: project has been aligned for modern Node 24 usage
- Main scripts:
  - `npm run dev`
  - `npm run build`
  - `npm run check`
  - `npm run lint`
  - `npm run format`
- ESLint uses Airbnb base and remains on ESLint 8 because Airbnb base does not support the latest ESLint major yet

## Current Stack

- `astro` `^6.3.1`
- `@astrojs/netlify` `^7.0.8`
- `@astrojs/sitemap` `^3.7.2`
- `tailwindcss` `^4.2.4`
- `@tailwindcss/vite` `^4.2.4`
- `typescript` `^6.0.3`
- `prettier` `^3.8.3`

## Important Project Structure

- `src/layouts/BaseLayout.astro`
  - Shared page shell
  - Main nav
  - Theme switcher
  - Shared SEO/meta tags
  - Footer
- `src/pages/index.astro`
  - Homepage
- `src/pages/cv.astro`
  - CV page
- `src/pages/_index.module.css`
  - Homepage-specific styles
- `src/pages/_cv.module.css`
  - CV-specific styles
- `src/components/Nav.module.css`
  - Header, nav, theme switcher, footer styles
- `src/styles/global.css`
  - Global palette and typography

## Content Data Structure

Content is split into smaller files on purpose. Keep it that way.

- `src/data/profile.ts`
  - name, greeting, role, title, intro, availability, summary, email, location, social links, highlights
- `src/data/experience.ts`
  - experience and volunteering
- `src/data/content.ts`
  - articles, talks, projects
- `src/data/credentials.ts`
  - certificates, skills, technologies, education, languages
- `src/data/site.ts`
  - composes the exports into one `site` object for page consumption

## Established Content Decisions

- `profile.role` is for the professional role and should remain:
  - `Engineering Manager`
- `profile.greeting` is separate and used on the homepage:
  - `Hej, I'm Vitaliy.`
- Homepage availability line:
  - `Based in Copenhagen and open to remote and hybrid leadership opportunities.`
- Public phone number was intentionally removed from the site
- Email remains public
- Homepage summary already includes short company context:
  - Awaze = travel platform company
  - Pleo = spend management fintech
- Articles are maintained in reverse chronological order

## Homepage Design Intent

The homepage should stay calm and text-led, not portfolio-heavy.

Current sections:
- Hero
- Summary
- Selected impact
- Articles
- Public speaking
- Certificates
- Elsewhere
- Projects

Notes:
- The `Projects` section was intentionally moved to the very end of the homepage
- The subnav order matches the page order and should stay consistent
- Avoid adding too many visually heavy sections above the fold

## Projects Section

The homepage has a `Projects` section based on three projects:

- `Bobruiko.com`
  - `https://bobruiko.com`
  - `2019-now`
  - Gatsby.js
  - mental health education platform and therapist website
- `Vpershe.com`
  - `https://vpershe.com`
  - `2018-2022`
  - Gatsby.js, React
  - public educational platform for Ukrainian teenagers
  - supported growth to `53K monthly visitors in 14 months`
- `Motix.com.ua`
  - `https://motix.com.ua`
  - `2011-2013`
  - SPA application
  - managing and synchronizing bookmarks
  - `1000+ active daily users` in 2013

Image assets:
- `public/projects/bobruiko.png`
- `public/projects/vpershe.png`
- `public/projects/motix.png`

Current project-card behavior:
- project screenshots are shown in a dedicated side media column
- screenshots use `object-contain`
- screenshots are muted toward the page palette by default
- screenshots become full color on hover
- the image itself should not be forced into a fake white framed panel

If this section is tweaked in the future:
- keep the cards elegant and readable first
- screenshots should support the text, not dominate it
- preserve hover-to-full-color unless there is a strong reason to remove it

## Theme System

- Light theme is default
- Dark theme uses a dark blue palette
- Initial theme follows browser `prefers-color-scheme`
- Manual toggle choice is stored in `localStorage`
- Desktop uses the fuller switcher
- Mobile uses a lighter nav-style control

Be careful when touching the toggle:
- active thumb positioning has already been tuned manually
- mobile and desktop toggle behavior differ by design

## Typography / Visual Language

- Global serif stack is intentional and should remain the primary typographic voice
- The site should feel editorial, not startup-generic
- Avoid adding loud gradients, glossy cards, or default SaaS UI patterns
- Keep one-column reading comfort as the main constraint

## SEO / Metadata Setup

Implemented already:
- `site` configured in `astro.config.mjs` as `https://vistan.me`
- sitemap via `@astrojs/sitemap`
- canonical URLs
- Open Graph tags
- Twitter card tags
- JSON-LD structured data
- `public/robots.txt`

Important files:
- `astro.config.mjs`
- `src/layouts/BaseLayout.astro`
- `public/robots.txt`

## OG Image

The OG image is a real generated PNG, not a hand-maintained screenshot.

Files:
- `public/og-image.png`
- `src/assets/og-portrait.jpg`
- `scripts/generate-og-image.swift`

Notes:
- The PNG is generated from the Swift script
- The script uses the portrait stored in `src/assets/og-portrait.jpg`
- If text/layout changes are needed, update the script and regenerate the PNG
- The OG image no longer uses the `Hej, I'm Vitaliy.` line
- It uses Vitaliy’s photo instead

To regenerate:

```bash
swift scripts/generate-og-image.swift
```

Important:
- running the Swift generator may require broader filesystem access in some sandboxes because Swift uses temp compilation directories outside the repo

## Netlify / Domain Notes

- Netlify is the deployment target
- `vistan.me` is the production domain
- There was discussion about using Netlify DNS with Namecheap
- If DNS is delegated to Netlify, DNS records should be managed in Netlify rather than Namecheap

## Files/Folders That Are Generated

Do not treat these as source of truth:
- `.astro/`
- `.netlify/`
- `dist/`

They can be regenerated.

## Development Preferences To Preserve

- Prefer editing content in `src/data/*` rather than hardcoding in page files
- Keep the homepage uncluttered
- Keep the CV page more utilitarian than the homepage
- Avoid duplicate content between homepage and CV unless it serves a clear purpose
- Prefer real links over placeholders
- Preserve responsive behavior for smaller phones like iPhone 12 mini widths

## Verification Workflow

After meaningful changes, run:

```bash
npm run check
npm run build
```

Use `npm run lint` when touching broader JS/Astro/CSS patterns.

## If You Continue This Project Later

Good next-step mindset:
- treat this as a personal editorial site, not a template
- keep changes coherent with the calm typography-first direction
- when adding sections, ask whether they earn their place on the homepage
- if changing visuals, preserve restraint first and novelty second
