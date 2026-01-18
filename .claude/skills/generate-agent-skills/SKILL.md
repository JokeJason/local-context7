---
name: generate-agent-skills
description: Generate documentation skills for AI agents from downloaded docs. Use after /build-my-context7 to create skills.
---

# Generate Agent Skills

Generate documentation skills for each AI agent using the latest skill specifications from downloaded docs.

## Usage

```
/generate-agent-skills              # Generate ALL skills
/generate-agent-skills zod-docs     # Generate only zod-docs skill
```

Run after `/build-my-context7` to generate skills based on the latest documentation.

## Instructions

### Step 1: Check Arguments

Check if `$ARGUMENTS` is provided:
- If **argument provided**: Generate only that specific skill
- If **no argument**: Generate all skills from `output/*-docs/`

### Step 2: Verify docs exist

**If processing a specific skill:**
- Verify `output/{argument}/` exists
- If not found, tell user to run `/build-my-context7 {argument}` first

**If processing all skills:**
- Check that `output/` contains downloaded documentation directories
- If empty, tell user to run `/build-my-context7` first

### Step 3: Read skill specifications (only needed once per session)

For each agent, read its skill documentation to understand the current format:

**Claude Code:**
- Read `output/claude-code-docs/build-with-claude-code/agent-skills.md`
- Note: YAML frontmatter with `name`, `description`, optional `allowed-tools`

**Codex CLI:**
- Read `output/codex-docs/configuration/skills/overview.md`
- Note: YAML frontmatter with `name`, `description`

**OpenCode:**
- Read `output/opencode-docs/skills.mdx`
- Note: YAML frontmatter with `name` (lowercase, hyphens), `description`

### Step 4: Create/update shared documentation

```bash
mkdir -p dotfiles/shared

# For specific skill:
rm -rf dotfiles/shared/{skill-name}
cp -r output/{skill-name} dotfiles/shared/

# For all skills:
for dir in output/*-docs; do
  name=$(basename "$dir")
  rm -rf "dotfiles/shared/$name"
  cp -r "$dir" "dotfiles/shared/$name"
done
```

### Step 4.5: Analyze documentation for enrichment

Before generating SKILL.md, analyze the docs to determine the enrichment level:

**Determine tier:**
```bash
# Count markdown files
file_count=$(find dotfiles/shared/{skill-name} -name "*.md" -o -name "*.mdx" 2>/dev/null | wc -l | tr -d ' ')

# Get total size in KB
total_size=$(du -sk dotfiles/shared/{skill-name} 2>/dev/null | cut -f1)
```

| Tier | Criteria | Enrichment Level |
|------|----------|------------------|
| Small (Tier 1) | < 30 files AND < 500KB | Full file index with descriptions |
| Medium (Tier 2) | 30-100 files OR 500KB-2MB | Directory tree with summaries |
| Large (Tier 3) | > 100 files OR > 2MB | Navigation guide only |

**For Small docs (Tier 1):**
- Read ALL markdown files in `dotfiles/shared/{skill-name}/`
- Extract `title` and `description` from YAML frontmatter
- Build a complete file-to-topic mapping table

**For Medium docs (Tier 2):**
- List directory structure with file counts per directory
- Read only index/overview/getting-started files in each directory
- Extract section summaries from these key files

**For Large docs (Tier 3):**
- List only top-level directories
- Identify key entry points (getting-started, api-reference, guides)
- Read only these entry point files for summaries

### Step 5: Generate skills for each agent

For each agent (Claude, Codex, OpenCode), create/update skills in `dotfiles/<agent>/skills/`:

1. Create directory: `dotfiles/<agent>/skills/<skill-name>/`
2. Determine the tier from Step 4.5
3. Create `SKILL.md` using the appropriate tier template below
4. Do NOT create `references/` - the install script handles this

---

## SKILL.md Templates

### Tier 1 Template (Small docs: < 30 files AND < 500KB)

Use this template for small documentation sets like zod-docs, claude-code-docs.

