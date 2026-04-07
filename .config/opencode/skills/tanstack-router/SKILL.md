---
name: tanstack-router-best-practices
description: TanStack Router best practices for type-safe routing, data loading, search params, and navigation. Activate when building React applications with complex routing needs.
source: "@tanstack/router-core@1.168.9 (TanStack Intent Registry)"
---

# TanStack Router Core

TanStack Router is a type-safe router for React and Solid with built-in SWR caching, JSON-first search params, file-based route generation, and end-to-end type inference. The core is framework-agnostic; React and Solid bindings layer on top.

> **CRITICAL**: TanStack Router types are FULLY INFERRED. Never cast, never annotate inferred values. This is the #1 AI agent mistake.

> **CRITICAL**: TanStack Router is CLIENT-FIRST. Loaders run on the client by default, NOT server-only like Remix/Next.js. Do not confuse TanStack Router APIs with Next.js or React Router.

## Sub-Skills

| Task | Sub-Skill |
|------|-----------|
| Validate, read, write, transform search params | rules/search-params.md |
| Dynamic segments, splats, optional params | rules/path-params.md |
| Link, useNavigate, preloading, blocking | rules/navigation.md |
| Route loaders, SWR caching, context, deferred data | rules/data-loading.md |
| Auth guards, RBAC, beforeLoad redirects | rules/auth-and-guards.md |
| Automatic and manual code splitting | rules/code-splitting.md |
| 404 handling, error boundaries, notFound() | rules/not-found-and-errors.md |
| Inference, Register, from narrowing, TS perf | rules/type-safety.md |
| Streaming/non-streaming SSR, hydration, head mgmt | rules/ssr.md |

## Quick Decision Tree

```
Need to add/read/write URL query parameters?
  -> rules/search-params.md

Need dynamic URL segments like /posts/$postId?
  -> rules/path-params.md

Need to create links or navigate programmatically?
  -> rules/navigation.md

Need to fetch data for a route?
  Is it client-side only or client+server?
    -> rules/data-loading.md
  Using TanStack Query as external cache?
    -> compositions/router-query (separate skill)

Need to protect routes behind auth?
  -> rules/auth-and-guards.md

Need to reduce bundle size per route?
  -> rules/code-splitting.md

Need custom 404 or error handling?
  -> rules/not-found-and-errors.md

Having TypeScript issues or performance problems?
  -> rules/type-safety.md

Need server-side rendering?
  -> rules/ssr.md
```

## Minimal Working Example

```tsx
// src/routes/__root.tsx
import { createRootRoute, Outlet } from '@tanstack/react-router'

export const Route = createRootRoute({
  component: () => <Outlet />,
})
```

```tsx
// src/routes/index.tsx
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/')({
  component: () => <h1>Home</h1>,
})
```

```tsx
// src/router.tsx
import { createRouter } from '@tanstack/react-router'
import { routeTree } from './routeTree.gen'

const router = createRouter({ routeTree })

// REQUIRED for type safety — without this, Link/useNavigate have no autocomplete
declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router
  }
}

export default router
```

```tsx
// src/main.tsx
import { RouterProvider } from '@tanstack/react-router'
import router from './router'

function App() {
  return <RouterProvider router={router} />
}
```

## Common Mistakes

### HIGH: createFileRoute path string must match the file path

The Vite plugin manages the path string in createFileRoute. Do not change it manually — it must match the file's location under src/routes/:

```tsx
// File: src/routes/posts/$postId.tsx
export const Route = createFileRoute('/posts/$postId')({
  // ✅ matches file path
  component: PostPage,
})

export const Route = createFileRoute('/post/$postId')({
  // ❌ silent mismatch
  component: PostPage,
})
```

The plugin auto-generates this string. If you rename a route file, the plugin updates it. Never edit the path string by hand.

## Version Note

This skill targets @tanstack/router-core v1.168.9. APIs are stable. Splat routes use $ (not *); the * compat alias will be removed in v2.
