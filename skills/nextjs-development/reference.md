# Next.js reference (read when needed)

## Caching (App Router)

- **Static**: default for fetches with default cache unless `cache: 'no-store'` or `revalidate`.
- **Dynamic**: `cookies()`, `headers()`, `searchParams` in pages, or `export const dynamic = 'force-dynamic'`.
- Prefer **tags** (`fetch(..., { next: { tags: ['x'] } })` + `revalidateTag`) when multiple routes share data.

## Server Actions

- Mark files with `"use server"` at top or per-function as per project convention.
- Idempotent reads should not live in actions; keep actions for mutations.
- Return structured errors the UI can render; avoid leaking stack traces to clients.

## Middleware

- Keep middleware edge-safe: no Node-only APIs.
- Matcher should be minimal—broad matchers add latency to every request.

## Partial Prerendering (when enabled)

- Confirm which segments are static shell vs dynamic holes before refactoring layouts.

## SEO and metadata

- Use `generateMetadata` for dynamic titles; avoid client-only title updates for critical pages.