```yaml
---
name: {skill-name}
description: Local {Library} documentation reference. Use when asked about {topics derived from content}.
---

# {Library} Documentation

{One paragraph description of the library extracted from overview/intro docs}

## Quick Reference

| File | Title | Description |
|------|-------|-------------|
| `basics.mdx` | Basic Usage | Schema definition, parsing, type inference |
| `api.mdx` | API Reference | Complete API documentation |
| `error-handling.mdx` | Error Handling | Custom errors and formatting |
{... include ALL files with their extracted frontmatter title/description ...}

## When to use

Use this skill when the user asks about:
- {topic derived from file titles}
- {topic 2}
- {topic 3}
- ...

## How to find information

1. Check the Quick Reference table above for the relevant file
2. Read the file from `references/{filename}`
```

**Example (zod-docs Tier 1):**
```yaml
---
name: zod-docs
description: Local Zod documentation reference. Use when asked about Zod schema validation, TypeScript type inference, parsing, error handling, JSON Schema conversion, or schema composition.
---

# Zod Documentation

Zod is a TypeScript-first schema declaration and validation library with static type inference.

## Quick Reference

| File | Title | Description |
|------|-------|-------------|
| `basic-usage.mdx` | Basic Usage | Creating schemas, parsing data, inferring types |
| `primitives.mdx` | Primitives | String, number, boolean, and other primitive types |
| `coercion.mdx` | Coercion | Automatic type coercion during parsing |
| `literals.mdx` | Literals | Literal types and values |
| `strings.mdx` | Strings | String-specific validations and transforms |
| `numbers.mdx` | Numbers | Number validations and constraints |
| `dates.mdx` | Dates | Date parsing and validation |
| `objects.mdx` | Objects | Object schemas, shape, and methods |
| `arrays.mdx` | Arrays | Array validation and element types |
| `other-types.mdx` | Other Types | Additional types and utilities |
| `error-handling.mdx` | Error Handling | Error formatting and custom errors |
| `json-schema.mdx` | JSON Schema | Converting Zod schemas to JSON Schema |
| `metadata.mdx` | Metadata | Adding metadata to schemas |

## When to use

Use this skill when the user asks about:
- Zod schema validation
- TypeScript type inference from schemas
- Data parsing and validation
- Error handling and custom errors
- JSON Schema conversion
- Schema composition (merge, extend, pick, omit)

## How to find information

1. Check the Quick Reference table above for the relevant file
2. Read the file from `references/{filename}`
```

---

### Tier 2 Template (Medium docs: 30-100 files OR 500KB-2MB)

Use this template for medium documentation sets like opencode-docs, tsf-docs.

```yaml
---
name: {skill-name}
description: Local {Library} documentation reference. Use when asked about {topics}.
---

# {Library} Documentation

{One paragraph description extracted from overview}

## Documentation Structure

```
references/
├── getting-started/    # {brief summary} ({N} files)
├── guides/             # {brief summary} ({N} files)
├── api/                # {brief summary} ({N} files)
├── framework-{name}/   # {brief summary} ({N} files)
└── examples/           # {brief summary} ({N} files)
```

## Topic Guide

| Topic | Location | Key Files |
|-------|----------|-----------|
| Installation | `getting-started/` | `installation.md`, `quick-start.md` |
| Core API | `api/` | `overview.md`, `methods.md` |
| React Integration | `framework-react/` | `quick-start.md`, `hooks.md` |
| {topic} | `{directory}/` | `{key-files}` |

## When to use

Use this skill when the user asks about:
- {topic 1}
- {topic 2}
- ...

## How to find information

1. Use the Topic Guide table to identify the relevant directory
2. Check the key files listed for that topic
3. Explore related files in that directory as needed
```

**Example (tsf-docs Tier 2):**
```yaml
---
name: tsf-docs
description: Local TanStack Form documentation reference. Use when asked about TanStack Form features, form validation, form state management, field arrays, React/Vue/Solid/Angular form integration, or form submission handling.
---

# TanStack Form Documentation

TanStack Form is a powerful, framework-agnostic form state management library with first-class TypeScript support.

## Documentation Structure

```
references/
├── overview.md              # Introduction and core concepts
├── installation.md          # Setup instructions
├── framework-react/         # React-specific guides (12 files)
├── framework-vue/           # Vue-specific guides (8 files)
├── framework-angular/       # Angular-specific guides (8 files)
├── framework-solid/         # Solid-specific guides (8 files)
├── framework-lit/           # Lit-specific guides (6 files)
└── reference/               # API reference docs (45 files)
```

## Topic Guide

| Topic | Location | Key Files |
|-------|----------|-----------|
| Getting Started | root | `overview.md`, `installation.md` |
| React Forms | `framework-react/` | `quick-start.md`, `basic-concepts.md` |
| Vue Forms | `framework-vue/` | `quick-start.md`, `basic-concepts.md` |
| Validation | `framework-{fw}/` | `validation.md` |
| Field Arrays | `framework-{fw}/` | `arrays.md` |
| API Reference | `reference/` | `formapi.md`, `fieldapi.md` |

## When to use

Use this skill when the user asks about:
- TanStack Form setup or configuration
- Form state management
- Field validation (sync/async)
- Field arrays and dynamic fields
- Framework-specific integration (React, Vue, Angular, Solid)
- Form submission handling

## How to find information

1. Use the Topic Guide table to identify the relevant directory
2. Check the key files listed for that topic
3. Explore related files in that directory as needed
```

