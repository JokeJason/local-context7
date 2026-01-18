# Tier 2 Template (Medium docs: 30-100 files OR 500KB-2MB)

List directory structure with file counts. Read only index/overview files for summaries.

```yaml
---
name: {skill-name}
description: Local {Library} documentation reference. Use when asked about {topics}.
---

# {Library} Documentation

{One paragraph description from overview}

## Documentation Structure

```
references/
├── {dir1}/       # {summary} ({N} files)
├── {dir2}/       # {summary} ({N} files)
└── {file}.mdx    # {summary}
```

## Topic Guide

| Topic | Key Files |
|-------|-----------|
| {Topic 1} | `file1.mdx`, `file2.mdx` |
| {Topic 2} | `dir/file.mdx` |

## When to use

Use this skill when the user asks about:
- {topic 1}
- {topic 2}

## How to find information

1. Use Topic Guide to find relevant files
2. Read from `references/{path}`
```
