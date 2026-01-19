# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

**local-context7** builds local documentation reference material for AI coding agents. It downloads official documentation, filters it with AI assistance, and generates skills that make the docs available as context during development.

Think of it as a local alternative to Context7's cloud-based documentation lookup.

## Directory Structure

```
.claude/            # Working Claude Code config for this repo
├── skills/         # Skills for building and managing docs
│   ├── build-my-context7/      # Main entry point
│   ├── download-docs/          # Downloads from manifests
│   ├── filter-docs/            # AI-assisted filtering
│   ├── generate-agent-skills/  # Creates agent skills
│   └── install-agent-skills/   # Deploys to system
└── agents/         # Sub-agents (manifest-processor)

dotfiles/           # Generated skills (deployed to system)
├── shared/         # Shared docs (stored once, not duplicated)
├── claude/skills/  # SKILL.md only → ~/.claude/skills/
├── codex/skills/   # SKILL.md only → ~/.codex/skills/
└── opencode/skills/# SKILL.md only → ~/.config/opencode/skills/

output/             # Intermediate downloaded/filtered docs
```

**Note:** Each agent's skill directory contains only `SKILL.md`. The `references/` folder is created at install time as a symlink to `dotfiles/shared/<skill>/`.

## Workflow

**Process all documentation:**
1. `/build-my-context7` - Downloads and filters all manifests
2. `/generate-agent-skills` - Creates all SKILL.md files
3. `/install-agent-skills` - Installs all skills

**Process a single library (more efficient):**
1. `/build-my-context7 <name>` - Download only specified manifest
2. `/generate-agent-skills <name>` - Generate only specified skill
3. `/install-agent-skills <name>` - Install only specified skill

Example: `/build-my-context7 zod-docs` → `/generate-agent-skills zod-docs` → `/install-agent-skills zod-docs`

## Adding New Documentation

Create a manifest in `.claude/skills/download-docs/scripts/manifests/`:

**GitHub source** (for repos with docs):
```json
{
  "_source": {
    "type": "github",
    "repo": "owner/repo",
    "path": "docs"
  }
}
```

**URL source** (for individual files):
```json
{
  "category": {
    "doc-name": "https://example.com/doc.md"
  }
}
```

Then run: `/build-my-context7 <manifest-name>` → `/generate-agent-skills <manifest-name>` → `/install-agent-skills <manifest-name>`

## Keeping README Updated

**After creating or updating a doc skill, always update README.md:**

1. Update the "Included Documentation" table with correct file counts
2. Add new skills or remove deleted ones
3. Verify source links are accurate

Run this to get current file counts:
```bash
for dir in dotfiles/shared/*/; do name=$(basename "$dir"); count=$(find "$dir" -name "*.md" -o -name "*.mdx" | wc -l); echo "$name: $count"; done
```
