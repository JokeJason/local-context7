# Tier 1 Template (Small docs: < 30 files AND < 500KB)

Read ALL markdown files and extract frontmatter `title` and `description` fields.

```yaml
---
name: {skill-name}
description: Local {Library} documentation reference. Use when asked about {topics from content}.
---

# {Library} Documentation

{One paragraph description from overview/intro file}

## Quick Reference

| File | Title | Description |
|------|-------|-------------|
| `file1.mdx` | {title} | {description} |
| `file2.mdx` | {title} | {description} |
{... ALL files ...}

## When to use

Use this skill when the user asks about:
- {topic from files}
- {topic 2}

## How to find information

1. Check the Quick Reference table above
2. Read from `references/{filename}`
```
