---
name: nextjs-canary-docs
description: Local Next.js documentation reference (canary branch). Use when asked about Next.js features, App Router, Server Components, routing, data fetching, rendering, caching, styling, optimizations, configuration, or Next.js APIs.
---

# Next.js Documentation (Canary)

Next.js is a React framework for building full-stack web applications. It provides Server Components, automatic code splitting, file-based routing, and built-in optimizations for production.

## Navigation Guide

**App Router (Recommended):** `references/01-app/` - The newer router with React Server Components support (220 files)

- `01-getting-started/` - Installation, project structure, core concepts
- `02-guides/` - Tutorials on authentication, caching, forms, data security
- `03-api-reference/` - Directives, components, file conventions, functions, config

**Pages Router (Legacy):** `references/02-pages/` - The original Next.js router (148 files)

- `01-getting-started/` - Setup and migration guides
- `02-guides/` - Pages Router-specific tutorials
- `03-building-your-application/` - Routing, rendering, data fetching
- `04-api-reference/` - Pages Router API documentation

**Architecture:** `references/03-architecture/` - How Next.js works under the hood (5 files)

**Community:** `references/04-community/` - Contribution guidelines (2 files)

## Key Entry Points

| Task | Start Here |
|------|------------|
| New to Next.js | `references/01-app/01-getting-started/01-installation.mdx` |
| Project structure | `references/01-app/01-getting-started/02-project-structure.mdx` |
| Layouts and pages | `references/01-app/01-getting-started/03-layouts-and-pages.mdx` |
| Server vs Client Components | `references/01-app/01-getting-started/05-server-and-client-components.mdx` |
| Data fetching | `references/01-app/01-getting-started/07-fetching-data.mdx` |
| Caching | `references/01-app/02-guides/caching.mdx` |
| Authentication | `references/01-app/02-guides/authentication.mdx` |
| Forms | `references/01-app/02-guides/forms.mdx` |
| API reference | `references/01-app/03-api-reference/index.mdx` |
| Components (Image, Link, etc.) | `references/01-app/03-api-reference/02-components/` |
| Configuration | `references/01-app/03-api-reference/05-config/` |
| Pages Router setup | `references/02-pages/01-getting-started/` |

## When to use

Use this skill when the user asks about:
- Next.js App Router or Pages Router
- Server Components and Client Components
- File-based routing, layouts, and navigation
- Data fetching and caching strategies
- Rendering (SSR, SSG, ISR, streaming)
- Middleware and API routes
- Image, Font, Link, Script optimization
- next.config.js configuration
- Deployment and production builds

## How to find information

1. **First**, read `references/STRUCTURE.md` to see all 377 documentation files organized by directory
2. Use the Navigation Guide above to identify the relevant section
3. Start with the Key Entry Points for common tasks
4. For App Router: explore `references/01-app/`
5. For Pages Router: explore `references/02-pages/`
6. For API details: check `03-api-reference/` within each router section

**STRUCTURE.md contains a complete file listing - always check it first when searching for specific topics.**
