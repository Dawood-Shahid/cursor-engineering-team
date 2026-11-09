---
name: nextjs-development
description: Next.js App Router checklist—server/client boundaries, caching, Server Actions, and NEXT_PUBLIC safety. Use when adding or changing pages, layouts, route handlers, or Server Actions.
---

# Next.js development

## Before coding
- Read the installed Next.js version in `package.json` (caching and APIs differ by major).
- Map server vs client: default to Server Components; add `"use client"` only for interactivity or browser APIs.
- Put privileged logic in Server Components, Route Handlers, or Server Actions—not in client bundles.

## Implementation checks
- Add `import "server-only"` to modules that must never ship to the client.
- Server Actions: validate with Zod/schema on the server; never trust `FormData` shape alone.
- After mutations: `revalidatePath` / `revalidateTag` (or the project's existing cache pattern)—avoid stale RSC payloads.
- No secrets in `NEXT_PUBLIC_*`; audit new env vars in the diff.
- Route Handlers: check method, auth, and consistent error status codes.

## Finish
- Lint, typecheck, production build.
- Smoke the affected route(s) and one negative case (unauthorized / invalid input).

## Deep reference
- Version-specific caching, middleware, and partial prerendering notes: [reference.md](reference.md)
