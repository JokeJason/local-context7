# Tier 3 Template (Large docs: > 100 files OR > 2MB)

List only top-level directories. Read only key entry point files for summaries.

```yaml
---
name: {skill-name}
description: Local {Library} documentation reference. Use when asked about {topics}.
---

# {Library} Documentation

{One paragraph description}

## Navigation Guide

**{Section 1}:** `references/{dir1}/` - {summary} ({N} files)

**{Section 2}:** `references/{dir2}/` - {summary} ({N} files)

**{Section 3}:** `references/{dir3}/` - {summary} ({N} files)

## Key Entry Points

| Task | Start Here |
|------|------------|
| Getting started | `references/{path}` |
| API reference | `references/{path}` |
| {Common task} | `references/{path}` |

## When to use

Use this skill when the user asks about:
- {topic 1}
- {topic 2}

## How to find information

1. Use Navigation Guide to find the section
2. Check Key Entry Points for common tasks
3. Explore the directory structure
```