---

### Tier 3 Template (Large docs: > 100 files OR > 2MB)

Use this template for large documentation sets like nextjs-canary-docs, langchain-docs.

```yaml
---
name: {skill-name}
description: Local {Library} documentation reference. Use when asked about {topics}.
---

# {Library} Documentation

{One paragraph description}

## Navigation Guide

**Getting Started:** `references/getting-started/` - Start here for installation and basics

**Core Concepts:** `references/{concepts-dir}/` - Fundamental concepts and architecture

**API Reference:** `references/{api-dir}/` - Complete API documentation

**Guides:** `references/{guides-dir}/` - How-to guides for common tasks

{Add more sections as appropriate for the library}

## Key Entry Points

| Task | Start Here |
|------|------------|
| New to {Library} | `references/getting-started/index.md` |
| API lookup | `references/{api-dir}/index.md` |
| Common patterns | `references/{guides-dir}/index.md` |
| {Specific task} | `references/{path}` |

## When to use

Use this skill when the user asks about:
- {topic 1}
- {topic 2}
- ...

## How to find information

1. Use the Navigation Guide above to identify the relevant section
2. Start with the Key Entry Points for common tasks
3. Explore the directory structure within each section
4. For specific APIs, check the API Reference section
```

**Example (nextjs-canary-docs Tier 3):**
```yaml
---
name: nextjs-canary-docs
description: Local Next.js documentation reference (canary branch). Use when asked about Next.js features, App Router, Server Components, routing, data fetching, rendering, caching, styling, optimizations, configuration, or Next.js APIs.
---

# Next.js Documentation

Next.js is a React framework for building full-stack web applications with server-side rendering, static generation, and modern React features.

## Navigation Guide

**Getting Started:** `references/01-getting-started/` - Installation, project structure, first app

**App Router:** `references/02-app/` - App Router architecture, routing, layouts

**Pages Router:** `references/03-pages/` - Legacy Pages Router documentation

**API Reference:** `references/04-api-reference/` - Complete API documentation for components, functions, and config

**Architecture:** `references/05-architecture/` - How Next.js works under the hood

## Key Entry Points

| Task | Start Here |
|------|------------|
| New to Next.js | `references/01-getting-started/01-installation.mdx` |
| App Router routing | `references/02-app/01-building-your-application/01-routing/` |
| Data fetching | `references/02-app/01-building-your-application/02-data-fetching/` |
| Server Components | `references/02-app/01-building-your-application/03-rendering/` |
| API routes | `references/02-app/01-building-your-application/01-routing/12-route-handlers.mdx` |
| Configuration | `references/04-api-reference/05-config/` |

## When to use

Use this skill when the user asks about:
- Next.js App Router or routing
- Server Components and Client Components
- Data fetching in Next.js
- Static and dynamic rendering
- Middleware and API routes
- Next.js configuration (next.config.js)
- Image, Font, Link, Script components

## How to find information

1. Use the Navigation Guide above to identify the relevant section
2. Start with the Key Entry Points for common tasks
3. Explore the directory structure within each section
4. For specific APIs, check `references/04-api-reference/`
```

### Step 6: Report results

Summarize:
- Which skills were generated/updated
- Which agents were updated
- Disk space used by shared docs

**Recommend next step**: Tell the user to run `/install-agent-skills` (or `/install-agent-skills {skill-name}`) to deploy.

## Important

- Do NOT create `references/` folders - the install script creates symlinks at install time.
- The shared docs are stored once, reducing repo size significantly.
