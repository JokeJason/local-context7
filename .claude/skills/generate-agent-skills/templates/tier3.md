# Tier 3 Template (Large docs: > 100 files OR > 2MB)

List only top-level directories. Read only key entry point files for summaries.

**Important:** For tier 3, also generate `STRUCTURE.md` in `dotfiles/shared/{skill-name}/` (see SKILL.md Step 3.5).

```yaml
---
name: {skill-name}
description: Local {Library} documentation reference. Use when asked about {topics}.
---

# {Library} Documentation

{One paragraph description}

## Quick Reference

| Topic | Entry Point |
|-------|-------------|
| Getting started | `references/{path}` |
| API reference | `references/{path}` |
| {Common task} | `references/{path}` |

## When to use

Use this skill when the user asks about:
- {topic 1}
- {topic 2}

## How to find information

1. **First**, read `references/STRUCTURE.md` to see all available documentation files
2. Identify the relevant section/files based on the user's question
3. Read specific files for detailed information

**STRUCTURE.md contains a complete file listing organized by directory - always check it first before searching.**
```
