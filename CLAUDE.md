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
├── claude/skills/  # → ~/.claude/skills/
├── codex/skills/   # → ~/.codex/skills/
└── opencode/skills/# → ~/.config/opencode/skills/

output/             # Intermediate downloaded/filtered docs
```

## Workflow

1. `/build-my-context7` - Downloads and filters documentation from manifests
2. `/generate-agent-skills` - Creates skills from filtered docs for each agent
3. `/install-agent-skills` - Symlinks generated skills to system locations

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

Then run the workflow: `/build-my-context7` → `/generate-agent-skills` → `/install-agent-skills`
